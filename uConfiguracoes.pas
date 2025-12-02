unit uConfiguracoes;


interface
Uses System.SysUtils,System.Classes,Data.DB, Data.SqlExpr, math,Datasnap.DSSession,MSHTML,ActiveX,FMX.Graphics,
 Soap.EncdDecd,System.JSON;

type
  TConfiguracoes = class
  private
    { private declarations }

  protected
    { protected declarations }
  public
    { public declarations }
    function GetSql():String;
    function RegistraSeguradora(oReq: TJSONObject;qUSU:TSQLQuery;cDB:TSQLConnection): String;
    function BuscaSeguradora(qUSU:TSQLQuery): String;

  published

  end;

  var sql : String;
implementation

uses uWMSite, uFrm, uConfiguracoesJSON;

{ TConfiguracoes }




function TConfiguracoes.GetSql: String;
begin
   result:=sql;
end;


function TConfiguracoes.RegistraSeguradora(oReq: TJSONObject;qUSU:TSQLQuery;cDB:TSQLConnection): String;
var
   cCod  : String;
   cAux  : String;
   cData : String;
   sqlCampo, sqlValor : String;
   cUsuAlt : String;
   qAUX  : TSQLQuery;
   qREG  : TSQLQuery;
   TD    : TTransactionDesc;
   oCon  : TConfiguracoesSeguradora;
begin
   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;

   oCon := TConfiguracoesSeguradora.Create;
   try
      try
         oCon.AsJson := oReq.ToString;

         cCod  := iif((oCon.Codigo = '') or (oCon.Codigo = '0'),'0',oCon.Codigo);
         cAux  := cCod;


         if(cCod = '0')then begin
            qAUX.Close;
            qAUX.SQL.Text := 'SELECT COALESCE(MAX(CODIGO),0)+1 AS COD FROM SEGUROS ';
            sql := qAUX.SQL.Text;
            qAUX.Open;

            cCod  := qAUX.FieldByName('COD').AsString;

            sqlCampo := ',DATA,EMPRESA';
            sqlValor := ',CURRENT_TIMESTAMP,1';
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
         end;

         if(NumeroInicio(oCon.Responsavel) <> '4') and (NumeroInicio(oCon.Responsavel) <> '5')then begin
            Result := '{"erro":"1","mensagem":"Responsável inválido"}';
            exit;
         end;

         if(NumeroInicio(oCon.SeguradoraFornecedor) <> '') and
           (SQLString('SELECT CODIGO FROM FORNECEDORES WHERE CODIGO=0'+NumeroInicio(oCon.SeguradoraFornecedor),qREG) = '') then begin
            Result := '{"erro":"1","mensagem":"Fornecedor inválido"}';
            exit;
         end;

         qREG.Close;
         qREG.SQL.Clear;
         qREG.SQL.Add('UPDATE OR INSERT INTO SEGUROS');
         qREG.SQL.Add('(CODIGO,TRANSAC,APOLICE,RESPONSAVEL,ATIVA'+sqlCampo+')');
         qREG.SQL.Add('VALUES(0'+cCod+',');
         qREG.SQL.Add('0'+NumeroInicio(oCon.SeguradoraFornecedor)+',');
         qREG.SQL.Add(QuotedStr(oCon.Apolice)+',');
         qREG.SQL.Add(QuotedStr(NumeroInicio(oCon.Responsavel))+',');
         qREG.SQL.Add(QuotedStr('S')+sqlValor);
         qREG.SQL.Add(')');
         sql := qREG.SQL.Text;
         qREG.ExecSQL(False);

         qREG.Close;
         qREG.SQL.Clear;
         qREG.SQL.Add('UPDATE OR INSERT INTO CONFIG');
         qREG.SQL.Add('(CODIGO,ATM_CODIGO,ATM_USUARIO,ATM_SENHA,SEGURADORA)');
         qREG.SQL.Add('VALUES(');
         qREG.SQL.Add('1,');
         qREG.SQL.Add(QuotedStr(Copy(oCon.CodigoAcesso,1,60))+',');
         qREG.SQL.Add(QuotedStr(Copy(oCon.NomeUsuario,1,60))+',');
         qREG.SQL.Add(QuotedStr(Copy(oCon.Senha,1,60))+',');
         qREG.SQL.Add(QuotedStr(Copy(oCon.Seguradora,1,20)));
         qREG.SQL.Add(')');
         sql := qREG.SQL.Text;
         qREG.ExecSQL(False);

         Result := '{"erro":0,"mensagem":"Registro '+iif(cAux = '0', 'incluído','atualizado')+' com sucesso!","codigo":"'+cCod+'"}';
      except on E: Exception do begin
         GravaLog('Erro ao gravar seguradora #cliente:'+qUSU.FieldByName('CNPJ').ASString+' #erro:'+e.Message+' SQL:'+sql);

         Result := MensagemErroServer();
      end;
      end;
   finally
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(oCon);
   end;
end;

function TConfiguracoes.BuscaSeguradora(qUSU: TSQLQuery): String;
var
   cCod  : String;
   oRes  : TJSONObject;
   qREG  : TSQLQuery;
begin
   qREG := TSQLQuery.Create(Nil);
   qREG.SQLConnection := qUSU.SQLConnection;

   oRes := TJSONObject.Create;
   try
      try
         qREG.Close;
         qREG.SQL.Text := 'SELECT FIRST 1 S.CODIGO,TRANSAC,APOLICE,RESPONSAVEL,ATIVA,S.DATA,'+
         'F.NOME AS NOMEF '+
         'FROM SEGUROS S '+
         'LEFT JOIN FORNECEDORES F ON F.CODIGO=S.TRANSAC '+
         'WHERE ATIVA='+QuotedStr('S');
         sql := qREG.SQL.Text;
         qREG.Open;

         oRes.AddPair('erro','0');
         oRes.AddPair('codigo',qREG.FieldByName('CODIGO').AsString);
         oRes.AddPair('unidade','MATRIZ');
         oRes.AddPair('seguradora_fornecedor',qREG.FieldByName('TRANSAC').AsString+' '+qREG.FieldByName('NOMEF').AsString);
         oRes.AddPair('responsavel',qREG.FieldByName('RESPONSAVEL').AsString);
         oRes.AddPair('apolice',qREG.FieldByName('APOLICE').AsString);
         oRes.AddPair('data',iif(qREG.FieldByName('DATA').IsNull,'',FormatDateTime('dd/mm/yyyy',qREG.FieldByName('DATA').AsDateTime)));

         qREG.Close;
         qREG.SQL.Text := 'SELECT FIRST 1 ATM_CODIGO,ATM_USUARIO,ATM_SENHA,SEGURADORA FROM CONFIG ';
         sql := qREG.SQL.Text;
         qREG.Open;

         oRes.AddPair('codigo_acesso',qREG.FieldByName('ATM_CODIGO').AsString);
         oRes.AddPair('nome_usuario',qREG.FieldByName('ATM_USUARIO').AsString);
         oRes.AddPair('senha',qREG.FieldByName('ATM_SENHA').AsString);
         oRes.AddPair('seguradora',qREG.FieldByName('SEGURADORA').AsString);

         Result := oRes.ToString();
      except on E: Exception do begin
         GravaLog('Erro ao buscar seguradora #cliente:'+qUSU.FieldByName('CNPJ').ASString+' #erro:'+e.Message+' SQL:'+sql);

         Result := MensagemErroServer();
      end;
      end;
   finally
      oRes.DisposeOf;
      FreeAndNil(qREG);
   end;
end;


end.
