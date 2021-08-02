inherited fFormEditDataDict: TfFormEditDataDict
  ClientHeight = 565
  ClientWidth = 749
  Caption = #32534#36753#25968#25454#23383#20856
  BorderStyle = bsSizeable
  ExplicitWidth = 757
  ExplicitHeight = 592
  PixelsPerInch = 96
  TextHeight = 12
  inherited PanelWork: TUniSimplePanel
    Width = 733
    Height = 545
    ExplicitWidth = 733
    ExplicitHeight = 511
    object PanelClient: TUniSimplePanel
      Left = 0
      Top = 35
      Width = 733
      Height = 510
      Hint = ''
      ParentColor = False
      Align = alClient
      TabOrder = 2
      ExplicitHeight = 476
      object UniSplitter1: TUniSplitter
        Left = 237
        Top = 0
        Width = 6
        Height = 510
        Hint = ''
        Align = alLeft
        ParentColor = False
        Color = clBtnFace
        ExplicitHeight = 476
      end
      object PanelDetail: TUniSimplePanel
        Left = 243
        Top = 0
        Width = 490
        Height = 510
        Hint = ''
        ParentColor = False
        Border = True
        Align = alClient
        TabOrder = 3
        ExplicitHeight = 476
        DesignSize = (
          490
          510)
        object PanelBase: TUniPanel
          Left = 5
          Top = 5
          Width = 478
          Height = 120
          Hint = ''
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          TitleVisible = True
          Title = #22522#26412#23646#24615
          Caption = ''
          object EditTitle: TUniEdit
            Left = 5
            Top = 5
            Width = 220
            Hint = ''
            MaxLength = 32
            Text = ''
            TabOrder = 1
            FieldLabel = #26174#31034#26631#39064
            FieldLabelWidth = 58
          end
          object EditWidth: TUniEdit
            Left = 5
            Top = 35
            Width = 220
            Hint = ''
            Text = ''
            TabOrder = 2
            FieldLabel = #26631#39064#23485#24230
            FieldLabelWidth = 58
          end
          object EditAlign: TUniComboBox
            Left = 5
            Top = 65
            Width = 220
            Hint = ''
            Text = ''
            TabOrder = 3
            FieldLabel = #23545#40784#26041#24335
            FieldLabelWidth = 58
            IconItems = <>
          end
          object EditVisible: TUniComboBox
            Left = 250
            Top = 65
            Width = 220
            Hint = ''
            Text = ''
            TabOrder = 6
            FieldLabel = #26159#21542#21487#35265
            FieldLabelWidth = 58
            IconItems = <>
          end
          object EditLock: TUniComboBox
            Left = 250
            Top = 35
            Width = 220
            Hint = ''
            Text = ''
            TabOrder = 5
            FieldLabel = #26159#21542#38145#23450
            FieldLabelWidth = 58
            IconItems = <>
          end
          object EditMulti: TUniComboBox
            Left = 250
            Top = 5
            Width = 220
            Hint = ''
            Text = ''
            TabOrder = 4
            FieldLabel = #26159#21542#22810#36873
            FieldLabelWidth = 58
            IconItems = <>
          end
        end
        object PanelDB: TUniPanel
          Left = 5
          Top = 130
          Width = 478
          Height = 150
          Hint = ''
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 3
          TitleVisible = True
          Title = #25968#25454#24211
          Caption = ''
          object EditTable: TUniEdit
            Left = 5
            Top = 5
            Width = 220
            Hint = ''
            MaxLength = 32
            Text = ''
            TabOrder = 1
            FieldLabel = #34920#21517#31216
            FieldLabelWidth = 58
          end
          object EditFType: TUniComboBox
            Left = 5
            Top = 65
            Width = 220
            Hint = ''
            Text = ''
            TabOrder = 3
            FieldLabel = #23383#27573#31867#22411
            FieldLabelWidth = 58
            IconItems = <>
          end
          object EditKey: TUniComboBox
            Left = 250
            Top = 65
            Width = 220
            Hint = ''
            Text = ''
            TabOrder = 6
            FieldLabel = #26159#21542#20027#38190
            FieldLabelWidth = 58
            IconItems = <>
          end
          object EditFWidth: TUniEdit
            Left = 250
            Top = 5
            Width = 220
            Hint = ''
            Text = ''
            TabOrder = 4
            FieldLabel = #23383#27573#23485#24230
            FieldLabelWidth = 58
          end
          object EditPre: TUniEdit
            Left = 250
            Top = 35
            Width = 220
            Hint = ''
            Text = ''
            TabOrder = 5
            FieldLabel = #23567#25968#20301
            FieldLabelWidth = 58
          end
          object EditField: TUniComboBox
            Left = 5
            Top = 35
            Width = 220
            Hint = ''
            MaxLength = 32
            Text = ''
            TabOrder = 2
            FieldLabel = #23383#27573#21517#31216
            FieldLabelWidth = 58
            IconItems = <>
          end
          object EditQuery: TUniComboBox
            Left = 5
            Top = 95
            Width = 220
            Hint = ''
            Text = ''
            TabOrder = 7
            FieldLabel = #25903#25345#26597#35810':'
            FieldLabelWidth = 58
            IconItems = <>
          end
        end
        object PanelFormat: TUniPanel
          Left = 5
          Top = 285
          Width = 478
          Height = 90
          Hint = ''
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 4
          TitleVisible = True
          Title = #26684#24335#21270
          Caption = ''
          object EditFText: TUniEdit
            Left = 250
            Top = 5
            Width = 220
            Hint = ''
            MaxLength = 100
            Text = ''
            TabOrder = 3
            FieldLabel = #20869#23481
            FieldLabelWidth = 58
          end
          object EditData: TUniEdit
            Left = 5
            Top = 35
            Width = 220
            Hint = ''
            MaxLength = 200
            Text = ''
            TabOrder = 2
            FieldLabel = #25968#25454
            FieldLabelWidth = 58
          end
          object EditStype: TUniComboBox
            Left = 5
            Top = 5
            Width = 220
            Hint = ''
            Text = ''
            TabOrder = 1
            FieldLabel = #26041#24335
            FieldLabelWidth = 58
            IconItems = <>
          end
          object EditMemo: TUniEdit
            Left = 250
            Top = 35
            Width = 220
            Hint = ''
            MaxLength = 100
            Text = ''
            TabOrder = 4
            FieldLabel = #25193#23637
            FieldLabelWidth = 58
          end
        end
        object PanelGroup: TUniPanel
          Left = 5
          Top = 380
          Width = 478
          Height = 90
          Hint = ''
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 5
          TitleVisible = True
          Title = #21512#35745#20998#32452
          Caption = ''
          object EditDisplay: TUniEdit
            Left = 5
            Top = 5
            Width = 220
            Hint = ''
            MaxLength = 50
            Text = ''
            TabOrder = 1
            FieldLabel = #26174#31034#25991#26412
            FieldLabelWidth = 58
          end
          object EditFormat: TUniEdit
            Left = 5
            Top = 35
            Width = 220
            Hint = ''
            MaxLength = 50
            Text = ''
            TabOrder = 2
            FieldLabel = #26684#24335#21270':'
            FieldLabelWidth = 58
          end
          object EditGType: TUniComboBox
            Left = 250
            Top = 5
            Width = 220
            Hint = ''
            Text = ''
            TabOrder = 3
            FieldLabel = #21512#35745#31867#22411
            FieldLabelWidth = 58
            IconItems = <>
          end
          object EditGPos: TUniComboBox
            Left = 250
            Top = 35
            Width = 220
            Hint = ''
            Text = ''
            TabOrder = 4
            FieldLabel = #21512#35745#20301#32622
            FieldLabelWidth = 58
            IconItems = <>
          end
        end
        object PanelDBottom: TUniSimplePanel
          Left = 0
          Top = 475
          Width = 490
          Height = 35
          Hint = ''
          ParentColor = False
          Align = alBottom
          TabOrder = 1
          ExplicitTop = 441
          DesignSize = (
            490
            35)
          object BtnApply: TUniButton
            Left = 412
            Top = 5
            Width = 75
            Height = 25
            Hint = ''
            Caption = #24212#29992
            Anchors = [akTop, akRight]
            TabOrder = 2
            Images = UniMainModule.SmallImages
            ImageIndex = 19
            OnClick = BtnApplyClick
          end
          object BtnReloead: TUniButton
            Left = 334
            Top = 5
            Width = 75
            Height = 25
            Hint = ''
            Caption = #37325#32622
            Anchors = [akTop, akRight]
            TabOrder = 1
            Images = UniMainModule.SmallImages
            ImageIndex = 20
            OnClick = BtnReloeadClick
          end
        end
      end
      object PanelL: TUniSimplePanel
        Left = 0
        Top = 0
        Width = 237
        Height = 510
        Hint = ''
        ParentColor = False
        Border = True
        Align = alLeft
        TabOrder = 1
        ExplicitHeight = 476
        object GridItems: TUniStringGrid
          Left = 0
          Top = 0
          Width = 237
          Height = 475
          Hint = #21452#20987#32534#36753#23383#20856
          ShowHint = True
          ParentShowHint = False
          FixedCols = 0
          FixedRows = 0
          ColCount = 3
          Options = [goVertLine, goHorzLine, goColSizing, goRowSelect]
          ShowColumnTitles = True
          Columns = <
            item
              Title.Caption = #39034#24207
            end
            item
              Title.Caption = #23383#27573
            end
            item
              Title.Caption = #26631#39064
            end>
          OnDblClick = GridItemsDblClick
          BorderStyle = ubsNone
          Align = alClient
          TabOrder = 0
          ExplicitHeight = 441
        end
        object PanelLBottom: TUniSimplePanel
          Left = 0
          Top = 475
          Width = 237
          Height = 35
          Hint = ''
          ParentColor = False
          Align = alBottom
          TabOrder = 2
          ExplicitTop = 441
          object BtnUp: TUniButton
            Left = 5
            Top = 5
            Width = 55
            Height = 25
            Hint = ''
            Caption = #19978#31227
            TabOrder = 1
            IconCls = 'arrow_up'
            OnClick = BtnUpClick
          end
          object BtnDown: TUniButton
            Left = 62
            Top = 5
            Width = 55
            Height = 25
            Hint = ''
            Caption = #19979#31227
            TabOrder = 2
            IconCls = 'arrow_down'
            OnClick = BtnUpClick
          end
          object BtnAdd: TUniButton
            Left = 119
            Top = 5
            Width = 55
            Height = 25
            Hint = ''
            Caption = #28155#21152
            TabOrder = 3
            IconCls = 'add'
            OnClick = BtnAddClick
          end
          object BtnDel: TUniButton
            Left = 176
            Top = 5
            Width = 55
            Height = 25
            Hint = ''
            Caption = #21024#38500
            TabOrder = 4
            IconCls = 'delete'
            OnClick = BtnDelClick
          end
        end
      end
    end
    object PanelTop: TUniSimplePanel
      Left = 0
      Top = 0
      Width = 733
      Height = 35
      Hint = ''
      ParentColor = False
      Align = alTop
      TabOrder = 1
      object EditEntity: TUniEdit
        Left = 0
        Top = 7
        Width = 237
        Hint = ''
        MaxLength = 32
        Text = ''
        TabOrder = 1
        FieldLabel = #23454#20307#26631#35782
        FieldLabelWidth = 56
      end
      object BtnSave: TUniButton
        Left = 320
        Top = 5
        Width = 75
        Height = 25
        Hint = ''
        Caption = #20445#23384
        TabOrder = 3
        Images = UniMainModule.SmallImages
        ImageIndex = 8
        OnClick = BtnSaveClick
      end
      object BtnLoad: TUniButton
        Left = 243
        Top = 5
        Width = 75
        Height = 25
        Hint = ''
        Caption = #21152#36733
        TabOrder = 2
        Images = UniMainModule.SmallImages
        ImageIndex = 12
        OnClick = BtnLoadClick
      end
    end
  end
end
