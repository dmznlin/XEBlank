object fFormDBConfig: TfFormDBConfig
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Database Configuration'
  ClientHeight = 430
  ClientWidth = 580
  Color = clBtnFace
  Constraints.MinHeight = 430
  Constraints.MinWidth = 580
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
    580
    430)
  PixelsPerInch = 96
  TextHeight = 12
  object SBar1: TdxStatusBar
    Left = 0
    Top = 410
    Width = 580
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
    Top = 35
    Anchors = [akLeft, akTop, akRight]
    Caption = #22522#30784#37197#32622
    ParentFont = False
    Style.Edges = [bLeft, bTop, bRight, bBottom]
    TabOrder = 3
    Height = 92
    Width = 563
    object EditDefDB: TcxComboBox
      Left = 82
      Top = 26
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 20
      Properties.ItemHeight = 18
      Properties.OnEditValueChanged = EditDefDBPropertiesEditValueChanged
      Style.BorderColor = clSkyBlue
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 0
      Width = 175
    end
    object EditDefFit: TcxComboBox
      Left = 82
      Top = 52
      AutoSize = False
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 20
      Properties.ItemHeight = 18
      Properties.OnEditValueChanged = EditDefDBPropertiesEditValueChanged
      Style.BorderColor = clSkyBlue
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 4
      Height = 21
      Width = 175
    end
    object EditDrivers: TcxComboBox
      Left = 350
      Top = 26
      AutoSize = False
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 20
      Properties.ItemHeight = 18
      Properties.OnEditValueChanged = EditDefDBPropertiesEditValueChanged
      Style.BorderColor = clSkyBlue
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 1
      Height = 20
      Width = 200
    end
    object EditReConn: TdxToggleSwitch
      Left = 280
      Top = 52
      AutoSize = False
      Caption = #25968#25454#24211#26029#24320#21518#33258#21160#37325#26032#36830#25509':'
      Checked = False
      ParentFont = False
      Properties.StateIndicator.Kind = sikText
      Properties.StateIndicator.OffText = #21542
      Properties.StateIndicator.OnText = #26159
      Properties.StateIndicator.Position = sipInside
      Properties.OnEditValueChanged = EditDefDBPropertiesEditValueChanged
      Style.BorderColor = clSkyBlue
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 5
      Transparent = True
      Height = 21
      Width = 270
    end
    object cxLabel1: TcxLabel
      Left = 12
      Top = 28
      Caption = #40664#35748#25968#25454#24211':'
      ParentFont = False
      Transparent = True
    end
    object cxLabel2: TcxLabel
      Left = 12
      Top = 54
      Caption = #40664#35748#24211#31867#22411':'
      ParentFont = False
      Transparent = True
    end
    object cxLabel3: TcxLabel
      Left = 280
      Top = 28
      Caption = #25968#25454#24211#39537#21160':'
      ParentFont = False
      Transparent = True
    end
  end
  object Group2: TcxGroupBox
    Left = 8
    Top = 135
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = #25968#25454#24211#37197#32622
    ParentFont = False
    Style.Edges = [bLeft, bTop, bRight, bBottom]
    TabOrder = 4
    Height = 267
    Width = 563
    object Panel1: TPanel
      Left = 155
      Top = 17
      Width = 406
      Height = 248
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        406
        248)
      object cxLabel4: TcxLabel
        Left = 12
        Top = 14
        Caption = #25968#25454#24211#26631#35782':'
        ParentFont = False
        Transparent = True
      end
      object cxLabel5: TcxLabel
        Left = 12
        Top = 42
        Caption = #25968#25454#24211#21517#31216':'
        ParentFont = False
        Transparent = True
      end
      object cxLabel6: TcxLabel
        Left = 12
        Top = 69
        Caption = #25968#25454#24211#31867#22411':'
        ParentFont = False
        Transparent = True
      end
      object cxLabel7: TcxLabel
        Left = 12
        Top = 96
        Caption = #36830#25509#23383#31526#20018':'
        ParentFont = False
        Transparent = True
      end
      object EditFit: TcxComboBox
        Left = 85
        Top = 67
        AutoSize = False
        ParentFont = False
        Properties.DropDownListStyle = lsEditFixedList
        Properties.DropDownRows = 20
        Properties.ItemHeight = 18
        Style.BorderColor = clSkyBlue
        Style.BorderStyle = ebsSingle
        Style.HotTrack = False
        Style.ButtonStyle = btsHotFlat
        Style.PopupBorderStyle = epbsSingle
        TabOrder = 4
        Height = 21
        Width = 175
      end
      object EditID: TcxTextEdit
        Left = 85
        Top = 12
        ParentFont = False
        TabOrder = 0
        Width = 175
      end
      object EditName: TcxTextEdit
        Left = 85
        Top = 40
        ParentFont = False
        TabOrder = 2
        Width = 175
      end
      object EditConn: TcxMemo
        Left = 85
        Top = 96
        Anchors = [akLeft, akTop, akRight, akBottom]
        ParentFont = False
        Properties.ScrollBars = ssVertical
        TabOrder = 7
        Height = 150
        Width = 306
      end
    end
    object cxSplitter1: TcxSplitter
      Left = 147
      Top = 17
      Width = 8
      Height = 248
      HotZoneClassName = 'TcxXPTaskBarStyle'
    end
    object Panel2: TPanel
      Left = 2
      Top = 17
      Width = 145
      Height = 248
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object Panel3: TPanel
        Left = 0
        Top = 220
        Width = 145
        Height = 28
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          145
          28)
        object EditFilter: TcxButtonEdit
          Left = 38
          Top = 5
          Anchors = [akLeft, akTop, akRight]
          ParentFont = False
          Properties.Buttons = <
            item
              Caption = 'x'
              Default = True
              ImageIndex = 45
              Kind = bkGlyph
            end>
          Properties.Images = FSM.Image16
          Properties.OnButtonClick = EditFilterPropertiesButtonClick
          Properties.OnChange = EditFilterPropertiesChange
          TabOrder = 0
          Width = 100
        end
        object cxLabel8: TcxLabel
          Left = 3
          Top = 8
          Caption = #31579#36873':'
          ParentFont = False
          Transparent = True
        end
      end
      object ListCfg: TdxImageListBox
        Left = 0
        Top = 0
        Width = 145
        Height = 220
        Alignment = taLeftJustify
        ImageAlign = dxliLeft
        ItemHeight = 0
        ImageList = FSM.Image16
        MultiLines = False
        VertAlignment = tvaCenter
        Align = alClient
        BorderStyle = bsNone
        TabOrder = 0
        OnClick = ListCfgClick
        SaveStrings = ()
      end
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 57
    Top = 208
  end
  object BarMgr1: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    MenuAnimations = maRandom
    MenusShowRecentItemsFirst = False
    PopupMenuLinks = <>
    UseF10ForMenu = False
    UseSystemFont = True
    Left = 18
    Top = 208
    PixelsPerInch = 96
    DockControlHeights = (
      0
      0
      22
      0)
    object dxBar1: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      Caption = 'Main Bar'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 608
      FloatTop = 8
      FloatClientWidth = 51
      FloatClientHeight = 36
      Images = FSM.Image16
      IsMainMenu = True
      ItemLinks = <
        item
          Visible = True
          ItemName = 'BarSub1'
        end
        item
          Visible = True
          ItemName = 'BarSub2'
        end>
      MultiLine = True
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = True
    end
    object BtnNew: TdxBarButton
      Caption = #26032#24314
      Category = 0
      Hint = #26032#24314
      Visible = ivAlways
      ImageIndex = 4
      PaintStyle = psCaptionGlyph
      OnClick = BtnNewClick
    end
    object BtnOpen: TdxBarButton
      Caption = #25171#24320
      Category = 0
      Hint = #25171#24320
      Visible = ivAlways
      ImageIndex = 16
      PaintStyle = psCaptionGlyph
      OnClick = BtnOpenClick
    end
    object BtnSaveFile: TdxBarButton
      Caption = #20445#23384
      Category = 0
      Hint = #20445#23384
      Visible = ivAlways
      ImageIndex = 17
      PaintStyle = psCaptionGlyph
    end
    object BarSub1: TdxBarSubItem
      Caption = #25991#20214
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'BtnNew'
        end
        item
          Visible = True
          ItemName = 'BtnOpen'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'BtnExit'
        end>
    end
    object BarS1: TdxBarSeparator
      Caption = '-'
      Category = 0
      Hint = '-'
      Visible = ivAlways
    end
    object BtnExit: TdxBarButton
      Caption = #36864#20986
      Category = 0
      Hint = #36864#20986
      Visible = ivAlways
      ImageIndex = 7
      OnClick = BtnExitClick
    end
    object BarS2: TdxBarSeparator
      Caption = '-'
      Category = 0
      Hint = '-'
      Visible = ivAlways
    end
    object BarSub2: TdxBarSubItem
      Caption = #37197#32622
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'BtnSaveCfg'
        end
        item
          Visible = True
          ItemName = 'BtnDelCfg'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'BtnTest'
        end>
    end
    object BtnTest: TdxBarButton
      Caption = #27979#35797
      Category = 0
      Hint = #27979#35797
      Visible = ivAlways
      ImageIndex = 37
      OnClick = BtnTestClick
    end
    object BtnSaveCfg: TdxBarButton
      Caption = #20445#23384
      Category = 0
      Hint = #20445#23384
      Visible = ivAlways
      ImageIndex = 2
      OnClick = BtnSaveCfgClick
    end
    object BtnDelCfg: TdxBarButton
      Caption = #21024#38500
      Category = 0
      Hint = #21024#38500
      Visible = ivAlways
      ImageIndex = 8
      OnClick = BtnDelCfgClick
    end
  end
end
