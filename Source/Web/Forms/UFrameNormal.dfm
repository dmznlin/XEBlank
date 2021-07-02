inherited fFrameNormal: TfFrameNormal
  Width = 772
  Height = 495
  ExplicitWidth = 772
  ExplicitHeight = 495
  inherited PanelWork: TUniContainerPanel
    Width = 772
    Height = 495
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 772
    ExplicitHeight = 495
    object DBGridMain: TUniDBGrid
      Left = 0
      Top = 92
      Width = 772
      Height = 403
      Hint = ''
      DataSource = DataSource1
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColumnMove, dgColLines, dgRowLines, dgRowSelect, dgConfirmDelete, dgAutoRefreshRow]
      LoadMask.Message = 'Loading data...'
      BorderStyle = ubsNone
      Align = alClient
      TabOrder = 1
      OnAjaxEvent = DBGridMainAjaxEvent
    end
    object PanelQuick: TUniSimplePanel
      Left = 0
      Top = 42
      Width = 772
      Height = 50
      Hint = ''
      ParentColor = False
      Border = True
      Align = alTop
      TabOrder = 2
    end
    object UniToolBar1: TUniToolBar
      Left = 0
      Top = 0
      Width = 772
      Height = 42
      Hint = ''
      ButtonHeight = 40
      ButtonWidth = 82
      Images = UniMainModule.SmallImages
      ShowCaptions = True
      TabOrder = 3
      ParentColor = False
      Color = clBtnFace
      object BtnAdd: TUniToolButton
        Left = 0
        Top = 0
        Hint = ''
        ImageIndex = 1
        Caption = #28155#21152
        TabOrder = 1
      end
      object BtnEdit: TUniToolButton
        Left = 82
        Top = 0
        Hint = ''
        ImageIndex = 2
        Caption = #20462#25913
        TabOrder = 2
      end
      object BtnDel: TUniToolButton
        Left = 164
        Top = 0
        Hint = ''
        ImageIndex = 3
        Caption = #21024#38500
        TabOrder = 3
      end
      object BtnS1: TUniToolButton
        Left = 246
        Top = 0
        Width = 8
        Hint = ''
        Style = tbsSeparator
        Caption = 'BtnS1'
        TabOrder = 4
      end
      object BtnRefresh: TUniToolButton
        Left = 254
        Top = 0
        Hint = ''
        ImageIndex = 20
        Caption = #21047#26032
        ScreenMask.Message = #27491#22312#35835#21462
        TabOrder = 5
      end
      object BtnS2: TUniToolButton
        Left = 336
        Top = 0
        Width = 8
        Hint = ''
        Style = tbsSeparator
        Caption = 'BtnS2'
        TabOrder = 9
      end
      object BtnPrint: TUniToolButton
        Left = 344
        Top = 0
        Hint = ''
        ImageIndex = 10
        Caption = #25171#21360
        TabOrder = 6
      end
      object BtnPreview: TUniToolButton
        Left = 426
        Top = 0
        Hint = ''
        ImageIndex = 4
        Caption = #39044#35272
        TabOrder = 7
      end
      object BtnExport: TUniToolButton
        Left = 508
        Top = 0
        Hint = ''
        ImageIndex = 9
        Caption = #23548#20986
        TabOrder = 8
      end
      object BtnS3: TUniToolButton
        Left = 590
        Top = 0
        Width = 8
        Hint = ''
        Style = tbsSeparator
        Caption = 'BtnS3'
        TabOrder = 10
      end
      object BtnExit: TUniToolButton
        Left = 598
        Top = 0
        Hint = ''
        ImageIndex = 19
        Caption = #36864#20986
        TabOrder = 11
      end
    end
  end
  object DataSource1: TDataSource
    DataSet = MTable1
    Left = 80
    Top = 152
  end
  object MTable1: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <>
    IndexDefs = <>
    SortOptions = []
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    LoadedCompletely = False
    SavedCompletely = False
    FilterOptions = []
    Version = '7.74.00 Professional Edition'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    Left = 16
    Top = 152
  end
  object HMenu1: TUniPopupMenu
    Left = 16
    Top = 208
    object MenuGridAdjust: TUniMenuItem
      Caption = #35843#25972#34920#26684
      OnClick = MenuGridAdjustClick
      CheckItem = True
    end
    object MenuEditDict: TUniMenuItem
      Caption = #32534#36753#34920#26684
    end
  end
end
