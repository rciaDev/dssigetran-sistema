unit uMdfeJSON;

interface

uses
  Pkg.Json.DTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
  TItens = class
  private
    FCodigo: string;
  published
    property Codigo: string read FCodigo write FCodigo;
  end;

  TDestino = class
  private
    FCep: string;
    FCidade: string;
    FUf: string;
  published
    property Cep: string read FCep write FCep;
    property Cidade: string read FCidade write FCidade;
    property Uf: string read FUf write FUf;
  end;

  TOrigem = class
  private
    FCep: string;
    FCidade: string;
    FUf: string;
  published
    property Cep: string read FCep write FCep;
    property Cidade: string read FCidade write FCidade;
    property Uf: string read FUf write FUf;
  end;

  TMdfeJSON = class(TJsonDTO)
  private
    FCodigo: string;
    FDestino: TDestino;
    [JSONName('itens'), JSONMarshalled(False)]
    FItensArray: TArray<TItens>;
    [GenericListReflect]
    FItens: TObjectList<TItens>;
    FMdfe: String;
    FObservacoes: string;
    FOrigem: TOrigem;
    [JSONName('uf_percurso')]
    FUfPercurso: string;
    function GetItens: TObjectList<TItens>;
  protected
    function GetAsJson: string; override;
  published
    property Codigo: string read FCodigo write FCodigo;
    property Destino: TDestino read FDestino;
    property Itens: TObjectList<TItens> read GetItens;
    property Mdfe: string read FMdfe write FMdfe;
    property Observacoes: string read FObservacoes write FObservacoes;
    property Origem: TOrigem read FOrigem;
    property UfPercurso: string read FUfPercurso write FUfPercurso;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

{ TMdfeJSON }

constructor TMdfeJSON.Create;
begin
  inherited;
  FOrigem := TOrigem.Create;
  FDestino := TDestino.Create;
end;

destructor TMdfeJSON.Destroy;
begin
  FOrigem.Free;
  FDestino.Free;
  GetItens.Free;
  inherited;
end;

function TMdfeJSON.GetItens: TObjectList<TItens>;
begin
  Result := ObjectList<TItens>(FItens, FItensArray);
end;

function TMdfeJSON.GetAsJson: string;
begin
  RefreshArray<TItens>(FItens, FItensArray);
  Result := inherited;
end;

end.
