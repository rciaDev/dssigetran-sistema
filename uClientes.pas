unit uClientes;


interface
Uses System.SysUtils,System.Classes,Data.DB, Data.SqlExpr, math,Datasnap.DSSession,MSHTML,ActiveX,FMX.Graphics,
 Soap.EncdDecd,System.JSON;

type
  TClientes = class
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

uses uWMSite, uFrm, uClientesJSON;

{ TClientes }



function TClientes.GetSql: String;
begin
   result:=sql;
end;


function TClientes.Registra(oReq: TJSONObject;qUSU:TSQLQuery;cDB:TSQLConnection): String;
var
   cCod  : String;
   cAux  : String;
   cData : String;
   sqlCampo, sqlValor : String;
   cUsuAlt : String;
   qAUX  : TSQLQuery;
   qREG  : TSQLQuery;
   TD    : TTransactionDesc;
   oCli  : TClienteCadastroJSON;
begin
   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;

   TD.TransactionID   := TDSSessionManager.GetThreadSession.Id;
   TD.IsolationLevel  := xilREADCOMMITTED;
   cDB.StartTransaction(TD);

   oCli := TClienteCadastroJSON.Create;
   try
      try
         oCli.AsJson := oReq.ToString;

         cCod  := iif((oCli.Codigo = '') or (oCli.Codigo = '0'),'0',oCli.Codigo);
         cAux  := cCod;

         qAUX.Close;
         qAUX.SQL.Text := 'SELECT CODIGO '+
         'FROM CLIENTES '+
         'WHERE CODIGO<>0'+cCod+' AND CNPJ='+QuotedStr(FormataCPFCNPJ(oCli.Cnpj));
         sql := qAUX.SQL.Text;
         qAUX.Open;

         if not(qAUX.Eof)then begin
            Result := '{"erro":"1","mensagem":"Esse CNPJ já está sendo utilizado"}';
            exit;
         end;

         if(cCod = '0')then begin
            qAUX.Close;
            qAUX.SQL.Text := 'SELECT COALESCE(MAX(CODIGO),0)+1 AS COD FROM CLIENTES ';
            sql := qAUX.SQL.Text;
            qAUX.Open;

            cCod  := qAUX.FieldByName('COD').AsString;

            sqlCampo := ',DATA,DATAATUALIZ';
            sqlValor := ',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP';
         end else begin
            qAUX.Close;
            qAUX.SQL.Text := 'SELECT CODIGO '+
            'FROM CLIENTES '+
            'WHERE CODIGO=0'+cCod;
            sql := qAUX.SQL.Text;
            qAUX.Open;

            if(qAUX.Eof)then begin
               Result := '{"erro":"1","mensagem":"Registro não localizado"}';
               exit;
            end;

            sqlCampo := ',DATAATUALIZ';
            sqlValor := ',CURRENT_TIMESTAMP';
         end;

         oCli.DescontaQuebra := 'N';
         oCli.AverbaSeguro := 'S';

         qREG.Close;
         qREG.SQL.Clear;
         qREG.SQL.Add('UPDATE OR INSERT INTO CLIENTES');
         qREG.SQL.Add('(CODIGO,TIPO,NOME,FANTASIA,CELULAR,EMAIL1,ENDERECO,NUMERO,BAIRRO,CEP,CIDADE,UF,CNPJ,IE,');
         qREG.SQL.Add('DESC_QUEBRA,AVERBAR,INATIVO,LIMITE,CODPAIS,BLOQUEADO'+sqlCampo+')');
         qREG.SQL.Add('VALUES(0'+cCod+',');
         qREG.SQL.Add(QuotedSan(oCli.Tipo)+','+QuotedSan(Copy(oCli.Nome,1,60))+',');
         qREG.SQL.Add(QuotedSan(Copy(oCli.Fantasia,1,60))+','+QuotedStr(SoNumero(oCli.Celular))+',');
         qREG.SQL.Add(QuotedStr(oCli.Email)+','+QuotedSan(oCli.Endereco)+',');
         qREG.SQL.Add(TrataNumStr(oCli.Numero)+','+QuotedSan(oCli.Bairro)+',');
         qREG.SQL.Add(QuotedStr(oCli.Cep)+','+QuotedSan(oCli.Cidade)+',');
         qREG.SQL.Add(QuotedStr(oCli.Uf)+','+QuotedStr(FormataCPFCNPJ(oCli.Cnpj))+',');
         qREG.SQL.Add(QuotedStr(oCli.Rg)+','+QuotedStr(oCli.DescontaQuebra)+',');
         qREG.SQL.Add(QuotedStr(oCli.AverbaSeguro)+','+QuotedStr(oCli.Situacao)+',');
         qREG.SQL.Add('0,'+QuotedStr('1058')+','+QuotedStr('N'));
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
      FreeAndNil(oCli);
   end;
end;

end.
