inherited fFormDateFilter: TfFormDateFilter
  ClientHeight = 140
  ClientWidth = 319
  Caption = ''
  ExplicitWidth = 325
  ExplicitHeight = 165
  PixelsPerInch = 96
  TextHeight = 12
  inherited BtnExit: TUniFSButton
    Left = 236
    Top = 106
    ExplicitLeft = 191
    ExplicitTop = 106
  end
  inherited BtnOK: TUniFSButton
    Left = 153
    Top = 106
    ExplicitLeft = 108
    ExplicitTop = 106
  end
  inherited PanelWork: TUniSimplePanel
    Width = 303
    Height = 90
    Border = True
    ExplicitWidth = 258
    ExplicitHeight = 90
    object EditBegin: TUniDateTimePicker
      Left = 5
      Top = 16
      Width = 290
      Hint = ''
      DateTime = 44415.000000000000000000
      DateFormat = 'yyyy-MM-dd'
      TimeFormat = 'HH:mm:ss'
      TabOrder = 1
      FieldLabelWidth = 58
    end
    object EditEnd: TUniDateTimePicker
      Left = 5
      Top = 56
      Width = 290
      Hint = ''
      DateTime = 44415.000000000000000000
      DateFormat = 'yyyy-MM-dd'
      TimeFormat = 'HH:mm:ss'
      TabOrder = 2
      FieldLabelWidth = 58
    end
  end
  object Check1: TUniCheckBox
    Left = 13
    Top = 110
    Width = 130
    Height = 17
    Hint = ''
    Caption = #26597#35810#26102#20351#29992
    TabOrder = 3
  end
end
