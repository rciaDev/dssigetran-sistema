unit uClientesJSON;

interface

uses
  Pkg.Json.DTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
  TClienteCadastroJSON = class(TJsonDTO)
  private
    [JSONName('averba_seguro')]
    FAverbaSeguro: string;
    FBairro: string;
    FCep: string;
    FCelular: string;
    FCidade: string;
    FCnpj: string;
    FCodigo: string;
    [JSONName('desconta_quebra')]
    FDescontaQuebra: string;
    FEndereco: string;
    FEmail: string;
    FFantasia: string;
    FNome: string;
    FNumero: string;
    FRg: string;
    FSituacao: string;
    FTipo: string;
    FUf: string;
  published
    property AverbaSeguro: string read FAverbaSeguro write FAverbaSeguro;
    property Bairro: string read FBairro write FBairro;
    property Cep: string read FCep write FCep;
    property Celular: string read FCelular write FCelular;
    property Cidade: string read FCidade write FCidade;
    property Cnpj: string read FCnpj write FCnpj;
    property Codigo: string read FCodigo write FCodigo;
    property DescontaQuebra: string read FDescontaQuebra write FDescontaQuebra;
    property Email: string read FEmail write FEmail;
    property Endereco: string read FEndereco write FEndereco;
    property Fantasia: string read FFantasia write FFantasia;
    property Nome: string read FNome write FNome;
    property Numero: string read FNumero write FNumero;
    property Rg: string read FRg write FRg;
    property Situacao: string read FSituacao write FSituacao;
    property Tipo: string read FTipo write FTipo;
    property Uf: string read FUf write FUf;
  end;
implementation

end.
