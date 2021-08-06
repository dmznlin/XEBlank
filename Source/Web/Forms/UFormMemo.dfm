inherited fFormMemo: TfFormMemo
  ClientHeight = 247
  ClientWidth = 371
  Caption = ''
  BorderStyle = bsSizeable
  ExplicitWidth = 379
  ExplicitHeight = 274
  PixelsPerInch = 96
  TextHeight = 12
  inherited BtnExit: TUniFSButton
    Left = 288
    Top = 213
    ExplicitLeft = 288
    ExplicitTop = 213
  end
  inherited BtnOK: TUniFSButton
    Left = 205
    Top = 213
    ExplicitLeft = 205
    ExplicitTop = 213
  end
  inherited PanelWork: TUniSimplePanel
    Width = 355
    Height = 197
    ExplicitWidth = 355
    ExplicitHeight = 197
    object Memo1: TUniHTMLMemo
      Left = 0
      Top = 0
      Width = 355
      Height = 197
      Hint = ''
      ScrollBars = ssBoth
      Align = alClient
      Color = clWindow
      TabOrder = 1
    end
  end
end
