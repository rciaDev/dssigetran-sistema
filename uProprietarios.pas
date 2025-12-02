unit uProprietarios;


interface
Uses System.SysUtils,System.Classes,Data.DB, Data.SqlExpr, math,Datasnap.DSSession,MSHTML,ActiveX,FMX.Graphics,
 Soap.EncdDecd,System.JSON;

type
  TProprietarios = class
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

uses uWMSite, uFrm, uProprietariosJSON;

{ TProprietarios }



function TProprietarios.GetSql: String;
begin
   result:=sql;
end;


function TProprietarios.Registra(oReq: TJSONObject;qUSU:TSQLQuery;cDB:TSQLConnection): String;
var
   cCod  : String;
   cAux  : String;
   cData : String;
   cCodigoBanco : String;
   cNomeBanco   : String;
   sqlCampo : String;
   sqlValor : String;
   cUsuAlt  : String;

   qAUX  : TSQLQuery;
   qREG  : TSQLQuery;
   TD    : TTransactionDesc;
   oProp : TProprietarioCadastroJSON;
begin
   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;

   TD.TransactionID   := TDSSessionManager.GetThreadSession.Id;
   TD.IsolationLevel  := xilREADCOMMITTED;
   cDB.StartTransaction(TD);

   oProp := TProprietarioCadastroJSON.Create;
   try
      try
         oProp.AsJson := oReq.ToString;

         cCod  := iif((oProp.Codigo = '') or (oProp.Codigo = '0'),'0',oProp.Codigo);
         cAux  := cCod;

//         qAUX.Close;
//         qAUX.SQL.Text := 'SELECT CODIGO '+
//         'FROM CLIENTES '+
//         'WHERE CODIGO<>0'+cCod+' AND CNPJ='+QuotedStr(FormataCPFCNPJ(oProp.Cnpj));
//         sql := qAUX.SQL.Text;
//         qAUX.Open;
//
//         if not(qAUX.Eof)then begin
//            Result := '{"erro":"1","mensagem":"Esse CNPJ já está sendo utilizado"}';
//            exit;
//         end;

         if(cCod = '0')then begin
            qAUX.Close;
            qAUX.SQL.Text := 'SELECT COALESCE(MAX(CODIGO),0)+1 AS COD FROM PROPRIETARIOS ';
            sql := qAUX.SQL.Text;
            qAUX.Open;

            cCod  := qAUX.FieldByName('COD').AsString;

            sqlCampo := ',DATA,DATAATUALIZ';
            sqlValor := ',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP';
         end else begin
            qAUX.Close;
            qAUX.SQL.Text := 'SELECT CODIGO '+
            'FROM PROPRIETARIOS '+
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

         cCodigoBanco := '';
         cNomeBanco   := '';

         if(Pos('-',oProp.Banco) <> 0)then begin
            cCodigoBanco := Copy(oProp.Banco,1,Pos('-',oProp.Banco)-1);
            cNomeBanco   := Copy(oProp.Banco,Pos('-',oProp.Banco)+1,oProp.Banco.Length);
         end;

         qREG.Close;
         qREG.SQL.Clear;
         qREG.SQL.Add('UPDATE OR INSERT INTO PROPRIETARIOS');
         qREG.SQL.Add('(CODIGO,TIPO,CNPJ,IE,NOME,fantasia,CEP,ENDERECO,NUMERO,BAIRRO,CAIXAP,EMAIL1,');
         qREG.SQL.Add('CELULAR,CIDADE,UF,INSS_CODIGO,TPTRANSP,RNTRC,INATIVO,BLOQUEADO,EFRETE,RB1_CODIGO,');
         qREG.SQL.Add('RB1_NOME,RB1_AGENCIA,RB1_CONTA,RB1_TITULAR,RB1_TITULAR_CPF'+sqlCampo+')');

         qREG.SQL.Add('VALUES(0'+cCod+',');
         qREG.SQL.Add(QuotedSan(oProp.Tipo)+','+QuotedStr(FormataCPFCNPJ(oProp.Cnpj))+',');
         qREG.SQL.Add(QuotedSan(oProp.Rg)+','+QuotedSan(Copy(oProp.Nome,1,60))+',');
         qREG.SQL.Add(QuotedSan(Copy(oProp.Fantasia,1,60))+','+QuotedSan(oProp.Cep)+',');
         qREG.SQL.Add(QuotedSan(oProp.Endereco)+','+TrataNumStr(oProp.Numero)+',');
         qREG.SQL.Add(QuotedSan(oProp.Bairro)+','+QuotedSan(Copy(oProp.Caixa,1,4))+',');
         qREG.SQL.Add(QuotedStr(oProp.Email)+','+QuotedSan(oProp.Celular)+',');
         qREG.SQL.Add(QuotedSan(oProp.Cidade)+','+QuotedSan(oProp.Uf)+',');
         qREG.SQL.Add('0'+SoNumero(oProp.Inss)+',0'+SoNumero(oProp.Categoria)+',');
         qREG.SQL.Add(QuotedSan(oProp.Rntrc)+','+QuotedSan(oProp.Situacao)+',');
         qREG.SQL.Add(QuotedSan('N')+','+QuotedSan('N')+',');
         qREG.SQL.Add(QuotedSan(cCodigoBanco)+','+QuotedSan(cNomeBanco)+',');
         qREG.SQL.Add(QuotedSan(oProp.Agencia)+','+QuotedSan(oProp.Conta)+',');
         qREG.SQL.Add(QuotedSan(oProp.Titular)+','+QuotedSan(FormataCPFCNPJ(oProp.CpfTitular))+'');
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

         GravaLog('Erro ao gravar proprietário #cliente:'+qUSU.FieldByName('CNPJ').ASString+' #erro:'+e.Message+' SQL:'+sql);

         Result := MensagemErroServer();
      end;
      end;
   finally
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(oProp);
   end;
end;

end.
