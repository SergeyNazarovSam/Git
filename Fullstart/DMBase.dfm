object DBase: TDBase
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
  object IB_ConnectionFelix: TFDConnection
    Params.Strings = (
      'User_Name=sysdba'
      'Password=x'
      'Database=C:\DATABASE\FELIX_GLOECKNERIN.FDB'
      'CharacterSet=UTF8'
      'DriverID=FB')
    LoginPrompt = False
    Transaction = IB_TransactionFelix
    Left = 80
    Top = 64
  end
  object FIREBIRD: TFDPhysFBDriverLink
    Left = 80
    Top = 8
  end
  object WAITCOURSOR: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 224
    Top = 144
  end
  object QueryGetNextID: TFDQuery
    Connection = IB_ConnectionFelix
    Left = 400
    Top = 184
  end
  object FDManager1: TFDManager
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <>
    Active = True
    Left = 80
    Top = 200
  end
  object IB_DSQLExecute: TFDQuery
    Connection = IB_ConnectionFelix
    Left = 384
    Top = 120
  end
  object IB_TransactionFelix: TFDTransaction
    Connection = IB_ConnectionFelix
    Left = 80
    Top = 120
  end
end
