inherited fFormDynPwd: TfFormDynPwd
  ClientHeight = 350
  ClientWidth = 327
  Caption = #21160#24577#21475#20196
  ExplicitWidth = 333
  ExplicitHeight = 375
  PixelsPerInch = 96
  TextHeight = 12
  inherited BtnExit: TUniFSButton
    Left = 244
    Top = 316
    ExplicitLeft = 244
    ExplicitTop = 326
  end
  inherited BtnOK: TUniFSButton
    Left = 161
    Top = 316
    ExplicitLeft = 161
    ExplicitTop = 326
  end
  inherited PanelWork: TUniSimplePanel
    Width = 311
    Height = 300
    Border = True
    ExplicitWidth = 311
    ExplicitHeight = 310
    object EditCode: TUniEdit
      Left = 91
      Top = 270
      Width = 128
      Hint = ''
      Text = ''
      TabOrder = 1
      FieldLabelWidth = 60
    end
    object UniLabel1: TUniLabel
      Left = 5
      Top = 15
      Width = 588
      Height = 12
      Hint = ''
      TextConversion = txtHTML
      Caption = #35828#26126#65306#21160#24577#21475#20196#20351#29992#29305#27530#31639#27861#65292#27599#38388#38548'30'#31186#26356#26032#19968#27425#24744#30340'<br>'#23494#30721#65292#26497#22823#38480#24230#30340#20445#25252#36134#25143#23433#20840#12290#24320#21551#26041#27861#22914#19979#65306
      TabOrder = 2
    end
    object UniLabel2: TUniLabel
      Left = 5
      Top = 60
      Width = 600
      Height = 12
      Hint = ''
      TextConversion = txtHTML
      Caption = 
        '1'#12289#22312#25163#26426#19978#23433#35013#21160#24577#23494#30721'App'#65292#33529#26524#21644#23433#21331#29992#25143#35831#25171#24320'<br>'#36719#20214#24066#22330#25628#32034'"Google Authenticator"'#65292#19979#36733#24182#23433#35013 +
        #12290
      TabOrder = 3
    end
    object UniLabel3: TUniLabel
      Left = 5
      Top = 95
      Width = 216
      Height = 12
      Hint = ''
      TextConversion = txtHTML
      Caption = '2'#12289#22312#25163#26426#19978#25171#24320'App'#24182#25195#25551#19979#26041#20108#32500#30721#65306
      TabOrder = 4
    end
    object ImageCode: TUniImage
      Left = 91
      Top = 115
      Width = 128
      Height = 128
      Hint = ''
      Center = True
      Stretch = True
    end
    object UniLabel4: TUniLabel
      Left = 5
      Top = 250
      Width = 198
      Height = 12
      Hint = ''
      TextConversion = txtHTML
      Caption = '3'#12289#22312#19979#38754#36755#20837'App'#19978#26174#31034#30340'6'#20301#25968#23383#65306
      TabOrder = 6
    end
  end
  object CheckClose: TUniCheckBox
    Left = 8
    Top = 316
    Width = 97
    Height = 17
    Hint = ''
    Caption = #20851#38381#21160#24577#23494#30721
    TabOrder = 3
  end
end
