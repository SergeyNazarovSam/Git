object VCLForm: TVCLForm
  Left = 0
  Top = 0
  Caption = 'VCLForm'
  ClientHeight = 219
  ClientWidth = 335
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button: TButton
    Left = 112
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Button'
    TabOrder = 0
    OnClick = ButtonClick
  end
end
