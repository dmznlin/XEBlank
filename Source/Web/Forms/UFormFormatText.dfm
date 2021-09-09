inherited fFormFormatTxt: TfFormFormatTxt
  ClientHeight = 278
  ClientWidth = 538
  Caption = #25991#26412#26684#24335#21270
  BorderStyle = bsSizeable
  ExplicitWidth = 546
  ExplicitHeight = 305
  PixelsPerInch = 96
  TextHeight = 12
  inherited PanelWork: TUniSimplePanel
    Width = 522
    Height = 258
    Border = True
    ExplicitWidth = 522
    ExplicitHeight = 258
    object PanelT: TUniSimplePanel
      Left = 0
      Top = 114
      Width = 522
      Height = 32
      Hint = ''
      ParentColor = False
      Border = True
      Align = alTop
      AlignmentControl = uniAlignmentClient
      ParentAlignmentControl = False
      TabOrder = 3
      Layout = 'hbox'
      LayoutAttribs.Pack = 'center'
      LayoutConfig.BodyCls = 'x-panel-border-bottom'
      object EditBlank: TUniNumberEdit
        Left = 2
        Top = 5
        Width = 125
        Hint = ''
        MaxLength = 3
        TabOrder = 2
        FieldLabel = #34892#39318#31354#26684':'
        FieldLabelWidth = 56
        LayoutConfig.Margin = '5 10 0 0'
        DecimalSeparator = '.'
      end
      object EditEnt: TUniEdit
        Left = 130
        Top = 5
        Width = 125
        Hint = ''
        MaxLength = 32
        Text = '#13#10'
        TabOrder = 5
        FieldLabel = #34892#23614#25442#34892':'
        FieldLabelWidth = 56
        LayoutConfig.Margin = '5 10 0 0'
      end
      object Check2: TUniCheckBox
        Left = 260
        Top = 7
        Width = 100
        Height = 17
        Hint = ''
        Caption = #34892#23614#34917#20805#31354#26684
        TabOrder = 4
        LayoutConfig.Margin = '5 10 0 0'
      end
      object BtnNormal: TUniButton
        Left = 365
        Top = 3
        Width = 75
        Height = 25
        Hint = ''
        Caption = #36824#21407#8593
        TabOrder = 3
        LayoutConfig.Margin = '3 5 0 0'
        OnClick = BtnNormalClick
      end
      object BtnFormat: TUniButton
        Left = 444
        Top = 3
        Width = 75
        Height = 25
        Hint = ''
        Caption = #36716#25442#8595
        TabOrder = 1
        LayoutConfig.Margin = '3 0 0 0'
        OnClick = BtnFormatClick
      end
    end
    object Splitter1: TUniSplitter
      Left = 0
      Top = 108
      Width = 522
      Height = 6
      Cursor = crVSplit
      Hint = ''
      Align = alTop
      ParentColor = False
      Color = clBtnFace
    end
    object EditNormal: TUniSyntaxEdit
      Left = 0
      Top = 0
      Width = 522
      Height = 108
      Hint = ''
      Lines.Strings = (
        #21407#22987#25991#26412)
      Language = 'SQL'
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      Align = alTop
    end
    object PanelC: TUniSimplePanel
      Left = 0
      Top = 146
      Width = 522
      Height = 112
      Hint = ''
      ParentColor = False
      Align = alClient
      object EditFormat: TUniSyntaxEdit
        Left = 0
        Top = 0
        Width = 522
        Height = 112
        Hint = ''
        Font.Charset = GB2312_CHARSET
        Font.Height = -12
        Font.Name = #23435#20307
        Align = alClient
      end
    end
  end
end
