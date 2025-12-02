object WMSite: TWMSite
  OldCreateOrder = False
  OnCreate = WebModuleCreate
  Actions = <
    item
      Name = 'ReverseStringAction'
      PathInfo = '/ReverseString'
      Producer = ReverseString
    end
    item
      Name = 'ServerFunctionInvokerAction'
      PathInfo = '/ServerFunctionInvoker'
      Producer = ServerFunctionInvoker
    end
    item
      Default = True
      Name = 'DefaultAction'
      PathInfo = '/index'
      OnAction = WebModuleDefaultAction
    end
    item
      MethodType = mtPost
      Name = 'ppEntrar'
      PathInfo = '/entrar'
      OnAction = WMSiteppEntrarAction
    end
    item
      MethodType = mtPost
      Name = 'ppPostos'
      PathInfo = '/postos'
      Producer = postos
    end
    item
      Name = 'acDadosUser'
      PathInfo = '/dados-usuario'
      OnAction = WMSiteacDadosUserAction
    end
    item
      MethodType = mtPost
      Name = 'actRecuperarSenha'
      PathInfo = '/recuperar-senha'
      OnAction = WMSiteactRecuperarSenhaAction
    end
    item
      MethodType = mtPost
      Name = 'actRecuperarSenhaValidaToken'
      PathInfo = '/recuperar-senha/valida-token'
      OnAction = WMSiterecuperarsenhavalidatokenAction
    end
    item
      MethodType = mtPost
      Name = 'actAlterarSenha'
      PathInfo = '/recuperar-senha/alterar-senha'
      OnAction = WMSiteactAlterarSenhaAction
    end
    item
      MethodType = mtPost
      Name = 'actUsuarios'
      PathInfo = '/usuarios'
    end
    item
      MethodType = mtPost
      Name = 'actUsuario'
      PathInfo = '/usuario'
    end
    item
      MethodType = mtPost
      Name = 'actUsuariosUpdateSenha'
      PathInfo = '/usuarios/alterar-senha'
      OnAction = WMSiteactUsuariosUpdateSenhaAction
    end
    item
      Name = 'actCadastrarUsuario'
      PathInfo = '/cadastrar-usuario'
    end
    item
      MethodType = mtPost
      Name = 'actExcluirUsuario'
      PathInfo = '/excluir-usuario'
    end
    item
      MethodType = mtPost
      Name = 'ppConsultaPagamentos'
      PathInfo = '/consulta-pagamentos'
    end
    item
      MethodType = mtGet
      Name = 'actBuscas'
      PathInfo = '/buscas'
      OnAction = WMSiteactBuscasAction
    end
    item
      Name = 'actRegistraPagamentos'
      PathInfo = '/registra-pagamento'
    end
    item
      MethodType = mtPost
      Name = 'actRegistraImagens'
      PathInfo = '/registra-imagem-pagamento'
    end
    item
      MethodType = mtPost
      Name = 'actBuscaPagamento'
      PathInfo = '/busca-pagamento'
    end
    item
      MethodType = mtPost
      Name = 'actCancelaPagamento'
      PathInfo = '/cancela-pagamento'
    end
    item
      MethodType = mtPost
      Name = 'actBuscaReg'
      PathInfo = '/executa-sql'
      OnAction = WMSiteactBuscaRegAction
    end
    item
      MethodType = mtPost
      Name = 'ppCadastrar'
      PathInfo = '/cadastrar'
      OnAction = WMSiteppCadastrarAction
    end
    item
      MethodType = mtGet
      Name = 'ppBuscaDadosReceita'
      PathInfo = '/dados-receita'
      OnAction = WMSiteppBuscaDadosReceitaAction
    end
    item
      MethodType = mtPost
      Name = 'actValidaCodigo'
      PathInfo = '/valida-email'
      OnAction = WMSiteactValidaCodigoAction
    end
    item
      MethodType = mtGet
      Name = 'actEncrip'
      PathInfo = '/sistema/encrip'
      OnAction = WMSiteactEncripAction
    end
    item
      MethodType = mtPost
      Name = 'actProdutosReg'
      PathInfo = '/produtos/registro'
      OnAction = WMSiteactProdutosRegAction
    end
    item
      MethodType = mtPost
      Name = 'actAtualizaCertificadoEmpresa'
      PathInfo = '/empresa/certificado'
      OnAction = WMSiteactAtualizaEmpresaAction
    end
    item
      MethodType = mtPost
      Name = 'actExcluiCertificadoEmpresa'
      PathInfo = '/empresa/certificado/remove'
      OnAction = WMSiteactExcluiCertificadoEmpresaAction
    end
    item
      MethodType = mtPost
      Name = 'actEmpresaLogo'
      PathInfo = '/empresa/logomarca'
      OnAction = WMSiteactEmpresaLogoAction
    end
    item
      MethodType = mtPost
      Name = 'actEmpresaPerfil'
      PathInfo = '/empresa/perfil'
      OnAction = WMSiteactEmpresaPerfilAction
    end
    item
      MethodType = mtGet
      Name = 'actEmpresaPlano'
      PathInfo = '/empresa/plano'
      OnAction = WMSiteactEmpresaPlanoAction
    end
    item
      MethodType = mtGet
      Name = 'actFretes'
      PathInfo = '/fretes/consulta'
    end
    item
      MethodType = mtPost
      Name = 'actFretesRegistra'
      PathInfo = '/fretes/registra'
      OnAction = WMSiteactFretesRegistraAction
    end
    item
      MethodType = mtPost
      Name = 'actFretesImportarXML'
      PathInfo = '/fretes/importar/xml'
      OnAction = WMSiteactFretesImportarXMLAction
    end
    item
      MethodType = mtPost
      Name = 'actFretesContrato'
      PathInfo = '/fretes/contrato'
      OnAction = WMSiteactFretesContratoAction
    end
    item
      MethodType = mtGet
      Name = 'actStatusCte'
      PathInfo = '/cte/status'
      OnAction = WMSitectestatusAction
    end
    item
      MethodType = mtGet
      Name = 'actGetItemsConfig'
      PathInfo = '/cte/configuracoes'
      OnAction = WMSiteactGetItemsConfigAction
    end
    item
      MethodType = mtPost
      Name = 'actEnviarCte'
      PathInfo = '/cte/enviar'
      OnAction = WMSiteactEnviarCteAction
    end
    item
      MethodType = mtPost
      Name = 'actCteCancela'
      PathInfo = '/cte/cancelar'
      OnAction = WMSiteactCteCancelaAction
    end
    item
      MethodType = mtPost
      Name = 'actCteConsultaSefaz'
      PathInfo = '/cte/consulta-sefaz'
      OnAction = WMSiteactCteConsultaSefazAction
    end
    item
      Name = 'actCteDownload'
      PathInfo = '/cte/download'
      OnAction = WMSiteactCteDownloadAction
    end
    item
      MethodType = mtPost
      Name = 'actCteEmail'
      PathInfo = '/cte/email'
      OnAction = WMSiteactCteEmailAction
    end
    item
      MethodType = mtPost
      Name = 'ppCteCorrecaoEnviar'
      PathInfo = '/cte/correcao/enviar'
      OnAction = WMSiteppCteCorrecaoEnviarAction
    end
    item
      MethodType = mtPost
      Name = 'actEnviaSeguro'
      PathInfo = '/cte/seguro/enviar'
      OnAction = WMSiteactEnviaSeguroAction
    end
    item
      MethodType = mtPost
      Name = 'actCteSeguroCancelar'
      PathInfo = '/cte/seguro/cancelar'
      OnAction = WMSiteactCteSeguroCancelarAction
    end
    item
      MethodType = mtGet
      Name = 'actCteSeguro'
      PathInfo = '/cte/seguro'
      OnAction = WMSiteactCteSeguroAction
    end
    item
      MethodType = mtPost
      Name = 'actMdfeConsulta'
      PathInfo = '/mdfe/consulta'
      OnAction = WMSiteactMdfeConsultaAction
    end
    item
      MethodType = mtPost
      Name = 'actMdfeRegistra'
      PathInfo = '/mdfe/registra'
      OnAction = WMSiteactMdfeRegistraAction
    end
    item
      MethodType = mtGet
      Name = 'actMdfeStatus'
      PathInfo = '/mdfe/status'
      OnAction = WMSiteactMdfeStatusAction
    end
    item
      MethodType = mtPost
      Name = 'actMdfeEnviar'
      PathInfo = '/mdfe/enviar'
      OnAction = WMSiteactMdfeEnviarAction
    end
    item
      MethodType = mtPost
      Name = 'actMdfeDownload'
      PathInfo = '/mdfe/download'
      OnAction = WMSiteactMdfeDownloadAction
    end
    item
      MethodType = mtPost
      Name = 'actMdfeDownloadEncerramento'
      PathInfo = '/mdfe/download/encerramento'
      OnAction = WMSiteactMdfeDownloadEncerramentoAction
    end
    item
      MethodType = mtPost
      Name = 'actMdfeCancelar'
      PathInfo = '/mdfe/cancelar'
      OnAction = WMSiteWebActionItem1Action
    end
    item
      MethodType = mtPost
      Name = 'actMdfeEmail'
      PathInfo = '/mdfe/email'
      OnAction = WMSiteactMdfeEmailAction
    end
    item
      MethodType = mtPost
      Name = 'actMdfeEncerrar'
      PathInfo = '/mdfe/encerrar'
      OnAction = WMSiteactMdfeEncerrarAction
    end
    item
      MethodType = mtPost
      Name = 'actMdfeSeguroEnviar'
      PathInfo = '/mdfe/seguro/enviar'
      OnAction = WMSiteactMdfeSeguroEnviarAction
    end
    item
      MethodType = mtPost
      Name = 'actUsuarioRegistrar'
      PathInfo = '/usuarios/registrar'
      OnAction = WMSiteactUsuarioRegistrarAction
    end
    item
      MethodType = mtPost
      Name = 'actClientesRegistrar'
      PathInfo = '/clientes/registrar'
      OnAction = WMSiteactClientesRegistrarAction
    end
    item
      MethodType = mtPost
      Name = 'actProprietarioRegistrar'
      PathInfo = '/proprietarios/registrar'
      OnAction = WMSiteactProprietarioRegistrarAction
    end
    item
      MethodType = mtPost
      Name = 'actConfiguracoesSeguradoras'
      PathInfo = '/configuracoes/seguradora'
      OnAction = WMSiteactConfiguracoesSeguradorasAction
    end
    item
      MethodType = mtGet
      Name = 'actConfiguracoesSeguradorasBusca'
      PathInfo = '/configuracoes/seguradora'
      OnAction = WMSiteactConfiguracoesSeguradorasBuscaAction
    end
    item
      Name = 'actAmigo'
      PathInfo = '/amigo'
      OnAction = WMSiteactAmigoAction
    end
    item
      Name = 'actTeste'
      PathInfo = '/testes/xmlimpressao'
      OnAction = WMSiteactTesteAction
    end
    item
      MethodType = mtGet
      Name = 'actImprimindoCarta'
      PathInfo = '/cte/correcao/imprimir'
      OnAction = WMSiteactImprimindoCartaAction
    end
    item
      MethodType = mtPost
      Name = 'actVeiculosRegistrar'
      PathInfo = '/veiculos'
      OnAction = WMSiteactVeiculosRegistrarAction
    end
    item
      MethodType = mtGet
      Name = 'actMdfeConsultaGet'
      PathInfo = '/mdfe/consulta'
      OnAction = WMSiteactMdfeConsultaGetAction
    end
    item
      MethodType = mtGet
      Name = 'actRelCad'
      PathInfo = '/relatorios/cadastrais'
      OnAction = WMSiteactRelCadClientesAction
    end
    item
      MethodType = mtGet
      Name = 'actRelOper'
      PathInfo = '/relatorios/operacionais'
      OnAction = WMSiteactRelOperAction
    end>
  BeforeDispatch = WebModuleBeforeDispatch
  Height = 521
  Width = 865
  object ServerFunctionInvoker: TPageProducer
    HTMLFile = 'Templates\ServerFunctionInvoker.html'
    OnHTMLTag = ServerFunctionInvokerHTMLTag
    Left = 78
    Top = 145
  end
  object ReverseString: TPageProducer
    HTMLFile = 'templates\ReverseString.html'
    OnHTMLTag = ServerFunctionInvokerHTMLTag
    Left = 192
    Top = 30
  end
  object WebFileDispatcher1: TWebFileDispatcher
    WebFileExtensions = <
      item
        MimeType = 'text/css'
        Extensions = 'css'
      end
      item
        MimeType = 'text/javascript'
        Extensions = 'js'
      end
      item
        MimeType = 'image/x-png'
        Extensions = 'png'
      end
      item
        MimeType = 'text/html'
        Extensions = 'htm;html'
      end
      item
        MimeType = 'image/jpeg'
        Extensions = 'jpg;jpeg;jpe'
      end
      item
        MimeType = 'image/gif'
        Extensions = 'gif'
      end
      item
        MimeType = 'application/pdf'
        Extensions = 'pdf'
      end
      item
        MimeType = 'application/x-zip-compressed'
        Extensions = 'zip'
      end
      item
        MimeType = 'application/vnd.oasis.opendocument.spreadsheet-template'
        Extensions = 'ots'
      end
      item
        Extensions = 'ttf'
      end
      item
        MimeType = 'image/svg+xml'
        Extensions = 'svg;svgz'
      end>
    BeforeDispatch = WebFileDispatcher1BeforeDispatch
    AfterDispatch = WebFileDispatcher1AfterDispatch
    WebDirectories = <
      item
        DirectoryAction = dirInclude
        DirectoryMask = '*'
      end
      item
        DirectoryAction = dirExclude
        DirectoryMask = '\templates\*'
      end>
    RootDirectory = '.'
    VirtualPath = '/'
    Left = 81
    Top = 96
  end
  object DSProxyGenerator1: TDSProxyGenerator
    ExcludeClasses = 'DSMetadata'
    MetaDataProvider = DSServerMetaDataProvider1
    Writer = 'Java Script REST'
    Left = 77
    Top = 216
  end
  object DSServerMetaDataProvider1: TDSServerMetaDataProvider
    Server = ServerContainer1.DSServer1
    Left = 74
    Top = 272
  end
  object IdMessage1: TIdMessage
    AttachmentEncoding = 'UUE'
    BccList = <>
    CCList = <>
    Encoding = meDefault
    FromList = <
      item
      end>
    Recipients = <>
    ReplyTo = <>
    ConvertPreamble = True
    Left = 72
    Top = 384
  end
  object postos: TPageProducer
    Left = 192
    Top = 88
  end
  object tLimpaPDF: TTimer
    Left = 584
    Top = 48
  end
  object IdHTTP1: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 256
    Top = 88
  end
  object HTTPRIO1: THTTPRIO
    HTTPWebNode.UseUTF8InHeader = True
    HTTPWebNode.InvokeOptions = [soIgnoreInvalidCerts, soAutoCheckAccessPointViaUDDI]
    HTTPWebNode.WebNodeOptions = []
    Converter.Options = [soSendMultiRefObj, soTryAllSchema, soRootRefNodesToBody, soCacheMimeResponse, soUTF8EncodeXML]
    Left = 264
    Top = 32
  end
  object DSHTTPWebDispatcher1: TDSHTTPWebDispatcher
    Filters = <>
    Left = 80
    Top = 32
  end
end
