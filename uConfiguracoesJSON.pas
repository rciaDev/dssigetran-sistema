unit uConfiguracoesJSON;

interface

uses
  Pkg.Json.DTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
  TConfiguracoesSeguradora = class(TJsonDTO)
  private
    FApolice: string;
    FCodigo: string;
    [JSONName('codigo_acesso')]
    FCodigoAcesso: string;
    FData: string;
    [JSONName('nome_usuario')]
    FNomeUsuario: string;
    FResponsavel: string;
    FSeguradora: string;
    [JSONName('seguradora_fornecedor')]
    FSeguradoraFornecedor: string;
    FSenha: string;
    FUnidade: string;
  published
    property Apolice: string read FApolice write FApolice;
    property Codigo: string read FCodigo write FCodigo;
    property CodigoAcesso: string read FCodigoAcesso write FCodigoAcesso;
    property Data: string read FData write FData;
    property NomeUsuario: string read FNomeUsuario write FNomeUsuario;
    property Responsavel: string read FResponsavel write FResponsavel;
    property Seguradora: string read FSeguradora write FSeguradora;
    property SeguradoraFornecedor: string read FSeguradoraFornecedor write FSeguradoraFornecedor;
    property Senha: string read FSenha write FSenha;
    property Unidade: string read FUnidade write FUnidade;
  end;

implementation

end.
