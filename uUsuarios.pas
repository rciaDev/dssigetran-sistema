unit uUsuarios;

interface
Uses System.SysUtils,System.Classes,Data.DB, Data.SqlExpr, math,Datasnap.DSSession,MSHTML,ActiveX,FMX.Graphics,
 Soap.EncdDecd,System.JSON;

type
  TUsuarios = class
  private
    { private declarations }

  protected
    { protected declarations }
  public
    { public declarations }
    function GetSql():String;
    function Registra(oReq: TJSONObject;qUSU:TSQLQuery;cDB:TSQLConnection): String;

  published

  end;

  var sql : String;
implementation

uses uWMSite, uFrm, uUsuariosJSON;

{ TUsuarios }



function TUsuarios.GetSql: String;
begin
   result:=sql;
end;


function TUsuarios.Registra(oReq: TJSONObject;qUSU:TSQLQuery;cDB:TSQLConnection): String;
var
   cCod  : String;
   cAux  : String;
   cData : String;
   sqlCampo, sqlValor : String;
   cUsuAlt : String;
   qAUX  : TSQLQuery;
   qREG  : TSQLQuery;
   TD    : TTransactionDesc;
   oUsu  : TUsuariosJSON;
begin
   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;

   TD.TransactionID   := TDSSessionManager.GetThreadSession.Id;
   TD.IsolationLevel  := xilREADCOMMITTED;
   cDB.StartTransaction(TD);

   oUsu := TUsuariosJSON.Create;
   try
      try
         oUsu.AsJson := oReq.ToString;

         cCod  := iif((oUsu.Codigo = '') or (oUsu.Codigo = '0'),'0',oUsu.Codigo);
         cAux  := cCod;
         // cData := FormatDateTime('dd.mm.yyyy hh:MM:ss', now);

         qAUX.Close;
         qAUX.SQL.Text := 'SELECT CODIGO '+
         'FROM USUARIOS '+
         'WHERE CODIGO<>0'+cCod+' AND EMAIL='+QuotedStr(oUsu.Email);
         sql := qAUX.SQL.Text;
         qAUX.Open;

         if not(qAUX.Eof)then begin
            Result := '{"erro":"1","mensagem":"Esse email já está sendo utilizado"}';
            exit;
         end;

         qAUX.Close;
         qAUX.SQL.Text := 'SELECT CODIGO '+
         'FROM USUARIOS '+
         'WHERE CODIGO<>0'+cCod+' AND LOGIN='+QuotedStr(oUsu.Login);
         sql := qAUX.SQL.Text;
         qAUX.Open;

         if not(qAUX.Eof)then begin
            Result := '{"erro":"1","mensagem":"Esse login já está sendo utilizado"}';
            exit;
         end;

         if(cCod = '0')then begin
            qAUX.Close;
            qAUX.SQL.Text := 'SELECT COALESCE(MAX(CODIGO),0)+1 AS COD FROM USUARIOS ';
            sql := qAUX.SQL.Text;
            qAUX.Open;

            cCod  := qAUX.FieldByName('COD').AsString;
            sqlCampo := ',SENHA,ENCRIPTADA';
            sqlValor := ','+QuotedStr(Encrip(oUsu.Senha))+','+QuotedStr('S');
         end else begin

            qAUX.Close;
            qAUX.SQL.Text := 'SELECT CODIGO '+
            'FROM USUARIOS '+
            'WHERE CODIGO=0'+cCod;
            sql := qAUX.SQL.Text;
            qAUX.Open;

            if(qAUX.Eof)then begin
               Result := '{"erro":"1","mensagem":"Registro não localizado"}';
               exit;
            end;

            // cData := FormatDateTime('dd.mm.yyyy hh:MM:ss', qAUX.FieldByName('DATA').AsDateTime);
         end;

         qREG.Close;
         qREG.SQL.Clear;
         qREG.SQL.Add('UPDATE OR INSERT INTO USUARIOS(CODIGO,');
         qREG.SQL.Add('NOME,LOGIN,CEP,ENDERECO,NUMERO,BAIRRO,');
         qREG.SQL.Add('ESTADO,CIDADE,EMAIL,ATIVO,PERFIL,PERFIL1,MENU'+sqlCampo+')');
         qREG.SQL.Add('VALUES('+cCod+',');
         qREG.SQL.Add(QuotedSan(oUsu.Nome)+','+QuotedStr(oUsu.login)+',');
         qREG.SQL.Add(QuotedSan(oUsu.Cep)+','+QuotedSan(oUsu.Endereco)+',');
         qREG.SQL.Add(TrataNumStr(oUsu.Numero)+','+QuotedSan(oUsu.Bairro)+',');
         qREG.SQL.Add(QuotedSan(oUsu.Uf)+','+QuotedSan(oUsu.Cidade)+',');
         qREG.SQL.Add(QuotedStr(oUsu.Email)+','+QuotedSan(oUsu.Ativo)+',');
         qREG.SQL.Add(QuotedSan(oUsu.Perfil)+','+QuotedSan(oUsu.PerfilAdicional)+',');
         qREG.SQL.Add('''SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS''');
         qREG.SQL.Add(sqlValor);
         qREG.SQL.Add(')');
         sql := qREG.SQL.Text;
         qREG.ExecSQL(False);

         Result := '{"erro":0,"mensagem":"Registro '+iif(cAux = '0', 'incluído','atualizado')+' com sucesso!","codigo":"'+cCod+'"}';

         if cDB.InTransaction then
           cDB.Commit(TD);

         Commita(qREG);
      except on E: Exception do begin
         if cDB.InTransaction then
            cDB.Rollback(TD);

         GravaLog('Erro ao gravar usuário #cliente:'+qUSU.FieldByName('CNPJ').ASString+' #erro:'+e.Message+' SQL:'+sql);

         Result := MensagemErroServer();
      end;
      end;
   finally
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(oUsu);
   end;
end;

end.
