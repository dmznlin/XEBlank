object fFormAdminPwd: TfFormAdminPwd
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Admin Tookit'
  ClientHeight = 393
  ClientWidth = 492
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 495
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    492
    393)
  PixelsPerInch = 96
  TextHeight = 12
  object SBar1: TdxStatusBar
    Left = 0
    Top = 373
    Width = 492
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
  end
  object Group1: TcxGroupBox
    Left = 8
    Top = 8
    Anchors = [akLeft, akTop, akRight]
    Caption = #20351#29992#35828#26126
    ParentFont = False
    Style.Edges = [bLeft, bTop, bRight, bBottom]
    TabOrder = 1
    Height = 125
    Width = 477
    object EditReadMe: TcxMemo
      Left = 2
      Top = 17
      Align = alClient
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
      Height = 106
      Width = 473
    end
  end
  object Group2: TcxGroupBox
    Left = 8
    Top = 142
    Anchors = [akLeft, akTop, akRight]
    Caption = #23494#30721#21442#25968
    ParentFont = False
    Style.Edges = [bLeft, bTop, bRight, bBottom]
    TabOrder = 2
    DesignSize = (
      477
      85)
    Height = 85
    Width = 477
    object cxLabel1: TcxLabel
      Left = 12
      Top = 23
      Caption = #29992#25143#26631#35782':'
      ParentFont = False
      Transparent = True
    end
    object cxLabel2: TcxLabel
      Left = 12
      Top = 49
      Caption = #23494#38053#38271#24230':'
      ParentFont = False
      Transparent = True
    end
    object cxLabel3: TcxLabel
      Left = 192
      Top = 23
      Caption = #31995#32479#26631#35782':'
      ParentFont = False
      Transparent = True
    end
    object cxLabel4: TcxLabel
      Left = 192
      Top = 49
      Caption = #21152#23494#23494#38053':'
      ParentFont = False
      Transparent = True
    end
    object BtnOK: TcxButton
      Left = 395
      Top = 22
      Width = 72
      Height = 45
      Anchors = [akTop, akRight]
      Caption = #29983#25104
      DropDownMenu = PMenu1
      Kind = cxbkDropDownButton
      TabOrder = 4
      OnClick = BtnOKClick
    end
    object EditUser: TcxTextEdit
      Left = 73
      Top = 22
      AutoSize = False
      ParentFont = False
      Style.BorderColor = clSkyBlue
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 5
      Text = 'admin'
      Height = 20
      Width = 112
    end
    object EditLen: TcxTextEdit
      Left = 73
      Top = 47
      AutoSize = False
      ParentFont = False
      Style.BorderColor = clSkyBlue
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 6
      Text = '6'
      Height = 20
      Width = 112
    end
    object EditKey: TcxButtonEdit
      Left = 252
      Top = 46
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      ParentFont = False
      ParentShowHint = False
      Properties.Buttons = <
        item
          ImageIndex = 35
          Hint = #29983#25104#38543#26426#23494#38053
          Kind = bkGlyph
        end
        item
          ImageIndex = 46
          Kind = bkGlyph
        end>
      Properties.Images = FSM.Image16
      Properties.PasswordChar = '*'
      Properties.OnButtonClick = EditKeyPropertiesButtonClick
      ShowHint = True
      Style.BorderColor = clSkyBlue
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      Style.LookAndFeel.SkinName = 'UserSkin'
      Style.ButtonStyle = btsHotFlat
      StyleDisabled.LookAndFeel.SkinName = 'UserSkin'
      StyleFocused.LookAndFeel.SkinName = 'UserSkin'
      StyleHot.LookAndFeel.SkinName = 'UserSkin'
      TabOrder = 7
      Height = 20
      Width = 135
    end
    object EditSys: TcxComboBox
      Left = 252
      Top = 22
      Anchors = [akLeft, akTop, akRight]
      ParentFont = False
      Properties.ImmediateDropDownWhenKeyPressed = False
      Properties.ItemHeight = 20
      Properties.OnChange = EditSysPropertiesChange
      Style.BorderColor = clSkyBlue
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsDefault
      TabOrder = 8
      Width = 135
    end
  end
  object Group3: TcxGroupBox
    Left = 8
    Top = 235
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = #20108#32500#30721
    ParentFont = False
    Style.Edges = [bLeft, bTop, bRight, bBottom]
    TabOrder = 3
    Height = 130
    Width = 477
    object BarCode1: TdxBarCode
      Left = 2
      Top = 17
      Align = alClient
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
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 33
    Top = 40
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 72
    Top = 40
    object N1: TMenuItem
      Caption = #20445#23384#23494#38053
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Caption = #21024#38500#23494#38053
      OnClick = N3Click
    end
  end
end
