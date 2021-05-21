inherited fFormInitMenus: TfFormInitMenus
  ClientHeight = 344
  ClientWidth = 494
  Caption = #21021#22987#21270#31995#32479#33756#21333
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
    object BtnStart: TUniButton
      Left = 8
      Top = 10
      Width = 75
      Height = 25
      Hint = ''
      Caption = #24320#22987
      TabOrder = 2
      OnClick = BtnStartClick
    end
  end
end
