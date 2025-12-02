program dsSigetran;
{$APPTYPE GUI}

{$R *.dres}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  uFrm in 'uFrm.pas' {frmPrin},
  uServerMethods in 'uServerMethods.pas',
  uServerContainer in 'uServerContainer.pas' {ServerContainer1: TDataModule},
  uWMSite in 'uWMSite.pas' {WMSite: TWebModule},
  uEmpresas in 'uEmpresas.pas',
  uReceitaWs in 'uReceitaWs.pas',
  uBuscas in 'uBuscas.pas',
  uFretes in 'uFretes.pas',
  uProdutos in 'uProdutos.pas',
  uFreteJSON in 'uFreteJSON.pas',
  uCTe in 'uCTe.pas',
  uMdfe in 'uMdfe.pas',
  uUsuariosJSON in 'uUsuariosJSON.pas',
  uUsuarios in 'uUsuarios.pas',
  uEmpresasJSON in 'uEmpresasJSON.pas',
  uClientesJSON in 'uClientesJSON.pas',
  uClientes in 'uClientes.pas',
  uProprietariosJSON in 'uProprietariosJSON.pas',
  uProprietarios in 'uProprietarios.pas',
  uConfiguracoes in 'uConfiguracoes.pas',
  uConfiguracoesJSON in 'uConfiguracoesJSON.pas',
  uVeiculosJSON in 'uVeiculosJSON.pas',
  uVeiculos in 'uVeiculos.pas',
  uRelatoriosCadastrais in 'uRelatoriosCadastrais.pas',
  uRelatoriosOperacionais in 'uRelatoriosOperacionais.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TfrmPrin, frmPrin);
  Application.Run;
end.
