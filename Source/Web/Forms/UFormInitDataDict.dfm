inherited fFormInitDataDict: TfFormInitDataDict
  ClientHeight = 344
  ClientWidth = 494
  Caption = #21021#22987#21270#25968#25454#23383#20856
  ExplicitWidth = 500
  ExplicitHeight = 369
  PixelsPerInch = 96
  TextHeight = 12
  inherited PanelWork: TUniSimplePanel
    Width = 478
    Height = 324
    ExplicitWidth = 478
    ExplicitHeight = 324
    object EditLog: TUniMemo
      Left = 8
      Top = 42
      Width = 460
      Height = 272
      Hint = ''
      ScrollBars = ssBoth
      Anchors = [akLeft, akTop, akRight, akBottom]
      ReadOnly = True
      TabOrder = 1
    end
    object EditLang: TUniComboBox
      Left = 8
      Top = 12
      Width = 377
      Hint = ''
      Style = csDropDownList
      Text = ''
      TabOrder = 2
      FieldLabel = #25968#25454#23383#20856#35821#35328
      FieldLabelWidth = 80
      IconItems = <>
    end
    object BtnStart: TUniButton
      Left = 393
      Top = 10
      Width = 75
      Height = 25
      Hint = ''
      Caption = #24320#22987
      TabOrder = 3
      OnClick = BtnStartClick
    end
  end
end
