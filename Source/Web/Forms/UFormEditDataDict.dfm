inherited fFormEditDataDict: TfFormEditDataDict
  ClientHeight = 490
  ClientWidth = 728
  Caption = #32534#36753#25968#25454#23383#20856
  BorderStyle = bsSizeable
  ExplicitWidth = 736
  ExplicitHeight = 517
  PixelsPerInch = 96
  TextHeight = 12
  inherited PanelWork: TUniSimplePanel
    Width = 712
    Height = 470
    ExplicitWidth = 688
    ExplicitHeight = 470
    object PanelClient: TUniSimplePanel
      Left = 0
      Top = 35
      Width = 712
      Height = 435
      Hint = ''
      ParentColor = False
      Align = alClient
      TabOrder = 1
      ExplicitWidth = 688
      object GridItems: TUniStringGrid
        Left = 0
        Top = 0
        Width = 200
        Height = 435
        Hint = ''
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
        Align = alLeft
        TabOrder = 1
      end
      object UniSplitter1: TUniSplitter
        Left = 200
        Top = 0
        Width = 6
        Height = 435
        Hint = ''
        Align = alLeft
        ParentColor = False
        Color = clBtnFace
      end
      object PanelDetail: TUniSimplePanel
        Left = 206
        Top = 0
        Width = 506
        Height = 435
        Hint = ''
        ParentColor = False
        Border = True
        Align = alClient
        TabOrder = 3
        ExplicitWidth = 482
        DesignSize = (
          506
          435)
        object PanelBase: TUniPanel
          Left = 5
          Top = 5
          Width = 494
          Height = 90
          Hint = ''
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          TitleVisible = True
          Title = #22522#26412#23646#24615
          Caption = ''
          object EditTitle: TUniEdit
            Left = 5
            Top = 5
            Width = 220
            Hint = ''
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
            Left = 250
            Top = 5
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
            Top = 35
            Width = 220
            Hint = ''
            Text = ''
            TabOrder = 4
            FieldLabel = #26159#21542#21487#35265
            FieldLabelWidth = 58
            IconItems = <>
          end
        end
        object PanelDB: TUniPanel
          Left = 5
          Top = 100
          Width = 494
          Height = 120
          Hint = ''
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          TitleVisible = True
          Title = #25968#25454#24211
          Caption = ''
          object EditTable: TUniEdit
            Left = 5
            Top = 5
            Width = 220
            Hint = ''
            Text = ''
            TabOrder = 1
            FieldLabel = #34920#21517#31216
            FieldLabelWidth = 58
          end
          object EditFType: TUniComboBox
            Left = 250
            Top = 35
            Width = 220
            Hint = ''
            Text = ''
            TabOrder = 2
            FieldLabel = #25968#25454#31867#22411
            FieldLabelWidth = 58
            IconItems = <>
          end
          object EditKey: TUniComboBox
            Left = 250
            Top = 65
            Width = 220
            Hint = ''
            Text = ''
            TabOrder = 3
            FieldLabel = #26159#21542#20027#38190
            FieldLabelWidth = 58
            IconItems = <>
          end
          object EditFWidth: TUniEdit
            Left = 5
            Top = 65
            Width = 220
            Hint = ''
            Text = ''
            TabOrder = 4
            FieldLabel = #23383#27573#23485#24230
            FieldLabelWidth = 58
          end
          object EditPre: TUniEdit
            Left = 250
            Top = 5
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
            Text = ''
            TabOrder = 6
            FieldLabel = #23383#27573#21517#31216
            FieldLabelWidth = 58
            IconItems = <>
          end
        end
        object PanelFormat: TUniPanel
          Left = 5
          Top = 225
          Width = 494
          Height = 90
          Hint = ''
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 3
          TitleVisible = True
          Title = #26684#24335#21270
          Caption = ''
          object EditFText: TUniEdit
            Left = 250
            Top = 5
            Width = 220
            Hint = ''
            Text = ''
            TabOrder = 1
            FieldLabel = #20869#23481
            FieldLabelWidth = 58
          end
          object EditData: TUniEdit
            Left = 5
            Top = 35
            Width = 220
            Hint = ''
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
            TabOrder = 3
            FieldLabel = #26041#24335
            FieldLabelWidth = 58
            IconItems = <>
          end
          object EditMemo: TUniEdit
            Left = 250
            Top = 35
            Width = 220
            Hint = ''
            Text = ''
            TabOrder = 4
            FieldLabel = #25193#23637
            FieldLabelWidth = 58
          end
        end
        object PanelGroup: TUniPanel
          Left = 5
          Top = 320
          Width = 494
          Height = 90
          Hint = ''
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 4
          TitleVisible = True
          Title = #21512#35745#20998#32452
          Caption = ''
          object EditDisplay: TUniEdit
            Left = 5
            Top = 5
            Width = 220
            Hint = ''
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
      end
    end
    object PanelTop: TUniSimplePanel
      Left = 0
      Top = 0
      Width = 712
      Height = 35
      Hint = ''
      ParentColor = False
      Align = alTop
      TabOrder = 2
      ExplicitWidth = 688
      object EditEntity: TUniEdit
        Left = 0
        Top = 6
        Width = 200
        Hint = ''
        Text = ''
        TabOrder = 1
        ReadOnly = True
        FieldLabel = #23454#20307#26631#35782
        FieldLabelWidth = 56
      end
      object BtnUp: TUniButton
        Left = 206
        Top = 5
        Width = 45
        Height = 25
        Hint = ''
        Caption = #19978#31227
        TabOrder = 2
        OnClick = BtnUpClick
      end
      object BtnDown: TUniButton
        Left = 255
        Top = 5
        Width = 45
        Height = 25
        Hint = ''
        Caption = #19979#31227
        TabOrder = 3
        OnClick = BtnUpClick
      end
      object BtnSave: TUniButton
        Left = 435
        Top = 5
        Width = 75
        Height = 25
        Hint = ''
        Caption = #20445#23384
        TabOrder = 4
        Images = UniMainModule.SmallImages
        ImageIndex = 8
      end
      object BtnAdd: TUniButton
        Left = 319
        Top = 5
        Width = 55
        Height = 25
        Hint = ''
        Caption = #28155#21152
        TabOrder = 5
        Images = UniMainModule.SmallImages
        ImageIndex = 1
        OnClick = BtnAddClick
      end
      object BtnDel: TUniButton
        Left = 377
        Top = 5
        Width = 55
        Height = 25
        Hint = ''
        Caption = #21024#38500
        TabOrder = 6
        Images = UniMainModule.SmallImages
        ImageIndex = 3
        OnClick = BtnDelClick
      end
    end
  end
end
