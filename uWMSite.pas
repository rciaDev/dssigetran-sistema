{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN UNIT_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN RLINK_WARNING ON}
{$WARN IMPLICIT_STRING_CAST ON}
{$WARN IMPLICIT_STRING_CAST_LOSS ON}
{$WARN EXPLICIT_STRING_CAST OFF}
{$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$WARN CVT_WCHAR_TO_ACHAR ON}
{$WARN CVT_NARROWING_STRING_LOST ON}
{$WARN CVT_ACHAR_TO_WCHAR ON}
{$WARN CVT_WIDENING_STRING_LOST ON}
{$WARN NON_PORTABLE_TYPECAST ON}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}
{$WARN IMMUTABLE_STRINGS OFF}

 // 0 - DEU CERTO
 // 1 - SQL INJECTION
 // 2 - CPF/CNPJ INVALIDO
 // 3 - NOME INVÁLIDO
 // 4 - EMAIL INVÁLIDO
 // 5 - CELULAR INVÁLIDO
 // 6 - SENHAS INVÁLIDAS
 // 7 - NAO CONCORDOU COM OS TERMOS
 // 8 - EMPRESA/MOTORISTA JÁ EXISTENTE
 // 9 - EMAIL JA EM USO
 // 10 - CÓDIGO DE VALIDAÇÃO INVÁLIDO
 // 11 - TICKET INVALIDO
 // 12 - SENHA FRACA
 // 13 - USUARIO NAO LOCALIZADO
 // 14 - USUARIO BLOQUEADO
 // 15 - TEM QUE VERIFICAR
 // 16 - CODIGO DE CIDADE ORIGEM/DESTINO INVALIDA
 // 17 - CIDADE NAO ENCONTRADA
 // 18 - TIPO DE CARGA INVÁLIDA
 // 19 - FRETE INVÁLIDO
 // 20 - FRETE JÁ CANCELADO
 // 21 - FRETE JÁ FINALIZADO
 // 22 - FRETE JA EXCLUIDO
 // 23 - FRETE NÃO PERMITIDO
 // 24 - AVALIAÇÃO INVÁLIDA
 // 25 - NENHUM REGISTRO ENCONTRADONTRADO
 // 30 - convite inesistente
 // 31 - JA EXISTE UMA SOLICITAÇÃO DE SAQUE
 // 101 - ERRO

 // 99 - PARAMETROS INVÁLIDOS
unit uWMSite;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, Datasnap.DSHTTPCommon,
  Datasnap.DSHTTPWebBroker, Datasnap.DSServer,IniFiles,MaskUtils,ReqMulti,
  Web.WebFileDispatcher, Web.HTTPProd,DataSnap.DSAuth,DateUtils,
  Datasnap.DSProxyJavaScript, IPPeerServer, Datasnap.DSMetadata,
  Datasnap.DSServerMetadata, Datasnap.DSClientMetadata, Datasnap.DSCommonServer,
  Datasnap.DSHTTP, IdBaseComponent, IdMessage, Data.FMTBcd, Data.DB,
  Data.SqlExpr, Data.DBXFirebird, IdContext, IdComponent, IdCustomTCPServer,
  IdTCPServer, IdCmdTCPServer, IdExplicitTLSClientServerBase, IdFTPServer,
  Datasnap.DSSession,IdHashMessageDigest,System.JSON,
  Data.DBXCommon,uFrm,System.NetEncoding, Vcl.ExtCtrls, IdTCPConnection,
  IdTCPClient, IdHTTP, ACBrBase, ACBrDFe, ACBrCTe, math,
  Soap.InvokeRegistry, Soap.Rio, Soap.SOAPHTTPClient,System.Net.HttpClient,
  System.Net.URLClient, System.Net.HttpClientComponent, Xml.xmldom, Xml.XMLIntf,
  System.TypInfo, Soap.WebServExp, Soap.WSDLBind, Xml.XMLSchema, Soap.WSDLPub,
  Xml.XMLDoc,ActiveX, ACBrNFe,System.StrUtils ;
  // , Xml.xmldom, Xml.XMLIntf,   Xml.XMLDoc

  {
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Data.DBXFirebird, Data.DB,
  Data.SqlExpr, Data.FMTBcd, Vcl.StdCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, Datasnap.DBClient,IdHashMessageDigest,IniFiles,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP, IdMessage,
  QuickRpt, QRCtrls, Vcl.ExtCtrls,IdAttachmentFile,System.Math,System.Net.HttpClient,
  System.Net.URLClient, System.Net.HttpClientComponent,averbaAtm;
  }

type
  TWMSite = class(TWebModule)
    ServerFunctionInvoker: TPageProducer;
    ReverseString: TPageProducer;
    WebFileDispatcher1: TWebFileDispatcher;
    DSProxyGenerator1: TDSProxyGenerator;
    DSServerMetaDataProvider1: TDSServerMetaDataProvider;
    IdMessage1: TIdMessage;
    postos: TPageProducer;
    tLimpaPDF: TTimer;
    IdHTTP1: TIdHTTP;
    HTTPRIO1: THTTPRIO;
    DSHTTPWebDispatcher1: TDSHTTPWebDispatcher;
    procedure ServerFunctionInvokerHTMLTag(Sender: TObject; Tag: TTag;
      const TagString: string; TagParams: TStrings; var ReplaceText: string);
    procedure WebModuleDefaultAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModuleBeforeDispatch(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebFileDispatcher1BeforeDispatch(Sender: TObject;
      const AFileName: string; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
    procedure WebModuleCreate(Sender: TObject);

    procedure IndexHTMLTag(Sender: TObject; Tag: TTag; const TagString: string;
      TagParams: TStrings; var ReplaceText: string);

    procedure contatoHTMLTag(Sender: TObject; Tag: TTag;
      const TagString: string; TagParams: TStrings; var ReplaceText: string);
    procedure enviaimgHTMLTag(Sender: TObject; Tag: TTag;
      const TagString: string; TagParams: TStrings; var ReplaceText: string);
    procedure WebFileDispatcher1AfterDispatch(Sender: TObject;
      const AFileName: string; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
    procedure posto_entrarHTMLTag(Sender: TObject; Tag: TTag;
      const TagString: string; TagParams: TStrings; var ReplaceText: string);
    procedure helioHTMLTag(Sender: TObject; Tag: TTag; const TagString: string;
      TagParams: TStrings; var ReplaceText: string);
    procedure WMSiteppHelioAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteppEntrarAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactBuscaRegAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteacDadosUserAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure IdServerIOHandlerSSLOpenSSL1Status(ASender: TObject;
      const AStatus: TIdStatus; const AStatusText: string);
    procedure WMSiteppCadastrarAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteppBuscaDadosReceitaAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactBuscasAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactValidaCodigoAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactUsuariosUpdateSenhaAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactEncripAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactFretesRegistraAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactProdutosRegAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactAtualizaEmpresaAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactExcluiCertificadoEmpresaAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSitectestatusAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactGetItemsConfigAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactEnviarCteAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactCteDownloadAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactMdfeConsultaAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactCteCancelaAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactCteEmailAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteppCteCorrecaoEnviarAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactMdfeRegistraAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactMdfeStatusAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactMdfeEnviarAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactMdfeDownloadAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteWebActionItem1Action(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactMdfeEmailAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactEmpresaLogoAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactMdfeEncerrarAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactUsuarioRegistrarAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactEmpresaPerfilAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactClientesRegistrarAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactProprietarioRegistrarAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactFretesContratoAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactRecuperarSenhaAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSiterecuperarsenhavalidatokenAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactAlterarSenhaAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactConfiguracoesSeguradorasAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactConfiguracoesSeguradorasBuscaAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactMdfeDownloadEncerramentoAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactEnviaSeguroAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure HTTPRIO1AfterExecute(const MethodName: string;
      SOAPResponse: TStream);
    procedure WMSiteactMdfeSeguroEnviarAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactCteSeguroAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactCteSeguroCancelarAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactFretesImportarXMLAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactEmpresaPlanoAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactAmigoAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactTesteAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactImprimindoCartaAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactVeiculosRegistrarAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactMdfeConsultaGetAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactCteConsultaSefazAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactRelCadClientesAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WMSiteactRelOperAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);

  private
    { Private declarations }
    FServerFunctionInvokerAction: TWebActionItem;
    function AllowServerFunctionInvoker: Boolean;

    function ValorSQL(sVlr: String): String;

    function CriaHash(cStr:String):string;
    function LoadHtml(cFile:String):String;

    function LocalizaEmp(qUSU:TSQLQuery;sTic:String):ShortString;
    function CarregaInicio():STring;
    function RestritoPageEmpresa(aDado:TArray<String>;cHtml:String;cMenu:string):String;
    function RestritoPageMotorista(aDado:TArray<String>;cHtml:String;cMenu:string):String;
    function PaginaPadrao(cHtml:String):String;
    function PrimeiroDiaMes(sData:String):String;
  public
    { Public declarations }

    var
       sql:String;
  end;
  function Encrip(cStr: AnsiString):String;
  function Decrip(cStr: AnsiString):String;
  function EnDeCrypt(const Value : String) : String;
  function iif(lCond:Boolean; cStr1,cStr2 : String):String;
  function ValorSQL(sVlr:String):String;
  function ValorSQL2(sVlr:String):String;
  function ValorSQL3(sVlr:String):String;
  function NumeroInicio(sText:String):String;
  function GetRandomPassword(qREG:TSQLQuery;Size: Integer;sTip:string): String;
  function GetRandomNumber(Size:Integer):string;
  function TemSQL(Tags:TStrings):Boolean;
  function TemSQL2(aDado:TArray<String>):Boolean;
  function FormataFone(cp:String):String;
  function FormataStatus(sStat,sTp:String):String;
  function ModalMessage(cNome,cTit,cClass,cMsg:String;tipo:Char='N'):String;
  function ContReg(qREG:TSQLQuery):Integer;
  function ModalLog(cTit:String):String;
  function StrToNumF(sText:String = ''):Double;
  function StrToNumI(sText:String = ''):Integer;
  function LoadHtml(cFile: String): WideString;
  function FormataDataFile(sDat:String;dNova:Boolean):String;
  function FormataDataSQL(sDat:String):String;
  function FormataPlaca(vr: String): String;
  function TemExtensao(cDir,cFile:String):String;
  function TemSQLApp(aDado:TArray<String>):Boolean;
  function BotaoImprimir():String;
  function CabecalhoImpressao(cTit,cCnpj,cNome,cDI,cDF:String):String;
  function TiraAcentos(sPl:String):String;
  function SubstituiEnterBr(sStr:String):string;
  function PrimeiroNome(sStr:String):String;
  function LocalizaUsu(qUSU:TSQLQuery;sToken:String):ShortString;
  function GeraLogTab(tab,tipo,codigo:String):String;
  function GetRandomId(cTip:String;Size:Integer):String;
  function MensagemErroServer():string;
  function MensagemErroLimite():String;
  function ValidaJSONObject(sJson:String):Boolean;
  function GetTokenBearer(sToken:String):String;
  function GeraJSONStr(qSQL:TSQLQuery;sOper:String = '';isJsonMin: Boolean = false):String;
  function GetValueJSONObject(cCampo:String;oJSON:TJSONObject):string;
  function GetValueJSONNull(cCampo:String;oJSON:TJSONObject):string;
  function GetValueAsString(jsonObj: TJSONObject; const propertyName: string): string;
  function IsDigit(st:String):Boolean;
  function StrIn(v:Array of String; s:String):integer;
  function ValidaDataStr(sData:String):Boolean;
  function MD5(texto:string):string;
  function ExecutaSQL(Params:TStrings;oBody:TJSONObject;cDB:TSQLConnection):String;
  function TemDeleteSQL(cStr:String):Boolean;
  function ValidaCNPJ(CNPJ:String):boolean;
  function ValidaCPF(CPF:String):Boolean;
  function ValidaCPFCNPJ(sText:String):Boolean;
  function GeraNumRand(iMax : Integer):String;
  function GetRandomPasswordSite(Size: Integer): String;
  function QuotedCopy(cStr:String;iLen:Integer):String;
  function QuotedJSON(cCamp:String;oJSON:TJSONObject):String;
  function JSONIsNull(cCamp:String;oJSON:TJSONObject):Boolean;
  function validaCertificado(cFile:string):boolean;
  function StrInArray(Str : String; const lista : Array of string) : Boolean;
  function GetCFOPNome(cfopCode: Integer): string;
  function CidadeIBGE(cCidade,cEstado:String;qAUX:TSQLQuery):String;
  function Divide(nFlo1:Double;nFlo2:Double):Double;
  function TrataMensagemExcept(cExcept:String):String;
  function HashMD5(cStr: String): string;
  function SQLInteger(cSQL:String;qSTRING:TSQLQuery):Integer;
  function ContaReg(qAUX:TSQLQuery):Integer;
  function DigitoVerificador(Numero: Integer): Integer;
  function validaImagem(cFile:string):boolean;
  function QuotedSan(cStr:String):String;
  function TrataNumStr(cNum:String):String;
  function RemoveQuebrasDeTexto(cTexto:String):String;
  function EnviaCTeATM(nCod: Integer;qATM:TSQLQuery;cOp:String = 'E'):string;
  function EnviaMDFeATM(nCod: Integer;qATM:TSQLQuery;cOp:String = 'E'):string;
  function TrataExecept(cEx:String):String;
  function ValidaXML(const xmlText: string): Boolean;
  function FormataCep(vr:String):String;
  function VerificaLimiteEmissoes(qUSU:TSQLQuery):Boolean;
  function PegaDataHoraPorEstado(cUf:String):TDateTime;
  function AmbienteTeste():Boolean;
  function CampoXML(cXML, cCP: String): String;

  procedure GravaLog(cErro:String);
  procedure ConfiguraConexao(cCnpjPar:String;cDB:TSQLConnection);
  procedure Base64FileDecode(sBase64,sNome,sTipo:string);
  procedure AddCampo(qSQL:TSQLQuery;oJs:TJSONObject);
  procedure ConfConexao(cn:TSQLConnection);
  procedure ExcluirArquivos(cName:String);
  procedure Commita(qREG:TSQLQuery);


  var
  WebModuleClass: TComponentClass = TWMSite;
  fPath:String;
  setPar: TFormatSettings;
  cErroGS:String; //erro gravando serviço
  sql : String;
  ACBRHerd: TACBrCTe;
  HTTPRIO_WEB: THTTPRIO;
  URL_API : String;


implementation

{$R *.dfm}

uses uServerMethods, uServerContainer, Web.WebReq , uEmpresas, uBuscas, uFretes,
  uProdutos, uCTe, uMdfe, uUsuarios, uClientes, uProprietarios, uConfiguracoes,averbaAtm,
  uVeiculos, uRelatoriosCadastrais;


function EnDeCrypt(const Value : String) : String;
var
  CharIndex : integer;
begin
  Result := Value;
  for CharIndex := 1 to Length(Value) do
    Result[CharIndex] := chr(not(ord(Value[CharIndex])));
end;

function Encrip(cStr: AnsiString):String;
var a : Integer;
    c1: AnsiString;
    c2: AnsiString;
    sC: AnsiString;
    sN: AnsiString;
Begin
   sC := 'MNRTYWOKUVBAQPISDLJGHZXVCWYGFKAXO';
   sN := '';
   For a:=1 to Length(cStr) do begin
       c1 := Copy(cStr,a,1);
       c2 := Copy(sC,a,1);
       sN := sN+AnsiChar(Ord(c1[1])+Ord(c2[1]));
   End;
   result := sN
End;

function Decrip(cStr: AnsiString):String;
var a : Integer;
    c1: AnsiString;
    c2: AnsiString;
    sC: AnsiString;
    sN: AnsiString;
Begin
   sC := 'MNRTYWOKUVBAQPISDLJGHZXVCWYGFKAXO';
   sN := '';
   For a:=1 to Length(cStr) do begin
       c1 := Copy(cStr,a,1);
       c2 := Copy(sC,a,1);
       sN := sN+Chr(Ord(c1[1])-Ord(c2[1]));
   End;
   result := sN
End;

function ValorSQL(sVlr:String):String;
var
  sV : String;
  nL : Integer;
begin
    sV := '';
    For nL := 1 to Length(sVlr) do begin
       if Pos(sVlr[nL],'0123456789')<>0 then
          sV := sV + sVlr[nL];
       if sVlr[nL]=',' then
          sV := sV+'.';
    End;
    if sV ='' then result := '0.00'
    else result := sV;
end;

function CampoXML(cXML, cCP: String): String;
var nP1,nP2 : Integer;
begin
   nP1 := Pos('<'+cCP+'>',cXML);
   nP2 := Pos('</'+cCP+'>',cXML);
   result := '';
   if (nP1<>0) and (nP2<>0) then begin
      nP1 := nP1+Length(cCP)+2;
      result := copy(cXML,nP1,nP2-nP1);
   end;
end;


function ValorSQL3(sVlr:String):String;
var
  sV : String;
  nL : Integer;
begin
    sV := '';
    For nL := 1 to Length(sVlr) do begin
       if Pos(sVlr[nL],'0123456789')<>0 then
          sV := sV + sVlr[nL]
       else if sVlr[nL]=',' then
          sV := sV+'.'
       else
          sV := sV + sVlr[nL];
    End;
    if sV ='' then result := '0.00'
    else result := sV;
end;


function iif(lCond: Boolean; cStr1, cStr2: String): String;
Begin
   if lCond then
      result := cStr1
   Else
      result := cStr2;
end;

function NumeroInicio(sText:String):String;
var
  sV : String;
  nL : Integer;
begin
    sV := '';
    nL := 1;
    while Pos(copy(sText,nL,1),'0123456789')>0 do begin
       sV := sV + Copy(sText,nL,1);
       nL := nL+1;
    end;
    result := sV;
end;





function TWMSite.CarregaInicio: STring;
begin
   result:='<script type="Text/JavaScript">window.location.href="/"</script>';
end;

procedure ConfConexao(cn: TSQLConnection);
begin
   cn.LoadParamsOnConnect:=false;
   cn.ConnectionName:= 'FBConnection';
   cn.DriverName    := 'Firebird';
   cn.LibraryName   := 'dbxfb.dll';
   cn.VendorLib     := 'fbclient.dll';
   cn.Params.Values['Database']  := frmPrin.dbBan;
   cn.Params.Values['User_Name'] := frmPrin.dbUsu;
   cn.Params.Values['Password']  := frmPrin.dbSen;
   cn.Params.Values['IsolationLevel']  := 'ReadCommited';
   cn.LoginPrompt := False;
end;


procedure TWMSite.contatoHTMLTag(Sender: TObject; Tag: TTag;
  const TagString: string; TagParams: TStrings; var ReplaceText: string);
var cPg:String;
    aDado: TArray<String>;
    qREG:TSQLQuery;
begin

   cPg:='oi';
   ReplaceText := cPg;
   Response;

end;

function TWMSite.CriaHash(cStr: String): string;
var
 idMd5:TIdHashMessageDigest5;
begin
  idMd5:=TIdHashMessageDigest5.Create;
  try
    result:=idMd5.HashStringAsHex(cStr+'rciachave');
  finally
    idMd5.Free;
  end;
end;

procedure TWMSite.IdServerIOHandlerSSLOpenSSL1Status(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: string);
begin
  GravaLog('Cert:'+AStatusText);
end;

procedure TWMSite.IndexHTMLTag(Sender: TObject; Tag: TTag;
  const TagString: string; TagParams: TStrings; var ReplaceText: string);
begin
   ReplaceText := '<HTML>R & Cia Sistemas<br><b>oi</b></HTML>';
   Response;
end;


function TWMSite.LoadHtml(cFile: String): String;
var lsFile:TStringList;
begin
   try
     lsFile:=TStringList.Create;
     try
        lsFile.LoadFromFile(cFile);
        result := lsFile.Text;
     finally
        lsFile.Free;
     end;
   except on e : exception do
     result := 'Erro na leitura do arquivo<br>'+e.message;
  end;
end;




procedure TWMSite.ServerFunctionInvokerHTMLTag(Sender: TObject; Tag: TTag;
  const TagString: string; TagParams: TStrings; var ReplaceText: string);
begin
  if SameText(TagString, 'urlpath') then
    ReplaceText := string(Request.InternalScriptName)
  else if SameText(TagString, 'port') then
    ReplaceText := IntToStr(Request.ServerPort)
  else if SameText(TagString, 'host') then
    ReplaceText := string(Request.Host)
  else if SameText(TagString, 'classname') then
    ReplaceText := uServerMethods.TServerMethods1.ClassName
  else if SameText(TagString, 'loginrequired') then
    if DSHTTPWebDispatcher1.AuthenticationManager <> nil then
      ReplaceText := 'true'
    else
      ReplaceText := 'false'
  else if SameText(TagString, 'serverfunctionsjs') then
    ReplaceText := string(Request.InternalScriptName) + '/js/serverfunctions.js'
  else if SameText(TagString, 'servertime') then
    ReplaceText := DateTimeToStr(Now)
  else if SameText(TagString, 'serverfunctioninvoker') then
    if AllowServerFunctionInvoker then
      ReplaceText :=
      '<div><a href="' + string(Request.InternalScriptName) +
      '/ServerFunctionInvoker" target="_blank">Server Functions</a></div>'
    else
      ReplaceText := '';
end;


function TWMSite.ValorSQL(sVlr: String): String;
begin

end;

procedure TWMSite.WebModuleDefaultAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var cPg:String;
begin
   Response.Content    :='não encontrado';
   Response.StatusCode := 404;
end;

procedure TWMSite.WMSiteppHelioAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
begin
   Response.Content    := Request.Content;
   Response.StatusCode := 200;
end;


procedure TWMSite.WebModuleBeforeDispatch(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.SetCustomHeader('Access-Control-Allow-Origin','*');
  if Trim(Request.GetFieldByName('Access-Control-Request-Headers')) <> '' then begin
     Response.SetCustomHeader('Access-Control-Allow-Headers', Request.GetFieldByName('Access-Control-Request-Headers'));
     Handled := True;
  end;

  if FServerFunctionInvokerAction <> nil then
    FServerFunctionInvokerAction.Enabled := AllowServerFunctionInvoker;
end;



function TWMSite.AllowServerFunctionInvoker: Boolean;
begin
  Result := (Request.RemoteAddr = '127.0.0.1') or (Request.RemoteAddr = '0:0:0:0:0:0:0:1') or (Request.RemoteAddr = '::1');
end;

procedure TWMSite.WebFileDispatcher1AfterDispatch(Sender: TObject;
  const AFileName: string; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
   cToken,cHash : String;
begin
  {
   if(Pos('\clientes\CTe\',AFileName)<>0) or (Pos('\clientes\MDFe\',AFileName)<>0)then begin
      cToken := Request.QueryFields.Values['client'];
      cHash  := Request.QueryFields.Values['hash'];

      if(hashMD5(ExtractFileName(AFileName)+cToken)<>cHash)then begin
         Response.StatusCode := 401;
         Response.Content := 'Sem permissão';
      end;
   end;
   }
end;

procedure TWMSite.WebFileDispatcher1BeforeDispatch(Sender: TObject;
  const AFileName: string; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  D1, D2: TDateTime;
begin
  Handled := False;
  if SameFileName(ExtractFileName(AFileName), 'serverfunctions.js') then
    if not FileExists(AFileName) or (FileAge(AFileName, D1) and FileAge(WebApplicationFileName, D2) and (D1 < D2)) then
    begin
      DSProxyGenerator1.TargetDirectory := ExtractFilePath(AFileName);
      DSProxyGenerator1.TargetUnitName := ExtractFileName(AFileName);
      DSProxyGenerator1.Write;
    end;
end;

procedure TWMSite.WebModuleCreate(Sender: TObject);
var Ini : TIniFile;
begin
  FServerFunctionInvokerAction := ActionByName('ServerFunctionInvokerAction');
  DSHTTPWebDispatcher1.Server := DSServer;

  if DSServer.Started then begin
    DSHTTPWebDispatcher1.DbxContext := DSServer.DbxContext;
    DSHTTPWebDispatcher1.Start;
  end;

  setPar.DateSeparator := '/';
  setPar.ShortDateFormat := 'dd/mm/yy';
  setPar.DecimalSeparator := ',';
  setPar.ThousandSeparator := '.';
  setPar.TimeSeparator := ':';

  URL_API := 'https://api-sistema.sigetran.com.br/';
  if AmbienteTeste() then
     URL_API := 'http://10.1.1.6:'+frmPrin.EditPort.Text+'/';



end;


function GetRandomPasswordSite(Size: Integer): String;
var
  I: Integer;
  fim : Boolean;
const
  str1 = '1234567890abcdefghijklmnopqrstuvwxyz';
begin
  Result := '';
  fim := false;
  for I := 1 to Size do
      Result:=Result+str1[Random(Length(str1)) + 1];
end;


procedure TWMSite.helioHTMLTag(Sender: TObject; Tag: TTag;
  const TagString: string; TagParams: TStrings; var ReplaceText: string);
begin
      ReplaceText := 'Ola helio';

end;
procedure TWMSite.HTTPRIO1AfterExecute(const MethodName: string;
  SOAPResponse: TStream);
var
   ms : TMemoryStream;
begin
   ms := TMemoryStream.Create;
   try
     ms.LoadFromStream(SoapResponse);
     ms.SaveToFile('a.xml');
   finally
     ms.Free;
   end;
end;

//
//procedure TWMSite.HTTPRIO2AfterExecute(const MethodName: string;
//  SOAPResponse: TStream);
//var
//   ms : TMemoryStream;
//begin
//   ms := TMemoryStream.Create;
//   try
//     ms.LoadFromStream(SoapResponse);
//     ms.SaveToFile('a.xml');
//   finally
//     ms.Free;
//   end;
//end;

procedure GravaLog(cErro: String);
var Log: textFile;
begin
   AssignFile(Log, 'dsError.log');
   try
      if not(FileExists('dsError.log')) then
         Rewrite(Log)
      else
         Append(Log);
      Writeln(Log, FormatDateTime('dd/mm/yyyy hh:MM:ss',now)+' '+cErro);
   finally
      CloseFile(Log);
   end;
end;




function TWMSite.PrimeiroDiaMes(sData: String): String;
begin
//   GravaLog(copy(sData,9,2));
   result:='01/'+Copy(sData,6,2)+'/'+Copy(sData,1,4);
end;


function GetRandomNumber(Size:Integer):string;
var
  I: Integer;
  fim : Boolean;
const
  str1 = '1234567890';
begin
  Result := '';
  try
     for I := 1 to Size do
        Result:=Result+str1[Random(Length(str1)) + 1];

  finally
  end;
end;

function GetRandomPassword(qREG:TSQLQuery;Size: Integer;sTip:string): String;
var
  I: Integer;
  fim : Boolean;
const
  str1 = 'token.1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzrcia.';
begin
  Result := '';
  try
     fim := false;
     while not(fim) do begin
        for I := 1 to Size do
            Result:=Result+str1[Random(Length(str1)) + 1];

        // se ja existe não pode
        qREG.Close;
        qREG.SQL.Text:='SELECT CODIGO FROM USUARIOS WHERE TOKEN='+QuotedStr(result);
        qREG.Open;

        fim:=qREG.Eof;
     end;
  finally
  end;
end;

function TWMSite.LocalizaEmp(qUSU: TSQLQuery; sTic: String): ShortString;
var
  cPg:String;
begin
  try
     qUSU.Close;
     qUSU.SQL.Text:='SELECT CODIGO,CNPJ,NOME, '+
     'FANTASIA,CELULAR,TICKET,MENU '+
     'FROM EMPRESAS '+
     'WHERE TICKET='+QuotedStr(sTic)+' AND COALESCE(SITUACAO,'''')<>''B'' ';
     sql:=qUSU.SQL.Text;
     qUSU.SQL.SaveToFile('./auditoria/LOCALIZA.txt');
     qUSU.Open;
   except on E: Exception do
     GravaLog('ERRO AO LOCALIZAR EMPRESA:'+E.Message+' SQL:'+sql);
  end;
end;

function LocalizaUsu(qUSU: TSQLQuery; sToken: String): ShortString;
var
  cPg:String;
begin
   if(sToken <> '')then begin
      qUSU.Close;
      qUSU.SQL.Text := 'SELECT U.*,E.CNPJ,E.RNTRC,'+
      'E.IE,E.FANTASIA,E.ENDERECO AS ENDERECOE,'+
      'E.COMPLEMENTO AS COMPLEMENTOE,E.ESTADO AS ESTADOE,'+
      'E.CIDADE AS CIDADEE,E.CEP AS CEPE,E.BAIRRO AS BAIRROE,'+
      'E.NUMERO AS NUMEROE,E.NOME AS NOMEE,E.TELEFONE,E.REGIME '+
      'FROM USUARIOS U '+
      'LEFT JOIN EMPRESA E ON E.CODIGO=1 '+
      'WHERE U.TOKEN='+QuotedStr(sToken);
      qUSU.Open;

      if(qUSU.Eof)then
         result := '{"erro":99,"mensagem":"Usuário não localizado"}'
      else
         Result := '{'+
              '"erro":"0",'+
              '"mensagem":"Usuário autenticado com sucesso",'+
              '"token":"'+sToken+'",'+
              '"nome":"'+qUSU.FieldByName('NOME').AsString+'",'+
              '"login":"'+qUSU.FieldByName('LOGIN').AsString+'"'+
         '}';
   end else
      result := '{"erro":1,"mensagem":"Não autenticado"}';
end;


function TemSQL(Tags:TStrings):Boolean;
var
  nTg:Integer;
  cTg:String;
begin
  result:=false;
  for nTg := 0 to Tags.Count-1 do begin
     cTg:=UpperCase(Tags.ValueFromIndex[nTg]);
     if((Pos('SELECT ',cTg)<>0) and (Pos('FROM', cTg)<>0)) or
       ((Pos('DELETE ',cTg)<>0) and (Pos('FROM', cTg)<>0)) or
       ((Pos('UPDATE ',cTg)<>0) and (Pos('SET',   cTg)<>0)) or
       ((Pos('INSERT ',cTg)<>0) and (Pos('VALUES',cTg)<>0))then begin
       result:=true;
       exit;
     end;

  end;
end;
function FormataStatus(sStat,sTp:String):String;
begin
   if(sTp='T')then begin
     if(sStat='A')then
       result:='ATIVA'
     else if(sStat='I')then
       result:='INATIVA'
     else if(sStat='B')then
       result:='BLOQUEADA'
     else if(sStat='S')then
       result:='SUSPENSA';

   end;
end;
function FormataOperacao(sOp:String):String;
begin
   if(sOp='I')then
      result:='INCLUSÃO'
   else if(sOp='A')then
      result:='ALTERAÇÃO'
   else if(sOp='E')then
      result:='EXCLUSÃO';

end;
function BtnPrint():String;
begin
  result:='<button type="button" class="btnImp" onClick="printDiv();">IMPRIMIR</button>';
end;
function BtnPrintFix():String;
begin
  result:='<a onClick="printDiv();"><div class="returnTop">'+
  '<div class="returnTopLink"><i class="fas fa-paste"></i></div>'+
  '</div></a>';
end;
function FormataFone(cp:String):String;
begin
   cp:=SoNumero(cp);
   if length(cp)=11 then
      result := FormatMaskText('!(99)00000-0000;0;0',cp)
   else if length(cp)=10 then
      result := FormatMaskText('!(99)0000-0000;0;0',cp)
   else if length(cp)=9 then
      result := FormatMaskText('!00000-0000;0;0',cp)
   else if length(cp)=8 then
      result := FormatMaskText('!0000-0000;0;0',cp)
   else
      result := '';
end;


function ModalMessage(cNome,cTit,cClass,cMsg:String;tipo:Char='N'): String;
begin
   result:=
   '<div class="modal fade" id="'+cNome+'" tabindex="-1" role="dialog">'+
   ' <div class="modal-dialog" role="document">'+
   '   <div class="modal-content">'+
   '     <div class="modal-header">'+
   '       <h5 class="modal-title" id="modaltitle">'+cTit+'</h5>'+
   '       <button type="button" class="close" data-dismiss="modal" aria-label="Close">'+
   '         <span aria-hidden="true">&times;</span>'+
   '       </button>'+
   '     </div>'+
   '     <div class="modal-body" id="modalmsg">'+
   '       <p class="'+cClass+'">'+cMsg+'</p>'+
   '     </div>'+
   '     <div class="modal-footer">'+
   '       <button type="button" class="btn btn-'+iif(tipo='N','primary','danger')+'" data-dismiss="modal">OK</button>'+
   '     </div>'+
   '   </div>'+
   ' </div>'+
   '</div>';

end;

function ModalLog(cTit:String): String;
begin
   result:=
   '<div class="modal fade" id="modalLog" tabindex="-1" role="dialog">'+
   ' <div class="modal-dialog modal-lg" role="document">'+
   '   <div class="modal-content">'+
   '     <div class="modal-header">'+
   '       <h5 class="modal-title" id="modaltitle">'+cTit+'</h5>'+
   '       <button type="button" class="close" data-dismiss="modal" aria-label="Close">'+
   '         <span aria-hidden="true">&times;</span>'+
   '       </button>'+
   '     </div>'+
   '     <div class="modal-body" id="idModLog">'+
   '     </div>'+
   '     <div class="modal-footer">'+
   '       <button type="button" class="btn btn-primary" data-dismiss="modal">OK</button>'+
   '     </div>'+
   '   </div>'+
   ' </div>'+
   '</div>';
end;



function ContReg(qREG:TSQLQuery):Integer;
var nIt:integer;
begin
  nIt:=0;
  qREG.First;
  while not(qREG.Eof) do begin
     inc(nIt);
     qREG.Next;
  end;
  result:=nIt;
end;

function StrToNumI(sText:String = ''):Integer;
var sV : String;
    nL : Word;
begin
    result:=0;
    if (Length(sText)=0) or not(sText[1] in ['0'..'9']) then
       exit;
    for nL := 1 to Length(sText) do begin
       if Pos(Copy(sText,nL,1),'0123456789')<>0 then
          sV := sV + Copy(sText,nL,1);
    End;
    result:=StrToInt('0'+sV);
end;
function StrToNumF(sText:String = ''):Double;
var
  sV : String;
  nL : Integer;
  nVH : Double;
begin
    sText := trim(sText);
    For nL := 1 to Length(sText) do begin
       if Pos(Copy(sText,nL,1),'0123456789,')<>0 then
          sV := sV + Copy(sText,nL,1);
    End;
    nVH := StrToFloat('0'+sV);
    result := nVH;
end;
function LoadHtml(cFile: String): WideString;
var lsFile:TStringList;
begin
   try
     lsFile:=TStringList.Create;
     try
        lsFile.LoadFromFile(cFile);
        //lsFile.Text:=StringReplace(lsFile.Text,sLineBreak,' ',[rfReplaceAll]);
        result := lsFile.Text;
     finally
        lsFile.Free;
     end;
   except on e : exception do
     result := 'Erro na leitura do arquivo<br>'+e.message;
  end;
end;

procedure TWMSite.enviaimgHTMLTag(Sender: TObject; Tag: TTag;
  const TagString: string; TagParams: TStrings; var ReplaceText: string);
var i,j : Integer;
  cPg : String;
  cnt : TSQLConnection;
  TD: TTransactionDesc;
  qUSU : TSQLQuery;
  qLOG : TSQLQuery;
  sql  : String;
  sCNPJ: String;
  cFase: String;
  cDir : String;
  cFile: String;
  aDado : TArray<String>;
  SFile:TSearchRec;
  lsExternalID : String;
  sLog :String;
begin
  sCNPJ:='';
  sql:='';
  cPg:='NAO';
  cFase := 'Inicio';
  cFile:=Request.QueryFields.Values['id'];   // ticket; codigo; tipo;
  aDado:=cFile.Split([';']);

  cnt := TSQLConnection.create(self);
  ConfConexao(cnt);
  qUSU:= TSQLQuery.Create(self);
  qUSU.SQLConnection:=cnt;
  qLOG:= TSQLQuery.Create(self);
  qLOG.SQLConnection:=cnt;

  TD.TransactionID := TDSSessionManager.GetThreadSession.Id;
  TD.IsolationLevel := xilREADCOMMITTED;
  cnt.StartTransaction(TD);
  try
    try
//                     tick           nomefile       tipo           cod.lan        numero da img
//      qUSU.SQL.Text:= aDado[0]+' | '+ aDado[1]+' | '+aDado[2]+' | '+aDado[3]+' | '+aDado[4];
//      qUSU.SQL.SaveToFile('parimg.txt');

      cPg:='';
      LocalizaUsu(qUSU,aDado[0]);
      if qUSU.eof then
         raise Exception.Create('Usuario não localizado ao receber imagem '+aDado[0]);
      sCNPJ:=trim(qUSU.FieldByname('CNPJ').AsString+' ');

      // define pasta
      if aDado[2]='_DOC' then
         cDir  :='.\doc\'+FormatDateTime('yyyymm',qUSU.FieldByName('HOJE').AsDateTime)
      else if aDado[1]='_REL' then
         cDir  :='.\rel\';
//         cDir  :='htdocs\ins';

      if not(DirectoryExists(cDir)) then
         ForceDirectories(cDir);

      // se ultimo parametro for L, é pra limpar as imagens que existem
      cFase := 'Limpar';
      if (length(aDado)>3) and (aDado[3]='L') then begin
         cFile :=cDir+'\ARQ'+aDado[1]+aDado[2];
         j := FindFirst(cFile+'*.*', faAnyFile, SFile);
         while j = 0 do begin
            if ((SFile.Attr and faDirectory) <> faDirectory) then
               DeleteFile(PChar(cDir+'\'+SFile.Name));
            j := FindNext(SFile);
         end;
         System.SysUtils.FindClose(SFile);
         exit;
      end else begin

         with TMultipartContentParser.Create(Request) do begin
           for i := 0 to Request.Files.Count -1 do begin
             if(aDado[2]='_DOC')then
                cFile :=cDir+'\ARQ'+aDado[1]+aDado[2]+'-'+aDado[3]+ExtractFileExt(Request.Files[i].FileName)
             else if(aDado[1]='_REL')then begin
                cFile :='REL'+SoNumero(qUSU.FieldBYName('CNPJ').AsString);
                cFile := TemExtensao(cDir,cFile);
                if(cFile<>'')then
                  DeleteFile(PChar(cDir+cFile));

                cFile :=cDir+'REL'+SoNumero(qUSU.FieldBYName('CNPJ').AsString)+ExtractFileExt(Request.Files[i].FileName);

             end;
//             if((aDado[2]='_FRETE')OR(aDado[2]='_FROTA')OR(aDado[2]='_CHAMADO'))then
//                cFile :=cDir+'\'+aDado[1]+'-'+aDado[3]+ExtractFileExt(Request.Files[i].FileName);
            if not(DirectoryExists(cDir)) then
               ForceDirectories(cDir);
             TMemoryStream(Request.Files[i].Stream).SaveToFile(cFile);
           end;
           cPg:='<SIM>';
           Free;
         end;

      end;
    except on e : exception do begin
      cPg:='ERRO';
      GravaLog('Erro Recebendo imagem:'+e.message);
     end;
    end;
  finally
    //lsCn.SaveToFile('htdocs\files.txt');
    if cnt.inTransaction then
       cnt.Commit(TD);
    FreeAndNil(qUSU);
    FreeAndNil(qLOG);
    FreeAndNil(cnt);

  end;
  ReplaceText := cPg;
  Response;

end;


function FormataDataFile(sDat:String;dNova:Boolean):String;
begin
  result := copy(sDat,3,2)+Copy(sDat,6,2)+Copy(sDat,9,2)+
            copy(sDat,12,12);
  result := StringReplace(result,':','',[rfReplaceAll]);
  if not(dNova) then
     result:=copy(result,1,12);
end;
function FormataDataSQL(sDat:String):String;
begin
  result := copy(sDat,9,2)+'.'+Copy(sDat,6,2)+'.'+Copy(sDat,1,4)+
            ' '+copy(sDat,12,12);
end;


function TemExtensao(cDir,cFile:String):String;
begin
   if FileExists(cDir+cFile+'.png') then
      result:=cFile+'.png'
   else if FileExists(cDir+cFile+'.pdf') then
      result:=cFile+'.pdf'
   else if FileExists(cDir+cFile+'.jpg') then
      result:=cFile+'.jpg'
   else if FileExists(cDir+cFile+'.jpeg') then
      result:=cFile+'.jpeg'
   else if FileExists(cDir+cFile+'.tif') then
      result:=cFile+'.tif'
   else if FileExists(cDir+cFile+'.tiff') then
      result:=cFile+'.tif'
   else if FileExists(cDir+cFile+'.bmp') then
      result:=cFile+'.bmp'
   else
      result := '';
end;

function AlertSuspenso(cMsg,cTipo:String;iTemp:Integer):String;
begin
   result:='<script type="text/javascript">'+
   'var mensagem = "<strong>'+cMsg+'</strong><br>"; '+
   'mostraDialogo(mensagem, "'+cTipo+'", '+IntToStr(iTemp)+') </script>';
end;

function TemSQL2(aDado:TArray<String>):Boolean;
var
  nTg:Integer;
  cTg:String;
begin
  result:=false;
  for nTg := 0 to Length(aDado)-1 do begin
     cTg:=UpperCase(aDado[ntg]);
     if((Pos('SELECT ',cTg)<>0) and (Pos('FROM', cTg)<>0)) or
       ((Pos('DELETE ',cTg)<>0) and (Pos('FROM', cTg)<>0)) or
       ((Pos('UPDATE ',cTg)<>0) and (Pos('SET',   cTg)<>0)) or
       ((Pos('INSERT ',cTg)<>0) and (Pos('VALUES',cTg)<>0))then begin
       result:=true;
       exit;
     end;

  end;
end;
function TemSQLApp(aDado:TArray<String>):Boolean;
var
  nTg:Integer;
  cTg:String;
begin
  result:=false;
  for nTg := 0 to Length(aDado)-1 do begin
     cTg:=UpperCase(aDado[ntg]);
     if((Pos('DELETE ',cTg)<>0) and (Pos('FROM', cTg)<>0)) or
       ((Pos('UPDATE ',cTg)<>0) and (Pos('SET',   cTg)<>0)) or
       ((Pos('INSERT ',cTg)<>0) and (Pos('VALUES',cTg)<>0))then begin
       result:=true;
       exit;
     end;

  end;
end;
procedure AddCampo(qSQL: TSQLQuery; oJs: TJSONObject);
var nF: Integer;
    cp: String;
begin
   //ROTINA ALTERADA PARA SE ADAPTAR AO APP DO CAIO
   for nF := 0 to qSQL.FieldCount-1 do begin
       cp:=qSQL.Fields[nF].FieldName;
       if qSQL.Fields[nF].DataType in [ftInteger,ftSmallint,ftFLoat,ftBCD,ftFMTBCD] then begin
          if(Copy(qSQL.Fields[nf].FieldName,1,3)='LAT')OR(Copy(qSQL.Fields[nf].FieldName,1,3)='LNG')then
             oJs.AddPair(qSQL.Fields[nF].FieldName,qSQL.FieldByName(qSQL.Fields[nF].FieldName).AsString)
          else
             oJs.AddPair(qSQL.Fields[nF].FieldName,ValorSQL(qSQL.FieldByName(qSQL.Fields[nF].FieldName).AsString));
       end else if qSQL.Fields[nF].DataType=ftWideMemo then
          oJs.AddPair(qSQL.Fields[nF].FieldName,' ')
       else if qSQL.Fields[nF].DataType=ftMemo then
          if qSQL.FieldByName(qSQL.Fields[nF].FieldName).IsNull then
             ojs.AddPair(qSQL.Fields[nF].FieldName,' ')
          else
             oJs.AddPair(qSQL.Fields[nF].FieldName,qSQL.FieldByName(qSQL.Fields[nF].FieldName).Value)
       else
          oJs.AddPair(qSQL.Fields[nF].FieldName,qSQL.FieldByName(qSQL.Fields[nF].FieldName).AsString);
   end;
end;
function BotaoImprimir: String;
begin
   result:='<a onClick="printDiv();"><div class="returnTop">'+
           '<div class="returnTopLink"><i class="fas fa-paste"></i></div>'+
           '</div></a>';
end;

function CabecalhoImpressao(cTit,cCnpj,cNome,cDI,cDF:String):String;
var
  cDir,cFile,cSrc:String;
begin
   cDir:='.\rel\';
   cFile:='REL'+SoNUmero(cCnpj);
   cFile:=TemExtensao(cDir,cFile);
   if(FileExists(cDir+cFile))then
     cSrc:=' <img src="/rel/'+cFile+'" id="imgPrint"  style="width: 60px;height: 60px;"/>'
   else
     cSrc:=' <img src="/assets/images/logo.png" id="imgPrint"  style="width: 60px;height: 60px;"/>';

   result:=
      '<div class="col-12 col-md-12 text-center row m-0 p-0 pb-2 pt-2">'+
      ' <div class="col-3 text-left">'+cSrc+' </div>'+
      ' <div class="col-6 text-left">'+
      ' <span class="titRel">'+cTit+'</span><br/>'+
      ' <span class="titRel2">'+cCnpj+' '+cNome+'</span>'+
      ' </div>'+
      ' <div class="col-3 text-right text-white">';
   if(cDI<>'')and(cDF<>'')then
     result:=result+'Data Ini:'+FormatDateTime('dd/mm/yyyy',StrToDateTime(cDI))+'<br/>'+
             'Data Fin:'+FormatDateTime('dd/mm/yyyy',StrToDateTime(cDF));

   result:=result+
      '</div>'+
      '</div>';
end;

procedure Base64FileDecode(sBase64,sNome,sTipo:string);
var
  BStream: TBytesStream;
begin
   BStream:= TBytesStream.Create(TNetEncoding.Base64.DecodeStringToBytes(sBase64));
  try
    BStream.SaveToFile(sNome+'.'+sTipo);
  finally
    BStream.Free;
  end;
end;


function ValorSQL2(sVlr:String):String;
var
  sV : String;
  nL : Integer;
begin
    sV := '';
    For nL := 1 to Length(sVlr) do begin
       if Pos(sVlr[nL],'0123456789')<>0 then
          sV := sV + sVlr[nL];
       if sVlr[nL]=',' then
          sV := sV+'.';
    End;
    if sV='' then
       result := '0.00'
    else begin
       if Pos('.',sV)<=0 then
          sV:=sV+'.00';
       result := sV;
    end;
end;

function TWMSite.RestritoPageEmpresa(aDado:TArray<String>;cHtml: String;cMenu:String): String;
var
  cPg:String;
  qUSU,qAUX:TSQLQuery;
  cDB:TSQLConnection;
begin
   cDB := TSQLConnection.create(self);
   ConfConexao(cDB);
   qUSU:= TSQLQuery.Create(self);
   qUSU.SQLConnection:=cDB;
   qAUX:= TSQLQuery.Create(self);
   qAUX.SQLConnection:=cDB;
   LocalizaEmp(qUSU,aDado[0]);
   try
      cPg:='';
      //header
      cPg:='<!DOCTYPE html>'+
           '<html lang="pt">'+
           '<head>'+
           ' <meta charset="utf-8" />'+
           ' <meta http-equiv="X-UA-Compatible" content="IE=edge" />'+
           ' <meta charset="utf-8" />'+
           ' <meta name="viewport" content="width=device-width,initial-scale=1" />'+
           ' <title>Empresa - Restrito</title>'+
           '<link rel="shortcut icon" href="./assets/images/logo.png" />'+
//           ' <script src="https://kit.fontawesome.com/309f181209.js" crossorigin="anonymous"></script>'+
           ' <link href="./assets/vendor/owl-carousel/owl.carousel.css" rel="stylesheet" />'+
           ' <link href="./assets/css/style-empresa.css" rel="stylesheet" />'+
           ' <link href="./assets/css/style-pages.css" rel="stylesheet" />'+
           '<link href="./assets/fontawesome/css/all.css" rel="stylesheet">'+

           '</head>';

      //preloader
      cPg:=cPg+
           '<body>'+
           ' <div id="preloader">'+
           ' <div class="sk-three-bounce">'+
           ' <div class="sk-child sk-bounce1"></div>'+
           ' <div class="sk-child sk-bounce2"></div>'+
           ' <div class="sk-child sk-bounce3"></div>'+
           ' </div>'+
           '</div>';

      //main wrapper
      cPg:=cPg+
           '<div id="main-wrapper">'+
           '<!-- Cabecalho -->'+
           ' <div class="nav-header">'+
           '  <a href="/restrito-empresas?id='+aDado[0]+'" class="brand-logo">'+
           '   <img src="./assets/images/logo.png" style="width:50px;height:50px"/>'+
           '   <span class="brand-title text-dark">'+
           '    Aproms Fretes'+
           '   </span>'+
           '  </a>'+
           '  <div class="nav-control">'+
           '   <div class="hamburger">'+
           '   <span class="line"></span>'+
           '   <span class="line"></span>'+
           '   <span class="line"></span>'+
           '  </div>'+
           ' </div>'+
           '</div>';

       //header
       cPg:=cPg+
            '<div class="header">'+
            ' <div class="header-content">'+
            '  <nav class="navbar navbar-expand">'+
            '   <div class="collapse navbar-collapse justify-content-between">'+
            '    <div class="header-left"></div>'+
            '    <ul class="navbar-nav header-right main-notification">'+
            '    <li class="nav-item dropdown notification_dropdown">'+
            '     <a class="nav-link bell dz-theme-mode" href="#">'+
            '       <i id="icon-light" class="fa fa-sun-o"></i>'+
            '       <i id="icon-dark" class="fa fa-moon-o"></i>'+
            '     </a>'+
            '    </li>'+
            '   <li class="nav-item dropdown notification_dropdown">'+
            '    <a class="nav-link bell dz-fullscreen" href="#">'+
            '     <svg id="icon-full" viewbox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round" class="css-i6dzq1">'+
            '      <path d="M8 3H5a2 2 0 0 0-2 2v3m18 0V5a2 2 0 0 0-2-2h-3m0 18h3a2 2 0 0 0 2-2v-3M3 16v3a2 2 0 0 0 2 2h3" style="stroke-dasharray: 37, 57; stroke-dashoffset: 0;"></path>'+
            '     </svg>'+
            '     <svg id="icon-minimize" width="20" height="20" viewbox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-minimize">'+
            '      <path d="M8 3v3a2 2 0 0 1-2 2H3m18 0h-3a2 2 0 0 1-2-2V3m0 18v-3a2 2 0 0 1 2-2h3M3 16h3a2 2 0 0 1 2 2v3" style="stroke-dasharray: 37, 57; stroke-dashoffset: 0;"></path>'+
            '     </svg>'+
            '    </a>'+
            '   </li>'+
            '   <li class="nav-item dropdown notification_dropdown">'+
            '    <a class="nav-link ai-icon" href="javascript:void(0)" role="button" data-toggle="dropdown">'+
            '     <svg class="bell-icon" width="24" height="24" viewbox="0 0 28 28" fill="none" xmlns="http://www.w3.org/2000/svg">'+
            '      <path d="M22.75 15.8385V13.0463C22.7471 10.8855 21.9385 8.80353 20.4821 7.20735C19.0258 5.61116 17.0264 4.61555 14.875 4.41516V2.625C14.875 2.39294 14.7828 2.17038 14.6187 2.00628C14.4546 1.84219 '+
            '       14.2321 1.75 14 1.75C13.7679 1.75 13.5454 1.84219 13.3813 2.00628C13.2172 2.17038 13.125 2.39294 13.125 2.625V4.41534C10.9736 4.61572 8.97429 5.61131 7.51794 7.20746C6.06159 8.80361 5.25291 10.8855 '+
            '       5.25 13.0463V15.8383C4.26257 16.0412 3.37529 16.5784 2.73774 17.3593C2.10019 18.1401 1.75134 19.1169 1.75 20.125C1.75076 20.821 2.02757 21.4882 2.51969 21.9803C3.01181 22.4724 3.67904 22.7492 4.375 '+
            '       22.75H9.71346C9.91521 23.738 10.452 24.6259 11.2331 25.2636C12.0142 25.9013 12.9916 26.2497 14 26.2497C15.0084 26.2497 15.9858 25.9013 16.7669 25.2636C17.548 24.6259 18.0848 23.738 18.2865 22.75H23.625C24.321 '+
            '       22.7492 24.9882 22.4724 25.4803 21.9803C25.9724 21.4882 26.2492 20.821 26.25 20.125C26.2486 19.117 25.8998 18.1402 25.2622 17.3594C24.6247 16.5786 23.7374 16.0414 22.75 15.8385ZM7 13.0463C7.00232 11.2113 7.73226 '+
            '       9.45223 9.02974 8.15474C10.3272 6.85726 12.0863 6.12732 13.9212 6.125H14.0788C15.9137 6.12732 17.6728 6.85726 18.9703 8.15474C20.2677 9.45223 20.9977 11.2113 21 13.0463V15.75H7V13.0463ZM14 24.5C13.4589 24.4983 '+
            '       12.9316 24.3292 12.4905 24.0159C12.0493 23.7026 11.716 23.2604 11.5363 22.75H16.4637C16.284 23.2604 15.9507 23.7026 15.5095 24.0159C15.0684 24.3292 14.5411 24.4983 14 24.5ZM23.625 21H4.375C4.14298 20.9999 3.9205 '+
            '       20.9076 3.75644 20.7436C3.59237 20.5795 3.50014 20.357 3.5 20.125C3.50076 19.429 3.77757 18.7618 4.26969 18.2697C4.76181 17.7776 5.42904 17.5008 6.125 17.5H21.875C22.571 17.5008 23.2382 17.7776 23.7303 18.2697C24.2224 '+
            '       18.7618 24.4992 19.429 24.5 20.125C24.4999 20.357 24.4076 20.5795 24.2436 20.7436C24.0795 20.9076 23.857 20.9999 23.625 21Z"fill="#EB8153"></path>'+
            '     </svg>'+
            '     <div class="pulse-css"></div>'+
            '    </a>'+
            '    <div class="dropdown-menu dropdown-menu-right">'+
            '     <div id="dlab_W_Notification1" class="widget-media dz-scroll p-3 height380">'+
            '      <ul class="timeline">'+
            '       <li>'+
            '        <div class="timeline-panel">'+
            '         <div class="media mr-2">'+
            '          <img alt="image" width="50" src="images/avatar/1.jpg" />'+
            '         </div>'+
            '         <div class="media-body">'+
            '          <h6 class="mb-1">Aproms Fretes - Pedência Financeira</h6>'+
            '          <small class="d-block">12:26 - 14/12/2021</small>'+
            '         </div>'+
            '        </div>'+
            '       </li>'+
            '      </ul>'+
            '     </div>'+
            '     <a class="all-notification" href="javascript:void(0)">Ver todas as notificações <i class="ti-arrow-right"></i></a>'+
            '    </div>'+
            '  </li>'+
            '  <li class="nav-item dropdown header-profile">'+
            '   <a class="nav-link" href="#" role="button" data-toggle="dropdown">'+
            '    <img src="./assets/images/user.png" width="20" alt="" />'+
            '     <div class="header-info">'+
            '      <span>'+PrimeiroNome(qUSU.FieldByName('NOME').AsString)+'</span>'+
            '      <small>Anunciante</small>'+
            '     </div>'+
            '   </a>'+
            '   <div class="dropdown-menu dropdown-menu-right">'+
            '    <a href="app-profile.html" class="dropdown-item ai-icon">'+
            '     <svg id="icon-user1" xmlns="http://www.w3.org/2000/svg" class="text-primary" width="18" height="18" viewbox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">'+
            '      <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>'+
            '      <circle cx="12" cy="7" r="4"></circle>'+
            '     </svg>'+
            '     <span class="ml-2">Perfil </span>'+
            '    </a>'+
            '    <a class="dropdown-item ai-icon" data-toggle="modal" data-target="#modalLogout">'+
            '     <svg id="icon-logout" xmlns="http://www.w3.org/2000/svg" class="text-danger" width="18" height="18" viewbox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">'+
            '      <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>'+
            '      <polyline points="16 17 21 12 16 7"></polyline>'+
            '      <line x1="21" y1="12" x2="9" y2="12"></line>'+
            '     </svg>'+
            '     <span class="ml-2">Sair </span>'+
            '    </a>'+
            '   </div>'+
            '  </li>'+
            ' </ul>'+
            '</div>'+
            '</nav>'+
            '<div class="sub-header">'+
            ' <div class="d-flex align-items-center flex-wrap mr-auto">';

       if(cMenu='1')then
          cPg:=cPg+'<h5 class="dashboard_bar">Dashboard</h5>'
       else if(cMenu='2')then
          cPg:=cPg+'<h5 class="dashboard_bar">Meus Fretes</h5>'
       else if(cMenu='3')then
          cPg:=cPg+'<h5 class="dashboard_bar">Criar Fretes</h5>';


       cPg:=cPg+'</div>';
       if cMenu='1' then
          cPg:=cPg+
            ' <div class="d-flex align-items-center">'+
            '  <a href="javascript:void(0);" class="btn btn-xs btn-primary light mr-1">Hoje</a>'+
            '  <a href="javascript:void(0);" class="btn btn-xs btn-primary light mr-1">Mês</a>'+
            '  <a href="javascript:void(0);" class="btn btn-xs btn-primary light">Ano</a>'+
            ' </div>';

       cPg:=cPg+
            '</div>'+
            '</div>'+
            '</div>'+
            '<div class="deznav">'+
            ' <div class="deznav-scroll">'+
//            '  <div class="main-profile">'+
//            '   <div class="image-bx">'+
//            '    <img src="./assets/images/perfil-empresa.jpg" alt="" />'+
//            '    <a href="javascript:void(0);"><i class="fa fa-cog" aria-hidden="true"></i></a>'+
//            '   </div>'+
//            '   <h5 class="name"><span class="font-w400">Olá,</span> Gabriel</h5>'+
//            '   <p class="email">468.755.088-69</p>'+
//            '  </div>'+
            '  <ul class="metismenu" id="menu">'+
            '   <li class="nav-label">Menu</li>'+
            '   <li class="mm-active">'+
            '    <a class="has-arrow ai-icon" href="javascript:void()" aria-expanded="false">'+
            '     <i class="flaticon-077-menu-1"></i>'+
            '     <span class="nav-text">Menu</span>'+
            '    </a>'+
            '    <ul aria-expanded="false">'+
            '     <li><a href="/restrito-empresas?id='+aDado[0]+'">Dashboard</a></li>'+
            '     <li><a href="/consulta-fretes?id='+aDado[0]+'">Meus Fretes</a></li>'+
            '    </ul>'+
            '   </li>'+
            '  </ul>'+
            '</div>'+
            '</div>';

       //body start

       cPg:=cPg+
            '<div class="content-body">'+
            ' <div class="container-fluid">'+
            '<div id="loaderCad" class="d-none">'+
            '<div><i class="spinner-border text-padrao" role="status"></i><p></p></div>'+
            '</div>'+
            cHtml+
            ' </div>'+
            '</div>';


       // rodape
       cPg:=cPg+
            '<div class="footer">'+
            ' <div class="copyright">'+
            '  <p>Copyright © R&cia &amp; Developed by <a href="https://rcia.com" target="_blank">R&cia</a> 2021</p>'+
            ' </div>'+
            '</div>'+
            '</div>';

       //modal
       cPg:=cPg+'<div class="modal fade" id="modalLogout">'+
             ' <div class="modal-dialog" role="document">'+
             '  <div class="modal-content">'+
             '   <div class="modal-header">'+
             '    <h5 class="modal-title idTitleModalCon" id="idTitleModalCon">Sair</h5>'+
             '    <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>'+
             '   </div>'+
             '   <div class="modal-body">Você realmente deseja sair?</div>'+
             '    <div class="modal-footer">'+
             '      <button type="button" class="btn btn-danger light" data-dismiss="modal">Fechar</button>'+
             '      <button type="button" class="btn btn-primary" onClick="handleLogout('+QuotedStr(aDado[0])+')">Confirmar</button>'+
             '    </div>'+
             '   </div>'+
             '  </div>'+
             ' </div>';

       //scripts
       cPg:=cPg+
            '<script src="./assets/vendor/global/global.min.js"></script>'+
            '<script src="./assets/vendor/bootstrap-select/dist/js/bootstrap-select.min.js"></script>'+
            '<script src="./assets/js/jquery.maskedinput-1.1.4.pack.js"></script>'+
            '<script src="./assets/js/jquery.maskmoney-3.1.1.js"></script>'+
            '<script src="./assets/js/dashboard/dashboard-1.js"></script>'+
            '<script src="./assets/vendor/owl-carousel/owl.carousel.js"></script>'+
            '<script src="./assets/js/custom.min.js"></script>'+
            '<script src="./assets/js/deznav-init.js"></script>'+
            '<script src="./assets/js/demo.js"></script>'+
            '<script src="./assets/js/main.js"></script>'+
            '<script src="./assets/js/masks.js"></script>'+
            '<script src="./assets/js/main-empresa.js"></script>'+
            '<script type="text/javascript">'+
            '$(document).ready(function () {'+

//            '  $("#cpf").mask("999.999.999-99", {reverse: true});'+
////        '  $("#cpfP").mask("999.999.999-99", {reverse: true});'+
//            '  $("#idCelular").mask("(99)99999-9999", {reverse: true});'+
//            '  $("#telefone").mask("(99)9999-9999", {reverse: true});'+
//            '  $("#cep").mask("99999-999", {reverse: true});'+
//            '  $("#placa").mask("aaa-9*99", {reverse: true});'+
            '  $("#idDataEnt").mask("99/99/9999", {reverse: true});'+
            '  $("#idQtd").maskMoney({prefix: "",decimal: ",",thousands: ".", precision: 3 });'+
            '  $("#idValor").maskMoney({prefix: "",decimal: ",",thousands: "."});'+
            '});'+
            '</script>';

       cPg:=cPg+
            '</body>'+
            '</html>';

   finally
     FreeAndNil(qAUX);
     FreeAndNil(qUSU);
   end;
   result:=cPg;

end;
function TWMSite.RestritoPageMotorista(aDado: TArray<String>; cHtml,
  cMenu: string): String;
begin

end;



function TiraAcentos(sPl: String): String;
const
  Acentos   = 'áéíóúÁÉÍÓÚàèìòùÀÈÌÒÙäëïöüÄËÏÖÜãõÃÕâêîôûÂÊÎÔÛçÇñÑ';
  Normais   = 'aeiouAEIOUaeiouAEIOUaeiouAEIOUaoAOaeiouAEIOUcCnN';
var
  a: Integer;
begin
  Result := '';
  for a := 1 to Length(sPl) do
    if Pos(sPl[a], Acentos) > 0 then
      Result := Result + Normais[Pos(sPl[a], Acentos)]
    else
      Result := Result + sPl[a];
end;

function SubstituiEnterBr(sStr : string): string;
begin
  { Retirando as quebras de linha em campos blob }
  Result := StringReplace(sStr, #$D#$A, '<br/>', [rfReplaceAll]);

  { Retirando as quebras de linha em campos blob }
  Result := StringReplace(sStr, #13#10, '<br/>', [rfReplaceAll]);
end;
function PrimeiroNome(sStr : string): string;
begin
  result := Copy(sStr,1,Pos(' ',sStr));
end;


function GeraLogTab(tab,tipo,codigo: String): String;
var
  qREG:TSQLQuery;
  cDB :TSQLConnection;
begin
   cDB := TSQLConnection.create(nil);
   ConfConexao(cDB);
   qREG:= TSQLQuery.Create(nil);
   qREG.SQLConnection:=cDB;
   try
     try
        if(tab = '2')then begin
//          qREG.Close;
//          qREG.SQL.Text:='INSERT INTO LOGS (TABELA,TIPO,CODIGO,ITEM,DATA)'+
//          'VALUES('+tab+','+QuotedStr(tipo)+','+QuotedStr(codigo)+',(SELECT COALESCE(MAX(ITEM),0)+1 FROM LOGS),CURRENT_TIMESTAMP)';
//          sql := qREG.SQl.Text;
//          qREG.Open;
        end;
     except on E: Exception do
        GravaLog('ERRO NA INSERSÃO DE CONSULTALOG  ERRO:'+e.Message+' SQL:'+sql)
     end;
   finally
      FreeAndNil(qREG);
      FreeAndNil(cDB);
   end;
end;
function GetRandomConvite(Qreg:TSQLQuery;Size:Integer): String;
var
   I: Integer;
   fim : Boolean;
const
   str1 = '1234567890';
begin
   Result := '';
  try
     fim := false;
     while not(fim) do begin
        for I := 1 to Size do
           Result:=Result+str1[Random(Length(str1)) + 1];

        // se ja existe não pode
        qREG.Close;
        qREG.SQL.Text:='SELECT CODIGO FROM MOTORISTAS WHERE CONVITE='+QuotedStr(Result)+' '+
        'UNION ALL SELECT CODIGO FROM EMPRESAS WHERE CONVITE='+QuotedStr(Result);
        qREG.Open;

        fim:=qREG.Eof;
     end;

  finally
  end;
end;
function TWMSite.PaginaPadrao(cHtml:String): String;
var
  cPg : String;
begin
   cPg:=cPg+
   '<!DOCTYPE html>'+
   '<html lang="pt">'+
   '<head>'+
   '<title>Nufrete | Fretes de todos</title>'+
   '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'+
   '<!--<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" /> -->'+
   '<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">'+
   '<link rel="shortcut icon" href="../assets/images/logo.png" />'+
   '<link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,700" rel="stylesheet">'+
   '<link rel="stylesheet" href="../assets/fonts/icomoon/style.css">'+
   '<link rel="stylesheet" href="../assets/css/bootstrap.min.css">'+
   '<link rel="stylesheet" href="../assets/css/jquery-ui.css">'+
   '<link rel="stylesheet" href="../assets/css/owl.carousel.min.css">'+
   '<link rel="stylesheet" href="../assets/css/owl.theme.default.min.css">'+
   '<link rel="stylesheet" href="../assets/css/owl.theme.default.min.css">'+
   '<link rel="stylesheet" href="../assets/css/jquery.fancybox.min.css">'+
   '<link rel="stylesheet" href="../assets/css/bootstrap-datepicker.css">'+
   '<link rel="stylesheet" href="../assets/fonts/flaticon/font/flaticon.css">'+
   '<link rel="stylesheet" href="../assets/css/aos.css">'+
   '<link rel="stylesheet" href="../assets/css/style.css">'+
   '<link rel="stylesheet" href="./fretes/fretes.css">'+
   '<link rel="stylesheet" href="./fretes/fretes-detalhes.css">'+
   '<script src="../assets/js/jquery-3.3.1.min.js"></script>'+
   '<script src="https://www.google.com/recaptcha/api.js?explicit&hl=pt-BR" async defer></script>'+
   '<script src="../assets/js/jquery.maskedinput-1.1.4.pack.js" type="text/javascript"></script>'+
   '<link href="../assets/fontawesome/css/all.css" rel="stylesheet">'+
   ''+
   '</head>'+
   '<body data-spy="scroll" data-target=".site-navbar-target" data-offset="300">'+
   '<div class="site-wrap">'+
   '<div class="site-mobile-menu site-navbar-target">'+
   '<div class="site-mobile-menu-header">'+
   '<div class="site-mobile-menu-close mt-3">'+
   '<span class="icon-close2 js-menu-toggle"></span>'+
   '</div>'+
   '</div>'+
   '<div class="site-mobile-menu-body"></div>'+
   '</div>'+
   '<!-- js-sticky-header site-navbar-target -->'+
   '<header class="site-navbar  " role="banner">'+
   '<!-- MENU PRINCIPAL -->'+
   '<div class="container-fluid bg-white p-0">'+
   '<div class="row align-items-center m-0 ">'+
   '<div class="col-10 d-block d-lg-none ml-md-0 py-3" style="position: relative; top: 3px;">'+
   '<a href="/"><img src="../assets/images/logo.png" class="logoMenu"/></a>'+
   '</div>'+
   ''+
   '<div class="col-2 d-block d-lg-none ml-md-0 py-3" style="position: relative; top: 3px;">'+
   '<a href="#" class="site-menu-toggle js-menu-toggle float-right text-dark">'+
   '<span class="icon-menu h3"></span>'+
   '</a>'+
   '</div>'+
   ''+
   ''+
   '<div class="col-12 m-0 BoxMenu js-sticky-header  d-lg-block d-none">'+
   '<nav class="site-navigation position-relative text-center text-white" role="navigation">'+
   '<ul class="site-menu main-menu js-clone-nav mr-auto d-none d-lg-block pb-2">'+
   '<li><a href="/"><img src="../assets/images/logo.png" class="logoMenu"/></a></li>'+
   '<li><a href="/fretes/" class="nav-link sansLight linkMenu">FRETES</a></li>'+
   '<li><a href="/empresas/" class="nav-link sansLight linkMenu">PARA EMPRESAS</a></li>'+
   '<li><a href="/motoristas/" class="nav-link sansLight linkMenu">PARA MOTORISTAS</a></li>'+
   '<!-- <li><button class="btn btn-primary d-block d-lg-none js-menu-toggle" data-toggle="modal" data-target=".bd-modal-sm">ENTRAR</button></li>'+
   '<li><a class="btCad d-lg-block d-none" href="/empresas/">Cadastre-se</a></li>'+
   '<li><button class="btn btn-danger btlogin d-lg-block d-none" data-toggle="modal" data-target=".bd-modal-sm">ENTRAR</button></li> -->'+
   '<!-- <button class="btn btn-danger btlogin d-lg-block d-none" data-toggle="modal" data-target=".bd-modal-sm">ENTRAR</button></li> -->'+
   '<li class="has-children">'+
   '<a href="#" class="nav-link sansLight linkMenu btCad">CADASTRAR-SE</a>'+
   '<ul class="dropdown">'+
   '<li><a href="/empresas?lc=cadastro" class="nav-link">SOU EMPRESA</a></li>'+
   '<li><a href="/motoristas?lc=cadastro" class="nav-link">SOU MOTORISTAS</a></li>'+
   '</ul>'+
   '</li>'+
   '<li class="has-children"><a href="#" class="nav-link sansLight linkMenu ">ENTRAR</a>'+
   '<ul class="dropdown">'+
   '<li><a href="/empresas?lc=entrar" class="nav-link">SOU EMPRESA</a></li>'+
   '<li><a href="/motoristas?lc=entrar" class="nav-link">SOU MOTORISTAS</a></li>'+
   '</ul>'+
   '</li>'+
   '<li>'+
   ''+
   ''+
   '</ul>'+
   '</nav>'+
   '</div>'+
   '</div>'+
   '</div>'+
   '</header>'+
   '<section class="main pt-0 bg-white">'+cHtml+'</section>';

   cPg:=cPg+
   '<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-1842706089820019" crossorigin="anonymous"></script>'+
   '<script src="../assets/js/jquery-ui.js"></script>'+
   '<script src="../assets/js/popper.min.js"></script>'+
   '<script src="../assets/js/bootstrap.min.js"></script>'+
   '<script src="../assets/js/owl.carousel.min.js"></script>'+
   '<script src="../assets/js/jquery.countdown.min.js"></script>'+
   '<script src="../assets/js/jquery.easing.1.3.js"></script>'+
   '<script src="../assets/js/aos.js"></script>'+
   '<script src="../assets/js/jquery.fancybox.min.js"></script>'+
   '<script src="../assets/js/jquery.sticky.js"></script>'+
   '<script src="../assets/js/isotope.pkgd.min.js"></script>'+
   '<script src="./main.js?v=1.1"></script>'+
   '<script src="../assets/js/main.js"></script>'+
   '<script src="../assets/js/cookie.js"></script>'+
   '<script defer src="../assets/js/solid.js"></script>'+
   '<script defer src="../assets/js/fontawesome.js"></script>'+
   '</body>'+
   '</html>';

   result := cPg;
end;



procedure TWMSite.posto_entrarHTMLTag(Sender: TObject; Tag: TTag;
  const TagString: string; TagParams: TStrings; var ReplaceText: string);
begin
  ReplaceText := 'oi';
  Response;
end;

function MensagemErroServer():string;
begin
   result := '{"erro":1,"mensagem":"Todo mundo erra, e dessa vez foram nossos servidores, já estamos trabalhando nisso"}';
end;

function MensagemErroLimite():String;
begin
   result := '{"erro":1,"mensagem":"Você atingiu o limite mensal de emissões da sua conta"}';
end;

function ValidaJSONObject(sJson:String):Boolean;
var
  JO : TJSONObject;
begin
   try
      JO     := TJSonObject.ParseJSONValue(sJson) AS TJSONObject;
      result := true;
   except on E: Exception do begin
      result := false;
   end;
   end;
end;
function GetTokenBearer(sToken:String):String;
begin
   result := Copy(sToken,Pos('Bearer ',sToken)+7,Length(sToken));
end;


function GeraJSONStr(qSQL: TSQLQuery;sOper:String = '';isJsonMin: Boolean = false):String;
var
  nF : Integer;
  cp : String;
  oJs : TJSONObject;
  aJs : TJSONArray;
begin
//  Result := '{';
  try
    qSQL.First;
    aJs := TJSONArray.Create;
    while not(qSQL.Eof) do begin
       oJs := TJSONObject.Create;
       for nF := 0 to qSQL.FieldCount-1 do begin
          cp := iif(isJsonMin,LowerCase(qSQL.Fields[nF].FieldName),UpperCase(qSQL.Fields[nF].FieldName));
          if qSQL.Fields[nF].DataType in [ftInteger,ftSmallint,ftFLoat,ftBCD] then
             oJs.AddPair(cp,ValorSQL(qSQL.FieldByName(qSQL.Fields[nF].FieldName).AsString))
          else if qSQL.Fields[nF].DataType in [ftFMTBCD] then
             oJs.AddPair(cp,FormatFloat(',#0.00',qSQL.FieldByName(qSQL.Fields[nF].FieldName).AsFloat))
          else if qSQL.Fields[nF].DataType=ftWideMemo then
             oJs.AddPair(cp,' ')
          else if (qSQL.Fields[nF].DataType=ftMemo) or (qSQL.Fields[nF].DataType=ftBlob) then
             if qSQL.FieldByName(cp).IsNull then
                ojs.AddPair(cp,' ')
             else
                oJs.AddPair(cp,RemoveQuebrasDeTexto(qSQL.FieldByName(qSQL.Fields[nF].FieldName).Value))
          else if(qSQL.Fields[nF].FieldName='CELULAR')then
             oJs.AddPair(cp,FormataFone(qSQL.FieldByName(qSQL.Fields[nF].FieldName).AsString))
          else
             oJs.AddPair(cp,RemoveQuebrasDeTexto(qSQL.FieldByName(qSQL.Fields[nF].FieldName).AsString));
       end;

//       if(sAdd<>'')then  //adiciona objeto passado por parametro
//          oJs.AddPair(sAdd,aAdd);

       aJs.Add(oJs);
       if sOper='Executa' then
          Break;

       qSQL.Next;
    end;

    Result := aJs.ToString;
  finally
    aJs.DisposeOf;
  end;

end;

function GetValueJSONObject(cCampo:String;oJSON:TJSONObject):string;
begin
   try
      if(oJSON.GetValue<String>(cCampo) = 'null')then
         Result := ''
      else
         Result := oJSON.GetValue<String>(cCampo);
   except on E:Exception do
      Result := '';
   end;
end;

function GetValueJSONNull(cCampo:String;oJSON:TJSONObject):string;
begin
   try
      if(oJSON.GetValue<String>(cCampo) = 'null')then
         Result := 'NULL'
      else
         Result := oJSON.GetValue<String>(cCampo);
   except on E:Exception do
      Result := 'NULL';
   end;
end;

function GetValueAsString(jsonObj: TJSONObject; const propertyName: string): string;
var
  jsonValue: TJSONValue;
begin
  jsonValue := jsonObj.Values[propertyName];
  if Assigned(jsonValue) and (jsonValue is TJSONString) then
    Result := TJSONString(jsonValue).Value
  else
    Result := '';
end;

function GetRandomId(cTip:String;Size:Integer):String;
var
   cSql : String;
   qREG : TSQLQUery;
   cDB  : TSQLConnection;
   I    : Integer;
   bRep  : Boolean;

   const str1 = '1234567890';
begin
   cDB  := TSQLConnection.Create(Nil);
   qREG := TSQLQuery.Create(Nil);

   ConfConexao(cDB);

   qREG.SQLConnection := cDB;
   try
      if(cTip='Usuario')then
         cSql := 'SELECT * FROM USUARIOS WHERE ID=0';
      if(cTip='Pagamento')then
         cSql := 'SELECT * FROM TRANSACOES WHERE ID=0';

      bRep := false;
      while not(bRep) do begin
         for I := 1 to Size do
            Result:=Result+str1[Random(Length(str1)) + 1];

         qREG.Close;
         qREG.SQL.Text := cSql+Result;
         qREG.Open;

         if qREG.Eof then
            bRep := true;
      end;
   finally
      FreeAndNil(qREG);
      FreeAndNil(cDB);
   end;
end;

function IsDigit(st:String):Boolean;
begin
  Result := True;
  Try
     StrToInt(Copy(st,1,1));
  Except
     Result := False;
  end;
end;

function StrIn(v:Array of String; s:String):integer;
var i : Integer;
begin
   result := -1;
   for i:=0 to high(v) do begin
      if v[i] = s then  begin
         result := i;
         break;
      end;
   end;
end;


function ValidaDataStr(sData:String):Boolean;
var
  tDt:TDateTime;
begin
  try
     tDt := StrToDate(sData);
     result := true;
  except on E: Exception do begin
     result := false;
  end;
  end;
end;

procedure ConfiguraConexao(cCnpjPar:String;cDB:TSQLConnection);
var
   Ini : TIniFile;
   sBan,sUsu,sSen : String;

   qREG   : TSQLQuery;
   cDBSYS : TSQLConnection;
begin
   cDBSYS := TSQLConnection.Create(Nil);
   qREG   := TSQLQuery.Create(Nil);

   ConfConexao(cDBSYS);

   qREG.SQLConnection := cDBSYS;
   try
      cCnpjPar := soNumero(cCnpjPar);

      qREG.Close;
      qREG.SQL.Text := 'SELECT BANCO,USUARIO,SENHA,SITUACAO,'+
      'COALESCE(DATA_VERIFICACAO,'''') AS DATA_VERIFICACAO '+
      'FROM EMPRESAS '+
      'WHERE (SELECT RESULTADO FROM EXTRAI_NUMERO(CNPJ))='+QuotedStr(cCnpjPar);
      qREG.Open;

      if (qREG.Eof) then
        raise Exception.Create('Banco não configurado empresa:'+cCnpjPar+'.');
      if (qREG.FieldByName('DATA_VERIFICACAO').AsString = '') then
        raise Exception.Create('Email não validado:'+cCnpjPar+'.');

      cDB.LoadParamsOnConnect := false;
      cDB.ConnectionName      := 'FBConnection';
      cDB.DriverName          := 'Firebird';
      cDB.LibraryName         := 'dbxfb.dll';
      cDB.VendorLib           := 'fbclient.dll';
      cDB.Params.Values['Database']  := qREG.FieldByName('BANCO').AsString;
      cDB.Params.Values['User_Name'] := qREG.FieldByName('USUARIO').AsString;
      cDB.Params.Values['Password']  := qREG.FieldByName('SENHA').AsString;
      cDB.Params.Values['IsolationLevel'] := 'ReadCommited';
      cDB.LoginPrompt := False;
   finally
      FreeAndNil(qREG);
      FreeAndNil(cDBSYS);
   end;
end;




procedure TWMSite.WMSiteactBuscaRegAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
  cErros : String;
  cToken : String;
  cSql   : String;
  oReq   : TJSONObject;
  qREG   : TSQLQuery;
  cDB    : TSQLConnection;
begin
   qREG := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   try
      try
         cErros := '';

         cToken := GetTokenBearer(Request.Authorization);
         oReq   := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         cSql   := GetValueJSONObject('sql',oReq);

         if (Request.QueryFields.Values['db'].Trim() = '') then
            cErros := cErros + 'Banco de dados não informado.';
         // if (Trim(Request.QueryFields.Values['chave'])='')or(Request.QueryFields.Values['chave'] <> MD5('R&CIA'+cSql+'INT')) then
         //    cErros := cErros + 'Chave de segurança inválida.';
         if (cSql.Trim() = '') then
            cErros := cErros + 'SQL não informada.';
         if Trim(cToken)='' then begin
            Response.Content := '{"erro":99,"mensagem":"Token inválido."}';
            Exit;
         end;

         if(cErros = '')then begin
            // configura conexao
            ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

            qREG.SQLConnection := cDB;

            qREG.Close;
            qREG.SQL.Text := 'SELECT TOKEN FROM USUARIOS WHERE TOKEN='+QuotedStr(cToken);
            qREG.Open;

            if qREG.Eof then begin
               Response.Content := '{"erro":99,"mensagem":"Usuário inválido"}';
               Exit;
            end;
         end;

         if (cErros <> '') then begin
            Response.Content := '{"erro":1,"mensagem":"'+cErros+'"}';
            Exit;
         end;

         if (Pos('DELETE',cSql) <> 0) and (Request.QueryFields.Values['hash'] <> 'fe7ec4cf-e8de-4f39-bb13-0b606299b57d') then begin
            Response.Content := '{"erro":1,"mensagem":"Sem autorização"}';
            Exit;
         end;

         Response.Content := ExecutaSQL(Request.QueryFields,oReq,cDB);
      except on E: Exception do begin
         Response.Content := '{"erro":1,"mensagem":"Ocorreu algum erro, tente novamente mais tarde"}';
         GravaLog('Erro no busca-registro #Erro:'+e.Message+sLineBreak+'sql:'+GetValueJSONObject('sql',oReq));
      end;
      end;
   finally
      FreeAndNil(cDB);
      FreeAndNil(qREG);
   end;
end;

procedure TWMSite.WMSiteactBuscasAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
   sSql : String;
   TBus : TBuscas;
begin
   TBus := TBuscas.Create;
   try
      try
         if(Request.QueryFields.Values['op'] = 'clienteExiste')then
            Response.Content := TBus.clienteExiste(Request.QueryFields);
      except on E: Exception do begin
         Response.Content := MensagemErroServer();
         GravaLog('Erro na rotina #buscas:'+e.Message+sLineBreak+' SQL:'+TBus.GetSql());
      end;
      end;
   finally
      FreeAndNil(TBus);
   end;
end;

procedure TWMSite.WMSiteactEncripAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
begin
   if(Request.QueryFields.Values['hash'] <> '470618ee-57e7-4692-82f0-c5a599febe95')then
      Response.Content := '{"erro":1,"mensagem":"Não autorizado"}'
   else
      Response.Content := '{"result":"'+Encrip(request.QueryFields.Values['text'])+'"}';
end;




procedure TWMSite.WMSiteactValidaCodigoAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   TEmp : TEmpresas;
begin
   TEmp := TEmpresas.Create;
   try
      try
         if(Request.QueryFields.Values['cnpj'] = '')or(Request.QueryFields.Values['code'] = '')then
            Response.Content := '{"erro":1,"mensagem":"Parâmetros inválidos"}'
         else
            Response.Content := TEmp.ValidaCodigo(Request.QueryFields);
      except on E: Exception do
         Response.Content := MensagemErroServer();
      end;
   finally
      FreeAndNil(TEmp);
   end;
end;





function ExecutaSQL(Params:TStrings;oBody:TJSONObject;cDB:TSQLConnection):String;
var
   qREG : TSQLQuery;
   sSql : String;
   isJsonMin : Boolean;
begin
   qREG := TSQLQuery.Create(Nil);

   qREG.SQLConnection := cDB;
   try
      qREG.Close;
      // qREG.SQL.Text := StringReplace(GetValueJSONObject('sql',oBody), '''', '''''', [rfReplaceAll]);;
      qREG.SQL.Text := GetValueJSONObject('sql',oBody);
//      GravaLog('SQL:'+qREG.SQL.Text);
      sSql := UpperCase(qREG.SQL.Text);

      if ((Pos('UPDATE',sSql)<>0)or(Pos('INSERT',sSql)<>0)or(Pos('DELETE',sSql) <> 0)) and(Pos('RETURNING',sSql) = 0) then begin
         qREG.ExecSQL(False);
         Result := '{"erro":0,"mensagem":"Executado com sucesso"}';
      end else begin
         qREG.Open;

         isJsonMin := false;
         if(Params.Values['minusculo'] <> '')then
            isJsonMin := true;

         if (Pos('UPDATE',sSql)<>0)or(Pos('INSERT',sSql)<>0)or(Pos('DELETE',sSql)<>0) then
            Result := GeraJSONStr(qREG,'Executa',isJsonMin)
         else
            Result := GeraJSONStr(qREG,'',isJsonMin);
      end;
   finally
      FreeAndNil(qREG);
   end;
end;

function MD5(texto:string):string;
var
   idmd5 : TIdHashMessageDigest5;
begin
  idmd5 := TIdHashMessageDigest5.Create;
  try
     result := idmd5.HashStringAsHex(texto);
  finally
     idmd5.Free;
  end;
end;




procedure TWMSite.WMSiteppCadastrarAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
   cRes : String;
   cReq : String;
   oReq : TJSONObject;
   TEmp : TEmpresas;
begin
   TEmp := TEmpresas.Create;
   try
      try
         cRes := '';
         cReq := Request.Content;

         if (Trim(cReq) = '')then
            cRes := '{"erro":1,"mensagem":"Nenhum parâmetro encontrado"}';

         if( not ValidaJSONObject(cReq))then begin
            cRes := '{"erro":1,"mensagem":"JSON Inválido"}';
            Response.StatusCode := 404;
         end;

         oReq := TJSONObject.ParseJSONValue(cReq) AS TJSONObject;

         if (Trim(GetValueJSONObject('cnpj',oReq))='') or (not ValidaCPFCNPJ(GetValueJSONObject('cnpj',oReq))) then
            cRes := '{"erro":1,"mensagem":"CNPJ inválido"}'
         else if Trim(GetValueJSONObject('nome',oReq))='' then
            cRes := '{"erro":1,"mensagem":"Nome não informado"}'
         else if Trim(GetValueJSONObject('email',oReq))='' then
            cRes := '{"erro":1,"mensagem":"Email não informado"}'
         else if Trim(GetValueJSONObject('usuario',oReq))='' then
            cRes := '{"erro":1,"mensagem":"Usuário não informado"}'
         else if Trim(GetValueJSONObject('senha',oReq))='' then
            cRes := '{"erro":1,"mensagem":"Senha não informada"}';

         if(cRes = '')then
            cRes := TEmp.Cadastrar(oReq,Request.QueryFields);
      except on E: Exception do begin
         cRes := '{"erro":1,"mensagem":"Ocorreu algum erro, tente novamente mais tarde"}';
         GravaLog('Erro no login #Erro:'+e.Message+' SQL:'+TEmp.GetSql());
      end;
      end;
   finally
      FreeAndNil(TEmp);
      Response.Content := cRes;
   end;
end;


procedure TWMSite.WMSiteppEntrarAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cRes : String;
   cReq : String;
   oReq : TJSONObject;
   TEmp : TEmpresas;
begin
   TEmp := TEmpresas.Create;
   try
      try
         cRes := '';
         cReq := Request.Content;

         if (Trim(cReq) = '')then
            cRes := '{"erro":1,"mensagem":"Nenhum parâmetro encontrado"}';

         if( not ValidaJSONObject(cReq))then begin
            cRes := '{"erro":1,"mensagem":"JSON Inválido"}';
            Response.StatusCode := 404;
         end;

         oReq := TJSONObject.ParseJSONValue(cReq) AS TJSONObject;

         if Trim(Request.QueryFields.Values['db'])='' then
            cRes := '{"erro":1,"mensagem":"Base de dados não informada"}'
         else if Trim(GetValueJSONObject('login',oReq))='' then
            cRes := '{"erro":1,"mensagem":"Login inválido"}'
         else if Trim(GetValueJSONObject('senha',oReq))='' then
            cRes := '{"erro":1,"mensagem":"Senha inválida"}';

         if(cRes='')then
            cRes := TEmp.Login(oReq,Request.QueryFields);
      except on E: Exception do begin
         cRes := '{"erro":1,"mensagem":"Ocorreu algum erro, tente novamente mais tarde"}';

         if(Pos('Email não validado',e.Message) <> 0)then
            cRes := '{"erro":2,"mensagem":"'+e.Message+'"}';

         GravaLog('Erro no login #Erro:'+e.Message+' SQL:'+TEmp.GetSql());
      end;
      end;
   finally
      FreeAndNil(TEmp);
      Response.Content := cRes;
   end;
end;


function TemDeleteSQL(cStr:String):Boolean;
begin
   Result := false;
   if (Pos('DELETE',cStr)<>0) and (Pos('FROM',cStr)<>0) then
      Result := true;
end;

procedure TWMSite.WMSiteacDadosUserAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
   cCod   : String;
   cSen   : String;
   cToken : String;
   qREG   : TSQLQuery;
   cDB    : TSQLConnection;
begin
   qREG := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qREG.SQLConnection := cDB;
   try
      cToken := GetTokenBearer(Request.Authorization);

      qREG.Close;
      qREG.SQL.Text := 'SELECT U.*,E.CNPJ '+
      'FROM USUARIOS U '+
      'LEFT JOIN EMPRESA E ON E.CODIGO=1 '+
      'WHERE U.TOKEN='+QuotedStr(cToken);
      qREG.Open;

      if qREG.Eof then
         Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
      else begin
         Response.Content := '{"erro":0,'+
         '"mensagem":"Usuário autenticado com sucesso",'+
         '"token":"'+cToken+'",'+
         '"codigo":"'+qREG.FieldByName('CODIGO').AsString+'",'+
         '"nome":"'+qREG.FieldByName('NOME').AsString+'",'+
         '"cnpj":"'+qREG.FieldByName('CNPJ').AsString+'",'+
         '"db":"'+Request.QueryFields.Values['db']+'",'+
         '"perfil":"'+qREG.FieldByName('PERFIL').AsString+'",'+
         '"perfil_adicional":"'+qREG.FieldByName('PERFIL1').AsString+'"'+
         '}';
      end;
   finally
      FreeAndNil(cDB);
      FreeAndNil(qREG);
   end;
end;

procedure TWMSite.WMSiteppBuscaDadosReceitaAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   TEmp : TEmpresas;
begin
   TEmp := TEmpresas.Create;
   try
      try
         if(Request.QueryFields.Values['cnpj'] = '')then
            Response.Content := '{"erro":1,"mensagem":"Cnpj inválido"}'
         else
            Response.Content := TEmp.BuscaDadosCNPJ(Request.QueryFields);

            if(Response.Content = '{}')then
               Response.StatusCode := 429;
      except on E: Exception do
         Response.Content := MensagemErroServer();
      end;
   finally
      FreeAndNil(TEmp);
   end;
end;

function ValidaCPFCNPJ(sText:String):Boolean;
begin
   if(Length(SoNumero(sText))=11)then
      result := ValidaCPF(sText)
   else
      result := ValidaCNPJ(sText);
end;



function ValidaCNPJ(CNPJ:string):Boolean;
var   dig13, dig14: string;
    sm, i, r, peso: integer;
begin
  CNPJ := SoNumero(CNPJ);
  // length - retorna o tamanho da string do CNPJ (CNPJ é um número formado por 14 dígitos)
  if ((CNPJ = '00000000000000') or (CNPJ = '11111111111111') or
      (CNPJ = '22222222222222') or (CNPJ = '33333333333333') or
      (CNPJ = '44444444444444') or (CNPJ = '55555555555555') or
      (CNPJ = '66666666666666') or (CNPJ = '77777777777777') or
      (CNPJ = '88888888888888') or (CNPJ = '99999999999999') or
      (length(CNPJ) <> 14))then begin
     result := false;
     exit;
  end;


  try
     { *-- Cálculo do 1o. Digito Verificador --* }
     sm := 0;
     peso := 2;
     for i := 12 downto 1 do begin
        // StrToInt converte o i-ésimo caractere do CNPJ em um número
        sm := sm + (StrToInt(CNPJ[i]) * peso);
        peso := peso + 1;
        if (peso = 10) then
           peso := 2;
     end;
     r := sm mod 11;
     if ((r = 0) or (r = 1))then
        dig13 := '0'
     else
        str((11-r):1, dig13); // converte um número no respectivo caractere numérico

     sm := 0;
     peso := 2;
     for i := 13 downto 1 do begin
        sm := sm + (StrToInt(CNPJ[i]) * peso);
        peso := peso + 1;
        if (peso = 10) then
           peso := 2;
     end;
     r := sm mod 11;
     if ((r = 0) or (r = 1)) then
        dig14 := '0'
     else
        str((11-r):1, dig14);

    if ((dig13 = CNPJ[13]) and (dig14 = CNPJ[14])) then
       result := true
    else
       result := false;
  except
    result := false
  end;
end;

function ValidaCPF(CPF:String):Boolean;
var  dig10, dig11: string;
    s, i, r, peso: integer;
begin
  CPF := SoNumero(CPF);
  // length - retorna o tamanho da string (CPF é um número formado por 11 dígitos)
  if ((CPF = '00000000000') or (CPF = '11111111111') or
      (CPF = '22222222222') or (CPF = '33333333333') or
      (CPF = '44444444444') or (CPF = '55555555555') or
      (CPF = '66666666666') or (CPF = '77777777777') or
      (CPF = '88888888888') or (CPF = '99999999999') or
      (length(CPF) <> 11)) then begin
     result := false;
     exit;
  end;

  try
     s := 0;
     peso := 10;
     for i := 1 to 9 do begin
        s := s + (StrToInt(CPF[i]) * peso);
        peso := peso - 1;
     end;
     r := 11 - (s mod 11);
     if ((r = 10) or (r = 11)) then
        dig10 := '0'
     else
        str(r:1, dig10);

     s := 0;
     peso := 11;
     for i := 1 to 10 do begin
        s := s + (StrToInt(CPF[i]) * peso);
        peso := peso - 1;
     end;
     r := 11 - (s mod 11);
     if ((r = 10) or (r = 11)) then
        dig11 := '0'
     else
        str(r:1, dig11);

     if ((dig10 = CPF[10]) and (dig11 = CPF[11])) then
        result := true
     else
        result := false;

  except
    result := false
  end;
end;

function GeraNumRand(iMax : Integer):String;
var
  I: Integer;

const
  str1 = '1234567890';
begin
  Result := '';

  for I := 1 to iMax do
     Result:=Result+str1[Random(Length(str1)) + 1];
end;

function QuotedCopy(cStr:String;iLen:Integer):String;
begin
   result := QuotedStr(Copy(cStr,1,iLen));
end;



procedure TWMSite.WMSiteactUsuariosUpdateSenhaAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cCod   : String;
   cSen   : String;
   cToken : String;
   oReq   : TJSONObject;
   qREG   : TSQLQuery;
   qAUX   : TSQLQuery;
   cDB    : TSQLConnection;
begin
   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;
   try
      cToken := GetTokenBearer(Request.Authorization);

      LocalizaUsu(qREG,cToken);

      oReq := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;
      if qREG.Eof then
         Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
      else if(GetValueJSONObject('senha',oReq)<>GetValueJSONObject('confirmaSenha',oReq))then
         Response.Content := '{"erro":1,"mensagem":"Senhas divergentes"}'
      else begin
//         qAUX.SQL.Text := 'UPDATE USUARIOS SET SENHA='+QuotedStr(Encrip(GetValueJSONObject('senha',oReq)));
//         qAUX.ExecSQL(False);

         qAUX.SQL.Text := 'UPDATE USUARIOS SET '+
         'SENHA='+QuotedStr(Encrip(GetValueJSONObject('senha',oReq)))+' '+
         'WHERE CODIGO=0'+qREG.FieldByName('CODIGO').AsString;
         qAUX.ExecSQL(False);

         Response.Content := '{"erro":0,"mensagem":"Senha alterada com sucesso"}';
      end;
   finally
      FreeAndNil(qREG);
      FreeAndNil(qAUX);
      FreeAndNil(cDB);
   end;
end;


procedure TWMSite.WMSiteactFretesRegistraAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken: String;
   oReq  : TJSONObject;
   TFre  : TFretes;
   qUSU  : TSQLQuery;
   cDB   : TSQLConnection;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TFre := TFretes.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         LocalizaUsu(qUSU,cToken);
        
         if qUSU.Eof then begin
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}';
            exit;
         end;

         oReq := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         Response.Content := TFre.Registra(oReq,qUSU,cDB);
      except on E: Exception do begin
         GravaLog('Erro ao registrar frete #erro:'+e.Message+sLineBreak+'#SQL:'+TFre.GetSql);
         Response.Content := MensagemErroServer();
      end;
      end;
   finally
      FreeAndNil(TFre);
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      oReq.DisposeOf;
   end;
end;



procedure TWMSite.WMSiteactProdutosRegAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken: String;
   oReq  : TJSONObject;
   TPro  : TProdutos;
   qUSU  : TSQLQuery;
   cDB   : TSQLConnection;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TPro := TProdutos.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then begin
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}';
            exit;
         end;

         oReq := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         Response.Content := TPro.Registra(oReq,qUSU);
      except on E: Exception do begin
         GravaLog('Erro ao registrar produto #erro:'+e.Message+sLineBreak+'#SQL:'+TPro.GetSql);
         Response.Content := MensagemErroServer();
      end;
      end;
   finally
      FreeAndNil(TPro);
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      oReq.DisposeOf;
   end;
end;

function QuotedJSON(cCamp:String;oJSON:TJSONObject):String;
begin
   try
      if(oJSON.GetValue<String>(cCamp) = 'null')then
         Result := 'NULL'
      else
         Result := QuotedStr(oJSON.GetValue<String>(cCamp));
   except on E:Exception do
      Result := 'NULL';
   end;
end;

function JSONIsNull(cCamp:String;oJSON:TJSONObject):Boolean;
begin
   result := false;
   if(GetValueJSONObject(cCamp,oJSON) = 'null')then
      Result := true;
end;



procedure TWMSite.WMSiteactAtualizaEmpresaAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cCod   : String;
   cSen   : String;
   cToken : String;
   cDir   : String;
   cFile  : String;
   nFile  : Integer;
   oReq   : TJSONObject;
   qREG   : TSQLQuery;
   qUSU   : TSQLQuery;
   cDB    : TSQLConnection;
   TEmp   : TEmpresas;
begin
   qUSU := TSQLQuery.Create(Nil);
   qREG := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;
   qREG.SQLConnection := cDB;
   try
      try

         cToken := GetTokenBearer(Request.Authorization);

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else begin
            with TMultipartContentParser.Create(Request) do begin
               cDir := '.\clientes\certificados\';
               if not(DirectoryExists(cDir)) then
                  ForceDirectories(cDir);

               cDir := './clientes/certificados/';

               cFile := '';
               for nFile := 0 to Request.Files.Count -1 do begin
                  Gravalog(Request.Files[nFile].FileName);
                  if(validaCertificado(Request.Files[nFile].FileName))then begin
                     cFile := cDir  + soNumero(qUSU.FieldByName('CNPJ').AsString);
                     cFile := cFile + ExtractFileExt(Request.Files[nFile].FileName);

                     TMemoryStream(Request.Files[nFile].Stream).SaveToFile(cFile);
                  end;
                  GravaLog(Request.Files[nFile].FileName);
               end;

               Response.Content := '{"erro":1,"mensagem":"Nenhum certificado anexado!"}';
               if(cFile <> '')then begin
                  qREG.Close;
                  qREG.SQL.Text := 'UPDATE PARAMETROS SET CERTIFICADO_CAMINHO='+QuotedStr(cFile);
                  qREG.ExecSQL(False);

                  Response.Content := '{"erro":0,"mensagem":"Certificado alterado com sucesso"}';
               end;

               Free;
            end;

         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao salvar certificado digital cliente #erro:'+e.MEssage);
      end;
      end;
   finally
      FreeAndNil(qREG);
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
   end;
end;

function validaCertificado(cFile:string):boolean;
var
   cExt : String;
begin
   cExt := ExtractFileExt(cFile);
   Result := false;
   if(StrInArray(cExt,['.cer', '.crt', '.pem', '.p12', '.pfx', '.p7b', '.p7c', '.key']))then
      Result := true;
end;
function validaImagem(cFile:string):boolean;
var
   cExt : String;
begin
   cExt := ExtractFileExt(cFile);
   Result := false;
   if(StrInArray(cExt,['.png', '.jpg', '.jpeg', '.bmp']))then
      Result := true;
end;

function StrInArray(Str : String; const lista : Array of string) : Boolean;
var
  I: Integer;
begin
  for I := Low(lista) to High(lista) do
    if lista[I] = Str then
    begin
      Result := True;
      Exit;;
    end;
  Result := False;
end;

procedure TWMSite.WMSiteactExcluiCertificadoEmpresaAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cCod   : String;
   cSen   : String;
   cToken : String;
   cDir   : String;
   cFile  : String;
   nFile  : Integer;
   oReq   : TJSONObject;
   qREG   : TSQLQuery;
   qUSU   : TSQLQuery;
   cDB    : TSQLConnection;
   TEmp   : TEmpresas;
begin
   qUSU := TSQLQuery.Create(Nil);
   qREG := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;
   qREG.SQLConnection := cDB;
   try
      try

         cToken := GetTokenBearer(Request.Authorization);

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else begin
            qREG.Close;
            qREG.SQL.Text := 'SELECT COALESCE(CERTIFICADO_CAMINHO,'''') AS CERTIFICADO_CAMINHO '+
            'FROM PARAMETROS';
            qREG.Open;

            if(qREG.FieldByName('CERTIFICADO_CAMINHO').AsString <> '')then begin
               DeleteFile(PChar(qREG.FieldByName('CERTIFICADO_CAMINHO').AsString));

               qREG.Close;
               qREG.SQL.Text := 'UPDATE PARAMETROS SET CERTIFICADO_CAMINHO=NULL';
               qREG.ExecSQL(False);
            end;

            Response.Content := '{"erro":0,"mensagem":"Certificado alterado com sucesso"}';
         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao excluir certificado digital cliente '+Request.QueryFields.Values['db']+' #erro:'+e.MEssage);
      end;
      end;
   finally
      FreeAndNil(qREG);
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
   end;
end;

procedure TWMSite.WMSitectestatusAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
   cToken : String;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
   TCt  : TCTe;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TCt := TCte.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else begin
            Response.Content := TCt.Status(cDB);
         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao consultar status cte cliente:'+Request.QueryFields.Values['db']+' #erro:'+e.MEssage+sLineBreak+'sql:'+TCt.GetSql());
      end;
      end;
   finally
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      FreeAndNil(TCt);
   end;
end;

procedure TWMSite.WMSiteactGetItemsConfigAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken : String;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
   TCt  : TCTe;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TCt := TCte.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else begin
            Response.Content := TCt.GetConfigs();
         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao excluir certificado digital cliente '+Request.QueryFields.Values['db']+' #erro:'+e.MEssage);
      end;
      end;
   finally
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      FreeAndNil(TCt);
   end;
end;

procedure TWMSite.WMSiteactEnviarCteAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken : String;
   oReq : TJSONObject;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
   TCt  : TCTe;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TCt := TCte.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         oReq   := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else if(GetValueJSONObject('codigo',oReq) = '')then
            Response.Content := '{"erro":99,"mensagem":"Registro inválido"}'
         else begin
            Response.Content := TCt.Envia(oReq,qUSU,cDB);
         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao enviar cte cliente:'+Request.QueryFields.Values['db']+' #erro:'+e.MEssage+sLineBreak+'sql:'+TCt.GetSql());
      end;
      end;
   finally
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      FreeAndNil(TCt);
   end;
end;



function GetCFOPNome(cfopCode: Integer): string;
const
  CFOPData: array[0..21] of record
    labelStr: string;
    valor: Integer;
  end = (
    (labelStr: 'ANULAÇÃO DE valor DE SERVIÇO DE TRANSPORTE'; valor: 1206),
    (labelStr: 'ANULAÇÃO DE valor DE SERVIÇO DE TRANSPORTE'; valor: 2206),
    (labelStr: 'ANULAÇÃO DE valor DE SERVIÇO DE TRANSPORTE'; valor: 3206),
    (labelStr: 'TRANSPORTE PARA MESMA NATUREZA'; valor: 5351),
    (labelStr: 'TRANSPORTE PARA A INDUSTRIA'; valor: 5352),
    (labelStr: 'TRANSPORTE PARA O COMERCIO'; valor: 5353),
    (labelStr: 'TRANSPORTE EMPRESA COMUNICAÇÃO'; valor: 5354),
    (labelStr: 'TRANSPORTE EMPRESA ENERGIA'; valor: 5355),
    (labelStr: 'TRANSPORTE PARA PRODUTOR RURAL'; valor: 5356),
    (labelStr: 'TRANSPORTE A NÃO CONTRIBUINTE'; valor: 5357),
    (labelStr: 'TRANSPORTE EM OUTRA UNIDADE FEDERAÇÃO'; valor: 5932),
    (labelStr: 'TRANSPORTE PARA MESMA NATUREZA'; valor: 6351),
    (labelStr: 'TRANSPORTE PARA A INDUSTRIA'; valor: 6352),
    (labelStr: 'TRANSPORTE PARA O COMERCIO'; valor: 6353),
    (labelStr: 'TRANSPORTE EMPRESA COMUNICAÇÃO'; valor: 6354),
    (labelStr: 'TRANSPORTE EMPRESA ENERGIA'; valor: 6355),
    (labelStr: 'TRANSPORTE PARA PRODUTOR RURAL'; valor: 6356),
    (labelStr: 'TRANSPORTE A NÃO CONTRIBUINTE'; valor: 6357),
    (labelStr: 'TRANSPORTE MERC.DISPENSADA EMISSAO NF'; valor: 6359),
    (labelStr: 'TRANSPORTE CONTRIB.SUBT.SERV.TRANSPORTE'; valor: 6360),
    (labelStr: 'TRANSPORTE EM OUTRA UNIDADE FEDERAÇÃO'; valor: 6932),
    (labelStr: 'PRESTAÇÃO DE SERVIÇO DE TRANSPORTE'; valor: 7358)
  );
var
  i: Integer;
begin
  Result := '';
  for i := Low(CFOPData) to High(CFOPData) do
  begin
    if CFOPData[i].valor = cfopCode then
    begin
      Result := CFOPData[i].labelStr;
      Break;
    end;
  end;
end;

function CidadeIBGE(cCidade,cEstado:String;qAUX:TSQLQuery):String;
begin
   qAUX.Close;
   qAUX.SQL.Text := 'SELECT ESTADO||CODIBGE AS CODIBGE '+
   'FROM TAB_ESTADOS E '+
   'LEFT JOIN TAB_CIDADES C ON C.ESTADO=E.CODIGO '+
   'WHERE E.SIGLA='+QuotedStr(UpperCase(cEstado))+' AND '+
   '(SELECT RETORNO FROM TIRA_ACENTOS(C.NOME))='+QuotedStr(UpperCase(TiraAcentos(cCidade)));
   qAUX.SQL.SaveToFile('sqlCodIBGE.txt');
   qAUX.Open;

   Result := qAUX.FieldByName('CODIBGE').AsString;
end;

function Divide(nFlo1:Double;nFlo2:Double):Double;
begin
   result := 0.00;
   if (nFlo1<>0.00) and (nFlo2<>0.00)  then
      result := nFlo1/nFlo2;
end;

function TrataMensagemExcept(cExcept:String):String;
begin
   Result := StringReplace(cExcept,'\',   '/',[rfReplaceAll, rfIgnoreCase]);
   Result := StringReplace(Result, #10,    '',[rfReplaceAll, rfIgnoreCase]);
   Result := StringReplace(Result, #13,    '',[rfReplaceAll, rfIgnoreCase]);
   Result := StringReplace(Result, '"',    '',[rfReplaceAll, rfIgnoreCase]);
   Result := StringReplace(Result, #10#13, '',[rfReplaceAll, rfIgnoreCase]);
   Result := StringReplace(Result, #9,     '',[rfReplaceAll, rfIgnoreCase]);
end;

function RemoveQuebrasDeTexto(cTexto:String):String;
begin
   Result := Trim(cTexto);
   Result := StringReplace(Result,'\',   '/',[rfReplaceAll, rfIgnoreCase]);
   Result := StringReplace(Result, #10,    '',[rfReplaceAll, rfIgnoreCase]);
   Result := StringReplace(Result, #13,    '',[rfReplaceAll, rfIgnoreCase]);
   Result := StringReplace(Result, #10#13, '',[rfReplaceAll, rfIgnoreCase]);
end;


procedure TWMSite.WMSiteactCteDownloadAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken : String;
   oReq : TJSONObject;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
   TCt  : TCTe;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TCt := TCte.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         oReq   := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else if(GetValueJSONObject('codigo',oReq) = '')then
            Response.Content := '{"erro":99,"mensagem":"Registro inválido"}'
         else begin
            Response.Content := TCt.Download(oReq,qUSU,cDB);
         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao enviar cte cliente:'+Request.QueryFields.Values['db']+' #erro:'+e.MEssage+sLineBreak+'sql:'+TCt.GetSql());
      end;
      end;
   finally
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      FreeAndNil(TCt);
   end;
end;



function HashMD5(cStr: String): string;
var
 idMd5:TIdHashMessageDigest5;
begin
  idMd5:=TIdHashMessageDigest5.Create;
  try
    result:= LowerCase(idMd5.HashStringAsHex(cStr));
  finally
    idMd5.Free;
  end;
end;
function SQLInteger(cSQL:String;qSTRING:TSQLQuery):Integer;
begin
   qSTRING.SQL.Clear;
   qSTRING.SQL.Add(cSQL);
   qSTRING.OPen;
   result := StrToNumI(qSTRING.Fields[0].AsString);
end;


procedure TWMSite.WMSiteactMdfeConsultaAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken :String;
   cRes : String;
   cReq : String;
   oReq : TJSONObject;
   TMdf : TMdfe;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
begin
   TMdf := TMdfe.Create;
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;
   try
      try
         cRes := '';
         cReq := Request.Content;

         if (Trim(cReq) = '')then
            cRes := '{"erro":1,"mensagem":"Nenhum parâmetro encontrado"}';

         if( not ValidaJSONObject(cReq))then begin
            cRes := '{"erro":1,"mensagem":"JSON Inválido"}';
            Response.StatusCode := 404;
         end;

         cToken := GetTokenBearer(Request.Authorization);

         oReq   := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else if(GetValueJSONObject('codigo',oReq) = '')then
            Response.Content := '{"erro":99,"mensagem":"Registro inválido"}'
         else begin
            // Response.Content := TMdf.consulta(oReq,qUSU,cDB);
         end;
      except on E: Exception do begin
         cRes := '{"erro":1,"mensagem":"Ocorreu algum erro, tente novamente mais tarde"}';
         GravaLog('Erro no login #Erro:'+e.Message+' SQL:'+TMdf.GetSql());
      end;
      end;
   finally
      FreeAndNil(TMdf);
      Response.Content := cRes;
   end;
end;


procedure TWMSite.WMSiteactMdfeConsultaGetAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken :String;
   cRes : String;
   cReq : String;
   TMdf : TMdfe;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
begin
   TMdf := TMdfe.Create;
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;
   try
      try
         cRes := '';

         if(Trim(Request.QueryFields.Values['codigo']) = '')then begin
            Response.Content := '{"erro":99,"mensagem":"Registro não encontrado"}';
            Exit;
         end;

         cToken := GetTokenBearer(Request.Authorization);

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else begin
            Response.Content := TMdf.Consulta(Request.QueryFields,qUSU);
         end;

      except on E: Exception do begin
         cRes := '{"erro":1,"mensagem":"Ocorreu algum erro, tente novamente mais tarde"}';
         GravaLog('Erro no consulta mdfe #Erro:'+e.Message+' SQL:'+TMdf.GetSql());
      end;
      end;
   finally
      FreeAndNil(TMdf);
   end;
end;

procedure TWMSite.WMSiteactMdfeDownloadAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken : String;
   oReq : TJSONObject;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
   TMdf : TMdfe;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TMdf := TMdfe.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         oReq   := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else if(GetValueJSONObject('codigo',oReq) = '')then
            Response.Content := '{"erro":99,"mensagem":"Registro inválido"}'
         else begin
            Response.Content := TMdf.Download(oReq,qUSU,cDB);
         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao gerar download mdfe cliente:'+Request.QueryFields.Values['db']+' #erro:'+e.MEssage+sLineBreak+'sql:'+TMdf.GetSql());
      end;
      end;
   finally
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      FreeAndNil(TMdf);
   end;
end;


procedure TWMSite.WMSiteactMdfeDownloadEncerramentoAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken : String;
   oReq : TJSONObject;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
   TMdf : TMdfe;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TMdf := TMdfe.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         oReq   := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else if(GetValueJSONObject('codigo',oReq) = '')then
            Response.Content := '{"erro":99,"mensagem":"Registro inválido"}'
         else begin
            Response.Content := TMdf.DownloadEncerramento(oReq,qUSU,cDB);
         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao gerar download encerramento mdfe cliente:'+Request.QueryFields.Values['db']+' #erro:'+e.MEssage+sLineBreak+'sql:'+TMdf.GetSql());
      end;
      end;
   finally
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      FreeAndNil(TMdf);
   end;
end;

procedure TWMSite.WMSiteactMdfeEnviarAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken : String;
   oReq : TJSONObject;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
   TMdf : TMdfe;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TMdf := TMdfe.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         oReq   := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else if(GetValueJSONObject('codigo',oReq) = '')then
            Response.Content := '{"erro":99,"mensagem":"Registro inválido"}'
         else begin
            Response.Content := TMdf.Envia(oReq,qUSU,cDB);
         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao enviar mdfe cliente:'+Request.QueryFields.Values['db']+' #erro:'+e.MEssage+sLineBreak+'sql:'+TMdf.GetSql());
      end;
      end;
   finally
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      FreeAndNil(TMdf);
   end;
end;

procedure TWMSite.WMSiteactCteCancelaAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken : String;
   oReq : TJSONObject;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
   TCt  : TCTe;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TCt := TCte.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         oReq   := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else if(GetValueJSONObject('codigo',oReq) = '')then
            Response.Content := '{"erro":99,"mensagem":"Registro inválido"}'
         else begin
            Response.Content := TCt.Cancela(oReq,qUSU,cDB);
         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao cancelar cte cliente:'+Request.QueryFields.Values['db']+' #erro:'+e.MEssage+sLineBreak+'sql:'+TCt.GetSql());
      end;
      end;
   finally
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      FreeAndNil(TCt);
   end;
end;


procedure TWMSite.WMSiteactCteEmailAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
   cToken : String;
   oReq : TJSONObject;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
   TCt  : TCTe;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TCt := TCte.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         oReq   := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else if(GetValueJSONObject('codigo',oReq) = '')or(GetValueJSONObject('email',oReq) = '')then
            Response.Content := '{"erro":1,"mensagem":"Parâmetros inválidos"}'
         else begin
            Response.Content := TCt.Email(oReq,qUSU,cDB);
         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao enviar email cte cliente:'+Request.QueryFields.Values['db']+' #erro:'+e.MEssage+sLineBreak+'sql:'+TCt.GetSql());
      end;
      end;
   finally
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      FreeAndNil(TCt);
   end;
end;

procedure TWMSite.WMSiteppCteCorrecaoEnviarAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken : String;
   oReq : TJSONObject;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
   TCt  : TCTe;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TCt := TCte.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         oReq   := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else if(GetValueJSONObject('evento',oReq) = '')then
            Response.Content := '{"erro":99,"mensagem":"Registro inválido"}'
         else begin
            Response.Content := TCt.CartaCorrecao(oReq,qUSU,cDB);
         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao cancelar cte cliente:'+Request.QueryFields.Values['db']+' #erro:'+e.MEssage+sLineBreak+'sql:'+TCt.GetSql());
      end;
      end;
   finally
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      FreeAndNil(TCt);
   end;
end;


procedure TWMSite.WMSiteactMdfeRegistraAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken: String;
   oReq  : TJSONObject;
   TMdf  : TMdfe;
   qUSU  : TSQLQuery;
   cDB   : TSQLConnection;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TMdf := TMdfe.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then begin
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}';
            exit;
         end;

         oReq := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         Response.Content := TMdf.Registra(oReq,qUSU,cDB);
      except on E: Exception do begin
         GravaLog('Erro ao registrar frete #erro:'+e.Message+sLineBreak+'#SQL:'+TMdf.GetSql);
         Response.Content := MensagemErroServer();
      end;
      end;
   finally
      FreeAndNil(TMdf);
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      oReq.DisposeOf;
   end;
end;
procedure TWMSite.WMSiteactMdfeSeguroEnviarAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken : String;
   oReq : TJSONObject;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
   TMdf : TMdfe;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TMdf := TMdfe.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         oReq   := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else if(GetValueJSONObject('codigo',oReq) = '')then
            Response.Content := '{"erro":99,"mensagem":"Registro inválido"}'
         else begin
            Response.Content := TMdf.EnviaSeguro(oReq,qUSU,cDB);
         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao averbar mdfe cliente:'+Request.QueryFields.Values['db']+' #erro:'+e.MEssage+sLineBreak+'sql:'+TMdf.GetSql());
      end;
      end;
   finally
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      FreeAndNil(TMdf);
   end;
end;

procedure TWMSite.WMSiteactMdfeStatusAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken : String;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
   TMdf : TMdfe;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TMdf := TMdfe.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else begin
            Response.Content := TMdf.Status(cDB);
         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao consultar status mdfe cliente:'+Request.QueryFields.Values['db']+' #erro:'+e.MEssage+sLineBreak+'sql:'+TMdf.GetSql());
      end;
      end;
   finally
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      FreeAndNil(TMdf);
   end;
end;

function ContaReg(qAUX:TSQLQuery):Integer;
begin
  qAUX.First;

  Result := 0;
  while not (qAUX.Eof) do begin
     Inc(Result);

     qAUX.Next;
  end;

  qAUX.First;
end;

function DigitoVerificador(Numero: Integer): Integer;
var sNum : string;
    wCodTotal: Word;
begin

  sNum := FormatFloat('000000000',Numero);
  wCodTotal := (strtoint(sNum[1])*5) + (strtoint(sNum[2])*9) + (strtoint(sNum[3])*5) +
               (strtoint(sNum[4])*4) + (strtoint(sNum[5])*8) + (strtoint(sNum[6])*4) +
               (strtoint(sNum[7])*3) + (strtoint(sNum[8])*7) + (strtoint(sNum[9])*3);


  wCodTotal := wCodTotal - ( wCodTotal div 11 * 11 );
  if  wCodTotal < 2 then
      sNum:=sNum+'0'
  else
      sNum:=sNum+inttostr(11 - wCodTotal);
  Result := strtoint(sNum);
end;

procedure TWMSite.WMSiteWebActionItem1Action(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken : String;
   oReq : TJSONObject;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
   TMdf : TMdfe;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TMdf := TMdfe.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         oReq   := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else if(GetValueJSONObject('codigo',oReq) = '')then
            Response.Content := '{"erro":99,"mensagem":"Registro inválido"}'
         else if(GetValueJSONObject('justificativa',oReq) = '')then
            Response.Content := '{"erro":99,"mensagem":"Justificativa inválida"}'
         else begin
            Response.Content := TMdf.Cancela(oReq,qUSU,cDB);
         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao cancelar mdfe cliente:'+Request.QueryFields.Values['db']+' #erro:'+e.MEssage+sLineBreak+'sql:'+TMdf.GetSql());
      end;
      end;
   finally
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      FreeAndNil(TMdf);
   end;
end;



procedure TWMSite.WMSiteactMdfeEmailAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken : String;
   oReq : TJSONObject;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
   TMdf : TMdfe;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TMdf := TMdfe.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         oReq   := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else if(GetValueJSONObject('codigo',oReq) = '')then
            Response.Content := '{"erro":99,"mensagem":"Registro inválido"}'
         else if(GetValueJSONObject('email',oReq) = '')then
            Response.Content := '{"erro":99,"mensagem":"Email de recebimento não informado"}'
         else begin
            Response.Content := TMdf.Email(oReq,qUSU,cDB);
         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao cancelar mdfe cliente:'+Request.QueryFields.Values['db']+' #erro:'+e.MEssage+sLineBreak+'sql:'+TMdf.GetSql());
      end;
      end;
   finally
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      FreeAndNil(TMdf);
   end;
end;


procedure TWMSite.WMSiteactEmpresaLogoAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cCod   : String;
   cToken : String;
   cDir   : String;
   cFile  : String;
   cCnpj  : String;
   nFile  : Integer;
   qREG   : TSQLQuery;
   qUSU   : TSQLQuery;
   cDB    : TSQLConnection;
begin
   qUSU := TSQLQuery.Create(Nil);
   qREG := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;
   qREG.SQLConnection := cDB;
   try
      try

         cToken := GetTokenBearer(Request.Authorization);

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else begin
            with TMultipartContentParser.Create(Request) do begin
               cDir := '.\clientes\logos\';
               if not(DirectoryExists(cDir)) then
                  ForceDirectories(cDir);

               cDir  := './clientes/logos/';
               cCnpj := soNumero(qUSU.FieldByName('CNPJ').AsString);

               cFile := '';

               // ExcluirArquivos(cDir+cCnpj);

               if(validaImagem(Request.Files[0].FileName))then begin
                  DeleteFile(PChar(cDir+cCnpj+'.png'));
                  DeleteFile(PChar(cDir+cCnpj+'.jpg'));
                  DeleteFile(PChar(cDir+cCnpj+'.jpeg'));

                  cFile := cDir  + cCnpj;
                  cFile := cFile + ExtractFileExt(Request.Files[0].FileName);

                  TMemoryStream(Request.Files[0].Stream).SaveToFile(cFile);
               end;

               Response.Content := '{"erro":1,"mensagem":"Nenhuma imagem anexada!"}';
               if(cFile <> '')then begin
                  qREG.Close;
                  qREG.SQL.Text := 'UPDATE PARAMETROS SET LOGOMARCA='+QuotedStr(cFile);
                  qREG.ExecSQL(False);

                  Response.Content := '{"erro":0,"mensagem":"Logomarca alterada com sucesso"}';
               end;

               Free;
            end;

         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao salvar logomarca cliente #erro:'+e.MEssage);
      end;
      end;
   finally
      FreeAndNil(qREG);
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
   end;
end;


procedure ExcluirArquivos(cName:String);
var
  SearchRec: TSearchRec;
begin
  try
     // Encontre o primeiro arquivo que corresponda ao nome desejado no diretório atual
     if FindFirst(cName + '.*', faAnyFile, SearchRec) = 0 then begin
        repeat
           // Exclua o arquivo encontrado
           // DeleteFile(SearchRec.Name);
        until FindNext(SearchRec) <> 0;

        // Limpe a estrutura SearchRec
        // FindClose(SearchRec);
     end;
  except on E: Exception do
  end;
end;


procedure TWMSite.WMSiteactMdfeEncerrarAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken : String;
   oReq : TJSONObject;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
   TMdf : TMdfe;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TMdf := TMdfe.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         oReq   := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else if(GetValueJSONObject('codigo',oReq) = '')then
            Response.Content := '{"erro":99,"mensagem":"Registro inválido"}'
         // else if(GetValueJSONObject('justificativa',oReq) = '')then
         //    Response.Content := '{"erro":99,"mensagem":"Justificativa inválida"}'
         else begin
            Response.Content := TMdf.Encerra(oReq,qUSU,cDB);
         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao encerrar mdfe cliente:'+Request.QueryFields.Values['db']+' #erro:'+e.MEssage+sLineBreak+'sql:'+TMdf.GetSql());
      end;
      end;
   finally
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      FreeAndNil(TMdf);
   end;
end;

procedure TWMSite.WMSiteactUsuarioRegistrarAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken: String;
   oReq  : TJSONObject;
   TUsu  : TUsuarios;
   qUSU  : TSQLQuery;
   cDB   : TSQLConnection;
begin
   try
      qUSU := TSQLQuery.Create(Nil);
      cDB  := TSQLConnection.Create(Nil);

      ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

      qUSU.SQLConnection := cDB;

      TUsu := TUsuarios.Create;

      try
         cToken := GetTokenBearer(Request.Authorization);

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then begin
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}';
            exit;
         end;

         oReq := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         Response.Content := TUsu.Registra(oReq,qUSU,cDB);
      except on E: Exception do begin
         GravaLog('Erro ao registrar usuário #erro:'+e.Message+sLineBreak+'#SQL:'+TUsu.GetSql);
         Response.Content := MensagemErroServer();
      end;
      end;
   finally
      FreeAndNil(TUsu);
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      oReq.DisposeOf;
   end;
end;

procedure TWMSite.WMSiteactEmpresaPerfilAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken: String;
   oReq  : TJSONObject;
   TEmp  : TEmpresas;
   qUSU  : TSQLQuery;
   cDB   : TSQLConnection;
begin
   try
      qUSU := TSQLQuery.Create(Nil);
      cDB  := TSQLConnection.Create(Nil);

      ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

      qUSU.SQLConnection := cDB;

      TEmp := TEmpresas.Create;

      try
         cToken := GetTokenBearer(Request.Authorization);

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then begin
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}';
            exit;
         end;

         oReq := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         Response.Content := TEmp.Perfil(oReq,qUSU,cDB);
      except on E: Exception do begin
         GravaLog('Erro ao atualizar perfil empresa #erro:'+e.Message+sLineBreak+'#SQL:'+TEmp.GetSql);
         Response.Content := MensagemErroServer();
      end;
      end;
   finally
      FreeAndNil(TEmp);
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      oReq.DisposeOf;
   end;
end;





function QuotedSan(cStr:String):String;
begin
   cStr   := StringReplace(cStr, '''', '''', [rfReplaceAll]);
   cStr   := StringReplace(cStr, '"', '',      [rfReplaceAll]);
   cStr   := UpperCase(cStr);
   result := QuotedStr(cStr);
end;

function TrataNumStr(cNum:String):String;
begin
  cNum := soNumero(cNum);

  if(Trim(cNum) = '')then begin
     Result := 'null';
     exit;
  end;

  Result := cNum;
end;

procedure TWMSite.WMSiteactClientesRegistrarAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken: String;
   oReq  : TJSONObject;
   TCli  : TClientes;
   qUSU  : TSQLQuery;
   cDB   : TSQLConnection;
begin
   try
      qUSU := TSQLQuery.Create(Nil);
      cDB  := TSQLConnection.Create(Nil);

      ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

      qUSU.SQLConnection := cDB;

      TCli := TClientes.Create;
      try
         cToken := GetTokenBearer(Request.Authorization);

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then begin
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}';
            exit;
         end;

         oReq := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         Response.Content := TCli.Registra(oReq,qUSU,cDB);
      except on E: Exception do begin
         GravaLog('Erro ao registrar cliente #erro:'+e.Message+sLineBreak+'#SQL:'+TCli.GetSql);
         Response.Content := MensagemErroServer();
      end;
      end;
   finally
      FreeAndNil(TCli);
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      oReq.DisposeOf;
   end;
end;




procedure TWMSite.WMSiteactProprietarioRegistrarAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken: String;
   oReq  : TJSONObject;
   TProp : TProprietarios;
   qUSU  : TSQLQuery;
   cDB   : TSQLConnection;
begin
   try
      qUSU := TSQLQuery.Create(Nil);
      cDB  := TSQLConnection.Create(Nil);

      ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

      qUSU.SQLConnection := cDB;

      TProp := TProprietarios.Create;
      try
         cToken := GetTokenBearer(Request.Authorization);

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then begin
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}';
            exit;
         end;

         oReq := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         Response.Content := TProp.Registra(oReq,qUSU,cDB);
      except on E: Exception do begin
         GravaLog('Erro ao registrar proprietários #erro:'+e.Message+sLineBreak+'#SQL:'+TProp.GetSql);
         Response.Content := MensagemErroServer();
      end;
      end;
   finally
      FreeAndNil(TProp);
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      oReq.DisposeOf;
   end;
end;


procedure TWMSite.WMSiteactFretesContratoAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken: String;
   oReq  : TJSONObject;
   TProp : TProprietarios;
   qUSU  : TSQLQuery;
   cDB   : TSQLConnection;
   // QRRelatorio : TQRRelatorio;
begin
   try
      {
      qUSU := TSQLQuery.Create(Nil);
      cDB  := TSQLConnection.Create(Nil);

      ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

      qUSU.SQLConnection := cDB;
      }

      //QRRelatorio := TQRRelatorio.Create(Nil);
      try
         cToken := GetTokenBearer(Request.Authorization);

         // LocalizaUsu(qUSU,cToken);

         // oReq := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;
         // if qUSU.Eof then begin
         //    Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}';
         //    exit;
         // end;

         // Response.Content := TProp.Registra(oReq,qUSU,cDB);

      except on E: Exception do begin
         GravaLog('Erro ao registrar proprietários #erro:'+e.Message+sLineBreak+'#SQL:'+TProp.GetSql);
         Response.Content := MensagemErroServer();
      end;
      end;
   finally
      //FreeAndNil(QRRelatorio);
      // FreeAndNil(qUSU);
      // FreeAndNil(cDB);
      // oReq.DisposeOf;
   end;
end;

procedure TWMSite.WMSiteactRecuperarSenhaAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cRes : String;
   cReq : String;
   oReq : TJSONObject;
   TEmp : TEmpresas;
begin
   TEmp := TEmpresas.Create;
   try
      try
         cRes := '';
         cReq := Request.Content;

         if (Trim(cReq) = '')then
            cRes := '{"erro":1,"mensagem":"Nenhum parâmetro encontrado"}';

         if( not ValidaJSONObject(cReq))then begin
            cRes := '{"erro":1,"mensagem":"JSON Inválido"}';
            Response.StatusCode := 404;
         end;

         oReq := TJSONObject.ParseJSONValue(cReq) AS TJSONObject;

         if Trim(Request.QueryFields.Values['db'])='' then
            cRes := '{"erro":1,"mensagem":"CNPJ não informado"}'
         else if Trim(GetValueJSONObject('login',oReq))='' then
            cRes := '{"erro":1,"mensagem":"Login inválido"}'
         else if Trim(GetValueJSONObject('cnpj',oReq))='' then
            cRes := '{"erro":1,"mensagem":"CNPJ inválido"}';

         if(cRes='')then
            cRes := TEmp.RecuperarSenha(oReq,Request.QueryFields);
      except on E: Exception do begin
         cRes := '{"erro":1,"mensagem":"Ocorreu algum erro, tente novamente mais tarde"}';

         if(Pos('Banco não configurado empresa',e.Message) <> 0)then
            cRes := '{"erro":0,"mensagem":"Solicitação enviada"}'
         else if(Pos('Email não validado',e.Message) <> 0)then
            cRes := '{"erro":2,"mensagem":"'+e.Message+'"}';

         GravaLog('Erro ao recuperar senha #Erro:'+e.Message+' SQL:'+TEmp.GetSql());
      end;
      end;
   finally
      FreeAndNil(TEmp);
      Response.Content := cRes;
   end;
end;





procedure TWMSite.WMSiteactTesteAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
   cToken : String;
   oReq : TJSONObject;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
   TMdf : TMdfe;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TMdf := TMdfe.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         oReq   := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

//         LocalizaUsu(qUSU,cToken);

//         if qUSU.Eof then
//            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
//         else if(GetValueJSONObject('codigo',oReq) = '')then
//            Response.Content := '{"erro":99,"mensagem":"Registro inválido"}'
//         else begin
            Response.Content := TMdf.ImprimePDFPorXMLEncerramento(oReq,qUSU,cDB);
//         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao gerar download encerramento mdfe cliente:'+Request.QueryFields.Values['db']+' #erro:'+e.MEssage+sLineBreak+'sql:'+TMdf.GetSql());
      end;
      end;
   finally
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      FreeAndNil(TMdf);
   end;
end;

procedure TWMSite.WMSiterecuperarsenhavalidatokenAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cRes : String;
   cReq : String;
   oReq : TJSONObject;
   TEmp : TEmpresas;
begin
   TEmp := TEmpresas.Create;
   try
      try
         cRes := '';
         cReq := Request.Content;

         if (Trim(cReq) = '') then
            cRes := '{"erro":1,"mensagem":"Nenhum parâmetro encontrado"}';

         if( not ValidaJSONObject(cReq))then begin
            cRes := '{"erro":1,"mensagem":"JSON Inválido"}';
            Response.StatusCode := 404;
         end;

         oReq := TJSONObject.ParseJSONValue(cReq) AS TJSONObject;

         if Trim(Request.QueryFields.Values['db'])='' then
            cRes := '{"erro":1,"mensagem":"CNPJ não informado"}'
         else if Trim(GetValueJSONObject('token',oReq))='' then
            cRes := '{"erro":1,"mensagem":"token inválido"}'
         else if Trim(GetValueJSONObject('cnpj',oReq))='' then
            cRes := '{"erro":1,"mensagem":"CNPJ inválido"}';

         if(cRes='')then
            cRes := TEmp.ValidaTokenRecuperarSenha(oReq,Request.QueryFields);
      except on E: Exception do begin
         cRes := '{"erro":1,"mensagem":"Ocorreu algum erro, tente novamente mais tarde"}';

         GravaLog('Erro ao validar token para alterar senha #Erro:'+e.Message+' SQL:'+TEmp.GetSql());
      end;
      end;
   finally
      FreeAndNil(TEmp);
      Response.Content := cRes;
   end;
end;

function EnviaCTeATM(nCod: Integer;qATM:TSQLQuery;cOp:String = 'E'):String;
var
    cPath : String;
    avAtm : ATMWebSvrPortType;
    retAtm : WideString;
    xmlCte : TStringList;
    sEmp,sFile,rData,rHora,rProt,rErro,rAver : String;
    oRet : averbaAtm.Retorno;
    oDad : averbaAtm.Array_Of_DadosSeguro;
    oErro: averbaAtm.ErrosProcesso;
    nE : Integer;
begin
   CoInitialize(nil);

   Result := '';

   qATM.Close;
   qATM.SQL.TExt := 'SELECT F.CODIGO,F.EMPRESA,F.CHAVECTE,P.PATHSALVAR,C.AVERBAR, '+
   'E.CNPJ '+
   'FROM FRETES F '+
   'LEFT JOIN PARAMETROS P ON P.EMPRESA=F.EMPRESA '+
   'LEFT JOIN EMPRESA E ON E.CODIGO=F.EMPRESA '+
   'LEFT JOIN CLIENTES C ON C.CODIGO=F.TOMADOR '+
   'WHERE F.CODIGO=0'+IntToStr(nCod);
   qATM.Open;

   if(qATM.FieldByName('AVERBAR').AsString = 'N')then begin
      Result := '{"erro":1,"mensagem":"Cliente não configurado para averbar"}';
      Exit;
   end;

   if(qATM.FieldByName('CHAVECTE').AsString = '')then begin
      Result := '{"erro":1,"mensagem":"CTe não enviado"}';
      Exit;
   end;

   if(qATM.FieldByName('AVERBAR').AsString = 'N')then begin
      Result := '{"erro":1,"mensagem":"Cliente não configurado para averbar"}';
      Exit;
   end;

   sEmp := qATM.FieldByName('EMPRESA').AsString;

   cPath := ExtractFilePath(ParamStr(0))+'clientes\CTe\'+soNumero(qATM.FieldByName('CNPJ').AsString)+'\';

   if cOp='E' then
      sFile := cPath + qATM.FieldByName('CHAVECTE').AsString+'-cte.xml'
   else
      sFile := cPath + '110111'+qATM.FieldByName('CHAVECTE').AsString+'01-procEventoCTe.xml';

   if not(FileExists(sFile)) then begin
      Result := '{"erro":1,"mensagem":"Erro na averbação: XML não encontrado"}';
      Exit;
   end;

   qATM.Close;
   qATM.SQL.Text := 'SELECT FIRST 1 ATM_USUARIO,ATM_SENHA,ATM_CODIGO FROM CONFIG';
   qATM.Open;

   xmlCte   := TStringList.create;
   oRet     := averbaAtm.Retorno.Create;
   try
      xmlCte.LoadFromFile(sFile);

      if (xmlCte.Text <> '') then begin
         avAtm := GetATMWebSvrPortType(False,'http://webserver.averba.com.br/20/index.soap');

         oRet  := avAtm.averbaCTe(qATM.FieldByName('ATM_USUARIO').AsSTring,
                               qATM.FieldByName('ATM_SENHA').AsSTring,
                               qATM.FieldByName('ATM_CODIGO').AsSTring,xmlCte.Text);


         oErro := oRet.Erros;

         if Length(oErro)>0 then begin
            retAtm:='';

            for nE:=0 to high(oErro) do begin
               retAtm := retAtm + 'Codigo:'+oErro[nE].Codigo+' Descrição:'+oErro[nE].Descricao;
               if oErro[nE].ValorEsperado<>'' then
                  retAtm := retAtm + 'Valor Esperado:'+oErro[nE].ValorEsperado+' Valor Informado:'+oErro[nE].ValorInformado;
            end;

            Result := '{"erro":1,"mensagem":"Erro na averbação: '+retAtm+'"}';
         end else begin
            rData := FormatDateTime('dd.mm.yyyy hh:MM.ss',oRet.Averbado.dhAverbacao.AsDateTime);
            rProt := oRet.Averbado.Protocolo;

            qATM.Close;
            if (cOp = 'E') then begin
               oDad  := oRet.Averbado.DadosSeguro;
               rAver := oDad[0].NumeroAverbacao;

               // atualiza numero averbação
               qATM.Close;
               qATM.SQL.Text := 'UPDATE FRETES SET AVERBACAO='+QuotedStr(Copy(rProt,1,40))+' WHERE CODIGO=0'+IntToStr(nCod);
               qATM.ExecSQL(False);

               qATM.Close;
               qATM.SQL.Text := 'UPDATE OR INSERT INTO FRETESATM (CODIGO,EMPRESA,DATA,PROTOCOLO,SITUACAO,AVERBACAO) '+
               'VALUES(0'+IntToStr(nCod)+',0'+sEmp+','+
               QuotedStr(rData)+','+
               QuotedSTr(rProt)+','+QuotedStr('AVERBADO')+','+
               QuotedStr(rAver)+')';

            end else begin
               qATM.Close;
               qATM.SQL.Text := 'UPDATE OR INSERT INTO FRETESATM (CODIGO,EMPRESA,CANC_DATA,CANC_PROT,SITUACAO) '+
               'VALUES(0'+IntToStr(nCod)+',0'+sEmp+','+
               QuotedStr(rData+' '+rHora)+','+
               QuotedSTr(rProt)+','+QuotedStr('CANCELADO')+')';
            end;
            qATM.ExecSQL(False);

            rData := FormatDateTime('dd/mm/yyyy hh:MM.ss',oRet.Averbado.dhAverbacao.AsDateTime);

            Result := '{'+
            '"erro":0,'+
            '"mensagem":"'+iif(cOp = 'E','CTe averbado com sucesso','Cancelamento de averbação realizado com sucesso')+'",'+
            '"codigo":"'+IntToStr(nCod)+'",'+
            '"data":"'+rData+'",'+
            '"protocolo":"'+rProt+'",'+
            '"averbacao":"'+rAver+'"'+
            '}';

         end;
      end;
   finally
      oRet.Free;
      xmlCte.Free;
   end;
end;

function EnviaMdfeATM(nCod: Integer;qATM:TSQLQuery;cOp:String = 'E'):String;
var
   avAtm  : ATMWebSvrPortType;
   retAtm : WideString;
   xmlCte : TStringList;
   sEmp,sDir,sFile,rData,rHora,rProt,rErro,rAver : String;
   oRet   : averbaAtm.RetornoMDFe;
   oDad   : averbaAtm.SuccessProcessoMDFe;
   oErro  : averbaAtm.ErrosProcesso;
   nE     : Integer;
   qAUX   : TSQLQUery;
begin
   CoInitialize(Nil);

   qAUX := TSQLQuery.Create(Nil);
   qAUX.SQLConnection := qATM.SQLConnection;
   try
      qATM.Close;
      qATM.SQL.Text := 'SELECT F.CODIGO,F.FRETE,F.EMPRESA,F.CHAVEMDFE,P.PATHSALVAR,F.DATA,'+
      'E.CNPJ '+
      'FROM FRETESMDF F '+
      'LEFT JOIN PARAMETROS P ON P.EMPRESA=F.EMPRESA '+
      'LEFT JOIN EMPRESA E ON E.CODIGO=F.EMPRESA '+
      'WHERE F.FRETE=0'+IntToStr(nCod);
      qATM.Open;


      if SQLString('SELECT PROTOCOLO FROM FRETESATM WHERE CODIGO=0'+qATM.FieldByName('FRETE').AsString,qAUX)='' then begin
         Result := '{"erro":1,"mensagem":"CTe sem protocolo de averbação"}';
         Exit;
      end;

      sEmp := qATM.FieldByName('EMPRESA').AsString;
      sDir := ExtractFilePath(ParamStr(0))+'clientes\MDFe\'+soNumero(qATM.FieldByName('CNPJ').AsString)+'\'+FormatDateTime('yyyymm',qATM.FieldByName('DATA').AsDateTime)+'\';

      if (cOp = 'E') then  // Envio
         sFile := sDir + 'MDFe\'+qATM.FieldByName('CHAVEMDFE').AsString+'-mdfe.xml'
      else if (cOp = 'B') then   // Baixa/Encerramento
         sFile := sDir + 'Evento\Encerramento\110112'+qATM.FieldByName('CHAVEMDFE').AsString+'01-procEventoMDFe.xml'
      else if (cOp = 'C') then   // Cancelamento
         sFile := sDir + 'Evento\Cancelamento\110111'+qATM.FieldByName('CHAVEMDFE').AsString+'01-procEventoMDFe.xml';

      if not(FileExists(sFile)) then begin
         Result := '{"erro":1,"mensagem":"XML não encontrado para averbação"}';
         Exit;
      end;

      qATM.Close;
      qATM.SQL.Text := 'SELECT ATM_USUARIO,ATM_SENHA,ATM_CODIGO FROM CONFIG';
      qATM.Open;

      xmlCte := TStringList.create;
      oRet   := averbaAtm.RetornoMDFe.Create;
      xmlCte.LoadFromFile(sFile);

      if (xmlCte.Text <> '') then begin
         avAtm := GetATMWebSvrPortType(False,'http://webserver.averba.com.br/20/index.soap');

         oRet  := avAtm.declaraMDFe(qATM.FieldByName('ATM_USUARIO').AsSTring,
                                 qATM.FieldByName('ATM_SENHA').AsSTring,
                                 qATM.FieldByName('ATM_CODIGO').AsSTring,xmlCte.Text);
         oErro := oRet.Erros;
         if Length(oErro)>0 then begin
            retAtm := '';

            for nE := 0 to High(oErro) do begin
               retAtm := retAtm+'Codigo:'+oErro[nE].Codigo+' Descrição:'+oErro[nE].Descricao;

               if (oErro[nE].ValorEsperado <> '') then
                  retAtm := retAtm + 'Valor Esperado:'+oErro[nE].ValorEsperado+' Valor Informado:'+oErro[nE].ValorInformado;
            end;

            Result := '{"erro":1,"mensagem":"Erro na declaração do seguro do mdfe: '+retAtm+'"}';
            Exit;
         end else begin
           rData := FormatDateTime('dd.mm.yyyy hh:MM:ss',oRet.Declarado.dhChancela.AsDateTime);
           rProt := oRet.Declarado.Protocolo;

           qATM.Close;
           qATM.SQL.Clear;
           if cOp='E' then

              qATM.SQL.Text := 'UPDATE FRETESATM SET '+
              'MDFEDATA='+Quotedstr(rData)+','+
              'MDFEPROT='+QuotedStr(rProt)+
              ' WHERE CODIGO=0'+IntToStr(nCod)

           else if cOp='B' then

              qATM.SQL.Text := 'UPDATE FRETESATM SET '+
              'MDFENCERRA_DATA='+Quotedstr(rData)+','+
              'MDFENCERRA_PROT='+QuotedStr(rProt)+
              ' WHERE CODIGO=0'+IntToStr(nCod)

           else if cOp='C' then

              qATM.SQL.Text := 'UPDATE FRETESATM SET '+
              'MDFCANCELA_DATA='+Quotedstr(rData)+','+
              'MDFCANCELA_PROT='+QuotedStr(rProt)+
              ' WHERE CODIGO=0'+IntToStr(nCod);

           if qATM.SQL.Count>0 then
               qATM.ExecSQL(False);

            rData := FormatDateTime('dd/mm/yyyy hh:MM:ss',oRet.Declarado.dhChancela.AsDateTime);

            Result := '{'+
            '"erro":0,'+
            '"mensagem":"MDFe averbado com sucesso",'+
            '"codigo":"'+IntToStr(nCod)+'",'+
            '"data":"'+rData+'",'+
            '"protocolo":"'+rProt+'",'+
            '"averbacao":"'+rAver+'"'+
            '}';
         end;
      end;
   finally
      FreeAndNil(qAUX);
      oRet.Free;
      xmlCte.Free;
   end;
end;

procedure TWMSite.WMSiteactAlterarSenhaAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cRes : String;
   cReq : String;
   oReq : TJSONObject;
   TEmp : TEmpresas;
begin
   TEmp := TEmpresas.Create;
   try
      try
         cRes := '';
         cReq := Request.Content;

         if (Trim(cReq) = '')then
            cRes := '{"erro":1,"mensagem":"Nenhum parâmetro encontrado"}';

         if( not ValidaJSONObject(cReq))then begin
            cRes := '{"erro":1,"mensagem":"JSON Inválido"}';
            Response.StatusCode := 404;
         end;

         oReq := TJSONObject.ParseJSONValue(cReq) AS TJSONObject;

         if Trim(Request.QueryFields.Values['db'])='' then
            cRes := '{"erro":1,"mensagem":"CNPJ não informado"}'
         else if Trim(GetValueJSONObject('token',oReq))='' then
            cRes := '{"erro":1,"mensagem":"token inválido"}'
         else if Trim(GetValueJSONObject('senha',oReq))='' then
            cRes := '{"erro":1,"mensagem":"Senha inválida"}'
         else if Trim(GetValueJSONObject('confirmaSenha',oReq))='' then
            cRes := '{"erro":1,"mensagem":"Confirmação inválida"}'
         else if (Trim(GetValueJSONObject('senha',oReq)).Length < 6)OR(Trim(GetValueJSONObject('confirmaSenha',oReq)).Length < 6) then
            cRes := '{"erro":1,"mensagem":"A senha deve ter pelo menos 6 caracteres"}'
         else if (Trim(GetValueJSONObject('senha',oReq)).Length > 12)OR(Trim(GetValueJSONObject('confirmaSenha',oReq)).Length > 12) then
            cRes := '{"erro":1,"mensagem":"A senha deve ter no máximo 12 caracteres"}'
         else if Trim(GetValueJSONObject('cnpj',oReq))='' then
            cRes := '{"erro":1,"mensagem":"CNPJ inválido"}';

         if(cRes='')then
            cRes := TEmp.AlterarSenha(oReq,Request.QueryFields);
      except on E: Exception do begin
         cRes := '{"erro":1,"mensagem":"Ocorreu algum erro, tente novamente mais tarde"}';

         GravaLog('Erro ao validar token para alterar senha #Erro:'+e.Message+' SQL:'+TEmp.GetSql());
      end;
      end;
   finally
      FreeAndNil(TEmp);
      Response.Content := cRes;
   end;
end;

procedure TWMSite.WMSiteactConfiguracoesSeguradorasAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken: String;
   oReq  : TJSONObject;
   TConf : TConfiguracoes;
   qUSU  : TSQLQuery;
   cDB   : TSQLConnection;
begin
   try
      qUSU := TSQLQuery.Create(Nil);
      cDB  := TSQLConnection.Create(Nil);

      ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

      qUSU.SQLConnection := cDB;

      TConf := TConfiguracoes.Create;
      try
         cToken := GetTokenBearer(Request.Authorization);

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then begin
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}';
            exit;
         end;

         oReq := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         Response.Content := TConf.RegistraSeguradora(oReq,qUSU,cDB);
      except on E: Exception do begin
         GravaLog('Erro ao registrar seguradora #erro:'+e.Message+sLineBreak+'#SQL:'+TConf.GetSql);
         Response.Content := MensagemErroServer();
      end;
      end;
   finally
      FreeAndNil(TConf);
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      oReq.DisposeOf;
   end;
end;

procedure TWMSite.WMSiteactConfiguracoesSeguradorasBuscaAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken: String;
   oReq  : TJSONObject;
   TConf : TConfiguracoes;
   qUSU  : TSQLQuery;
   cDB   : TSQLConnection;
begin
   try
      qUSU := TSQLQuery.Create(Nil);
      cDB  := TSQLConnection.Create(Nil);

      ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

      qUSU.SQLConnection := cDB;

      TConf := TConfiguracoes.Create;
      try
         cToken := GetTokenBearer(Request.Authorization);

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then begin
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}';
            exit;
         end;

         oReq := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         Response.Content := TConf.BuscaSeguradora(qUSU);
      except on E: Exception do begin
         GravaLog('Erro ao buscar seguradora #erro:'+e.Message+sLineBreak+'#SQL:'+TConf.GetSql);
         Response.Content := MensagemErroServer();
      end;
      end;
   finally
      FreeAndNil(TConf);
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      oReq.DisposeOf;
   end;
end;


procedure TWMSite.WMSiteactEnviaSeguroAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken : String;
   oReq : TJSONObject;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
   TCt  : TCTe;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TCt := TCte.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         oReq   := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else if(GetValueJSONObject('codigo',oReq) = '')then
            Response.Content := '{"erro":99,"mensagem":"Registro inválido"}'
         else begin
            Response.Content := TCt.EnviaSeguro(oReq,qUSU,cDB);
         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao averbar cte cliente:'+Request.QueryFields.Values['db']+' #erro:'+e.MEssage+sLineBreak+'sql:'+TCt.GetSql());
      end;
      end;
   finally
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      FreeAndNil(TCt);
   end;
end;

procedure TWMSite.WMSiteactCteSeguroAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken : String;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
   TCt  : TCTe;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TCt := TCte.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else if(Request.QueryFields.Values['codigo'] = '')then
            Response.Content := '{"erro":1,"mensagem":"Registro inválido"}'
         else begin
            Response.Content := TCt.BuscaFretesAtm(Request.QueryFields,qUSU);
         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao buscar averbacao cte cliente:'+Request.QueryFields.Values['db']+' #erro:'+e.MEssage+sLineBreak+'sql:'+TCt.GetSql());
      end;
      end;
   finally
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      FreeAndNil(TCt);
   end;
end;


procedure TWMSite.WMSiteactCteSeguroCancelarAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken : String;
   oReq : TJSONObject;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
   TCt  : TCTe;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TCt := TCte.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         oReq   := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else if(GetValueJSONObject('codigo',oReq) = '')then
            Response.Content := '{"erro":99,"mensagem":"Registro inválido"}'
         else begin
            Response.Content := TCt.EnviaSeguro(oReq,qUSU,cDB);
         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao averbar cte cliente:'+Request.QueryFields.Values['db']+' #erro:'+e.MEssage+sLineBreak+'sql:'+TCt.GetSql());
      end;
      end;
   finally
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      FreeAndNil(TCt);
   end;
end;


procedure TWMSite.WMSiteactFretesImportarXMLAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken: String;
   TFre  : TFretes;
   qUSU  : TSQLQuery;
   cDB   : TSQLConnection;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;
   TFre := TFretes.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then begin
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}';
            exit;
         end;

         if (Request.Content =  '') then begin
            Response.Content := '{"erro":1,"mensagem":"Nenhum dado informado"}';
            exit;
         end;

         // if(not ValidaXML(Request.Content))then begin
         //    Response.Content := '{"erro":1,"mensagem":"XML inválido"}';
         //    exit;
         // end;

         Response.Content := TFre.ImportarNFeXML(Request.Content,qUSU,cDB);
      except on E: Exception do begin
         GravaLog('Erro ao registrar frete #erro:'+e.Message+sLineBreak+'#SQL:'+TFre.GetSql);
         Response.Content := TrataExecept(e.Message);
      end;
      end;
   finally
      FreeAndNil(TFre);
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
   end;
end;

function TrataExecept(cEx:String):String;
begin
   Result := MensagemErroServer();
end;

function ValidaXML(const xmlText: string): Boolean;
var
  XMLDoc: IXMLDocument;
begin
   XMLDoc := TXMLDocument.Create(nil);
   try
      try
         XMLDoc.XML.Text := xmlText;

         // Verificar se o documento é válido
         XMLDoc.Active := True;

         // Se chegou até aqui, o XML é válido
         Result := True;
      except
         Result := False;
      end;
   finally
     FreeAndNil(XMLDoc);
   end;
end;

function FormataPlaca(vr: String): String;
begin
   result := '';
   if trim(vr)='' then
      exit;
   result := UpperCase(Copy(vr,1,3))+'-'+
   COpy(trim(UpperCase(StringReplace(Copy(vr,4,5),'-','',[rfReplaceAll]))),1,4);
end;

function FormataCep(vr:String):String;
begin
   result := SoNumero(vr);
   if trim(result)='' then
      exit;
   result := Copy(vr,1,5)+'-'+Copy(vr,6,3);
end;


function GeraNomeRed(ncm: string; ncmData: TStringList): string;
var
  i: Integer;
  ncmCode, ncmName: string;
  currentPrefix: string;
begin
   // Inicializa o valor padrão do resultado
   Result := 'Nome Reduzido não encontrado';

   currentPrefix := '';

   // Percorre as linhas da tabela de dados
   for i := 0 to ncmData.Count - 1 do begin
      // Divide a linha em partes usando o caractere de tabulação como separador
      ncmCode := Trim(Copy(ncmData[i], 1, Pos(#9, ncmData[i]) - 1));
      ncmName := Trim(Copy(ncmData[i], Pos(#9, ncmData[i]) + 1, Length(ncmData[i])));

      // Atualiza o prefixo atual para o NCM
      if Length(ncmCode) < Length(currentPrefix) then
         currentPrefix := Copy(currentPrefix, 1, Length(ncmCode));

      // Preenche o dicionário com o mapeamento NCM para nome reduzido
      if ncmCode = ncm then begin
         Result := ncmName;
         Break;
      end;
   end;
end;

procedure TWMSite.WMSiteactEmpresaPlanoAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken: String;
   TEmp  : TEmpresas;
   qUSU  : TSQLQuery;
   cDB   : TSQLConnection;
begin
   try
      qUSU := TSQLQuery.Create(Nil);
      cDB  := TSQLConnection.Create(Nil);

      ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

      qUSU.SQLConnection := cDB;

      TEmp := TEmpresas.Create;

      try
         cToken := GetTokenBearer(Request.Authorization);

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then begin
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}';
            exit;
         end;

         Response.Content := TEmp.BuscaPlano(qUSU);
      except on E: Exception do begin
         GravaLog('Erro ao buscar plano empresa #erro:'+e.Message+sLineBreak+'#SQL:'+TEmp.GetSql);
         Response.Content := MensagemErroServer();
      end;
      end;
   finally
      FreeAndNil(TEmp);
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
   end;
end;

function VerificaLimiteEmissoes(qUSU:TSQLQuery):Boolean;
var
   qREG : TSQLQuery;
   qAUX : TSQLQuery;
   cDB  : TSQLConnection;
begin
   qAUX := TSQLQUery.Create(Nil);
   qREG := TSQLQUery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfConexao(cDB);

   qAUX.SQLConnection := qUSU.SQLConnection;
   qREG.SQLConnection := cDB;
   try
      Result := false;

      qREG.Close;
      qREG.SQL.Text := 'SELECT P.CODIGO AS PLANO_ID,COALESCE(P.QUANTIDADE,0) AS QUANTIDADE,'+
      'P.TITULO,P.VALOR  '+
      'FROM EMPRESAS E '+
      'LEFT JOIN PLANOS P ON P.CODIGO=E.PLANO '+
      'WHERE E.CNPJ='+QuotedStr(SoNumero(qUSU.FieldByName('CNPJ').AsString));
      sql := qREG.SQL.Text;
      qREG.Open;

      qAUX.Close;
      qAUX.SQL.Text := 'SELECT FIRST 1 '+
      '(SELECT COUNT(CODIGO) FROM FRETES WHERE CHAVECTE<>''''  AND DATA >= '+QuotedStr(FormatDateTime('01.mm.yyyy',now))+')+'+
      '(SELECT COUNT(CODIGO)FROM FRETESMDF WHERE ITEM = 1  AND (STATUS = ''E'') AND DATA >= '+QuotedStr(FormatDateTime('01.mm.yyyy',now))+') AS EMISSOES '+
      'FROM PARAMETROS ';
      qAUX.Open;

      if((qREG.FieldByName('QUANTIDADE').AsInteger - qAUX.FieldByName('EMISSOES').AsInteger + 1) > 0)then
         Result := true;

   finally
      FreeAndNil(qREG);
      FreeAndNil(qAUX);
      FreeAndNil(cDB);
   end;
end;
procedure TWMSite.WMSiteactAmigoAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
  qREG  : TSQLQuery;
  cDB   : TSQLConnection;
  cPg   : String;
  nReg  : Integer;
  nRec  : Integer;
  cNome : String;
  cFone : String;
  cAmigo: String;

begin
   cDB  := TSQLConnection.Create(nil);
   ConfConexao(cDB);
   qREG := TSQLQuery.Create(nil);
   qREG.SQLConnection:=cDB;

   try
      try
         qREG.SQL.Text := 'COMMIT WORK';
         qREG.ExecSQL(False);

         qREG.SQL.Text := 'SELECT * FROM AMIGO WHERE ID='+QuotedStr(Request.QueryFields.Values['id']);
         qREG.Open;
         if qREG.eof then begin
            cPg := 'Não Encontrado';
            exit;
         end;

         cNome := qREG.FieldByName('NOME').AsString;
         cFone := qREG.FieldByName('TELEFONE').AsString;

         // se veio o parametro é para descobrir o amigo
         if (Request.QueryFields.Values['descobrir']<>'') and (qREG.FieldByName('AMIGO').AsString='') then begin
            qREG.SQL.Text := 'SELECT A.* FROM AMIGO A'+
            ' WHERE A.NOME<>'+QuotedStr(cNome)+
            //' AND (SELECT B.NOME FROM AMIGO B WHERE B.AMIGO=A.NOME) IS NULL';
            ' AND (SELECT B.NOME FROM AMIGO B WHERE B.AMIGO=REVERSE(A.ID)) IS NULL';
            qREG.Open;

            if qREG.eof then
               raise Exception.Create('Fim de amigos');
            nReg:=0;
            while not(qREG.eof) do begin
              inc(nReg);
              qREG.Next;
            end;
            qREG.Close;
            qREG.Open;

            if nReg>1 then begin
               nReg:=RandomRange(1, nREG);

               nRec:=0;
               while not(qREG.eof) and (nRec<nReg) do begin
                 inc(nRec);
                 qREG.Next;
               end;
            end;

            cAmigo:=qREG.FieldByName('ID').AsString;
            qREG.SQL.Text := 'UPDATE AMIGO SET AMIGO=REVERSE('+QuotedStr(cAmigo)+')'+
            ' WHERE NOME='+QuotedStr(cNome);
            qREG.ExecSQL(False);
         end;

         qREG.SQL.Text := 'SELECT A.*,(SELECT NOME FROM AMIGO WHERE ID=REVERSE(A.AMIGO)) AS AMIGONOME '+
         'FROM AMIGO A WHERE A.ID='+QuotedStr(Request.QueryFields.Values['id']);
         qREG.Open;

         cPg:='<span class="fs-3 fw-bold text-light">'+
         'OLA '+qREG.FieldByName('NOME').AsString+'</span>';
         cPg:=cPg+'<div class="border p-4 mt-2 rounded"><span class="fs-4 fw-light text-light">';

         if not(qREG.eof) then begin
            if qREG.FieldByName('AMIGO').AsString='' then
               cPg:=cPg+'<button id="queme" type="button" class="btn btn-Default" '+
               'onClick="window.location.href='+QuotedStr('/amigo?id='+Request.QueryFields.Values['id']+'&descobrir=0')+';">Sortear Amigo</button>'
            else
               cPg:=cPg+'SEU AMIGO É '+qREG.FieldByName('AMIGONOME').AsString;
         end else
            cPg:=cPg+'Numero não encontrado';
         cPg:=cPg+'</span></div>';


         cPg:=cPg+'<div class="border p-4 mt-2 rounded">';
         cPg:=cPg+'<span class="fs-4 fw-light text-light">Para o seu amigo</span> ';
         cPg:=cPg+'</div>';

         cPg:=cPg+'<div class="border p-4 mt-2 rounded">';
         cPg:=cPg+'<span class="fs-4 fw-light text-light">Do seu amigo</span> ';
         cPg:=cPg+'</div>';

      except on E: Exception do
         cPg:= e.message;
      end;
   finally
      qREG.Close;
      cDB.Close;
      FreeAndNil(qREG);
      FreeAndNil(cDB);

      cPg:='<!DOCTYPE html>'+
           '<html lang="pt">'+
           '<head>'+
           '   <meta charset="UTF-8">'+
           '   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">'+
           '   <meta name="description" content="">'+
           '   <meta name="" content="">'+
           '   <title>Amigo Secreto</title>'+
           '   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">'+
           '   <style>'+
           '       html, body {'+
           '           height: 100%;'+
           '           margin: 0;'+
           '       }'+
           '   </style>'+
           '</head>'+
           '<body>'+
           '<div class="p-2 bg-light d-flex flex-column justify-content-center align-items-center" style="width: 100%; height: 100%;">'+
           '<div class=" card d-flex flex-column justify-content-center align-items-center mt-4" style="height: 600px; width: 90%; background-color:rgba(21, 92, 162, 0.5);">'+
           '<span class="fs-1 fw-bold text-light">FAMILIA RODRIGUES</span>'+
           '<span class="fs-4 fw-light text-light">Amigo Secreto 2023</span> '+
             cPg+
           '</div>'+
           '<script>'+
            'src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous">'+
           '</script>'+
           '</body>'+
           '</html>';

      Response.Content := cPg;

   end;
end;

procedure Commita(qREG:TSQLQuery);
begin
   qREG.Close;
   qREG.SQL.Text := 'COMMIT WORK;';
   qREG.ExecSQL(False);
end;

function PegaDataHoraPorEstado(cUf:String):TDateTime;
var nDif : Integer;
begin
   if (MatchStr(cUf,['RO','MT','MS','AM','RR'])) then
      nDif := 0 // não incrementa hora [UTC - 04]
   else if (MatchStr(cUf,['AC'])) then
      nDif := -1 // retorna uma hora [UTC - 05]
   else
      nDif := 1; // incrementa uma hora padrão brazilia  [UTC - 03]

   Result := IncHour(now, nDif);
end;


procedure TWMSite.WMSiteactImprimindoCartaAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken : String;
   oReq : TJSONObject;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
   TCt  : TCTe;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TCt := TCte.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         oReq   := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
//         else if(GetValueJSONObject('evento',oReq) = '')then
//            Response.Content := '{"erro":99,"mensagem":"Registro inválido"}'
         else begin
            Response.Content := TCt.ImprimirCorrecao(oReq,qUSU,cDB);
         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao imprimir carta de correção cliente:'+Request.QueryFields.Values['db']+' #erro:'+e.MEssage+sLineBreak+'sql:'+TCt.GetSql());
      end;
      end;
   finally
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      FreeAndNil(TCt);
   end;
end;

procedure TWMSite.WMSiteactVeiculosRegistrarAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken: String;
   oReq  : TJSONObject;
   TVei  : TVeiculos;
   qUSU  : TSQLQuery;
   cDB   : TSQLConnection;
begin
   try
      qUSU := TSQLQuery.Create(Nil);
      cDB  := TSQLConnection.Create(Nil);

      ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

      qUSU.SQLConnection := cDB;

      TVei := TVeiculos.Create;
      try
         cToken := GetTokenBearer(Request.Authorization);

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then begin
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}';
            exit;
         end;

         oReq := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         Response.Content := TVei.Registra(oReq,qUSU,cDB);
      except on E: Exception do begin
         GravaLog('Erro ao registrar veiculos #erro:'+e.Message+sLineBreak+'#SQL:'+TVei.GetSql);
         Response.Content := MensagemErroServer();
      end;
      end;
   finally
      FreeAndNil(TVei);
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      oReq.DisposeOf;
   end;
end;

function AmbienteTeste():Boolean;
begin
   Result := false;
   if FileExists('AmbienteTeste.txt') then
      Result := true;

end;

procedure TWMSite.WMSiteactCteConsultaSefazAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken : String;
   oReq : TJSONObject;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
   TCt  : TCTe;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TCt := TCte.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         oReq   := TJSONObject.ParseJSONValue(Request.Content) AS TJSONObject;

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else if(GetValueJSONObject('codigo',oReq) = '')then
            Response.Content := '{"erro":99,"mensagem":"Registro inválido"}'
         else begin
            Response.Content := TCt.ConsultaSEFAZ(oReq,qUSU,cDB);
         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao consultar cte  na SEFAZ cliente:'+Request.QueryFields.Values['db']+' #erro:'+e.MEssage+sLineBreak+'sql:'+TCt.GetSql());
      end;
      end;
   finally
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      FreeAndNil(TCt);
   end;
end;

procedure TWMSite.WMSiteactRelCadClientesAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
   cToken : String;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
   TRel  : TRelatoriosCadastrais;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TRel := TRelatoriosCadastrais.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else begin
            if (Request.QueryFields.Values['modo'] = 'clientes') then
               Response.Content := TRel.Clientes(Request.QueryFields,qUSU)
            else if (Request.QueryFields.Values['modo'] = 'fornecedores') then
               Response.Content := TRel.Fornecedores(Request.QueryFields,qUSU)
            else if (Request.QueryFields.Values['modo'] = 'motoristas') then
               Response.Content := TRel.Motoristas(Request.QueryFields,qUSU)
            else if (Request.QueryFields.Values['modo'] = 'proprietarios') then
               Response.Content := TRel.Proprietarios(Request.QueryFields,qUSU)
            else if (Request.QueryFields.Values['modo'] = 'veiculos') then
               Response.Content := TRel.Veiculos(Request.QueryFields,qUSU)
            else if (Request.QueryFields.Values['modo'] = 'produtos') then
               Response.Content := TRel.Produtos(Request.QueryFields,qUSU);
         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao consultar cte  na SEFAZ cliente:'+Request.QueryFields.Values['db']+' #erro:'+e.MEssage+sLineBreak+'sql:'+TRel.GetSql());
      end;
      end;
   finally
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      FreeAndNil(TRel);
   end;
end;
procedure TWMSite.WMSiteactRelOperAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
   cToken : String;
   qUSU : TSQLQuery;
   cDB  : TSQLConnection;
   TRel  : TRelatoriosCadastrais;
begin
   qUSU := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(Nil);

   ConfiguraConexao(Request.QueryFields.Values['db'],cDB);

   qUSU.SQLConnection := cDB;

   TRel := TRelatoriosCadastrais.Create;
   try
      try
         cToken := GetTokenBearer(Request.Authorization);

         LocalizaUsu(qUSU,cToken);

         if qUSU.Eof then
            Response.Content := '{"erro":99,"mensagem":"Usuário não encontrado"}'
         else begin
            Request.QueryFields.SaveToFile('tags.txt');
//            if (Request.QueryFields.Values['modo'] = 'clientes') then
//               Response.Content := TRel.Clientes(Request.QueryFields,qUSU)
//            else if (Request.QueryFields.Values['modo'] = 'fornecedores') then
//               Response.Content := TRel.Fornecedores(Request.QueryFields,qUSU)
//            else if (Request.QueryFields.Values['modo'] = 'motoristas') then
//               Response.Content := TRel.Motoristas(Request.QueryFields,qUSU)
//            else if (Request.QueryFields.Values['modo'] = 'proprietarios') then
//               Response.Content := TRel.Proprietarios(Request.QueryFields,qUSU)
//            else if (Request.QueryFields.Values['modo'] = 'veiculos') then
//               Response.Content := TRel.Veiculos(Request.QueryFields,qUSU)
//            else if (Request.QueryFields.Values['modo'] = 'produtos') then
//               Response.Content := TRel.Produtos(Request.QueryFields,qUSU);
         end;
      except on E: Exception do begin
         Response.Content := MensagemErroServer;
         GravaLog('Erro ao consultar cte  na SEFAZ cliente:'+Request.QueryFields.Values['db']+' #erro:'+e.MEssage+sLineBreak+'sql:'+TRel.GetSql());
      end;
      end;
   finally
      FreeAndNil(qUSU);
      FreeAndNil(cDB);
      FreeAndNil(TRel);
   end;
end;

initialization

finalization
  Web.WebReq.FreeWebModules;
end.



