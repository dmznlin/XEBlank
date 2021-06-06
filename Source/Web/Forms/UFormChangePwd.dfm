inherited fFormChangePwd: TfFormChangePwd
  ClientHeight = 152
  ClientWidth = 265
  Caption = #20462#25913#23494#30721
  ExplicitWidth = 271
  ExplicitHeight = 177
  PixelsPerInch = 96
  TextHeight = 12
  inherited BtnExit: TUniFSButton
    Left = 182
    Top = 118
    TabOrder = 2
    ExplicitLeft = 182
    ExplicitTop = 126
  end
  inherited BtnOK: TUniFSButton
    Left = 99
    Top = 118
    ExplicitLeft = 99
    ExplicitTop = 126
  end
  inherited PanelWork: TUniSimplePanel
    Width = 249
    Height = 102
    TabOrder = 0
    ExplicitWidth = 249
    ExplicitHeight = 110
    object EditTwice: TUniEdit
      Left = 5
      Top = 70
      Width = 235
      Hint = ''
      PasswordChar = '*'
      MaxLength = 32
      Text = ''
      TabOrder = 3
      FieldLabel = #20877#36755#19968#27425':'
      FieldLabelWidth = 60
    end
    object EditNew: TUniEdit
      Left = 5
      Top = 41
      Width = 235
      Hint = ''
      PasswordChar = '*'
      MaxLength = 32
      Text = ''
      TabOrder = 2
      FieldLabel = #26032#30340#23494#30721':'
      FieldLabelWidth = 60
    end
    object EditPwd: TUniEdit
      Left = 5
      Top = 12
      Width = 235
      Hint = ''
      PasswordChar = '*'
      MaxLength = 32
      Text = ''
      TabOrder = 1
      FieldLabel = #21407#26377#23494#30721':'
      FieldLabelWidth = 60
    end
  end
end
