unit uProdutos;

interface
Uses System.SysUtils,System.Classes,Data.DB, Data.SqlExpr, math,Datasnap.DSSession,MSHTML,ActiveX,FMX.Graphics,
 Soap.EncdDecd,System.JSON;

type
  TProdutos = class
  private
    { private declarations }

  protected
    { protected declarations }
  public
    { public declarations }
    function GetSql():String;
    function Registra(oReq:TJSONObject; qUSU:TSQLQuery):String;

  published

  end;

  var sql : String;
implementation

uses uWMSite, uFrm;


{ TProdutos }

function TProdutos.GetSql: String;
begin
   result := sql;
end;

function TProdutos.Registra(oReq: TJSONObject; qUSU: TSQLQUery): String;
var
   cCod,cValor   : String;
   cValorFrete   : String;
   cAux,cBaseRed : String;
   cPorcentTol   : String;
   cAliquota     : String;
   qREG : TSQLQuery;
begin
   qREG := TSQLQuery.Create(Nil);
   qREG.SQLConnection := qUSU.SQLConnection;
   try
      cCod := Trim(GetValueJSONObject('codigo',oReq));
      if(Trim(GetValueJSONObject('codigo',oReq)) = '')then begin
         Result := '{"erro":"1","mensagem":"Código inválido"}';
         exit;
      end;

      if(Trim(GetValueJSONObject('nome',oReq)) = '')then begin
         Result := '{"erro":"1","mensagem":"Nome inválido"}';
         exit;
      end;

      if(cCod = '0')then
         cCod := '(SELECT COALESCE(MAX(CODIGO),0)+1 FROM PRODUTOS)'
      else begin
         qREG.Close;
         qREG.SQL.Text := 'SELECT CODIGO '+
         'FROM PRODUTOS '+
         'WHERE CODIGO=0'+SoNumero(cCod);
         sql := qREG.SQL.Text;
         qREG.Open;

         if qREG.Eof then begin
            Result := '{"erro":"1","mensagem":"Produto não localizado"}';
            exit;
         end;
      end;

      cAliquota   := iif(JSONIsNull('aliquota',oReq),'0,00',GetValueJSONObject('aliquota', oReq));
      cBaseRed    := iif(JSONIsNull('base_reducao',oReq),'0,00',GetValueJSONObject('base_reducao', oReq));
      cValor      := iif(JSONIsNull('valor',oReq),'0,00',GetValueJSONObject('valor', oReq));
      cValorFrete := iif(JSONIsNull('valor_frete',oReq),'0,00',GetValueJSONObject('valor_frete', oReq));
      cPorcentTol := iif(JSONIsNull('porcentagem_tolerancia',oReq),'0,00',GetValueJSONObject('porcentagem_tolerancia', oReq));

      qREG.Close;
      qREG.SQL.Clear;
      qREG.SQL.Add('UPDATE OR INSERT INTO PRODUTOS(');
      qREG.SQL.Add('CODIGO,NCM,NOME,UNIDADE,VOLUME,');
      qREG.SQL.Add('QUANTIDADE,VRPRODUTO,ESPECIE,PREDOMINANTE,');
      qREG.SQL.Add('CARACTERISTICA,FRETE,FRETEUNID,CSTA,CSTB,');
      qREG.SQL.Add('ALIQUOTA,BASERED,TOLPERC,PAGAICMS,DIGITAPESO,');
      qREG.SQL.Add('OBSCTE,DIGITATOL,TIPOCARGA,EAN)');
      qREG.SQL.Add('VALUES('+cCod+','+QuotedJSON('codigo_ncm',oReq)+',');
      qREG.SQL.Add(QuotedJSON('nome',oReq)+','+QuotedJSON('unidade',oReq)+',');
      qREG.SQL.Add('NULL,NULL,'+ValorSQL(cValor)+',');
      qREG.SQL.Add(QuotedJSON('especie',oReq)+','+QuotedJSON('descricao_predominante',oReq)+',');
      qREG.SQL.Add(QuotedJSON('caracteristica',oReq)+','+ValorSQL(cValorFrete));
      qREG.SQL.Add(','+QuotedJSON('unidade_valor',oReq)+',');
      qREG.SQL.Add(' ''0'','+QuotedJSON('cstb',oReq)+',');
      qREG.SQL.Add(ValorSQL(cAliquota)+','+ValorSQL(cBaseRed)+','+ValorSQL(cPorcentTol)+',');
      qREG.SQL.Add(QuotedJSON('paga_icms',oReq)+','+QuotedJSON('digita_peso',oReq)+','+QuotedJSON('observacao_cte',oReq)+',');
      qREG.SQL.Add(QuotedJSON('digita_tolerancia',oReq)+','+QuotedJSON('tipo_carga',oReq)+',');
      qREG.SQL.Add(QuotedJSON('codigo_ean',oReq)+') RETURNING CODIGO');
      sql := qREG.SQL.Text;
      qREG.Open;

      result := '{'+
      '"erro":0,'+
      '"mensagem":"Registro incluído/registrado com sucesso!",'+
      '"codigo":"'+qREG.FieldByName('CODIGO').AsString+'"'+
      '}';

   finally
      FreeAndNil(qREG);
   end;
end;

end.
