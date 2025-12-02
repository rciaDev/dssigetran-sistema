unit uCTe;

interface
Uses System.SysUtils,System.Classes,Data.DB, Data.SqlExpr, math,Datasnap.DSSession,MSHTML,ActiveX,FMX.Graphics,
 Soap.EncdDecd,System.JSON,ACBrCTeDACTEClass,ACBrCTe, pcnConversao,
  Printers, pcteConversaoCTe, Vcl.Dialogs,
  pcnAuxiliar,RLReport, RLFilters, RLPDFFilter, Types,RLTypes,
  ACBrNFe,ACBrMDFeDAMDFeClass,  ACBrMDFe,ACBrDFeUtil, ACBrMail,ACBrDFeSSL,
  ACBrCTeDACTeRLClass, ACBrBase, ACBrDFe, ACBrMDFeDAMDFeRLClass, ACBrDFeReport,
  System.TypInfo,ACBrUtil,System.StrUtils,System.DateUtils,Windows,Soap.InvokeRegistry, Soap.Rio, Soap.SOAPHTTPClient;

type
  TCte = class
  private
    { private declarations }

  protected
    { protected declarations }
  public
    { public declarations }
    function Status(cDB:TSQLConnection):String;
    function Envia(oReq:TJSONObject;qUSU:TSQLQuery;cDB:TSQLConnection):String;
    function Download(oReq:TJSONObject;qUSU:TSQLQuery;cDB:TSQLConnection):String;
    function Cancela(oReq:TJSONObject;qUSU:TSQLQuery;cDB:TSQLConnection):String;
    function ConsultaSEFAZ(oReq:TJSONObject;qUSU:TSQLQuery;cDB:TSQLConnection):String;
    function EnviaSeguro(oReq:TJSONObject;qUSU:TSQLQuery;cDB:TSQLConnection):String;
    function CartaCorrecao(oReq:TJSONObject;qUSU:TSQLQuery;cDB:TSQLConnection):String;
    function ImprimirCorrecao(oReq:TJSONObject;qUSU:TSQLQuery;cDB:TSQLConnection):String;
    function Email(oReq:TJSONObject;qUSU:TSQLQuery;cDB:TSQLConnection):String;
    function BuscaFretesAtm(sReq:TStrings;qUSU:TSQLQuery):String;

    function GetSql():String;
    function GetConfigs():String;
    function VerificaCertificado(qAUX:TSQLQuery):Boolean;
    function MudouTomador(qREG,qAUX:TSQLQuery):Boolean;
    function ProximoCte(qREG,qAUX:TSQLQuery):Integer;
    function ValidaCancelamento(oReq:TJSONObject; ACBRCte1:TACBRCte;qREG,qUSU:TSQLQuery):String;
    function PegaChaveXML(cXml:String):String;

    procedure DeletaPDFs();
    procedure GerarCte(qREG,qAUX,qUSU:TSQLQuery;ACBRCTe1:TACBRCTE;ACBrCTeDACTeRL1:TACBrCTeDACTeRL);
    procedure ConfiguraCTe(qAUX:TSQLQUery;ACBRCTe1:TACBRCTE;ACBrCTeDACTeRL1:TACBrCTeDACTeRL);
    procedure ConfiguraMail(ACBRMail:TACBRMail;qAUX:TSQLQuery);

  published

  end;

  var
    sql  : String;
    cCri : String;
implementation

uses uWMSite, uFrm;


{ TProdutos }



procedure TCte.ConfiguraCTe(qAUX:TSQLQUery;ACBRCTe1:TACBRCTE;ACBrCTeDACTeRL1:TACBrCTeDACTeRL);
var
   cCert : String;
   bOk   : Boolean;
begin
   cCert := qAUX.FieldByName('CERTIFICADO_CAMINHO').AsString;
   if(Copy(cCert,1,1) = '.')then
       cCert := ExtractFilePath(ParamStr(0))+Copy(cCert,3,Length(cCert));

   ACBrCTe1.Configuracoes.Geral.VersaoDF           := ve400;
   // ACBrCTe1.Configuracoes.Certificados.NumeroSerie := qAUX.FieldByName('CTESERIE').AsString;
   ACBrCTe1.Configuracoes.Geral.FormaEmissao       := teNormal;// StrToTpEmis(bOk,IntToStr(qAUX.FieldByname('FORMAEMISSAO').AsInteger+1));
   ACBrCTe1.Configuracoes.Geral.Salvar             := False;

   // ACBrCTe1.Configuracoes.WebServices.TimeZoneConf.ModoDeteccao := tzPCN;

   ACBrCTe1.Configuracoes.WebServices.UF            := qAUX.FieldByname('WEBSERVICE').AsString;
   ACBrCTe1.Configuracoes.WebServices.Ambiente      := StrToTpAmb(bOk,IntToStr(qAUX.FieldByname('AMBIENTE').AsInteger+1));
   ACBrCTe1.Configuracoes.WebServices.Visualizar    := false;
   ACBrCTe1.Configuracoes.Arquivos.AdicionarLiteral := false;
   ACBrCTe1.Configuracoes.Arquivos.SepararPorMes    := false;

   ACBrCTe1.Configuracoes.Geral.ModeloDF := moCTE;


   ACBrCTe1.Configuracoes.Geral.SSLLib             := libWinCrypt;
   ACBrCTe1.Configuracoes.Geral.SSLXmlSignLib      := xsLibXml2;
   ACBrCTe1.Configuracoes.Geral.SSLHttpLib         := httpWinHttp;
   ACBrCTe1.Configuracoes.Geral.SSLCryptLib        := cryWinCrypt;
   //   ACBrCTe1.Configuracoes.Geral.SSLLib           := libWinCrypt;
//    ACBrCTe1.Configuracoes.Geral.SSLLib             := libOpenSSL;
   ACBrCTe1.Configuracoes.Certificados.ArquivoPFX  := cCert;//qAUX.FieldByName('CERTIFICADO_CAMINHO').AsString;
   ACBrCTe1.Configuracoes.Certificados.Senha       := qAUX.FieldByName('CERTIFICADO_SENHA').AsString;
   ACBRCTe1.Configuracoes.WebServices.Visualizar   := false;

   ACBRCTe1.Configuracoes.WebServices.TimeOut      := 60000;
   // ACBRCTe1.Configuracoes.WebServices.tentativas   := 5;

   ACBRCTe1.DACTE                 := ACBrCTeDACTeRL1;
   ACBRCTe1.DACTE.MostraPreview   := false;
   ACBRCTe1.DACTE.MostraStatus    := false;
   ACBRCTe1.DACTE.MostraSetup     := false;

   ACBrCTe1.DACTe.TipoDACTe                    := StrToTpImp(bOk,IntToStr(qAUX.FieldByName('TIPODACTE').AsInteger));
   // ACBrCTe1.DACTe.TipoDACTe                    := StrToTpImp(bOk,IntToStr(0));
   ACBrCTe1.DACTe.Logo                         := qAUX.FieldByName('LOGOMARCA').AsString;
   ACBrCTe1.Configuracoes.Arquivos.PathSchemas := ExtractFilePath(ParamStr(0))+'Schemas\';

   ACBrCTe1.Configuracoes.Arquivos.PathSalvar  := ExtractFilePath(ParamStr(0))+'clientes\CTe\'+soNUmero(qAUX.FieldByName('CNPJ').AsString)+'\'; //qAUX.FieldByname('PATHSALVAR').AsString
   ACBrCTe1.DACTe.PathPDF                      := ExtractFilePath(ParamStr(0))+'clientes\CTe\'+soNUmero(qAUX.FieldByName('CNPJ').AsString)+'\PDFs\';
   ACBrCTeDACTeRL1.PathPDF                     := ExtractFilePath(ParamStr(0))+'clientes\CTe\'+soNUmero(qAUX.FieldByName('CNPJ').AsString)+'\PDFs\';

   ACBrCTeDACTeRL1.ExpandeLogoMarca            := true;
end;



function TCte.GetSql: String;
begin
   result := sql;
end;



function TCte.PegaChaveXML(cXml:String): String;
var nP1,nP2:Word;
begin
   nP1 := Pos('<chCTe>',cXml);
   nP2 := PosEx('</chCTe>',cXml);
   result := Copy(cXml,nP1+7,nP2-nP1-7);
end;

function TCte.ProximoCte(qREG,qAUX: TSQLQuery): Integer;
var
  nRes : Integer;
  qAUX2 : TSQLQuery;
begin
   qAUX2 := TSQLQuery.Create(Nil);
   qAUX2.SQLConnection := qREG.SQLConnection;
   try
      qAUX.Close;
      qAUX.SQL.Text := 'SELECT COALESCE(MAX(CTE),0)+1 AS NCTE FROM FRETES'+
      ' WHERE CTE>=0'+SQLString('SELECT ULT_CTE FROM PARAMETROS WHERE EMPRESA=0'+qREG.FieldByName('EMPRESA').ASString,qAUX2)+
      ' AND MODELO=''CTe'' '+
      ' AND EMPRESA=0'+qREG.FieldByName('EMPRESA').ASString;
      sql := qAUX.SQL.Text;
      qAUX.Open;

      nRes := qAUX.FieldByName('NCTE').AsInteger;

      qAUX.Close;
      qAUX.SQL.Text := 'SELECT COALESCE(CTE_INICIAL,0) AS CTEI FROM PARAMETROS WHERE EMPRESA=1';
      sql := qAUX.SQL.Text;
      qAUX.Open;

      if (nRes < qAUX.FieldByName('CTEI').AsInteger) then
         nRes:=qAUX.FieldByName('CTEI').AsInteger;

      // verifica se esta dentro dos inutilizados
      repeat
         qAUX.Close;
         qAUX.SQL.Text := 'SELECT * FROM FRETECTE_INUT '+
         'WHERE EMPRESA=0'+qREG.FieldByName('EMPRESA').AsString+' '+
         'AND '+IntToStr(nRes)+'>=NUME_I '+' '+
         'AND '+IntToStr(nRes)+'<=NUME_F ';
         sql := qAUX.SQL.Text;
         qAUX.Open;

         if not(qAUX.eof) then
           nRes := qAUX.FieldByName('NUME_F').AsInteger+1;
      until qAUX.Eof;
   finally
   end;

   Result := nRes;
end;

function TCte.Status(cDB:TSQLConnection): String;
var
   cMensagem       : String;
   ACBrCte1        : TACBrCTe;
   ACBrCTeDACTeRL1 : TACBrCTeDACTeRL;
   qAUX            : TSQLQuery;
begin
   ACBrCte1        := TACBrCTe.Create(Nil);
   ACBrCTeDACTeRL1 := TACBrCTeDACTeRL.Create(Nil);

   qAUX := TSQLQuery.Create(Nil);
   qAUX.SQLConnection := cDB;
   try
      if(not VerificaCertificado(qAUX))then begin
         Result := '{"erro":1,"mensagem":"Certificado ou senha do certificado não informado!"}';
         exit;
      end;

      cMensagem := '';
      try
         ConfiguraCTe(qAUX,ACBrCTe1,ACBrCTeDACTeRL1);
      except on E: Exception do begin
         Result := '{"erro":1,"mensagem":"Ocorreu algum erro ao configurar o CTE"}';
         GravaLog('Erro ao configurar CTE STATUS:'+e.Message);
         exit;
      end;
      end;

      try
         ACBrCte1.WebServices.StatusServico.Executar;
      except on E: Exception do begin
         Result := '{"erro":1,"mensagem":"'+TrataMensagemExcept(e.Message)+'"}';
         GravaLog('Erro ao executar CTE STATUS:'+e.Message);
         exit;
      end;
      end;

//      Result := '{"erro":0,"status":"'+IntToStr(ACBrCte1.WebServices.StatusServico.cStat)+'"}';
      Result := '{'+
      '"erro":0,'+
      '"status":"'+IntToStr(ACBrCte1.WebServices.StatusServico.cStat)+'",'+
      '"mensagem":"'+ACBrCte1.WebServices.StatusServico.xMotivo+'"'+
      '}';
   finally
      FreeAndNil(qAUX);
      FreeAndNil(ACBrCte1);
      FreeAndNil(ACBrCTeDACTeRL1);
   end;
end;




function TCte.GetConfigs: String;
var
   cFormaEmissao : String;
   cVersaoDF     : String;
   nI : TpcnTipoEmissao;
   J  : TModeloCTe;
   K  : TVersaoCTe;
begin
  cFormaEmissao := '';
  cVersaoDF     := '';

  {
  for nI := Low(TpcnTipoEmissao) to High(TpcnTipoEmissao) do
    GravaLog(GetEnumName(TypeInfo(TpcnTipoEmissao), integer(nI)));
   }
  {
  cbVersaoDF.Items.Clear;
  for K := Low(TVersaoCTe) to High(TVersaoCTe) do
     cbVersaoDF.Items.Add( GetEnumName(TypeInfo(TVersaoCTe), integer(K) ) );
  cbVersaoDF.ItemIndex := 1; // 0=200; 1=300; 2=400
  }
end;



function TCte.Envia(oReq: TJSONObject; qUSU: TSQLQuery;
  cDB: TSQLConnection): String;
var
   cAux       : String;
   cMensagem  : String;
   cCod       : String;
   cEx        : String;
   cProtocolo : String;
   cRecibo    : String;
   cDownload  : String;
   cPathSalvar: String;
   nCte       : Integer;
   ACBrCte1        : TACBrCTe;
   ACBrCTeDACTeRL1 : TACBrCTeDACTeRL;
   qREG : TSQLQuery;
   qAUX : TSQLQuery;
begin
   ACBrCte1        := TACBrCTe.Create(Nil);
   ACBrCTeDACTeRL1 := TACBrCTeDACTeRL.Create(Nil);

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
         ConfiguraCTe(qAUX,ACBrCTe1,ACBrCTeDACTeRL1);
      except on E: Exception do begin
         Result := '{"erro":1,"mensagem":"Ocorreu algum erro ao configurar o CTE"}';
         exit;
      end;
      end;

      // GravaLog(ACBrCTe1.Configuracoes.WebServices.TimeZoneConf.TimeZoneStr);

      cCod        := GetValueJSONObject('codigo',oReq);
      cPathSalvar := qAUX.FieldByName('PATHSALVAR').AsString;

      qREG.Close;
      qREG.SQL.Text := 'SELECT F.*,E.ESTADO AS ESTADOE,'+
      'E.CIDADE AS CIDADEE,O.NOME AS NOMEO,O.CIDADE AS CIDADEO,O.UF AS UFO,'+
      'D.NOME AS NOMED,D.CIDADE AS CIDADED,D.UF AS UFD,E.CNPJ AS CNPJE,E.REGIME,'+
      'CST.DESCRICAO AS CSTN,P.NOME AS NOMEPROD,F.SITUACAO AS SIT_CTE '+
      'FROM FRETES F '+
      'LEFT JOIN EMPRESA E ON E.CODIGO=F.EMPRESA '+
      'LEFT JOIN ORIGENS O ON O.CODIGO=F.ORIGEM '+
      'LEFT JOIN DESTINOS D ON D.CODIGO=F.DESTINO '+
      'LEFT JOIN PRODUTOS P ON P.CODIGO=F.PRODUTO '+
      'LEFT JOIN LISTAS CST ON CST.CODIGO=4 AND CST.NOME=F.CST '+
      'WHERE F.CODIGO=0'+cCod;
      sql := qREG.SQL.Text;
      qREG.Open;

      cCod := qREG.FieldByName('CODIGO').AsString;


      if not(AmbienteTeste()) then begin
         if(qREG.FieldByName('SIT_CTE').AsString = 'E') and (MatchStr(qREG.FieldByName('STATUS_SEFAZ').AsString,['100','103']))then begin
            Result := '{"erro":1,"mensagem":"CTe já enviado para Sefaz"}';
            exit;
         end;
      end;

      qAUX.SQL.Text := 'SELECT CTE FROM FRETES WHERE CTE=0'+qREG.FieldByName('CTE').AsString+
      ' AND EMPRESA=0'+qREG.FieldByName('EMPRESA').AsString+
      ' AND CODIGO<>0'+cCod;
      sql := qAUX.SQL.Text;
      qAUX.Open;

      if(qREG.FieldByName('CTE').AsString = '') or (qAUX.FieldByName('CTE').AsString <> '') then begin
         // grava o numero do CTE.
         nCte := ProximoCte(qREG,qAUX);

         qAUX.Close;
         qAUX.SQL.Text := 'UPDATE FRETES SET CTE=0'+IntToStr(nCte)+
         ',CODCTE=0'+IntToStr(GerarCodigoDFe(nCte))+
         ' WHERE CODIGO=0'+cCod+
         ' AND EMPRESA=0'+qREG.FieldByName('EMPRESA').AsString;
         qAUX.ExecSQL(False);

         qREG.Refresh;
      end;

      ACBrCTe1.Conhecimentos.Clear;

      cCri := '';

      try
      if (qREG.FieldByName('CHAVECTE').AsString <> '') and (qREG.FieldByName('PROTOCOLO').AsString <> '') then begin
         try
           ACBrCTe1.Conhecimentos.LoadFromFile(ACBrCTe1.Configuracoes.Arquivos.PathSalvar + qREG.FieldByName('CHAVECTE').AsString + '-cte.xml', false);
           if ACBrCTe1.Conhecimentos.Items[0].CTe.procCTe.nProt = '' then
              GerarCte(qREG,qAUX,qUSU,ACBrCTe1,ACBrCTeDACTeRL1);
         except
            GerarCte(qREG,qAUX,qUSU,ACBrCTe1,ACBrCTeDACTeRL1);
         end;
      end else
         GerarCte(qREG,qAUX,qUSU,ACBrCTe1,ACBrCTeDACTeRL1);
      except
         cCri:='deuerro';
      end;

      {
        if(MatchStr(qREG.FieldByName('STATUS_SEFAZ').AsString,['100','103']))then
           cCri := 'CTe já enviado para SEFAZ'
        else
      }

      if(cCri <> '')then begin
         Result := '{"erro":1,"mensagem":"'+cCri+'"}';
         exit;
      end;

      cEx:='';
      try
//         cCri := inttostr(ACBrCTe1.Conhecimentos.Count);
//         ShowMessage(
//          'SSLLib=' + IntToStr(Ord(ACBrCTe1.Configuracoes.Geral.SSLLib)) + sLineBreak +
//          'SSLHttpLib=' + IntToStr(Ord(ACBrCTe1.Configuracoes.Geral.SSLHttpLib)) + sLineBreak +
//          'SSLXmlSignLib=' + IntToStr(Ord(ACBrCTe1.Configuracoes.Geral.SSLXmlSignLib))
//         );
//
         ACBrCTe1.Conhecimentos.Items[0].GravarXML();
         ACBrCTe1.Conhecimentos.Items[0].Assinar;
         ACBrCTe1.Conhecimentos.Items[0].Validar;

         ACBrCTe1.Enviar(qREG.FieldByName('CTE').AsInteger,false,false);

         if (ACBrCTe1.Conhecimentos.Items[0].CTe.infCTe.ID <> '') and (Pos('0'+qREG.FieldByName('CTE').AsString,ACBrCTe1.Conhecimentos.Items[0].CTe.infCTe.ID) <> 0) then begin
            qAUX.Close;
            qAUX.SQL.Text := 'UPDATE FRETES SET CHAVECTE='+QuotedStr(Copy(ACBrCTe1.Conhecimentos.Items[0].CTe.infCTe.ID,4,45))+
            ' WHERE CODIGO=0'+qREG.FieldByName('CODIGO').AsString+
            ' AND EMPRESA=0'+qREG.FieldByName('EMPRESA').AsString;
            sql := qAUX.SQL.Text;
            qAUX.ExecSQL(False);

            qREG.Refresh;
         end;

         // AcbrCTE1.Conhecimentos.;
         ACBrCTe1.Conhecimentos.ImprimirPDF;

         if ACBrCTe1.WebServices.Enviar.cStat in [108,109] then begin
            Result := '{"erro":1,"mensagem":"Serviço Paralisado"}';
            Exit;
         end else if ACBrCTe1.WebServices.Enviar.cStat in [111,112] then begin
            Result := '{"erro":1,"mensagem":"Consulta cadastro com ocorrencia"}';
            Exit;
         end;

         // verifica se é pra fazer averbação e envia.
         // ADICIONANR VERIFICAÇÃO DE AMBIENTE
         if(not FileExists('AmbienteTeste.txt')) then begin
            if SQLString('SELECT AVERBAATM FROM PARAMETROS WHERE EMPRESA=0'+qREG.FieldByName('EMPRESA').AsString,qAUX)='S' then begin
                case AnsiIndexStr(SQLString('SELECT SEGURADORA FROM CONFIG',qAUX), ['AT&M', 'PORTO SEGURO']) of
                   0: EnviaCteATM(qREG.FieldByName('CODIGO').AsInteger,qAUX);
                   // 1: frmPrin.EnviaPorto(frmFretes.tREGCODIGO.AsInteger);
                end;

               qREG.Refresh;
            end;
         end;
      except on E: Exception do begin
         cEx := e.message;
         if (Pos('DUPLICIDADE',UpperCase(cEx))<>0) and
            (Copy(ACBrCTe1.Conhecimentos.Items[0].CTe.infCTe.ID,4,45) <> qREG.FieldByName('CHAVECTE').AsString) and
            (Pos('0'+qREG.FieldByName('CTE').AsString,ACBrCTe1.Conhecimentos.Items[0].CTe.infCTe.ID)<>0) then begin

            qAUX.Close;
            qAUX.SQL.Text := 'UPDATE FRETES SET '+
            ' CHAVECTE='+QuotedStr(Copy(ACBrCTe1.Conhecimentos.Items[0].CTe.infCTe.ID,4,45))+
            ' WHERE CODIGO=0'+qREG.FieldByName('CODIGO').AsString+
            ' AND EMPRESA=0'+qREG.FieldByName('EMPRESA').AsString;
            sql := qAUX.SQL.Text;
            qAUX.ExecSQL(False);

            qREG.Refresh;
         end;
      end;
      end;

      if (ACBrCTe1.WebServices.Enviar.Protocolo <> '') and (ACBrCTe1.WebServices.Enviar.cStat in [100,103]) then begin
         qAUX.Close;
         qAUX.SQL.Text := 'UPDATE FRETES SET '+
         'ULT_DOWNLOAD_PDF=CURRENT_TIMESTAMP,'+
         'PROTOCOLO='+QuotedStr(ACBrCTe1.WebServices.Enviar.Protocolo)+' '+
         'WHERE CODIGO=0'+qREG.FieldByName('CODIGO').AsString;
         sql := qAUX.SQL.Text;
         qAUX.ExecSQL(False);

      end else if ACBrCTe1.WebServices.Enviar.Recibo<>'' then begin
         qAUX.Close;
         qAUX.SQL.Text := 'UPDATE FRETES SET '+
         'ULT_DOWNLOAD_PDF=CURRENT_TIMESTAMP,'+
         'RECIBO='+QuotedStr(ACBrCTe1.WebServices.Enviar.Recibo)+' '+
         'WHERE CODIGO=0'+qREG.FieldByName('CODIGO').AsString;
         sql := qAUX.SQL.Text;
         qAUX.ExecSQL(False);
      end;

      qAUX.Close;
      qAUX.SQL.Text := 'UPDATE FRETES SET '+
      'STATUS_SEFAZ=0'+IntToStr(ACBrCTe1.WebServices.Enviar.cStat)+' '+
      'WHERE CODIGO=0'+qREG.FieldByName('CODIGO').AsString;
      sql := qAUX.SQL.Text;
      qAUX.ExecSQL(False);

      qREG.Refresh;

      cDownload := '';
      if(cEx = '')then begin

         if(Trim(cPathSalvar) <> '')then begin // caso seja cliente do sigetran
            cAux := cPathSalvar+'\PDFs\'+qREG.FieldByName('CHAVECTE').AsString+'-cte.pdf';

            if FileExists(cAux) then begin
               try
                  MoveFile(Pchar(cAux),Pchar('.\clientes\CTe\'+SoNumero(qUSU.FieldByName('CNPJ').AsString)+'\PDfs\'+qREG.FieldByName('CHAVECTE').AsString+'-cte.pdf'));
               except on E: Exception do
                  GravaLog('Erro:'+e.Message);
               end;
            end;
         end;

         qAUX.Close;
         qAUX.SQL.Text := 'UPDATE FRETES SET SITUACAO=''E'' '+
         'WHERE CODIGO=0'+cCod;
         sql := qAUX.SQL.Text;
         qAUX.ExecSQL(false);

         cDownload := '/clientes/CTe/'+soNUmero(qUSU.FieldByName('CNPJ').AsString)+'/PDFs/'+qREG.FieldByName('CHAVECTE').AsString+'-cte.pdf';

         Result := '{'+
         '"erro":0,'+
         '"mensagem":"CTe enviado com sucesso",'+
         '"tpAmb":"'+TpAmbToStr(ACBrCTe1.WebServices.Enviar.TpAmb)+'",'+
         '"verAplic":"'+ACBrCTe1.WebServices.Enviar.verAplic+'",'+
         '"cStat":"'+IntToStr(ACBrCTe1.WebServices.Enviar.cStat)+'",'+
         '"cUF":"'+IntToStr(ACBrCTe1.WebServices.Enviar.cUF)+'",'+
         '"xMotivo":"'+ACBrCTe1.WebServices.Enviar.xMotivo+'",'+
         '"xMsg":"'+ACBrCTe1.WebServices.Enviar.Msg+'",'+
         '"Recibo":"'+ACBrCTe1.WebServices.Enviar.Recibo+'",'+
         '"Protocolo":"'+ACBrCTe1.WebServices.Enviar.Protocolo+'",'+
         '"pdf":"'+cDownload+'",'+
         '"chave_cte":"'+qREG.FieldByName('CHAVECTE').AsString+'"'+
         '}';

      end else begin
         cEx := TrataMensagemExcept(cEx);

         qAUX.Close;
         qAUX.SQL.Text := 'UPDATE FRETES SET SITUACAO=''R'' '+
         'WHERE CODIGO=0'+cCod;
         sql := qAUX.SQL.Text;
         qAUX.ExecSQL(false);

         Result := '{'+
         '"erro":2,'+
         '"mensagem":"'+cEx+'",'+
         '"tpAmb":"'+TpAmbToStr(ACBrCTe1.WebServices.Enviar.TpAmb)+'",'+
         '"verAplic":"'+ACBrCTe1.WebServices.Enviar.verAplic+'",'+
         '"cStat":"'+IntToStr(ACBrCTe1.WebServices.Enviar.cStat)+'",'+
         '"cUF":"'+IntToStr(ACBrCTe1.WebServices.Enviar.cUF)+'",'+
         '"xMotivo":"'+ACBrCTe1.WebServices.Enviar.xMotivo+'",'+
         '"xMsg":"'+ACBrCTe1.WebServices.Enviar.Msg+'",'+
         '"Recibo":"'+ACBrCTe1.WebServices.Enviar.Recibo+'",'+
         '"Protocolo":"'+ACBrCTe1.WebServices.Enviar.Protocolo+'"'+
         '}';
      end;

      // if frmFretes.tREGCFOP.AsInteger>6000 then
      //    ShowMEssage('Atenção ! Em operações interestaduais é obrigatório envio de MDFe.');
   finally
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(ACBrCte1);
      FreeAndNil(ACBrCTeDACTeRL1);
   end;
end;


procedure TCte.GerarCte(qREG,qAUX,qUSU: TSQLQuery; ACBRCTe1: TACBRCTE;ACBrCTeDACTeRL1:TACBrCTeDACTeRL);
var
  i, j, CodigoMunicipio, Tomador: Integer;
  NumCte,nRegSeg,nCodCte : Integer;
  tmp : String;
  ok : boolean;
  qAUX2 : TSQLQuery;
begin
   qAUX2 := TSQLQuery.Create(Nil);
   qAUX2.SQLConnection := qREG.SQLConnection;
   try
      cCri   := '';
      NumCte := qREG.FieldByName('CTE').AsInteger;
      nCodCte:= qREG.FieldByName('CODCTE').AsInteger;

      if nCodCte = 0 then begin
         nCodCte := GerarCodigoDFe(NumCte);

         qAUX.Close;
         qAUX.SQL.Text := 'UPDATE FRETES SET CODCTE=0'+IntToStr(nCodCte)+' '+
         'WHERE CODIGO=0'+qAUX.FieldByName('CODIGO').AsString;
         sql := qAUX.SQL.Text;
         qAUX.ExecSQL(False);

         qREG.Refresh;
      end;

      with ACBrCTe1.Conhecimentos.Add.CTe do begin
         // Dados de Identificação do CT-e
         if (qREG.FieldByName('ESTADOE').AsString = '') then
            Ide.cUF    := UFtoCUF('MS')
         else
            Ide.cUF    := UFtoCUF(qREG.FieldByName('ESTADOE').AsString);

         // Atenção o valor de cCT tem que ser um numero aleatório conforme recomendação
         // da SEFAZ, mas neste exemplo vamos atribuir o mesmo numero do CT-e.
         //Ide.cCT    := NumCTe;  //
         Ide.cCT    := qREG.FieldByName('CODIGO').AsInteger;  //
         Ide.cCT    := nCodCte;
         // Ide.cCT    := frmFretes.tREGCODCTE.AsInteger; REMOVI GABRIEL
         Ide.CFOP   := qREG.FieldByName('CFOP').AsInteger;
         Ide.natOp  := GetCFOPNome(qREG.FieldByName('CFOP').AsInteger);

         if (qREG.FieldByName('APAGAR').AsString = '1') then
            Ide.forPag := fpPago // ou fpAPagar
         else
            Ide.forPag := fpAPagar; // ou fpAPagar

         Ide.modelo := 57;
         Ide.serie  := 1;
         Ide.nCT    := NumCTe;
         Ide.dhEmi  := qREG.FieldByName('DATA').AsDateTime;
         if ACBrCTe1.DACTe.TipoDACTe=tiPaisagem then
            Ide.tpImp  := tiPaisagem
         else
            Ide.tpImp  := tiRetrato;

         Ide.tpAmb:=ACBrCTe1.Configuracoes.WebServices.Ambiente;
         if (ACBrCTe1.Configuracoes.Geral.FormaEmissao = teContingencia)then begin
            ACBrCTe1.Configuracoes.Geral.FormaEmissao:= teSVCRS;
            Ide.tpEmis := teSVCRS;
         end;

         Ide.tpEmis := ACBrCTe1.Configuracoes.Geral.FormaEmissao;

         case qREG.FieldByName('TIPO').AsInteger of
            0: Ide.tpCTe:=tcNormal;
            1: Ide.tpCTe:=tcComplemento;
            2: Ide.tpCTe:=tcAnulacao;
            3: Ide.tpCTe:=tcSubstituto;
         end;

         Ide.procEmi := peAplicativoContribuinte;
         Ide.verProc := '1.0.0';  //Versão do seu sistema
         // Ide.verProc := Copy('1.0.0'frmPrin.pVer.caption,8,5);  //Versão do seu sistema

         if (qREG.FieldByName('CIDADEE').AsString = '') then
            CodigoMunicipio := StrtonumI(CidadeIBGE('DOURADOS',qREG.FieldByName('ESTADOE').AsString,qAUX2))
         else
            CodigoMunicipio := StrtonumI(CidadeIBGE(qREG.FieldByName('CIDADEE').AsString,qREG.FieldByName('ESTADOE').AsString,qAUX2));

         Ide.cMunEnv := CodigoMunicipio;
         Ide.xMunEnv := qREG.FieldByName('CIDADEE').AsString;
         Ide.UFEnv   := qREG.FieldByName('ESTADOE').AsString;

         if (Ide.xMunEnv='') or (Ide.UFEnv='') then
            cCri := 'Definir cidade e estado da empresa.';

         Ide.modal   := mdRodoviario;

         case StrToNumI('0'+qREG.FieldByName('TIPOSRV').AsString) of
            0: Ide.tpServ:=tsNormal;
            1: Ide.tpServ:=tsSubcontratacao;
            2: Ide.tpServ:=tsRedespacho;
            3: Ide.tpServ:=tsIntermediario;
         end;

         if (qREG.FieldByName('TIPOSRV').AsInteger=1) then begin
            qAUX.Close;
            qAUX.SQL.Text := 'SELECT * FROM FRETESDOCANT WHERE CODIGO=0'+qREG.FieldByName('CODIGO').AsString;
            sql := qAUX.SQL.Text;
            qAUX.Open;

            with infCteNorm.docAnt do begin
               emiDocAnt.Add;
               emiDocAnt[0].CNPJCPF := qAUX.FieldByName('CNPJCPF').AsString;
               emiDocAnt[0].IE      := qAUX.FieldByName('IE').AsString;
               emiDocAnt[0].UF      := qAUX.FieldByName('UF').AsString;
               emiDocAnt[0].xNome   := qAUX.FieldByName('NOME').AsString;
               emiDocAnt[0].idDocAnt.Add;
               emiDocAnt[0].idDocAnt[0].idDocAntEle.Add;
               emiDocAnt[0].idDocAnt[0].idDocAntEle[0].chave := qREG.FieldByName('TIPOCHV').AsString;
               emiDocAnt[0].idDocAnt[0].idDocAntEle[0].chCTe := qREG.FieldByName('TIPOCHV').AsString;
            end;
         end;

         qAUX.Close;
         qAUX.SQL.Text := 'SELECT F.ORIGEM,F.DESTINO '+
         'FROM FRETESVEI F '+
         'WHERE CODIGO=0'+qREG.FieldByName('CODIGO').AsString;
         sql := qAUX.SQL.TExt;
         qAUX.Open;

         // Origem da Prestação
         if (NumeroInicio(qREG.FieldByName('ORIGEM').AsString)<>'') and (qREG.FieldByName('CIDADEO').AsString <> '') then begin
         // if (qREG.FieldByName('CIDADEO').AsString <> '') then begin
            Ide.xMunIni := qREG.FieldByName('CIDADEO').AsString;
            Ide.UFIni   := qREG.FieldByName('UFO').AsString;

            // entende que o usuario digitou cidade/estado
         end else begin
            tmp         := Trim(qAUX.FieldByName('ORIGEM').AsString);
            Ide.xMunIni := Copy(tmp,1,length(tmp)-3);
            Ide.UFIni   := Copy(tmp,length(tmp)-1,2);
         end;

         // Destino da Prestação
         if (NumeroInicio(qREG.FieldByName('ORIGEM').AsString)<>'') and (qREG.FieldByName('CIDADED').AsString <> '') then begin
            GravaLog('Entrou no 1:'+Trim(qREG.FieldByName('CIDADED').AsString));
            Ide.xMunFim := qREG.FieldByName('CIDADED').AsString;
            Ide.UFFim   := qREG.FieldByName('UFD').AsString;
         end else begin
            GravaLog('Entrou no 2:'+Trim(qAUX.FieldByName('DESTINO').AsString));
            tmp         := Trim(qAUX.FieldByName('DESTINO').AsString);
            Ide.xMunFim := Copy(tmp,1,length(tmp)-3);
            Ide.UFFim   := Copy(tmp,length(tmp)-1,2);
         end;

         if(qREG.FieldByName('TOMADOR').AsString = qREG.FieldByName('REMETENTE').AsString)then
            Tomador := 0
         else if (qREG.FieldByName('TOMADOR').AsString = qREG.FieldByName('DESTINATARIO').AsString) then
            Tomador := 3
         else
            Tomador := 4;

         case Tomador of
            0: Ide.Toma03.Toma := tmRemetente;
            1: Ide.Toma03.Toma := tmExpedidor;
            2: Ide.Toma03.Toma := tmRecebedor;
            3: Ide.Toma03.Toma := tmDestinatario;
            4: Ide.Toma03.Toma := tmOutros;
         end;

         Ide.indIEToma := inContribuinte; // inIsento, inNaoContribuinte

         // Tomador do Serviço no CTe 4 = Outros
         if Tomador = 4 then begin
            qAUX.Close;
            qAUX.SQL.Text :='SELECT * FROM CLIENTES WHERE CODIGO=0'+qREG.FieldByName('TOMADOR').AsString;
            sql := qAUX.SQL.Text;
            qAUX.Open;

            Ide.Toma4.Toma    := tmOutros;
            Ide.Toma4.CNPJCPF := SoNumero(qAUX.FieldByName('CNPJ').AsString); // CNPJ do Tomador do Serviço
            if (qAUX.FieldByName('IE').AsString='ISENTO') OR (Trim(qAUX.FieldByName('IE').AsString)='') then
               Ide.Toma4.IE := 'ISENTO'
            else
               Ide.Toma4.IE := SoNumero(qAUX.FieldByName('IE').AsString);
            if Ide.toma4.IE='' then
               cCri:=cCri+'Definir Inscrição Estadual do cliente.';

            Ide.Toma4.xNome          := qAUX.FieldByName('NOME').AsString;
            Ide.Toma4.xFant          := qAUX.FieldByName('FANTASIA').AsString;
            Ide.Toma4.fone           := SoNumero(qAUX.FieldByName('TELEFONE').AsString);
            Ide.Toma4.EnderToma.xLgr := qAUX.FieldByName('ENDERECO').AsString;
            if qAUX.FieldByName('NUMERO').AsInteger=0 then
               Ide.Toma4.enderToma.nro := 'S/N'
            else
               Ide.Toma4.enderToma.nro := qAUX.FieldByName('NUMERO').AsString;

            Ide.Toma4.EnderToma.xCpl    := qAUX.FieldByName('COMPLEMENTO').AsString;
            Ide.Toma4.EnderToma.xBairro := qAUX.FieldByName('BAIRRO').AsString;
            Ide.Toma4.EnderToma.cMun    := StrtonumI(CidadeIBGE(qAUX.FieldByName('CIDADE').AsString,qAUX.FieldByName('UF').AsString,qAUX2));
            Ide.Toma4.EnderToma.xMun    := qAUX.FieldByName('CIDADE').AsString;
            Ide.Toma4.EnderToma.CEP     := StrToint('0'+SoNumero(qAUX.FieldByName('CEP').AsString));
            Ide.Toma4.EnderToma.UF      := qAUX.FieldByName('UF').AsString;
            Ide.Toma4.EnderToma.cPais   := 1058;
            Ide.Toma4.EnderToma.xPais   := 'BRASIL';
            if (Ide.toma4.IE='') or (Ide.toma4.CNPJCPF='') then
               cCri:=cCri+'Definir CNPJ e IE do cliente.';
         end;

         //
         //  Informações Complementares do CTe
         //
         compl.xCaracAd  := '';

        // caracteristica adicional serviço
         compl.xCaracSer := '';

         // usuario
         compl.xEmi      := qREG.FieldByName('USUINC').AsString;

         compl.fluxo.xOrig := '';
         compl.fluxo.xDest := '';
         compl.fluxo.xRota := '';

         // DATA DE ENTREGA
         if (qREG.FieldByName('DIASENTREGA').AsInteger=0) then
            compl.Entrega.TipoData := tdSemData
         else
            compl.Entrega.TipoData := tdAteData;
         case compl.Entrega.TipoData of
            tdSemData: compl.Entrega.semData.tpPer := tdSemData;
            tdAteData: begin
               compl.Entrega.comData.tpPer := compl.Entrega.TipoData;
               compl.Entrega.comData.dProg := qREG.FieldByName('DATA').ASDateTime+qREG.FieldByName('DIASENTREGA').AsInteger;
            end;
            tdNoPeriodo: begin
               compl.Entrega.noPeriodo.tpPer := tdNoPeriodo;
               compl.Entrega.noPeriodo.dIni  := qREG.FieldByName('DATA').ASDateTime;
               compl.Entrega.noPeriodo.dFim  := qREG.FieldByName('DATA').ASDateTime+30;
            end;
         end;

         // HORA DE ENTREGA
         compl.Entrega.TipoHora := thSemHorario;
         case compl.Entrega.TipoHora of
            thSemHorario: compl.Entrega.semHora.tpHor := thSemHorario;
            thNoHorario, thAteHorario, thApartirHorario: begin
               compl.Entrega.comHora.tpHor := compl.Entrega.TipoHora;
               compl.Entrega.comHora.hProg := StrToTime('10:00');
            end;
            thNoIntervalo: begin
               compl.Entrega.noInter.tpHor := thNoIntervalo;
               compl.Entrega.noInter.hIni  := StrToTime('08:00');
               compl.Entrega.noInter.hFim  := StrToTime('17:00');
            end;
         end;

         compl.origCalc := Copy(qREG.FieldByName('ORIGEM').AsString+' '+qREG.FieldByName('NOMEO').AsString,1,40);
         compl.destCalc := Copy(qREG.FieldByName('DESTINO').AsString+' '+qREG.FieldByName('NOMED').AsString,1,40);

         compl.xObs     := qREG.FieldByName('OBS1').AsString+#13+#10+
                           iif(trim(qREG.FieldByName('OBS2').AsString)<>'',qREG.FieldByName('OBS2').AsString+#13+#10,'')+
                           iif(trim(qREG.FieldByName('OBS3').AsString)<>'',qREG.FieldByName('OBS3').AsString+#13+#10,'')+
                           iif(trim(qREG.FieldByName('OBS4').AsString)<>'',qREG.FieldByName('OBS4').AsString+#13+#10,'');

         Emit.CNPJ := SoNumero(qUSU.FieldByName('CNPJ').AsString);

         //{Obrigatório na versão 4.00}  //crtNenhum, crtSimplesNacional, crtSimplesExcessoReceita, crtRegimeNormal,crtSimplesNacionalMEI
         if (ACBrCTe1.Configuracoes.Geral.VersaoDF = ve400) then
            Emit.CRT  := StrToCRTCTe(ok,qUSU.FieldByname('REGIME').AsString);
         //Emit.CNPJ := '10662293000126';

         if (qUSU.FieldByName('IE').AsString='ISENTO') or (qUSU.FieldByName('IE').AsString='') then
            Emit.IE:='ISENTO'
         else
            Emit.IE:=SoNumero(qUSU.FieldByName('IE').AsString);

         if Emit.IE='' then
            cCri:=cCri+'Definir Inscrição Estadual da empresa.';

         Emit.xNome := qUSU.FieldByName('NOMEE').AsString;
         Emit.xFant := qUSU.FieldByName('FANTASIA').AsString;
         Emit.EnderEmit.xLgr := qUSU.FieldByName('ENDERECOE').AsString;

         if qUSU.FieldByName('NUMEROE').AsInteger=0 then
            Emit.EnderEmit.nro := 'S/N'
         else
            Emit.EnderEmit.nro := qUSU.FieldByName('NUMEROE').AsString;

         Emit.EnderEmit.xCpl    := qUSU.FieldByName('COMPLEMENTOE').AsString;
         Emit.EnderEmit.xBairro := qUSU.FieldByName('BAIRROE').AsString;

         // o mesmo gerado acima no inicio.
         //CodigoMunicipio:=frmPrin.CidadeIBGE(inttostr(Ide.cUF),frmPrin.tTRACIDADE.AsString);
         Emit.EnderEmit.cMun := CodigoMunicipio;
         Emit.EnderEmit.xMun := qUSU.FieldByName('CIDADEE').AsString;
         Emit.EnderEmit.CEP  := StrToIntDef('0'+SoNumero(qUSU.FieldByName('CEPE').AsString), 0);
         Emit.EnderEmit.UF   := qUSU.FieldByName('ESTADOE').AsString;
         Emit.EnderEmit.fone := qUSU.FieldByName('TELEFONE').AsString;

         if (qAUX.eof) or (qAUX.FindField('CIDADE')=nil) then begin
            qAUX.Close;
            qAUX.SQL.Clear;
            qAUX.SQL.Add('SELECT NOME,CIDADE,UF FROM FORNECEDORES WHERE CODIGO=0'+NumeroInicio(qREG.FieldByName('REMETENTE').AsString));
            qAUX.Open;
         end;

         // caso nao tenha cidade de origem, pega a mesma do remetente.
         if (Ide.xMunIni='') and (qAUX.FieldByName('CIDADE').AsString<>'') then begin
            Ide.cMunIni := StrtonumI(CidadeIBGE(qAUX.FieldByName('CIDADE').AsString,qAUX.FieldByName('UF').AsString,qAUX2));
            Ide.xMunIni := qAUX.FieldByName('CIDADE').AsString;
            Ide.UFIni   := qAUX.FieldByName('UF').AsString;
         end;

         //
         //  Dados do Remetente
         //
         qAUX.Close;
         qAUX.SQL.Clear;
         qAUX.SQL.Add('SELECT * FROM '+iif(qREG.FieldByName('REMQUEM').AsString='C','CLIENTES','FORNECEDORES'));
         qAUX.SQL.Add('WHERE CODIGO=0'+qREG.FieldByName('REMETENTE').AsString);
         qAUX.Open;

         Rem.xNome := qAUX.FieldByName('NOME').AsString;
         Rem.xFant := qAUX.FieldByName('FANTASIA').AsString;
         Rem.EnderReme.xLgr := qAUX.FieldByName('ENDERECO').AsString;

         if qAUX.FieldByName('NUMERO').AsInteger=0 then
            Rem.EnderReme.nro := 'S/N'
         else
            Rem.EnderReme.nro := qAUX.FieldByName('NUMERO').AsString;

         Rem.EnderReme.xCpl    := qAUX.FieldByName('COMPLEMENTO').AsString;
         Rem.EnderReme.xBairro := qAUX.FieldByName('BAIRRO').AsString;
         Rem.EnderReme.cMun    := StrtonumI(CidadeIBGE(qAUX.FieldByName('CIDADE').AsString,qAUX.FieldByName('UF').AsString,qAUX2));
         Rem.EnderReme.xMun    := qAUX.FieldByName('CIDADE').AsString;
         Rem.EnderReme.CEP     := StrToIntDef('0'+SoNumero(qAUX.FieldByName('CEP').AsString), 0);
         Rem.EnderReme.UF      := qAUX.FieldByName('UF').AsString;
         Rem.EnderReme.cPais   := 1058;
         Rem.EnderReme.xPais   := 'BRASIL';
         Rem.CNPJCPF           := SoNumero(qAUX.FieldByName('CNPJ').AsString);

         if (qAUX.FieldByName('IE').AsString='ISENTO') OR (Trim(qAUX.FieldByName('IE').AsString)='')  then
            Rem.IE := 'ISENTO'
         else
            Rem.IE := SoNumero(qAUX.FieldByName('IE').AsString);

         if Rem.IE='' then
            cCri := cCri+'Definir Inscrição Estadual do Remetente.';

         Rem.fone := SoNumero(qAUX.FieldByName('TELEFONE').AsString);

         if Ide.UFIni='' then
            Ide.UFIni:=Rem.EnderReme.UF;

         if Ide.xMunIni='' then
            Ide.xMunIni:=Rem.EnderReme.xMun;

         Ide.cMunIni := StrtonumI(CidadeIBGE(Ide.xMunIni,Ide.UFIni,qAUX2));

         GravaLog('Ide.UFIni:'+Ide.UFIni);
         GravaLog('Ide.xMunIni:'+Ide.xMunIni);

         GravaLog('Rem.EnderReme.UF:'+IntToStr(Ide.cMunIni));
         GravaLog('Rem.EnderReme.UF:'+Rem.EnderReme.UF);
         GravaLog('Rem.EnderReme.xMun:'+Rem.EnderReme.xMun);

         if (Ide.cMunIni=0) or (Ide.xMunIni='') or (Ide.UFIni = '') then
            cCri:=cCri+'Definir cidade e estado (UF) da origem.';

         Ide.retira  := rtSim;
         Ide.xdetretira := '';

         qAUX.Close;
         qAUX.SQL.Text := 'SELECT * '+
         'FROM FRETENOTAS '+
         'WHERE CODIGO=0'+qREG.FieldByName('CODIGO').AsString;
         sql := qAUX.SQL.Text;
         qAUX.Open;

         while not(qAUX.Eof) do begin
            if UpperCase(qAUX.FieldByName('TIPO').AsString)='NFE' then begin
               with infCteNorm.infDoc.InfNFe.Add do
                 chave := qAUX.FieldByName('CHAVE').AsString;
            end else begin
               with infCteNorm.infDoc.InfNF.Add do begin
                 nDoc  := qAUX.FieldByName('NUMERO').AsString;
                 Serie := qAUX.FieldByName('SERIE').AsString;
                 nPeso := RoundTo(qAUX.FieldByName('QUANTIDADE').AsFloat, -2);
                 dEmi  := qAUX.FieldByName('DATA').AsDateTime;
                 vNf   := qAUX.FieldByName('VRMERCADORIA').AsFloat;
                 nCFOP := 5102;
               end;
            end;

            qAUX.next;
         end;

         //
         //  Dados do Destinatario
         //
         qAUX.Close;
         qAUX.SQL.Clear;
         qAUX.SQL.Add('SELECT * FROM '+iif(qREG.FieldByName('DESQUEM').AsString='C','CLIENTES','FORNECEDORES'));
         qAUX.SQL.Add('WHERE CODIGO=0'+qREG.FieldByName('DESTINATARIO').AsString);
         qAUX.Open;

         Dest.xNome          := qAUX.FieldByName('NOME').AsString;
         Dest.EnderDest.xLgr := qAUX.FieldByName('ENDERECO').AsString;
         if qAUX.FieldByName('NUMERO').AsInteger = 0 then
            Dest.EnderDest.nro := 'S/N'
         else
            Dest.EnderDest.nro := qAUX.FieldByName('NUMERO').AsString;
         Dest.EnderDest.xCpl    := qAUX.FieldByName('COMPLEMENTO').AsString;
         Dest.EnderDest.xBairro := qAUX.FieldByName('BAIRRO').AsString;
         Dest.EnderDest.cMun    := StrtoNumI(CidadeIBGE(qAUX.FieldByName('CIDADE').AsString,qAUX.FieldByName('UF').AsString,qAUX2));
         Dest.EnderDest.xMun    := qAUX.FieldByName('CIDADE').AsString;
         Dest.EnderDest.CEP     := StrToIntDef('0'+SoNumero(qAUX.FieldByName('CEP').AsString), 0);
         Dest.EnderDest.UF      := qAUX.FieldByName('UF').AsString;
         Dest.EnderDest.cPais   := 1058;
         Dest.EnderDest.xPais   := 'BRASIL';
         Dest.CNPJCPF           := SoNumero(qAUX.FieldByName('CNPJ').AsString);
         if (qAUX.FieldByName('IE').AsString = 'ISENTO') OR (Trim(qAUX.FieldByName('IE').AsString)='') then
            Dest.IE:='ISENTO'
         else
            Dest.IE:=SoNumero(qAUX.FieldByName('IE').AsString);

         if Dest.IE='' then
            cCri:=cCri+'Definir Inscrição Estadual do Destinatário.';

         Dest.fone := SoNumero(qAUX.FieldByName('TELEFONE').AsString);
         Dest.ISUF := SoNumero(qAUX.FieldByName('SUFRAMA').AsString); // Inscrição no SUFRAMA

         // caso nao tenha cidade de origem, pega a mesma do remetente.
         if (Ide.xMunFim='') and (qAUX.FieldByName('CIDADE').AsString <> '') then begin
            Ide.cMunFim := StrToNumI(CidadeIBGE(qAUX.FieldByName('CIDADE').AsString,qAUX.FieldByName('UF').AsString,qAUX2));
            Ide.xMunFim := qAUX.FieldByName('CIDADE').AsString;
            Ide.UFFim   := qAUX.FieldByName('UF').AsString;
         end;

         if Ide.UFFim='' then
            Ide.UFFim:=Dest.EnderDest.UF;
         if Ide.xMunFim='' then
            Ide.xMunFim:=Dest.EnderDest.xMun;

         Ide.cMunFim := StrtonumI(CidadeIBGE(Ide.xMunFim,Ide.UFFim,qAUX2));
         if (Ide.cMunFim=0) or (Ide.xMunFim='') or (Ide.UFFim='') then
            cCri:=cCri+'Definir cidade e estado (UF) do destino.';

         // Local de Entrega
         if Trim(qAUX.FieldByName('CNPJ').AsString) <> '' then begin
            Dest.locEnt.CNPJCPF := qAUX.FieldByName('CNPJ').AsString;
            Dest.locEnt.xNome   := qAUX.FieldByName('NOME').AsString;
            Dest.locEnt.xLgr    := qAUX.FieldByName('ENDERECO').AsString;
            if (qAUX.FieldByName('NUMERO').AsInteger = 0) then
               Dest.locEnt.nro := 'S/N'
            else
               Dest.locEnt.nro := qAUX.FieldByName('NUMERO').AsString;
            Dest.locEnt.xCpl   := qAUX.FieldByName('COMPLEMENTO').AsString;
            Dest.locEnt.xBairro:= qAUX.FieldByName('BAIRRO').AsString;
            CodigoMunicipio    := StrtonumI(CidadeIBGE(qAUX.FieldByName('CIDADE').AsString,qAUX.FieldByName('UF').AsString,qAUX2));
            Dest.locEnt.cMun   := CodigoMunicipio;
            Dest.locEnt.xMun   := qAUX.FieldByName('CIDADE').AsString;
            Dest.locEnt.UF     := qAUX.FieldByName('UF').AsString;
         end;

         //
         //  Dados do Expedidor
         //

         qAUX.Close;
         qAUX.SQL.Clear;
         qAUX.SQL.Add('SELECT * FROM '+iif(qREG.FieldByName('REMQUEM').AsString='C','CLIENTES','FORNECEDORES'));
         qAUX.SQL.Add('WHERE CODIGO=0'+qREG.FieldByName('REMETENTE').AsString);
         qAUX.Open;

         Exped.xNome           := qAUX.FieldByName('NOME').AsString;
         Exped.EnderExped.xLgr := qAUX.FieldByName('ENDERECO').AsString;
         if qAUX.FieldByName('NUMERO').AsInteger<>0 then
            Exped.EnderExped.nro := qAUX.FieldByName('NUMERO').AsString
         else
            Exped.EnderExped.nro:='S/N';
         Exped.EnderExped.xCpl    := qAUX.FieldByName('COMPLEMENTO').AsString;
         Exped.EnderExped.xBairro := qAUX.FieldByName('BAIRRO').AsString;
         Exped.EnderExped.cMun    := StrtonumI(CidadeIBGE(qAUX.FieldByName('CIDADE').AsString,qAUX.FieldByName('UF').AsString,qAUX2));
         Exped.EnderExped.xMun    := qAUX.FieldByName('CIDADE').AsString;
         Exped.EnderExped.CEP     := StrToIntDef(qAUX.FieldByName('CEP').AsString, 0);
         Exped.EnderExped.UF      := qAUX.FieldByName('UF').AsString;
         Exped.EnderExped.cPais   := 1058;
         Exped.EnderExped.xPais   := 'BRASIL';
         Exped.CNPJCPF            := qAUX.FieldByName('CNPJ').AsString;
         Exped.IE                 := (qAUX.FieldByName('IE').AsString);
         Exped.fone               := (qAUX.FieldByName('TELEFONE').AsString);

         qAUX.Close;
         qAUX.SQL.Clear;
         qAUX.SQL.Add('SELECT * FROM ORIGENS WHERE CODIGO=0'+qREG.FieldByName('ORIGEM').AsString);
         qAUX.Open;
         if Trim(qAUX.FieldByName('CNPJ').AsString)='' then begin
            qAUX.Close;
            qAUX.SQL.Clear;
            qAUX.SQL.Add('SELECT * FROM '+iif(qREG.FieldByName('REMQUEM').AsString='C','CLIENTES','FORNECEDORES'));
            qAUX.SQL.Add('WHERE CODIGO=0'+qREG.FieldByName('REMETENTE').AsString);
            sql := qAUX.SQL.Text;
            qAUX.Open;
         end;

         if (qREG.FieldByName('DESTINO').AsString <> '') and not(qAUX.Eof) and (SoNumero(qAUX.FieldByName('CNPJ').AsString) <> Rem.CNPJCPF)then begin
            Exped.xNome := qAUX.FieldByName('NOME').AsString;
            Exped.EnderExped.xLgr := qAUX.FieldByName('ENDERECO').AsString;
            if qAUX.FieldByName('NUMERO').AsInteger <> 0 then
               Exped.EnderExped.nro := qAUX.FieldByName('NUMERO').AsString
            else
               Exped.EnderExped.nro := 'S/N';
            Exped.EnderExped.xCpl := qAUX.FieldByName('COMPLEMENTO').AsString;
            Exped.EnderExped.xBairro := qAUX.FieldByName('BAIRRO').AsString;
            Exped.EnderExped.cMun := StrTonumI(CidadeIBGE(qAUX.FieldByName('CIDADE').AsString,qAUX.FieldByName('UF').AsString,qAUX2));
            Exped.EnderExped.xMun := qAUX.FieldByName('CIDADE').AsString;
            Exped.EnderExped.CEP := StrToIntDef('0'+SoNumero(qAUX.FieldByName('CEP').AsString), 0);
            Exped.EnderExped.UF := qAUX.FieldByName('UF').AsString;
            Exped.EnderExped.cPais := 1058;
            Exped.EnderExped.xPais := 'BRASIL';
            Exped.CNPJCPF := (qAUX.FieldByName('CNPJ').AsString);
            Exped.IE:=(qAUX.FieldByName('IE').AsString);
            Exped.fone:=(qAUX.FieldByName('TELEFONE').AsString);
         end;

         qAUX.Close;
         qAUX.SQL.Clear;
         qAUX.SQL.Add('SELECT * FROM DESTINOS WHERE CODIGO=0'+qREG.FieldByName('DESTINO').AsString);
         sql := qAUX.SQL.Text;
         qAUX.Open;

         if Trim(qAUX.FieldByName('CNPJ').AsString)='' then begin
            qAUX.Close;
            qAUX.SQL.Clear;
            qAUX.SQL.Add('SELECT * FROM '+iif(qREG.FieldByName('DESQUEM').AsString='C','CLIENTES','FORNECEDORES'));
            qAUX.SQL.Add('WHERE CODIGO=0'+qREG.FieldByName('DESTINATARIO').AsString);
            qAUX.Open;
         end;

         if (qREG.FieldByName('ORIGEM').AsString<>'') and (not(qAUX.Eof)) and (SoNumero(qAUX.FieldByName('CNPJ').AsString)<>Dest.CNPJCPF)then begin
            Receb.xNome:=qAUX.FieldByName('NOME').AsString;
            Receb.EnderReceb.xLgr:=qAUX.FieldByName('ENDERECO').AsString;
            if qAUX.FieldByName('NUMERO').AsInteger<>0 then
               Receb.EnderReceb.nro:=qAUX.FieldByName('NUMERO').AsString
            else
               Receb.EnderReceb.nro:='S/N';
            Receb.EnderReceb.xCpl:=qAUX.FieldByName('COMPLEMENTO').AsString;
            Receb.EnderReceb.xBairro:=qAUX.FieldByName('BAIRRO').AsString;
            Receb.EnderReceb.cMun:=StrtonumI(CidadeIBGE(qAUX.FieldByName('CIDADE').AsString,qAUX.FieldByName('UF').AsString,qAUX2));
            Receb.EnderReceb.xMun:=qAUX.FieldByName('CIDADE').AsString;
            Receb.EnderReceb.CEP:=StrToIntDef('0'+SoNumero(qAUX.FieldByName('CEP').AsString), 0);
            Receb.EnderReceb.UF:=qAUX.FieldByName('UF').AsString;
            Receb.EnderReceb.cPais:=1058;
            Receb.EnderReceb.xPais:='BRASIL';
            Receb.CNPJCPF := qAUX.FieldByName('CNPJ').AsString;
            Receb.IE:=qAUX.FieldByName('IE').AsString;
            Receb.fone:=qAUX.FieldByName('TELEFONE').AsString;

         end;

         vPrest.vTPrest := RoundTo(qREG.FieldByName('VALOR').AsFloat, -2);
         if (qREG.FieldByName('CST').AsString='60') and (SQLString('SELECT CTEICMS FROM PEDIDOS WHERE CODIGO=0'+qREG.FieldByName('PEDIDO').AsString,qAUX2)='S') then
            vPrest.vTPrest:= qREG.FieldByName('BASE').AsFloat;

         if SQLString('SELECT RECICMS FROM FRETESVEI WHERE CODIGO=0'+qREG.FieldByName('CODIGO').AsString,qAUX2)='S' then begin
            // tive que colocar igual, a sefaz nao aceitava mais
            vPrest.vTPrest := RoundTo(qREG.FieldByName('VALOR').AsFloat+qREG.FieldByName('ICMS').AsFloat, -2);
            vPrest.vRec    := RoundTo(qREG.FieldByName('VALOR').AsFloat+qREG.FieldByName('ICMS').AsFloat, -2)
         end else
            vPrest.vRec    := RoundTo(qREG.FieldByName('VALOR').AsFloat, -2);

         // Relação dos Componentes da Prestação de Serviço
         // FRETE BRUTO
         with vPrest.comp.Add do begin
           xNome:='VALOR FRETE';
           vComp:=RoundTo(qREG.FieldByName('VALOR').AsFloat-qREG.FieldByName('PEDAGIO').AsFloat, -2);
         end;

         // PEDAGIO
         if qREG.FieldByName('PEDAGIO').AsFloat<>0.00 then begin
            with vPrest.comp.Add do begin
              xNome:='(+)PEDAGIO';
              vComp:=RoundTo(qREG.FieldByName('PEDAGIO').AsFloat, -2);
            end;
         end;

         // SEGURO
         if qREG.FieldByName('SEGURO').AsFloat <> 0.00 then begin
            with vPrest.comp.Add do begin
              xNome:='(+)SEGURO';
              vComp:=RoundTo(qREG.FieldByName('SEGURO').AsFloat, -2);
            end;
         end;

         // OUTRO
         if qREG.FieldByName('OUTROS').AsFloat<>0.00 then begin
            with vPrest.comp.Add do begin
              xNome:='(+)OUTROS';
              vComp:=RoundTo(qREG.FieldByName('OUTROS').AsFloat, -2);
            end;
         end;

         // ESTADIA
         if qREG.FieldByName('ESTADIA').AsFloat<>0.00 then begin
            with vPrest.comp.Add do begin
              xNome:='(-)DESCONTOS';
              vComp:=RoundTo(qREG.FieldByName('SECCAT').AsFloat, -2);
            end;
         end;

         if (qREG.FieldByName('CST').AsString='0') or
            (Copy(qREG.FieldByName('CSTN').AsString,1,7)='SIMPLES') then begin

            Imp.ICMS.ICMSSN.indSN := 1;
            imp.ICMS.SituTrib := cstICMSSN;
         end else begin
            Imp.ICMS.ICMSSN.indSN := 0;
            case qREG.FieldByName('CST').AsInteger of
               00: begin
                  Imp.ICMS.SituTrib    := cst00;
                  Imp.ICMS.ICMS00.CST   := cst00; // Tributação Normal ICMS
                  Imp.ICMS.ICMS00.vBC   := RoundTo(qREG.FieldByName('BASE').AsFloat, -2);
                  Imp.ICMS.ICMS00.pICMS := RoundTo(qREG.FieldByName('ALIQUOTA').AsFloat, -2);
                  Imp.ICMS.ICMS00.vICMS := RoundTo(Divide(qREG.FieldByName('BASE').AsFloat*qREG.FieldByName('ALIQUOTA').AsFloat,100), -2);
               end;
               20: begin
                  Imp.ICMS.SituTrib      := cst20;
                  Imp.ICMS.ICMS20.CST    := cst20; // Tributação com BC reduzida do ICMS
                  Imp.ICMS.ICMS20.pRedBC := RoundTo(qREG.FieldByName('BASERED').AsFloat, -2);
                  Imp.ICMS.ICMS20.vBC    := RoundTo(qREG.FieldByName('BASE').AsFloat, -2);
                  Imp.ICMS.ICMS20.pICMS  := RoundTo(qREG.FieldByName('ALIQUOTA').AsFloat, -2);
                  Imp.ICMS.ICMS20.vICMS  := RoundTo(Divide(qREG.FieldByName('BASE').AsFloat*qREG.FieldByName('ALIQUOTA').AsFloat,100), -2);
               end;

               40: begin
                  Imp.ICMS.SituTrib  := cst40;
                  Imp.ICMS.ICMS45.CST := cst40; // ICMS Isento
               end;

               41: begin
                 Imp.ICMS.SituTrib  := cst41;
                 Imp.ICMS.ICMS45.CST := cst41; // ICMS não Tributada
               end;

               51: begin
                  Imp.ICMS.SituTrib  := cst51;
                  Imp.ICMS.ICMS45.CST := cst51; // ICMS diferido
               end;

               60: begin
                  Imp.ICMS.SituTrib  := cst60;
                  Imp.ICMS.ICMS60.CST := cst60;
                  Imp.ICMS.ICMS60.vBCSTRet  := RoundTo(qREG.FieldByName('BASE').AsFloat, -2);
                  Imp.ICMS.ICMS60.pICMSSTRet:= RoundTo(qREG.FieldByName('ALIQUOTA').AsFloat, -2);
                  Imp.ICMS.ICMS60.vICMSSTRet:= RoundTo(Divide(qREG.FieldByName('BASE').AsFloat*qREG.FieldByName('ALIQUOTA').AsFloat,100), -2);
               end;

               90: begin
                  Imp.ICMS.SituTrib      := cst90;
                  Imp.ICMS.ICMS90.CST    := cst90; // ICMS Outros
                  Imp.ICMS.ICMS90.pRedBC := RoundTo(qREG.FieldByName('BASERED').AsFloat, -2);
                  Imp.ICMS.ICMS90.vBC    := RoundTo(qREG.FieldByName('BASE').AsFloat, -2);
                  Imp.ICMS.ICMS90.pICMS  := RoundTo(qREG.FieldByName('ALIQUOTA').AsFloat, -2);
                  Imp.ICMS.ICMS90.vICMS  := RoundTo(Divide(qREG.FieldByName('BASE').AsFloat * qREG.FieldByName('ALIQUOTA').AsFloat,100), -2);
                  Imp.ICMS.ICMS90.vCred  := RoundTo(Divide(qREG.FieldByName('BASE').AsFloat * qREG.FieldByName('ALIQUOTA').AsFloat,100), -2);
               end;
            end;
         end;

         //
         //  Informações da Carga
         //
         infCteNorm.infCarga.vCarga  := RoundTo(qREG.FieldByName('VRMERCADORIA').AsFloat, -2);
         infCteNorm.infCarga.proPred := qREG.FieldByName('PRODUTO').AsString+' '+qREG.FieldByName('NOMEPROD').AsString;
         infCteNorm.infCarga.xOutCat := qREG.FieldByName('ESPECIE').AsString;

         // UnidMed = (uM3,uKG, uTON, uUNIDADE, uLITROS);
         with infCteNorm.infCarga.InfQ.Add do begin
            cUnid := uKg;
            if qREG.FieldByName('UNIDADE').AsString='CX' then
               tpMed  := 'UNIDADE'
            else
               //tpMed  := 'PESO NFe';
               tpMed  := 'PESO BASE DE CALCULO';

            qCarga := RoundTo(qREG.FieldByName('QUANTIDADE').AsFloat, -2);
         end;

         //
         //  Informações da Seguradora
         //
         qAUX.Close;
         if qREG.FieldByName('PEDIDO').AsInteger<>0 then
            qAUX.SQL.Text := 'SELECT S.*,F.NOME FROM SEGUROS S '+
            'LEFT JOIN FORNECEDORES F ON F.CODIGO=S.TRANSAC '+
            'WHERE S.CODIGO='+
            '(SELECT P.SEGUROCOD FROM PEDIDOS P WHERE P.CODIGO=0'+qREG.FieldByName('PEDIDO').AsString+') AND S.ATIVA=''S'' '
         else
            qAUX.SQL.Text := 'SELECT S.*,F.NOME '+
            'FROM SEGUROS S '+
            'LEFT JOIN FORNECEDORES F ON F.CODIGO=S.TRANSAC '+
            'WHERE S.ATIVA=''S'' ORDER BY DATA DESC';
         sql := qAUX.SQL.Text;
         qAUX.Open;

         nRegSeg := 0;
         if qAUX.FieldBYName('CODIGO').AsString<>'' then begin
            Inc(nRegSeg);

            qAUX2.Close;
            qAUX2.SQL.Text := 'UPDATE OR INSERT INTO FRETESSEG (CODIGO,ITEM,SEGURO) VALUES('+
            qREG.FieldByName('CODIGO').AsString+','+IntToStr(nRegSeg)+','+qAUX.FieldBYName('CODIGO').AsString+')';
            sql := qAUX2.SQL.TExt;
            qAUX2.ExecSQL(False);
            while not(qAUX.Eof) do begin
               with infCteNorm.seg.Add do begin
                  case qAUX.FieldBYName('RESPONSAVEL').AsInteger of
                     0: respSeg:=rsRemetente;
                     1: respSeg:=rsExpedidor;
                     2: respSeg:=rsRecebedor;
                     3: respSeg:=rsDestinatario;
                     4: respSeg:=rsEmitenteCTe;
                     5: respSeg:=rsTomadorServico;
                  end;

                  xSeg  := Copy(qAUX.FieldByName('NOME').AsString,1,30);
                  nApol := qAUX.FieldByName('APOLICE').AsString;
               end;
               qAUX.Next;
            end;
         end else begin
            with infCteNorm.seg.Add do begin
               respSeg := rsRemetente;
               xSeg    := '';
               nApol   := '';
               nAver   := '';
            end;
         end;

         //
         //  Dados do Modal Rodoviário
         //
         infCteNorm.Rodo.RNTRC := qUSU.FieldByName('RNTRC').AsString;
         infCteNorm.Rodo.dPrev := (qREG.FieldByName('DATA').AsDateTime+Max(qREG.FieldByName('DIASENTREGA').AsInteger,1));
         infCteNorm.Rodo.Lota  := ltSim;

         ACBrCTeDACTeRL1.Usuario := qUSU.FieldByName('CODIGO').ASString;

         infCteNorm.Rodo.lota := ltSim;
         with infCteNorm.Rodo.moto.add do begin
            qAUX.Close;
            qAUX.SQl.Text := 'SELECT M.NOME,M.CPF,V.* '+
            'FROM MOTORISTAS M '+
            'LEFT JOIN VEICULO V ON V.CODIGO=0'+qREG.FieldByName('VEICULO').AsString+' '+
            'WHERE M.CODIGO=0'+qREG.FieldByName('MOTORISTA').AsString;
            sql := qAUX.SQL.Text;
            qAUX.Open;

            xNome := qAUX.FieldByName('NOME').AsString;
            CPF   := SoNumero(qAUX.FieldByName('CPF').AsString);
         end;

         Compl.ObsCont.Clear;
         with compl.ObsCont do begin
            with Add do begin
               xCampo := 'CPF:';
               xTexto := qAUX.FieldByName('CPF').AsString
            end;

            with Add do begin
               xCampo := 'MOTORISTA';
               xTexto := qAUX.FieldByName('NOME').AsString;
            end;

            with Add do begin
               tmp:='';
               if trim(qAUX.FieldByName('CAR1PLACA').AsString)<>'' then
                  tmp:=tmp+'CARRETA1: '+qAUX.FieldByName('CAR1PLACA').AsString+' '+
                           'RENAVAN1: '+qAUX.FieldByName('CAR1RENAVAN').AsString;
               if trim(qAUX.FieldByName('CAR2PLACA').AsString)<>'' then
                  tmp:=tmp+'CARRETA2: '+qAUX.FieldByName('CAR2PLACA').AsString+' '+
                           'RENAVAN2: '+qAUX.FieldByName('CAR2RENAVAN').AsString;
               if trim(qAUX.FieldByName('CAR3PLACA').AsString)<>'' then
                  tmp:=tmp+'CARRETA3: '+qAUX.FieldByName('CAR3PLACA').AsString+' '+
                           'RENAVAN3: '+qAUX.FieldByName('CAR3RENAVAN').AsString;
               xCampo:='VEICULO';
               xTexto:='PLACA:'+qAUX.FieldByName('PLACA').AsString+' '+
                       'RENAVAM:'+qAUX.FieldByName('RENAVAN').AsString+' '+tmp;
            end;
         end;

         qAUX.Close;
         qAUX.SQL.Text := 'SELECT NOME,CNPJ,RNTRC,IE,UF '+
         'FROM PROPRIETARIOS '+
         'WHERE CODIGO=0'+qREG.FieldByName('PROPRIETARIO').AsString;
         sql := qAUX.SQL.Text;
         qAUX.Open;
         with infCteNorm.Rodo.veic.add do begin
            Prop.tpProp  := tpOutros;
            Prop.xNome   := qAUX.FieldByName('NOME').AsString;
            Prop.CNPJCPF := SoNumero(qAUX.FieldByName('CNPJ').AsString);
            Prop.RNTRC   := qAUX.FieldByName('RNTRC').AsString;
            Prop.UF      := qAUX.FieldByName('UF').AsString;

            if (qAUX.FieldByName('IE').AsString='ISENTO') OR (TRIM(qAUX.FieldByName('IE').AsString)='') then
               Prop.IE     :='ISENTO'
            else
               Prop.IE     :=SoNumero(qAUX.FieldByName('IE').AsString);

            if (Prop.xNome<>'') and (Prop.IE='') then
               cCri:=cCri+'Definir Inscrição Estadual do Proprietário.';

            qAUX2.Close;
            qAUX2.SQl.Text := 'SELECT * '+
            'FROM VEICULO '+
            'WHERE CODIGO=0'+qREG.FieldByName('VEICULO').AsString;
            sql := qAUX2.SQL.Text;
            qAUX2.Open;

            placa   := StringReplace(qAUX2.FieldByName('PLACA').AsString,'-','',[rfReplaceAll]);
            RENAVAM := SoNumero(qAUX2.FieldByName('RENAVAN').AsString);
            UF      := qAUX2.FieldByName('PLACAUF').AsString;

            if qAUX2.FieldByName('TIPO').AsInteger in [2,3,4] then
               tpVeic := tvReboque
            else
               tpVeic := tvTracao;
            tpCar := tcFechada;
         end;

         // carreta 1
         if qAUX2.FieldByName('CAR1PLACA').AsString<>'' then begin
            with infCteNorm.Rodo.veic.add do begin
               //(tpTACAgregado, tpOutros, tpOutros);
               Prop.tpProp := tpOutros;
               Prop.xNome  :=qAUX.FieldByName('NOME').AsString;
               Prop.CNPJCPF:=SoNumero(qAUX.FieldByName('CNPJ').AsString);
               Prop.RNTRC  :=qAUX.FieldByName('RNTRC').AsString;
               Prop.UF     :=qAUX.FieldByName('UF').AsString;

               if (qAUX.FieldByName('IE').AsString='ISENTO') OR (TRIM(qAUX.FieldByName('IE').AsString)='') then
                  Prop.IE     :='ISENTO'
               else
                  Prop.IE     :=SoNumero(qAUX.FieldByName('IE').AsString);

               if Prop.IE='' then
                  cCri:=cCri+'Definir Inscrição Estadual do Proprietário da Carreta 1.';

                placa   := Copy(qAUX2.FieldByName('CAR1PLACA').AsString,1,3)+Copy(qAUX2.FieldByName('CAR1PLACA').AsString,5,4);
                RENAVAM := SoNumero(qAUX2.FieldByName('CAR1RENAVAN').AsString);
                UF      := qAUX2.FieldByName('CAR1PLACAUF').AsString;
                tpVeic  := tvTracao;
                tpCar   := tcFechada;
            end;
         end;

         if qAUX2.FieldByName('CAR2PLACA').AsString<>'' then begin
            with infCteNorm.Rodo.veic.add do begin
               Prop.tpProp := tpOutros;
               Prop.xNome  :=qAUX.FieldByName('NOME').AsString;
               Prop.CNPJCPF:=SoNumero(qAUX.FieldByName('CNPJ').AsString);
               Prop.RNTRC  :=qAUX.FieldByName('RNTRC').AsString;
               Prop.UF     :=qAUX.FieldByName('UF').AsString;

               if (qAUX.FieldByName('IE').AsString='ISENTO') OR (TRIM(qAUX.FieldByName('IE').AsString)='') then
                  Prop.IE     :='ISENTO'
               else
                  Prop.IE     :=SoNumero(qAUX.FieldByName('IE').AsString);

               if Prop.IE='' then
                  cCri:=cCri+'Definir Inscrição Estadual do Proprietário da Carreta 2.';

               placa   := Copy(qAUX2.FieldByName('CAR2PLACA').AsString,1,3)+Copy(qAUX2.FieldByName('CAR2PLACA').AsString,5,4);
               RENAVAM := SoNumero(qAUX2.FieldByName('CAR2RENAVAN').AsString);
               UF      := qAUX2.FieldByName('CAR2PLACAUF').AsString;
               tpVeic  := tvTracao;
               tpCar   := tcFechada;
            end;
         end;

         if qAUX2.FieldByName('CAR3PLACA').AsString<>'' then begin
            with infCteNorm.Rodo.veic.add do begin
               //(tpTACAgregado, tpOutros, tpOutros);
               Prop.tpProp  := tpOutros;
               Prop.xNome   := qAUX.FieldByName('NOME').AsString;
               Prop.CNPJCPF := SoNumero(qAUX.FieldByName('CNPJ').AsString);
               Prop.RNTRC   := qAUX.FieldByName('RNTRC').AsString;
               Prop.UF      := qAUX.FieldByName('UF').AsString;

               if (qAUX.FieldByName('IE').AsString='ISENTO') OR (TRIM(qAUX.FieldByName('IE').AsString)='') then
                  Prop.IE     :='ISENTO'
               else
                  Prop.IE     :=SoNumero(qAUX.FieldByName('IE').AsString);

               if Prop.IE='' then
                  cCri:=cCri+'Definir Inscrição Estadual do Proprietário da Carreta 3.';
               placa   := Copy(qAUX2.FieldByName('CAR3PLACA').AsString,1,3)+Copy(qAUX2.FieldByName('CAR3PLACA').AsString,5,4);
               RENAVAM := SoNumero(qAUX2.FieldByName('CAR3RENAVAN').AsString);
               UF      := qAUX2.FieldByName('CAR3PLACAUF').AsString;
               tpVeic  := tvTracao;
               tpCar   := tcFechada;
            end;
         end;

         if qREG.FieldByName('TIPO').AsString='0' then
            Ide.refCTE:=qREG.FieldByName('TIPOCHV').AsString// Chave de Acesso do CT-e Referenciado
         else if qREG.FieldByName('TIPO').AsString='1' then begin

            if(ACBrCTe1.Configuracoes.Geral.VersaoDF = ve400)then // apenas para versão 4.00
               infCteComp10.Add.chCTe := qREG.FieldByName('TIPOCHV').AsString
            else
               infCteComp.chave := qREG.FieldByName('TIPOCHV').AsString;

         end else if qREG.FieldByName('TIPO').AsString='2' then begin
            GravaLog('Chamou para anular: '+qREG.FieldByName('TIPOCHV').AsString);

            qAUX.Close;
            qAUX.SQL.Text := 'SELECT CAST(DATA AS DATE) AS DATA FROM FRETES WHERE CODIGO=0'+qREG.FieldByName('TIPOSEQ').AsString;
            sql := qAUX.SQL.Text;
            qAUX.Open;

            infCTeAnu.dEmi  := qAUX.FieldByName('DATA').AsDateTime;
            infCTeAnu.chCTe := qREG.FieldByName('TIPOCHV').AsString;
         end else if qREG.FieldByName('TIPO').AsString='3' then begin
            infCteNorm.infCteSub.chCte:=qREG.FieldByName('TIPOCHV').AsString;

            if MudouTomador(qREG,qAUX) then
               infCteNorm.infCteSub.indAlteraToma:= tiSim
            else
               infCteNorm.infCteSub.indAlteraToma:= tiNao;

            qAUX.Close;
            qAUX.SQL.Text := 'SELECT NOME,IE,CNPJ '+
            'FROM CLIENTES '+
            'WHERE CODIGO=0'+qREG.FieldByName('TOMADOR').AsString;
            sql := qAUX.SQL.Text;
            qAUX.Open;

            if SoNumero(qAUX.FieldByName('IE').AsString)<>'' then begin
               qAUX2.Close;
               qAUX2.SQL.Text := 'SELECT FIRST 1 * '+
               'FROM FRETENOTAS '+
               'WHERE CODIGO=0'+qREG.FieldByName('CODIGO').AsString;
               sql := qAUX2.SQL.Text;
               qAUX2.Open;

               if UpperCase(qAUX2.FieldByName('TIPO').AsString)='NFE' then
                  infCteNorm.infCteSub.tomaICMS.refNFe := qAUX2.FieldByName('CHAVE').AsString  // chave da NFe
               else begin
                  infCteNorm.infCteSub.tomaICMS.refNF.CNPJCPF := SoNumero(qAUX.FieldByName('CNPJ').AsString);
                  infCteNorm.infCteSub.tomaICMS.refNF.modelo  := '55';
                  infCteNorm.infCteSub.tomaICMS.refNF.serie   := StrToNumI(qAUX2.FieldByName('SERIE').AsString);
                  infCteNorm.infCteSub.tomaICMS.refNF.nro     := qAUX2.FieldByName('NUMERO').AsInteger;
                  infCteNorm.infCteSub.tomaICMS.refNF.valor   := qAUX2.FieldByName('VRMERCADORIA').AsFloat;
                  infCteNorm.infCteSub.tomaICMS.refNF.dEmi    := qAUX2.FieldByName('DATA').AsFloat;
               end;
            end else
               infCteNorm.infCteSub.tomaNaoICMS.refCteAnu := qREG.FieldByName('TIPOCHV').ASString;

            // dados do responsavel técnico
            qAUX.Close;
            qAUX.SQL.Text := 'SELECT * FROM RESPTECNICO';
            sql := qAUX.SQL.Text;
            qAUX.OPen;

            infRespTec.CNPJ     := qAUX.FieldByName('CNPJ').AsString;
            infRespTec.xContato := qAUX.FieldByName('NOME').AsString;
            infRespTec.email    := qAUX.FieldByName('EMAIL').AsString;
            infRespTec.fone     := SoNumero(qAUX.FieldByName('TELEFONE').AsString);
         end else
            Ide.refCTE:='';
      end;
   finally
      FreeAndNil(qAUX2);
   end;
end;
function TCte.MudouTomador(qREG,qAUX:TSQLQuery): Boolean;
begin
   qAUX.Close;
   qAUX.SQL.Text := 'SELECT F.TOMADOR,C.CNPJ,'+
   '(SELECT C.CNPJ '+
   'FROM FRETES FO '+
   'LEFT JOIN CLIENTES C ON C.CODIGO=FO.TOMADOR '+
   'WHERE FO.CHAVECTE=F.TIPOCHV) AS CNPJ2 '+
   'FROM FRETES F '+
   'LEFT JOIN CLIENTES C ON C.CODIGO=F.TOMADOR '+
   'WHERE F.CODIGO=0'+qREG.FieldByName('CODIGO').AsString;
   sql := qAUX.SQL.Text;
   qAUX.Open;

   result := qAUX.FIeldByName('CNPJ').AsString<>qAUX.FIeldByName('CNPJ2').AsString;
end;


function TCte.Download(oReq: TJSONObject; qUSU: TSQLQuery;
  cDB: TSQLConnection): String;
var
   cCod       : String;
   cAux       : String;
   cMensagem  : String;
   cFile      : String;
   cDownload  : String;
   nCte       : Integer;
   ACBrCte1        : TACBrCTe;
   ACBrCTeDACTeRL1 : TACBrCTeDACTeRL;
   qREG : TSQLQuery;
   qAUX : TSQLQuery;
begin
   ACBrCte1        := TACBrCTe.Create(Nil);
   ACBrCTeDACTeRL1 := TACBrCTeDACTeRL.Create(Nil);

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
      'FROM FRETES F '+
      'WHERE F.CODIGO=0'+cCod;
      sql := qREG.SQL.Text;
      qREG.Open;

      if(qREG.FieldByName('CHAVECTE').AsString = '')then begin
         Result := '{"erro":1,"mensagem":"Chave do CTe inválida"}';
         Exit;
      end;

      cDownload := '/clientes/CTe/'+soNUmero(qUSU.FieldByName('CNPJ').AsString)+'/PDFs/'+qREG.FieldByName('CHAVECTE').AsString+'-cte.pdf';
      if (qREG.FieldByName('ULT_DOWNLOAD_PDF').AsDateTime < IncDay(Now,-1)) and (not FilesExists('.'+cDownload))then begin // verifica se precisa gerar novamente o PDF
         cMensagem := '';
         try
            ConfiguraCTe(qAUX,ACBrCTe1,ACBrCTeDACTeRL1);
         except on E: Exception do begin
            Result := '{"erro":1,"mensagem":"Ocorreu algum erro ao configurar o CTE"}';
            exit;
         end;
         end;

         cFile := ACBrCTe1.Configuracoes.Arquivos.PathSalvar+qREG.FieldByName('CHAVECTE').AsString+'-cte.xml';
         try
            ACBrCTe1.Conhecimentos.LoadFromFile(cFile);
            ACBrCTe1.Conhecimentos.ImprimirPDF;
         except on E: Exception do begin
            Result := '{"erro":1,"mensagem":"Ocorreu um erro ao tentar gerar download"}';
            GravaLog('Erro ao tentar gerar download erro:'+e.Message);
            Exit;
         end;
         end;
      end;

      qAUX.Close;
      qAUX.SQL.Text := 'UPDATE FRETES SET ULT_DOWNLOAD_PDF=CURRENT_TIMESTAMP WHERE CODIGO=0'+cCod;
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
      FreeAndNil(ACBrCte1);
      FreeAndNil(ACBrCTeDACTeRL1);
   end;
end;


function TCte.VerificaCertificado(qAUX: TSQLQuery): Boolean;
begin
  qAUX.SQL.Text := 'SELECT COALESCE(CERTIFICADO_CAMINHO,'''') AS CERTIFICADO_CAMINHO, '+
  'COALESCE(CERTIFICADO_SENHA,'''') AS CERTIFICADO_SENHA,COALESCE(AMBIENTE,0) AS AMBIENTE,'+
  'E.CNPJ,P.* '+
  'FROM PARAMETROS P '+
  'LEFT JOIN EMPRESA E ON E.CODIGO=1 '+
  'WHERE EMPRESA=1';
  sql := qAUX.SQL.Text;
  qAUX.Open;

  Result := true;
  if(qAUX.FieldByName('CERTIFICADO_CAMINHO').AsString = '') or (qAUX.FieldByName('CERTIFICADO_SENHA').AsString = '')then
     Result := False;
end;

procedure TCte.DeletaPDFs;
var
   cCod       : String;
   cMensagem  : String;
   cFile      : String;
   cDownload  : String;
   nCte       : Integer;
   ACBrCte1        : TACBrCTe;
   ACBrCTeDACTeRL1 : TACBrCTeDACTeRL;
   qREG : TSQLQuery;
   qAUX : TSQLQuery;
   cDB  : TSQLConnection;
begin

//   cDB  := TSQLConnection.Create(Nil);
//   qREG := TSQLQuery.Create(Nil);
//
//   ConfiguraConexao();
//
//   qREG.SQLConnection := cDB;
//   qAUX.SQLConnection := cDB;
//   try
//      if(not VerificaCertificado(qAUX))then begin
//         Result := '{"erro":1,"mensagem":"Certificado ou senha do certificado não informado!"}';
//         exit;
//      end;
//
//      cMensagem := '';
//      try
//         ConfiguraCTe(qAUX,ACBrCTe1,ACBrCTeDACTeRL1);
//      except on E: Exception do begin
//         Result := '{"erro":1,"mensagem":"Ocorreu algum erro ao configurar o CTE"}';
//         exit;
//      end;
//      end;
//
//      cCod := GetValueJSONObject('codigo',oReq);
//
//      qREG.Close;
//      qREG.SQL.Text := 'SELECT F.* '+
//      'FROM FRETES F '+
//      'WHERE F.CODIGO=0'+cCod;
//      sql := qREG.SQL.Text;
//      qREG.Open;
//
//      if(qREG.FieldByName('CHAVECTE').AsString = '')then begin
//         Result := '{"erro":1,"mensagem":"Chave do CTe inválida"}';
//         Exit;
//      end;
//
//      cFile := ACBrCTe1.Configuracoes.Arquivos.PathSalvar+qREG.FieldByName('CHAVECTE').AsString+'-cte.xml';
//
//      try
//         ACBrCTe1.Conhecimentos.LoadFromFile(cFile);
//         ACBrCTe1.Conhecimentos.ImprimirPDF;
//
//         if ACBrCTe1.EventoCTe.Evento.Count>0 then
//            ACBrCTe1.ImprimirEvento;
//      except on E: Exception do begin
//         Result := '{"erro":1,"mensagem":"Ocorreu um erro ao tentar gerar download"}';
//         GravaLog('Erro ao tentar gerar download erro:'+e.Message);
//         Exit;
//      end;
//      end;
//
//      // cDownload := ACBrCTe1.Configuracoes.Arquivos.PathSalvar+'/PDFs/'+qREG.FieldByName('CHAVECTE').AsString+'-cte.pdf';
//      cDownload := '/clientes/CTe/'+soNUmero(qUSU.FieldByName('CNPJ').AsString)+'/PDFs/'+qREG.FieldByName('CHAVECTE').AsString+'-cte.pdf';
//
//      Result := '{'+
//      '"erro":0,'+
//      '"mensagem":"PDF gerado com sucesso",'+
//      '"pdf":"'+cDownload+'"'+
//      '}';
//   finally
//      FreeAndNil(qAUX);
//      FreeAndNil(qREG);
//      FreeAndNil(cDB);
//   end;
end;



function TCte.Cancela(oReq: TJSONObject; qUSU: TSQLQuery;
  cDB: TSQLConnection): String;
var
   cMensagem  : String;
   cCod       : String;
   cEx        : String;
   cProtocolo : String;
   cRecibo    : String;
   cDownload  : String;
   nCte       : Integer;
   ACBrCte1        : TACBrCTe;
   ACBrCTeDACTeRL1 : TACBrCTeDACTeRL;
   qREG : TSQLQuery;
   qAUX : TSQLQuery;
begin
   ACBrCte1        := TACBrCTe.Create(Nil);
   ACBrCTeDACTeRL1 := TACBrCTeDACTeRL.Create(Nil);

   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;
   try
      if(not VerificaCertificado(qAUX))then begin
         Result := '{"erro":1,"mensagem":"Certificado ou senha do certificado não informado!"}';
         exit;
      end;

      try
         ConfiguraCTe(qAUX,ACBrCTe1,ACBrCTeDACTeRL1);
      except on E: Exception do begin
         Result := '{"erro":1,"mensagem":"Ocorreu algum erro ao configurar o CTE"}';
         exit;
      end;
      end;

      cCod := GetValueJSONObject('codigo',oReq);

      qREG.Close;
      qREG.SQL.Text := 'SELECT F.* '+
      'FROM FRETES F '+
      'WHERE F.CODIGO=0'+cCod;
      sql := qREG.SQL.Text;
      qREG.Open;

      if(qREG.FieldByName('CHAVECTE').AsString = '')then begin
         Result := '{"erro":1,"mensagem":"Chave do CTe inválida"}';
         Exit;
      end;

      if(not FileExists('\Projetos\dsSigetran\dsSigetran.dproj'))then begin
         if (SQLInteger('SELECT FIRST 1 FRETE FROM FATREC WHERE FRETE=0'+cCod,qAUX)<>0) or (SQLInteger('SELECT FIRST 1 FRETE FROM FATDES WHERE FRETE=0'+cCod,qAUX)<>0) then begin
            result := '{"erro":1,"mensagem":"Operação não permitida. Este conhecimento ja foi faturado !"}';
            exit;
         end;
      end;

      if (qREG.FieldByName('STATUS').AsString = 'A') or (qREG.FieldByName('STATUS').AsString = 'S') then begin
         result := '{"erro":1,"mensagem":"Operação não permitida. Situação não permite."}';
         exit;
      end;

      if SQLInteger('SELECT CODIGO FROM FRETESMDF WHERE FRETE=0'+cCod+' AND STATUS=''P'' ',qAUX)<>0 then begin
         result := '{"erro":1,"mensagem":"Operação não permitida. Situação não permite."}';
         exit;
      end;

      // ACBrCTe1.Configuracoes.WebServices.TimeZoneConf.TimeZoneStr := '-03:00';

      Result := ValidaCancelamento(oReq,ACBRCTe1,qREG,qUSU);

      if (Result  = '') then begin
         ACBrCTe1.ImprimirEventoPDF;

         if (qREG.FieldByName('STATUS').AsString <> 'C') then begin
            qAUX.Close;
            qAUX.SQL.Text := 'UPDATE FRETES SET STATUS=''C'' WHERE CODIGO=0'+qREG.FieldByName('CODIGO').AsString;
            sql := qAUX.SQL.Text;
            qAUX.ExecSQL(false);

            qREG.Refresh;
         end;

         {
         // excluir cheque se tiver
         frmFretes.tBAN.First;
         while not(frmFretes.tBAN.Eof) do begin
            SQLExecute('DELETE FROM CORRENTE WHERE CODIGO=0'+frmFretes.tBANSEQCC.AsString);
            frmFretes.tBAN.Delete;
         end;
         }
         GravaLog(ACBrCTe1.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.nProt);
         qAUX.Close;
         qAUX.SQL.Text := 'DELETE FROM FRETESPAG WHERE FRETE=0'+qREG.FieldByName('CODIGO').AsString;
         sql := qAUX.SQL.Text;
         qAUX.ExecSQL(false);

         qREG.Refresh;
         if SQLString('SELECT AVERBAATM FROM PARAMETROS WHERE EMPRESA=0'+qREG.FieldByName('EMPRESA').AsString,qAUX)='S' then begin

            case AnsiIndexStr(SQLString('SELECT SEGURADORA FROM CONFIG',qAUX), ['AT&M', 'PORTO SEGURO']) of
               0: EnviaCteATM(qREG.FieldByName('CODIGO').AsInteger,qAUX,'C');
               // 1: frmPrin.EnviaPorto(frmFretes.tREGCODIGO.AsInteger);
            end;

//            case MatchStr(SQLString('SELECT SEGURADORA FROM CONFIG',qAUX), ['AT&M', 'PORTO SEGURO']) of
//                0: EnviaATM(qREG.FieldByName('CODIGO').AsInteger,qAUX,'C');
//               //    1: frmPrin.EnviaPorto(frmFretes.tREGCODIGO.AsInteger);
//            end;
         end;

         Result := '{"erro":0,"mensagem":"CTE cancelado com sucesso."}';
      end;
   finally
      // ACBrCTe1.Configuracoes.WebServices.TimeZoneConf.TimeZoneStr:='-03:00';

      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(ACBrCte1);
      FreeAndNil(ACBrCTeDACTeRL1);
   end;
end;
function TCte.ValidaCancelamento(oReq: TJSONObject; ACBRCte1:TACBRCte;qREG,qUSU: TSQLQuery): String;
var
   cJus : String;
   cUf  : String;
   qAUX : TSQLQuery;
begin
   qAUX := TSQLQuery.Create(Nil);
   qAUX.SQLConnection := qREG.SQLConnection;

   Result := '';
   try
      try
         // senao temc have para cancelar...
         if (qREG.FieldByName('CHAVECTE').AsString = '') then begin
            Result := '{"erro":1,"mensagem":"Chave não encontrada, envie ou consulte o registro."}';
            exit;
         end;

         cJus := Trim(GetValueJSONObject('justificativa',oReq));
         if (cJus = '') then begin
            Result := '{"erro":1,"mensagem":"Justificativa não informada."}';
            exit;
         end;

         // eFrete
         // if (qREG.FielByName('EFRETE').AsString = '1') and frmFretes.tREGEFRETE.AsString='1') and not(frmFretes.CancelaEFrete(vAux)) then
         if (qREG.FieldByName('EFRETE').AsString = '1') then begin
            Result := '{"erro":1,"mensagem":"Não permitido cancelar."}';
            exit;
         end;

         ACBrCTe1.Conhecimentos.Clear;
         if not(FileExists(ACBrCTe1.Configuracoes.Arquivos.PathSalvar+qREG.FieldByName('CHAVECTE').AsString+'-cte.xml')) then begin
            Result := '{"erro":1,"mensagem":"Não foi possível encontrar o XML."}';
            exit;
         end;

         ACBrCTe1.Conhecimentos.LoadFromFile(ACBrCTe1.Configuracoes.Arquivos.PathSalvar+qREG.FieldByName('CHAVECTE').AsString+'-cte.xml');

         qAUX.Close;
         qAUX.SQL.Text := 'SELECT M.CHAVEMDFE '+
         'FROM FRETES F '+
         'LEFT JOIN FRETESMDF M ON M.FRETE=F.CODIGO '+
         'WHERE F.CODIGO=0'+qREG.FieldByName('CODIGO').AsString;
         sql := qAUX.SQL.Text;
         qREG.Open;

         ACBrCTe1.EventoCTe.Evento.Clear;
         ACBrCTe1.EventoCTe.idLote := qREG.FieldByName('CODIGO').AsInteger;

         with ACBrCTe1.EventoCTe.Evento.Add do begin
            infevento.chCTe := qREG.FieldByName('CHAVECTE').AsString;
            infEvento.CNPJ  := SoNumero(SQLString('SELECT CNPJ FROM EMPRESA WHERE CODIGO=0'+qREG.FieldByName('EMPRESA').AsString,qAUX));

            cUF := SQLString('SELECT ESTADO FROM EMPRESA WHERE CODIGO=0'+IntTOStr(Max(qREG.FieldByName('EMPRESA').AsInteger,1)),qAUX);

            infEvento.dhEvento        := PegaDataHoraPorEstado(ACBrCTe1.Configuracoes.WebServices.UF);
            infEvento.tpEvento        := teCancelamento;
            infEvento.cOrgao          := StrToIntDef(Copy(qREG.FieldByName('CHAVECTE').AsString, 1, 2), 0);
            infEvento.detEvento.xJust := cJus;
            infEvento.detEvento.nProt := ACBrCTe1.Conhecimentos.Items[0].CTe.procCTe.nProt;
            if infEvento.detEvento.nProt='' then
               infEvento.detEvento.nProt := qREG.FieldByName('PROTOCOLO').AsString;
         end;

         ACBrCTe1.EnviarEvento(qREG.FieldByName('CODIGO').AsInteger);

         Result := '';

         {
         MemoResp.Lines.Text   :=  UTF8Encode(frmFretes.ACBrCTe1.WebServices.EnvEvento.RetWS);
         memoRespWS.Lines.Text :=  UTF8Encode(frmFretes.ACBrCTe1.WebServices.EnvEvento.RetWS);

         //LoadXML(MemoResp, WBResposta);
         LoadXML(frmFretes.ACBrCTe1.WebServices.EnvEvento.RetWS, WBResposta);
         }
      except on e:exception do begin
         GravaLog('Erro ao cancelar CTE. Erro:'+e.Message+sLineBreak+'SQL:'+sql);

         // if not(Pos('DUPLICIDADE',UpperCase(e.Message)) <> 0) then
         Result := '{"erro":1,"mensagem":"Não foi possível cancelar. '+TrataMensagemExcept(e.Message)+'"}';
      end;
      end;
   finally
      FreeAndNil(qAUX);
   end;
end;


function TCte.Email(oReq: TJSONObject; qUSU: TSQLQuery;
  cDB: TSQLConnection): String;
var
   cEmail   : String;
   cCod     : String;
   cAssunto : String;
   sMail    : String;
   sMail1   : String;
   sMail2   : String;
   cCopia   : String;
   sEmailCopia : String;
   lEmail   : TStringList;
   lMsg     : TStringList;
   nCte     : Integer;
   ACBrCte1 : TACBrCTe;
   ACBrCTeDACTeRL1 : TACBrCTeDACTeRL;
   ACBRMail : TACBRMAil;
   qREG : TSQLQuery;
   qAUX : TSQLQuery;
begin
   ACBrCte1        := TACBrCTe.Create(Nil);
   ACBrCTeDACTeRL1 := TACBrCTeDACTeRL.Create(Nil);

   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;

   ACBRMail := TACBRMail.Create(Nil);
   try
      if(not VerificaCertificado(qAUX))then begin
         Result := '{"erro":1,"mensagem":"Certificado ou senha do certificado não informado!"}';
         exit;
      end;

      try
         ConfiguraCTe(qAUX,ACBrCTe1,ACBrCTeDACTeRL1);
      except on E: Exception do begin
         Result := '{"erro":1,"mensagem":"Ocorreu algum erro ao configurar o CTE"}';
         exit;
      end;
      end;

      cCod   := GetValueJSONObject('codigo',oReq);
      cEmail := GetValueJSONObject('email',oReq);

      qREG.Close;
      qREG.SQL.Text := 'SELECT F.* '+
      'FROM FRETES F '+
      'WHERE F.CODIGO=0'+cCod;
      sql := qREG.SQL.Text;
      qREG.Open;

      if(qREG.FieldByName('CHAVECTE').AsString = '')then begin
         Result := '{"erro":1,"mensagem":"Chave do CTe inválida"}';
         Exit;
      end;

      cCopia  := SQLString('SELECT MAILCOPIA FROM PARAMETROS WHERE EMPRESA=0'+qREG.FieldByName('EMPRESA').AsString,qAUX);

      // REMOVIDO POR HORA
      qAUX.Close;
      qAUX.SQL.Text := 'SELECT EMAIL1,EMAIL2,EMAIL3 '+
      'FROM CLIENTES '+
      'WHERE CODIGO=0'+qREG.FieldByName('TOMADOR').AsString;
      sql := qAUX.SQL.Text;
      qAUX.Open;

      sMail  := qAUX.FieldByName('EMAIL1').AsString;
      sMail1 := qAUX.FieldByName('EMAIL2').AsString;
      sMail2 := qAUX.FieldByName('EMAIL3').AsString;

      if (sMail='') and (sMail1='') and (sMail2='') and (cCopia <> 'S') then begin
         Result := '{"erro":1,"mensagem":"Email do tomador não foi encontrado !"}';
         exit;
      end;

      lMsg   := TStringList.Create;
      lEmail := TStringList.Create;
      if ACBrCTe1.Configuracoes.WebServices.Ambiente=taHomologacao then
         sMail  := cEmail
      else if(cCopia = 'S')then begin
         sEmailCopia := SQLString('SELECT MAILMAIL FROM PARAMETROS WHERE EMPRESA=0'+qREG.FieldByName('EMPRESA').AsString,qAUX);

         if cCopia = 'S' then
            lEmail.Add(sEmailCopia);
      end;

       if(FileExists('AmbienteTeste.txt'))then begin
         sMail  := cEmail;
         sMail1 := cEmail;
         sMail2 := cEmail;
       end;

      sMail := Trim(sMail);
      if ACBrCTe1.Configuracoes.WebServices.Ambiente <> taHomologacao then begin
         if sMail1<>'' then
            lEmail.Add(sMail1);
         if sMail2<>'' then
            lEmail.Add(sMail2);
      end;

      ConfiguraMail(ACBRMail,qAUX);

      ACBrCte1.MAIL := ACBRMail;

      //  retorno a conexão pois pode mudar na configuração do componente de email
      qAUX.Close;
      qAUX.SQLConnection := cDB;

      ACBrCTe1.Conhecimentos.clear;
      ACBrCTe1.Conhecimentos.LoadFromFile(ACBrCTe1.Configuracoes.Arquivos.PathSalvar+qREG.FieldByName('CHAVECTE').AsString+'-cte.xml');

      qAUX.Close;
      qAUX.SQL.Text := 'SELECT * '+
      'FROM PARAMETROS '+
      'WHERE EMPRESA=0'+qREG.FieldByName('EMPRESA').AsString;
      sql := qAUX.SQL.Text;
      qAUX.Open;

      lMsg.Text := qAUX.FieldByName('MAILMSG').AsString;
      if(Trim(lMsg.Text) = '')then
         lMsg.Text := 'Olá, espero que esta mensagem o encontre bem. '+
         'Estou enviando, em anexo, o Conhecimento de Transporte Eletrônico (CTe). '+
         'O CTe está disponível em dois formatos para sua conveniência: XML e PDF.';


      cAssunto := qAUX.FieldByName('MAILASSUNTO').AsString;
      if(Trim(cAssunto) = '')then
         cAssunto := 'DACTe - SIGETRAN';


      ACBrCTe1.Conhecimentos.Items[0].EnviarEmail(sMail,
      cAssunto,
      lMsg,
      true,
      lEmail);

      Result := '{"erro":0,"mensagem":"Email enviado com sucesso!"}';
      {
      if (frmMailCte<>NIL) and (trim(frmMailCte.edMail.Text)<>'') then
         ShowMessage('CTe enviado no email '+frmMailCte.edMail.Text)
      else
         ShowMessage('CTe enviado no email '+sMail);
      }
   finally
      FreeAndNil(lEmail);
      FreeAndNil(lMsg);
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(ACBRMail);
      FreeAndNil(ACBrCte1);
      FreeAndNil(ACBrCTeDACTeRL1);
   end;
end;

procedure TCte.ConfiguraMail(ACBRMail: TACBRMail; qAUX: TSQLQuery);
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

      if(qAUX.FieldByName('MAILUSER').AsString = '')then begin
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
      ACBrMail.SetSSL   := qAUX.FieldByName('MAILSSL').AsString='S'; // SSL - ConexÃ£o Segura

      ACBrMail.SetTLS   := true; //cbEmailSSL.Checked; // Auto TLS
      ACBrMail.ReadingConfirmation := False; //Pede confirmaÃ§Ã£o de leitura do email
      ACBrMail.UseThread := False;           //Aguarda Envio do Email(nÃ£o usa thread)
      ACBrMail.FromName  := 'CTe '+cEmpresa;
   finally
      FreeAndNil(cDBSYS);
   end;

end;


function TCte.CartaCorrecao(oReq: TJSONObject; qUSU: TSQLQuery;
  cDB: TSQLConnection): String;
var
   cCod       : String;
   XMLCCE     : String;
   ACBrCte1        : TACBrCTe;
   ACBrCTeDACTeRL1 : TACBrCTeDACTeRL;
   qREG : TSQLQuery;
   qAUX : TSQLQuery;
begin
   ACBrCte1        := TACBrCTe.Create(Nil);
   ACBrCTeDACTeRL1 := TACBrCTeDACTeRL.Create(Nil);

   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;
   try
      if(not VerificaCertificado(qAUX))then begin
         Result := '{"erro":1,"mensagem":"Certificado ou senha do certificado não informado!"}';
         exit;
      end;

      try
         ConfiguraCTe(qAUX,ACBrCTe1,ACBrCTeDACTeRL1);
      except on E: Exception do begin
         Result := '{"erro":1,"mensagem":"Ocorreu algum erro ao configurar o CTE"}';
         exit;
      end;
      end;

      cCod := GetValueJSONObject('evento',oReq);

      qREG.Close;
      qREG.SQL.Text := 'SELECT F.* '+
      'FROM FRETESCCE F '+
      'WHERE F.EVENTO=0'+cCod;
      sql := qREG.SQL.Text;
      qREG.Open;

      if(qREG.FieldByName('CHAVE').AsString = '')then begin
         Result := '{"erro":1,"mensagem":"Chave do CTe inválida"}';
         Exit;
      end;

      // ACBrCTe1.Configuracoes.WebServices.TimeZoneConf.TimeZoneStr := '-04:00';
      try
         ACBrCTe1.EventoCTe.Evento.Clear;
         ACBrCTe1.Conhecimentos.Clear;
         ACBrCTe1.Conhecimentos.LoadFromFile(ACBrCTe1.Configuracoes.Arquivos.PathSalvar+qREG.FieldByName('CHAVE').AsString+'-cte.xml');

         with ACBrCTe1.EventoCTe.Evento.Add do begin
            infEvento.tpAmb  := ACBrCTe1.Configuracoes.WebServices.Ambiente;
            infEvento.chCTe  := qREG.FieldByName('CHAVE').AsString;
            infEvento.CNPJ   := SoNumero(qUSU.FieldByName('CNPJ').AsString);
            infEvento.dhEvento := PegaDataHoraPorEstado(ACBrCTe1.Configuracoes.WebServices.UF);
            infEvento.tpEvento := teCCe;
            infEvento.nSeqEvento := qREG.FieldByName('EVNUM').AsInteger;
            infEvento.detEvento.descEvento:= 'Carta de Correcao';
            infEvento.cOrgao := ACBrCTe1.Configuracoes.WebServices.UFCodigo;

            qAUX.Close;
            qAUX.SQL.Text := 'SELECT F.* '+
            'FROM FRETESCCECP F '+
            'WHERE EVENTO='+qREG.FieldByName('EVENTO').AsString;
            sql := qAUX.SQL.Text;
            qAUX.Open;

            while not(qAUX.Eof) do begin
               with InfEvento.detEvento.infCorrecao.Add do begin
                  grupoAlterado := qAUX.FieldByName('GRUPO').AsString;
                  campoAlterado := qAUX.FieldByName('CAMPO').AsString;
                  valorAlterado := qAUX.FieldByName('VALOR').AsString;
                  nroItemAlterado:= qAUX.FieldByName('NUMERO').AsInteger;
               end;

               qAUX.Next;
            end;

         end;

         if ACBrCTe1.EnviarEvento(qREG.FieldByName('EVENTO').AsInteger) then begin
            with ACBrCTe1.WebServices.EnvEvento do begin
               if not(EventoRetorno.retEvento.Items[0].RetInfEvento.cStat in [135, 136]) then begin
                 raise EDatabaseError.CreateFmt(
                   'Ocorreu o seguinte erro ao enviar a carta de correção:'+
                   'Código:%d'+
                   'Motivo: %s', [
                     EventoRetorno.retEvento.Items[0].RetInfEvento.cStat,
                     EventoRetorno.retEvento.Items[0].RetInfEvento.xMotivo
                 ]);
               end;

               //DataHoraEvento  := EventoRetorno.retEvento.Items[0].RetInfEvento.dhRegEvento;
               //NumeroProtocolo := EventoRetorno.retEvento.Items[0].RetInfEvento.nProt;
               XMLCCe          := EventoRetorno.retEvento.Items[0].RetInfEvento.XML;

               ACBrCTe1.EventoCTe.Evento.Clear;
               ACBrCTe1.EventoCTe.LerXMLFromString(XMLCCe);

               //CodigoStatus    := EventoRetorno.retEvento.Items[0].RetInfEvento.cStat;
               //MotivoStatus    := EventoRetorno.retEvento.Items[0].RetInfEvento.xMotivo;
               qAUX.Close;
               qAUX.SQL.Text := 'UPDATE FRETESCCE SET '+
               'STATUS=''E'','+
               'PROTOCOLO='+QuotedStr(EventoRetorno.retEvento.Items[0].RetInfEvento.nProt)+' '+
               'WHERE CODIGO=0'+cCod;
               sql := qAUX.SQL.Text;
               qAUX.ExecSQL(False);

               Result := '{"erro":0,"mensagem":"Carta de correção enviada com sucesso!"}';
            end;
         end else begin
            with ACBrCTe1.WebServices.EnvEvento do begin
              raise Exception.Create(
                'Ocorreram erros ao enviar a Carta de Correção:' +
                'Lote: '     + IntToStr(EventoRetorno.idLote) +
                'Ambiente: ' + TpAmbToStr(EventoRetorno.tpAmb)+
                'Orgao: '    + IntToStr(EventoRetorno.cOrgao)+
                'Status: '   + IntToStr(EventoRetorno.cStat)+
                'Motivo: '   + EventoRetorno.xMotivo
              );
            end;
         end;
      except on e:exception do
         Result := '{"erro":1,"mensagem":"'+e.MEssage+'"}';
      end;
   finally
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(ACBrCte1);
      FreeAndNil(ACBrCTeDACTeRL1);
   end;
end;

function TCte.EnviaSeguro(oReq: TJSONObject; qUSU: TSQLQuery;
  cDB: TSQLConnection): String;
var
   cMensagem  : String;
   cCod       : String;
   cOp        : String;
   nCte       : Integer;
   ACBrCte1        : TACBrCTe;
   ACBrCTeDACTeRL1 : TACBrCTeDACTeRL;
   qREG : TSQLQuery;
   qAUX : TSQLQuery;
begin
   ACBrCte1        := TACBrCTe.Create(Nil);
   ACBrCTeDACTeRL1 := TACBrCTeDACTeRL.Create(Nil);

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
      'FROM FRETES F '+
      'WHERE F.CODIGO=0'+cCod;
      sql := qREG.SQL.Text;
      qREG.Open;

      if(qREG.FieldByName('CHAVECTE').AsString = '')then begin
         Result := '{"erro":1,"mensagem":"Chave do CTe inválida"}';
         Exit;
      end;

      try
         cOp := iif(GetValueJSONObject('cancelamento',oReq) = 'true','C','E');
         case AnsiIndexStr(SQLString('SELECT SEGURADORA FROM CONFIG',qAUX), ['AT&M', 'PORTO SEGURO']) of
            0: begin
               Result := EnviaCteATM(qREG.FieldByName('CODIGO').AsInteger,qAUX,cOp);
            end;
            // 1: frmPrin.EnviaPorto(frmFretes.tREGCODIGO.AsInteger);
         end;
      except on E: Exception do begin
         GravaLog('Erro ao averbar CTe|MDFe Cliente:'+qUSU.FieldByName('CNPJ').AsString+' Erro:'+e.Message);
         Result := '{"erro":1,"mensagem":"Não foi possível averbar"}';
      end;
      end;
   finally
      // ACBrCTe1.Configuracoes.WebServices.TimeZoneConf.TimeZoneStr:='-03:00';

      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(ACBrCte1);
      FreeAndNil(ACBrCTeDACTeRL1);
   end;
end;

function TCte.BuscaFretesAtm(sReq: TStrings; qUSU: TSQLQuery): String;
var
   cCod       : String;
   qREG : TSQLQuery;
begin
   qREG := TSQLQuery.Create(Nil);

   qREG.SQLConnection := qUSU.SQLConnection;
   try
      cCod := SoNumero(sReq.Values['codigo']);

      qREG.Close;
      qREG.SQL.Text := 'SELECT A.CODIGO,A.EMPRESA,A.DATA AS DATA_CTE,'+
      'A.PROTOCOLO AS PROTOCOLO_CTE,A.CANC_DATA AS DATA_CANCELAMENTO_CTE,'+
      'A.CANC_PROT AS PROTOCOLO_CANCELAMENTO_CTE,A.SITUACAO AS SITUACAO_CTE,'+
      'A.AVERBACAO,A.MDFEDATA AS DATA_MDFE,A.MDFEPROT AS PROTOCOLO_MDFE,'+
      'A.MDFENCERRA_DATA AS DATA_ENCERRAMENTO_MDFE,A.MDFENCERRA_PROT AS PROTOCOLO_ENCERRAMENTO_MDFE,'+
      'A.MDFCANCELA_DATA AS DATA_CANCELAMENTO_MDFE,A.MDFCANCELA_PROT AS PROTOCOLO_CANCELAMENTO_MDFE,'+
      'F.CTE '+
      'FROM FRETESATM A '+
      'LEFT JOIN FRETES F ON F.CODIGO=A.CODIGO '+
      'WHERE A.CODIGO=0'+cCod;
      sql := qREG.SQL.Text;
      qREG.Open;

      if(qREG.Eof)then begin
         Result := '{}';
         exit;
      end;

      Result := GeraJSONStr(qREG,'',true);
   finally
      FreeAndNil(qREG);
   end;
end;

function TCte.ImprimirCorrecao(oReq: TJSONObject; qUSU: TSQLQuery;
  cDB: TSQLConnection): String;
var
   cCod       : String;
   cAux       : String;
   cMensagem  : String;
   cFile      : String;
   cDownload  : String;
   nCte       : Integer;
   ACBrCte1        : TACBrCTe;
   ACBrCTeDACTeRL1 : TACBrCTeDACTeRL;
   qREG : TSQLQuery;
   qAUX : TSQLQuery;
begin
   ACBrCte1        := TACBrCTe.Create(Nil);
   ACBrCTeDACTeRL1 := TACBrCTeDACTeRL.Create(Nil);

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

//      qREG.Close;
//      qREG.SQL.Text := 'SELECT F.* '+
//      'FROM FRETES F '+
//      'WHERE F.CODIGO=0'+cCod;
//      sql := qREG.SQL.Text;
//      qREG.Open;
//
//      if(qREG.FieldByName('CHAVECTE').AsString = '')then begin
//         Result := '{"erro":1,"mensagem":"Chave do CTe inválida"}';
//         Exit;
//      end;

      try
         ConfiguraCTe(qAUX,ACBrCTe1,ACBrCTeDACTeRL1);
      except on E: Exception do begin
         Result := '{"erro":1,"mensagem":"Ocorreu algum erro ao configurar o CTE"}';
         exit;
      end;
      end;

      // cFile := ACBrCTe1.Configuracoes.Arquivos.PathSalvar+'110110'+qREG.FieldByName('CHAVECTE').AsString+'005-procEventoCTe.xml';
      cFile := 'D:\lixo\11011031240342566370000130570010000000301387800330001-procEventoCTe.xml';
      try
         ACBrCTe1.EventoCTe.LerXML(cFile);
         ACBrCTe1.ImprimirEvento;
         ACBrCTe1.ImprimirEventoPDF;
      except on E: Exception do begin
         Result := '{"erro":1,"mensagem":"Ocorreu um erro ao tentar gerar download"}';
         GravaLog('Erro ao tentar gerar download erro:'+e.Message);
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
      FreeAndNil(ACBrCte1);
      FreeAndNil(ACBrCTeDACTeRL1);
   end;
end;

function TCte.ConsultaSEFAZ(oReq: TJSONObject; qUSU: TSQLQuery;
  cDB: TSQLConnection): String;
var
   cMensagem  : String;
   cCod       : String;
   cDownload  : String;
   cRetorno   : String;
   cChave     : String;
   cAux       : String;
   cRec       : String;
   nCte       : Integer;
   lXML       : TStringList;

   ACBrCte1        : TACBrCTe;
   ACBrCTeDACTeRL1 : TACBrCTeDACTeRL;
   qREG : TSQLQuery;
   qAUX : TSQLQuery;
begin
   ACBrCte1        := TACBrCTe.Create(Nil);
   ACBrCTeDACTeRL1 := TACBrCTeDACTeRL.Create(Nil);

   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;

   lXML := TStringList.Create;
   try
      if(not VerificaCertificado(qAUX))then begin
         Result := '{"erro":1,"mensagem":"Certificado ou senha do certificado não informado!"}';
         exit;
      end;

      try
         ConfiguraCTe(qAUX,ACBrCTe1,ACBrCTeDACTeRL1);
      except on E: Exception do begin
         Result := '{"erro":1,"mensagem":"Ocorreu algum erro ao configurar o CTE"}';
         exit;
      end;
      end;

      cCod := GetValueJSONObject('codigo',oReq);

      qREG.Close;
      qREG.SQL.Text := 'SELECT F.*,E.ESTADO AS ESTADOE,'+
      'E.CIDADE AS CIDADEE,O.NOME AS NOMEO,O.CIDADE AS CIDADEO,O.UF AS UFO,'+
      'D.NOME AS NOMED,D.CIDADE AS CIDADED,D.UF AS UFD,E.CNPJ AS CNPJE,E.REGIME,'+
      'CST.DESCRICAO AS CSTN,P.NOME AS NOMEPROD,F.SITUACAO AS SIT_CTE '+
      'FROM FRETES F '+
      'LEFT JOIN EMPRESA E ON E.CODIGO=F.EMPRESA '+
      'LEFT JOIN ORIGENS O ON O.CODIGO=F.ORIGEM '+
      'LEFT JOIN DESTINOS D ON D.CODIGO=F.DESTINO '+
      'LEFT JOIN PRODUTOS P ON P.CODIGO=F.PRODUTO '+
      'LEFT JOIN LISTAS CST ON CST.CODIGO=4 AND CST.NOME=F.CST '+
      'WHERE F.CODIGO=0'+cCod;
      sql := qREG.SQL.Text;
      qREG.Open;

      if (qREG.Eof) then begin
         Result := '{"erro":1,"mensagem":"Registro não localizado."}';
         Exit;
      end;

      cRec   := qREG.FieldByName('RECIBO').AsString;
      cChave := qREG.FieldByName('CHAVECTE').AsString;

      if(qREG.FieldByName('CHAVECTE').AsString <> '')then begin
         try
            ACBrCTe1.Conhecimentos.LoadFromFile(ACBrCTe1.Configuracoes.Arquivos.PathSalvar+qREG.FieldByName('CHAVECTE').AsString+'-cte.xml',false);
         except on E: Exception do
            GerarCte(qREG,qAUX,qUSU,ACBRCTe1,ACBrCTeDACTeRL1);
         end;

         ACBrCTe1.Consultar;
         ACBrCTe1.Conhecimentos.ImprimirPDF;
      end else if(qREG.FieldByName('RECIBO').AsString <> '')then begin
         ACBrCTe1.WebServices.Recibo.Recibo := qREG.FieldByName('RECIBO').AsString;
         ACBrCTe1.WebServices.Recibo.Executar;
      end else begin
         Result := '{"erro":1,"mensagem":"CTE sem chave e recibo."}';
         Exit;
      end;

      cRetorno := UTF8Encode(ACBrCTe1.WebServices.Recibo.RetWS);

      if (qREG.FieldByName('CHAVECTE').AsString = '') then begin
         if (ACBrCTe1.WebServices.Retorno.ChaveCte <> '') then
            cChave := ACBrCTe1.WebServices.Retorno.ChaveCte
         else
            cChave := PegaChaveXML(cRetorno);

         qAUX.Close;
         qAUX.SQL.Text := 'UPDATE FRETES SET CHAVECTE='+QuotedStr(cChave)+' WHERE CODIGO=0'+cCod;
         sql := qAUX.SQL.Text;
         qAUX.ExecSQL(False);
      end;

      cAux := ACBrCTe1.Configuracoes.Arquivos.PathSalvar+qREG.FieldByName('CTE').AsString+'-rec.xml';
      if(qREG.FieldByName('RECIBO').AsString = '') and (FileExists(cAux)) then begin
         lXml.LoadFromFile(cAux);
         cRec := CampoXML(lXml.Text,'nRec');

         qAUX.Close;
         qAUX.SQL.Text := 'UPDATE FRETES SET RECIBO='+QuotedStr(cRec)+' WHERE CODIGO=0'+cCod;
         sql := qAUX.SQL.Text;
         qAUX.ExecSQL(False);
      end;

      if (ACBrCTe1.Conhecimentos.Count > 0) AND (ACBrCTe1.Conhecimentos.Items[0].CTe.procCTe.nProt<>'') then begin
         qAUX.Close;
         qAUX.SQL.Text := 'UPDATE FRETES SET PROTOCOLO='+QuotedStr(ACBrCTe1.Conhecimentos.Items[0].CTe.procCTe.nProt)+' WHERE CODIGO=0'+cCod;
         sql := qAUX.SQL.Text;
         qAUX.ExecSQL(False);
      end;

      Result := '{'+
      '"erro":0,'+
      '"mensagem":"CTE consultado com sucesso.",'+
      '"chave_cte":"'+cChave+'",'+
      '"recibo":"'+cRec+'"'+
      '}';
   finally
      FreeAndNil(lXML);
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(ACBrCte1);
      FreeAndNil(ACBrCTeDACTeRL1);
   end;
end;


end.

