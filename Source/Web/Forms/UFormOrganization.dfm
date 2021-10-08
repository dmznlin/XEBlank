inherited fFormOrganization: TfFormOrganization
  ClientHeight = 398
  ClientWidth = 336
  Caption = ''
  ExplicitWidth = 342
  ExplicitHeight = 423
  PixelsPerInch = 96
  TextHeight = 12
  inherited BtnExit: TUniFSButton
    Left = 253
    Top = 364
    ExplicitLeft = 304
    ExplicitTop = 181
  end
  inherited BtnOK: TUniFSButton
    Left = 170
    Top = 364
    ExplicitLeft = 221
    ExplicitTop = 181
  end
  inherited PanelWork: TUniSimplePanel
    Width = 320
    Height = 348
    ExplicitWidth = 371
    ExplicitHeight = 165
    object wPage: TUniPageControl
      Left = 0
      Top = 0
      Width = 320
      Height = 348
      Hint = ''
      ActivePage = Sheet4
      Align = alClient
      TabOrder = 1
      ExplicitWidth = 371
      ExplicitHeight = 165
      object Sheet1: TUniTabSheet
        Hint = ''
        Caption = #22522#26412#20449#24687
        ExplicitWidth = 363
        ExplicitHeight = 137
        object EditType: TUniComboBox
          Left = 8
          Top = 40
          Width = 260
          Hint = ''
          Style = csDropDownList
          Text = ''
          TabOrder = 0
          FieldLabel = #32452#32455#31867#22411
          FieldLabelWidth = 56
          IconItems = <>
        end
        object EditName: TUniEdit
          Left = 8
          Top = 70
          Width = 260
          Hint = ''
          MaxLength = 100
          Text = ''
          TabOrder = 1
          FieldLabel = #32452#32455#21517#31216
          FieldLabelWidth = 56
        end
        object EditValid: TUniDateTimePicker
          Left = 8
          Top = 100
          Width = 260
          Hint = ''
          DateTime = 44468.000000000000000000
          DateFormat = 'yyyy-MM-dd'
          TimeFormat = 'HH:mm:ss'
          TabOrder = 2
          FieldLabel = #26377#25928#26085#26399
          FieldLabelWidth = 56
        end
        object EditParent: TUniEdit
          Left = 8
          Top = 10
          Width = 260
          Hint = ''
          Text = ''
          TabOrder = 3
          ReadOnly = True
          FieldLabel = #19978#32423#32452#32455
          FieldLabelWidth = 56
        end
      end
      object Sheet2: TUniTabSheet
        Hint = ''
        Caption = #37197#32622#21442#25968
        ExplicitWidth = 363
        ExplicitHeight = 137
      end
      object Sheet3: TUniTabSheet
        Hint = ''
        Caption = #36890#35759#22320#22336
        ExplicitWidth = 363
        ExplicitHeight = 137
        DesignSize = (
          312
          320)
        object EditPName: TUniEdit
          Left = 8
          Top = 10
          Width = 300
          Hint = ''
          MaxLength = 100
          Text = ''
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          EmptyText = #21517#31216
        end
        object EditCode: TUniEdit
          Left = 8
          Top = 40
          Width = 300
          Hint = ''
          MaxLength = 16
          Text = ''
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          EmptyText = #37038#25919#32534#30721
        end
        object EditPAddr: TUniMemo
          Left = 8
          Top = 70
          Width = 300
          Height = 50
          Hint = ''
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          EmptyText = #35814#32454#22320#22336
        end
        object GridPost: TUniStringGrid
          Left = 8
          Top = 130
          Width = 300
          Height = 180
          Hint = ''
          FixedCols = 0
          FixedRows = 0
          RowCount = 0
          ColCount = 3
          Options = [goVertLine, goHorzLine, goColSizing, goRowSelect]
          ShowColumnTitles = True
          Columns = <
            item
              Title.Caption = #21517#31216
            end
            item
              Title.Caption = #37038#32534
            end
            item
              Title.Caption = #22320#22336
            end>
          OnMouseDown = GridPostMouseDown
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 3
        end
      end
      object Sheet4: TUniTabSheet
        Hint = ''
        Caption = #32852#31995#26041#24335
        ExplicitWidth = 363
        ExplicitHeight = 137
        DesignSize = (
          312
          320)
        object EditMName: TUniEdit
          Left = 8
          Top = 10
          Width = 300
          Hint = ''
          MaxLength = 100
          Text = ''
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          EmptyText = #32852#31995#20154#22995#21517
        end
        object EditMPhone: TUniEdit
          Left = 8
          Top = 40
          Width = 300
          Hint = ''
          MaxLength = 16
          Text = ''
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          EmptyText = #30005#35805#21495#30721
        end
        object EditMMail: TUniMemo
          Left = 8
          Top = 70
          Width = 300
          Height = 50
          Hint = ''
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          EmptyText = #30005#23376#37038#31665
        end
        object GridMail: TUniStringGrid
          Left = 8
          Top = 130
          Width = 300
          Height = 180
          Hint = ''
          FixedCols = 0
          FixedRows = 0
          RowCount = 0
          ColCount = 3
          Options = [goVertLine, goHorzLine, goColSizing, goRowSelect]
          ShowColumnTitles = True
          Columns = <
            item
              Title.Caption = #22995#21517
            end
            item
              Title.Caption = #30005#35805
            end
            item
              Title.Caption = #37038#31665
            end>
          OnMouseDown = GridPostMouseDown
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 3
        end
      end
    end
  end
  object PMenu1: TUniPopupMenu
    Images = UniMainModule.SmallImages
    Left = 28
    Top = 192
    object N1: TUniMenuItem
      Caption = #28155#21152
      ImageIndex = 1
    end
    object N3: TUniMenuItem
      Caption = #21024#38500
      ImageIndex = 3
    end
    object N2: TUniMenuItem
      Caption = '-'
    end
    object N4: TUniMenuItem
      Caption = #37325#32622
      ImageIndex = 20
      OnClick = N4Click
    end
  end
end
