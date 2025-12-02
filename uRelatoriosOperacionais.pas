unit uRelatoriosOperacionais;
interface
Uses System.SysUtils,System.Classes,Data.DB, Data.SqlExpr, math,Datasnap.DSSession,MSHTML,Soap.EncdDecd,System.JSON;

type
  TRelatoriosOperacionais = class
  private
    { private declarations }
    function GeraRelatorio(cTitulo:String;qREG:TSQLQuery):String;
    function GeraRelatorioHTML(cPg:String):String;

  protected
    { protected declarations }
  public
    { public declarations }
    function GetSql():String;
    function Conhecimentos(Req:TStrings;qUSU:TSQLQuery):String;

  published

  end;

  var sql : String;
implementation

uses uWMSite, uFrm;


{ TRelatoriosOperacionais }




function TRelatoriosOperacionais.GeraRelatorioHTML(cPg: String): String;
begin
   Result := '<!DOCTYPE html>';

   Result := Result + '<head>'+
   '<link href="/bootstrap.min.css" rel="stylesheet" />'+
   '<link href="/print.css" rel="stylesheet" />'+
   '<title>Relatório</title>'+
   '</head>';

   Result := Result + '<body>'+
   cPg+
   '</body>';

   Result := Result + '</html>';
end;

function TRelatoriosOperacionais.GetSql: String;
begin
   result := sql;
end;
//
//function TRelatoriosOperacionais.Clientes(oReq: TJSONObject; qUSU: TSQLQUery): String;
//var
//   qREG : TSQLQuery;
//begin
//   qREG := TSQLQuery.Create(Nil);
//   qREG.SQLConnection := qUSU.SQLConnection;
//   try
//   finally
//      FreeAndNil(qREG);
//   end;
//end;



function TRelatoriosOperacionais.GeraRelatorio(cTitulo:String;qREG: TSQLQuery): String;
var
   cPg : String;
   cCp : String;
   cLogo : String;
   nCp   : Integer;
   qAUX  : TSQLQuery;
begin
   cPg := '';
   qAUX := TSQLQuery.Create(Nil);
   qAUX.SQLConnection := qREG.SQLConnection;

   try
      qAUX.Close;
      qAUX.SQL.Text := 'SELECT LOGOMARCA FROM PARAMETROS';
      sql := qAUX.SQL.Text;
      qAUX.Open;

      cLogo := qAUX.FieldByName('LOGOMARCA').AsString;
      if(Pos(':',cLogo) <> 0)then
         cLogo := StringReplace(cLogo,ExtractFilePath(ParamStr(0)),URL_API,[rfReplaceAll]);

      qAUX.Close;
      qAUX.SQL.Text := 'SELECT NOME,ENDERECO,NUMERO,EMAIL,CEP,CIDADE,ESTADO,CNPJ,IE FROM EMPRESA';
      sql :=qAUX.SQL.Text;
      qAUX.Open;

      cPg := cPg + '<div class="row m-0 p-0">'+
      '<div class="col-6">'+
      ' <img src="'+cLogo+'" width="100%" height="120px"/>'+
      '</div>'+

      '<div class="col-6 d-flex flex-column justify-content-center ">'+

      '<div>'+qAUX.FieldByName('NOME').AsString+'</div>'+
      '<div>'+qAUX.FieldByName('ENDERECO').AsString+','+qAUX.FieldByName('NUMERO').AsString+'</div>'+
      '<div>'+qAUX.FieldByName('EMAIL').AsString+'</div>'+
      '<div>'+qAUX.FieldByName('CEP').AsString+' '+qAUX.FieldByName('CIDADE').AsString+' '+ qAUX.FieldByName('ESTADO').AsString+'</div>'+
      '<div>'+qAUX.FieldByName('CNPJ').AsString+'</div>'+
      '<div>'+qAUX.FieldByName('IE').AsString+'</div>'+

      '</div>'+

      '<div class="col-12 text-center d-flex justify-content-center align-items-center border">'+
      '<h3>'+cTitulo+'</h3>'+
      '</div>'+

      '</div>';

      cPg := cPg + '<table class="table table-striped">';

      // Monta cabeçalho
      cPg := cPg + '<thead>';
      cPg := cPg + '<tr>';
      for nCp := 0 to qREG.FieldCount - 1 do begin
         cPg := cPg + '<th>'+qREG.Fields[nCp].FieldName+'</th>';
      end;
      cPg := cPg + '</tr>';
      cPg := cPg + '</thead>';


      cPg := cPg + '<tbody>';
      while not(qREG.Eof) do begin
         cPg := cPg + '<tr>';
         for nCp := 0 to qREG.FieldCount -1 do
            cPg := cPg + '<td class="py-1">'+qREG.Fields[nCp].AsString+'</td>';
         cPg := cPg + '</tr>';

         qREG.Next;
      end;
      cPg := cPg + '</tbody>';

      cPg := cPg + '</table>';

      Result := cPg;
   finally
      FreeAndNil(qAUX);
   end;
end;

function TRelatoriosOperacionais.Conhecimentos(Req: TStrings;
  qUSU: TSQLQuery): String;
var
   cPg  : String;
   cPor : String;
   qREG : TSQLQuery;
begin
   qREG := TSQLQuery.Create(Nil);
   qREG.SQLConnection := qUSU.SQLConnection;
   try
      qREG.Close;
      qREG.SQL.Text := 'SELECT CODIGO,NOME,CIDADE,UF,TELEFONE '+
      'FROM FORNECEDORES '+
      'WHERE CODIGO>0 ';

      if(Req.Values['filtro'] = '1')then begin
         cPor := 'Nome';
         qREG.SQL.Add('AND UPPER(NOME) LIKE '+QuotedStr('%'+Trim(UpperCase(Req.Values['conteudo']))+'%'))
      end else if(Req.Values['filtro'] = '2')then begin
         cPor := 'Cidade';
         qREG.SQL.Add('AND UPPER(CIDADE) LIKE '+QuotedStr('%'+Trim(UpperCase(Req.Values['conteudo']))+'%'))
      end else if(Req.Values['filtro'] = '3')then begin
         cPor := 'Uf';
         qREG.SQL.Add('AND UPPER(UF)='+QuotedStr(Trim(UpperCase(Req.Values['conteudo']))));
      end;

      qREG.SQL.Add('ORDER BY CODIGO');

      sql := qREG.SQL.Text;
      qREG.Open;

      cPg := GeraRelatorio('Relação de Fornecedores/Por '+cPor,qREG);
   finally
      Result := GeraRelatorioHTML(cPg);
      FreeAndNil(qREG);
   end;
end;


end.
