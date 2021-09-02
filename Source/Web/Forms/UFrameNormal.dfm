inherited fFrameNormal: TfFrameNormal
  Width = 570
  Height = 353
  ExplicitWidth = 570
  ExplicitHeight = 353
  inherited PanelWork: TUniContainerPanel
    Width = 570
    Height = 353
    object DBGridMain: TUniDBGrid
      Left = 0
      Top = 41
      Width = 570
      Height = 312
      Hint = ''
      DataSource = DataSource1
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColumnMove, dgColLines, dgRowLines, dgRowSelect, dgConfirmDelete, dgAutoRefreshRow]
      LoadMask.Message = 'Loading data...'
      Align = alClient
      TabOrder = 1
    end
    object PanelQuick: TUniSimplePanel
      Left = 0
      Top = 38
      Width = 570
      Height = 3
      Hint = ''
      ParentColor = False
      Border = True
      Align = alTop
      TabOrder = 2
    end
    object ToolBarMain: TUniToolBar
      Left = 0
      Top = 0
      Width = 570
      Height = 38
      Hint = ''
      ButtonHeight = 36
      ButtonWidth = 67
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
        Left = 67
        Top = 0
        Hint = ''
        ImageIndex = 2
        Caption = #20462#25913
        TabOrder = 2
      end
      object BtnDel: TUniToolButton
        Left = 134
        Top = 0
        Hint = ''
        ImageIndex = 3
        Caption = #21024#38500
        TabOrder = 3
      end
      object BtnS1: TUniToolButton
        Left = 201
        Top = 0
        Width = 8
        Hint = ''
        Style = tbsSeparator
        Caption = 'BtnS1'
        TabOrder = 4
      end
      object BtnRefresh: TUniToolButton
        Left = 209
        Top = 0
        Hint = ''
        ImageIndex = 20
        Caption = #21047#26032
        ScreenMask.Message = #27491#22312#35835#21462
        TabOrder = 5
        OnClick = BtnRefreshClick
      end
      object BtnS2: TUniToolButton
        Left = 276
        Top = 0
        Width = 8
        Hint = ''
        Style = tbsSeparator
        Caption = 'BtnS2'
        TabOrder = 9
      end
      object BtnPrint: TUniToolButton
        Left = 284
        Top = 0
        Hint = ''
        ImageIndex = 10
        Caption = #25171#21360
        TabOrder = 6
      end
      object BtnPreview: TUniToolButton
        Left = 351
        Top = 0
        Hint = ''
        ImageIndex = 4
        Caption = #39044#35272
        TabOrder = 7
      end
      object BtnExport: TUniToolButton
        Left = 418
        Top = 0
        Hint = ''
        ImageIndex = 9
        Caption = #23548#20986
        TabOrder = 8
        OnClick = BtnExportClick
      end
      object BtnS3: TUniToolButton
        Left = 485
        Top = 0
        Width = 8
        Hint = ''
        Style = tbsSeparator
        Caption = 'BtnS3'
        TabOrder = 10
      end
      object BtnExit: TUniToolButton
        Left = 493
        Top = 0
        Hint = ''
        ImageIndex = 19
        Caption = #36864#20986
        TabOrder = 11
        OnClick = BtnExitClick
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
end
