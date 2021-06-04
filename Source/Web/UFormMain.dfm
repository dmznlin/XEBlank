object fFormMain: TfFormMain
  Left = 0
  Top = 0
  ClientHeight = 544
  ClientWidth = 773
  Caption = ''
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  Font.Charset = GB2312_CHARSET
  Font.Height = -12
  Font.Name = #23435#20307
  OnCreate = UniFormCreate
  OnDestroy = UniFormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object PanelTop: TUniSimplePanel
    Left = 0
    Top = 0
    Width = 773
    Height = 80
    Hint = ''
    ParentColor = False
    Align = alTop
    TabOrder = 0
    object ImageRight: TUniImage
      Left = 552
      Top = 0
      Width = 221
      Height = 80
      Hint = ''
      AutoSize = True
      Align = alRight
    end
    object ImageLeft: TUniImage
      Left = 0
      Top = 0
      Width = 552
      Height = 80
      Hint = ''
      Align = alClient
    end
    object LabelHint: TUniLabel
      Left = 15
      Top = 40
      Width = 90
      Height = 20
      Hint = ''
      Caption = 'HintLabel'
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Color = clWhite
      Font.Height = -20
      Font.Name = #26999#20307
      TabOrder = 3
    end
  end
  object StatusBar1: TUniStatusBar
    Left = 0
    Top = 525
    Width = 773
    Height = 19
    Hint = ''
    Panels = <>
    SizeGrip = False
    Align = alBottom
    ParentColor = False
    Color = clWindow
  end
  object PanelClient: TUniSimplePanel
    Left = 0
    Top = 80
    Width = 773
    Height = 445
    Hint = ''
    ParentColor = False
    Align = alClient
    TabOrder = 2
    object PanelLeft: TUniContainerPanel
      Left = 0
      Top = 0
      Width = 256
      Height = 445
      Hint = ''
      ParentColor = False
      Align = alLeft
      AlignmentControl = uniAlignmentClient
      ParentAlignmentControl = False
      TabOrder = 1
      object PanelLeftTop: TUniPanel
        Left = 0
        Top = 0
        Width = 256
        Height = 50
        Hint = ''
        Align = alTop
        TabOrder = 1
        BorderStyle = ubsNone
        TitleVisible = True
        Title = #21151#33021#23548#33322
        Caption = ''
        Layout = 'hbox'
        object BtnGetMsg: TUniFSButton
          Left = 0
          Top = 0
          Width = 36
          Height = 50
          Hint = #36890#30693#28040#24687
          ShowHint = True
          ParentShowHint = False
          StyleButton = Transparent
          BadgeText.Text = '0'
          BadgeText.TextColor = '#FFFFFF'
          BadgeText.TextSize = 10
          BadgeText.TextStyle = 'bold'
          BadgeText.BackgroundColor = '#D50000'
          BadgeText.Visible = True
          Caption = ''
          Align = alLeft
          TabOrder = 2
          Images = UniMainModule.SmallImages
          ImageIndex = 25
        end
        object BtnExpand: TUniFSButton
          Left = 36
          Top = 0
          Width = 23
          Height = 50
          Hint = #23637#24320#33756#21333
          ShowHint = True
          ParentShowHint = False
          StyleButton = Transparent
          BadgeText.Text = '0'
          BadgeText.TextColor = '#FFFFFF'
          BadgeText.TextSize = 10
          BadgeText.TextStyle = 'bold'
          BadgeText.BackgroundColor = '#D50000'
          Caption = ''
          Align = alLeft
          TabOrder = 3
          Images = UniMainModule.SmallImages
          ImageIndex = 17
          OnClick = BtnExpandClick
        end
        object BtnCollapse: TUniFSButton
          Left = 59
          Top = 0
          Width = 23
          Height = 50
          Hint = #25910#36215#33756#21333
          ShowHint = True
          ParentShowHint = False
          StyleButton = Transparent
          BadgeText.Text = '0'
          BadgeText.TextColor = '#FFFFFF'
          BadgeText.TextSize = 10
          BadgeText.TextStyle = 'bold'
          BadgeText.BackgroundColor = '#D50000'
          Caption = ''
          Align = alLeft
          TabOrder = 4
          Images = UniMainModule.SmallImages
          ImageIndex = 18
          OnClick = BtnExpandClick
        end
        object EditSearch: TUniComboBox
          Left = 82
          Top = 0
          Width = 174
          Height = 50
          Hint = ''
          ShowHint = True
          ParentShowHint = False
          Text = ''
          Align = alClient
          TabOrder = 1
          MinQueryLength = 3
          CheckChangeDelay = 250
          ClearButton = True
          FieldLabelWidth = 250
          Triggers = <
            item
              ButtonId = 0
              IconCls = 'x-form-search-trigger'
              HandleClicks = True
            end>
          IconItems = <>
          OnChange = EditSearchChange
          OnTriggerEvent = EditSearchTriggerEvent
        end
      end
      object PanelMenus: TUniContainerPanel
        Left = 0
        Top = 50
        Width = 256
        Height = 395
        Hint = ''
        ParentColor = False
        Align = alClient
        TabOrder = 2
        Layout = 'accordion'
      end
    end
    object PageWork: TUniPageControl
      Left = 262
      Top = 0
      Width = 511
      Height = 445
      Hint = ''
      ActivePage = SheetWelcome
      Align = alClient
      TabOrder = 2
      object SheetWelcome: TUniTabSheet
        Hint = ''
        AlignmentControl = uniAlignmentClient
        ParentAlignmentControl = False
        Caption = #27426#36814#39318#39029
        Layout = 'hbox'
        LayoutAttribs.Align = 'bottom'
        LayoutAttribs.Pack = 'end'
        object LabelCopyRight: TUniLabel
          Left = 0
          Top = 395
          Width = 503
          Height = 22
          Hint = ''
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'CopyRight'
          Align = alBottom
          ParentFont = False
          Font.Charset = GB2312_CHARSET
          Font.Color = clGray
          Font.Height = -12
          Font.Name = #23435#20307
          TabOrder = 0
          LayoutConfig.Padding = '0 20 0 0'
        end
        object ImageWelcome: TUniImage
          Left = 176
          Top = 128
          Width = 128
          Height = 128
          Hint = ''
          Stretch = True
          LayoutConfig.Padding = '0 20 0 0'
        end
      end
    end
    object SplitterLeft: TUniSplitter
      Left = 256
      Top = 0
      Width = 6
      Height = 445
      Hint = ''
      Align = alLeft
      ParentColor = False
      Color = clBtnFace
    end
  end
  object FSToast1: TUniFSToast
    TitleSize = 13
    TitleLineHeight = 0
    MsgSize = 12
    MsgLineHeight = 0
    Theme = Dark
    ImageWidth = 0
    MaxWidth = 0
    zIndex = 99999
    Layout = SmallInt
    Balloon = False
    Close = True
    CloseOnEscape = False
    RTL = False
    Position = bottomRight
    TimeOut = 5000
    Drag = True
    Overlay = False
    ToastOnce = False
    PauseOnHover = True
    ResetOnHover = False
    ProgressBar = True
    ProgressBarColor = 'rgb(0, 255, 184)'
    ScreenMask.Enabled = False
    Animateinside = True
    TransitionIn = fadeInUp
    TransitionOut = fadeOut
    TransitionInMobile = fadeInUp
    TransitionOutMobile = fadeOutDown
    ButtonTextYes = 'Confirma'
    ButtonTextNo = 'Cancela'
    Left = 80
    Top = 184
  end
  object FSConfirm1: TUniFSConfirm
    Theme = modern
    TypeColor = blue
    TypeAnimated = False
    Draggable = False
    EscapeKey = False
    CloseIcon = False
    Icon = 'fa fa-smile-o'
    RTL = False
    boxWidth = '380px'
    ButtonTextConfirm = 'Confirma'
    ButtonTextCancel = 'Cancela'
    ScreenMask.Enabled = False
    ScreenMask.Text = 'Processing'
    PromptType.TypePrompt = text
    PromptType.RequiredField = False
    PromptType.TextRequiredField = 'Field riquired'
    Left = 24
    Top = 184
  end
  object PMenu1: TUniPopupMenu
    Images = UniMainModule.SmallImages
    Left = 135
    Top = 184
    object MenuExpand: TUniMenuItem
      Caption = #20840#37096#23637#24320
      ImageIndex = 17
      OnClick = BtnExpandClick
    end
    object MenuCollapse: TUniMenuItem
      Caption = #20840#37096#25910#36215
      ImageIndex = 18
      OnClick = BtnExpandClick
    end
    object MenuS1: TUniMenuItem
      Caption = '-'
    end
    object MenuEdit: TUniMenuItem
      Caption = #32534#36753#33756#21333
      ImageIndex = 4
      OnClick = MenuEditClick
    end
    object MenuDel: TUniMenuItem
      Caption = #21024#38500#33756#21333
      ImageIndex = 6
      OnClick = MenuDelClick
    end
  end
end
