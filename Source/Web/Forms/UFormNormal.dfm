inherited fFormNormal: TfFormNormal
  Caption = 'fFormNormal'
  PixelsPerInch = 96
  TextHeight = 13
  object BtnExit: TUniFSButton [0]
    Left = 219
    Top = 136
    Width = 75
    Height = 25
    Hint = ''
    StyleButton = Default
    BadgeText.Text = '0'
    BadgeText.TextColor = '#FFFFFF'
    BadgeText.TextSize = 10
    BadgeText.TextStyle = 'bold'
    BadgeText.BackgroundColor = '#D50000'
    Caption = #21462#28040
    Cancel = True
    TabOrder = 0
  end
  object BtnOK: TUniFSButton [1]
    Left = 136
    Top = 136
    Width = 75
    Height = 25
    Hint = ''
    StyleButton = Default
    BadgeText.Text = '0'
    BadgeText.TextColor = '#FFFFFF'
    BadgeText.TextSize = 10
    BadgeText.TextStyle = 'bold'
    BadgeText.BackgroundColor = '#D50000'
    Caption = #30830#23450
    TabOrder = 1
    OnClick = BtnOKClick
  end
  inherited PanelWork: TUniSimplePanel
    Height = 120
    TabOrder = 2
    ExplicitHeight = 120
  end
end
