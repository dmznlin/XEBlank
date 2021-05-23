object fFormLogin: TfFormLogin
  Left = 0
  Top = 0
  ClientHeight = 265
  ClientWidth = 354
  Caption = #30331#24405
  OldCreateOrder = False
  BorderIcons = [biSystemMenu]
  MonitoredKeys.Keys = <>
  OnCreate = UniLoginFormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ImageLogo: TUniImage
    Left = 0
    Top = 0
    Width = 354
    Height = 132
    Hint = ''
    Align = alTop
  end
  object UniSimplePanel1: TUniSimplePanel
    Left = 12
    Top = 142
    Width = 330
    Height = 80
    Hint = ''
    ParentColor = False
    Border = True
    TabOrder = 1
    object UniLabel1: TUniLabel
      Left = 12
      Top = 17
      Width = 54
      Height = 12
      Hint = ''
      Caption = #29992#25143#21517#31216':'
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 1
    end
    object EditUser: TUniEdit
      Left = 72
      Top = 12
      Width = 175
      Hint = ''
      Text = ''
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 2
    end
    object UniLabel2: TUniLabel
      Left = 12
      Top = 50
      Width = 54
      Height = 12
      Hint = ''
      Caption = #30331#24405#23494#30721':'
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 3
    end
    object EditPwd: TUniEdit
      Left = 72
      Top = 45
      Width = 175
      Hint = ''
      PasswordChar = '*'
      Text = ''
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 4
    end
    object ImageKey: TUniImage
      Left = 260
      Top = 12
      Width = 55
      Height = 55
      Hint = ''
    end
  end
  object BtnOK: TUniFSMenuButton
    Left = 175
    Top = 230
    Width = 85
    Height = 25
    Hint = ''
    DropdownMenu = PMenu1
    Caption = #30331#24405
    TabOrder = 2
    ScreenMask.Enabled = True
    ScreenMask.Message = #27491#22312#30331#24405
    ScreenMask.Target = Owner
    OnClick = BtnOKClick
    StyleMenuButton = Default
    BadgeText.Text = '0'
    BadgeText.TextColor = '#FFFFFF'
    BadgeText.TextSize = 10
    BadgeText.TextStyle = 'bold'
    BadgeText.BackgroundColor = '#D50000'
  end
  object BtnExit: TUniFSButton
    Left = 266
    Top = 230
    Width = 75
    Height = 25
    Hint = ''
    StyleButton = Default
    BadgeText.Text = '0'
    BadgeText.TextColor = '#FFFFFF'
    BadgeText.TextSize = 10
    BadgeText.TextStyle = 'bold'
    BadgeText.BackgroundColor = '#D50000'
    Caption = #36864#20986
    TabOrder = 3
    OnClick = BtnExitClick
  end
  object PMenu1: TUniPopupMenu
    Left = 16
    Top = 16
    object N1: TUniMenuItem
      Caption = #31649#29702#21592#24037#20855
      object MenuDES: TUniMenuItem
        Caption = #25968#25454#32534#30721' && '#35299#30721
        OnClick = MenuDESClick
      end
      object N2: TUniMenuItem
        Caption = '-'
      end
      object MenuInitDB: TUniMenuItem
        Caption = #21021#22987#21270#25968#25454#24211
        OnClick = MenuInitDBClick
      end
      object MenuInitMenu: TUniMenuItem
        Caption = #21021#22987#21270#31995#32479#33756#21333
        OnClick = MenuInitMenuClick
      end
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
    Left = 128
    Top = 16
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
    Left = 72
    Top = 16
  end
end
