// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://webserver.averba.com.br/20/index.soap?wsdl
//  >Import : http://webserver.averba.com.br/20/index.soap?wsdl>0
// Encoding : ISO-8859-1
// Version  : 1.0
// (31/10/2023 11:01:49 - - $Rev: 90173 $)
// ************************************************************************ //

unit averbaATM;

interface

uses Soap.InvokeRegistry, Soap.SOAPHTTPClient, System.Types, Soap.XSBuiltIns;

const
  IS_OPTN = $0001;
  IS_UNBD = $0002;
  IS_UNQL = $0008;


type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Embarcadero types; however, they could also
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:integer         - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:dateTime        - "http://www.w3.org/2001/XMLSchema"[Gbl]

  RetornoMDFe          = class;                 { "urn:ATMWebSvr"[GblCplx] }
  InfoProcesso         = class;                 { "urn:ATMWebSvr"[GblCplx] }
  Retorno              = class;                 { "urn:ATMWebSvr"[GblCplx] }
  ErroProcesso         = class;                 { "urn:ATMWebSvr"[GblCplx] }
  SuccessProcessoMDFe  = class;                 { "urn:ATMWebSvr"[GblCplx] }
  SuccessProcesso      = class;                 { "urn:ATMWebSvr"[GblCplx] }
  DadosSeguro          = class;                 { "urn:ATMWebSvr"[GblCplx] }

  InfosProcesso = array of InfoProcesso;        { "urn:ATMWebSvr"[GblCplx] }
  Array_Of_DadosSeguro = array of DadosSeguro;   { "urn:ATMWebSvr"[GblUbnd] }
  ErrosProcesso = array of ErroProcesso;        { "urn:ATMWebSvr"[GblCplx] }


  // ************************************************************************ //
  // XML       : RetornoMDFe, global, <complexType>
  // Namespace : urn:ATMWebSvr
  // ************************************************************************ //
  RetornoMDFe = class(TRemotable)
  private
    FNumero: string;
    FSerie: string;
    FFilial: string;
    FErros: ErrosProcesso;
    FErros_Specified: boolean;
    FDeclarado: SuccessProcessoMDFe;
    FDeclarado_Specified: boolean;
    FInfos: InfosProcesso;
    FInfos_Specified: boolean;
    procedure SetErros(Index: Integer; const AErrosProcesso: ErrosProcesso);
    function  Erros_Specified(Index: Integer): boolean;
    procedure SetDeclarado(Index: Integer; const ASuccessProcessoMDFe: SuccessProcessoMDFe);
    function  Declarado_Specified(Index: Integer): boolean;
    procedure SetInfos(Index: Integer; const AInfosProcesso: InfosProcesso);
    function  Infos_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property Numero:    string               Index (IS_UNQL) read FNumero write FNumero;
    property Serie:     string               Index (IS_UNQL) read FSerie write FSerie;
    property Filial:    string               Index (IS_UNQL) read FFilial write FFilial;
    property Erros:     ErrosProcesso        Index (IS_OPTN or IS_UNQL) read FErros write SetErros stored Erros_Specified;
    property Declarado: SuccessProcessoMDFe  Index (IS_OPTN or IS_UNQL) read FDeclarado write SetDeclarado stored Declarado_Specified;
    property Infos:     InfosProcesso        Index (IS_OPTN or IS_UNQL) read FInfos write SetInfos stored Infos_Specified;
  end;



  // ************************************************************************ //
  // XML       : InfoProcesso, global, <complexType>
  // Namespace : urn:ATMWebSvr
  // ************************************************************************ //
  InfoProcesso = class(TRemotable)
  private
    FCodigo: string;
    FDescricao: string;
  published
    property Codigo:    string  Index (IS_UNQL) read FCodigo write FCodigo;
    property Descricao: string  Index (IS_UNQL) read FDescricao write FDescricao;
  end;



  // ************************************************************************ //
  // XML       : Retorno, global, <complexType>
  // Namespace : urn:ATMWebSvr
  // ************************************************************************ //
  Retorno = class(TRemotable)
  private
    FNumero: string;
    FSerie: string;
    FFilial: string;
    FCNPJCli: string;
    FCNPJCli_Specified: boolean;
    FTpDoc: Int64;
    FTpDoc_Specified: boolean;
    FInfAdic: string;
    FInfAdic_Specified: boolean;
    FErros: ErrosProcesso;
    FErros_Specified: boolean;
    FAverbado: SuccessProcesso;
    FAverbado_Specified: boolean;
    FInfos: InfosProcesso;
    FInfos_Specified: boolean;
    procedure SetCNPJCli(Index: Integer; const Astring: string);
    function  CNPJCli_Specified(Index: Integer): boolean;
    procedure SetTpDoc(Index: Integer; const AInt64: Int64);
    function  TpDoc_Specified(Index: Integer): boolean;
    procedure SetInfAdic(Index: Integer; const Astring: string);
    function  InfAdic_Specified(Index: Integer): boolean;
    procedure SetErros(Index: Integer; const AErrosProcesso: ErrosProcesso);
    function  Erros_Specified(Index: Integer): boolean;
    procedure SetAverbado(Index: Integer; const ASuccessProcesso: SuccessProcesso);
    function  Averbado_Specified(Index: Integer): boolean;
    procedure SetInfos(Index: Integer; const AInfosProcesso: InfosProcesso);
    function  Infos_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property Numero:   string           Index (IS_UNQL) read FNumero write FNumero;
    property Serie:    string           Index (IS_UNQL) read FSerie write FSerie;
    property Filial:   string           Index (IS_UNQL) read FFilial write FFilial;
    property CNPJCli:  string           Index (IS_OPTN or IS_UNQL) read FCNPJCli write SetCNPJCli stored CNPJCli_Specified;
    property TpDoc:    Int64            Index (IS_OPTN or IS_UNQL) read FTpDoc write SetTpDoc stored TpDoc_Specified;
    property InfAdic:  string           Index (IS_OPTN or IS_UNQL) read FInfAdic write SetInfAdic stored InfAdic_Specified;
    property Erros:    ErrosProcesso    Index (IS_OPTN or IS_UNQL) read FErros write SetErros stored Erros_Specified;
    property Averbado: SuccessProcesso  Index (IS_OPTN or IS_UNQL) read FAverbado write SetAverbado stored Averbado_Specified;
    property Infos:    InfosProcesso    Index (IS_OPTN or IS_UNQL) read FInfos write SetInfos stored Infos_Specified;
  end;



  // ************************************************************************ //
  // XML       : ErroProcesso, global, <complexType>
  // Namespace : urn:ATMWebSvr
  // ************************************************************************ //
  ErroProcesso = class(TRemotable)
  private
    FCodigo: string;
    FDescricao: string;
    FValorEsperado: string;
    FValorEsperado_Specified: boolean;
    FValorInformado: string;
    FValorInformado_Specified: boolean;
    procedure SetValorEsperado(Index: Integer; const Astring: string);
    function  ValorEsperado_Specified(Index: Integer): boolean;
    procedure SetValorInformado(Index: Integer; const Astring: string);
    function  ValorInformado_Specified(Index: Integer): boolean;
  published
    property Codigo:         string  Index (IS_UNQL) read FCodigo write FCodigo;
    property Descricao:      string  Index (IS_UNQL) read FDescricao write FDescricao;
    property ValorEsperado:  string  Index (IS_OPTN or IS_UNQL) read FValorEsperado write SetValorEsperado stored ValorEsperado_Specified;
    property ValorInformado: string  Index (IS_OPTN or IS_UNQL) read FValorInformado write SetValorInformado stored ValorInformado_Specified;
  end;



  // ************************************************************************ //
  // XML       : SuccessProcessoMDFe, global, <complexType>
  // Namespace : urn:ATMWebSvr
  // ************************************************************************ //
  SuccessProcessoMDFe = class(TRemotable)
  private
    FdhChancela: TXSDateTime;
    FProtocolo: string;
  public
    destructor Destroy; override;
  published
    property dhChancela: TXSDateTime  Index (IS_UNQL) read FdhChancela write FdhChancela;
    property Protocolo:  string       Index (IS_UNQL) read FProtocolo write FProtocolo;
  end;



  // ************************************************************************ //
  // XML       : SuccessProcesso, global, <complexType>
  // Namespace : urn:ATMWebSvr
  // ************************************************************************ //
  SuccessProcesso = class(TRemotable)
  private
    FdhAverbacao: TXSDateTime;
    FProtocolo: string;
    FDadosSeguro: Array_Of_DadosSeguro;
    FDadosSeguro_Specified: boolean;
    procedure SetDadosSeguro(Index: Integer; const AArray_Of_DadosSeguro: Array_Of_DadosSeguro);
    function  DadosSeguro_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property dhAverbacao: TXSDateTime           Index (IS_UNQL) read FdhAverbacao write FdhAverbacao;
    property Protocolo:   string                Index (IS_UNQL) read FProtocolo write FProtocolo;
    property DadosSeguro: Array_Of_DadosSeguro  Index (IS_OPTN or IS_UNBD or IS_UNQL) read FDadosSeguro write SetDadosSeguro stored DadosSeguro_Specified;
  end;



  // ************************************************************************ //
  // XML       : DadosSeguro, global, <complexType>
  // Namespace : urn:ATMWebSvr
  // ************************************************************************ //
  DadosSeguro = class(TRemotable)
  private
    FNumeroAverbacao: string;
    FCNPJSeguradora: string;
    FCNPJSeguradora_Specified: boolean;
    FNomeSeguradora: string;
    FNomeSeguradora_Specified: boolean;
    FNumApolice: string;
    FNumApolice_Specified: boolean;
    FTpMov: string;
    FTpMov_Specified: boolean;
    FTpDDR: string;
    FTpDDR_Specified: boolean;
    FValorAverbado: string;
    FValorAverbado_Specified: boolean;
    FRamoAverbado: string;
    FRamoAverbado_Specified: boolean;
    procedure SetCNPJSeguradora(Index: Integer; const Astring: string);
    function  CNPJSeguradora_Specified(Index: Integer): boolean;
    procedure SetNomeSeguradora(Index: Integer; const Astring: string);
    function  NomeSeguradora_Specified(Index: Integer): boolean;
    procedure SetNumApolice(Index: Integer; const Astring: string);
    function  NumApolice_Specified(Index: Integer): boolean;
    procedure SetTpMov(Index: Integer; const Astring: string);
    function  TpMov_Specified(Index: Integer): boolean;
    procedure SetTpDDR(Index: Integer; const Astring: string);
    function  TpDDR_Specified(Index: Integer): boolean;
    procedure SetValorAverbado(Index: Integer; const Astring: string);
    function  ValorAverbado_Specified(Index: Integer): boolean;
    procedure SetRamoAverbado(Index: Integer; const Astring: string);
    function  RamoAverbado_Specified(Index: Integer): boolean;
  published
    property NumeroAverbacao: string  Index (IS_UNQL) read FNumeroAverbacao write FNumeroAverbacao;
    property CNPJSeguradora:  string  Index (IS_OPTN or IS_UNQL) read FCNPJSeguradora write SetCNPJSeguradora stored CNPJSeguradora_Specified;
    property NomeSeguradora:  string  Index (IS_OPTN or IS_UNQL) read FNomeSeguradora write SetNomeSeguradora stored NomeSeguradora_Specified;
    property NumApolice:      string  Index (IS_OPTN or IS_UNQL) read FNumApolice write SetNumApolice stored NumApolice_Specified;
    property TpMov:           string  Index (IS_OPTN or IS_UNQL) read FTpMov write SetTpMov stored TpMov_Specified;
    property TpDDR:           string  Index (IS_OPTN or IS_UNQL) read FTpDDR write SetTpDDR stored TpDDR_Specified;
    property ValorAverbado:   string  Index (IS_OPTN or IS_UNQL) read FValorAverbado write SetValorAverbado stored ValorAverbado_Specified;
    property RamoAverbado:    string  Index (IS_OPTN or IS_UNQL) read FRamoAverbado write SetRamoAverbado stored RamoAverbado_Specified;
  end;


  // ************************************************************************ //
  // Namespace : urn:ATMWebSvr
  // soapAction: urn:ATMWebSvr#%operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : rpc
  // use       : literal
  // binding   : ATMWebSvrBinding
  // service   : ATMWebSvr
  // port      : ATMWebSvrPort
  // URL       : http://webserver.averba.com.br/20/index.soap
  // ************************************************************************ //
  ATMWebSvrPortType = interface(IInvokable)
  ['{7B838219-78E4-EEC2-9CDB-E58C0CBE8435}']
    function  averbaCTe(const usuario: string; const senha: string; const codatm: string; const xmlCTe: string): Retorno; stdcall;
    function  averbaNFe(const usuario: string; const senha: string; const codatm: string; const xmlNFe: string): Retorno; stdcall;
    function  declaraMDFe(const usuario: string; const senha: string; const codatm: string; const xmlMDFe: string): RetornoMDFe; stdcall;
    function  AddBackMail(const usuario: string; const senha: string; const codatm: string; const aplicacao: string; const assunto: string; const remetentes: string;
                          const destinatarios: string; const corpo: string; const chave: string; const chaveresp: string): string; stdcall;
  end;

function GetATMWebSvrPortType(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): ATMWebSvrPortType;


implementation
  uses System.SysUtils;

function GetATMWebSvrPortType(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): ATMWebSvrPortType;
const
  defWSDL = 'http://webserver.averba.com.br/20/index.soap?wsdl';
  defURL  = 'http://webserver.averba.com.br/20/index.soap';
  defSvc  = 'ATMWebSvr';
  defPrt  = 'ATMWebSvrPort';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;

  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;

  try
    Result := (RIO as ATMWebSvrPortType);
    if UseWSDL then begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


destructor RetornoMDFe.Destroy;
var
  I: Integer;
begin
  for I := 0 to System.Length(FErros)-1 do
    System.SysUtils.FreeAndNil(FErros[I]);
  System.SetLength(FErros, 0);
  for I := 0 to System.Length(FInfos)-1 do
    System.SysUtils.FreeAndNil(FInfos[I]);
  System.SetLength(FInfos, 0);
  System.SysUtils.FreeAndNil(FDeclarado);
  inherited Destroy;
end;

procedure RetornoMDFe.SetErros(Index: Integer; const AErrosProcesso: ErrosProcesso);
begin
  FErros := AErrosProcesso;
  FErros_Specified := True;
end;

function RetornoMDFe.Erros_Specified(Index: Integer): boolean;
begin
  Result := FErros_Specified;
end;

procedure RetornoMDFe.SetDeclarado(Index: Integer; const ASuccessProcessoMDFe: SuccessProcessoMDFe);
begin
  FDeclarado := ASuccessProcessoMDFe;
  FDeclarado_Specified := True;
end;

function RetornoMDFe.Declarado_Specified(Index: Integer): boolean;
begin
  Result := FDeclarado_Specified;
end;

procedure RetornoMDFe.SetInfos(Index: Integer; const AInfosProcesso: InfosProcesso);
begin
  FInfos := AInfosProcesso;
  FInfos_Specified := True;
end;

function RetornoMDFe.Infos_Specified(Index: Integer): boolean;
begin
  Result := FInfos_Specified;
end;

destructor Retorno.Destroy;
var
  I: Integer;
begin
  for I := 0 to System.Length(FErros)-1 do
    System.SysUtils.FreeAndNil(FErros[I]);
  System.SetLength(FErros, 0);
  for I := 0 to System.Length(FInfos)-1 do
    System.SysUtils.FreeAndNil(FInfos[I]);
  System.SetLength(FInfos, 0);
  System.SysUtils.FreeAndNil(FAverbado);
  inherited Destroy;
end;

procedure Retorno.SetCNPJCli(Index: Integer; const Astring: string);
begin
  FCNPJCli := Astring;
  FCNPJCli_Specified := True;
end;

function Retorno.CNPJCli_Specified(Index: Integer): boolean;
begin
  Result := FCNPJCli_Specified;
end;

procedure Retorno.SetTpDoc(Index: Integer; const AInt64: Int64);
begin
  FTpDoc := AInt64;
  FTpDoc_Specified := True;
end;

function Retorno.TpDoc_Specified(Index: Integer): boolean;
begin
  Result := FTpDoc_Specified;
end;

procedure Retorno.SetInfAdic(Index: Integer; const Astring: string);
begin
  FInfAdic := Astring;
  FInfAdic_Specified := True;
end;

function Retorno.InfAdic_Specified(Index: Integer): boolean;
begin
  Result := FInfAdic_Specified;
end;

procedure Retorno.SetErros(Index: Integer; const AErrosProcesso: ErrosProcesso);
begin
  FErros := AErrosProcesso;
  FErros_Specified := True;
end;

function Retorno.Erros_Specified(Index: Integer): boolean;
begin
  Result := FErros_Specified;
end;

procedure Retorno.SetAverbado(Index: Integer; const ASuccessProcesso: SuccessProcesso);
begin
  FAverbado := ASuccessProcesso;
  FAverbado_Specified := True;
end;

function Retorno.Averbado_Specified(Index: Integer): boolean;
begin
  Result := FAverbado_Specified;
end;

procedure Retorno.SetInfos(Index: Integer; const AInfosProcesso: InfosProcesso);
begin
  FInfos := AInfosProcesso;
  FInfos_Specified := True;
end;

function Retorno.Infos_Specified(Index: Integer): boolean;
begin
  Result := FInfos_Specified;
end;

procedure ErroProcesso.SetValorEsperado(Index: Integer; const Astring: string);
begin
  FValorEsperado := Astring;
  FValorEsperado_Specified := True;
end;

function ErroProcesso.ValorEsperado_Specified(Index: Integer): boolean;
begin
  Result := FValorEsperado_Specified;
end;

procedure ErroProcesso.SetValorInformado(Index: Integer; const Astring: string);
begin
  FValorInformado := Astring;
  FValorInformado_Specified := True;
end;

function ErroProcesso.ValorInformado_Specified(Index: Integer): boolean;
begin
  Result := FValorInformado_Specified;
end;

destructor SuccessProcessoMDFe.Destroy;
begin
  System.SysUtils.FreeAndNil(FdhChancela);
  inherited Destroy;
end;

destructor SuccessProcesso.Destroy;
var
  I: Integer;
begin
  for I := 0 to System.Length(FDadosSeguro)-1 do
    System.SysUtils.FreeAndNil(FDadosSeguro[I]);
  System.SetLength(FDadosSeguro, 0);
  System.SysUtils.FreeAndNil(FdhAverbacao);
  inherited Destroy;
end;

procedure SuccessProcesso.SetDadosSeguro(Index: Integer; const AArray_Of_DadosSeguro: Array_Of_DadosSeguro);
begin
  FDadosSeguro := AArray_Of_DadosSeguro;
  FDadosSeguro_Specified := True;
end;

function SuccessProcesso.DadosSeguro_Specified(Index: Integer): boolean;
begin
  Result := FDadosSeguro_Specified;
end;

procedure DadosSeguro.SetCNPJSeguradora(Index: Integer; const Astring: string);
begin
  FCNPJSeguradora := Astring;
  FCNPJSeguradora_Specified := True;
end;

function DadosSeguro.CNPJSeguradora_Specified(Index: Integer): boolean;
begin
  Result := FCNPJSeguradora_Specified;
end;

procedure DadosSeguro.SetNomeSeguradora(Index: Integer; const Astring: string);
begin
  FNomeSeguradora := Astring;
  FNomeSeguradora_Specified := True;
end;

function DadosSeguro.NomeSeguradora_Specified(Index: Integer): boolean;
begin
  Result := FNomeSeguradora_Specified;
end;

procedure DadosSeguro.SetNumApolice(Index: Integer; const Astring: string);
begin
  FNumApolice := Astring;
  FNumApolice_Specified := True;
end;

function DadosSeguro.NumApolice_Specified(Index: Integer): boolean;
begin
  Result := FNumApolice_Specified;
end;

procedure DadosSeguro.SetTpMov(Index: Integer; const Astring: string);
begin
  FTpMov := Astring;
  FTpMov_Specified := True;
end;

function DadosSeguro.TpMov_Specified(Index: Integer): boolean;
begin
  Result := FTpMov_Specified;
end;

procedure DadosSeguro.SetTpDDR(Index: Integer; const Astring: string);
begin
  FTpDDR := Astring;
  FTpDDR_Specified := True;
end;

function DadosSeguro.TpDDR_Specified(Index: Integer): boolean;
begin
  Result := FTpDDR_Specified;
end;

procedure DadosSeguro.SetValorAverbado(Index: Integer; const Astring: string);
begin
  FValorAverbado := Astring;
  FValorAverbado_Specified := True;
end;

function DadosSeguro.ValorAverbado_Specified(Index: Integer): boolean;
begin
  Result := FValorAverbado_Specified;
end;

procedure DadosSeguro.SetRamoAverbado(Index: Integer; const Astring: string);
begin
  FRamoAverbado := Astring;
  FRamoAverbado_Specified := True;
end;

function DadosSeguro.RamoAverbado_Specified(Index: Integer): boolean;
begin
  Result := FRamoAverbado_Specified;
end;

initialization
  { ATMWebSvrPortType }
  InvRegistry.RegisterInterface(TypeInfo(ATMWebSvrPortType), 'urn:ATMWebSvr', 'ISO-8859-1');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(ATMWebSvrPortType), 'urn:ATMWebSvr#%operationName%');
  InvRegistry.RegisterInvokeOptions(TypeInfo(ATMWebSvrPortType), ioLiteral);
  { ATMWebSvrPortType.averbaCTe }
  InvRegistry.RegisterParamInfo(TypeInfo(ATMWebSvrPortType), 'averbaCTe', 'Response', '',
                                '[Namespace="urn:ATMWebSvr"]');
  { ATMWebSvrPortType.averbaNFe }
  InvRegistry.RegisterParamInfo(TypeInfo(ATMWebSvrPortType), 'averbaNFe', 'Response', '',
                                '[Namespace="urn:ATMWebSvr"]');
  { ATMWebSvrPortType.declaraMDFe }
  InvRegistry.RegisterParamInfo(TypeInfo(ATMWebSvrPortType), 'declaraMDFe', 'Response', '',
                                '[Namespace="urn:ATMWebSvr"]');
  RemClassRegistry.RegisterXSInfo(TypeInfo(InfosProcesso), 'urn:ATMWebSvr', 'InfosProcesso');
  RemClassRegistry.RegisterXSInfo(TypeInfo(Array_Of_DadosSeguro), 'urn:ATMWebSvr', 'Array_Of_DadosSeguro');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ErrosProcesso), 'urn:ATMWebSvr', 'ErrosProcesso');
  RemClassRegistry.RegisterXSClass(RetornoMDFe, 'urn:ATMWebSvr', 'RetornoMDFe');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(RetornoMDFe), 'Erros', '[ArrayItemName="Erro"]');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(RetornoMDFe), 'Infos', '[ArrayItemName="Info"]');
  RemClassRegistry.RegisterXSClass(InfoProcesso, 'urn:ATMWebSvr', 'InfoProcesso');
  RemClassRegistry.RegisterXSClass(Retorno, 'urn:ATMWebSvr', 'Retorno');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(Retorno), 'Erros', '[ArrayItemName="Erro"]');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(Retorno), 'Infos', '[ArrayItemName="Info"]');
  RemClassRegistry.RegisterXSClass(ErroProcesso, 'urn:ATMWebSvr', 'ErroProcesso');
  RemClassRegistry.RegisterXSClass(SuccessProcessoMDFe, 'urn:ATMWebSvr', 'SuccessProcessoMDFe');
  RemClassRegistry.RegisterXSClass(SuccessProcesso, 'urn:ATMWebSvr', 'SuccessProcesso');
  RemClassRegistry.RegisterXSClass(DadosSeguro, 'urn:ATMWebSvr', 'DadosSeguro');

end.
