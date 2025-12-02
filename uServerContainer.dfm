object ServerContainer1: TServerContainer1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 271
  Width = 415
  object DSServer1: TDSServer
    Left = 16
    Top = 3
  end
  object DSServerClass1: TDSServerClass
    OnGetClass = DSServerClass1GetClass
    Server = DSServer1
    Left = 80
    Top = 3
  end
  object DSTCPServerTransport1: TDSTCPServerTransport
    Port = 230
    Server = DSServer1
    Filters = <>
    Left = 200
    Top = 4
  end
end
