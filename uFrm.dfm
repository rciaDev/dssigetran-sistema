object frmPrin: TfrmPrin
  Left = 271
  Top = 114
  Caption = 'Sigetran Sistema - Vers'#227'o 1.1.3'
  ClientHeight = 355
  ClientWidth = 844
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu2
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 48
    Width = 23
    Height = 18
    Caption = 'Port'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Trebuchet MS'
    Font.Style = []
    ParentFont = False
  end
  object bIni: TButton
    Left = 24
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Start'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Trebuchet MS'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = bIniClick
  end
  object bPare: TButton
    Left = 105
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Stop'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Trebuchet MS'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = bPareClick
  end
  object EditPort: TEdit
    Left = 24
    Top = 72
    Width = 75
    Height = 26
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Trebuchet MS'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Text = '8086'
    OnExit = EditPortExit
  end
  object pnlJS: TPanel
    Left = 24
    Top = 191
    Width = 265
    Height = 65
    Caption = 'Atualizando JS'
    Color = 4259584
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 3
  end
  object pnlBancos: TPanel
    Left = 24
    Top = 232
    Width = 265
    Height = 90
    Caption = 'Atualizando Bancos'
    Color = clCream
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 4
    Visible = False
  end
  object chkAtualizaBancos: TCheckBox
    Left = 24
    Top = 112
    Width = 156
    Height = 17
    Caption = 'Atualiza Banco de Dados'
    TabOrder = 5
    OnClick = chkAtualizaBancosClick
  end
  object chkCrm: TCheckBox
    Left = 24
    Top = 135
    Width = 156
    Height = 17
    Caption = 'Envia para CRM'
    TabOrder = 6
    OnClick = chkCrmClick
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 768
    Top = 120
  end
  object TAtualizaDB: TTimer
    Interval = 5000
    OnTimer = TAtualizaDBTimer
    Left = 704
    Top = 16
  end
  object PopupMenu2: TPopupMenu
    Left = 776
    Top = 16
    object At1: TMenuItem
      Caption = 'Atualizar Bancos'
      OnClick = At1Click
    end
  end
  object TMensagem: TTimer
    OnTimer = TMensagemTimer
    Left = 624
    Top = 16
  end
end
