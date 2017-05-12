object DataModuleBase: TDataModuleBase
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 356
  Width = 674
  object TimerConnect: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerConnectTimer
    Left = 240
    Top = 64
  end
  object FDConnectionFelix: TFDConnection
    Params.Strings = (
      'User_Name=sysdba'
      'Password=x'
      'Database=C:\DATABASE\FELIX_GLOECKNERIN.FDB'
      'CharacterSet=UTF8'
      'DriverID=FB')
    LoginPrompt = False
    Transaction = FDTransactionFelix
    Left = 80
    Top = 64
  end
  object FDPhysFBDriverLinkFireBird: TFDPhysFBDriverLink
    Left = 80
    Top = 8
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 224
    Top = 144
  end
  object FDQueryGetNextID: TFDQuery
    Connection = FDConnectionFelix
    Left = 400
    Top = 184
  end
  object FDManager: TFDManager
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <>
    Active = True
    Left = 80
    Top = 200
  end
  object FDQuery: TFDQuery
    Connection = FDConnectionFelix
    Left = 384
    Top = 120
  end
  object FDTransactionFelix: TFDTransaction
    Connection = FDConnectionFelix
    Left = 80
    Top = 120
  end
end
