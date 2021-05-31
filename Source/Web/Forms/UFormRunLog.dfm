inherited fFormRunLog: TfFormRunLog
  ClientHeight = 441
  ClientWidth = 645
  Caption = #31995#32479#36816#34892#26085#24535
  BorderStyle = bsSizeable
  ExplicitWidth = 653
  ExplicitHeight = 468
  PixelsPerInch = 96
  TextHeight = 12
  inherited PanelWork: TUniSimplePanel
    Width = 629
    Height = 421
    ExplicitWidth = 629
    ExplicitHeight = 421
    object EditLog: TUniMemo
      Left = 8
      Top = 42
      Width = 611
      Height = 369
      Hint = ''
      ScrollBars = ssBoth
      Anchors = [akLeft, akTop, akRight, akBottom]
      ReadOnly = True
      TabOrder = 1
    end
    object CheckShow: TUniCheckBox
      Left = 517
      Top = 14
      Width = 102
      Height = 17
      Hint = ''
      Caption = #26174#31034#23454#26102#26085#24535
      Anchors = [akTop, akRight]
      TabOrder = 2
      OnChange = CheckShowChange
    end
    object EditDate: TUniDateTimePicker
      Left = 8
      Top = 12
      Width = 160
      Hint = ''
      DateTime = 44347.000000000000000000
      DateFormat = 'yyyy-MM-dd'
      TimeFormat = 'HH:mm:ss'
      TabOrder = 3
      FieldLabel = #26085#26399':'
      FieldLabelWidth = 32
    end
    object BtnLoad: TUniButton
      Left = 176
      Top = 11
      Width = 75
      Height = 25
      Hint = ''
      Caption = #21152#36733
      TabOrder = 4
      OnClick = BtnLoadClick
    end
    object CheckSimple: TUniCheckBox
      Left = 265
      Top = 15
      Width = 102
      Height = 17
      Hint = ''
      Caption = #21152#36733#31616#26131#26085#24535
      TabOrder = 5
      OnChange = CheckShowChange
    end
  end
end
