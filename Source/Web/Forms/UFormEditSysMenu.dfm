inherited fFormEditSysMenu: TfFormEditSysMenu
  ClientHeight = 293
  ClientWidth = 412
  Caption = #32534#36753#33756#21333
  ExplicitWidth = 418
  ExplicitHeight = 322
  PixelsPerInch = 96
  TextHeight = 12
  inherited BtnExit: TUniFSButton
    Left = 329
    Top = 259
  end
  inherited BtnOK: TUniFSButton
    Left = 246
    Top = 259
  end
  inherited PanelWork: TUniSimplePanel
    Width = 396
    Height = 243
    object UniEdit1: TUniEdit
      Left = 64
      Top = 40
      Width = 225
      Hint = ''
      Text = 'UniEdit1'
      TabOrder = 1
    end
    object UniComboBox1: TUniComboBox
      Left = 64
      Top = 96
      Width = 225
      Hint = ''
      Text = 'UniComboBox1'
      TabOrder = 2
      IconItems = <
        item
        end>
    end
  end
end
