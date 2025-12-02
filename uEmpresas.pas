
unit uEmpresas;

interface
Uses System.SysUtils,System.Classes,Data.DB, Data.SqlExpr, math,Datasnap.DSSession,MSHTML,ActiveX,FMX.Graphics,
 Soap.EncdDecd,System.JSON,ACBrMail,Winapi.Windows, uFreteJSON,IdHTTP,System.Hash;

type
  TEmpresas = class
  private
    { private declarations }

  protected
    { protected declarations }
  public
    { public declarations }
    function GetSql():String;
    function Login(oBody:TJSONObject;Params:TStrings):String;
    function RecuperarSenha(oBody:TJSONObject;Params:TStrings):String;
    function ValidaTokenRecuperarSenha(oBody:TJSONObject;Params:TStrings):String;
    function AlterarSenha(oBody:TJSONObject;Params:TStrings):String;
    function Cadastrar(oReq:TJSONObject;Params:TStrings):String;
    function BuscaDadosCNPJ(Query: TStrings): STring;
    function ValidaCodigo(Query:TStrings):String;
    function Perfil(oReq:TJSONObject;qUSU:TSQLQuery;cDB:TSQLConnection):String;
    function BuscaPlano(qUSU:TSQLQuery):String;

    function GerarEmailRecuperarSenha(oBody:TJSONObject):String;
    function GerarEmailVerificacao(cCod:String):String;

    procedure GeraBase(cCnpj:String;cDB:TSQLConnection);
    procedure ConfiguraBase(oReq:TJSONObject);
    procedure CriaPastasCliente(cCnpj:String);
    procedure ConfiguraConexaoBaseNova(cCnpjPar:String;cDB:TSQLConnection);
    procedure EnviaCodigo(oReq:TJSONObject;qREG:TSQLQuery);





  published

  end;

  var sql : String;
implementation

{ TEmpresas }

uses uWMSite, uReceitaWs, uFrm, uEmpresasJSON;
function TEmpresas.Login(oBody: TJSONObject; Params: TStrings): String;
var
   cCod   : String;
   cSen   : String;
   cToken : String;
   qREG   : TSQLQuery;
   qAUX   : TSQLQuery;
   cDB    : TSQLConnection;
   cDBSYS : TSQLConnection;
begin
   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Params.Values['db'],cDB);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;
   try
      cSen := GetValueJSONObject('senha',oBody);

      qAUX.Close;
      qAUX.SQL.Text := 'SELECT U.*,E.CNPJ '+
      'FROM USUARIOS U '+
      'LEFT JOIN EMPRESA E ON E.CODIGO=1 '+
      'WHERE U.LOGIN='+QuotedStr(GetValueJSONObject('login',oBody));
      sql := qAUX.SQL.Text;
      qAUX.Open;

      if qAUX.Eof then
         Result := '{"erro":99,"mensagem":"Usuário não encontrado"}'
      else if(qAUX.FieldByName('ENCRIPTADA').AsString = 'S') and (qAUX.FieldByName('SENHA').AsString <> Encrip(GetValueJSONObject('senha',oBody)))then
         Result := '{"erro":99,"mensagem":"Usuário não encontrado"}'
      else if(qAUX.FieldByName('ENCRIPTADA').AsString = 'N') and (qAUX.FieldByName('SENHA').AsString <> GetValueJSONObject('senha',oBody))then
         Result := '{"erro":99,"mensagem":"Usuário não encontrado"}'
      else if(qAUX.FieldByName('ATIVO').AsString = 'N')then
         Result := '{"erro":99,"mensagem":"Usuário inativo"}'
      else begin
         cCod   := qAUX.FieldByName('CODIGO').AsString;
         cToken := GetRandomPassword(qREG,32,'');

         qREG.Close;
         qREG.SQL.Text := 'UPDATE USUARIOS SET '+
         'SENHA='+QuotedStr(Encrip(GetValueJSONObject('senha',oBody)))+','+
         'ENCRIPTADA='+QuotedStr('S')+','+
         'TOKEN='+QuotedStr(cToken)+' '+
         'WHERE CODIGO=0'+cCod;
         sql := qREG.SQL.Text;
         qREG.ExecSQL(false);

         Result := '{'+
         '"erro":0,'+
         '"mensagem":"Usuário autenticado com sucesso",'+
         '"token":"'+cToken+'",'+
         '"codigo":"'+cCod+'",'+
         '"nome":"'+qAUX.FieldByName('NOME').AsString+'",'+
         '"cnpj":"'+qAUX.FieldByName('CNPJ').AsString+'",'+
         '"db":"'+Params.Values['db']+'",'+
         '"perfil":"'+qAUX.FieldByName('PERFIL').AsString+'",'+
         '"perfil_adicional":"'+qAUX.FieldByName('PERFIL1').AsString+'"'+
         '}';
      end;
   finally
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(cDB);
   end;
end;

function TEmpresas.ValidaCodigo(Query: TStrings): String;
var
   cRes,cToken : String;
   qREG : TSQLQuery;
   qAUX : TSQLQuery;
   cDBSYS  : TSQLConnection;
   cDB     : TSQLConnection;
begin
   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   cDBSYS := TSQLConnection.Create(nil);
   cDB    := TSQLConnection.Create(nil);

   ConfConexao(cDBSYS);

   qREG.SQLConnection := cDBSYS;
   qAUX.SQLConnection := cDBSYS;
   try
      try
         qREG.Close;
         qREG.SQL.Text := 'SELECT * '+
         'FROM EMPRESAS '+
         'WHERE CNPJ='+QuotedStr(SoNumero(Query.Values['cnpj']))+' AND '+
         'CODIGO_VERIFICACAO='+Query.Values['code'];
         sql := qREG.SQL.Text;
         qREG.Open;

         if (qREG.Eof) then begin
            cRes := '{"erro":1,"mensagem":"Este CNPJ não existe na nossa base de dados ou o código é inválido"}';
            exit;
         end;

         if not(qREG.FieldByName('DATA_VERIFICACAO').IsNull) then begin
            cRes := '{"erro":1,"mensagem":"Essa conta já foi validada!"}';
            exit;
         end;

         qAUX.Close;
         qAUX.SQL.Clear;
         qAUX.SQl.Add('UPDATE EMPRESAS SET DATA_VERIFICACAO=CURRENT_TIMESTAMP,SITUACAO=''A'' ');
         qAUX.SQl.Add('WHERE CODIGO=0'+qREG.FieldByName('CODIGO').AsString);
         sql := qAUX.SQL.Text;
         qAUX.ExecSQL(False);

         // conecta na base do cliente
         ConfiguraConexao(SoNumero(qREG.FieldByName('CNPJ').AsString), cDB);
         qAUX.SQLConnection := cDB;

         cToken := GetRandomPasswordSite(32);

         qAUX.Close;
         qAUX.SQL.Clear;
         qAUX.SQl.Add('UPDATE USUARIOS SET TOKEN='+QuotedStr(cToken));
         qAUX.SQl.Add('WHERE LOGIN='+QuotedStr(Query.Values['login']));
         qAUX.SQl.Add('RETURNING CODIGO,NOME');
         sql := qAUX.SQL.Text;
         qAUX.Open;

         cRes := '{'+
         '"mensagem":"Usuário autenticado com sucesso",'+
         '"token":"'+cToken+'",'+
         '"codigo":"'+qAUX.FieldByName('CODIGO').AsString+'",'+
         '"nome":"'+qAUX.FieldByName('NOME').AsString+'",'+
         '"cnpj":"'+FormataCPFCNPJ(Query.Values['cnpj'])+'",'+
         '"db":"'+soNumero(Query.Values['cnpj'])+'"'+
         '}';
      except on E: Exception do begin
         cRes := '{"erro":1,"mensagem":"Ocorreu algum erro, tente novamente mais tarde"}';
         GravaLog('Erro no cadastar #Erro:'+e.Message+' sql:'+sql);
      end;
      end;
   finally
      FreeAndNil(qREG);
      FreeAndNil(qAUX);
      FreeAndNil(cDB);
      FreeAndNil(cDBSYS);

      Result := cRes;
   end;
end;


{ TEmpresas }


function TEmpresas.BuscaDadosCNPJ(Query: TStrings): STring;
var
   TRec : TRecWs;
begin
  TRec := TRecWs.Create;
  try
     Result := TRec.BuscaReceitaWs(SoNumero(Query.Values['cnpj']));

     if(Copy(Result,1,2)='NO')then
        Result := '{}'
     else begin
        Result := '{'+
        '"nome":"'+TRec.tDados.FieldByName('NOME').AsString+'",'+
        '"fantasia":"'+TRec.tDados.FieldByName('FANTASIA').AsString+'",'+
        '"email":"'+TRec.tDados.FieldByName('EMAIL').AsString+'",'+
        '"cep":"'+TRec.tDados.FieldByName('CEP').AsString+'",'+
        '"endereco":"'+TRec.tDados.FieldByName('LOGRADOURO').AsString+'",'+
        '"numero":"'+TRec.tDados.FieldByName('NUMERO').AsString+'",'+
        '"bairro":"'+TRec.tDados.FieldByName('BAIRRO').AsString+'",'+
        '"cidade":"'+TRec.tDados.FieldByName('MUNICIPIO').AsString+'",'+
        '"uf":"'+TRec.tDados.FieldByName('UF').AsString+'"'+
        '}';
     end;
  finally
     FreeAndNil(TRec);
  end;
end;


function TEmpresas.Cadastrar(oReq: TJSONObject; Params: TStrings): String;
var
   cRes,cReq : String;
   cCnpj,cNome,cEmail,cCel : String;
   cUsuario,cSenha,cCode   : String;
   cToken,cBase,cPlataforma: String;
   qREG : TSQLQuery;
   cDB  : TSQLConnection;
begin
   qREG := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(nil);

   ConfConexao(cDB);

   qREG.SQLConnection := cDB;
   try
      try
         cCnpj := GetValueJSONObject('cnpj',oReq);
         cNome := GetValueJSONObject('nome',oReq);
         cCel  := GetValueJSONObject('celular',oReq);
         cEmail:= GetValueJSONObject('email',oReq);
         cUsuario := GetValueJSONObject('usuario',oReq);
         cSenha   := GetValueJSONObject('senha',oReq);
         cPlataforma := GetValueJSONObject('plataforma',oReq);

         qREG.Close;
         qREG.SQL.Text := 'SELECT CNPJ FROM EMPRESAS WHERE CNPJ='+QuotedStr(SoNumero(cCnpj));
         sql := qREG.SQL.Text;
         qREG.Open;

         if not(qREG.Eof) then begin
            cRes := '{"erro":1,"mensagem":"Este CNPJ já está sendo utilizado"}';
            exit;
         end;

         if not ValidaCPFCNPJ(cCnpj) then begin
            cRes := '{"erro":1,"mensagem":"Este CNPJ não é válido!"}';
            exit;
         end;

         if (cUsuario = 'ADMINISTRADOR') or (cUsuario = 'SYSDBA') then begin
            cRes := '{"erro":1,"mensagem":"Este nome de usuário é restrito"}';
            exit;
         end;

         qREG.Close;
         qREG.SQL.Text := 'SELECT EMAIL FROM EMPRESAS WHERE EMAIL='+QuotedStr(cEmail);
         sql := qREG.SQL.Text;
         qREG.Open;

         if not(qREG.Eof) then begin
            cRes := '{"erro":1,"mensagem":"Este email já está sendo utilizado"}';
            exit;
         end;

         cBase  := '127.0.0.1:'+ExtractFileDir(ParamStr(0))+'\bases\'+soNumero(cCnpj)+'.fdb';
         cCode  := GeraNumRand(5);

         oReq.AddPair('code',  cCode);

         GeraBase(cCnpj,cDB);
         ConfiguraBase(oReq);
         EnviaCodigo(oReq,qREG);

         qREG.Close;
         qREG.SQL.Clear;
         qREG.SQl.Add('INSERT INTO EMPRESAS(CODIGO,NOME,CNPJ,BANCO,USUARIO,SENHA,SITUACAO,EMAIL,CODIGO_VERIFICACAO,CELULAR,DATA,PLATAFORMA_CADASTRO,PLANO)');
         qREG.SQl.Add('VALUES((SELECT COALESCE(MAX(CODIGO),0)+1 FROM EMPRESAS),'+QuotedCopy(cNome,300)+','+QuotedStr(soNumero(cCnpj))+',');
         qREG.SQl.Add(QuotedStr(cBase)+','+QuotedStr('SYSDBA')+','+QuotedStr('hsrsuper')+','+QuotedStr('P')+','+QuotedCopy(cEmail,100)+','+cCode+',');
         qREG.SQl.Add(QuotedCopy(cCel,15)+',');
         qREG.SQL.Add(QuotedStr(FormatDateTime('dd.mm.yyyy hh:MM:ss',Now))+','+QuotedStr(UpperCase(cPlataforma)));
         qREG.SQL.Add(',1)RETURNING CODIGO');
         sql := qREG.SQL.Text;
         qREG.SQL.SaveToFile('insertEmpresa.txt');
         qREG.Open;

         cRes := '{"erro":0,"mensagem":"Cadastrado com sucesso"}';
      except on E: Exception do begin
         cRes := '{"erro":1,"mensagem":"Ocorreu algum erro, tente novamente mais tarde"}';
         GravaLog('Erro no cadastar #Erro:'+e.Message+' sql:'+sql);
      end;
      end;
   finally
      FreeAndNil(qREG);
      FreeAndNil(cDB);

      Result := cRes;
   end;
end;




function TEmpresas.GetSql: String;
begin
   result := sql;
end;

procedure TEmpresas.GeraBase(cCnpj: String; cDB: TSQLConnection);
var
   cBase,cBaseNova : String;
   qREG : TSQLQuery;
begin
   qREG := TSQlQuery.Create(Nil);
   qREG.SQLConnection := cDB;
   try
      if(not DirectoryExists('.\bases'))then
         ForceDirectories('.\bases');

      cBase := '.\bases\base_limpa.fdb';
      cBaseNova := '.\bases\'+soNumero(cCnpj)+'.fdb';

      CopyFile(PChar(cBase),PChar(cBaseNova),true);
   finally
      FreeAndNil(qREG);
   end;
end;

procedure TEmpresas.ConfiguraBase(oReq:TJSONObject);
var
  cCnpj,cNome,cEmail,cCel,cUsuario,cSenha: String;
  cMenu,cToken : String;
  cCodCrm,cJsonCrm, cJsonResp : String;
  cPlataforma : String;
  cCodUsuario : String;

  jsonSend : TStringStream;
  oResp : TJSONObject;
  qREG  : TSQLQuery;
  cDB   : TSQLConnection;
  TD    : TTransactionDesc;
  oHttp : TIDHTTP;
begin
   cDB  := TSQLConnection.Create(Nil);
   qREG := TSQLQuery.Create(Nil);

   cCnpj := GetValueJSONObject('cnpj',oReq);

   ConfiguraConexaoBaseNova(cCnpj,cDB);

   qREG.SQLConnection := cDB;

   oHttp := TIdHTTP.Create(Nil);

   TD.TransactionID   := TDSSessionManager.GetThreadSession.Id;
   TD.IsolationLevel  := xilREADCOMMITTED;
   cDB.StartTransaction(TD);
   try
      try
         cNome := UpperCase(GetValueJSONObject('nome',oReq));
         cCel  := GetValueJSONObject('celular',oReq);
         cEmail:= GetValueJSONObject('email',oReq);
         cUsuario := GetValueJSONObject('usuario',oReq);
         cSenha   := Encrip(GetValueJSONObject('senha',oReq));
         cMenu := 'SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS';
         cPlataforma := GetValueJSONObject('plataforma',oReq);

         cCodUsuario := '(SELECT COALESCE(MAX(CODIGO),0)+1 FROM USUARIOS)';
         qREG.Close;
         qREG.SQL.Text := 'SELECT CODIGO FROM USUARIOS WHERE LOGIN='+QuotedStr(cUsuario);
         sql := qREG.SQL.Text;
         qREG.Open;

         if not(qREG.Eof) then
            cCodUsuario := qREG.FieldByName('CODIGO').AsString;

         qREG.Close;
         qREG.SQL.Clear;
         qREG.SQL.Add('UPDATE OR INSERT INTO USUARIOS (');
         qREG.SQL.Add('CODIGO, NOME, LOGIN, SENHA, ENCRIPTADA, MENU, ');
         qREG.SQL.Add('EMAIL, PERFIL, PERFIL1, LOGADO, ATIVO) VALUES (');
         qREG.SQL.Add(cCodUsuario+','+QuotedCopy(cNome,60)+','+QuotedCopy(cUsuario,20)+',');
         qREG.SQL.Add(QuotedCopy(cSenha,20)+','+QuotedStr('S')+','+QuotedStr(cMenu)+',');
         qREG.SQL.Add(QuotedCopy(cEmail,50)+','+QuotedStr('ADMINISTRADOR')+','+QuotedStr('CONTADOR')+','+QuotedStr('S')+',');
         qREG.SQL.Add(QuotedStr('S')+')');
         sql := qREG.SQL.Text;
         qREG.ExecSQL(False);

         cCodCrm  := '0';
         cJsonCrm := '';

         if (sAtualizaCRM = 'S') and not(FileExists('AmbienteTeste.txt'))then begin
            oHTTP.Request.ContentType := 'application/json';
            try
               try
                  cJsonCrm := '{'+
                  '"cnpj": "'+cCnpj+'",'+
                  '"nome": "'+Copy(UpperCase(cNome),1,60)+'",'+
                  '"email": "'+cEmail+'",'+
                  '"celular": "'+cCel+'",'+
                  '"plataforma":"'+cPlataforma+'"'+
                  '}';

                  jsonSend := TStringStream.Create(cJsonCrm);

                  cJsonResp := oHttp.Post(frmPrin.cUrlCRM+'/api/clientes/cadastrar?chave=3791000733296071248',jsonSend);

                  oResp := TJSONObject.ParseJSONValue(cJsonResp) as TJSONObject;

                  if(GetValueJSONObject('erro',oResp) = '0')then
                     cCodCrm := GetValueJSONObject('codigo',oResp);
               except
                on E: EIdHTTPProtocolException do
                  GravaLog('Erro de protocolo ao enviar cliente CRM:'+e.Message);
                on E: Exception do
                  GravaLog('Erro normal ao enviar cliente CRM:'+e.Message);
               end;
            finally
               jsonSend.Free;
            end;
         end;

         qREG.Close;
         qREG.SQL.Clear;
         qREG.SQL.Add('UPDATE OR INSERT INTO EMPRESA (');
         qREG.SQL.Add('CODIGO, ATIVO, NOME, FANTASIA, CNPJ, ');
         qREG.SQL.Add('EMAIL, REGISTRODATA, REGISTROCODIGO,');
         qREG.SQL.Add('PERPIS, COFINS, SESTSENAT, RNTRC,TPTRANSP,CODIGO_CRM)');
         qREG.SQL.Add('VALUES (1,''S'','+QuotedCopy(cNome,60)+','+QuotedCopy(cNome,60)+','+QuotedStr(cCnpj)+',');
         qREG.SQL.Add(QuotedStr(cEmail)+',CURRENT_DATE,0,');
         qREG.SQL.Add('1.65, 7.6,0.00,0,0,'+cCodCrm+')');
         sql := qREG.SQL.Text;
         qREG.ExecSQL(false);

         qREG.Close;
         qREG.SQL.Clear;
         qREG.SQL.Add('INSERT INTO PARAMETROS(EMPRESA,USUARIOS,AMBIENTE,FORMAEMISSAO,TIPODACTE)');
         qREG.SQL.Add('VALUES (1,1,1,''0'',''0'')');
         sql := qREG.SQL.Text;
         qREG.ExecSQL(false);

         CriaPastasCliente(SoNumero(cCnpj));

         cDB.Commit(TD);
         Commita(qREG);
      except on E: Exception do begin
         if(cDB.InTransaction)then
            cDB.Rollback(TD);         

         raise Exception.Create(e.Message);
      end;
      end;
   finally
      FreeAndNil(oHttp);
      FreeAndNil(qREG);
      FreeAndNil(cDB);
   end;

end;

procedure TEmpresas.ConfiguraConexaoBaseNova(cCnpjPar: String;
  cDB: TSQLConnection);
var
   cBase : String;
begin
   cCnpjPar := soNumero(cCnpjPar);
   cBase    := '127.0.0.1:'+ExtractFileDir(ParamStr(0))+'\bases\'+cCnpjPar+'.fdb';

   cDB.LoadParamsOnConnect := false;
   cDB.ConnectionName      := 'FBConnection';
   cDB.DriverName          := 'Firebird';
   cDB.LibraryName         := 'dbxfb.dll';
   cDB.VendorLib           := 'fbclient.dll';
   cDB.Params.Values['Database']  := cBase;
   cDB.Params.Values['User_Name'] := 'SYSDBA';
   cDB.Params.Values['Password']  := 'hsrsuper';
   cDB.Params.Values['IsolationLevel'] := 'ReadCommited';
   cDB.LoginPrompt := False;
end;

procedure TEmpresas.CriaPastasCliente(cCnpj: String);
begin
   if(not DirectoryExists('.\clientes\CTe\'+cCnpj)) then
      ForceDirectories('.\clientes\CTe\'+cCnpj);
   if(not DirectoryExists('.\clientes\CTe\'+cCnpj+'\PDFs\')) then
      ForceDirectories('.\clientes\CTe\'+cCnpj+'\PDFs\');
   if(not DirectoryExists('.\clientes\MDFe\'+cCnpj)) then
      ForceDirectories('.\clientes\MDFe\'+cCnpj);
end;

procedure TEmpresas.EnviaCodigo(oReq: TJSONObject;qREG:TSQLQuery);
var
  cFile:String;
  ACBRMail : TACBrMail;
begin
   ACBRMail := TACBRMail.Create(Nil);
   try
      qREG.Close;
      qREG.SQL.Text:='SELECT FIRST 1 SMTP,PORTA,CONTA,SENHA FROM PARAMETROS ORDER BY CODIGO';
      qREG.open;


      ACBrMail.Clear;
      ACBrMail.Host := qREG.FieldByName('SMTP').AsString;
      ACBrMail.Port := qREG.FieldByName('PORTA').AsString;

      ACBrMail.Username := qREG.FieldByName('CONTA').AsString;
      ACBrMail.Password := qREG.FieldByName('SENHA').AsString;

      cFile:='AmbienteTeste.txt';
      if(FileExists(cFile))then begin
         ACBRMail.Username := 'gabrielbangarclprates@gmail.com';
         ACBRMail.Password := 'gvlglezfocsmeyvm';
      end;

      ACBRMail.SetSSL   := True;
      ACBrMail.SetTLS   := true;
      ACBrMail.UseThread:= False;
      ACBrMail.FromName := 'Equipe Sigetran';
//      ACBrMail.From     := 'Equipe Sigetran';
      ACBrMail.Subject  := 'Código de verificação de email:'+GetValueJSONObject('code',oReq);
      ACBrMail.ClearAttachments;
      ACBrMail.IsHTML := True;
      ACBrMail.AltBody.Clear;
      ACBrMail.Body.Add(GerarEmailVerificacao(GetValueJSONObject('code',oReq)));
      ACBrMail.AddAddress(GetValueJSONObject('email',oReq));
      ACBrMail.UseThread := False;
      ACBrMail.Send();
   finally
      FreeAndNil(ACBrMail);
   end;
end;


function TEmpresas.Perfil(oReq: TJSONObject; qUSU: TSQLQuery;
  cDB: TSQLConnection): String;
var
   cCod  : String;
   cAux  : String;
   cData : String;
   sqlCampo  : String;
   sqlValor  : String;
   cUsuAlt   : String;
   cJsonCrm  : String;
   cJsonResp : String;
   cCodCrm   : String;

   oResp : TJSONObject;
   oCrm  : TJSONObject;

   qAUX  : TSQLQuery;
   qREG  : TSQLQuery;
   TD    : TTransactionDesc;
   oEmp  : TPerfilJSON;
   oHttp : TIDHttp;
   jsonSend : TStringStream;
begin
   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;

   TD.TransactionID   := TDSSessionManager.GetThreadSession.Id;
   TD.IsolationLevel  := xilREADCOMMITTED;
   cDB.StartTransaction(TD);

   oEmp   := TPerfilJSON.Create;
   oHttp  := TIdHTTP.Create(Nil);
   oCrm   := TJSONObject.Create;

   try
      try
         oEmp.AsJson := oReq.ToString;

         qREG.Close;
         qREG.SQL.Clear;
         qREG.SQL.Add('UPDATE EMPRESA SET');
         qREG.SQL.Add('FANTASIA='+QuotedSan(Copy(oEmp.Nome,1,80))+',');
         qREG.SQL.Add('NOME='+QuotedSan(Copy(oEmp.Razao,1,60))+',');
         qREG.SQL.Add('ENDERECO='+QuotedSan(Copy(oEmp.Endereco,1,50))+',');
         qREG.SQL.Add('MUNICIPIO=0'+soNumero(oEmp.CodigoMunicipio)+',');
         qREG.SQL.Add('NUMERO=0'+soNumero(oEmp.Numero)+',');
         qREG.SQL.Add('COMPLEMENTO='+QuotedSan(Copy(oEmp.Complemento,1,30))+',');
         qREG.SQL.Add('BAIRRO='+QuotedSan(Copy(oEmp.Bairro,1,30))+',');
         qREG.SQL.Add('CEP='+QuotedSan(oEmp.Cep)+',');
         qREG.SQL.Add('CIDADE='+QuotedSan(oEmp.Cidade)+',');
         qREG.SQL.Add('ESTADO='+QuotedSan(oEmp.Uf)+',');
         qREG.SQL.Add('CODIBGE=0'+CidadeIBGE(oEmp.Cidade,oEmp.Uf,qAUX)+',');
         qREG.SQL.Add('RNTRC='+QuotedSan(Copy(SoNumero(oEmp.Rntrc),1,10))+',');
         qREG.SQL.Add('IE='+QuotedSan(Copy(oEmp.Ie,1,20))+',');
         qREG.SQL.Add('REGIME='+QuotedSan(Copy(oEmp.Regime,1,1))+',');
         qREG.SQL.Add('TELEFONE='+QuotedSan(Copy(soNumero(oEmp.Telefone),1,14))+',');
         qREG.SQL.Add('EMAIL='+QuotedStr(Copy(oEmp.Email,1,50))+',');
         qREG.SQL.Add('TPTRANSP='+QuotedStr(oEmp.TipoTransportadora));
         qREG.SQL.Add('WHERE CODIGO=1');
         sql := qREG.SQL.Text;
         qREG.ExecSQL(False);

         qREG.Close;
         qREG.SQL.Text := 'SELECT COALESCE(CODIGO_CRM,0) AS CODIGO_CRM,'+
         'COALESCE(ULTIMA_ATUALIZACAO_CRM,CURRENT_TIMESTAMP-61) AS ULT_AT_CRM '+
         'FROM EMPRESA '+
         'WHERE CODIGO=1';
         qREG.Open;

         if(sAtualizaCRM = 'S') and (qREG.FieldByName('ULT_AT_CRM').AsDateTime+60 <= Now)then begin
            try
               try
                  oHTTP.Request.ContentType := 'application/json';

                  oCrm.AddPair('cnpj', oEmp.Cnpj);
                  oCrm.AddPair('codigo', qREG.FieldByName('CODIGO_CRM').AsString);
                  oCrm.AddPair('nome', Copy(UpperCase(Trim(TrataMensagemExcept(oEmp.Nome))), 1, 60));
                  oCrm.AddPair('email', oEmp.Email);
                  oCrm.AddPair('celular', oEmp.Telefone);
                  oCrm.AddPair('endereco', oEmp.Endereco);
                  oCrm.AddPair('numero', soNumero(oEmp.Numero));
                  oCrm.AddPair('bairro', oEmp.Bairro);
                  oCrm.AddPair('cidade', oEmp.Cidade);
                  oCrm.AddPair('uf', oEmp.Uf);
                  oCrm.AddPair('cep', oEmp.Cep);
                  oCrm.AddPair('plataforma', oEmp.Plataforma);

                  GravaLog(cJSonCrm);

                  jsonSend := TStringStream.Create(UTF8Encode(oCrm.ToString));

                  cJsonResp := oHttp.Post(frmPrin.cUrlCRM+'/api/clientes/cadastrar?chave=3791000733296071248',jsonSend);

                  oResp := TJSONObject.ParseJSONValue(cJsonResp) as TJSONObject;

                  if(GetValueJSONObject('erro',oResp) = '0')then begin
                     cCodCrm := GetValueJSONObject('codigo',oResp);

                     qREG.Close;
                     qREG.SQL.Text := 'UPDATE EMPRESA SET '+
                     'CODIGO_CRM=0'+cCodCrm+','+
                     'ULTIMA_ATUALIZACAO_CRM=CURRENT_TIMESTAMP '+
                     'WHERE CODIGO=1';
                     sql := qREG.SQL.Text;
                     qREG.ExecSQL(False)
                  end;
               except
                on E: EIdHTTPProtocolException do
                  GravaLog('Erro de protocolo ao enviar cliente CRM:'+e.Message);
                on E: Exception do
                  GravaLog('Erro normal ao enviar cliente CRM:'+e.Message);
               end;
            finally
               jsonSend.Free;
               oResp.Free;
            end;
         end;

         Result := '{"erro":0,"mensagem":"Perfil atualizado com sucesso!","codigo":"'+cCod+'"}';

         if cDB.InTransaction then
           cDB.Commit(TD);

         Commita(qREG);
      except on E: Exception do begin
         if cDB.InTransaction then
            cDB.Rollback(TD);

         GravaLog('Erro ao gravar perfil #cliente:'+qUSU.FieldByName('CNPJ').ASString+' #erro:'+e.Message+' SQL:'+sql);

         Result := MensagemErroServer();
      end;
      end;
   finally
      oCrm.DisposeOf;
      FreeAndNil(oHttp);
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(oEmp);
   end;
end;

function TEmpresas.RecuperarSenha(oBody: TJSONObject; Params: TStrings): String;
var
   cCod   : String;
   cToken : String;
   cFile  : String;
   qREG   : TSQLQuery;
   qAUX   : TSQLQuery;
   cDB    : TSQLConnection;
   cDBSYS : TSQLConnection;
   ACBRMail : TACBRMail;
begin
   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   cDB     := TSQLConnection.Create(Nil);
   cDBSYS  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Params.Values['db'],cDB);
   ConfConexao(cDBSYS);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;

   ACBRMail := TACBRMail.Create(Nil);
   try

      qAUX.Close;
      qAUX.SQL.Text := 'SELECT FIRST 1 U.*,E.CNPJ '+
      'FROM USUARIOS U '+
      'LEFT JOIN EMPRESA E ON E.CODIGO=1 '+
      'WHERE U.LOGIN='+QuotedStr(GetValueJSONObject('login',oBody));
      sql := qAUX.SQL.Text;
      qAUX.Open;

      if qAUX.Eof then
         Result := '{"erro":0,"mensagem":"Email enviado com sucesso"}'
      else if(qAUX.FieldByName('ATIVO').AsString = 'N')then
         Result := '{"erro":1,"mensagem":"Usuário inativo"}'
      else if(Trim(qAUX.FieldByName('EMAIL').AsString) = '')then
         Result := '{"erro":1,"mensagem":"Usuário não localizado"}'
      else begin

         cToken := Params.Values['db']+GetValueJSONObject('login',oBody);
         cToken := Copy(THashSHA2.GetHashString(cToken, THashSHA2.TSHA2Version.SHA256),1,16);

         qREG.Close;
         qREG.SQL.Text := 'UPDATE USUARIOS SET '+
         'TOKEN_ALTERACAO_SENHA='+QuotedStr(cToken)+' '+
         'WHERE CODIGO=0'+qAUX.FieldByName('CODIGO').AsString;
         sql := qREG.SQL.Text;
         qREG.ExecSQL(False);

         oBody.AddPair('token',Copy(cToken,1,16));
         oBody.AddPair('db',Params.Values['db']);

         qREG.SQLConnection := cDBSYS;

         qREG.Close;
         qREG.SQL.Text:='SELECT FIRST 1 SMTP,PORTA,CONTA,SENHA FROM PARAMETROS ORDER BY CODIGO';
         qREG.open;

         ACBrMail.Clear;
         ACBrMail.Host := qREG.FieldByName('SMTP').AsString;
         ACBrMail.Port := qREG.FieldByName('PORTA').AsString;

         ACBrMail.Username := qREG.FieldByName('CONTA').AsString;
         ACBrMail.Password := qREG.FieldByName('SENHA').AsString;

         if(FileExists('AmbienteTeste.txt'))then begin
            ACBRMail.Username := 'gabrielbangarclprates@gmail.com';
            ACBRMail.Password := 'gvlglezfocsmeyvm';
         end;

         ACBRMail.SetSSL   := True;
         ACBrMail.SetTLS   := true;
         ACBrMail.UseThread:= False;
         ACBrMail.FromName := 'Equipe Sigetran';
         ACBrMail.From     := '';
         ACBrMail.Subject  := 'Recuperação de senha';
         ACBrMail.ClearAttachments;
         ACBrMail.IsHTML := True;
         ACBrMail.AltBody.Clear;
         ACBrMail.Body.Add(GerarEmailRecuperarSenha(oBody));
         if(FileExists('AmbienteTeste.txt'))then
            ACBrMail.AddAddress('gabrielbangarclprates@gmail.com')
         else
            ACBrMail.AddAddress(qAUX.FieldByName('EMAIL').AsString);
         ACBrMail.UseThread := False;
         ACBrMail.Send();


         Result := '{'+
         '"erro":0,'+
         '"mensagem":"Email enviado com sucesso"'+
         '}';
      end;
   finally
      FreeAndNil(ACBRMail);
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(cDB);
      FreeAndNil(cDBSYS);
   end;
end;

function TEmpresas.GerarEmailRecuperarSenha(oBody:TJSONObject): String;
var
   cUrl : String;
begin
   cUrl := 'https://sigetran.com.br';
   if(FileExists('AmbienteTeste.txt'))then
      cUrl := 'http://localhost:3000';

   cUrl := cUrl + '/alterar/senha?cnpj='+GetValueJSONObject('db',oBody)+'&token='+GetValueJSONObject('token',oBody);


   Result :=
   ' <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'+
   ' <html dir="ltr" xmlns="http://www.w3.org/1999/xhtml" xmlns:o="urn:schemas-microsoft-com:office:office" lang="pt">'+
   ' <head>'+
   ' <meta charset="UTF-8">'+
   ' <meta content="width=device-width, initial-scale=1" name="viewport">'+
   ' <meta name="x-apple-disable-message-reformatting">'+
   ' <meta http-equiv="X-UA-Compatible" content="IE=edge">'+
   ' <meta content="telephone=no" name="format-detection">'+
   ' <title>Novo Template 2</title>'+
   ' <!--[if (mso 16)]>'+
   ' <style type="text/css">'+
   ' a {text-decoration: none;}'+
   ' </style>'+
   ' <![endif]--><!--[if gte mso 9]>'+
   ' <style>sup { font-size: 100% !important; }</style>'+
   ' <![endif]--><!--[if gte mso 9]>'+
   ' <xml>'+
   ' <o:OfficeDocumentSettings>'+
   ' <o:AllowPNG></o:AllowPNG>'+
   ' <o:PixelsPerInch>96</o:PixelsPerInch>'+
   ' </o:OfficeDocumentSettings>'+
   ' </xml>'+
   ' <![endif]-->'+
   ' <style type="text/css">'+
   ' #outlook a {'+
   ' padding:0;'+
   ' }'+
   ' .es-button {'+
   ' mso-style-priority:100!important;'+
   ' text-decoration:none!important;'+
   ' }'+
   ' a[x-apple-data-detectors] {'+
   ' color:inherit!important;'+
   ' text-decoration:none!important;'+
   ' font-size:inherit!important;'+
   ' font-family:inherit!important;'+
   ' font-weight:inherit!important;'+
   ' line-height:inherit!important;'+
   ' }'+
   ' .es-desk-hidden {'+
   ' display:none;'+
   ' float:left;'+
   ' overflow:hidden;'+
   ' width:0;'+
   ' max-height:0;'+
   ' line-height:0;'+
   ' mso-hide:all;'+
   ' }';

   Result := Result +

   '@media only screen and (max-width:600px) { '+
   'p, ul li, ol li, a { '+
   'line-height:150%!important '+
   '} '+
   'h1, h2, h3, h1 a, h2 a, h3 a { '+
   'line-height:120%!important '+
   '} '+
   'h1 { '+
   'font-size:36px!important; '+
   'text-align:left '+
   '} '+
   'h2 { '+
   'font-size:26px!important; '+
   'text-align:left '+
   '} '+
   'h3 { '+
   'font-size:20px!important; '+
   'text-align:left '+
   '} '+
   '.es-header-body h1 a, .es-content-body h1 a, .es-footer-body h1 a { '+
   'font-size:36px!important; '+
   'text-align:left '+
   '} '+
   '.es-header-body h2 a, .es-content-body h2 a, .es-footer-body h2 a { '+
   'font-size:26px!important; '+
   'text-align:left '+
   '} '+
   '.es-header-body h3 a, .es-content-body h3 a, .es-footer-body h3 a { '+
   'font-size:20px!important; '+
   'text-align:left '+
   '} '+
   '.es-menu td a { '+
   'font-size:12px!important '+
   '} '+
   '.es-header-body p, .es-header-body ul li, .es-header-body ol li, .es-header-body a { '+
   'font-size:14px!important '+
   '} '+
   '.es-content-body p, .es-content-body ul li, .es-content-body ol li, .es-content-body a { '+
   'font-size:14px!important '+
   '} '+
   '.es-footer-body p, .es-footer-body ul li, .es-footer-body ol li, .es-footer-body a { '+
   'font-size:14px!important '+
   '} '+
   '.es-infoblock p, .es-infoblock ul li, .es-infoblock ol li, .es-infoblock a { '+
   'font-size:12px!important '+
   '} '+
   '*[class="gmail-fix"] { '+
   'display:none!important '+
   '} '+
   '.es-m-txt-c, .es-m-txt-c h1, .es-m-txt-c h2, .es-m-txt-c h3 { '+
   'text-align:center!important '+
   '} '+
   '.es-m-txt-r, .es-m-txt-r h1, .es-m-txt-r h2, .es-m-txt-r h3 { '+
   'text-align:right!important '+
   '} '+
   '.es-m-txt-l, .es-m-txt-l h1, .es-m-txt-l h2, .es-m-txt-l h3 { '+
   'text-align:left!important '+
   '} '+
   '.es-m-txt-r img, .es-m-txt-c img, .es-m-txt-l img { '+
   'display:inline!important '+
   '} '+
   '.es-button-border { '+
   'display:inline-block!important '+
   '} '+
   'a.es-button, button.es-button { '+
   'font-size:20px!important; '+
   'display:inline-block!important '+
   '} '+
   '.es-adaptive table, .es-left, .es-right { '+
   'width:100%!important '+
   '} '+
   '.es-content table, .es-header table, .es-footer table, .es-content, .es-footer, .es-header { '+
   'width:100%!important; '+
   'max-width:600px!important '+
   '} '+
   '.es-adapt-td { '+
   'display:block!important; '+
   'width:100%!important '+
   '} '+
   '.adapt-img { '+
   'width:100%!important; '+
   'height:auto!important '+
   '} '+
   '.es-m-p0 { '+
   'padding:0!important '+
   '} '+
   '.es-m-p0r { '+
   'padding-right:0!important '+
   '} '+
   '.es-m-p0l { '+
   'padding-left:0!important '+
   '} '+
   '.es-m-p0t { '+
   'padding-top:0!important '+
   '} '+
   '.es-m-p0b { '+
   'padding-bottom:0!important '+
   '} '+
   '.es-m-p20b { '+
   'padding-bottom:20px!important '+
   '} '+
   '.es-mobile-hidden, .es-hidden { '+
   'display:none!important '+
   '} '+
   'tr.es-desk-hidden, td.es-desk-hidden, table.es-desk-hidden { '+
   'width:auto!important; '+
   'overflow:visible!important; '+
   'float:none!important; '+
   'max-height:inherit!important; '+
   'line-height:inherit!important '+
   '} '+
   'tr.es-desk-hidden { '+
   'display:table-row!important '+
   '} '+
   'table.es-desk-hidden { '+
   'display:table!important '+
   '} '+
   'td.es-desk-menu-hidden { '+
   'display:table-cell!important '+
   '} '+
   '.es-menu td { '+
   'width:1%!important '+
   '} '+
   'table.es-table-not-adapt, .esd-block-html table { '+
   'width:auto!important '+
   '} '+
   'table.es-social { '+
   'display:inline-block!important '+
   '} '+
   'table.es-social td { '+
   'display:inline-block!important '+
   '} '+
   '.es-m-p5 { '+
   'padding:5px!important '+
   '} '+
   '.es-m-p5t { '+
   'padding-top:5px!important '+
   '} '+
   '.es-m-p5b { '+
   'padding-bottom:5px!important '+
   '} '+
   '.es-m-p5r { '+
   'padding-right:5px!important '+
   '} '+
   '.es-m-p5l { '+
   'padding-left:5px!important '+
   '} '+
   '.es-m-p10 { '+
   'padding:10px!important '+
   '} '+
   '.es-m-p10t { '+
   'padding-top:10px!importantv '+
   '} '+
   '.es-m-p10b { '+
   'padding-bottom:10px!important '+
   '} '+
   '.es-m-p10r { '+
   'padding-right:10px!important '+
   '} '+
   '.es-m-p10l { '+
   'padding-left:10px!important '+
   '} '+
   '.es-m-p15 { '+
   'padding:15px!important '+
   '} '+
   '.es-m-p15t { '+
   'padding-top:15px!important '+
   '} '+
   '.es-m-p15b { '+
   'padding-bottom:15px!important '+
   '} '+
   '.es-m-p15r { '+
   'padding-right:15px!important '+
   '} '+
   '.es-m-p15l { '+
   'padding-left:15px!important '+
   '} '+
   '.es-m-p20 { '+
   'padding:20px!important '+
   '} '+
   '.es-m-p20t { '+
   'padding-top:20px!important '+
   '} '+
   '.es-m-p20r { '+
   'padding-right:20px!important '+
   '} '+
   '.es-m-p20l { '+
   'padding-left:20px!important '+
   '} '+
   '.es-m-p25 { '+
   'padding:25px!important '+
   '} '+
   '.es-m-p25t { '+
   'padding-top:25px!important '+
   '} '+
   '.es-m-p25b { '+
   'padding-bottom:25px!important '+
   '} '+
   '.es-m-p25r { '+
   'padding-right:25px!important '+
   '} '+
   '.es-m-p25l { '+
   'padding-left:25px!important '+
   '} '+
   '.es-m-p30 { '+
   'padding:30px!important '+
   '} '+
   '.es-m-p30t { '+
   'padding-top:30px!important '+
   '} '+
   '.es-m-p30b { '+
   'padding-bottom:30px!important '+
   '} '+
   '.es-m-p30r { '+
   'padding-right:30px!important '+
   '} '+
   '.es-m-p30l { '+
   'padding-left:30px!important '+
   '} '+
   '.e s-m-p35 { '+
   'padding:35px!important; '+
   '} '+

   ' </style>'+
   ' </head>'+
   ' <body style="width:100%;font-family:arial, ''helvetica neue'', helvetica, sans-serif;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;padding:0;Margin:0">'+
   ' <div dir="ltr" class="es-wrapper-color" lang="pt" style="background-color:#FAFAFA">'+
   ' <!--[if gte mso 9]>'+
   ' <v:background xmlns:v="urn:schemas-microsoft-com:vml" fill="t">'+
   ' <v:fill type="tile" color="#fafafa"></v:fill>'+
   ' </v:background>'+
   ' <![endif]-->'+
   ' <table class="es-wrapper" width="100%" cellspacing="0" cellpadding="0" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;'+
   'border-spacing:0px;padding:0;Margin:0;width:100%;height:100%;background-repeat:repeat;background-position:center top;background-color:#FAFAFA">'+
   ' <tr>'+
   ' <td valign="top" style="padding:0;Margin:0">'+
   ' <table cellpadding="0" cellspacing="0" class="es-header" align="center" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;'+
   ' width:100%;background-color:transparent;background-repeat:repeat;background-position:center top">'+
   ' <tr>'+
   ' <td align="center" style="padding:0;Margin:0">'+
   ' <table bgcolor="#ffffff" class="es-header-body" align="center" cellpadding="0" cellspacing="0" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:transparent;width:600px">'+
   ' <tr>'+
   ' <td align="left" style="padding:20px;Margin:0">'+
   ' <table cellpadding="0" cellspacing="0" width="100%" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">'+
   ' <tr>'+
   ' <td class="es-m-p0r" valign="top" align="center" style="padding:0;Margin:0;width:560px">'+
   ' <table cellpadding="0" cellspacing="0" width="100%" role="presentation" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">'+
   ' <tr>'+
   ' <td align="center" style="padding:0;Margin:0;padding-bottom:10px;font-size:0px">'+
   '  <img src="https://sigetran.com.br/logo.png" alt="Logo" '+
   '   style="display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic;font-size:12px" width="80" title="Logo"></td>'+
   ' </tr>'+
   ' </table>'+
   ' </td>'+
   ' </tr>'+
   ' </table>'+
   ' </td>'+
   ' </tr>'+
   ' </table>'+
   ' </td>'+
   ' </tr>'+
   ' </table>'+
   ' <table cellpadding="0" cellspacing="0" class="es-content" align="center" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%">'+
   ' <tr>'+
   ' <td align="center" style="padding:0;Margin:0">'+
   ' <table bgcolor="#ffffff" class="es-content-body" align="center" cellpadding="0" cellspacing="0" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#FFFFFF;width:600px">'+
   ' <tr>'+
   ' <td align="left" style="padding:0;Margin:0;padding-top:15px;padding-left:20px;padding-right:20px">'+
   ' <table cellpadding="0" cellspacing="0" width="100%" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">'+
   ' <tr>'+
   ' <td align="center" valign="top" style="padding:0;Margin:0;width:560px">'+
   ' <table cellpadding="0" cellspacing="0" width="100%" role="presentation" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">'+
   ' <tr>'+
   ' <td align="center" style="padding:0;Margin:0;padding-top:10px;padding-bottom:10px;font-size:0px"><img src="https://ksmjvq.stripocdn.email/content/guids/CABINET_91d375bbb7ce4a7f7b848a611a0368a7/images/69901618385469411.png" alt '+
   'style="display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic" width="100"></td>'+
   ' </tr>'+
   ' <tr>'+
   ' <td align="center" class="es-m-p0r es-m-p0l es-m-txt-c" style="Margin:0;padding-top:15px;padding-bottom:15px;padding-left:40px;padding-right:40px">'+
   ' <h1 style="Margin:0;line-height:55px;mso-line-height-rule:exactly;font-family:arial, ''helvetica neue'', helvetica, sans-serif;font-size:46px;font-style:normal;font-weight:bold;color:#333333"><span style="font-size:36px">'+
   ' Redefinição de senha</span>&nbsp;</h1>'+
   ' </td>'+
   ' </tr>'+
   ' <tr>'+
   ' <td align="center" class="es-m-txt-c" style="padding:0;Margin:0;padding-left:40px;padding-right:40px">'+
   ' <p style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, ''helvetica neue'', helvetica, sans-serif;line-height:21px;color:#333333;font-size:14px">'+
   ' Redefina sua senha clicando no botão abaixo.</p>'+
   ' </td>'+
   ' </tr>'+
   ' </table>'+
   ' </td>'+
   ' </tr>'+
   ' </table>'+
   ' </td>'+
   ' </tr>'+
   ' <tr>'+
   ' <td align="left" style="padding:0;Margin:0;padding-bottom:20px;padding-left:20px;padding-right:20px">'+
   ' <table cellpadding="0" cellspacing="0" width="100%" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">'+
   ' <tr>'+
   ' <td align="center" valign="top" style="padding:0;Margin:0;width:560px">'+
   ' <table cellpadding="0" cellspacing="0" width="100%" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:separate;border-spacing:0px;border-radius:5px" role="presentation">'+
   ' <tr>'+
   ' <td align="center" style="padding:0;Margin:0;padding-top:10px;padding-bottom:10px">'+
   ' <!--[if mso]>'+

   ' <a href="https://sigetran.com.br/alterar/senha/jihjia8id0" target="_blank" hidden>'+
   ' <v:roundrect xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="urn:schemas-microsoft-com:office:word" esdevVmlButton href="https://sigetran.com.br/alterar/senha/jihjia8id0"'+
   ' style="height:44px; v-text-anchor:middle; width:261px" arcsize="9%" stroke="f" fillcolor="#ad37ed">'+
   ' <w:anchorlock></w:anchorlock>'+
   ' <center style="color:#ffffff; font-family:arial, "helvetica neue", helvetica, sans-serif; font-size:18px; font-weight:400; line-height:18px; mso-text-raise:1px">REDEFINIR SENHA</center>'+
   ' </v:roundrect>'+
   ' </a>'+

   ' <![endif]--><!--[if !mso]><!-- --><span class="msohide es-button-border" style="border-style:solid;border-color:#2CB543;background:#ad37ed;border-width:0px;display:inline-block;border-radius:4px;width:auto;mso-hide:all">'+
   // botão redefinir senha
   ' <a href="'+cUrl+'" class="es-button" target="_blank" style="mso-style-priority:100 !important;text-decoration:none;-webkit-text-size-adjust:none;'+
   '-ms-text-size-adjust:none;mso-line-height-rule:exactly;color:#FFFFFF;font-size:20px;'+
   ' padding:10px 30px 10px 30px;display:inline-block;background:#ad37ed;border-radius:4px;font-family:arial, ''helvetica neue'', helvetica, sans-serif;font-weight:normal;font-style:normal;line-height:24px;width:auto;text-align:center;mso-padding-alt:0;'+
   ' mso-border-alt:10px solid #5C68E2;padding-left:30px;padding-right:30px">'+
   ' REDEFINIR SENHA'+
   ' </a></span><!--<![endif]-->'+
   ' </td>'+
   ' </tr>'+
   ' <tr>'+
   ' <td align="center" style="padding:0;Margin:0;padding-top:10px;padding-bottom:10px">'+
   ' <p style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, ''helvetica neue'', helvetica, sans-serif;line-height:21px;color:#333333;font-size:14px">'+
   ' Se você não solicitou a redefinição de sua senha, desconsidere esta mensagem ou entre em contato com nosso suporte em nosso email sigetran.sup@gmail.com'+
   ' </p>'+
   ' </td>'+
   ' </tr>'+
   ' </table>'+
   ' </td>'+
   ' </tr>'+
   ' </table>'+
   ' </td>'+
   ' </tr>'+
   ' </table>'+
   ' </td>'+
   ' </tr>'+
   ' </table>'+
   ' <table cellpadding="0" cellspacing="0" class="es-footer" align="center" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;'+
   ' table-layout:fixed !important;width:100%;background-color:transparent;background-repeat:repeat;background-position:center top">'+
   ' <tr>'+
   ' <td align="center" style="padding:0;Margin:0">'+
   ' <table class="es-footer-body" align="center" cellpadding="0" cellspacing="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:transparent;width:600px" role="none">'+
   ' <tr>'+
   ' <td align="left" style="Margin:0;padding-top:20px;padding-bottom:20px;padding-left:20px;padding-right:20px">'+
   ' <table cellpadding="0" cellspacing="0" width="100%" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">'+
   ' <tr>'+
   ' <td align="left" style="padding:0;Margin:0;width:560px">'+
   ' <table cellpadding="0" cellspacing="0" width="100%" role="presentation" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">'+
   ' <tr>'+
   ' <td align="center" style="padding:0;Margin:0;padding-bottom:35px">'+
   ' <p style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, ''helvetica neue'', helvetica, sans-serif;line-height:18px;color:#333333;'+
   'font-size:12px">Sigetran © 2023 Todos direitos reservados.</p>'+
   ' </td>'+
   ' </tr>'+
   ' </table>'+
   ' </td>'+
   ' </tr>'+
   ' </table>'+
   ' </td>'+
   ' </tr>'+
   ' </table>'+
   ' </td>'+
   ' </tr>'+
   ' </table>'+
   ' <table cellpadding="0" cellspacing="0" class="es-content" align="center" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%">'+
   ' <tr>'+
   ' <td class="es-info-area" align="center" style="padding:0;Margin:0">'+
   ' <table class="es-content-body" align="center" cellpadding="0" cellspacing="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:transparent;width:600px" bgcolor="#FFFFFF" role="none">'+
   ' <tr>'+
   ' <td align="left" style="padding:20px;Margin:0">'+
   ' <table cellpadding="0" cellspacing="0" width="100%" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">'+
   ' <tr>'+
   ' <td align="center" valign="top" style="padding:0;Margin:0;width:560px">'+
   ' <table cellpadding="0" cellspacing="0" width="100%" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">'+
   ' <tr>'+
   ' <td align="center" style="padding:0;Margin:0;display:none"></td>'+
   ' </tr>'+
   ' </table>'+
   ' </td>'+
   ' </tr>'+
   ' </table>'+
   ' </td>'+
   ' </tr>'+
   ' </table>'+
   ' </td>'+
   ' </tr>'+
   ' </table>'+
   ' <table cellpadding="0" cellspacing="0" class="es-content" align="center" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%">'+
   ' <tr>'+
   ' <td class="es-info-area" align="center" style="padding:0;Margin:0">'+
   ' <table class="es-content-body" align="center" cellpadding="0" cellspacing="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:transparent;width:600px" bgcolor="#FFFFFF" role="none">'+
   ' <tr>'+
   ' <td align="left" style="padding:20px;Margin:0">'+
   ' <table cellpadding="0" cellspacing="0" width="100%" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">'+
   ' <tr>'+
   ' <td align="center" valign="top" style="padding:0;Margin:0;width:560px">'+
   ' <table cellpadding="0" cellspacing="0" width="100%" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">'+
   ' <tr>'+
   ' <td align="center" style="padding:0;Margin:0;display:none"></td>'+
   ' </tr>'+
   ' </table>'+
   ' </td>'+
   ' </tr>'+
   ' </table>'+
   ' </td>'+
   ' </tr>'+
   ' </table>'+
   ' </td>'+
   ' </tr>'+
   ' </table>'+
   ' </td>'+
   ' </tr>'+
   ' </table>'+
   ' </div>'+
   ' </body>'+
   ' </html>';
end;


function TEmpresas.GerarEmailVerificacao(cCod:String): String;
begin
   Result :=
   '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> '+
   '<html dir="ltr" xmlns="http://www.w3.org/1999/xhtml" xmlns:o="urn:schemas-microsoft-com:office:office" lang="pt"> '+
   '<head> '+
   '<meta charset="UTF-8"> '+
   '<meta content="width=device-width, initial-scale=1" name="viewport"> '+
   '<meta name="x-apple-disable-message-reformatting"> '+
   '<meta http-equiv="X-UA-Compatible" content="IE=edge"> '+
   '<meta content="telephone=no" name="format-detection"> '+
   '<title>Confirmação de Email</title> '+
   '<!--[if (mso 16)]> '+
   '<style type="text/css"> '+
   'a {text-decoration: none;} '+
   '</style> '+
   '<![endif]--><!--[if gte mso 9]> '+
   '<style>sup { font-size: 100% !important; }</style> '+
   '<![endif]--><!--[if gte mso 9]> '+
   '<xml> '+
   '<o:OfficeDocumentSettings> '+
   '<o:AllowPNG></o:AllowPNG> '+
   '<o:PixelsPerInch>96</o:PixelsPerInch> '+
   '</o:OfficeDocumentSettings> '+
   '</xml> '+
   '<![endif]--> '+
   '<style type="text/css"> '+
   '#outlook a { '+
   'padding:0; '+
   '} '+
   '.es-button { '+
   'mso-style-priority:100!important; '+
   'text-decoration:none!important; '+
   '} '+
   'a[x-apple-data-detectors] { '+
   'color:inherit!important; '+
   'text-decoration:none!important; '+
   'font-size:inherit!important; '+
   'font-family:inherit!important; '+
   'font-weight:inherit!important; '+
   'line-height:inherit!important; '+
   '} '+
   '.es-desk-hidden { '+
   'display:none; '+
   'float:left; '+
   'overflow:hidden; '+
   'width:0; '+
   'max-height:0; '+
   'line-height:0; '+
   'mso-hide:all; '+
   '} '+
   '@media only screen and (max-width:600px) { '+
   'p, ul li, ol li, a { '+
   'line-height:150%!important '+
   '} '+
   'h1, h2, h3, h1 a, h2 a, h3 a { '+
   'line-height:120% '+
   '} '+
   'h1 { '+
   'font-size:36px!important; '+
   'text-align:left '+
   '} '+
   'h2 { '+
   'font-size:26px!important; '+
   'text-align:left '+
   '} '+
   'h3 { '+
   'font-size:20px!important; '+
   'text-align:left '+
   '} '+
   '.es-header-body h1 a, .es-content-body h1 a, .es-footer-body h1 a { '+
   'font-size:36px!important; '+
   'text-align:left '+
   '} '+
   '.es-header-body h2 a, .es-content-body h2 a, .es-footer-body h2 a { '+
   'font-size:26px!important; '+
   'text-align:left '+
   '} '+
   '.es-header-body h3 a, .es-content-body h3 a, .es-footer-body h3 a { '+
   'font-size:20px!important; '+
   'text-align:left '+
   '} '+
   '.es-menu td a { '+
   'font-size:12px!important '+
   '} '+
   '.es-header-body p, .es-header-body ul li, .es-header-body ol li, .es-header-body a { '+
   'font-size:14px!important '+
   '} '+
   '.es-content-body p, .es-content-body ul li, .es-content-body ol li, .es-content-body a { '+
   'font-size:16px!important '+
   '} '+
   '.es-footer-body p, .es-footer-body ul li, .es-footer-body ol li, .es-footer-body a { '+
   'font-size:14px!important '+
   '} '+
   '.es-infoblock p, .es-infoblock ul li, .es-infoblock ol li, .es-infoblock a { '+
   'font-size:12px!important '+
   '} '+
   '*[class="gmail-fix"] { '+
   'display:none!important '+
   '} '+
   '.es-m-txt-c, .es-m-txt-c h1, .es-m-txt-c h2, .es-m-txt-c h3 { '+
   'text-align:center!important '+
   '} '+
   '.es-m-txt-r, .es-m-txt-r h1, .es-m-txt-r h2, .es-m-txt-r h3 { '+
   'text-align:right!important '+
   '} '+
   '.es-m-txt-l, .es-m-txt-l h1, .es-m-txt-l h2, .es-m-txt-l h3 { '+
   'text-align:left!important '+
   '} '+
   '.es-m-txt-r img, .es-m-txt-c img, .es-m-txt-l img { '+
   'display:inline!important '+
   '} '+
   '.es-button-border { '+
   'display:inline-block!important '+
   '} '+
   'a.es-button, button.es-button { '+
   'font-size:20px!important; '+
   'display:inline-block!important '+
   '} '+
   '.es-adaptive table, .es-left, .es-right { '+
   'width:100%!important '+
   '} '+
   '.es-content table, .es-header table, .es-footer table, .es-content, .es-footer, .es-header { '+
   'width:100%!important; '+
   'max-width:600px!important '+
   '} '+
   '.es-adapt-td { '+
   'display:block!important; '+
   'width:100%!important '+
   '} '+
   '.adapt-img { '+
   'width:100%!important; '+
   'height:auto!important '+
   '} '+
   '.es-m-p0 { '+
   'padding:0!important '+
   '} '+
   '.es-m-p0r { '+
   'padding-right:0!important '+
   '} '+
   '.es-m-p0l { '+
   'padding-left:0!important '+
   '} '+
   '.es-m-p0t { '+
   'padding-top:0!important '+
   '} '+
   '.es-m-p0b { '+
   'padding-bottom:0!important '+
   '} '+
   '.es-m-p20b { '+
   'padding-bottom:20px!important '+
   '} '+
   '.es-mobile-hidden, .es-hidden { '+
   'display:none!important '+
   '} '+
   'tr.es-desk-hidden, td.es-desk-hidden, table.es-desk-hidden { '+
   'width:auto!important; '+
   'overflow:visible!important; '+
   'float:none!important; '+
   'max-height:inherit!important; '+
   'line-height:inherit!important '+
   '} '+
   'tr.es-desk-hidden { '+
   'display:table-row!important '+
   '} '+
   'table.es-desk-hidden { '+
   'display:table!important '+
   '} '+
   'td.es-desk-menu-hidden { '+
   'display:table-cell!important '+
   '} '+
   '.es-menu td { '+
   'width:1%!important '+
   '} '+
   'table.es-table-not-adapt, .esd-block-html table { '+
   'width:auto!important '+
   '} '+
   'table.es-social { '+
   'display:inline-block!important '+
   '} '+
   'table.es-social td { '+
   'display:inline-block!important '+
   '} '+
   '.es-m-p5 { '+
   'padding:5px!important '+
   '} '+
   '.es-m-p5t { '+
   'padding-top:5px!important '+
   '} '+
   '.es-m-p5b { '+
   'padding-bottom:5px!important '+
   '} '+
   '.es-m-p5r { '+
   'padding-right:5px!important '+
   '} '+
   '.es-m-p5l { '+
   'padding-left:5px!important '+
   '} '+
   '.es-m-p10 { '+
   'padding:10px!important '+
   '} '+
   '.es-m-p10t { '+
   'padding-top:10px!important '+
   '} '+
   '.es-m-p10b { '+
   'padding-bottom:10px!important '+
   '} '+
   '.es-m-p10r { '+
   'padding-right:10px!important '+
   '} '+
   '.es-m-p10l { '+
   'padding-left:10px!important '+
   '} '+
   '.es-m-p15 { '+
   'padding:15px!important '+
   '} '+
   '.es-m-p15t { '+
   'padding-top:15px!important '+
   '} '+
   '.es-m-p15b { '+
   'padding-bottom:15px!important '+
   '} '+
   '.es-m-p15r { '+
   'padding-right:15px!important '+
   '} '+
   '.es-m-p15l { '+
   'padding-left:15px!important '+
   '} '+
   '.es-m-p20 { '+
   'padding:20px!important '+
   '} '+
   '.es-m-p20t { '+
   'padding-top:20px!important '+
   '} '+
   '.es-m-p20r { '+
   'padding-right:20px!important '+
   '} '+
   '.es-m-p20l { '+
   'padding-left:20px!important '+
   '} '+
   '.es-m-p25 { '+
   'padding:25px!important '+
   '} '+
   '.es-m-p25t { '+
   'padding-top:25px!important '+
   '} '+
   '.es-m-p25b { '+
   'padding-bottom:25px!important '+
   '} '+
   '.es-m-p25r { '+
   'padding-right:25px!important '+
   '} '+
   '.es-m-p25l { '+
   'padding-left:25px!important '+
   '} '+
   '.es-m-p30 { '+
   'padding:30px!important '+
   '} '+
   '.es-m-p30t { '+
   'padding-top:30px!important '+
   '} '+
   '.es-m-p30b { '+
   'padding-bottom:30px!important '+
   '} '+
   '.es-m-p30r { '+
   'padding-right:30px!important '+
   '} '+
   '.es-m-p30l { '+
   'padding-left:30px!important '+
   '} '+
   '.es-m-p35 { '+
   'padding:35px!important '+
   '} '+
   ' '+
   '</style> '+
   '</head> '+
   '<body style="width:100%;font-family:arial, ''helvetica neue'', helvetica, sans-serif;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;padding:0;Margin:0"> '+
   '<div dir="ltr" class="es-wrapper-color" lang="pt" style="background-color:#FAFAFA"> '+
   '<!--[if gte mso 9]> '+
   '<v:background xmlns:v="urn:schemas-microsoft-com:vml" fill="t"> '+
   '<v:fill type="tile" color="#fafafa"></v:fill> '+
   '</v:background> '+
   '<![endif]--> '+
   '<table class="es-wrapper" width="100%" cellspacing="0" cellpadding="0" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;padding:0;Margin:0;width:100%;height:100%;'+
   ' background-repeat:repeat;background-position:center top;background-color:#FAFAFA"> '+
   '<tr> '+
   '<td valign="top" style="padding:0;Margin:0"> '+
   '<table cellpadding="0" cellspacing="0" class="es-content" align="center" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%"> '+
   '<tr> '+
   '<td class="es-info-area" align="center" style="padding:0;Margin:0"> '+
   '<table class="es-content-body" align="center" cellpadding="0" cellspacing="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:transparent;width:600px" bgcolor="#FFFFFF" role="none"> '+
   '<tr> '+
   '<td align="left" style="padding:20px;Margin:0"> '+
   '<table cellpadding="0" cellspacing="0" width="100%" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px"> '+
   '<tr> '+
   '<td align="center" valign="top" style="padding:0;Margin:0;width:560px"> '+
   '<table cellpadding="0" cellspacing="0" width="100%" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px"> '+
   '<tr> '+
   '<td align="center" style="padding:0;Margin:0;display:none"></td> '+
   '</tr> '+
   '</table> '+
   '</td> '+
   '</tr> '+
   '</table> '+
   '</td> '+
   '</tr> '+
   '</table> '+
   '</td> '+
   '</tr> '+
   '</table> '+
   '<table cellpadding="0" cellspacing="0" class="es-header" align="center" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;background-color:transparent;'+
   'background-repeat:repeat;background-position:center top"> '+
   '<tr> '+
   '<td align="center" style="padding:0;Margin:0"> '+
   '<table bgcolor="#ffffff" class="es-header-body" align="center" cellpadding="0" cellspacing="0" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;'+
   'border-spacing:0px;background-color:transparent;width:600px"> '+
   '<tr> '+
   '<td align="left" style="Margin:0;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px"> '+
   '<table cellpadding="0" cellspacing="0" width="100%" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px"> '+
   '<tr> '+
   '<td class="es-m-p0r" valign="top" align="center" style="padding:0;Margin:0;width:560px"> '+
   '<table cellpadding="0" cellspacing="0" width="100%" role="presentation" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px"> '+
   '<tr> '+
   '<td align="center" style="padding:0;Margin:0;padding-bottom:20px;font-size:0px">'+
   ' <img src="https://sigetran.com.br/logo.png" alt="Logo" style="display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic;font-size:12px" width="80" height="80" title="Logo"></td> '+
   '</tr> '+
   '</table> '+
   '</td> '+
   '</tr> '+
   '</table> '+
   '</td> '+
   '</tr> '+
   '</table> '+
   '</td> '+
   '</tr> '+
   '</table> '+
   '<table cellpadding="0" cellspacing="0" class="es-content" align="center" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;'+
   'table-layout:fixed !important;width:100%"> '+
   '<tr> '+
   '<td align="center" style="padding:0;Margin:0"> '+
   '<table bgcolor="#ffffff" class="es-content-body" align="center" cellpadding="0" cellspacing="0" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;'+
   'border-spacing:0px;background-color:#FFFFFF;width:600px"> '+
   '<tr> '+
   '<td align="left" style="Margin:0;padding-bottom:10px;padding-left:20px;padding-right:20px;padding-top:30px"> '+
   '<table cellpadding="0" cellspacing="0" width="100%" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px"> '+
   '<tr> '+
   '<td align="center" valign="top" style="padding:0;Margin:0;width:560px"> '+
   '<table cellpadding="0" cellspacing="0" width="100%" role="presentation" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px"> '+
   '<tr> '+
   '<td align="center" style="padding:0;Margin:0;padding-top:10px;padding-bottom:10px;font-size:0px">'+
   ' <img src="https://ksmjvq.stripocdn.email/content/guids/CABINET_a3448362093fd4087f87ff42df4565c1/images/78501618239341906.png" alt '+
   ' style="display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic" width="100"></td> '+
   '</tr> '+
   '<tr> '+
   '<td align="center" class="es-m-txt-c" style="padding:0;Margin:0;padding-bottom:10px"> '+
   '<h1 style="Margin:0;line-height:36px;mso-line-height-rule:exactly;font-family:arial, ''helvetica neue'', helvetica, sans-serif;font-size:36px;font-style:normal;font-weight:bold;color:#333333">'+
   ' Confirme seu email</h1> '+
   '</td> '+
   '</tr> '+
   '<tr> '+
   '<td align="center" class="es-m-p0r es-m-p0l" style="Margin:0;padding-top:5px;padding-bottom:5px;padding-left:40px;padding-right:40px"> '+


   '<p style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, ''helvetica neue'', helvetica, sans-serif;line-height:21px;color:#333333;'+
   ' font-size:14px">Parábens, você acabou de se cadastrar na nossa plataforma, só mais um clique para você poder sair gerando CT-e e MDF-e!! <br> Copie e cole o código abaixo para confirmar seu email</p> '+
   '</td> '+
   '</tr> '+
   '</table> '+
   '</td> '+
   '</tr> '+
   '</table> '+
   '</td> '+
   '</tr> '+
   '<tr> '+
   '<td align="left" style="Margin:0;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px"> '+
   '<table cellpadding="0" cellspacing="0" width="100%" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px"> '+
   '<tr> '+
   '<td align="center" valign="top" style="padding:0;Margin:0;width:560px"> '+
   '<table cellpadding="0" cellspacing="0" width="100%" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:separate;border-spacing:0px;border-left:2px dashed #cccccc;border-right:2px dashed #cccccc;'+
   ' border-top:2px dashed #cccccc;border-bottom:2px dashed #cccccc;border-radius:5px" role="presentation"> '+
   '<tr> '+
   '<td align="center" class="es-m-txt-c" style="padding:0;Margin:0;padding-top:20px;padding-left:20px;padding-right:20px"> '+
   '<h2 style="Margin:0;line-height:31px;mso-line-height-rule:exactly;font-family:arial, ''helvetica neue'', helvetica, sans-serif;font-size:26px;font-style:normal;font-weight:bold;color:#333333">Seu código</h2> '+
   '</td> '+
   '</tr> '+
   '<tr> '+
   '<td align="center" class="es-m-txt-c" style="Margin:0;padding-top:10px;padding-bottom:20px;padding-left:20px;padding-right:20px"> '+
   '<h1 style="Margin:0;line-height:55px;mso-line-height-rule:exactly;font-family:arial, ''helvetica neue'', helvetica, sans-serif;font-size:46px;font-style:normal;font-weight:bold;color:#5c68e2">'+
   ' <strong>'+cCod+'</strong>'+ // CODIGO '+
   '</h1> '+
   '</td> '+
   '</tr> '+
   '</table> '+
   '</td> '+
   '</tr> '+
   '</table> '+
   '</td> '+
   '</tr> '+
   '</table> '+
   '</td> '+
   '</tr> '+
   '</table> '+
   '<table cellpadding="0" cellspacing="0" class="es-footer" align="center" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;'+
   ' table-layout:fixed !important;width:100%;background-color:transparent;background-repeat:repeat;background-position:center top"> '+
   '<tr> '+
   '<td align="center" style="padding:0;Margin:0"> '+
   '<table class="es-footer-body" align="center" cellpadding="0" cellspacing="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;'+
   ' background-color:transparent;width:640px" role="none"> '+
   '<tr> '+
   '<td align="left" style="Margin:0;padding-top:20px;padding-bottom:20px;padding-left:20px;padding-right:20px"> '+
   '<table cellpadding="0" cellspacing="0" width="100%" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px"> '+
   '<tr> '+
   '<td align="left" style="padding:0;Margin:0;width:600px"> '+
   '<table cellpadding="0" cellspacing="0" width="100%" role="presentation" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px"> '+
   '<tr> '+
   '<td align="center" style="padding:0;Margin:0;padding-bottom:35px"> '+
   '<p style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, ''helvetica neue'', helvetica, sans-serif;line-height:18px;'+
   'color:#333333;font-size:12px">Sigetran © 2023 Todos direitos reservados.</p> '+
   '</td> '+
   '</tr> '+
   '</table> '+
   '</td> '+
   '</tr> '+
   '</table> '+
   '</td> '+
   '</tr> '+
   '</table> '+
   '</td> '+
   '</tr> '+
   '</table> '+
   '<table cellpadding="0" cellspacing="0" class="es-content" align="center" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;'+
   'table-layout:fixed !important;width:100%"> '+
   '<tr> '+
   '<td class="es-info-area" align="center" style="padding:0;Margin:0"> '+
   '<table class="es-content-body" align="center" cellpadding="0" cellspacing="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:transparent;'+
   'width:600px" bgcolor="#FFFFFF" role="none"> '+
   '<tr> '+
   '<td align="left" style="padding:0;Margin:0;padding-left:20px;padding-right:20px;padding-bottom:30px"> '+
   '<table cellpadding="0" cellspacing="0" width="100%" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px"> '+
   '<tr> '+
   '<td align="center" valign="top" style="padding:0;Margin:0;width:560px"> '+
   '<table cellpadding="0" cellspacing="0" width="100%" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:separate;border-spacing:0px;border-radius:5px" role="none"> '+
   '<tr> '+
   '<td align="center" style="padding:0;Margin:0;display:none"></td> '+
   '</tr> '+
   '</table> '+
   '</td> '+
   '</tr> '+
   '</table> '+
   '</td> '+
   '</tr> '+
   '<tr> '+
   '<td align="left" style="padding:20px;Margin:0"> '+
   '<table cellpadding="0" cellspacing="0" width="100%" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px"> '+
   '<tr> '+
   '<td align="center" valign="top" style="padding:0;Margin:0;width:560px"> '+
   '<table cellpadding="0" cellspacing="0" width="100%" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px"> '+
   '<tr> '+
   '<td align="center" style="padding:0;Margin:0;display:none"></td> '+
   '</tr> '+
   '</table> '+
   '</td> '+
   '</tr> '+
   '</table> '+
   '</td> '+
   '</tr> '+
   '<tr> '+
   '<td align="left" style="padding:20px;Margin:0"> '+
   '<table cellpadding="0" cellspacing="0" width="100%" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px"> '+
   '<tr> '+
   '<td align="center" valign="top" style="padding:0;Margin:0;width:560px"> '+
   '<table cellpadding="0" cellspacing="0" width="100%" role="none" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px"> '+
   '<tr> '+
   '<td align="center" style="padding:0;Margin:0;display:none"></td> '+
   '</tr> '+
   '</table> '+
   '</td> '+
   '</tr> '+
   '</table> '+
   '</td> '+
   '</tr> '+
   '</table> '+
   '</td> '+
   '</tr> '+
   '</table> '+
   '</td> '+
   '</tr> '+
   '</table> '+
   '</div> '+
   '</body> '+
   '</html>';
end;

function TEmpresas.ValidaTokenRecuperarSenha(oBody: TJSONObject;
  Params: TStrings): String;
var
   cCod   : String;
   cFile  : String;
   qREG   : TSQLQuery;
   qAUX   : TSQLQuery;
   cDB    : TSQLConnection;
begin
   qAUX := TSQLQuery.Create(Nil);

   cDB     := TSQLConnection.Create(Nil);

   ConfiguraConexao(Params.Values['db'],cDB);
   qAUX.SQLConnection := cDB;
   try
      qAUX.Close;
      qAUX.SQL.Text := 'SELECT FIRST 1 U.*,E.CNPJ '+
      'FROM USUARIOS U '+
      'LEFT JOIN EMPRESA E ON E.CODIGO=1 '+
      'WHERE U.TOKEN_ALTERACAO_SENHA='+QuotedStr(GetValueJSONObject('token',oBody));
      sql := qAUX.SQL.Text;
      qAUX.Open;

      if qAUX.Eof then
         Result := '{"erro":1,"mensagem":"Token não encontrado"}'
      else begin
         Result := '{'+
         '"erro":0,'+
         '"mensagem":"Token validado com sucesso"'+
         '}';
      end;
   finally
      FreeAndNil(qAUX);
      FreeAndNil(cDB);
   end;
end;

function TEmpresas.AlterarSenha(oBody: TJSONObject; Params: TStrings): String;
var
   cCod   : String;
   cFile  : String;
   qREG   : TSQLQuery;
   qAUX   : TSQLQuery;
   cDB    : TSQLConnection;
begin
   qAUX := TSQLQuery.Create(Nil);
   qREG := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Params.Values['db'],cDB);

   qAUX.SQLConnection := cDB;
   qREG.SQLConnection := cDB;
   try
      qAUX.Close;
      qAUX.SQL.Text := 'SELECT FIRST 1 U.*,E.CNPJ '+
      'FROM USUARIOS U '+
      'LEFT JOIN EMPRESA E ON E.CODIGO=1 '+
      'WHERE U.TOKEN_ALTERACAO_SENHA='+QuotedStr(GetValueJSONObject('token',oBody));
      sql := qAUX.SQL.Text;
      qAUX.Open;

      if qAUX.Eof then
         Result := '{"erro":1,"mensagem":"Token não encontrado"}'
      else begin
         qREG.Close;
         qREG.SQL.Text := 'UPDATE USUARIOS SET '+
         'SENHA='+QuotedStr(Encrip(GetValueJSONObject('senha',oBody)))+','+
         'TOKEN_ALTERACAO_SENHA=NULL '+
         'WHERE CODIGO=0'+qAUX.FieldByName('CODIGO').AsString;
         sql := qREG.SQL.Text;
         qREG.ExecSQL(False);

         Result := '{'+
         '"erro":0,'+
         '"mensagem":"Senha alterada com sucesso"'+
         '}';
      end;
   finally
      FreeAndNil(qREG);
      FreeAndNil(qAUX);
      FreeAndNil(cDB);
   end;
end;

function TEmpresas.BuscaPlano(qUSU: TSQLQuery): String;
var
   cCod   : String;
   cFile  : String;

   qREG   : TSQLQuery;
   qAUX   : TSQLQuery;
   cDB    : TSQLConnection;
begin
   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfConexao(cDB);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := qUSU.SQLConnection;
   try
      qREG.Close;
      qREG.SQL.Text := 'SELECT P.CODIGO AS PLANO_ID, P.QUANTIDADE,P.TITULO,P.VALOR  '+
      'FROM EMPRESAS E '+
      'LEFT JOIN PLANOS P ON P.CODIGO=E.PLANO '+
      'WHERE E.CNPJ='+QuotedStr(SoNumero(qUSU.FieldByName('CNPJ').AsString));
      sql := qREG.SQL.Text;
      qREG.Open;

      qAUX.Close;
      qAUX.SQL.Text := 'SELECT FIRST 1 '+
      '(SELECT COUNT(CODIGO) FROM FRETES WHERE CHAVECTE<>''''  AND DATA >= '+QuotedStr(FormatDateTime('01.mm.yyyy',now))+')+'+
      '(SELECT COUNT(CODIGO)FROM FRETESMDF WHERE ITEM = 1  AND (STATUS = ''E'') AND DATA >= '+QuotedStr(FormatDateTime('01.mm.yyyy',now))+') AS EMISSOES '+
      'FROM PARAMETROS ';
      sql := qAUX.SQL.Text;
      qAUX.Open;

      Result := '{'+
      '"erro":0,'+
      '"plano_id":"'+qREG.FieldByName('PLANO_ID').AsString+'",'+
      '"quantidade_emissoes":"'+qREG.FieldByName('QUANTIDADE').AsString+'",'+
      '"titulo":"'+qREG.FieldByName('TITULO').AsString+'",'+
      '"valor_mensal":"'+qREG.FieldByName('VALOR').AsString+'",'+
      '"emissoes_realizadas":"'+qAUX.FieldByName('EMISSOES').AsString+'"'+
      '}';
   finally
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(cDB);
   end;
end;


end.
