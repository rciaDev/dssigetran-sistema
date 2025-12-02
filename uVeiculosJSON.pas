unit uVeiculosJSON;

interface

uses
  Pkg.Json.DTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
  TProprietario = class
  private
    FCategoria: string;
    FCodigo: string;
    FCpfCnpj: string;
    FIe: string;
    FNome: string;
    FRntrc: string;
    FUf: string;
  published
    property Categoria: string read FCategoria write FCategoria;
    property Codigo: string read FCodigo write FCodigo;
    property CpfCnpj: string read FCpfCnpj write FCpfCnpj;
    property Ie: string read FIe write FIe;
    property Nome: string read FNome write FNome;
    property Rntrc: string read FRntrc write FRntrc;
    property Uf: string read FUf write FUf;
  end;

  TVeiculosJSON = class(TJsonDTO)
  private
    FCapacidadeKg: string;
    FCapacidadeKg1: string;
    FCapacidadeKg2: string;
    FCapacidadeKg3: string;
    FCapacidadeM3: string;
    FCapacidadeM31: string;
    FCapacidadeM32: string;
    FCapacidadeM33: string;
    FCodigo: string;
    FFrota: string;
    FModelo: string;
    FModelo1: string;
    FModelo2: string;
    FModelo3: string;
    FMotorista: string;
    FNumeroEixos: string;
    FNumeroEixos1: string;
    FNumeroEixos2: string;
    FNumeroEixos3: string;
    FPlaca: string;
    FPlaca1: string;
    FPlaca2: string;
    FPlaca3: string;
    FProprietario: TProprietario;
    FRenavam: string;
    FRenavam1: string;
    FRenavam2: string;
    FRenavam3: string;
    FRntrc: string;
    FRntrc1: string;
    FRntrc2: string;
    FRntrc3: string;
    FTara: string;
    FTara1: string;
    FTara2: string;
    FTara3: string;
    FTipo: string;
    FUfEmplacamento: string;
    FUfEmplacamento1: string;
    FUfEmplacamento2: string;
    FUfEmplacamento3: string;
  published
    property CapacidadeKg: string read FCapacidadeKg write FCapacidadeKg;
    property CapacidadeKg1: string read FCapacidadeKg1 write FCapacidadeKg1;
    property CapacidadeKg2: string read FCapacidadeKg2 write FCapacidadeKg2;
    property CapacidadeKg3: string read FCapacidadeKg3 write FCapacidadeKg3;
    property CapacidadeM3: string read FCapacidadeM3 write FCapacidadeM3;
    property CapacidadeM31: string read FCapacidadeM31 write FCapacidadeM31;
    property CapacidadeM32: string read FCapacidadeM32 write FCapacidadeM32;
    property CapacidadeM33: string read FCapacidadeM33 write FCapacidadeM33;
    property Codigo: string read FCodigo write FCodigo;
    property Frota: string read FFrota write FFrota;
    property Modelo: string read FModelo write FModelo;
    property Modelo1: string read FModelo1 write FModelo1;
    property Modelo2: string read FModelo2 write FModelo2;
    property Modelo3: string read FModelo3 write FModelo3;
    property Motorista: string read FMotorista write FMotorista;
    property NumeroEixos: string read FNumeroEixos write FNumeroEixos;
    property NumeroEixos1: string read FNumeroEixos1 write FNumeroEixos1;
    property NumeroEixos2: string read FNumeroEixos2 write FNumeroEixos2;
    property NumeroEixos3: string read FNumeroEixos3 write FNumeroEixos3;
    property Placa: string read FPlaca write FPlaca;
    property Placa1: string read FPlaca1 write FPlaca1;
    property Placa2: string read FPlaca2 write FPlaca2;
    property Placa3: string read FPlaca3 write FPlaca3;
    property Proprietario: TProprietario read FProprietario;
    property Renavam: string read FRenavam write FRenavam;
    property Renavam1: string read FRenavam1 write FRenavam1;
    property Renavam2: string read FRenavam2 write FRenavam2;
    property Renavam3: string read FRenavam3 write FRenavam3;
    property Rntrc: string read FRntrc write FRntrc;
    property Rntrc1: string read FRntrc1 write FRntrc1;
    property Rntrc2: string read FRntrc2 write FRntrc2;
    property Rntrc3: string read FRntrc3 write FRntrc3;
    property Tara: string read FTara write FTara;
    property Tara1: string read FTara1 write FTara1;
    property Tara2: string read FTara2 write FTara2;
    property Tara3: string read FTara3 write FTara3;
    property Tipo: string read FTipo write FTipo;
    property UfEmplacamento: string read FUfEmplacamento write FUfEmplacamento;
    property UfEmplacamento1: string read FUfEmplacamento1 write FUfEmplacamento1;
    property UfEmplacamento2: string read FUfEmplacamento2 write FUfEmplacamento2;
    property UfEmplacamento3: string read FUfEmplacamento3 write FUfEmplacamento3;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

{ TRoot }

constructor TVeiculosJSON.Create;
begin
  inherited;
  FProprietario := TProprietario.Create;
end;

destructor TVeiculosJSON.Destroy;
begin
  FProprietario.Free;
  inherited;
end;

end.
