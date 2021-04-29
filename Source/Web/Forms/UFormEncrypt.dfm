inherited fFormEncrypt: TfFormEncrypt
  ClientHeight = 344
  ClientWidth = 494
  Caption = #25968#25454#32534#30721' & '#35299#30721
  ExplicitWidth = 500
  ExplicitHeight = 369
  PixelsPerInch = 96
  TextHeight = 12
  inherited PanelWork: TUniSimplePanel
    Width = 478
    Height = 324
    ExplicitWidth = 443
    ExplicitHeight = 269
    object wPage1: TUniPageControl
      Left = 0
      Top = 0
      Width = 478
      Height = 324
      Hint = ''
      ActivePage = Sheet2
      Align = alClient
      TabOrder = 1
      ExplicitWidth = 443
      ExplicitHeight = 269
      object Sheet1: TUniTabSheet
        Hint = ''
        Caption = 'Base64'
        ExplicitWidth = 435
        ExplicitHeight = 241
        object BaseEncrypt: TUniMemo
          Left = 0
          Top = 201
          Width = 470
          Height = 95
          Hint = ''
          BorderStyle = ubsNone
          ScrollBars = ssBoth
          Align = alBottom
          TabOrder = 0
          ExplicitTop = 141
          ExplicitWidth = 435
        end
        object BaseEncode: TUniButton
          Left = 120
          Top = 165
          Width = 75
          Height = 25
          Hint = ''
          Caption = #32534#30721' '#8595
          TabOrder = 1
          OnClick = BaseEncodeClick
        end
        object BaseDecode: TUniButton
          Left = 250
          Top = 165
          Width = 75
          Height = 25
          Hint = ''
          Caption = #35299#30721' '#8593
          TabOrder = 2
          OnClick = BaseEncodeClick
        end
        object BaseText: TUniMemo
          Left = 0
          Top = 62
          Width = 470
          Height = 95
          Hint = ''
          BorderStyle = ubsNone
          ScrollBars = ssBoth
          Align = alTop
          TabOrder = 3
          ExplicitTop = 60
          ExplicitWidth = 487
        end
        object UniPanel1: TUniPanel
          Left = 0
          Top = 0
          Width = 470
          Height = 62
          Hint = ''
          Align = alTop
          TabOrder = 4
          BorderStyle = ubsNone
          TitleVisible = True
          Title = #21442#25968
          Caption = ''
          object CheckBase64: TUniCheckBox
            Left = 12
            Top = 8
            Width = 80
            Height = 17
            Hint = ''
            Caption = #33258#21160#20998#34892
            TabOrder = 1
          end
        end
      end
      object Sheet2: TUniTabSheet
        Hint = ''
        Caption = '3DES'
        ExplicitWidth = 435
        ExplicitHeight = 241
        object UniPanel2: TUniPanel
          Left = 0
          Top = 0
          Width = 470
          Height = 62
          Hint = ''
          Align = alTop
          TabOrder = 0
          BorderStyle = ubsNone
          TitleVisible = True
          Title = #21442#25968
          Caption = ''
          object CheckDes: TUniCheckBox
            Left = 220
            Top = 8
            Width = 112
            Height = 17
            Hint = ''
            Caption = #20351#29992#25968#25454#24211#23494#38053
            TabOrder = 1
          end
          object UniLabel1: TUniLabel
            Left = 12
            Top = 10
            Width = 54
            Height = 12
            Hint = ''
            Caption = #21152#23494#23494#38053':'
            TabOrder = 2
          end
          object EditKey: TUniEdit
            Left = 70
            Top = 5
            Width = 121
            Hint = ''
            PasswordChar = '*'
            Text = ''
            TabOrder = 3
          end
        end
        object DesText: TUniMemo
          Left = 0
          Top = 62
          Width = 470
          Height = 95
          Hint = ''
          BorderStyle = ubsNone
          ScrollBars = ssBoth
          Align = alTop
          TabOrder = 1
          ExplicitTop = 68
          ExplicitWidth = 487
        end
        object DesEncrypt: TUniMemo
          Left = 0
          Top = 201
          Width = 470
          Height = 95
          Hint = ''
          BorderStyle = ubsNone
          ScrollBars = ssBoth
          Align = alBottom
          TabOrder = 2
          ExplicitTop = 141
          ExplicitWidth = 435
        end
        object DesEncode: TUniButton
          Left = 120
          Top = 165
          Width = 75
          Height = 25
          Hint = ''
          Caption = #32534#30721' '#8595
          TabOrder = 3
          OnClick = DesEncodeClick
        end
        object DesDecode: TUniButton
          Left = 250
          Top = 165
          Width = 75
          Height = 25
          Hint = ''
          Caption = #35299#30721' '#8593
          TabOrder = 4
          OnClick = DesEncodeClick
        end
      end
    end
  end
end
