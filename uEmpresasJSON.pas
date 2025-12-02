unit uEmpresasJSON;

interface

uses
  Pkg.Json.DTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
  TPerfilJSON = class(TJsonDTO)
  private
    FBairro: string;
    FCep: string;
    FCidade: string;
    FCnpj: string;
    FCodigo: string;
    [JSONName('codigo_municipio')]
    FCodigoMunicipio: string;
    FComplemento: string;
    FEmail: string;
    FEndereco: string;
    FIe: string;
    FNome: string;
    FNumero: string;
    FPlataforma : String;
    FRazao: string;
    FRegime: string;
    FRntrc: string;
    FTelefone: string;
    [JSONName('tipo_transportadora')]
    FTipoTransportadora: string;
    FUf: string;
    FUnidade: string;
  published
    property Bairro: string read FBairro write FBairro;
    property Cep: string read FCep write FCep;
    property Cidade: string read FCidade write FCidade;
    property Cnpj: string read FCnpj write FCnpj;
    property Codigo: string read FCodigo write FCodigo;
    property CodigoMunicipio: string read FCodigoMunicipio write FCodigoMunicipio;
    property Complemento: string read FComplemento write FComplemento;
    property Email: string read FEmail write FEmail;
    property Endereco: string read FEndereco write FEndereco;
    property Ie: string read FIe write FIe;
    property Nome: string read FNome write FNome;
    property Numero: string read FNumero write FNumero;
    property Plataforma: string read FPlataforma write FPlataforma;
    property Razao: string read FRazao write FRazao;
    property Regime: string read FRegime write FRegime;
    property Rntrc: string read FRntrc write FRntrc;
    property Telefone: string read FTelefone write FTelefone;
    property TipoTransportadora: string read FTipoTransportadora write FTipoTransportadora;
    property Uf: string read FUf write FUf;
    property Unidade: string read FUnidade write FUnidade;
  end;

implementation

end.
