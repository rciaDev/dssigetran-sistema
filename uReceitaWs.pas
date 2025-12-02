unit uReceitaWs;

interface
Uses System.SysUtils,System.Classes,Data.DB, Data.SqlExpr, math,Datasnap.DSSession,MSHTML,ActiveX,FMX.Graphics,
 Soap.EncdDecd,midaslib,Datasnap.DBClient,IdHTTP,System.JSON,IdIOHandler,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL,System.Net.HttpClient,
  System.Net.URLClient, System.Net.HttpClientComponent;

type
  TRecWs = class
  private
    { private declarations }

  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create;
    destructor Destroy;
    function BuscaReceitaWs(sCnpj:String):String;

    var
    tDados  :TClientDataSet;
    tAtvPrin:TClientDataSet;
    tAtvSec :TClientDataSet;

  published

  end;

implementation

{ TRecWs }

constructor TRecWs.Create;
begin
   tDados   := TClientDataSet.Create(nil);
   tAtvPrin := TClientDataSet.Create(nil);
   tAtvSec  := TClientDataSet.Create(nil);

   //aqui cria os campos do objeto principal
   tDados.FieldDefs.Clear;
   tDados.FieldDefs.Add('DATA_SITUACAO',     ftString,  10,False);
   tDados.FieldDefs.Add('COMPLEMENTO',       ftString,  50,False);
   tDados.FieldDefs.Add('TIPO',              ftString,  20,False);
   tDados.FieldDefs.Add('NOME',              ftString,  100,False);
   tDados.FieldDefs.Add('UF',                ftString,  2,False);
   tDados.FieldDefs.Add('TELEFONE',          ftString,  20,False);
   tDados.FieldDefs.Add('EMAIL',             ftString,  100,False);
   tDados.FieldDefs.Add('SITUACAO',          ftString,  15,False);
   tDados.FieldDefs.Add('BAIRRO',            ftString,  50,False);
   tDados.FieldDefs.Add('LOGRADOURO',        ftString,  50,False);
   tDados.FieldDefs.Add('NUMERO',            ftString,  10,False);
   tDados.FieldDefs.Add('CEP',               ftString,  10,False);
   tDados.FieldDefs.Add('MUNICIPIO',         ftString,  50,False);
   tDados.FieldDefs.Add('PORTE',             ftString,  20,False);
   tDados.FieldDefs.Add('ABERTURA',          ftString,  10,False);
   tDados.FieldDefs.Add('NATUREZA_JURIDICA', ftString,  100,False);
   tDados.FieldDefs.Add('FANTASIA',          ftString,  100,False);
   tDados.FieldDefs.Add('CNPJ',              ftString,  18,False);
   tDados.FieldDefs.Add('ULTIMA_ATUALIZACAO',ftString,  30,False);
   tDados.FieldDefs.Add('STATUS',            ftString,  5,False);
   tDados.CreateDataSet;
   tDados.Open;

   // cria os campos da atividade_principal
   tAtvPrin.FieldDefs.Clear;
   tAtvPrin.FieldDefs.Add('TEXT',     ftString,  100,False);
   tAtvPrin.FieldDefs.Add('CODE',     ftString,  100,False);
   tAtvPrin.CreateDataSet;
   tAtvPrin.Open;

   // cria os campos da atividade_secundaria
   tAtvSec.FieldDefs.Clear;
   tAtvSec.FieldDefs.Add('TEXT',     ftString,  100,False);
   tAtvSec.FieldDefs.Add('CODE',     ftString,  100,False);
   tAtvSec.CreateDataSet;
   tAtvSec.Open;

end;

destructor TRecWs.Destroy;
begin
   FreeAndNil(tDados);
   FreeAndNil(tAtvPrin);
   FreeAndNil(tAtvSec);
end;

function TRecWs.BuscaReceitaWs(sCnpj: String): String;
var
  i         : integer;
  sRes,sGet : String;
  oPrin     : TJSONObject;
  aAtvPrin  : TJSONArray;
  aAtvSec   : TJSONArray;

  Request   : TNetHTTPClient;
  Response  : IHTTPResponse;

begin
  Request := TNetHTTPClient.Create(nil);
  try
     try
        //13324150000100
        Response := Request.Get('https://www.receitaws.com.br/v1/cnpj/'+sCnpj);
        sGet     := Response.ContentAsString;

        oPrin    := TJSonObject.ParseJSONValue(sGet) AS TJSonObject;

        aAtvPrin := oPrin.GetValue('atividade_principal')    AS TJSONArray;
        aAtvSec  := oPrin.GetValue('atividades_secundarias') AS TJSONArray;

        //grava dados no obejto principal
        tDados.Append;
        tDados.FieldByName('DATA_SITUACAO').AsString := oPrin.GetValue<string>('data_situacao');
        tDados.FieldByName('COMPLEMENTO').AsString   := oPrin.GetValue<string>('complemento');
        tDados.FieldByName('TIPO').AsString          := oPrin.GetValue<string>('tipo');
        tDados.FieldByName('NOME').AsString          := oPrin.GetValue<string>('nome');
        tDados.FieldByName('UF').AsString            := oPrin.GetValue<string>('uf');
        tDados.FieldByName('TELEFONE').AsString      := oPrin.GetValue<string>('telefone');
        tDados.FieldByName('EMAIL').AsString         := oPrin.GetValue<string>('email');
        tDados.FieldByName('SITUACAO').AsString      := oPrin.GetValue<string>('situacao');
        tDados.FieldByName('BAIRRO').AsString        := oPrin.GetValue<string>('bairro');
        tDados.FieldByName('LOGRADOURO').AsString    := oPrin.GetValue<string>('logradouro');
        tDados.FieldByName('NUMERO').AsString        := oPrin.GetValue<string>('numero');
        tDados.FieldByName('CEP').AsString           := oPrin.GetValue<string>('cep');
        tDados.FieldByName('MUNICIPIO').AsString     := oPrin.GetValue<string>('municipio');
        tDados.FieldByName('PORTE').AsString         := oPrin.GetValue<string>('porte');
        tDados.FieldByName('ABERTURA').AsString      := oPrin.GetValue<string>('abertura');
        tDados.FieldByName('NATUREZA_JURIDICA').AsString := oPrin.GetValue<string>('natureza_juridica');
        tDados.FieldByName('FANTASIA').AsString      := oPrin.GetValue<string>('fantasia');
        tDados.FieldByName('CNPJ').AsString          := oPrin.GetValue<string>('cnpj');
        tDados.FieldByName('ULTIMA_ATUALIZACAO').AsString := oPrin.GetValue<string>('ultima_atualizacao');
        tDados.FieldByName('STATUS').AsString        := oPrin.GetValue<string>('status');
        tDados.Post;

        //grava os dados no array de atividades principais
        for i := 0 to aAtvPrin.Count -1 do begin
           tAtvPrin.Append;
           tAtvPrin.FieldByName('TEXT').AsString := aAtvPrin.Get(i).GetValue<String>('text');
           tAtvPrin.FieldByName('CODE').AsString := aAtvPrin.Get(i).GetValue<String>('code');
           tAtvPrin.Post;
        end;

        //grava os dados no array de atividades secundarias
        for i := 0 to aAtvSec.Count -1 do begin
           tAtvSec.Append;
           tAtvSec.FieldByName('TEXT').AsString := aAtvSec.Get(i).GetValue<String>('text');
           tAtvSec.FieldByName('CODE').AsString := aAtvSec.Get(i).GetValue<String>('code');
           tAtvSec.Post;
        end;

        result:='OK';

     except on E: Exception do
        result:='NO '+e.Message;
     end;
  finally
     Request.Free;
  end;
end;


end.
