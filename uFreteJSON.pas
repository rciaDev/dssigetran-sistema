unit uFreteJSON;

interface

uses
  Pkg.Json.DTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
  TNotas = class
  private
    FChave: string;
    FData: string;
    [JSONName('dias_entrega')]
    FDiasEntrega: string;
    FItem: Integer;
    FMercadoria: string;
    FNumero: string;
    FQuantidade: Integer;
    FSerie: string;
    FTipo: string;
    FUnidade: string;
    [JSONName('valor_mercadoria')]
    FValorMercadoria: Double;
    [JSONName('valor_unitario')]
    FValorUnitario: Double;
  published
    property Chave: string read FChave write FChave;
    property Data: string read FData write FData;
    property DiasEntrega: string read FDiasEntrega write FDiasEntrega;
    property Item: Integer read FItem write FItem;
    property Mercadoria: string read FMercadoria write FMercadoria;
    property Numero: string read FNumero write FNumero;
    property Quantidade: Integer read FQuantidade write FQuantidade;
    property Serie: string read FSerie write FSerie;
    property Tipo: string read FTipo write FTipo;
    property Unidade: string read FUnidade write FUnidade;
    property ValorMercadoria: Double read FValorMercadoria write FValorMercadoria;
    property ValorUnitario: Double read FValorUnitario write FValorUnitario;
  end;

  TFreteJSON = class(TJsonDTO)
  private
    FAdiantamento: Double;
    FAliquota: Double;
    [JSONName('base_reducao')]
    FBaseReducao: Double;
    [JSONName('base_icms')]
    FBaseIcms: Double;
    FCfop: string;
    FChave: string;
    [JSONName('cidade_emissao')]
    FCidadeEmissao: String;
    FCodigo: string;
    FCst: string;
    FCtr: string;
    [JSONName('descontos_adicionais_mercadoria')]
    FDescontosAdicionaisMercadoria: Double;
    [JSONName('descontos_empresa')]
    FDescontosEmpresa: Double;
    FDestinatario: string;
    [JSONName('destinatario_tipo')]
    FDestinatarioTipo: string;
    FDestino: string;
    FDistancia: Integer;
    [JSONName('especie_mercadoria')]
    FEspecieMercadoria: string;
    FEstadia: Double;
    [JSONName('forma_pagamento')]
    FFormaPagamento: String;
    [JSONName('icms_motorista')]
    FIcmsMotorista: Double;
    FInss: Double;
    [JSONName('irrf_motorista')]
    FIrrfMotorista: Double;
    FMercadoria: string;
    FModelo: string;
    FMotorista: string;
    [JSONName('notas'), JSONMarshalled(False)]
    FNotasArray: TArray<TNotas>;
    [GenericListReflect]
    FNotas: TObjectList<TNotas>;
    FObs: string;
    FOrigem: string;
    [JSONName('outros_valores_motorista')]
    FOutrosValoresMotorista: Double;
    [JSONName('pedagio_empresa')]
    FPedagioEmpresa: Double;
    [JSONName('pedagio_motorista')]
    FPedagioMotorista: Double;
    [JSONName('pedagio_ppt')]
    FPedagioPpt: Double;
    FPlaca: string;
    FPlataforma: string;
    [JSONName('porcentagem_adiantamento')]
    FPorcentagemAdiantamento: Double;
    FProprietario: string;
    FQuantidade: Integer;
    [JSONName('quantidade_tolerancia_motorista')]
    FQuantidadeToleranciaMotorista: Double;
    FRemetente: string;
    [JSONName('remetente_tipo')]
    FRemetenteTipo: string;
    FSaldo: Double;
    FSerie: String;
    [JSONName('seguro_empresa')]
    FSeguroEmpresa: Double;
    [JSONName('seguro_motorista')]
    FSeguroMotorista: Double;
    FSest: Double;
    [JSONName('tipo_cte')]
    FTipoCte: string;
    [JSONName('tipo_servico')]
    FTipoServico: string;
    [JSONName('tolerancia_motorista')]
    FToleranciaMotorista: Double;
    FTomador: string;
    [JSONName('tomador_tipo')]
    FTomadorTipo: string;
    [JSONName('uf_emissao')]
    FUfEmissao: String;
    [JSONName('valor_frete_motorista')]
    FValorFreteMotorista: Double;
    [JSONName('valor_frete_motorista_ppt')]
    FValorFreteMotoristaPpt: Double;
    [JSONName('valor_frete_ppt_empresa')]
    FValorFretePptEmpresa: Double;
    [JSONName('valor_mercadoria')]
    FValorMercadoria: Double;
    [JSONName('valor_total_empresa')]
    FValorTotalEmpresa: Double;
    [JSONName('vr_icms')]
    FVrIcms: Double;
    function GetNotas: TObjectList<TNotas>;
  protected
    function GetAsJson: string; override;
  published
    property Adiantamento: Double read FAdiantamento write FAdiantamento;
    property Aliquota: Double read FAliquota write FAliquota;
    property BaseReducao: Double read FBaseReducao write FBaseReducao;
    property BaseIcms: Double read FBaseIcms write FBaseIcms;
    property Cfop: string read FCfop write FCfop;
    property Chave: string read FChave write FChave;
    property CidadeEmissao: string read FCidadeEmissao write FCidadeEmissao;
    property Codigo: string read FCodigo write FCodigo;
    property Cst: string read FCst write FCst;
    property Ctr: string read FCtr write FCtr;
    property DescontosAdicionaisMercadoria: Double read FDescontosAdicionaisMercadoria write FDescontosAdicionaisMercadoria;
    property DescontosEmpresa: Double read FDescontosEmpresa write FDescontosEmpresa;
    property Destinatario: string read FDestinatario write FDestinatario;
    property DestinatarioTipo: string read FDestinatarioTipo write FDestinatarioTipo;
    property Destino: string read FDestino write FDestino;
    property Distancia: Integer read FDistancia write FDistancia;
    property EspecieMercadoria: string read FEspecieMercadoria write FEspecieMercadoria;
    property Estadia: Double read FEstadia write FEstadia;
    property FormaPagamento: String read FFormaPagamento write FFormaPagamento;
    property IcmsMotorista: Double read FIcmsMotorista write FIcmsMotorista;
    property Inss: Double read FInss write FInss;
    property IrrfMotorista: Double read FIrrfMotorista write FIrrfMotorista;
    property Mercadoria: string read FMercadoria write FMercadoria;
    property Modelo: string read FModelo write FModelo;
    property Motorista: string read FMotorista write FMotorista;
    property Notas: TObjectList<TNotas> read GetNotas;
    property Obs: string read FObs write FObs;
    property Origem: string read FOrigem write FOrigem;
    property OutrosValoresMotorista: Double read FOutrosValoresMotorista write FOutrosValoresMotorista;
    property PedagioEmpresa: Double read FPedagioEmpresa write FPedagioEmpresa;
    property PedagioMotorista: Double read FPedagioMotorista write FPedagioMotorista;
    property PedagioPpt: Double read FPedagioPpt write FPedagioPpt;
    property Placa: string read FPlaca write FPlaca;
    property Plataforma: string read FPlataforma write FPlataforma;
    property PorcentagemAdiantamento: Double read FPorcentagemAdiantamento write FPorcentagemAdiantamento;
    property Proprietario: string read FProprietario write FProprietario;
    property Quantidade: Integer read FQuantidade write FQuantidade;
    property QuantidadeToleranciaMotorista: Double read FQuantidadeToleranciaMotorista write FQuantidadeToleranciaMotorista;
    property Remetente: string read FRemetente write FRemetente;
    property RemetenteTipo: string read FRemetenteTipo write FRemetenteTipo;
    property Saldo: Double read FSaldo write FSaldo;
    property Serie: String read FSerie write FSerie;
    property SeguroEmpresa: Double read FSeguroEmpresa write FSeguroEmpresa;
    property SeguroMotorista: Double read FSeguroMotorista write FSeguroMotorista;
    property Sest: Double read FSest write FSest;
    property TipoCte: string read FTipoCte write FTipoCte;
    property TipoServico: string read FTipoServico write FTipoServico;
    property ToleranciaMotorista: Double read FToleranciaMotorista write FToleranciaMotorista;
    property Tomador: string read FTomador write FTomador;
    property TomadorTipo: string read FTomadorTipo write FTomadorTipo;
    property UfEmissao: string read FUfEmissao write FUfEmissao;
    property ValorFreteMotorista: Double read FValorFreteMotorista write FValorFreteMotorista;
    property ValorFreteMotoristaPpt: Double read FValorFreteMotoristaPpt write FValorFreteMotoristaPpt;
    property ValorFretePptEmpresa: Double read FValorFretePptEmpresa write FValorFretePptEmpresa;
    property ValorMercadoria: Double read FValorMercadoria write FValorMercadoria;
    property ValorTotalEmpresa: Double read FValorTotalEmpresa write FValorTotalEmpresa;
    property VrIcms: Double read FVrIcms write FVrIcms;
  public
    destructor Destroy; override;
  end;

implementation

{ TFreteJSON }

destructor TFreteJSON.Destroy;
begin
  GetNotas.Free;
  inherited;
end;

function TFreteJSON.GetNotas: TObjectList<TNotas>;
begin
  Result := ObjectList<TNotas>(FNotas, FNotasArray);
end;

function TFreteJSON.GetAsJson: string;
begin
  RefreshArray<TNotas>(FNotas, FNotasArray);
  Result := inherited;
end;

end.
