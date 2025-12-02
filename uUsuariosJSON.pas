unit uUsuariosJSON;

interface

uses
  Pkg.Json.DTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
  TUsuariosJSON = class(TJsonDTO)
  private
    FAtivo: string;
    FBairro: string;
    FCep: string;
    FCidade: string;
    FCodigo: string;
    FEmail: string;
    FEndereco: string;
    FLogin: string;
    FNome: string;
    FNumero: string;
    FPerfil: string;
    [JSONName('perfil_adicional')]
    FPerfilAdicional: string;
    FSenha: string;
    FUf: string;
  published
    property Ativo: string read FAtivo write FAtivo;
    property Bairro: string read FBairro write FBairro;
    property Cep: string read FCep write FCep;
    property Cidade: string read FCidade write FCidade;
    property Codigo: string read FCodigo write FCodigo;
    property Email: string read FEmail write FEmail;
    property Endereco: string read FEndereco write FEndereco;
    property Login: string read FLogin write FLogin;
    property Nome: string read FNome write FNome;
    property Numero: string read FNumero write FNumero;
    property Perfil: string read FPerfil write FPerfil;
    property PerfilAdicional: string read FPerfilAdicional write FPerfilAdicional;
    property Senha: string read FSenha write FSenha;
    property Uf: string read FUf write FUf;
  end;

implementation

end.
