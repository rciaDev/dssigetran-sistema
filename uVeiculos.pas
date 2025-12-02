unit uVeiculos;


interface
Uses System.SysUtils,System.Classes,Data.DB, Data.SqlExpr, math,Datasnap.DSSession,MSHTML,Soap.EncdDecd,System.JSON,uVeiculosJSON;

type
  TVeiculos = class
  private
    { private declarations }

    function GravaProprietario(oVei:TVeiculosJSON;cDB:TSQLConnection):String;
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

uses uWMSite, uFrm;

{ TVeiculos }



function TVeiculos.GetSql: String;
begin
   result:=sql;
end;

function TVeiculos.GravaProprietario(oVei: TVeiculosJSON;cDB:TSQLConnection):String;
var
   cCod  : String;
   cAux  : String;
   cTipo : String;

   qAUX  : TSQLQuery;
   qREG  : TSQLQuery;
begin
   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;
   try
      cCod  := iif((oVei.Proprietario.Codigo = '') or (oVei.Proprietario.Codigo = '0'),'0',oVei.Proprietario.Codigo);
      cAux  := cCod;

      cTipo := iif(Length(oVei.Proprietario.CpfCnpj) = 14,'F','J');

      if(cCod = '0')then begin
         qREG.Close;
         qREG.SQL.Clear;
         qREG.SQL.Add('INSERT INTO PROPRIETARIOS');
         qREG.SQL.Add('(CODIGO,TIPO,CNPJ,IE,NOME,FANTASIA,');
         qREG.SQL.Add('TPTRANSP,UF,RNTRC,INATIVO,BLOQUEADO,EFRETE,DATA,DATAATUALIZ)');
         qREG.SQL.Add('VALUES((SELECT COALESCE(MAX(CODIGO),0)+1 FROM PROPRIETARIOS),');
         qREG.SQL.Add(QuotedSan(cTipo)+','+QuotedStr(FormataCPFCNPJ(oVei.Proprietario.CpfCnpj))+',');
         qREG.SQL.Add(QuotedSan(oVei.Proprietario.Ie)+','+QuotedSan(Copy(oVei.Proprietario.Nome,1,60))+',');
         qREG.SQL.Add(QuotedSan(Copy(oVei.Proprietario.Nome,1,60))+',');
         qREG.SQL.Add(QuotedSan(oVei.Proprietario.Categoria)+','+QuotedSan(oVei.Proprietario.Uf)+',');
         qREG.SQL.Add(QuotedSan(SoNumero(oVei.Proprietario.Rntrc))+',');
         qREG.SQL.Add(QuotedSan('N')+','+QuotedSan('N')+',0,');
         qREG.SQL.Add('CURRENT_TIMESTAMP,CURRENT_TIMESTAMP');
         qREG.SQL.Add(')RETURNING CODIGO');
         sql := qREG.SQL.Text;
         qREG.Open;

         cCod := qREG.FieldByName('CODIGO').AsString;
      end else begin
         qAUX.Close;
         qAUX.SQL.Text := 'SELECT CODIGO '+
         'FROM PROPRIETARIOS '+
         'WHERE CODIGO=0'+cCod;
         sql := qAUX.SQL.Text;
         qAUX.Open;

         if(qAUX.Eof)then begin
            Result := 'NULL';
            exit;
         end;

         qREG.Close;
         qREG.SQL.Clear;
         qREG.SQL.Text := 'UPDATE PROPRIETARIOS SET '+
         'CNPJ='+QuotedStr(FormataCPFCNPJ(oVei.Proprietario.CpfCnpj))+','+
         'TIPO='+QuotedStr(cTipo)+','+
         'IE='+QuotedSan(oVei.Proprietario.Ie)+','+
         'NOME='+QuotedSan(Copy(oVei.Proprietario.Nome,1,60))+','+
         'FANTASIA='+QuotedSan(Copy(oVei.Proprietario.Nome,1,60))+','+
         'TPTRANSP='+QuotedSan(oVei.Proprietario.Categoria)+','+
         'UF='+QuotedSan(oVei.Proprietario.Uf)+','+
         'RNTRC='+QuotedSan(SoNumero(oVei.Proprietario.Rntrc))+','+
         'DATAATUALIZ=CURRENT_TIMESTAMP '+
         'WHERE CODIGO=0'+cCod;
         sql := qREG.SQL.Text;
         qREG.ExecSQL(False);
      end;

      Result := cCod;
   finally
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
   end;
end;


function TVeiculos.Registra(oReq: TJSONObject;qUSU:TSQLQuery;cDB:TSQLConnection): String;
var
   cCod  : String;
   cAux  : String;
   cData : String;
   cCodigoProp : String;
   sqlCampo : String;
   sqlValor : String;
   cUsuAlt  : String;

   qAUX  : TSQLQuery;
   qREG  : TSQLQuery;
   TD    : TTransactionDesc;
   oVei : TVeiculosJSON;
begin
   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;

   TD.TransactionID   := TDSSessionManager.GetThreadSession.Id;
   TD.IsolationLevel  := xilREADCOMMITTED;
   cDB.StartTransaction(TD);

   oVei := TVeiculosJSON.Create;
   try
      try
         oVei.AsJson := oReq.ToString;

         cCod  := iif((oVei.Codigo = '') or (oVei.Codigo = '0'),'0',oVei.Codigo);
         cAux  := cCod;

         qAUX.Close;
         qAUX.SQL.Text := 'SELECT CODIGO '+
         'FROM VEICULO '+
         'WHERE CODIGO<>0'+cCod+' AND PLACA='+QuotedStr(FormataPlaca(oVei.Placa));
         sql := qAUX.SQL.Text;
         qAUX.Open;

         if not(qAUX.Eof)then begin
            Result := '{"erro":"1","mensagem":"Essa Placa já está sendo utilizada"}';
            exit;
         end;


         if(cCod = '0')then begin
            qAUX.Close;
            qAUX.SQL.Text := 'SELECT COALESCE(MAX(CODIGO),0)+1 AS COD FROM VEICULO) ';
            sql := qAUX.SQL.Text;
            qAUX.Open;

            cCod  := qAUX.FieldByName('COD').AsString;

            // sqlCampo := ',DATA,DATAATUALIZ';
            // sqlValor := ',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP';
         end else begin
            qAUX.Close;
            qAUX.SQL.Text := 'SELECT CODIGO '+
            'FROM VEICULO '+
            'WHERE CODIGO=0'+cCod;
            sql := qAUX.SQL.Text;
            qAUX.Open;

            if(qAUX.Eof)then begin
               Result := '{"erro":"1","mensagem":"Registro não localizado"}';
               exit;
            end;

            // sqlCampo := ',DATAATUALIZ';
            // sqlValor := ',CURRENT_TIMESTAMP';
         end;

         cCodigoProp := SoNumero(oVei.Proprietario.Codigo);
         if(Trim(oVei.Proprietario.Nome) <> '')then
            cCodigoProp := GravaProprietario(oVei,cDB);

         qREG.Close;
         qREG.SQL.Clear;
         qREG.SQL.Add('UPDATE OR INSERT INTO VEICULO(CODIGO,PLACA,PLACAUF,MODELO,FROTA,PROPRIETARIO,MOTORISTA,');
			 	 qREG.SQL.Add('TIPO,EIXOS,RNTRC,RENAVAN,TARA,CAPKG,CAPM3,EFRETE,INATIVO,');
			 	 qREG.SQL.Add('CAR1PLACA,CAR1PLACAUF,CAR1PROPR,CAR1MODELO,CAR1EIXOS,CAR1RNTRC,CAR1RENAVAN,CAR1TARA,CAR1CAPKG,CAR1CAPM3,');
			 	 qREG.SQL.Add('CAR2PLACA,CAR2PLACAUF,CAR2PROPR,CAR2MODELO,CAR2EIXOS,CAR2RNTRC,CAR2RENAVAN,CAR2TARA,CAR2CAPKG,CAR2CAPM3,');
			 	 qREG.SQL.Add('CAR3PLACA,CAR3PLACAUF,CAR3PROPR,CAR3MODELO,CAR3EIXOS,CAR3RNTRC,CAR3RENAVAN,CAR3TARA,CAR3CAPKG,CAR3CAPM3'+sqlCampo+')');
         qREG.SQL.Add('VALUES(');
         qREG.SQL.Add('0'+cCod+',');
         qREG.SQL.Add(QuotedStr(FormataPlaca(oVei.Placa))+',');
         qREG.SQL.Add(QuotedStr(oVei.UfEmplacamento)+',');
         qREG.SQL.Add(QuotedStr(oVei.Modelo)+',');
         qREG.SQL.Add(QuotedStr(NumeroInicio(oVei.Frota))+',');
         qREG.SQL.Add(QuotedStr(NumeroInicio(oVei.Proprietario.Codigo))+',');
         qREG.SQL.Add(QuotedStr(NumeroInicio(oVei.Motorista))+',');
         qREG.SQL.Add(QuotedStr(oVei.Tipo)+',');
         qREG.SQL.Add(SoNumero(oVei.NumeroEixos)+',');
         qREG.SQL.Add(QuotedStr(SoNumero(oVei.Rntrc))+',');
         qREG.SQL.Add(QuotedStr(oVei.Renavam)+',');
         qREG.SQL.Add(SoNumero(oVei.Tara)+',');
         qREG.SQL.Add(SoNumero(oVei.CapacidadeKg)+',');
         qREG.SQL.Add(SoNumero(oVei.CapacidadeM3)+',');
         qREG.SQL.Add('''0'',''N'',');

         qREG.SQL.Add(QuotedStr(FormataPlaca(oVei.Placa1))+',');
         qREG.SQL.Add(QuotedStr(oVei.UfEmplacamento1)+',');
         qREG.SQL.Add(QuotedStr(NumeroInicio(oVei.Proprietario.Codigo))+',');
         qREG.SQL.Add(QuotedStr(oVei.Modelo1)+',');
         qREG.SQL.Add(SoNumero(oVei.NumeroEixos1)+',');
         qREG.SQL.Add(QuotedStr(SoNumero(oVei.Rntrc1))+',');
         qREG.SQL.Add(QuotedStr(SoNumero(oVei.Renavam1))+',');
         qREG.SQL.Add(SoNumero(oVei.Tara1)+',');
         qREG.SQL.Add(SoNumero(oVei.CapacidadeKg1)+',');
         qREG.SQL.Add(SoNumero(oVei.CapacidadeM31)+',');

         qREG.SQL.Add(QuotedStr(FormataPlaca(oVei.Placa2))+',');
         qREG.SQL.Add(QuotedStr(oVei.UfEmplacamento2)+',');
         qREG.SQL.Add(QuotedStr(NumeroInicio(oVei.Proprietario.Codigo))+',');
         qREG.SQL.Add(QuotedStr(oVei.Modelo2)+',');
         qREG.SQL.Add(SoNumero(oVei.NumeroEixos2)+',');
         qREG.SQL.Add(QuotedStr(SoNumero(oVei.Rntrc2))+',');
         qREG.SQL.Add(QuotedStr(SoNumero(oVei.Renavam2))+',');
         qREG.SQL.Add(SoNumero(oVei.Tara2)+',');
         qREG.SQL.Add(SoNumero(oVei.CapacidadeKg2)+',');
         qREG.SQL.Add(SoNumero(oVei.CapacidadeM32)+',');

         qREG.SQL.Add(QuotedStr(FormataPlaca(oVei.Placa3))+',');
         qREG.SQL.Add(QuotedStr(oVei.UfEmplacamento3)+',');
         qREG.SQL.Add(QuotedStr(NumeroInicio(oVei.Proprietario.Codigo))+',');
         qREG.SQL.Add(QuotedStr(oVei.Modelo3)+',');
         qREG.SQL.Add(SoNumero(oVei.NumeroEixos3)+',');
         qREG.SQL.Add(QuotedStr(SoNumero(oVei.Rntrc3))+',');
         qREG.SQL.Add(QuotedStr(SoNumero(oVei.Renavam3))+',');
         qREG.SQL.Add(SoNumero(oVei.Tara3)+',');
         qREG.SQL.Add(SoNumero(oVei.CapacidadeKg3)+',');
         qREG.SQL.Add(SoNumero(oVei.CapacidadeM33));
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

         GravaLog('Erro ao gravar veiculos #cliente:'+qUSU.FieldByName('CNPJ').ASString+' #erro:'+e.Message+' SQL:'+sql);

         Result := MensagemErroServer();
      end;
      end;
   finally
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(oVei);
   end;
end;


end.
