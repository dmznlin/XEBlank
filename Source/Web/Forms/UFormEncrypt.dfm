inherited fFormEncrypt: TfFormEncrypt
  ClientHeight = 344
  ClientWidth = 494
  Caption = #25968#25454#32534#30721' & '#35299#30721
  ExplicitWidth = 500
  ExplicitHeight = 373
  PixelsPerInch = 96
  TextHeight = 12
  inherited PanelWork: TUniSimplePanel
    Width = 478
    Height = 324
    ExplicitWidth = 478
    ExplicitHeight = 324
    object wPage1: TUniPageControl
      Left = 0
      Top = 0
      Width = 478
      Height = 324
      Hint = ''
      ActivePage = Sheet3
      Align = alClient
      TabOrder = 1
      object Sheet1: TUniTabSheet
        Hint = ''
        Caption = 'Base64'
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
            Width = 52
            Height = 13
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
      object Sheet3: TUniTabSheet
        Hint = ''
        Caption = 'AdminKey'
        object AKEncrypt: TUniMemo
          Left = 0
          Top = 201
          Width = 470
          Height = 95
          Hint = ''
          BorderStyle = ubsNone
          ScrollBars = ssBoth
          Align = alBottom
          TabOrder = 0
        end
        object AKEncode: TUniButton
          Left = 120
          Top = 165
          Width = 75
          Height = 25
          Hint = ''
          Caption = #32534#30721' '#8595
          TabOrder = 1
          OnClick = AKEncodeClick
        end
        object AKDecode: TUniButton
          Left = 250
          Top = 165
          Width = 75
          Height = 25
          Hint = ''
          Caption = #35299#30721' '#8593
          TabOrder = 2
          OnClick = AKEncodeClick
        end
        object AKText: TUniMemo
          Left = 0
          Top = 62
          Width = 470
          Height = 95
          Hint = ''
          BorderStyle = ubsNone
          ScrollBars = ssBoth
          Align = alTop
          TabOrder = 3
        end
        object UniPanel4: TUniPanel
          Left = 0
          Top = 0
          Width = 470
          Height = 62
          Hint = ''
          Align = alTop
          TabOrder = 4
          BorderStyle = ubsNone
          TitleVisible = True
          Title = #35828#26126
          Caption = ''
          object UniLabel2: TUniLabel
            Left = 12
            Top = 8
            Width = 292
            Height = 13
            Hint = ''
            Caption = #29992#20110#29983#25104#31649#29702#21592#23494#38053','#40664#35748#23384#25918#22312'"[Config] - AdminKey"'#20013'.'
            TabOrder = 1
          end
        end
      end
    end
  end
end
