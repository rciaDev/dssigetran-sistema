unit uMdfe;

interface
Uses System.SysUtils,System.Classes,Data.DB, Data.SqlExpr, math,Datasnap.DSSession,MSHTML,ActiveX,FMX.Graphics,
     ACBrMDFeDAMDFeClass,  ACBrMDFe, ACBrMDFeDAMDFeRLClass, ACBrDFeReport,pcnConversao, pcnAuxiliar,ACBrDFeSSL,
     pmdfeConversaoMDFe,ACBrCTeDACTeRLClass, ACBrBase, ACBrDFe, Types,RLTypes,System.DateUtils,ACBrMail,
     Soap.EncdDecd,System.JSON,Windows;

type
  TMdfe = class
  private
    { private declarations }

  protected
    { protected declarations }
  public
    { public declarations }
    function GetSql():String;
    function Registra(oReq:TJSONObject; qUSU:TSQLQuery;cDB:TSQLConnection):String;

    function Status(cDB:TSQLConnection):String;
    function Envia(oReq:TJSONObject;qUSU:TSQLQuery;cDB:TSQLConnection):String;
    function Download(oReq: TJSONObject; qUSU: TSQLQuery;cDB: TSQLConnection): String;
    function DownloadEncerramento(oReq: TJSONObject; qUSU: TSQLQuery;cDB: TSQLConnection): String;
    function Cancela(oReq:TJSONObject;qUSU:TSQLQuery;cDB:TSQLConnection):String;
    function Email(oReq:TJSONObject;qUSU:TSQLQuery;cDB:TSQLConnection):String;
    function Encerra(oReq:TJSONObject;qUSU:TSQLQuery;cDB:TSQLConnection):String;
    function EnviaSeguro(oReq:TJSONObject;qUSU:TSQLQuery;cDB:TSQLConnection):String;
    function VerificaCertificado(qAUX: TSQLQuery): Boolean;
    function ImprimePDFPorXMLEncerramento(oReq: TJSONObject; qUSU: TSQLQuery;
    cDB: TSQLConnection): String;
    function Consulta(Req: TStrings; qUSU: TSQLQuery): String;

    procedure ConfiguraMail(ACBRMail: TACBRMail; qAUX: TSQLQuery);
    procedure ConfiguraMDFe(qAUX: TSQLQUery; ACBrMDFe1:TACBrMDFe;ACBrMDFeDAMDFeRL1: TACBrMDFeDAMDFeRL);
    procedure GerarMdfe(qREG,qAUX,qUSU:TSQLQuery;ACBrMDFe1:TACBrMDFe;ACBrMDFeDAMDFeRL1:TACBrMDFeDAMDFeRL);
    procedure AdicionarNota(qREG:TSQLQuery;ACBrMDFe1:TACBrMDFe);
    procedure EncerrarMDFe(ch,pr: String;ACBrMDFe1:TACBrMDFe;qAUX:TSQLQuery);

  published

  end;

  var sql : String;
implementation

uses uWMSite, uFrm, uMdfeJSON;


{ TMdfe }



procedure TMdfe.ConfiguraMDFe(qAUX: TSQLQUery; ACBrMDFe1: TACBrMDFe;ACBrMDFeDAMDFeRL1: TACBrMDFeDAMDFeRL);
var
   cPdf  : String;
   cCert : String;
   cLogo : String;
   bOk   : Boolean;
   PathMensal: String;
begin
   cCert := qAUX.FieldByName('CERTIFICADO_CAMINHO').AsString;
   if(Copy(cCert,1,1) = '.')then
       cCert := ExtractFilePath(ParamStr(0))+Copy(cCert,3,Length(cCert));

   ACBrMDFe1.Configuracoes.Certificados.ArquivoPFX  := cCert;
   ACBrMDFe1.Configuracoes.Certificados.Senha       := qAUX.FieldByName('CERTIFICADO_SENHA').AsString;
   ACBrMDFe1.Configuracoes.Geral.SSLLib             := libWinCrypt;

   ACBrMDFe1.Configuracoes.Geral.Salvar              := False;
   ACBrMDFe1.Configuracoes.Arquivos.AdicionarLiteral := true;
   ACBrMDFe1.Configuracoes.Arquivos.SepararPorMes    := true;
   ACBrMDFe1.Configuracoes.Arquivos.PathMDFe         := ExtractFilePath(ParamStr(0))+'clientes\MDFe\'+soNUmero(qAUX.FieldByName('CNPJ').AsString)+'\';
   ACBrMDFe1.Configuracoes.Arquivos.PathEvento       := ExtractFilePath(ParamStr(0))+'clientes\MDFe\'+soNUmero(qAUX.FieldByName('CNPJ').AsString)+'\';
   ACBrMDFe1.Configuracoes.Arquivos.EmissaoPathMDFe  := true;
   ACBrMDFe1.Configuracoes.Arquivos.Salvar           := true;
   // ACBrMDFe1.Configuracoes.Arquivos.           := False;
   ACBrMDFe1.Configuracoes.Arquivos.PathSchemas      := ExtractFilePath(ParamStr(0))+'SchemasMDFe\';
   ACBRMDFe1.Configuracoes.WebServices.TimeOut       := 60000;

   PathMensal := ACBrMDFe1.Configuracoes.Arquivos.GetPathMDFe(0);

   // Configurações -> Geral
   ACBrMDFe1.Configuracoes.Geral.FormaEmissao  := StrToTpEmis(bOK,IntToStr(qAUX.FieldByname('FORMAEMISSAO').AsInteger));
   ACBrMDFe1.Configuracoes.Arquivos.PathSalvar := PathMensal;

   // ACBrMDFe1.Configuracoes.Geral.Salvar        := true;

   ACBrMDFe1.Configuracoes.WebServices.AguardarConsultaRet      := 0;
   ACBrMDFe1.Configuracoes.WebServices.AjustaAguardaConsultaRet := False;
   ACBrMDFe1.Configuracoes.WebServices.Ambiente                 := StrToTpAmb(bOK, IntToStr(qAUX.FieldByname('AMBIENTE').AsInteger+1));
   ACBrMDFe1.Configuracoes.WebServices.IntervaloTentativas      := 0;
   ACBrMDFe1.Configuracoes.WebServices.Tentativas               := 5;
   ACBrMDFe1.Configuracoes.WebServices.UF                       := qAUX.FieldByname('WEBSERVICE').AsString;
//   ACBrMDFe1.Configuracoes.WebServices.TimeZoneConf.ModoDeteccao := tzPCN;
   ACBrMDFe1.Configuracoes.WebServices.Visualizar               := qAUX.FieldByname('VERMSG').AsString='S';

   // Garamte criação das pastas
   cPdf := ExtractFilePath(ParamStr(0))+'clientes\MDFe\'+soNUmero(qAUX.FieldByName('CNPJ').AsString)+'\'+FormatDateTime('yyyymm',Now)+'\MDFe\PDFs\';
   if not(DirectoryExists(cPdf)) then
      ForceDirectories(cPdf);

   {
   // Gera PDF na pasta referente ao mes do cliente
   cPdf := ExtractFilePath(ParamStr(0))+'clientes\MDFe\'+soNUmero(qAUX.FieldByName('CNPJ').AsString)+'\'+FormatDateTime('yyyymm',qREG.FieldByName('DATA').AsDateTime)+'\MDFe\PDFs\';
   if not(DirectoryExists(cPdf)) then
      ForceDirectories(cPdf);
   }

   ACBrMDFeDAMDFeRL1.MostraPreview := false;
   ACBRMDFe1.DAMDFe                := ACBrMDFeDAMDFeRL1;
   ACBrMDFe1.DAMDFE.PathPDF        := cPdf;
   // ACBrMDFe1.DAMDFE.        := cPdf;
   ACBrMDFe1.DAMDFE.MostraStatus   := false;
   ACBrMDFe1.DAMDFE.MostraSetup    := false;

   // DAMDFe
   if (ACBrMDFe1.DAMDFe <> nil) then begin
      cLogo := qAUX.FieldByName('LOGOMARCA').AsString;
      if(Copy(cLogo,1,1) = '.')then
         cLogo := ExtractFilePath(ParamStr(0))+Copy(cLogo,3,Length(cLogo));

      // ACBrMDFe1.DAMDFe.PathPDF        := PathMensal;
      ACBrMDFe1.DAMDFe.Logo           := cLogo;
      ACBrMDFe1.DAMDFe.MostraPreview  := false; // mudei aqui
      ACBrMDFe1.DAMDFe.TipoDAMDFe     := StrToTpImp(bOK, IntToStr(qAUX.FieldByName('TIPODACTE').AsInteger));
   end;
end;

function TMdfe.GetSql: String;
begin
   result := sql;
end;



function TMdfe.Registra(oReq: TJSONObject; qUSU: TSQLQUery;cDB:TSQLConnection): String;
var
   cCod,cMdf  : String;
   cAux,cData : String;
   cSit       : String;
   cUsuAlt    : String;
   nIt   : Integer;
   qAUX  : TSQLQuery;
   qREG  : TSQLQuery;
   TD    : TTransactionDesc;
   oMdfe : TMdfeJSON;
begin
   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;

   TD.TransactionID   := TDSSessionManager.GetThreadSession.Id;
   TD.IsolationLevel  := xilREADCOMMITTED;
   cDB.StartTransaction(TD);

   oMdfe := TMdfeJSON.Create;
   try
      try
         oMdfe.AsJson := oReq.ToString;

         if(SoNumero(oMdfe.Origem.Cep) = '') or (SoNumero(oMdfe.Destino.Cep) = '')then begin
            Result := '{"erro":"1","mensagem":"Os CEPs de origem e destino são necessário para o envio do MDFe."}';
            exit;
         end;

         if not VerificaLimiteEmissoes(qUSU) then begin
            Result := MensagemErroLimite();
            Exit;
         end;

         cCod  := iif((oMdfe.Codigo = '') or (oMdfe.Codigo = '0'),'0',oMdfe.Codigo);
         cAux  := cCod;
         cData := FormatDateTime('dd.mm.yyyy hh:MM:ss', now);

         for nIt := 0 to oMdfe.Itens.Count - 1 do begin
            qAUX.Close;
            qAUX.SQL.Text := 'SELECT COALESCE(CHAVECTE,'''') AS CHAVECTE,CTRC '+
            'FROM FRETES '+
            'WHERE CODIGO=0'+SoNumero(oMdfe.Itens[nIt].Codigo);
            sql := qAUX.SQL.Text;
            qAUX.Open;

            if(qAUX.FieldByName('CHAVECTE').AsString = '')then begin
               Result := '{"erro":"1","mensagem":"CTRC '+qAUX.FieldByName('CTRC').AsString+' não enviado para sefaz."}';
               exit;
            end;
         end;

         qREG.Close;
         qREG.SQL.Text := 'SELECT F.EMPRESA '+
         'FROM FRETES F '+
         'WHERE F.CODIGO=0'+SoNumero(oMdfe.Itens[oMdfe.Itens.Count-1].Codigo);
         sql := qREG.SQL.Text;
         qREG.Open;

         if(cCod = '0')then begin
            qAUX.Close;
            qAUX.SQL.Text := 'SELECT COALESCE(MAX(CODIGO),0)+1 AS COD,COALESCE(MAX(MDFE),0)+1 AS MDF '+
            'FROM FRETESMDF '+
            'WHERE CODIGO>=(SELECT MAX(CODIGO) FROM FRETESMDF)-100';
            sql := qAUX.SQL.Text;
            qAUX.Open;

            cCod := qAUX.FieldByName('COD').AsString;
            cMdf := qAUX.FieldByName('MDF').AsString;
            // pega o mdf inicial

            qAUX.Close;
            qAUX.SQL.Text := 'SELECT MDF_INICIAL FROM PARAMETROS WHERE EMPRESA=0'+qREG.FieldByName('EMPRESA').AsString;
            qAUX.Open;

            if (StrToNumI(cMdf) < qAUX.FieldByName('MDF_INICIAL').AsInteger) then
               cMdf := qAUX.FieldByName('MDF_INICIAL').AsString;

            cSit := 'P';
         end else begin

            qAUX.Close;
            qAUX.SQL.Text := 'SELECT DATA,STATUS,MDFE '+
            'FROM FRETESMDF '+
            'WHERE CODIGO=0'+cCod;
            sql := qAUX.SQL.Text;
            qAUX.Open;

            if(qAUX.Eof)then begin
               Result := '{"erro":"1","mensagem":"Registro não localizado"}';
               exit;
            end;

            cMdf  := qAUX.FieldByName('MDFE').AsString;
            cData := FormatDateTime('dd.mm.yyyy hh:MM:ss', qAUX.FieldByName('DATA').AsDateTime);
            cSit  := qAUX.FieldByName('STATUS').AsString;

            if (cCod <> '0') and (StrToNumI(qAUX.FieldByName('MDFE').AsString) = 0) then begin
               qAUX.Close;
               qAUX.SQL.Text := 'SELECT COALESCE(MAX(MDFE),0)+1 AS MDF '+
               'FROM FRETESMDF '+
               'WHERE CODIGO>=(SELECT MAX(CODIGO) FROM FRETESMDF)-100';
               sql := qAUX.SQL.Text;
               qAUX.Open;

               cMdf := qAUX.FieldByName('MDF').AsString;
            end;

         end;

         for nIt := 0 to oMdfe.Itens.Count - 1 do begin
            qREG.Close;
            qREG.SQL.Text := 'SELECT F.EMPRESA,F.CODIGO,F.CTRC,F.CTE,F.CHAVECTE AS CHAVE_CTE,F.QUANTIDADE AS CARGA,F.VALOR,'+
            'COALESCE(V.CAPKG,0)+COALESCE(V.CAR1CAPKG,0)+COALESCE(V.CAR2CAPKG,0)+COALESCE(V.CAR3CAPKG,0) AS CAPACIDADE,'+
            'F.QUANTIDADE '+
            'FROM FRETES F '+
            'LEFT JOIN VEICULO V ON V.CODIGO=F.VEICULO '+
            'WHERE F.CODIGO=0'+SoNumero(oMdfe.Itens[nIt].Codigo);
            sql := qREG.SQL.Text;
            qREG.Open;

            qAUX.Close;
            qAUX.SQL.Text := 'UPDATE OR INSERT INTO FRETESMDF (CODIGO,ITEM,MDFE,FRETE,EMPRESA,'+
            'STATUS,DATA,O_CEP,O_UF,O_CIDADE,D_CEP,D_UF,D_CIDADE,CARGA,CAPACIDADE,VALOR,OBS,PERCURSO,'+
            iif(cAux='0','USUARIO','USUALT')+') VALUES ('+
            '0'+cCod+','+
            '0'+IntToStr(nIt+1)+','+
            '0'+cMDF+','+
            '0'+oMdfe.Itens[nIt].Codigo+','+
            '0'+qREG.FieldByName('EMPRESA').AsString+','+
            QuotedStr(cSit)+','+
            QuotedStr(cData)+','+
            QuotedStr(soNumero(oMdfe.Origem.Cep))+','+
            QuotedStr(UpperCase(oMdfe.Origem.Uf))+','+
            QuotedStr(UpperCase(oMdfe.Origem.Cidade))+','+
            QuotedStr(soNumero(oMdfe.Destino.Cep))+','+
            QuotedStr(UpperCase(oMdfe.Destino.Uf))+','+
            QuotedStr(UpperCase(oMdfe.Destino.Cidade))+','+
            ValorSQL(qREG.FieldByName('CARGA').AsString)+','+
            ValorSQL(qREG.FieldByName('CAPACIDADE').AsString)+','+
            ValorSQL(qREG.FieldByName('VALOR').AsString)+','+
            QuotedStr(UpperCase(oMdfe.Observacoes))+','+
            QuotedStr(UpperCase(oMdfe.UfPercurso))+','+
            '0'+qUSU.FieldByName('CODIGO').AsString+')';
            sql := qAUX.sql.Text;
            qAUX.ExecSQL(False);
         end;

         qAUX.Close;
         qAUX.SQL.Text := 'DELETE FROM FRETESMDF WHERE CODIGO=0'+cCod+' '+
         'AND ITEM>0'+IntToStr(nIt);
         sql := qAUX.SQL.Text;
         GravaLog('SQL:'+sql);
         qAUX.ExecSQL(False);

         Result := '{"erro":0,"mensagem":"Registro '+iif(cAux = '0', 'incluído','atualizado')+' com sucesso!","codigo":"'+cCod+'"}';

         if cDB.InTransaction then
           cDB.Commit(TD);
      except on E: Exception do begin
         if cDB.InTransaction then
            cDB.Rollback(TD);

         GravaLog('ERRO AO GRAVAR MDFE ERRO:'+e.Message+' SQL:'+sql);

         Result := MensagemErroServer();
      end;
      end;
   finally
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(oMdfe);
   end;
end;

function TMdfe.Status(cDB: TSQLConnection): String;
var
   cMensagem         : String;
   ACBRMDfe1         : TACBrMDFe;
   ACBrMDFeDAMDFeRL1 : TACBrMDFeDAMDFeRL;
   qAUX              : TSQLQuery;
begin
   ACBRMDfe1         := TACBrMDFe.Create(Nil);
   ACBrMDFeDAMDFeRL1 := TACBrMDFeDAMDFeRL.Create(Nil);

   qAUX := TSQLQuery.Create(Nil);
   qAUX.SQLConnection := cDB;
   try
      if(not VerificaCertificado(qAUX))then begin
         Result := '{"erro":1,"mensagem":"Certificado ou senha do certificado não informado!"}';
         exit;
      end;

      cMensagem := '';
      try
         ConfiguraMDFe(qAUX,ACBRMDfe1,ACBrMDFeDAMDFeRL1);
      except on E: Exception do begin
         Result := '{"erro":1,"mensagem":"Ocorreu algum erro ao configurar o MDFE"}';
         GravaLog('Erro ao configurar MDFE STATUS:'+e.Message);
         exit;
      end;
      end;

      try
         ACBRMDfe1.WebServices.StatusServico.Executar;
      except on E: Exception do begin
         Result := '{"erro":1,"mensagem":"'+TrataMensagemExcept(e.Message)+'"}';
         GravaLog('Erro ao executar MDFE STATUS:'+e.Message);
         exit;
      end;
      end;

      Result := '{'+
      '"erro":0,'+
      '"status":"'+IntToStr(ACBRMDfe1.WebServices.StatusServico.cStat)+'",'+
      '"mensagem":"'+ACBRMDfe1.WebServices.StatusServico.xMotivo+'"'+
      '}';
   finally
      FreeAndNil(qAUX);
      FreeAndNil(ACBRMDfe1);
      FreeAndNil(ACBrMDFeDAMDFeRL1);
   end;
end;

function TMdfe.VerificaCertificado(qAUX: TSQLQuery): Boolean;
begin
  qAUX.SQL.Text := 'SELECT COALESCE(CERTIFICADO_CAMINHO,'''') AS CERTIFICADO_CAMINHO, '+
  'COALESCE(CERTIFICADO_SENHA,'''') AS CERTIFICADO_SENHA,COALESCE(AMBIENTE,0) AS AMBIENTE,'+
  'E.CNPJ,COALESCE(P.FORMAEMISSAO,''0'') AS FORMAEMISSAO, COALESCE(TIPODACTE,''0'') AS TIPODACTE,P.* '+
  'FROM PARAMETROS P '+
  'LEFT JOIN EMPRESA E ON E.CODIGO=1 '+
  'WHERE EMPRESA=1';
  sql := qAUX.SQL.Text;
  qAUX.Open;

  Result := true;
  if((qAUX.FieldByName('CERTIFICADO_CAMINHO').AsString = '') or
    (qAUX.FieldByName('CERTIFICADO_SENHA').AsString = '') or
    (not FileExists(qAUX.FieldByName('CERTIFICADO_CAMINHO').AsString)))then
     Result := False;
end;


function TMdfe.Email(oReq: TJSONObject; qUSU: TSQLQuery;
  cDB: TSQLConnection): String;
var
   cEmail   : String;
   cCod     : String;
   cCopia   : String;
   cPdf     : String;     
   cBase    : String;
   lEmail   : TStringList;
   lMsg     : TStringList;
   nMdfe    : Integer;

   ACBRMDfe1         : TACBrMDFe;
   ACBrMDFeDAMDFeRL1 : TACBrMDFeDAMDFeRL;
   ACBRMail : TACBRMAil;

   qREG : TSQLQuery;
   qAUX : TSQLQuery;
begin
   ACBRMDfe1         := TACBrMDFe.Create(Nil);
   ACBrMDFeDAMDFeRL1 := TACBrMDFeDAMDFeRL.Create(Nil);

   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;

   ACBRMail := TACBRMail.Create(Nil);

   lMsg   := TStringList.Create;
   lEmail := TStringList.Create;
   try
      if(not VerificaCertificado(qAUX))then begin
         Result := '{"erro":1,"mensagem":"Certificado ou senha do certificado não informado!"}';
         exit;
      end;

      try
         ConfiguraMDFe(qAUX,ACBRMDfe1,ACBrMDFeDAMDFeRL1);
      except on E: Exception do begin
         Result := '{"erro":1,"mensagem":"Ocorreu algum erro ao configurar o MDFE"}';
         GravaLog('Erro ao configurar MDFE STATUS:'+e.Message);
         exit;
      end;
      end;

      cCod   := GetValueJSONObject('codigo',oReq);
      cEmail := Trim(GetValueJSONObject('email',oReq));

      qREG.Close;
      qREG.SQL.Text := 'SELECT F.* '+
      'FROM FRETESMDF F '+
      'WHERE F.CODIGO=0'+cCod;
      sql := qREG.SQL.Text;
      qREG.Open;

      if(qREG.FieldByName('CHAVEMDFE').AsString = '')then begin
         Result := '{"erro":1,"mensagem":"Chave do MDFe inválida"}';
         Exit;
      end;

      ConfiguraMail(ACBRMail,qAUX);

      ACBRMDfe1.MAIL := ACBRMail;

      qAUX.Close;
      qAUX.SQLConnection := cDB;

      // define caminho base
      cBase := '.\clientes'+
               '\MDfe'+
               '\'+soNUmero(qUSU.FieldByName('CNPJ').AsString)+
               '\'+FormatDateTime('yyyymm',qREG.FieldByName('DATA').AsDateTime)+
               '\MDFe\';


      ACBRMDfe1.Manifestos.clear;
      ACBRMDfe1.Manifestos.LoadFromFile(cBase + qREG.FieldByName('CHAVEMDFE').AsString+'-mdfe.xml');

      qAUX.Close;
      qAUX.SQL.Text := 'SELECT P.*,E.* '+
      'FROM PARAMETROS P '+
      'LEFT JOIN EMPRESA E ON E.CODIGO=P.EMPRESA '+
      'WHERE P.EMPRESA=0'+qREG.FieldByName('EMPRESA').AsString;
      sql := qAUX.SQL.Text;
      qAUX.Open;

      lMsg.Add('Prezado Senhores,');
      lMsg.Add('');
      lMsg.Add('Segue em anexo arquivos eletronicos referente manifesto de conhecimentos.');
      lMsg.Add('');
      lMsg.Add('Atenciosamente');
      lMsg.Add('');
      lMsg.Add(qAUX.FieldByName('FANTASIA').AsString);

      if(qAUX.FieldByName('TELEFONE').AsString <> '')then
         lMsg.Add('Telefone:'+FormataFone(qAUX.FieldByName('TELEFONE').AsString));

      cPdf := ACBRMDfe1.Configuracoes.Arquivos.PathSalvar+'/PDFs/'+qREG.FieldByName('CHAVEMDFE').AsString+'-mdfe.pdf';
      if(FileExists(cPdf)) then
         lEmail.Add(cPdf);

      ACBRMDfe1.EnviarEmail(
      cEmail,
      'MDFe - '+qAUX.FieldByName('FANTASIA').AsString,
      lMsg,
      nil,
      lEmail);

      Result := '{"erro":0,"mensagem":"Email enviado com sucesso!"}';
   finally
      FreeAndNil(lEmail);
      FreeAndNil(lMsg);
      FreeAndNil(qAUX);
      FreeAndNil(qREG);

      FreeAndNil(ACBRMail);
      FreeAndNil(ACBRMDfe1);
      FreeAndNil(ACBrMDFeDAMDFeRL1);
   end;
end;


function TMdfe.Envia(oReq: TJSONObject; qUSU: TSQLQuery;
  cDB: TSQLConnection): String;
var
   cMensagem  : String;
   cCod       : String;
   cAux       : String;
   cPro       : String;
   cDest      : String;
   cEx        : String;
   cDownload  : String;
   cPathMdfe  : String;
   mdfeOk     : Boolean;
   ACBRMDfe1         : TACBrMDFe;
   ACBrMDFeDAMDFeRL1 : TACBrMDFeDAMDFeRL;
   qREG : TSQLQuery;
   qAUX : TSQLQuery;
begin
   ACBRMDfe1         := TACBrMDFe.Create(Nil);
   ACBrMDFeDAMDFeRL1 := TACBrMDFeDAMDFeRL.Create(Nil);

   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;
   try
      if not VerificaLimiteEmissoes(qUSU) then begin
         Result := MensagemErroLimite();
         Exit;
      end;

      if(not VerificaCertificado(qAUX))then begin
         Result := '{"erro":1,"mensagem":"Certificado ou senha do certificado não informado!"}';
         exit;
      end;

      cMensagem := '';
      try
         ConfiguraMdfe(qAUX,ACBRMDfe1,ACBrMDFeDAMDFeRL1);
      except on E: Exception do begin
         Result := '{"erro":1,"mensagem":"Ocorreu algum erro ao configurar o MDFE"}';
         GravaLog('Erro ao configurar MDFE STATUS:'+e.Message);
         exit;
      end;
      end;

      cCod      := SoNumero(GetValueJSONObject('codigo',oReq));
      cPathMdfe := qAUX.FieldByName('PATHMDFE').AsString;

      qREG.Close;
      qREG.SQL.Text := 'SELECT M.*,F.TOMADOR,F.MOTORISTA||'' ''||MT.NOME AS MOTORISTA,F.CTE,F.CTRC,F.CHAVECTE, '+
      'F.EMPRESA,F.VEICULO,F.PRODUTO,F.AVERBACAO,F.QUANTIDADE,F.VALOR,V.PLACA,M.USUARIO||'' ''||UI.LOGIN AS USUI, '+
			'M.USUALT||'' ''||UA.NOME AS USUA,M.USUENC||'' ''||UE.NOME AS USUE,F.PEDIDO,F.CIOT,F.DIASENTREGA,'+
      'F.VALOR1-F.SEGURO1-F.IRRF1-F.SEST-F.INSS-F.OUTROS1+F.DESCONTOS1+F.ICMS1+F.CLASSIFICACAO1+F.ESTADIA+F.PEDAGIO1 AS VRFRE '+
			'FROM FRETESMDF M '+
			'LEFT JOIN FRETES F ON F.CODIGO=M.FRETE '+
			'LEFT JOIN MOTORISTAS MT ON MT.CODIGO=F.MOTORISTA '+
			'LEFT JOIN VEICULO V ON V.CODIGO=F.VEICULO '+
			'LEFT JOIN USUARIOS UI ON UI.CODIGO=M.USUARIO '+
			'LEFT JOIN USUARIOS UA ON UA.CODIGO=M.USUALT '+
			'LEFT JOIN USUARIOS UE ON UE.CODIGO=M.USUENC '+
			'WHERE M.CODIGO=0'+cCod+' AND ITEM=(SELECT MAX(ITEM) FROM FRETESMDF WHERE CODIGO=0'+cCod+') '+
      // 'WHERE M.CODIGO=0'+cCod+' '+
      'ORDER BY ITEM';

      sql := qREG.SQL.Text;
      qREG.Open;

      if(qREG.Eof)then begin
         Result := '{"erro":1,"mensagem":"Manifesto não encontrado"}';
         exit;
      end;

      if (CidadeIBGE(qREG.FieldByName('O_CIDADE').AsString,qREG.FieldByName('O_UF').AsString,qAUX) = '') then begin
         Result := '{"erro":1,"mensagem":"Cidade origem não encontrada."}';
         exit;
      end;

      if (CidadeIBGE(qREG.FieldByName('D_CIDADE').AsString,qREG.FieldByName('D_UF').AsString,qAUX) = '') then begin
         Result := '{"erro":1,"mensagem":"Cidade destino não encontrada."}';
         exit;
      end;


      if(not FileExists('AmbienteTeste.txt'))then begin
         if(qREG.FieldByName('STATUS').AsString = 'E')then begin
            Result := '{"erro":1,"mensagem":"Esse MDFe já foi autorizado."}';
            exit;
         end;

         if(qREG.FieldByName('STATUS').AsString = 'Z')then begin
            Result := '{"erro":1,"mensagem":"Esse MDFe já foi encerrado."}';
            exit;
         end;

         if(qREG.FieldByName('STATUS').AsString = 'C')then begin
            Result := '{"erro":1,"mensagem":"Esse MDFe já foi cancelado."}';
            exit;
         end;
      end;


      cEx := '';
      // ACBrMDFe1.Configuracoes.WebServices.TimeZoneConf.TimeZoneStr:='-04:00';
      try
         try
            ACBrMDFe1.Manifestos.Clear;
            GerarMDFe(qREG,qAUX,qUSU,ACBrMDFe1,ACBrMDFeDAMDFeRL1);
            ACBrMDFe1.Manifestos.Items[0].GravarXML('', '');

            ACBrMDFe1.Enviar(StrToInt(cCod),false,true);

            if (ACBrMDFe1.WebServices.Enviar.Protocolo <> '') then begin
               qAUX.Close;
               qAUX.SQL.Text := 'UPDATE FRETESMDF SET '+
               'STATUS=''E'','+
               'CHAVEMDFE='+QuotedStr(Copy(ACBrMDFe1.Manifestos.Items[0].MDFe.infMDFe.ID, 5, 44))+','+
               'ULT_DOWNLOAD_PDF=CURRENT_TIMESTAMP,'+
               'PROTOCOLO_ENVIO='+QuotedStr(ACBrMDFe1.WebServices.Enviar.Protocolo)+' '+
               'WHERE CODIGO=0'+cCod;
               sql := qAUX.SQL.Text;
               qAUX.ExecSQL(False);

               mdfeOk := true;
            end;

            // ACBrMDFe1.Manifestos.ImprimirPDF;
            // ACBrMDFe1.Manifestos.Imprimir;
         except on E: Exception do  begin
            cEx:=e.message;
            if (Pos('DUPLICIDADE',UpperCase(cEx))<>0) and (ACBrMDFe1.Manifestos.Count>0) and (ACBrMDFe1.Manifestos.Items[0].MDFe.infMDFe.ID<>'') then begin
            // if (ACBrMDFe1.Manifestos.Count>0) and (ACBrMDFe1.Manifestos.Items[0].MDFe.infMDFe.ID<>'') then begin
               qAUX.Close;
               qAUX.SQL.Text := 'UPDATE FRETESMDF SET '+
               'STATUS=''E'',CHAVEMDFE='+QuotedStr(Copy(ACBrMDFe1.Manifestos.Items[0].MDFe.infMDFe.ID, 5, 44))+' '+
               'WHERE CODIGO=0'+cCod;
               sql := qAUX.SQL.Text;
               qAUX.ExecSQL(False);

               mdfeOk := true;

               qREG.Refresh;
            end;
         end;
         end;
      finally
         // ACBrMDFe1.Configuracoes.WebServices.TimeZoneConf.TimeZoneStr:='-03:00';
      end;

         // envia mdfe para averbação
      if mdfeOk then begin
         try
            if (SQLString('SELECT AVERBAATM FROM PARAMETROS WHERE EMPRESA=0'+qREG.FieldByName('EMPRESA').AsString,qAUX)='S') and
               (SQLString('SELECT SEGURADORA FROM CONFIG',qAUX)='AT&M') then
            // EnviaATMMDF(frmFretes.tREGCODIGO.AsInteger);
         except on e:exception do
            cEx := 'Não foi possível enviar AT&M.';
         end;
      end;

      qAUX.Close;
      qAUX.SQL.Text := 'UPDATE FRETESMDF SET STATUS_SEFAZ=0'+IntToStr(ACBrMDFe1.WebServices.Enviar.cStat)+' WHERE CODIGO=0'+cCod;
      sql := qAUX.SQL.Text;
      qAUX.ExecSQL(False);

      qREG.Refresh;

      cDownload := '';
      if(cEx = '')then begin
         cDownload := '/clientes/MDfe/'+soNUmero(qUSU.FieldByName('CNPJ').AsString)+'/'+FormatDateTime('yyyymm',qREG.FieldByName('DATA').AsDateTime)+'/MDFe/PDFs/'+qREG.FieldByName('CHAVEMDFE').AsString+'-mdfe.pdf';
         cAux      := '.\clientes\MDfe\'+soNUmero(qUSU.FieldByName('CNPJ').AsString)+'\'+FormatDateTime('yyyymm',qREG.FieldByName('DATA').AsDateTime)+'\MDFe\'+qREG.FieldByName('CHAVEMDFE').AsString+'-mdfe.pdf';
         cDest     := '.\clientes\MDfe\'+soNUmero(qUSU.FieldByName('CNPJ').AsString)+'\'+FormatDateTime('yyyymm',qREG.FieldByName('DATA').AsDateTime)+'\MDFe\PDfs\'+qREG.FieldByName('CHAVEMDFE').AsString+'-mdfe.pdf';

         if FileExists(cAux) then begin
            try
               MoveFile(Pchar(cAux),Pchar(cDest));
            except on E: Exception do
            end;
         end;

         Result := '{'+
         '"erro":0,'+
         '"mensagem":"MDFe enviado com sucesso",'+
         '"tpAmb":"'+TpAmbToStr(ACBrMDFe1.WebServices.Enviar.TpAmb)+'",'+
         '"verAplic":"'+ACBrMDFe1.WebServices.Enviar.verAplic+'",'+
         '"cStat":"'+IntToStr(ACBrMDFe1.WebServices.Enviar.cStat)+'",'+
         '"cUF":"'+IntToStr(ACBrMDFe1.WebServices.Enviar.cUF)+'",'+
         '"xMotivo":"'+ACBrMDFe1.WebServices.Enviar.xMotivo+'",'+
         '"xMsg":"'+ACBrMDFe1.WebServices.Enviar.Msg+'",'+
         '"Recibo":"'+ACBrMDFe1.WebServices.Enviar.Recibo+'",'+
         '"Protocolo":"'+ACBrMDFe1.WebServices.Enviar.Protocolo+'",'+
//          '"pdf":"'+cDownload+'",'+
         '"pdf":"",'+
         '"chave_mdfe":"'+qREG.FieldByName('CHAVEMDFE').AsString+'"'+
         '}';
      end else begin
         if(Pos('chMDFe Não Encerrada:',cEx) <> 0) and (AmbienteTeste())then begin
            cAux := Copy(cEx,Pos('chMDFe Não Encerrada:',cEx)+21,44);
            cPro := Copy(cEx,Pos('[NroProtocolo:',cEx)+14,15);

            EncerrarMDFe(cAux,cPro,ACBrMDFe1,qAUX);

            cEx := 'Havia MDFe não encerrado, encerramos automaticamente o MDFe:'+cAux+'. Tente enviar novamente. ';
         end;

         cEx := TrataMensagemExcept(cEx);

         Result := '{'+
         '"erro":2,'+
         '"mensagem":"'+cEx+'",'+
         '"tpAmb":"'+TpAmbToStr(ACBrMDFe1.WebServices.Enviar.TpAmb)+'",'+
         '"verAplic":"'+ACBrMDFe1.WebServices.Enviar.verAplic+'",'+
         '"cStat":"'+IntToStr(ACBrMDFe1.WebServices.Enviar.cStat)+'",'+
         '"cUF":"'+IntToStr(ACBrMDFe1.WebServices.Enviar.cUF)+'",'+
         '"xMotivo":"'+TrataMensagemExcept(ACBrMDFe1.WebServices.Enviar.xMotivo)+'",'+
         '"xMsg":"'+TrataMensagemExcept(ACBrMDFe1.WebServices.Enviar.Msg)+'",'+
         '"Recibo":"'+ACBrMDFe1.WebServices.Enviar.Recibo+'",'+
         '"Protocolo":"'+ACBrMDFe1.WebServices.Enviar.Protocolo+'"'+
         '}';
      end;
   finally
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(ACBRMDfe1);
      FreeAndNil(ACBrMDFeDAMDFeRL1);
   end;
end;

procedure TMdfe.GerarMdfe(qREG, qAUX, qUSU: TSQLQuery; ACBrMDFe1: TACBrMDFe;
  ACBrMDFeDAMDFeRL1: TACBrMDFeDAMDFeRL);
var
   cUF  : String;
   cVol : String;
   cAux : String;
   cCod : String;
   cCid : String;

   tKG  : Double;
   tVR  : Double;
   vrF  : Double;

   qtNF   : Integer;
   qtNFe  : Integer;
   tQTRAT : Integer;
   qtCte  : Integer;

   lsCte   : TStringList;
   ok      : boolean;
   frotaP  : boolean;

   qNF   : TSQLQuery;
   qVEI  : TSQLQuery;
   qEMP  : TSQLQuery;
   qAUX2 : TSQLQuery;
begin
   tQTRAT := 0;
   tKG    := 0.00;

   qNF    := TSQLQuery.Create(Nil);
   qEMP   := TSQLQuery.Create(Nil);
   qVEI   := TSQLQuery.Create(Nil);
   qAUX2  := TSQLQuery.Create(Nil);

   qNF.SQLConnection   := qREG.SQLConnection;
   qVEI.SQLConnection  := qREG.SQLConnection;
   qEMP.SQLConnection  := qREG.SQLConnection;
   qAUX2.SQLConnection := qREG.SQLConnection;
   try
      // qREG.Last;

      with ACBrMDFe1.Manifestos.Add.MDFe do begin
         //
         // Dados de Identificação do MDF-e
         //

         qEMP.Close;
         qEMP.SQL.Text := 'SELECT E.*,U.CODIGO AS COD_UF '+
         'FROM EMPRESA E '+
         'LEFT JOIN TAB_ESTADOS U ON U.SIGLA=E.ESTADO '+
         'WHERE E.CODIGO=0'+qREG.FieldByName('EMPRESA').AsString;
         sql := qEMP.SQL.Text;
         qEMP.Open;

         cUF     := qEMP.FieldByName('ESTADO').AsString;
         Ide.cUF := qEMP.FieldByName('COD_UF').AsInteger;

         // TpcnTipoAmbiente = (taProducao, taHomologacao);
         {
         case rgTipoAmb.ItemIndex of
          0: Ide.tpAmb := taProducao;
          1: Ide.tpAmb := taHomologacao;
         end;
         }

         Ide.tpAmb   := ACBrMDFe1.Configuracoes.WebServices.Ambiente;

         // TTpEmitenteMDFe = (teTransportadora, teTranspCargaPropria, teTranspCTeGlobalizado);
         // se o CNPJ da empresa for igual o CNPJ do Proprietario...
         Ide.tpEmit  := teTransportadora;
         Ide.modelo  := '58';  // codigo do modelo MDFe
         Ide.serie   := 1;
         Ide.nMDF    := StrToNumI(qREG.FieldByName('MDFE').AsString);
         Ide.cMDF    := DigitoVerificador(Ide.nMDF);  // Código Aleatório

         // TMDFeModal = ( moRodoviario, moAereo, moAquaviario, moFerroviario );
         Ide.modal   := moRodoviario;
         Ide.dhEmi   := Now;

         // TpcnTipoEmissao = (teNormal, teContingencia, teSCAN, teDPEC, teFSDA);
         Ide.tpEmis  := teNormal;

         // TpcnProcessoEmissao = (peAplicativoContribuinte, peAvulsaFisco, peAvulsaContribuinte, peContribuinteAplicativoFisco);
         Ide.procEmi := peAplicativoContribuinte;
         Ide.verProc := '1.0.0';  //Versão do seu sistema
         Ide.UFIni   := qREG.FieldByName('O_UF').AsString;
         Ide.UFFim   := qREG.FieldByName('D_UF').AsString;

         with Ide.infMunCarrega.Add do begin
            xMunCarrega := qREG.FieldByName('O_CIDADE').AsString;
            cMunCarrega := StrToIntDef(CidadeIBGE(qREG.FieldByName('O_CIDADE').AsString,qREG.FieldByName('O_UF').AsString,qAUX),0);
         end;

         // define percurso
         if (qREG.FieldByName('PERCURSO').AsString <> '') then begin
            cAux := Trim(qREG.FieldByName('PERCURSO').AsString)+',';

            while (cAux <> '') do begin
               Ide.infPercurso.Add.UfPer := Copy(cAux,1,2);
               cAux := Copy(cAux,4,Length(cAux));
            end
         end;

         //
         // Dados do Emitente
         //

         if (qEMP.FieldByname('TPTRANSP').AsInteger = 1) then
            Ide.tpEmit  := teTranspCargaPropria
         else if (qEMP.FieldByname('TPTRANSP').AsInteger = 2) then
            Ide.tpEmit  := teTranspCTeGlobalizado;

         Emit.CNPJCPF := SoNumero(qEMP.FieldByName('CNPJ').AsString);
         Emit.IE      := SoNumero(qEMP.FieldByName('IE').AsString);
         Emit.xNome   := qEMP.FieldByName('NOME').AsString;
         Emit.xFant   := qEMP.FieldByName('FANTASIA').AsString;

         Emit.EnderEmit.xLgr    := qEMP.FieldByName('ENDERECO').AsString;
         Emit.EnderEmit.nro     := qEMP.FieldByName('NUMERO').AsString;
         Emit.EnderEmit.xCpl    := qEMP.FieldByName('COMPLEMENTO').AsString;
         Emit.EnderEmit.xBairro := qEMP.FieldByName('BAIRRO').AsString;
         Emit.EnderEmit.cMun    := qEMP.FieldByName('CODIBGE').AsInteger;
         Emit.EnderEmit.xMun    := qEMP.FieldByName('CIDADE').AsString;
         Emit.EnderEmit.CEP     := StrToIntDef(SoNumero(qEMP.FieldByName('CODIBGE').AsString),0);
         Emit.EnderEmit.UF      := qEMP.FieldByName('ESTADO').AsString;
         Emit.EnderEmit.fone    := SoNumero(qEMP.FieldByName('TELEFONE').AsString);
         Emit.enderEmit.email   := SoNumero(qEMP.FieldByName('EMAIL').AsString);

         //
         //  Informações da Seguradora
         //
         qAUX.Close;
         if qREG.FieldByName('PEDIDO').AsInteger<>0 then
            qAUX.SQL.Text := 'SELECT S.*,F.NOME,F.CNPJ '+
            'FROM SEGUROS S '+
            'LEFT JOIN FORNECEDORES F ON F.CODIGO=S.TRANSAC '+
            'WHERE S.CODIGO=(SELECT P.SEGUROCOD FROM PEDIDOS P WHERE P.CODIGO=0'+qREG.FieldBYName('PEDIDO').AsString+') AND S.ATIVA=''S'' '
         else
            qAUX.SQL.Text := 'SELECT S.*,F.NOME,F.CNPJ '+
            'FROM SEGUROS S '+
            'LEFT JOIN FORNECEDORES F ON F.CODIGO=S.TRANSAC '+
            'WHERE S.ATIVA=''S'' ';
         sql := qAUX.SQL.Text;
         qAUX.Open;

         with seg.Add do begin
            if (qAUX.Eof) then begin
               xSeg  := '';
               CNPJ  := '';
               nApol := '';
               aver.Add.nAver := '';
//               xSeg  := 'SEGURADORA';
//               respSeg := rsEmitente;
//               CNPJ := '00000000000000';
//               nApol := '000000';
//               aver.Add.nAver := '';
            end else begin
               if (qAUX.FieldBYName('RESPONSAVEL').AsInteger = 5) or (qAUX.FieldBYName('CODIGO').AsString = '') then begin
                  respSeg := rsTomadorServico;
                  CNPJCPF := SoNumero(SQLString('SELECT CNPJ FROM CLIENTES WHERE CODIGO=0'+qREG.FieldByName('TOMADOR').AsString,qAUX2));
               end else begin
                  respSeg := rsEmitente;
                  CNPJCPF := SoNUmero(qEMP.FieldByName('CNPJ').AsString);
               end;

               if (qAUX.FieldBYName('CODIGO').AsString <> '') then begin
                  xSeg  := Copy(qAUX.FieldByName('NOME').AsString,1,30);
                  CNPJ  := qAUX.FieldByName('CNPJ').AsString;
                  nApol := qAUX.FieldByName('APOLICE').AsString;

                  if (respSeg=rsEmitente) and (nApol='') then
                     raise Exception.Create('Sem número de apólice');

                  qAUX2.Close;
                  qAUX2.SQL.Text := 'SELECT F.AVERBACAO '+
                  'FROM FRETESMDF M '+
                  'LEFT JOIN FRETES F ON F.CODIGO=M.FRETE '+
                  'WHERE M.CODIGO=0'+qREG.FieldByName('CODIGO').AsString+' AND COALESCE(AVERBACAO,'''')<>'''' ';
                  sql := qAUX2.SQl.Text;
                  qAUX2.Open;

                  while not(qAUX2.Eof) do begin
                     aver.Add.nAver := qAUX2.FieldByName('AVERBACAO').AsString;
                     qAUX2.Next;
                  end;
               end else begin
//                  xSeg  := '';
//                  CNPJ  := '';
//                  nApol := '';
//                  aver.Add.nAver := '';
               end;
            end;

            if (aver.Count = 0) then
               aver.Add.nAver := '99999';
         end;

         qVEI.Close;
         qVEI.SQL.Text := 'SELECT M.NOME,M.CPF,V.TARA,V.CAPKG,V.CAPM3,V.PLACA,V.PLACAUF,V.RENAVAN,V.TIPO,V.FROTA,'+
         'V.CAR1PLACA,V.CAR1PLACAUF,V.CAR1TARA,V.CAR1CAPKG,V.CAR1CAPM3,V.CAR2PLACA,V.CAR2PLACAUF,'+
         'V.CAR2TARA,V.CAR2CAPKG,V.CAR2CAPM3,V.CAR3PLACA,V.CAR3PLACAUF,V.CAR3TARA,V.CAR3CAPKG,V.CAR3CAPM3,'+
         'P.CNPJ,P.RNTRC,P.NOME AS NOMEP,P.IE,P.UF,V.RNTRC AS VEIRNTRC,V.CAR1RNTRC,'+
         'V.CAR2RNTRC,V.CAR3RNTRC,P.TPTRANSP '+
         'FROM VEICULO V '+
         'LEFT JOIN MOTORISTAS M ON M.CODIGO=V.MOTORISTA '+
         'LEFT JOIN PROPRIETARIOS P ON P.CODIGO=V.PROPRIETARIO '+
         'WHERE V.CODIGO=0'+qREG.FieldBYName('VEICULO').AsString;
         sql := qVEI.SQL.Text;
         qVEI.Open;

         //frota :=   qTP.FieldByname('FROTA').AsInteger=0;
         //Autor:Helio 29/05/23 OS 7889 Quando for frota propria não pode enviar infPag no xml
         frotaP     :=   qVEI.FieldByname('FROTA').AsInteger = 1;
         // frotaP     :=   qVEI.FieldByname('FROTA').AsInteger = 0;


         //rodo.RNTRC := SoNumero(qEMP.FieldByName('RNTRC').AsString);
         rodo.RNTRC := SoNumero(qVEI.FieldByName('RNTRC').AsString);

         if True then
            rodo.CIOT  := NumeroInicio(qREG.FieldByName('CIOT').AsString);

         if rodo.CIOT<>'' then begin
            with rodo.infANTT.infCIOT.New do begin
               CIOT    := qREG.FieldByName('CIOT').AsString;
               // acho que aqui é o proprietario
               CNPJCPF := SoNumero(qVEI.FieldByName('CNPJ').AsString);
            end;
         end;

         rodo.veicTracao.cInt  := qREG.FieldByName('VEICULO').AsString;
         rodo.veicTracao.placa := StringReplace(qVEI.FieldByName('PLACA').AsString,'-','',[rfReplaceAll]);
         rodo.veicTracao.UF    := qVEI.FieldByName('PLACAUF').AsString;
         rodo.veicTracao.tara  := qVEI.FieldByName('TARA').AsInteger;
         rodo.veicTracao.capKG := qVEI.FieldByName('CAPKG').AsInteger;
         rodo.veicTracao.capM3 := qVEI.FieldByName('CAPM3').AsInteger;

         if (qVEI.FieldByName('TIPO').AsInteger >= 1) and (qVEI.FieldByName('TIPO').AsInteger <= 4)then
            rodo.veicTracao.tpRod  := trCavaloMecanico
         else if (qVEI.FieldByName('TIPO').AsInteger = 5) then
            rodo.veicTracao.tpRod  := trTruck
         else if (qVEI.FieldByName('TIPO').AsInteger = 6) then
            rodo.veicTracao.tpRod  := trToco
         else
            rodo.veicTracao.tpRod  := trOutros;
         rodo.veicTracao.tpCar  := tcGraneleira;

         if (qVEI.FieldByName('FROTA').AsInteger = 0) then begin // mudei gabriel
            if (Length(SoNumero(qVEI.FieldByName('CNPJ').AsString)) = 11) or (qVEI.FieldByname('TPTRANSP').AsInteger = 2) then
               Ide.tpTransp:= ttTAC
            else begin
               if (qVEI.FieldByname('TPTRANSP').AsInteger = 3) then
                  Ide.tpTransp:= ttCTC
               else
                  Ide.tpTransp:= ttETC;
            end;
         end;

         // nao é informação da empresa, mas do proprietario
         with rodo.infANTT do begin
            RNTRC := SoNumero(qEMP.FieldByName('RNTRC').AsString);

            with infContratante.Add do begin
               CNPJCPF := SoNumero(qVEI.FieldByName('CNPJ').AsString);      // contratante, que é a transportadora e no caso de frota propria pode ser o mesmo emitente.
               CNPJCPF := Emit.CNPJCPF;  // pegando pelo cadastro do veiculo
            end;
         end;

         // proprietarios frota terceiros
         if (qVEI.FieldByName('FROTA').AsInteger <> 1) then begin
            rodo.veicTracao.prop.CNPJCPF := SoNumero(qVEI.FieldByName('CNPJ').AsString);
            rodo.veicTracao.prop.RNTRC   := SoNumero(qVEI.FieldByName('VEIRNTRC').AsString);
            rodo.veicTracao.prop.xNome   := qVEI.FieldByName('NOMEP').AsString;

            if Pos('ISENT',qVEI.FieldByName('IE').AsString)<>0 then
               rodo.veicTracao.prop.IE   := 'ISENTO'
            else
               rodo.veicTracao.prop.IE   := SoNumero(qVEI.FieldByName('IE').AsString);

            rodo.veicTracao.prop.UF     := qVEI.FieldByName('UF').AsString;
            rodo.veicTracao.prop.tpProp := tpTACIndependente;
         end;

         with rodo.veicTracao.condutor.Add do begin
            xNome := qVEI.FieldByName('NOME').AsString;
            CPF   := SoNumero(qVEI.FieldByName('CPF').AsString);
         end;

         if (Trim(qVEI.FieldByName('CAR1PLACA').AsString) <> '')  then begin
            with rodo.veicReboque.Add do begin
               cInt  := qREG.FieldByName('VEICULO').AsString+'-1';
               placa := StringReplace(qVEI.FieldByName('CAR1PLACA').AsString,'-','',[rfReplaceAll]);
               uf    := qVEI.FieldByName('CAR1PLACAUF').AsString;
               tara  := qVEI.FieldByName('CAR1TARA').AsInteger;
               capKG := qVEI.FieldByName('CAR1CAPKG').AsInteger;
               capM3 := qVEI.FieldByName('CAR1CAPM3').AsInteger;
               prop.CNPJCPF := SoNumero(qVEI.FieldByName('CNPJ').AsString);
               prop.RNTRC   := SoNumero(qVEI.FieldByName('CAR1RNTRC').AsString);
               prop.xNome   := qVEI.FieldByName('NOMEP').AsString;

               if Pos('ISENT',qVEI.FieldByName('IE').AsString)<>0 then
                  prop.IE  := 'ISENTO'
               else
                  prop.IE  := SoNumero(qVEI.FieldByName('IE').AsString);

               prop.UF := qVEI.FieldByName('UF').AsString;
            end;
         end;

         if (Trim(qVEI.FieldByName('CAR2PLACA').AsString) <> '') then begin
            with rodo.veicReboque.Add do begin
               cInt  := qREG.FieldByName('VEICULO').AsString+'-2';
               placa := StringReplace(qVEI.FieldByName('CAR2PLACA').AsString,'-','',[rfReplaceAll]);
               uf    := qVEI.FieldByName('CAR2PLACAUF').AsString;
               tara  := qVEI.FieldByName('CAR2TARA').AsInteger;
               capKG := qVEI.FieldByName('CAR2CAPKG').AsInteger;
               capM3 := qVEI.FieldByName('CAR2CAPM3').AsInteger;

               prop.CNPJCPF := SoNumero(qVEI.FieldByName('CNPJ').AsString);
               prop.RNTRC   := SoNumero(qVEI.FieldByName('CAR2RNTRC').AsString);
               prop.xNome   := qVEI.FieldByName('NOMEP').AsString;

               if Pos('ISENT',qVEI.FieldByName('IE').AsString)<>0 then
                  prop.IE    := 'ISENTO'
               else
                  prop.IE    := SoNumero(qVEI.FieldByName('IE').AsString);

               prop.UF := qVEI.FieldByName('UF').AsString;
            end;
         end;

         if (Trim(qVEI.FieldByName('CAR3PLACA').AsString) <> '') then begin
            with rodo.veicReboque.Add do begin
               cInt  := qREG.FieldByName('VEICULO').AsString+'-3';
               placa := StringReplace(qVEI.FieldByName('CAR3PLACA').AsString,'-','',[rfReplaceAll]);
               uf    := qVEI.FieldByName('CAR3PLACAUF').AsString;
               tara  := qVEI.FieldByName('CAR3TARA').AsInteger;
               capKG := qVEI.FieldByName('CAR3CAPKG').AsInteger;
               capM3 := qVEI.FieldByName('CAR3CAPM3').AsInteger;

               prop.CNPJCPF := SoNumero(qVEI.FieldByName('CNPJ').AsString);
               prop.RNTRC   := SoNumero(qVEI.FieldByName('CAR3RNTRC').AsString);
               prop.xNome   := qVEI.FieldByName('NOMEP').AsString;

               if Pos('ISENT',qVEI.FieldByName('IE').AsString)<>0 then
                  prop.IE := 'ISENTO'
               else
                  prop.IE := SoNumero(qVEI.FieldByName('IE').AsString);

              prop.UF := qVEI.FieldByName('UF').AsString;
            end;
         end;

         qtNF  := 0;
         qtNFe := 0;

         // qREG.First;

         qAUX.Close;
         qAUX.SQL.Text := 'SELECT M.*,F.MOTORISTA||'' ''||MT.NOME AS MOTORISTA,F.CTE,F.CTRC,F.CHAVECTE,F.CIOT,'+
         'F.QUANTIDADE,F.VALOR,V.PLACA '+
         'FROM FRETESMDF M '+
         'LEFT JOIN FRETES F ON F.CODIGO=M.FRETE '+
         'LEFT JOIN MOTORISTAS MT ON MT.CODIGO=F.MOTORISTA '+
         'LEFT JOIN VEICULO V ON V.CODIGO=F.VEICULO '+
         'WHERE M.CODIGO=0'+qREG.FieldByName('CODIGO').AsString+' AND LEFT(F.MODELO,2)=''CT'' '+  // lista só quando é CT,
         'ORDER BY D_UF,D_CIDADE';
         sql := qAUX.SQl.Text;
         qAUX.Open;

         qtCte     := ContaReg(qAUX);
         rodo.CIOT := qAUX.FieldByName('CIOT').AsString;

         qAUX.First;
         while not(qAUX.Eof) do begin
            cVol := SQLString('SELECT VOLUME FROM PRODUTOS WHERE CODIGO=0'+qREG.FieldByName('PRODUTO').AsString,qAUX2);

            with infDoc.infMunDescarga.new do begin
               xMunDescarga := qAUX.FieldByName('D_CIDADE').AsString;
               cMunDescarga := StrtoIntDef(CidadeIBGE(qREG.FieldByName('D_CIDADE').AsString,qREG.FieldByName('D_UF').AsString,qAUX2),0);

               cCod := ' ';
               cCid := qAUX.FieldByName('D_UF').AsString+' '+qAUX.FieldByName('D_CIDADE').AsString;

               while not(qAUX.Eof) and (qAUX.FieldByName('D_UF').AsString+' '+qAUX.FieldByName('D_CIDADE').AsString=cCid) do begin
                  with infCTe.new do begin
                     chCTe := qAUX.FieldByName('CHAVECTE').asString;
                     cCod  := cCod+qAUX.FieldByName('FRETE').asString+',';

                     // Informações das Unidades de Transporte (Carreta/Reboque/Vagão)
                     with infUnidTransp.new do begin

                        //TpcnUnidTransp = ( utRodoTracao, utRodoReboque, utNavio, utBalsa, utAeronave, utVagao, utOutros );
                        if Trim(qVEI.FieldByName('CAR1PLACA').AsString)='' then begin
                           tpUnidTransp := utRodoReboque;
                           idUnidTransp := '01';  // Rodoviário  Tração
                        end else begin
                           tpUnidTransp := utRodoReboque;
                           idUnidTransp := '02';  // Rodoviário  Reboque
                        end;

                        with lacUnidTransp.new do begin
                            nLacre := '1';
                        end;

                          // Informações das Unidades de carga (Containeres/ULD/Outros)
                        with infUnidCarga.Add do begin
                           // TpcnUnidCarga  = ( ucContainer, ucULD, ucPallet, ucOutros );
                           tpUnidCarga := ucOutros;
                           idUnidCarga := iif(cVol<>'',cVol,'GRANEL');
                           with lacUnidTransp.new do begin
                               nLacre := '1'
                           end;
                           qtdRat := 1.0;
                        end;
                     end;
                  end; // fim do with infCTe.Add

                  tKG := tKG+qAUX.FieldByName('CARGA').AsFloat;
                  qAUX.Next;
               end;

               if Trim(cCod)='' then
                  raise Exception.Create('Nenhum conhecimento encontrado.');

               cCod[Length(cCod)]:=')';

               // nfe eletronica
               qNF.Close;
               qNF.SQL.Text := 'SELECT NF.*,R.NOME,R.CNPJ,R.UF,F.CODIGO AS CODFRETE '+
               'FROM FRETES F '+
               'LEFT JOIN FRETENOTAS NF ON NF.CODIGO=F.CODIGO '+
               'LEFT JOIN NOMESPEDIDO(F.REMETENTE,F.REMQUEM) AS R ON R.CODIGO=F.REMETENTE '+
               'WHERE F.CODIGO IN ('+cCod+' AND LEFT(F.MODELO,2)=''NF'' ';  // lista só quando é NF,
               qNF.Open;

               while not(qNF.Eof) and (infDoc.infMunDescarga[0].infCTe.Count = 0) do begin
                  qAUX.Close;
                  qAUX.SQl.Text := 'SELECT * '+
                  'FROM FRETESLACRE WHERE CODIGO=0'+qNF.FieldByName('CODFRETE').AsString+' '+
                  'AND NOTA=0'+qNF.FieldByName('NUMERO').AsString;
                  sql := qAUX.SQL.Text;
                  qAUX.Open;

                  if (qNF.FieldByName('CHAVE').AsString <> '') then begin
                     with infNFe.Add do begin
                        chNfe := qNF.FieldByName('CHAVE').AsString;

                        with infUnidTransp.Add do begin
                           //TpcnUnidTransp = ( utRodoTracao, utRodoReboque, utNavio, utBalsa, utAeronave, utVagao, utOutros );
                           if Trim(qVEI.FieldByName('CAR1PLACA').AsString)='' then begin
                              tpUnidTransp := utRodoReboque;
                              idUnidTransp := '01';  // Rodoviário  Tração
                           end else begin
                              tpUnidTransp := utRodoReboque;
                              idUnidTransp := '02';  // Rodoviário  Reboque
                           end;

                           // Informações das Unidades de carga (Containeres/ULD/Outros)
                           with infUnidCarga.Add do begin
                              // TpcnUnidCarga  = ( ucContainer, ucULD, ucPallet, ucOutros );
                              tpUnidCarga := ucOutros;
                              idUnidCarga := iif(cVol<>'',cVol,'GRANEL');
                              with lacUnidTransp.Add do begin
                                 if trim(qAUX.FieldByName('LACRE').AsString)='' then
                                    nLacre := '1'
                                 else
                                    nLacre := qAUX.FieldByName('LACRE').AsString;
                              end;
                              qtdRat := 1.0;
                           end;
                           qtdRat := 1.0;
                        end;
                     end;
                  end;

                  tVR := tVR+qNF.FieldByName('VRMERCADORIA').AsFloat;
                  qNF.Next;
               end;
            end;
         end;
         //qtNFe:=infDoc.infMunDescarga.Items[0].infNFe.Count-1;
         qtNFe:=0;

         // qREG.Last;

         //Informações OPCIONAIS sobre o produto predominante
         qAUX.Close;
         qAUX.SQL.Text := 'SELECT P.TIPOCARGA,P.NOME,EAN,NCM,O_CIDADE,D_CIDADE '+
         'FROM FRETESMDF M '+
         'LEFT JOIN FRETES F ON F.CODIGO=M.FRETE '+
         'LEFT JOIN PRODUTOS P ON P.CODIGO=F.PRODUTO '+
         'WHERE M.CODIGO=0'+qREG.FieldByName('CODIGO').AsString;
         sql := qAUX.SQL.Text;
         qAUX.Open;

         // Inicio dos Campos Novos Descomentar para fazer os testes
         prodPred.tpCarga := StrToTCarga(ok,FormatFloat('00',StrToNumI(NumeroInicio(qAUX.FieldByName('TIPOCARGA').AsString))));
         prodPred.xProd   := qAUX.FieldByName('NOME').AsString;
         prodPred.cEAN    := qAUX.FieldByName('EAN').AsString;
         prodPred.NCM     := SoNumero(qAUX.FieldByName('NCM').AsString);

         // Informações do Local de Carregamento
         // Informar somente quando MDF-e for de carga lotação
         prodPred.infLocalCarrega.CEP       := StrToNumI(SoNumero(qREG.FieldByName('O_CEP').AsString));
         prodPred.infLocalCarrega.latitude  := 0;
         prodPred.infLocalCarrega.longitude := 0;

         // Informações do Local de Descarregamento
         // Informar somente quando MDF-e for de carga lotação
         prodPred.infLocalDescarrega.CEP       := StrToNumI(SoNumero(qREG.FieldByName('D_CEP').AsString));
         prodPred.infLocalDescarrega.latitude  := 0;
         prodPred.infLocalDescarrega.longitude := 0;


         // pagamentos
         qAUX.Close;
         qAUX.SQL.Text := 'SELECT F.APAGAR,P.RB1_CODIGO,P.RB1_AGENCIA,SUM(F.VALOR1) AS VRF,'+
         'SUM(F.SEGURO1+F.DESCONTOS1+F.OUTROS1) AS VRDES,SUM(F.IRRF1+F.INSS+F.SEST) AS IMP,'+
         'SUM(F.PEDAGIO1) AS PEDAGIO '+
         'FROM FRETESMDF M '+
         'LEFT JOIN FRETES F ON F.CODIGO=M.FRETE '+
         'LEFT JOIN VEICULO V ON V.CODIGO=F.VEICULO '+
         'LEFT JOIN PROPRIETARIOS P ON P.CODIGO=V.PROPRIETARIO '+
         'WHERE M.CODIGO=0'+qREG.FieldByName('CODIGO').AsString+' '+
         'GROUP BY 1,2,3';
         sql := qAUX.SQL.Text;
         qAUX.Open;

         if not(frotaP) and (qAUX.FieldByName('RB1_CODIGO').AsString<>'') and (qAUX.FieldByName('RB1_AGENCIA').AsString<>'') then begin
            with rodo.infANTT.infPag.New do begin
               //xNome         := 'Nome do Responsavel pelo Pagamento';
               idEstrangeiro := '';
               if (SoNumero(qUSU.FieldByName('CNPJ').AsString)=Emit.CNPJCPF) or (Trim(qUSU.FieldByName('CNPJ').AsString) = '') then begin
                  xNome         := Emit.xNome;
                  CNPJCPF       := Emit.CNPJCPF;
               end else begin
                  CNPJCPF       := SoNumero(qUSU.FieldByName('CNPJ').AsString);
                  xNome         := SQLString('SELECT NOME FROM CLIENTES WHERE CNPJ='+QuotedStr(qUSU.FieldByName('CNPJ').AsString),qAUX2);
               end;

               vContrato := qAUX.FieldByName('VRF').AsFloat;
               if qAUX.FieldByName('APAGAR').AsString <> '0' then
                  indPag    := ipVista
               else
                  indPag    := ipPrazo;

               if qAUX.FieldByName('PEDAGIO').AsFloat<>0.00 then begin
                  with rodo.infANTT.infPag[0].Comp.New do begin
                     tpComp := tcValePedagio;
                     vComp  := qAUX.FieldByName('PEDAGIO').AsFloat;
                     xComp  := '';
                  end;
               end;

               if qAUX.FieldByName('IMP').AsFloat<>0.00 then begin
                  with rodo.infANTT.infPag[0].Comp.New do begin
                     tpComp := tcImpostos;
                     vComp  := qAUX.FieldByName('IMP').AsFloat;
                     xComp  := '';
                  end;
               end;

               if qAUX.FieldByName('VRDES').AsFloat<>0.00 then begin
                  with rodo.infANTT.infPag[0].Comp.New do begin
                     tpComp := tcDespesas;
                     vComp  := qAUX.FieldByName('VRDES').AsFloat;
                     xComp  := '';
                  end;
               end;

               vrF := qAUX.FieldByName('VRF').AsFloat-
                      qAUX.FieldByName('IMP').AsFloat-
                      qAUX.FieldByName('PEDAGIO').AsFloat-
                      qAUX.FieldByName('VRDES').AsFloat;

               if vrF<>0.00 then begin
                  with rodo.infANTT.infPag[0].Comp.New do begin
                     tpComp := tcOutros;
                     vComp  := vrF;
                     xComp  := 'Outros custos do Frete';
                  end;
               end;

               //ver se tem a prazo e parcelado.
               if rodo.infANTT.infPag[0].indPag = ipPrazo then begin
                  with rodo.infANTT.infPag[0].infPrazo.New do begin
                     nParcela := 1;
                     dVenc    := qREG.FieldByName('DATA').AsDateTime+qREG.FieldByName('DIASENTREGA').AsInteger;

                     if dVenc<Ide.dhEmi then
                        dVEnc:=Ide.dhEmi;

                     vParcela := qAUX.FieldByName('VRF').AsFloat;
                  end;
               end;

               // CNPJ da Instituição de pagamento Eletrônico do Frete
               // EFRETE
               if qAUX.FieldByName('APAGAR').AsString='2' then
                  rodo.infANTT.infPag[0].infBanc.CNPJIPEF := '01648418000172';

               //if rodo.infANTT.infPag[0].infBanc.CNPJIPEF = '' then begin
               if not(frotaP) then begin
                  rodo.infANTT.infPag[0].infBanc.codBanco   := qAUX.FieldByName('RB1_CODIGO').AsString;
                  rodo.infANTT.infPag[0].infBanc.codAgencia := qAUX.FieldByName('RB1_AGENCIA').AsString;
               end;
            end;
         end;


         if qtNFe<>0 then
            tot.qNFe  := qtNFe
         else
            tot.qCTe  := qtCte;

         tot.vCarga := RoundTO(tVR,-3);
         tot.cUnid  := uKG;
         tot.qCarga := RoundTo(tKG,-3);

         infAdic.infCpl     := qREG.FieldByName('OBS').AsString;
         infAdic.infAdFisco := '';

         // dados do responsavel técnico
         qAUX.Close;
         qAUX.SQL.Text := 'SELECT * FROM RESPTECNICO';
         sql := qAUX.SQL.Text;
         qAUX.OPen;

         infRespTec.CNPJ     := qAUX.FieldByName('CNPJ').AsString;
         infRespTec.xContato := qAUX.FieldByName('NOME').AsString;
         infRespTec.email    := qAUX.FieldByName('EMAIL').AsString;
         infRespTec.fone     := SoNumero(qAUX.FieldByName('TELEFONE').AsString);
      end;

      ACBrMDFe1.Manifestos.GerarMDFe;
   finally
      FreeAndNil(qNF);
      FreeAndNil(qVEI);
      FreeAndNil(qEMP);
      FreeAndNil(qAUX2);
   end;
end;

function TMdfe.Download(oReq: TJSONObject; qUSU: TSQLQuery;
  cDB: TSQLConnection): String;
var
   cCod       : String;
   cMensagem  : String;
   cFile      : String;
   cBase      : String;
   cAux       : String;
   cDest      : String;
   cDownload  : String;
   nCte       : Integer;
   ACBRMDfe1         : TACBrMDFe;
   ACBrMDFeDAMDFeRL1 : TACBrMDFeDAMDFeRL;
   qREG : TSQLQuery;
   qAUX : TSQLQuery;
begin
   ACBRMDfe1         := TACBrMDFe.Create(Nil);
   ACBrMDFeDAMDFeRL1 := TACBrMDFeDAMDFeRL.Create(Nil);

   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;
   try
      if(not VerificaCertificado(qAUX))then begin
         Result := '{"erro":1,"mensagem":"Certificado ou senha do certificado não informado!"}';
         exit;
      end;

      cCod := GetValueJSONObject('codigo',oReq);

      qREG.Close;
      qREG.SQL.Text := 'SELECT M.* '+
      'FROM FRETESMDF M '+
      'WHERE M.CODIGO=0'+cCod;
      sql := qREG.SQL.Text;
      qREG.Open;

      if(qREG.FieldByName('CHAVEMDFE').AsString = '')then begin
         Result := '{"erro":1,"mensagem":"Chave do MDFe inválida"}';
         Exit;
      end;

      // define caminho base
      cBase := '.\clientes'+
               '\MDfe'+
               '\'+soNUmero(qUSU.FieldByName('CNPJ').AsString)+
               '\'+FormatDateTime('yyyymm',qREG.FieldByName('DATA').AsDateTime)+
               '\MDFe\';

      cAux  := cBase + 'PDFs\'+qREG.FieldByName('CHAVEMDFE').AsString+'-mdfe.pdf';

      cDownload := '/clientes/MDfe/'+soNUmero(qUSU.FieldByName('CNPJ').AsString)+'/'+FormatDateTime('yyyymm',qREG.FieldByName('DATA').AsDateTime)+'/MDFe/PDFs/'+qREG.FieldByName('CHAVEMDFE').AsString+'-mdfe.pdf';
      if(qREG.FieldByName('ULT_DOWNLOAD_PDF').AsDateTime < IncDay(Now,-1)) or (not FileExists('.'+cDownload))then begin // verifica se precisa gerar novamente o PDF

         cMensagem := '';
         try
            ConfiguraMDFe(qAUX,ACBRMDfe1,ACBrMDFeDAMDFeRL1);
         except on E: Exception do begin
            Result := '{"erro":1,"mensagem":"Ocorreu algum erro ao configurar o MDFE"}';
            exit;
         end;
         end;

         cAux  := cBase + qREG.FieldByName('CHAVEMDFE').AsString+'-mdfe.xml';
         if not FileExists(cAux) then begin
            Result := '{"erro":1,"mensagem":"XML não encontrado"}';
            exit;
         end;
                                        
         cFile := cBase + '\'+qREG.FieldByName('CHAVEMDFE').AsString+'-mdfe.xml';

         // cFile := ACBRMDfe1.Configuracoes.Arquivos.PathSalvar+qREG.FieldByName('CHAVEMDFE').AsString+'-mdfe.xml';

         try
            ACBRMDfe1.Manifestos.LoadFromFile(cFile,true);

            AdicionarNota(qREG,ACBRMDfe1);

            ACBrMDFeDAMDFERL1.Cancelada := qREG.FieldByName('STATUS').AsString = 'C';
            ACBrMDFeDAMDFeRL1.Encerrado := qREG.FieldByName('STATUS').AsString = 'Z';

            ACBRMDfe1.Manifestos.ImprimirPDF;

            GravaLog('Gerou');

            cAux      := cBase + qREG.FieldByName('CHAVEMDFE').AsString+'-mdfe.pdf';
            cDest     := cBase + 'PDfs\'+qREG.FieldByName('CHAVEMDFE').AsString+'-mdfe.pdf';

            if FileExists(cAux) then begin
               try
                  MoveFile(Pchar(cAux),Pchar(cDest));
               except on E: Exception do
               end;
            end;
         except on E: Exception do begin
            Result := '{"erro":1,"mensagem":"Ocorreu um erro ao tentar gerar download"}';
            GravaLog('Erro ao tentar gerar download erro:'+e.Message);
            Exit;
         end;
         end;
      end;

      qAUX.Close;
      qAUX.SQL.Text := 'UPDATE FRETESMDF SET ULT_DOWNLOAD_PDF=CURRENT_TIMESTAMP WHERE CODIGO=0'+cCod;
      sql := qAUX.SQL.Text;
      qAUX.ExecSQL(False);

      Result := '{'+
      '"erro":0,'+
      '"mensagem":"PDF gerado com sucesso",'+
      '"pdf":"'+cDownload+'"'+
      '}';
   finally
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(ACBRMDfe1);
      FreeAndNil(ACBrMDFeDAMDFeRL1);
   end;
end;
procedure TMdfe.AdicionarNota(qREG: TSQLQuery; ACBrMDFe1: TACBrMDFe);
var
   qAUX : TSQLQuery;
   qFRE : TSQLQuery;
   qLAC : TSQLQuery;   
begin
   qAUX := TSQLQuery.Create(Nil);
   qFRE := TSQLQuery.Create(Nil);       
   
   qAUX.SQLConnection := qREG.SQLConnection;
   qFRE.SQLConnection := qREG.SQLConnection;

   try    
      qAUX.Close;
      qAUX.SQL.Text := 'SELECT FRETE FROM FRETESMDF WHERE CODIGO=0'+qREG.FieldByName('CODIGO').AsString;
      sql := qAUX.SQL.Text;
      qAUX.Open;
     
      while not(qAUX.Eof) do begin
         qFRE.Close;
         qFRE.SQL.Text := 'SELECT NF.*,R.NOME,R.CNPJ,R.UF,F.CODIGO AS CODFRETE '+
         'FROM FRETES F '+
         'LEFT JOIN FRETENOTAS NF ON NF.CODIGO=F.CODIGO '+
         'LEFT JOIN NOMESPEDIDO(F.REMETENTE,F.REMQUEM) AS R ON R.CODIGO=F.REMETENTE '+
         'WHERE F.CODIGO=0'+qAUX.FieldByName('FRETE').AsString;
         sql := qFRE.SQL.Text;
         qFRE.Open;
     
         with ACBrMDFe1.Manifestos[0].MDFe.infDoc.infMunDescarga.Items[0] do begin
            while not(qFRE.Eof) do begin                
               if qFRE.FieldByName('CHAVE').AsString<>'' then begin
                  with infNFe.Add do begin
                     chNfe := qFRE.FieldByName('CHAVE').AsString;
                  end;
               end;
               
               qFRE.Next;
            end;
         end;    
     
         qAUX.Next;
      end;
   finally                       
      FreeAndNil(qAUX);
      FreeAndNil(qFRE);
   end;
end;

function TMdfe.Cancela(oReq: TJSONObject; qUSU: TSQLQuery;
  cDB: TSQLConnection): String;
var
   cCod,cJus  : String;
   cMensagem  : String;
   cFile,cUf  : String;

   ACBRMDfe1         : TACBrMDFe;
   ACBrMDFeDAMDFeRL1 : TACBrMDFeDAMDFeRL;

   qREG : TSQLQuery;
   qAUX : TSQLQuery;
begin
   ACBRMDfe1         := TACBrMDFe.Create(Nil);
   ACBrMDFeDAMDFeRL1 := TACBrMDFeDAMDFeRL.Create(Nil);

   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;
   try
      if(not VerificaCertificado(qAUX))then begin
         Result := '{"erro":1,"mensagem":"Certificado ou senha do certificado não informado!"}';
         exit;
      end;

      cCod := GetValueJSONObject('codigo',oReq);
      cJus := Trim(GetValueJSONObject('justificativa',oReq));

      qREG.Close;
      qREG.SQL.Text := 'SELECT M.* '+
      'FROM FRETESMDF M '+
      'WHERE M.CODIGO=0'+cCod;
      sql := qREG.SQL.Text;
      qREG.Open;

      if(qREG.FieldByName('CHAVEMDFE').AsString = '')then begin
         Result := '{"erro":1,"mensagem":"Chave do MDFe inválida"}';
         Exit;
      end;

      cMensagem := '';
      try
         ConfiguraMdfe(qAUX,ACBRMDfe1,ACBrMDFeDAMDFeRL1);
      except on E: Exception do begin
         Result := '{"erro":1,"mensagem":"Ocorreu algum erro ao configurar o MDFE"}';
         GravaLog('Erro ao configurar MDFE CANCELAR:'+e.Message);
         exit;
      end;
      end;


      if (cJus = '') then begin
         Result := '{"erro":1,"mensagem":"Justificativa não informada."}';
         exit;
      end;

      if not FileExists(ACBRMDfe1.Configuracoes.Arquivos.PathSalvar+qREG.FieldByName('CHAVEMDFE').AsString+'-mdfe.xml') then begin
         Result := '{"erro":1,"mensagem":"XML não localizado"}';
         exit;
      end;

      ACBrMDFe1.Manifestos.LoadFromFile(ACBRMDfe1.Configuracoes.Arquivos.PathSalvar+qREG.FieldByName('CHAVEMDFE').AsString+'-mdfe.xml',true);

      ACBrMDFe1.EventoMDFe.Evento.clear;
      with ACBrMDFe1.EventoMDFe.Evento.Add do begin
         infEvento.chMDFe := Copy(ACBrMDFe1.Manifestos.Items[0].MDFe.infMDFe.ID, 5, 44);

         cUF := SQLString('SELECT ESTADO FROM EMPRESA WHERE CODIGO=01',qAUX);

         infEvento.dhEvento      := PegaDataHoraPorEstado(ACBrMDFe1.Configuracoes.WebServices.UF);
         // infEvento.dhEvento        := IncHour(Now);
         infEvento.tpEvento        := teCancelamento;
         infEvento.nSeqEvento      := 1;
         infEvento.detEvento.xJust := trim(cJus);
         infEvento.detEvento.nProt := ACBrMDFe1.Manifestos.Items[0].MDFe.procMDFe.nProt;

         if infEvento.detEvento.nProt='' then begin
            infEvento.detEvento.nProt := '';
         end;
      end;

      try
         ACBrMDFe1.EnviarEvento(1); // 1 = Numero do Lote
         // ACBrMDFe1.ImprimirEvento;

         qAUX.Close;
         qAUX.SQL.Text := 'UPDATE FRETESMDF SET STATUS=''C'' WHERE CODIGO=0'+cCod;
         sql := qAUX.SQL.Text;
         qAUX.ExecSQL(False);

         Result := '{"erro":0,"mensagem":"CTE cancelado com sucesso."}';
      except on E: Exception do
         Result := '{"erro":1,"mensagem":"'+TrataMensagemExcept(e.Message)+'"}';
      end;

   finally
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(ACBRMDfe1);
      FreeAndNil(ACBrMDFeDAMDFeRL1);
   end;
end;

procedure TMdfe.ConfiguraMail(ACBRMail: TACBRMail; qAUX: TSQLQuery);
var
   cEmpresa : String;
   cSenha : String;
   cDBSYS : TSQLConnection;
begin
   cDBSYS := TSQLConnection.Create(Nil);
   try
      qAUX.Close;
      qAUX.SQL.Text := 'SELECT P.MAILPORTA,P.MAILSMTP,'+
      'P.MAILUSER,P.MAILPASS,P.MAILSSL,'+
      '(SELECT FIRST 1 NOME FROM EMPRESA) AS NOMEE '+
      'FROM PARAMETROS P '+
      'WHERE P.EMPRESA=1';
      sql := qAUX.SQL.Text;
      qAUX.Open;

      cEmpresa := qAUX.FieldByName('NOMEE').AsString;
      cSenha   := Decrip(qAUX.FieldByName('MAILPASS').AsString);

      if(Trim(qAUX.FieldByName('MAILUSER').AsString) = '') or (Trim(qAUX.FieldByName('MAILPASS').AsString) = '')then begin
         qAUX.Close;
         ConfConexao(cDBSYS);

         qAUX.Close;
         qAUX.SQLConnection := cDBSYS;

         qAUX.SQL.Text := 'SELECT FIRST 1 PORTA AS MAILPORTA,'+
         'SMTP AS MAILSMTP,CONTA AS MAILUSER,SENHA AS MAILPASS, '+
         '''S'' AS MAILSSL '+
         'FROM PARAMETROS ';
         sql := qAUX.SQL.Text;
         qAUX.Open;

         cSenha   := qAUX.FieldByName('MAILPASS').AsString;
      end;

      ACBrMail.Host     := qAUX.FieldByName('MAILSMTP').AsString;
      ACBrMail.Port     := qAUX.FieldByName('MAILPORTA').AsString;
      ACBrMail.Username := qAUX.FieldByName('MAILUSER').AsString;
      ACBrMail.Password := cSenha;
      ACBrMail.From     := qAUX.FieldByName('MAILUSER').AsString;
      ACBrMail.SetSSL   := qAUX.FieldByName('MAILSSL').AsString = 'S'; // SSL - ConexÃ£o Segura
      ACBrMail.SetTLS   := true; //cbEmailSSL.Checked; // Auto TLS
      ACBrMail.ReadingConfirmation := False; //Pede confirmaÃ§Ã£o de leitura do email
      ACBrMail.UseThread := False;           //Aguarda Envio do Email(nÃ£o usa thread)
      ACBrMail.FromName  := 'MDFe -  '+cEmpresa;
   finally
      FreeAndNil(cDBSYS);
   end;
end;

function TMdfe.Encerra(oReq: TJSONObject; qUSU: TSQLQuery;
  cDB: TSQLConnection): String;
var
   cCod,cAux  : String;
   cMensagem  : String;
   cFile,cUf  : String;
   cPathMdfe  : String;
   cDownload  : String;
   cBase      : String;

   ACBRMDfe1         : TACBrMDFe;
   ACBrMDFeDAMDFeRL1 : TACBrMDFeDAMDFeRL;

   qREG : TSQLQuery;
   qAUX : TSQLQuery;
begin
   ACBRMDfe1         := TACBrMDFe.Create(Nil);
   ACBrMDFeDAMDFeRL1 := TACBrMDFeDAMDFeRL.Create(Nil);

   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;
   try
      if(not VerificaCertificado(qAUX))then begin
         Result := '{"erro":1,"mensagem":"Certificado ou senha do certificado não informado!"}';
         exit;
      end;

      cCod      := GetValueJSONObject('codigo',oReq);
      cPathMdfe := qAUX.FieldByName('PATHMDFE').AsString;

      qREG.Close;
      qREG.SQL.Text := 'SELECT M.* '+
      'FROM FRETESMDF M '+
      'WHERE M.CODIGO=0'+cCod;
      sql := qREG.SQL.Text;
      qREG.Open;

      if(not FileExists('AmbienteTeste.txt'))then begin
         if(qREG.FieldByName('CHAVEMDFE').AsString = '')then begin
            Result := '{"erro":1,"mensagem":"Chave do MDFe inválida"}';
            Exit;
         end;

         if(qREG.FieldByName('STATUS').AsString = 'Z')then begin
            Result := '{"erro":1,"mensagem":"Esse MDFe já foi encerrado."}';
            exit;
         end;

         if(qREG.FieldByName('STATUS').AsString = 'C')then begin
            Result := '{"erro":1,"mensagem":"Esse MDFe já foi cancelado."}';
            exit;
         end;
      end;

      if(qREG.FieldByName('CHAVEMDFE').AsString = '')then begin
         Result := '{"erro":1,"mensagem":"Esse MDFe ainda não foi autorizado"}';
         exit;
      end;

      cMensagem := '';
      try
         ConfiguraMdfe(qAUX,ACBRMDfe1,ACBrMDFeDAMDFeRL1);
      except on E: Exception do begin
         Result := '{"erro":1,"mensagem":"Ocorreu algum erro ao configurar o MDFE"}';
         GravaLog('Erro ao configurar MDFE ENCERRAR:'+e.Message);
         exit;
      end;
      end;

      cBase := ExtractFilePath(ParamStr(0))+
               'clientes'+
               '\MDFe'+
               '\'+soNUmero(qAUX.FieldByName('CNPJ').AsString)+
               '\'+FormatDateTime('yyyymm',qREG.FieldByName('DATA').AsDateTime)+
               '\MDFe';

      cFile := cBase + '\'+qREG.FieldByName('CHAVEMDFE').AsString+'-mdfe.xml';

      if(not FileExists(cFile))then begin
         GravaLog('XML não encontrado ao encerrar:'+cFile);
         Result := '{"erro":1,"mensagem":"XML não localizado"}';
         exit;
      end;

      ACBrMDFe1.Manifestos.LoadFromFile(cFile,true);
      ACBrMDFe1.EventoMDFe.Evento.clear;

      with ACBrMDFe1.EventoMDFe.Evento.Add do begin
         infEvento.chMDFe     := Copy(ACBrMDFe1.Manifestos.Items[0].MDFe.infMDFe.ID, 5, 44);
         infEvento.dhEvento   := PegaDataHoraPorEstado(ACBrMDFe1.Configuracoes.WebServices.UF);
         infEvento.tpEvento   := teEncerramento;
         infEvento.nSeqEvento := 1;

         // GravaLog('dhEvento='+ DateTimeToStr(PegaDataHoraPorEstado(ACBrMDFe1.Configuracoes.WebServices.UF)));

         infEvento.detEvento.nProt := ACBrMDFe1.Manifestos.Items[0].MDFe.procMDFe.nProt;

         if infEvento.detEvento.nProt='' then
            infEvento.detEvento.nProt := qREG.FieldByName('PROTOCOLO_ENVIO').AsString;

         infEvento.detEvento.dtEnc := Date;
         infEvento.detEvento.cUF   := StrToInt(Copy(IntToStr(ACBrMDFe1.Manifestos.Items[0].MDFe.infDoc.infMunDescarga.Items[0].cMunDescarga),1,2));
         infEvento.detEvento.cMun  := ACBrMDFe1.Manifestos.Items[0].MDFe.infDoc.infMunDescarga.Items[0].cMunDescarga;

         if (infEvento.detEvento.cUF = 99) then
            infEvento.detEvento.cMun:= 9999999;
      end;

      cAux := '';
      try
         ACBrMDFe1.EnviarEvento(1); // 1 = Numero do Lote
      except on e:exception do
         cAux := Uppercase(e.Message);
      end;

      if (ACBrMDFe1.WebServices.StatusServico.cStat=135) or (Pos('DUPLICIDADE DE EVENTO',cAux)<>0) or (cAux = '') then begin

         ACBrMDFe1.DAMDFE.PathPDF := cBase + '\PDFs\';
         ACBrMDFe1.ImprimirEventoPDF;

         cDownload := '/clientes'+
                      '/MDfe'+
                      '/'+soNUmero(qUSU.FieldByName('CNPJ').AsString)+
                      '/'+FormatDateTime('yyyymm',qREG.FieldByName('DATA').AsDateTime)+
                      '/MDFe'+
                      '/PDFs'+
                      '/110112'+qREG.FieldByName('CHAVEMDFE').AsString+'01-procEventoMDFe.pdf';


         qAUX.SQL.Text := 'UPDATE FRETESMDF SET '+
         'STATUS= ''Z'','+
         'USUENC=0'+qUSU.FieldByName('CODIGO').AsString+' '+
         'WHERE CODIGO=0'+qREG.FieldByName('CODIGO').AsString;
         sql := qAUX.SQL.Text;
         qAUX.ExecSQL(False);

         Result := '{'+
         '"erro":0,'+
         '"mensagem":"CTE encerrado com sucesso.",'+
         '"pdf":"'+cDownload+'"'+
         '}';
      end else begin
         Result := '{"erro":1,"mensagem":"'+TrataMensagemExcept(cAux)+'"}';
      end;
   finally
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(ACBRMDfe1);
      FreeAndNil(ACBrMDFeDAMDFeRL1);
   end;
end;



function TMdfe.DownloadEncerramento(oReq: TJSONObject; qUSU: TSQLQuery;
  cDB: TSQLConnection): String;
var
   cCod       : String;
   cMensagem  : String;
   cFile      : String;
   cAux       : String;
   cDownload  : String;
   cBase      : String;
   nCte       : Integer;
   ACBRMDfe1         : TACBrMDFe;
   ACBrMDFeDAMDFeRL1 : TACBrMDFeDAMDFeRL;
   qREG : TSQLQuery;
   qAUX : TSQLQuery;
begin
   ACBRMDfe1         := TACBrMDFe.Create(Nil);
   ACBrMDFeDAMDFeRL1 := TACBrMDFeDAMDFeRL.Create(Nil);

   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;
   try
      if(not VerificaCertificado(qAUX))then begin
         Result := '{"erro":1,"mensagem":"Certificado ou senha do certificado não informado!"}';
         exit;
      end;

      cCod := GetValueJSONObject('codigo',oReq);

      qREG.Close;
      qREG.SQL.Text := 'SELECT M.* '+
      'FROM FRETESMDF M '+
      'WHERE M.CODIGO=0'+cCod;
      sql := qREG.SQL.Text;
      qREG.Open;

      if(qREG.FieldByName('CHAVEMDFE').AsString = '')then begin
         Result := '{"erro":1,"mensagem":"Chave do MDFe inválida"}';
         Exit;
      end;

      if(qREG.FieldByName('STATUS').AsString <> 'Z')then begin
         Result := '{"erro":1,"mensagem":"Esse MDFe ainda não foi encerrado"}';
         Exit;
      end;

      cBase     := '\clientes\MDfe\'+soNUmero(qUSU.FieldByName('CNPJ').AsString)+'\'+FormatDateTime('yyyymm',qREG.FieldByName('DATA').AsDateTime)+'\MDFe\';
      cDownload := cBase + 'PDFs\110112'+qREG.FieldByName('CHAVEMDFE').AsString+'01-procEventoMDFe.pdf';

      if not(FileExists('.'+cDownload))then begin
         cBase := '.'+cBase;

         cMensagem := '';
         try
            ConfiguraMDFe(qAUX,ACBRMDfe1,ACBrMDFeDAMDFeRL1);
         except on E: Exception do begin
            Result := '{"erro":1,"mensagem":"Ocorreu algum erro ao configurar o MDFE"}';
            exit;
         end;
         end;

         cFile := cBase + qREG.FieldByName('CHAVEMDFE').AsString+'-mdfe.xml';

         if not FileExists(cFile) then begin
            Result := '{"erro":1,"mensagem":"XML não encontrado"}';
            exit;
         end;

         try
            ACBrMDFe1.DAMDFE.PathPDF := ExtractFilePath(ParamStr(0))+ Copy(cBase,3,cBase.Length) + 'PDFs\';
            // ACBRMDfe1.
            ACBRMDfe1.Manifestos.LoadFromFile(cFile);
            ACBRMDfe1.ImprimirEventoPDF;

            cAux := cBase + '110112'+qREG.FieldByName('CHAVEMDFE').AsString+'01-procEventoMDFe.pdf';

//            if(Trim(qAUX.FieldByName('PATHMDFE').AsString) = '')then begin // caso seja cliente do sigetran
//               cAux := '.\clientes\MDfe\'+soNUmero(qUSU.FieldByName('CNPJ').AsString)+'\110112'+qREG.FieldByName('CHAVEMDFE').AsString+'01-procEventoMDFe.pdf';
//            end else
//               cAux := qAUX.FieldByName('PATHMDFE').AsString+'\'+FormatDateTime('yyyymm',qREG.FieldByName('DATA').AsDateTime)+'\MDFe\110112'+qREG.FieldByName('CHAVEMDFE').AsString+'01-procEventoMDFe.pdf';

            cDownload := '/clientes'+
                         '/MDfe'+
                         '/'+soNUmero(qUSU.FieldByName('CNPJ').AsString)+
                         '/'+FormatDateTime('yyyymm',qREG.FieldByName('DATA').AsDateTime)+
                         '/MDFe'+
                         '/PDFs'+
                         '/110112'+qREG.FieldByName('CHAVEMDFE').AsString+'01-procEventoMDFe.pdf';
            {

            if FileExists(cAux) then begin
               try
                  MoveFile(Pchar(cAux),Pchar('.\clientes\MDfe\'+soNUmero(qUSU.FieldByName('CNPJ').AsString)+'\PDfs\110112'+qREG.FieldByName('CHAVEMDFE').AsString+'01-procEventoMDFe.pdf'));
                  cDownload := '/clientes/MDfe/'+soNUmero(qUSU.FieldByName('CNPJ').AsString)+'/PDFs/110112'+qREG.FieldByName('CHAVEMDFE').AsString+'01-procEventoMDFe.pdf';
               except on E: Exception do
                  cDownload := '/clientes/MDfe/'+soNUmero(qUSU.FieldByName('CNPJ').AsString)+'/110112'+qREG.FieldByName('CHAVEMDFE').AsString+'01-procEventoMDFe.pdf';
               end;
            end;

            }
         except on E: Exception do begin
            Result := '{"erro":1,"mensagem":"Ocorreu um erro ao tentar gerar download de encerramento"}';
            GravaLog('Erro ao tentar gerar download encerramento erro:'+e.Message);
            Exit;
         end;
         end;
      end else
         cDownload := StringReplace(cDownload,'\','/',[rfReplaceAll]);

      Result := '{'+
      '"erro":0,'+
      '"mensagem":"PDF gerado com sucesso",'+
      '"pdf":"'+cDownload+'"'+
      '}';
   finally
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(ACBRMDfe1);
      FreeAndNil(ACBrMDFeDAMDFeRL1);
   end;
end;



function TMdfe.EnviaSeguro(oReq: TJSONObject; qUSU: TSQLQuery;
  cDB: TSQLConnection): String;
var
   cMensagem  : String;
   cCod       : String;
   nCte       : Integer;
   qREG : TSQLQuery;
   qAUX : TSQLQuery;
begin
   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;
   try
      if(not VerificaCertificado(qAUX))then begin
         Result := '{"erro":1,"mensagem":"Certificado ou senha do certificado não informado!"}';
         exit;
      end;

      cCod := GetValueJSONObject('codigo',oReq);

      qREG.Close;
      qREG.SQL.Text := 'SELECT F.* '+
      'FROM FRETESMDF F '+
      'WHERE F.FRETE=0'+cCod;
      sql := qREG.SQL.Text;
      qREG.Open;

      if(qREG.FieldByName('CHAVEMDFE').AsString = '')then begin
         Result := '{"erro":1,"mensagem":"Chave do MDFE inválida"}';
         Exit;
      end;

      try
         Result := EnviaMDFeATM(qREG.FieldByName('FRETE').AsInteger,qAUX);
      except on E: Exception do begin
         GravaLog('Erro ao averbar MDFe Cliente:'+qUSU.FieldByName('CNPJ').AsString+' Erro:'+e.Message);
         Result := '{"erro":1,"mensagem":"Não foi possível averbar"}';
      end;
      end;
   finally
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
   end;
end;

function TMdfe.ImprimePDFPorXMLEncerramento(oReq: TJSONObject; qUSU: TSQLQuery;
  cDB: TSQLConnection): String;
var
   cCod       : String;
   cMensagem  : String;
   cFile      : String;
   cAux       : String;
   cDownload  : String;
   cBase      : String;
   nCte       : Integer;
   ACBRMDfe1         : TACBrMDFe;
   ACBrMDFeDAMDFeRL1 : TACBrMDFeDAMDFeRL;
   qREG : TSQLQuery;
   qAUX : TSQLQuery;
begin
   ACBRMDfe1         := TACBrMDFe.Create(Nil);
   ACBrMDFeDAMDFeRL1 := TACBrMDFeDAMDFeRL.Create(Nil);

   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;

   try
      if(not VerificaCertificado(qAUX))then begin
         Result := '{"erro":1,"mensagem":"Certificado ou senha do certificado não informado!"}';
         exit;
      end;

      cCod := GetValueJSONObject('codigo',oReq);

      try
         ConfiguraMDFe(qAUX,ACBRMDfe1,ACBrMDFeDAMDFeRL1);
      except on E: Exception do begin
         Result := '{"erro":1,"mensagem":"Ocorreu algum erro ao configurar o MDFE"}';
         exit;
      end;
      end;

      try
         ACBrMDFe1.DAMDFE.PathPDF := 'C:\lixo\PDFs\';
         ACBrMDFe1.Configuracoes.Arquivos.PathEvento := 'C:\lixo\PDFs\';
         ACBRMDfe1.EventoMDFe.LerXML('C:\lixo\1101125024014020981200016658001000000840100008403601-procEventoMDFe.xml');
         ACBRMDfe1.ImprimirEvento;
//         ACBRMDfe1.ImprimirEvento;
      except on E: Exception do begin
         Result := '{"erro":1,"mensagem":"Ocorreu um erro ao tentar gerar download de encerramento"}';
         GravaLog('Erro ao tentar gerar download encerramento erro:'+e.Message);
         Exit;
      end;
      end;

      Result := '{'+
      '"erro":0,'+
      '"mensagem":"PDF gerado com sucesso",'+
      '"pdf":"'+cDownload+'"'+
      '}';
   finally
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(ACBRMDfe1);
      FreeAndNil(ACBrMDFeDAMDFeRL1);
   end;
end;

function TMdfe.Consulta(Req: TStrings; qUSU: TSQLQuery): String;
var
   aItens : TJSONArray;
   oItens : TJSONObject;

   oPrin  : TJSONObject;

   qAUX : TSQLQuery;
   qREG : TSQLQuery;
begin
   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   qREG.SQLConnection := qUSU.SQLConnection;
   qAUX.SQLConnection := qUSU.SQLConnection;

   oPrin := TJSONObject.Create;
   try
      Req.Values['codigo'] := SoNumero(Req.Values['codigo']);

      qREG.Close;
      qREG.SQL.Add('SELECT M.*,F.CTE,F.CTRC,F.CHAVECTE,');
			qREG.SQL.Add('F.QUANTIDADE,F.VALOR,');
      qREG.SQL.Add('MT.CODIGO||'' ''||MT.NOME AS NOMEMOT,');
      qREG.SQL.Add('P.CODIGO||'' ''||P.NOME AS NOMEP,');
      qREG.SQL.Add('V.PLACA AS PLACA,');
      qREG.SQL.Add('M.USUARIO||'' ''||UI.LOGIN AS USUI,');
			qREG.SQL.Add('M.USUALT||'' ''||UA.NOME AS USUA,M.USUENC||'' ''||UE.NOME AS USUE,');
      qREG.SQL.Add('T.CODIGO||'' ''||T.NOME AS NOMETOM');
			qREG.SQL.Add('FROM FRETESMDF M');
			qREG.SQL.Add('LEFT JOIN FRETES F ON F.CODIGO=M.FRETE');
      qREG.SQL.Add('LEFT JOIN CLIENTES T ON T.CODIGO=F.TOMADOR');
			qREG.SQL.Add('LEFT JOIN MOTORISTAS MT ON MT.CODIGO=F.MOTORISTA');
			qREG.SQL.Add('LEFT JOIN PRODUTOS P ON P.CODIGO=F.PRODUTO');
			qREG.SQL.Add('LEFT JOIN VEICULO V ON V.CODIGO=F.VEICULO');
			qREG.SQL.Add('LEFT JOIN USUARIOS UI ON UI.CODIGO=M.USUARIO');
			qREG.SQL.Add('LEFT JOIN USUARIOS UA ON UA.CODIGO=M.USUALT');
			qREG.SQL.Add('LEFT JOIN USUARIOS UE ON UE.CODIGO=M.USUENC');
			qREG.SQL.Add('WHERE M.CODIGO=0'+Req.Values['codigo']);
      sql := qREG.SQL.Text;
      qREG.SQL.SaveToFile('teste.txt');
      qREG.Open;

      if (qREG.Eof) then begin
         Result := '{"erro":1,"mensagem":"Registro não encontrado"}';
         Exit;
      end;

      qAUX.Close;
      qAUX.SQL.Text := 'SELECT COUNT(*) AS AVERBADO '+
      'FROM FRETESATM '+
      'WHERE CODIGO=0'+qREG.FieldByName('FRETE').AsString;
      sql := qAUX.SQL.Text;
      qAUX.Open;

      oPrin.AddPair('averbado',iif(StrToNumI(qAUX.FieldByName('AVERBADO').AsString) > 0,'S','N'));

      oPrin.AddPair('codigo',qREG.FieldByName('CODIGO').AsString);
      oPrin.AddPair('cep_destino',FormataCep(qREG.FieldByName('D_CEP').AsString));
      oPrin.AddPair('cidade_destino',qREG.FieldByName('D_CIDADE').AsString);
      oPrin.AddPair('uf_destino',qREG.FieldByName('D_UF').AsString);
      oPrin.AddPair('cep_origem',FormataCep(qREG.FieldByName('O_CEP').AsString));
      oPrin.AddPair('cidade_origem',qREG.FieldByName('O_CIDADE').AsString);
      oPrin.AddPair('uf_origem',qREG.FieldByName('O_UF').AsString);
      oPrin.AddPair('data',FormatDateTime('yyyy-mm-dd hh:MM:ss',qREG.FieldByName('DATA').AsDateTime));
      oPrin.AddPair('cnpj',qUSU.FieldByName('CNPJ').AsString);
      oPrin.AddPair('estado_de_percurso',qREG.FieldByName('PERCURSO').AsString);
      oPrin.AddPair('informacao_complementar',qREG.FieldByName('OBS').AsString);
      oPrin.AddPair('mdfe',qREG.FieldByName('MDFE').AsString);
      oPrin.AddPair('chave_mdfe',qREG.FieldByName('CHAVEMDFE').AsString);
      oPrin.AddPair('motorista',qREG.FieldByName('NOMEMOT').AsString);
      oPrin.AddPair('situacao',qREG.FieldByName('STATUS').AsString);
      oPrin.AddPair('placa',qREG.FieldByName('PLACA').AsString);
      oPrin.AddPair('tomador',qREG.FieldByName('NOMETOM').AsString);
      oPrin.AddPair('produto',qREG.FieldByName('NOMEP').AsString);
      oPrin.AddPair('download_pdf','');


      aItens := TJSONArray.Create;
      while not(qREG.Eof) do begin
         if(qREG.FieldByName('FRETE').AsString <> '')then begin
            oItens := TJSONObject.Create;
            oItens.AddPair('codigo',qREG.FieldByName('FRETE').AsString);
            oItens.AddPair('item',qREG.FieldByName('ITEM').AsString);
            oItens.AddPair('ctrc',qREG.FieldByName('CTRC').AsString);
            oItens.AddPair('cte',qREG.FieldByName('CTE').AsString);
            oItens.AddPair('tipo_documento','CTe');
            oItens.AddPair('chave_documento',qREG.FieldByName('CHAVECTE').AsString);
            oItens.AddPair('capacidade',qREG.FieldByName('QUANTIDADE').AsString);
            oItens.AddPair('carga',qREG.FieldByName('CARGA').AsString);
            oItens.AddPair('empresa',qREG.FieldByName('EMPRESA').AsString);
            oItens.AddPair('data',FormatDateTime('yyyy-mm-dd',qREG.FieldByName('DATA').AsDateTime));
            oItens.AddPair('motorista',qREG.FieldByName('NOMEMOT').AsString);
            oItens.AddPair('placa',qREG.FieldByName('PLACA').AsString);
            oItens.AddPair('quantidade',qREG.FieldByName('CARGA').AsString);
            oItens.AddPair('cep_destino',qREG.FieldByName('D_CEP').AsString);
            oItens.AddPair('cep_origem',qREG.FieldByName('O_CEP').AsString);
            oItens.AddPair('cidade_destino',qREG.FieldByName('D_CIDADE').AsString);
            oItens.AddPair('cidade_origem',qREG.FieldByName('O_CIDADE').AsString);
            oItens.AddPair('uf_destino',qREG.FieldByName('D_UF').AsString);
            oItens.AddPair('uf_origem',qREG.FieldByName('O_UF').AsString);
            oItens.AddPair('emitido_sigetran','S');
            aItens.Add(oItens);
         end;
         qREG.Next;
      end;

      oPrin.AddPair('itens',aItens);

      Result := oPrin.ToString;
   finally
      oPrin.DisposeOf;
      FreeAndNil(qREG);
      FreeAndNil(qAUX);
   end;
end;

procedure TMdfe.EncerrarMDFe(ch,pr: String;ACBrMDFe1:TACBrMDFe;qAUX:TSQLQuery);
var dMes : String;
    cDir : String;
    cAux : String;
    cCnpj: String;

begin
   qAUX.Close;
   qAUX.SQL.Text := 'SELECT E.CNPJ '+
   'FROM EMPRESA E '+
   'WHERE E.CODIGO=01';
   sql := qAUX.SQL.Text;
   qAUX.Open;

   cCnpj := qAUX.FieldByName('CNPJ').AsString;

   qAUX.SQL.Text:='SELECT * FROM FRETESMDF WHERE (DATA>CURRENT_DATE-90) AND CHAVEMDFE='+QuotedStr(ch);
   sql := qAUX.SQL.Text;
   qAUX.Open;
   if qAUX.Eof then begin
//      ConfiguraMDFe(qAUX,,ACBrMDFe1);
      dMes := FormatDateTime('yyyymm',date);
   end else begin
//      LeiaCOnfigMDFe(qAUX.FieldByName('EMPRESA').AsString);
      dMes := FormatDateTime('yyyymm',qAUX.FieldByName('DATA').AsDateTime);
   end;

   cDir := ACBrMDFe1.Configuracoes.Arquivos.PathSalvar;

   ACBrMDFe1.Manifestos.Clear;
   try
      ACBrMDFe1.Manifestos.LoadFromFile(cDir+ch+'-mdfe.xml',true);
   except
   end;

   try
      cAux:='';
      ACBrMDFe1.EventoMDFe.Evento.clear;
      with ACBrMDFe1.EventoMDFe.Evento.Add do begin
         infEvento.CNPJCPF    := SoNumero(cCnpj);
         infEvento.chMDFe     := ch;
         infEvento.dhEvento   := now;
         infEvento.tpEvento   := teEncerramento;
         infEvento.nSeqEvento := 1;

         infEvento.detEvento.nProt := pr;
         infEvento.detEvento.dtEnc := Date;

         if ACBrMDFe1.Manifestos.Count>0 then begin
            infEvento.detEvento.cUF   := StrToInt(Copy(IntToStr(ACBrMDFe1.Manifestos.Items[0].MDFe.infDoc.infMunDescarga.Items[0].cMunDescarga),1,2));
            infEvento.detEvento.cMun  := ACBrMDFe1.Manifestos.Items[0].MDFe.infDoc.infMunDescarga.Items[0].cMunDescarga;
         end else begin
            infEvento.detEvento.cUF   := 42;
            infEvento.detEvento.cMun  := 4218608;
         end;
      end;

      ACBrMDFe1.EnviarEvento( 1 ); // 1 = Numero do Lote
   except on e:exception do
      cAux := e.message;
   end;
end;



end.
