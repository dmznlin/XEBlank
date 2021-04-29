inherited fFormInitDB: TfFormInitDB
  ClientHeight = 344
  ClientWidth = 494
  Caption = #21021#22987#21270#25968#25454#24211
  ExplicitWidth = 500
  ExplicitHeight = 373
  PixelsPerInch = 96
  TextHeight = 12
  inherited PanelWork: TUniSimplePanel
    Width = 478
    Height = 324
    ExplicitWidth = 478
    ExplicitHeight = 324
    object UniLabel1: TUniLabel
      Left = 8
      Top = 17
      Width = 66
      Height = 12
      Hint = ''
      Caption = #25968#25454#24211#21015#34920':'
      TabOrder = 1
    end
    object EditDB: TUniComboBox
      Left = 80
      Top = 12
      Width = 305
      Hint = ''
      Style = csDropDownList
      Text = ''
      TabOrder = 2
      IconItems = <>
    end
    object EditLog: TUniMemo
      Left = 8
      Top = 42
      Width = 460
      Height = 272
      Hint = ''
      ScrollBars = ssBoth
      Anchors = [akLeft, akTop, akRight, akBottom]
      ReadOnly = True
      TabOrder = 3
    end
    object BtnStart: TUniButton
      Left = 393
      Top = 10
      Width = 75
      Height = 25
      Hint = ''
      Caption = #24320#22987
      TabOrder = 4
      OnClick = BtnStartClick
    end
  end
end
