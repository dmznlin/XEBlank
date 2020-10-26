object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Admin Tookit'
  ClientHeight = 410
  ClientWidth = 520
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object SBar1: TdxStatusBar
    Left = 0
    Top = 390
    Width = 520
    Height = 20
    Panels = <
      item
        PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
        PanelStyle.Font.Charset = GB2312_CHARSET
        PanelStyle.Font.Color = clWindowText
        PanelStyle.Font.Height = -12
        PanelStyle.Font.Name = #23435#20307
        PanelStyle.Font.Style = []
        PanelStyle.ParentFont = False
        Width = 200
      end
      item
        PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
      end>
    PaintStyle = stpsUseLookAndFeel
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ExplicitLeft = 208
    ExplicitTop = 120
    ExplicitWidth = 0
  end
  object Layout1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 520
    Height = 390
    Align = alClient
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    LayoutLookAndFeel = FSM.dxLayoutWeb1
    ExplicitTop = -6
    ExplicitWidth = 692
    ExplicitHeight = 549
    object EditReadMe: TcxMemo
      Left = 23
      Top = 36
      ParentFont = False
      Style.BorderColor = clSkyBlue
      Style.BorderStyle = ebsSingle
      Style.Edges = []
      Style.HotTrack = False
      Style.LookAndFeel.SkinName = ''
      Style.Shadow = False
      StyleDisabled.LookAndFeel.SkinName = ''
      StyleFocused.LookAndFeel.SkinName = ''
      StyleHot.LookAndFeel.SkinName = ''
      TabOrder = 0
      Height = 75
      Width = 474
    end
    object BarCode1: TdxBarCode
      Left = 143
      Top = 258
      Text = 'Hello Word'
      ParentFont = False
      Properties.BarCodeSymbologyClassName = 'TdxBarCodeQRCodeSymbology'
      Properties.ModuleWidth = 3
      Properties.ShowText = False
      Style.BorderColor = clSkyBlue
      Style.BorderStyle = ebsSingle
      Style.Edges = []
      Style.HotTrack = False
      Style.LookAndFeel.SkinName = ''
      Style.Shadow = False
      StyleDisabled.LookAndFeel.SkinName = ''
      StyleHot.LookAndFeel.SkinName = ''
    end
    object EditUser: TcxTextEdit
      Left = 81
      Top = 148
      AutoSize = False
      ParentFont = False
      Style.BorderColor = clSkyBlue
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 1
      Text = 'admin'
      Height = 20
      Width = 105
    end
    object EditLen: TcxTextEdit
      Left = 81
      Top = 173
      AutoSize = False
      ParentFont = False
      Style.BorderColor = clSkyBlue
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 2
      Text = '6'
      Height = 20
      Width = 105
    end
    object EditSys: TcxComboBox
      Left = 249
      Top = 148
      ParentFont = False
      Properties.ItemHeight = 20
      Properties.OnChange = EditSysPropertiesChange
      Style.BorderColor = clSkyBlue
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      Style.LookAndFeel.SkinName = 'UserSkin'
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      StyleDisabled.LookAndFeel.SkinName = 'UserSkin'
      StyleFocused.LookAndFeel.SkinName = 'UserSkin'
      StyleHot.LookAndFeel.SkinName = 'UserSkin'
      TabOrder = 3
      Width = 175
    end
    object EditKey: TcxButtonEdit
      Left = 249
      Top = 171
      AutoSize = False
      ParentFont = False
      Properties.Buttons = <
        item
          Caption = #38543#26426
          Default = True
          Kind = bkText
        end>
      Properties.OnButtonClick = EditKeyPropertiesButtonClick
      Style.BorderColor = clSkyBlue
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      Style.LookAndFeel.SkinName = 'UserSkin'
      Style.ButtonStyle = btsHotFlat
      StyleDisabled.LookAndFeel.SkinName = 'UserSkin'
      StyleFocused.LookAndFeel.SkinName = 'UserSkin'
      StyleHot.LookAndFeel.SkinName = 'UserSkin'
      TabOrder = 4
      Height = 20
      Width = 175
    end
    object BtnOK: TcxButton
      Left = 429
      Top = 148
      Width = 60
      Height = 45
      Caption = #29983#25104
      LookAndFeel.SkinName = 'UserSkin'
      TabOrder = 5
      OnClick = BtnOKClick
    end
    object Layout1Group_Root: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      ButtonOptions.Buttons = <>
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = -1
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = dxLayoutGroup3
      Control = EditReadMe
      ControlOptions.OriginalHeight = 75
      ControlOptions.OriginalWidth = 393
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = dxLayoutGroup2
      AlignHorz = ahCenter
      AlignVert = avCenter
      CaptionOptions.AlignHorz = taCenter
      Control = BarCode1
      ControlOptions.OriginalHeight = 85
      ControlOptions.OriginalWidth = 233
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = Layout1Group_Root
      CaptionOptions.Text = #23494#30721#21442#25968
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.AlignHorz = taCenter
      CaptionOptions.Text = #29992#25143#26631#35782':'
      Control = EditUser
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 105
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.AlignHorz = taCenter
      CaptionOptions.Text = #23494#38053#38271#24230':'
      Control = EditLen
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 105
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem6: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.AlignHorz = taCenter
      CaptionOptions.Text = #31995#32479#26631#35782':'
      Control = EditSys
      ControlOptions.OriginalHeight = 18
      ControlOptions.OriginalWidth = 175
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem7: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.AlignHorz = taCenter
      CaptionOptions.Text = #21152#23494#23494#38053':'
      Control = EditKey
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 175
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup2: TdxLayoutGroup
      Parent = Layout1Group_Root
      AlignVert = avClient
      CaptionOptions.Text = #20108#32500#30721
      ButtonOptions.Buttons = <>
      Index = 2
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignVert = avClient
      CaptionOptions.AlignHorz = taCenter
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = BtnOK
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 60
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup3: TdxLayoutGroup
      Parent = Layout1Group_Root
      CaptionOptions.Text = #20351#29992#35828#26126
      ButtonOptions.Buttons = <>
      Index = 0
    end
    object dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup1
      AlignHorz = ahLeft
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahLeft
      Index = 0
    end
    object dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup3
      Index = 1
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 25
    Top = 24
  end
end
