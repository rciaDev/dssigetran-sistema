unit uServerMethods;

interface

uses System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSAuth,Data.DB,
  Data.SqlExpr, Data.DBXFirebird, MaskUtils,System.JSON,uWMSite,uFrm,Datasnap.DSSession;

type
{$METHODINFO ON}
  TServerMethods1 = class(TComponent)
  private
    { Private declarations }
  public
    { Public declarations }
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
    function GetStream(cCha:String;cSQL:WideString): TStringStream;
    function ncm(sCnpj:String;cSQL:WideString): TStringStream;
    function ncmun(sCnpj:String;cSQL:WideString): TStringStream;
    function updatePagamento(oDoc:TJSONObject):String;
    function updateCadastroM(oCad:TJSONObject):TJSONArray;
    function updateAtualizaP(oCad:TJSONObject):TJSONArray;
    function loginApp(cpf:string;senha:string):TJSONArray;
//    function busca(sPar:String):TJSONArray;

  end;

  servicos = Class(TServerMethods1)

  End;

{$METHODINFO OFF}
  function ValorSQL(sVlr:String):String;

implementation


uses System.StrUtils,uServerContainer;


function TServerMethods1.EchoString(Value: string): string;
begin
  Result := Value;
end;

function TServerMethods1.GetStream(cCha: String;cSQL: WideString): TStringStream;
var
  //sStream: TStringStream;
  lsReg:TStringList;
  cM,cL:String;
  nF : Integer;
  fCpo: TField;
  qSQL: TSQLQuery;

begin

   // url=http://10.1.1.4:8082/datasnap/rest/TServerMethods1/GetStream/290402277573055282
   qSQL:= TSQLQuery.Create(nil);
   qSQL.SQLConnection:=ServerContainer1.GetConnection;


   lsReg:=TStringList.Create;
   lsReg.Text:='Sem resposta';
   try
     try
       ServerContainer1.GetConnection.Open;

       //TIdURI.URLDecode(cSQL);
       cSQL := Trim(StringReplace(cSQL,'<*>','/',[rfReplaceAll]));
       cSQL := Trim(StringReplace(cSQL,'<->','=',[rfReplaceAll]));

       qSQL.Close;
       qSQL.SQL.Text:='SELECT CODIGO,NOME,INATIVO FROM CLIENTES WHERE CHAVE='+QuotedStr(cCha);
       qSQL.Open;
       if qSQL.Eof then
          raise Exception.Create('Empresa não encontrada')
       else if qSQL.FieldByName('INATIVO').AsString='S' then
          raise Exception.Create('Empresa inativa');

       fCpo := TField.Create(self);
       try
         qSQL.Close;
         qSQL.SQL.Text := cSQL;
         qSQL.Open;
         while not(qSQL.Eof) do begin
           cL:='(';
           for nF := 0 to qSQL.FieldCount-1 do begin
               fCpo:=qSQL.Fields[nF];
               if ((fCpo.DataType=ftFMTBcd) or (fCpo.DataType=ftFloat) or (fCpo.DataType=ftInteger) or (fCpo.DataType=ftSmallInt)) then
                  cL:=cL+ValorSQL(fCpo.AsString)
               else if ((fCpo.DataType=ftString) or (fCpo.DataType=ftWideString) or (fCpo.DataType=ftMemo) ) then
                  cL:=cL+QuotedStr(fCpo.AsString)
               else if (fCpo.DataType=ftDate)  then
                  cL:=cL+QuotedStr(FormatDateTime('dd.mm.yyyy',fCpo.AsDateTime))
               else if (fCpo.DataType=ftTime)  then
                  cL:=cL+QuotedStr(FormatDateTime('hh:MM:ss',fCpo.AsDateTime))
               else if (fCpo.DataType=ftDateTime) or (fCpo.DataType=ftTimeStamp)  then
                  cL:=cL+QuotedStr(FormatDateTime('dd.mm.yyyy hh:MM:ss',fCpo.AsDateTime));
               if nF<qSQL.FieldCount-1 then
                  cL:=cL+',';
           end;
           cL:=cL+')';
           lsReg.Add(cL);
           qSQL.Next;
         end;
       finally
         fCpo.Free;
       end;
     except on e : exception do
       lsReg.Text:='Erro: '+e.message;
        //GravaLog('Exceção GetStream '+e.Message,cSQL);
     end;
   finally
     // retorna
     Result := TStringStream.Create('');
     lsReg.SaveToStream(Result);
     //lsReg.Free;

     qSQL.Close;
     qSQL.SQLConnection.Close;
     qSQL.Free;
     //frmPrin.Led(false);
   end;

end;

function TServerMethods1.ReverseString(Value: string): string;
begin
  Result := System.StrUtils.ReverseString(Value);
end;

function ValorSQL(sVlr:String):String;
var
  sV : String;
  nL : Integer;
begin
    sV := '';
    For nL := 1 to Length(sVlr) do begin
       if Pos(sVlr[nL],'0123456789-')<>0 then
          sV := sV + sVlr[nL];
       if (sVlr[nL]=',') or (sVlr[nL]='.') then
          sV := sV+'.';
    End;
    if sV ='' then result := '0'
    else result := sV;
end;

function TServerMethods1.ncm(sCnpj: String; cSQL: WideString): TStringStream;
var
  //sStream: TStringStream;
  lsReg:TStringList;
  cM,cL:String;
  nF : Integer;
  fCpo: TField;
  qSQL: TSQLQuery;
  qMOV: TSQLQuery;

begin

   // url=http://10.1.1.4:8082/datasnap/rest/TServerMethods1/GetStream/290402277573055282
   qSQL:= TSQLQuery.Create(nil);
   qSQL.SQLConnection:=ServerContainer1.GetConnection;

   qMOV:= TSQLQuery.Create(nil);
   qMOV.SQLConnection:=ServerContainer1.GetCntGSMarket;


   lsReg:=TStringList.Create;
   lsReg.Text:='Erro:Sem conexao';
   try
     try
       ServerContainer1.GetConnection.Open;

       sCnpj:=FormatMaskText('00.000.000/0000-00;0;*',sCnpj);
       qSQL.Close;
       qSQL.SQL.Text:='SELECT CODIGO,NOME,FANTASIA,DATAATUALIZ,GRADE_TRIB FROM CLIENTES WHERE CNPJ='+QuotedStr(sCnpj);
       qSQL.Open;
       if qSQL.Eof then
         raise Exception.Create('Empresa não encontrada');
       if qSQL.FieldByName('GRADE_TRIB').AsString<>'S' then
         raise Exception.Create('Empresa não configurada');

       //TIdURI.URLDecode(cSQL);
       cSQL := Trim(StringReplace(cSQL,'<*>','/',[rfReplaceAll]));
       cSQL := Trim(StringReplace(cSQL,'<->','=',[rfReplaceAll]));

       qMOV.Close;
       qMOV.SQL.Text := cSQL+' AND CSTB IS NOT NULL AND ALICMS IS NOT NULL';
       qMOV.Open;
       // nao pode retornar semmovimento porque pega em blocos..
       //if qMOV.Eof then
       //  raise Exception.Create('Sem movimento');

       lsReg.Clear;
       lsReg.Text := '';
       while not(qMOV.eof) do begin
         cL:=QuotedStr(qMOV.FieldByName('NCM').AsString)+','+
             QuotedStr(qMOV.FieldByName('CEST').AsString)+','+
             QuotedStr(qMOV.FieldByName('CSTB').AsString)+','+
             ValorSQL(qMOV.FieldByName('ALICMS').AsString)+','+
             ValorSQL(qMOV.FieldByName('MVA').AsString)+','+
             ValorSQL(qMOV.FieldByName('REDUCAO').AsString)+','+
             ValorSQL(qMOV.FieldByName('PISCT').AsString)+','+
             ValorSQL(qMOV.FieldByName('PISAL').AsString)+','+
             ValorSQL(qMOV.FieldByName('PISCT1').AsString)+','+
             ValorSQL(qMOV.FieldByName('PISAL1').AsString)+','+
             ValorSQL(qMOV.FieldByName('PISTB').AsString)+','+
             ValorSQL(qMOV.FieldByName('PISNT').AsString)+','+
             ValorSQL(qMOV.FieldByName('COFCT').AsString)+','+
             ValorSQL(qMOV.FieldByName('COFAL').AsString)+','+
             ValorSQL(qMOV.FieldByName('COFCT1').AsString)+','+
             ValorSQL(qMOV.FieldByName('COFAL1').AsString)+','+
             ValorSQL(qMOV.FieldByName('COFTB').AsString)+','+
             ValorSQL(qMOV.FieldByName('COFNT').AsString)+'';
         lsReg.Add(cL);
         qMOV.Next;
       end;


     except on e : exception do
       lsReg.Text:='Erro:'+e.message;
        //GravaLog('Exceção GetStream '+e.Message,cSQL);
     end;
   finally
     // retorna
     Result := TStringStream.Create('');
     lsReg.SaveToStream(Result);
     //lsReg.Free;

     qMOV.Close;
     qMOV.SQLConnection.Close;
     qMOV.Free;
     qSQL.Close;
     qSQL.SQLConnection.Close;
     qSQL.Free;
     //frmPrin.Led(false);
   end;


end;

function TServerMethods1.ncmun(sCnpj: String; cSQL: WideString): TStringStream;
var
  //sStream: TStringStream;
  lsUn:TStringList;
  cM,cL:String;
  nF : Integer;
  fCpo: TField;
  qSQL: TSQLQuery;
  qMOV: TSQLQuery;

begin

   // url=http://10.1.1.4:8082/datasnap/rest/TServerMethods1/GetStream/290402277573055282
   Result := TStringStream.Create('Olá');
   exit;
   qSQL:= TSQLQuery.Create(nil);
   qSQL.SQLConnection:=ServerContainer1.GetConnection;

   qMOV:= TSQLQuery.Create(nil);
   qMOV.SQLConnection:=ServerContainer1.GetCntGSMarket;


   lsUn:=TStringList.Create;
   lsUn.Text:='Erro:Sem conexao';
   try
     try
       ServerContainer1.GetConnection.Open;

       sCnpj:=FormatMaskText('00.000.000/0000-00;0;*',sCnpj);
       qSQL.Close;
       qSQL.SQL.Text:='SELECT CODIGO,NOME,FANTASIA,DATAATUALIZ,GRADE_TRIB FROM CLIENTES WHERE CNPJ='+QuotedStr(sCnpj);
       qSQL.Open;
       if qSQL.Eof then
         raise Exception.Create('Empresa não encontrada');
       if qSQL.FieldByName('GRADE_TRIB').AsString<>'S' then
         raise Exception.Create('Empresa não configurada');

       //TIdURI.URLDecode(cSQL);
       cSQL := Trim(StringReplace(cSQL,'<*>','/',[rfReplaceAll]));
       cSQL := Trim(StringReplace(cSQL,'<->','=',[rfReplaceAll]));

       qMOV.Close;
       qMOV.SQL.Text := cSQL;
       qMOV.Open;

       lsUn.Clear;
       lsUn.Text := '';
       while not(qMOV.eof) do begin
         cL:=QuotedStr(qMOV.FieldByName('NCM').AsString)+','+
             QuotedStr(qMOV.FieldByName('UNIDADE').AsString)+','+
             ValorSQL(qMOV.FieldByName('INICIO').AsString)+','+
             ValorSQL(qMOV.FieldByName('FIM').AsString)+','+
             ValorSQL(qMOV.FieldByName('DETALHAMENTO').AsString);
         lsUn.Add(cL);
         qMOV.Next;
       end;


     except on e : exception do
       lsUn.Text:='Erro:'+e.message;
        //GravaLog('Exceção GetStream '+e.Message,cSQL);
     end;
   finally
     // retorna
     Result := TStringStream.Create('');
     lsUn.SaveToStream(Result);
     //lsUn.Free;

     qMOV.Close;
     qMOV.SQLConnection.Close;
     qMOV.Free;
     qSQL.Close;
     qSQL.SQLConnection.Close;
     qSQL.Free;
     //frmPrin.Led(false);
   end;


end;



function TServerMethods1.updatePagamento(oDoc: TJSONObject): String;
var
  cPg,sCod,sEmit:String;
  sDoc,sTip,sNameArq,sDataArq:string;
  cDir:String;
  sql  : String;
  aImg : TJSONArray;
  nImg,nI: Integer;
  qREG,qUSU,qAUX : TSQLQuery;
  TD: TTransactionDesc;
  cnt:TSQLConnection;
begin
   try
     sql  := '';
     cnt  := TSQLConnection.create(nil);
     ConfConexao(cnt);
     qREG := TSQLQuery.Create(nil);
     qAUX := TSQLQuery.Create(nil);
     qUSU := TSQLQuery.Create(nil);
     qAUX.SQLConnection := cnt;
     qREG.SQLConnection := cnt;
     qUSU.SQLConnection := cnt;

     TD.TransactionID := TDSSessionManager.GetThreadSession.Id;
     TD.IsolationLevel := xilREADCOMMITTED;
     cnt.StartTransaction(TD);

     try
        qUSU.Close;
        qUSU.SQL.Text:='SELECT * FROM ( '+
         'SELECT U.*,'+
         'CASE WHEN U.TIPO=''P'' THEN '+
         ' (SELECT CNPJ FROM ASSOCIADOS WHERE CODIGO=U.EMPRESA) ELSE '+
         ' (SELECT CNPJ FROM CLIENTES WHERE CODIGO=U.EMPRESA) END AS CNPJ '+
         'FROM USUARIOSNET U '+
         'WHERE U.LOGIN='+QuotedStr(oDoc.GetValue('LOGIN').Value)+' '+
         'AND U.SENHA='+QuotedStr(oDoc.GetValue('SENHA').Value)+' AND '+
         'U.TIPO='+QuotedStr('P')+' AND '+
         'COALESCE(U.SITUACAO,''N'')<>''B'' '+
         ') U '+
         'WHERE U.CNPJ='+QuotedStr(FormataCPFCNPJ(SoNumero(oDoc.GetValue('CNPJU').Value)));

        qUSU.Open;

        if qUSU.Eof then
           cPg:='[{"STATUS":"NO","MENSAGEM":"Usuario nao encontrado"}]'
        else begin
           if(Trim(oDoc.GetValue('LOGIN').Value)='')then
              cPg:='{"STATUS":"NO","MSG":"Transportadora não enconstrada"}'
           else begin
              if(Copy(oDoc.GetValue('CNPJT').Value,1,3)='RUC')then
                 sEmit:=oDoc.GetValue('CNPJT').Value
              else begin
                 sEmit:=FormataCPFCNPJ(SoNumero(oDoc.GetValue('CNPJT').Value));
              end;
           end;

           qAUX.Close;
           qAUX.SQL.Text:='SELECT FIRST 1 CODIGO FROM CLIENTES WHERE CNPJ='+QuotedStr(sEmit);
           qAUX.Open;

           if qAUX.Eof then
              cPg:='{"STATUS":"NO","MSG":"Transportadora não encontrada"}';
           sEmit := qAUX.FieldByName('CODIGO').AsString;

           if(cPg='')then begin
              qAUX.Close;
              qAUX.SQL.Text:='SELECT DOCUMENTO '+
              'FROM TRANSACOESDOC '+
              'WHERE DOCUMENTO=0'+SoNumero(oDoc.GetValue('DOCN').Value)+' AND '+
              'CLIENTE=0'+sEmit+' AND '+
              '(COALESCE(SITUACAO,'''')<>''R'' OR COALESCE(SITUACAO,'''')<>''C'')';
              sql:=qAUX.SQL.Text;
              qAUX.Open;
              sCod := '(SELECT GEN_ID(GDOC,1) FROM RDB$DATABASE)';
              if not(qAUX.Eof)then
                  cPg:='{"STATUS":"NO","MSG":"Documento já digitado"}';
           end;

           if((Trim(oDoc.GetValue('DOCT').Value)='SD')and(StrToNumI(oDoc.GetValue('PESO').Value)<=0))or(StrToNumF(oDoc.GetValue('PESO').Value)<0.00)then
              cPg:='{"STATUS":"NO","MSG":"PESO DE CHEGADA INVÁLIDO"}';
           if(StrToNumI(oDoc.GetValue('VALOR').Value)<=0)then
              cPg:='{"STATUS":"NO","MSG":"VALOR DO PAGAMENTO INVÁLIDO"}';
           if(Trim(oDoc.GetValue('DOCN').Value)='')then
              cPg:='{"STATUS":"NO","MSG":"DOCUMENTO INVÁLIDO"}';
           if(Trim(oDoc.GetValue('DOCT').Value)='')or
              ((oDoc.GetValue('DOCT').Value<>'SD')and(oDoc.GetValue('DOCT').Value<>'AD')and
              (oDoc.GetValue('DOCT').Value<>'RC')and(oDoc.GetValue('DOCT').Value<>'NF')and
              (oDoc.GetValue('DOCT').Value<>'PD')and(oDoc.GetValue('DOCT').Value<>'ES')and
              (oDoc.GetValue('DOCT').Value<>'AB')and(oDoc.GetValue('DOCT').Value<>'AD2')and
              (oDoc.GetValue('DOCT').Value<>'AD3')and(oDoc.GetValue('DOCT').Value<>'AD1'))then
                 cPg:='{"STATUS":"NO","MSG":"TIPO DE DOCUMENTO INVÁLIDO"}';

           if(cPg='')then begin
              qAUX.Close;
              qAUX.SQL.Text:='SELECT FIRST 1 CURRENT_TIMESTAMP AS AGORA FROM PARAMETROS';
              qAUX.Open;

              qREG.SQL.Clear;
              qREG.SQL.Add('UPDATE OR INSERT INTO TRANSACOESDOC(');
              qREG.SQL.Add('CODIGO,ASSOCIADO,USUARIO,DATA,DOCUMENTO,TIPO,CLIENTE,');
              qREG.SQL.Add('VALOR,TPDESCONTO,DESCONTO,VALORPAGO,PESOCHE,SITUACAO,ORIGEM)');
              qREG.SQL.Add('VALUES(');
              qREG.SQL.Add(sCod+',');
              qREG.SQL.Add('0'+qUSU.FieldByName('EMPRESA').AsString+',');
              qREG.SQL.Add('0'+qUSU.FieldByName('CODIGO').AsString+',');
              qREG.SQL.Add(QuotedStr(FormatDateTime('dd.mm.yyyy hh:MM:ss',qAUX.FieldByName('AGORA').AsDateTime))+',0'+oDoc.GetValue('DOCN').Value+',');
              qREG.SQL.Add(QuotedStr(oDoc.GetValue('DOCT').Value)+',');
              qREG.SQL.Add('0'+sEmit+',');
              qREG.SQL.Add(ValorSQL(oDoc.GetValue('VALOR').Value)+',');
              qREG.SQL.Add(QuotedStr('D')+',0,'+ValorSQL(oDoc.GetValue('VALOR').Value)+',');
              qREG.SQL.Add(iif(trim(oDoc.GetValue('PESO').Value)='','0',oDoc.GetValue('PESO').Value)+','+QuotedStr('N')+','+QuotedStr('1')+')');
              qREG.SQL.Add('RETURNING CODIGO,DATA,PROTOCOLO,CAST(DATA AS VARCHAR(24))');
              qREG.SQL.SaveToFile('USUARIOSNET.txt');
              sql:=qREG.SQL.Text;
              qREG.open;

              aImg := oDoc.GetValue('DOC') as TJSONArray;
              nI   := 1;
              for nImg := 0 to aImg.Size - 1 do begin
                 sNameArq := '';
                 sDataArq := '';
                 sTip     := aImg.Get(nImg).GetValue<string>('TIPO');
                 sDoc     := aImg.Get(nImg).GetValue<string>('BASE64');

                 if(Trim(sDoc)<>'')then begin
                     cDir  :='doc\'+FormatDateTime('yyyymm',qAUX.FieldByName('AGORA').AsDateTime);
                    if not(DirectoryExists(cDir)) then
                       ForceDirectories(cDir);

                    sDataArq:=FormataDataFile(qREG.FieldByName('CAST').AsString,true);

                    sNameArq :=cDir+'\ARQ'+Copy(SoNumero(qUSU.FieldBYName('CNPJ').ASString),1,8)+'.'+sDataArq+'_DOC-'+IntToStr(nI);
                    Base64FileDecode(sDoc,sNameArq,sTip);
                    inc(nI);
                 end;
              end;

              cPg := '{"STATUS":"OK","MSG":"REGISTRO INCLUIDO COM SUCESSO","CODIGO":"'+qREG.FieldByName('CODIGO').AsString+'"}';
           end;
        end;


        if cnt.InTransaction then
          cnt.Commit(TD);
       except on e : exception do begin
         if cnt.InTransaction then
           cnt.Rollback(TD);
         Gravalog('Erro no pagamento: '+e.message);
         cPg := '{"STATUS":"NO","MSG":"'+e.message+'"}';
       end;
     end;

   finally
      FreeAndNil(qUSU);
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(cnt);
      Result := cPg;
   end;
end;

function TServerMethods1.updateCadastroM(oCad:TJSONObject): TJSONArray;
var
  cPg,sql,sTic,sVer,sCod: String;
  qREG,qAUX : TSQLQuery;
  TD : TTransactionDesc;
  cnt:TSQLConnection;
  jsonObj:TJSONObject;
  // ACBrMail1:TACBrMail;
begin
//   try
//     sql  := '';
//
//     qREG := TSQLQuery.Create(nil);
//     qAUX := TSQLQuery.Create(nil);
//     cnt  := TSQLConnection.create(nil);
//
//     ConfConexao(cnt);
//
//     qAUX.SQLConnection := cnt;
//     qREG.SQLConnection := cnt;
//
//     TD.TransactionID := TDSSessionManager.GetThreadSession.Id;
//     TD.IsolationLevel := xilREADCOMMITTED;
//     cnt.StartTransaction(TD);
//
//     ACBrMail1 := TACBrMail.Create(nil);
//     jsonObj := TJSONObject.Create;
//
//     Result := TJSONArray.Create;
//     try
//        if(Length(SoNumero(oCad.GetValue('CPF').Value)) <> 11)then
//           jsonObj.AddPair('code','2')
//        else if(Trim(oCad.GetValue('NOME').Value) = '') then
//           jsonObj.AddPair('code','3')
//        else if(Trim(oCad.GetValue('EMAIL').Value) = '')then
//           jsonObj.AddPair('code','4')
//        else if(Length(SoNumero(oCad.GetValue('TEL').Value)) <> 11)then
//           jsonObj.AddPair('code','5')
//        else if(Trim(oCad.GetValue('SENHA').Value) = '') then
//           jsonObj.AddPair('code','6');
//
//
//        if (jsonObj.Count = 0) then begin
//           qAUX.Close;
//           qAUX.SQL.Text := 'SELECT CODIGO '+
//           'FROM MOTORISTAS '+
//           'WHERE CNPJ ='+QuotedStr(oCad.GetValue('CPF').Value);
//           sql := qAUX.SQL.Text;
//           qAUX.Open;
//           if not qAUX.Eof then
//              jsonObj.AddPair('code','8');
//        end;
//
//        if (jsonObj.Count = 0) then begin
//           sTic := GetRandomPassword(qAUX,32,'E');
//           qAUX.Close;
//           qAUX.SQL.Text := 'UPDATE OR INSERT INTO '+
//           'MOTORISTAS(CODIGO,CNPJ,NOME,CELULAR,EMAIL,SITUACAO,SENHA,TICKET,CONVIDADO,DATA) '+
//           'VALUES((SELECT COALESCE(MAX(CODIGO),0)+1 FROM MOTORISTAS), '+
//           QuotedStr(oCad.GetValue('CPF').Value)+','+
//           QuotedStr(oCad.GetValue('NOME').Value)+','+
//           QuotedStr(oCad.GetValue('TEL').Value)+','+
//           QuotedStr(oCad.GetValue('EMAIL').Value)+',''P'','+
//           QuotedStr(oCad.GetValue('SENHA').Value)+','+QuotedStr(sTic)+','+
//           QuotedStr(oCad.GetValue('CONVIDADO').Value)+',CURRENT_TIMESTAMP)RETURNING CODIGO';
//           sql := qAUX.SQL.Text;
//           qAUX.open;
//
//           sVer := GetRandomNumber(6);
//           sCod := qAUX.FieldByName('CODIGO').AsString;
//
//           qREG.Close;
//           qREG.SQL.Clear;
//           qREG.SQL.Add('UPDATE OR INSERT INTO VALIDACAO(');
//           qREG.SQL.Add('TIPO,CODIGO,ITEM,DATA,VALOR,SITUACAO)VALUES(');
//           qREG.SQL.Add(QuotedStr('M')+',0'+sCod+',');
//           qREG.SQL.Add('(SELECT COALESCE(MAX(ITEM),0)+1 FROM VALIDACAO WHERE TIPO=''E'' AND CODIGO=0'+sCod+'),');
//           qREG.SQL.Add('CURRENT_TIMESTAMP,'+sVer+',''P'')');
//           sql := qREG.SQL.Text;
//           qREG.ExecSQL(False);
//
//           qAUX.Close;
//           qAUX.SQL.Text:='SELECT SMTP,PORTA,CONTA,SENHA FROM PARAMETROS WHERE CODIGO=1';
//           sql:=qAUX.SQL.Text;
//           qAUX.open;
//
//           ACBrMail1.Host     := qAUX.FieldByName('SMTP').AsString;
//           ACBrMail1.Port     := qAUX.FieldByName('PORTA').AsString;
//           ACBrMail1.Username := qAUX.FieldByName('CONTA').AsString;
//           ACBrMail1.Password := qAUX.FieldByName('SENHA').AsString;
//           ACBrMail1.FromName := 'Aproms Fretes';
//           ACBrMail1.From     := qAUX.FieldByName('CONTA').AsString;
//           ACBrMail1.SetSSL   :=  true;
//           ACBrMail1.SetSSL   :=  true;
//           ACBrMail1.AddAddress(oCad.GetValue('EMAIL').Value);
//
//           ACBrMail1.ClearAttachments;
//           ACBrMail1.Subject  := 'Código de verificação de email:'+sVer;
//           ACBrMail1.AltBody.Clear;
//           ACBrMail1.AltBody.Add('Oi '+oCad.GetValue('NOME').Value+', seja bem vindo a nossa plataforma');
//           ACBrMail1.AltBody.Add('');
//           ACBrMail1.AltBody.Add('Você está a um passo de encontrar  cargas de forma facil e rápido');
//           ACBrMail1.AltBody.Add('');
//           ACBrMail1.AltBody.Add('Por favor confirme seu endereço de email copiando e colando esse código em nosso aplicativo');
//           ACBrMail1.AltBody.Add('');
//           ACBrMail1.AltBody.Add('Código:'+sVer);
//           ACBrMail1.AltBody.Add('');
//           ACBrMail1.AltBody.Add('Abraços');
//           ACBrMail1.AltBody.Add('');
//           ACBrMail1.AltBody.Add('Aproms Fretes');
//           ACBrMail1.Send();
//           jsonObj.AddPair('code','0');
//           jsonObj.AddPair('ticket',sTic);
//           jsonObj.AddPair('codigo',sCod);
//
//        end;
//
//        Result.AddElement(jsonObj);
//
//        if cnt.InTransaction then
//          cnt.Commit(TD);
//       except on e : exception do begin
//         if cnt.InTransaction then
//           cnt.Rollback(TD);
//            GravaLog('ERRO NO CADASTRO DE EMPRESA SQL:'+e.Message+', SQL:'+sql);
//         cPg := '{"STATUS":"NO","MSG":"'+e.message+'"}';
//       end;
//     end;
//
//   finally
//      FreeAndNil(qAUX);
//      FreeAndNil(qREG);
//      FreeAndNil(cnt);
//      FreeAndNil(ACBrMail1);
//   end;
end;


//function TServerMethods1.busca(sPar:String): TJSONArray;
//var
//    cPg,cSql,sql:String;
//    nI:INteger;
//    aDado : TArray<String>;
//    qREL  : TSQLQuery;
//    qUSU  : TSQLQuery;
//    oPrin : TJSONObject;
//    oRes  : TJSONObject;
//    aPrin : TJSONArray;
//    cDB   : TSQLConnection;
//begin
//   try
//     sql  := '';
//     cDB  := TSQLConnection.create(nil);
//     ConfConexao(cDB);
//
//     qREL := TSQLQuery.Create(nil);
//     qREL.SQLConnection:=cDB;
//     qUSU := TSQLQuery.Create(nil);
//     qUSU.SQLConnection:=cDB;
//     aDado := sPar.Split([';']);
//     oRes  := TJSONObject.Create;
//     aPrin := TJSONArray.Create;
//     try
//
//        if(TemSQLApp(aDado))then begin
//           cPg:='{"STATUS":"NO","MSG":"Não permitido"}';
//           GravaLog('SQL DE (INSERT|DELETE|UPDATE) PASSADA NO APP');
//        end else begin
//          qUSU.Close;
//             qUSU.SQL.Text:='SELECT U.*,'+
//             'CASE WHEN U.TIPO=''P'' THEN '+
//             ' (SELECT CNPJ FROM ASSOCIADOS WHERE CODIGO=U.EMPRESA) ELSE '+
//             ' (SELECT CNPJ FROM CLIENTES WHERE CODIGO=U.EMPRESA) END AS CNPJ,'+
//             'CURRENT_TIMESTAMP AS HOJE '+
//             'FROM USUARIOSNET U '+
//             'WHERE U.TICKET='+QuotedStr(aDado[0])+' AND '+
//             'COALESCE(U.SITUACAO,''N'')<>''B''  ';
//             sql:=qUSU.SQL.Text;
//             qUSU.SQL.SaveToFile('TICKET.txt');
//             qUSU.Open;
//           if(qUSU.Eof)then
//              cPg:='{"STATUS":"NO","MSG":"Usuário não localizado"}'
//           else begin
//              cSql:=aDado[1];
//
//              cSql:=StringReplace(cSql,'<->','=',[rfReplaceAll]);
//              cSql:=StringReplace(cSql,'<p>','%',[rfReplaceAll]);
//              cSql:=StringReplace(cSql,'<*>','/',[rfReplaceAll]);
//
//              qREL.Close;
//              qREL.SQL.Text:=cSql;
//              qREL.Open;
//              if(qREL.Eof)then
//                cPg:='{"STATUS":"SEM","MSG":"Nenhum registro encontrado"}'
//              else begin
//                 while not(qREL.Eof) do begin
//                    oPrin := TJSONObject.Create;
//                    AddCampo(qREL,oPrin);
//                    try
//                      aPrin.AddElement(oPrin);
//                    except on E: Exception do
//                       GravaLog('ERRO AO CRIAR JSON APP '+e.Message)
//                    end;
//                    qREL.Next;
//                 end;
//
//                 oRes.AddPair('DADOS',aPrin);
////                 result := oRes;
//              end;
//           end;
//        end;
//        result.Add(oRes);
//
//      except on e : exception do begin
//        Gravalog('Erro buscando dados app: '+e.message+sLineBreak+' 1 - USERNAME:'+cDB.Params.Values['User_Name']+' SENHA:'+cDB.Params.Values['Password']);
//        cPg:='{"STATUS":"NO","MSG":"'+e.message+'"}';
//      end;
//     end;
//
//   finally
//      oRes.DisposeOf;
//      FreeAndNil(qUSU);
//      FreeAndNil(qREL);
//      FreeAndNil(cDB);
//   end;
//end;
function TServerMethods1.updateAtualizaP(oCad: TJSONObject): TJSONArray;
var
  cPg,sql: String;
  qREG,qAUX : TSQLQuery;
  TD : TTransactionDesc;
  cnt:TSQLConnection;
  jsonObj:TJSONObject;
begin
   try
     sql  := '';
     cnt  := TSQLConnection.create(nil);
     qREG := TSQLQuery.Create(nil);
     qAUX := TSQLQuery.Create(nil);

     ConfConexao(cnt);

     qAUX.SQLConnection := cnt;
     qREG.SQLConnection := cnt;

     TD.TransactionID := TDSSessionManager.GetThreadSession.Id;
     TD.IsolationLevel := xilREADCOMMITTED;
     cnt.StartTransaction(TD);

     jsonObj := TJSONObject.Create;

     Result := TJSONArray.Create;
     try
        if(Trim(oCad.GetValue('NOME').Value) = '') then
           jsonObj.AddPair('code','3')
        else if(Length(SoNumero(oCad.GetValue('TEL').Value)) <> 11)then
           jsonObj.AddPair('code','5')
        else if(Trim(oCad.GetValue('SENHA').Value) = '') then
           jsonObj.AddPair('code','6')
        else if(Trim(oCad.GetValue('TICKET').Value) = '') then
           jsonObj.AddPair('code','11')
       else if(Trim(oCad.GetValue('EMAIL').Value) = '') then
           jsonObj.AddPair('code','4');

        if(oCad.Count = 0)then
            jsonObj.AddPair('code','99');
        if(jsonObj.Count = 0)then begin
           qAUX.Close;
           qAUX.SQL.Text := 'SELECT CODIGO FROM MOTORISTAS '+
           'WHERE TICKET='+QuotedStr(oCad.GetValue('TICKET').Value);
           sql := qREG.SQL.Text;
           qAUX.Open;
           if qAUX.Eof then
              jsonObj.AddPair('code','11');
        end;

        if (jsonObj.Count = 0) then begin
           qREG.Close;
           qREG.SQL.Text := 'UPDATE OR INSERT INTO '+
           'MOTORISTAS(CODIGO,NOME,CELULAR,SENHA,EMAIL) '+
           'VALUES('+qAUX.FieldByName('CODIGO').AsString+','+
           QuotedStr(oCad.GetValue('NOME').Value)+','+
           QuotedStr(oCad.GetValue('TEL').Value)+','+
           QuotedStr(oCad.GetValue('SENHA').Value)+','+
           QuotedStr(oCad.GetValue('EMAIL').Value)+')';
           sql := qREG.SQL.Text;
           qREG.ExecSQL(false);
           jsonObj.AddPair('code','0');
        end;

        Result.AddElement(jsonObj);

        if cnt.InTransaction then
          cnt.Commit(TD);
       except on e : exception do begin
         if cnt.InTransaction then
           cnt.Rollback(TD);
         Gravalog('Erro no cadastro de motoristas app: '+e.message+' SQL:'+sql);
         cPg := '{"STATUS":"NO","MSG":"'+e.message+'"}';
       end;
     end;

   finally
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(cnt);
   end;
end;

function TServerMethods1.loginApp(cpf, senha: string): TJSONArray;
var
  cPg,sql,sTic: String;
  qREG,qAUX : TSQLQuery;
  TD : TTransactionDesc;
  cnt:TSQLConnection;
  jsonObj:TJSONObject;
begin
   try
      sql  := '';
      cnt  := TSQLConnection.create(nil);
      qREG := TSQLQuery.Create(nil);
      qAUX := TSQLQuery.Create(nil);

      ConfConexao(cnt);

      qAUX.SQLConnection := cnt;
      qREG.SQLConnection := cnt;

      jsonObj := TJSONObject.Create;
      Result  := TJSONArray.Create;
      try
         if((cpf = '') or (senha = '')) then
            jsonObj.AddPair('code','99');

         if(jsonObj.Count = 0)then begin
            if(Length(SoNumero(cpf)) = 11) and (senha <> '')then begin
               sTic := GetRandomPassword(qAUX,32,'E');
               qAUX.Close;
                qAUX.SQL.Text :='SELECT CODIGO,NOME,EMAIL,CELULAR FROM MOTORISTAS WHERE '+
               'CNPJ ='+QuotedStr(cpf)+' AND SENHA='+QuotedStr(senha)+'';
               qAUX.Open;
               if not qAUX.Eof then  begin
                 qREG.Close;
                 qREG.SQL.Text := 'UPDATE MOTORISTAS SET TICKET='+QuotedStr(sTic)+' '+
                 'WHERE CNPJ = '+QuotedStr(cpf)+' AND SENHA='+QuotedStr(senha)+'';
                 qREG.ExecSQL(false);
                 jsonObj.AddPair('code','0');
                 jsonObj.AddPair('ticket',sTic);
                 jsonObj.AddPair('nome',qAUX.FieldByName('NOME').AsString);
                 jsonObj.AddPair('email',qAUX.FieldByName('EMAIL').AsString);
                 jsonObj.AddPair('celular',qAUX.FieldByName('CELULAR').AsString);
                 jsonObj.AddPair('codigo',qAUX.FieldByName('CODIGO').AsString);

               end else
                  jsonObj.AddPair('code','6');
            end;
         end;

         Result.AddElement(jsonObj);
         if cnt.InTransaction then
            cnt.Commit(TD);
      except on e : exception do begin
         if cnt.InTransaction then
            cnt.Rollback(TD);
         Gravalog('Erro no cadastro de motoristas app: '+e.message);
         cPg := '{"STATUS":"NO","MSG":"'+e.message+'"}';
      end;
      end;
   finally
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(cnt);
   end;
end;
end.

