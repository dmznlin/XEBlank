inherited fFormMemStatus: TfFormMemStatus
  ClientHeight = 473
  ClientWidth = 692
  Caption = #31995#32479#20869#23384#29366#24577
  BorderStyle = bsSizeable
  ExplicitWidth = 700
  ExplicitHeight = 500
  PixelsPerInch = 96
  TextHeight = 12
  inherited PanelWork: TUniSimplePanel
    Width = 676
    Height = 453
    ExplicitWidth = 478
    ExplicitHeight = 324
    object EditLog: TUniMemo
      Left = 8
      Top = 42
      Width = 658
      Height = 401
      Hint = ''
      ScrollBars = ssBoth
      Anchors = [akLeft, akTop, akRight, akBottom]
      ReadOnly = True
      TabOrder = 1
      ExplicitWidth = 460
      ExplicitHeight = 272
    end
    object BtnRefresh: TUniButton
      Left = 8
      Top = 10
      Width = 75
      Height = 25
      Hint = ''
      Caption = #21047#26032
      TabOrder = 2
      OnClick = BtnRefreshClick
    end
  end
end
