unit uProprietariosJSON;

interface

uses
  Pkg.Json.DTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
  TProprietarioCadastroJSON = class(TJsonDTO)
  private
    FAgencia: string;
    FBairro: string;
    FBanco: string;
    FCaixa: string;
    FCategoria : string;
    FCelular: string;
    FCep: string;
    FCidade: string;
    FCnpj: string;
    FCodigo: string;
    FConta: string;
    [JSONName('cpf_titular')]
    FCpfTitular: string;
    FEmail: string;
    FEndereco: string;
    FFantasia: string;
    FInss: string;
    FNome: string;
    FNumero: string;
    FRg: string;
    FRntrc: string;
    FSituacao: string;
    FTipo: string;
    FTitular: string;
    FUf: string;
  published
    property Agencia: string read FAgencia write FAgencia;
    property Bairro: string read FBairro write FBairro;
    property Banco: string read FBanco write FBanco;
    property Caixa: string read FCaixa write FCaixa;
    property Categoria: string read FCategoria write FCategoria;
    property Celular: string read FCelular write FCelular;
    property Cep: string read FCep write FCep;
    property Cidade: string read FCidade write FCidade;
    property Cnpj: string read FCnpj write FCnpj;
    property Codigo: string read FCodigo write FCodigo;
    property Conta: string read FConta write FConta;
    property CpfTitular: string read FCpfTitular write FCpfTitular;
    property Email: string read FEmail write FEmail;
    property Endereco: string read FEndereco write FEndereco;
    property Fantasia: string read FFantasia write FFantasia;
    property Inss: string read FInss write FInss;
    property Nome: string read FNome write FNome;
    property Numero: string read FNumero write FNumero;
    property Rg: string read FRg write FRg;
    property Rntrc: string read FRntrc write FRntrc;
    property Situacao: string read FSituacao write FSituacao;
    property Tipo: string read FTipo write FTipo;
    property Titular: string read FTitular write FTitular;
    property Uf: string read FUf write FUf;
  end;

implementation

end.
