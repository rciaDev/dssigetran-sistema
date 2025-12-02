unit uBuscas;

interface
Uses System.SysUtils,System.Classes,Data.DB, Data.SqlExpr, math,Datasnap.DSSession,MSHTML,ActiveX,FMX.Graphics,
 Soap.EncdDecd,System.JSON;

type
  TBuscas = class
  private
    { private declarations }

  protected
    { protected declarations }
  public
    { public declarations }
    function GetSql():String;
    function clienteExiste(req:TStrings):String;

  published

  end;

  var sql : String;
implementation

uses uWMSite, uFrm;

{ TBuscas }


function TBuscas.clienteExiste(req: TStrings): String;
var
   qREG : TSQLQuery;
   cDB  : TSQLConnection;
begin
   qREG := TSQLQuery.Create(niL);
   cDB  := TSQLConnection.Create(nil);

   ConfConexao(cDB);

   qREG.SQLConnection := cDB;
   try
      if(Trim(Req.Values['cnpj']) = '')then begin
         Result := '{"erro":1,"mensagem":"CNPJ inválido"}';
         Exit;
      end;

      qREG.Close;
      qREG.SQL.Text := 'SELECT CNPJ FROM EMPRESAS WHERE CNPJ='+QuotedStr(soNumero(Req.Values['cnpj']));
      sql := qREG.SQL.Text;
      qREG.Open;

      if not(qREG.Eof) then begin
         Result := '{"erro":1,"mensagem":"Esse CNPJ já está sendo utilizado"}';
         Exit;
      end;

      Result := '{"erro":0,"mensagem":"CNPJ disponível"}';

   finally
      FreeAndNil(qREG);
      FreeAndNil(cDB);
   end;
end;

function TBuscas.GetSql: String;
begin
   result:=sql;
end;


end.
