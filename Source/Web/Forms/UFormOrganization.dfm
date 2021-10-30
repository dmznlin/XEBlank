inherited fFormOrganization: TfFormOrganization
  ClientHeight = 385
  ClientWidth = 350
  Caption = ''
  ExplicitWidth = 356
  ExplicitHeight = 410
  PixelsPerInch = 96
  TextHeight = 12
  inherited BtnExit: TUniFSButton
    Left = 267
    Top = 351
    ExplicitLeft = 267
    ExplicitTop = 351
  end
  inherited BtnOK: TUniFSButton
    Left = 184
    Top = 351
    Caption = #20445#23384
    ExplicitLeft = 184
    ExplicitTop = 351
  end
  inherited PanelWork: TUniSimplePanel
    Width = 334
    Height = 335
    ExplicitWidth = 334
    ExplicitHeight = 335
    object wPage: TUniPageControl
      Left = 0
      Top = 0
      Width = 334
      Height = 335
      Hint = ''
      ActivePage = SheetContact
      Align = alClient
      TabOrder = 1
      object Sheet1: TUniTabSheet
        Hint = ''
        Caption = #22522#26412#20449#24687
        DesignSize = (
          326
          307)
        object EditType: TUniComboBox
          Left = 8
          Top = 40
          Width = 314
          Hint = ''
          Style = csDropDownList
          Text = ''
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          FieldLabel = #32452#32455#31867#22411
          FieldLabelWidth = 56
          IconItems = <>
        end
        object EditName: TUniEdit
          Left = 8
          Top = 70
          Width = 314
          Hint = ''
          MaxLength = 100
          Text = ''
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          FieldLabel = #32452#32455#21517#31216
          FieldLabelWidth = 56
        end
        object EditValid: TUniDateTimePicker
          Left = 8
          Top = 100
          Width = 314
          Hint = ''
          DateTime = 44468.000000000000000000
          DateFormat = 'yyyy-MM-dd'
          TimeFormat = 'HH:mm:ss'
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          FieldLabel = #26377#25928#26085#26399
          FieldLabelWidth = 56
        end
        object EditParent: TUniEdit
          Left = 8
          Top = 10
          Width = 314
          Hint = ''
          Text = ''
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 3
          ReadOnly = True
          FieldLabel = #19978#32423#32452#32455
          FieldLabelWidth = 56
        end
      end
      object Sheet2: TUniTabSheet
        Hint = ''
        Caption = #37197#32622#21442#25968
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 256
        ExplicitHeight = 128
      end
      object SheetAddress: TUniTabSheet
        Hint = ''
        Caption = #36890#35759#22320#22336
        DesignSize = (
          326
          307)
        object EditPName: TUniEdit
          Left = 8
          Top = 10
          Width = 314
          Hint = ''
          MaxLength = 100
          Text = ''
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          EmptyText = #21517#31216
          OnChange = EditPNameChange
        end
        object EditCode: TUniEdit
          Left = 8
          Top = 40
          Width = 314
          Hint = ''
          MaxLength = 16
          Text = ''
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          EmptyText = #37038#25919#32534#30721
          OnChange = EditPNameChange
        end
        object EditPAddr: TUniMemo
          Left = 8
          Top = 70
          Width = 314
          Height = 50
          Hint = ''
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          EmptyText = #35814#32454#22320#22336
          OnChange = EditPNameChange
        end
        object GridPost: TUniStringGrid
          Left = 8
          Top = 130
          Width = 314
          Height = 170
          Hint = #21491#38190#28155#21152' '#21452#20987#32534#36753
          ShowHint = True
          ParentShowHint = False
          FixedCols = 0
          FixedRows = 0
          RowCount = 0
          ColCount = 4
          Options = [goVertLine, goHorzLine, goColSizing, goRowSelect]
          ShowColumnTitles = True
          Columns = <
            item
              Title.Caption = 'ID'
              Width = 25
            end
            item
              Title.Caption = #21517#31216
            end
            item
              Title.Caption = #37038#32534
            end
            item
              Title.Caption = #22320#22336
            end>
          OnDblClick = GridPostDblClick
          OnMouseDown = GridPostMouseDown
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 3
        end
      end
      object SheetContact: TUniTabSheet
        Hint = ''
        Caption = #32852#31995#26041#24335
        DesignSize = (
          326
          307)
        object EditMName: TUniEdit
          Left = 8
          Top = 10
          Width = 314
          Hint = ''
          MaxLength = 100
          Text = ''
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          EmptyText = #32852#31995#20154#22995#21517
          OnChange = EditPNameChange
        end
        object EditMPhone: TUniEdit
          Left = 8
          Top = 40
          Width = 314
          Hint = ''
          MaxLength = 16
          Text = ''
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          EmptyText = #30005#35805#21495#30721
          OnChange = EditPNameChange
        end
        object EditMMail: TUniMemo
          Left = 8
          Top = 70
          Width = 314
          Height = 50
          Hint = ''
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          EmptyText = #30005#23376#37038#31665
          OnChange = EditPNameChange
        end
        object GridMail: TUniStringGrid
          Left = 8
          Top = 130
          Width = 314
          Height = 170
          Hint = #21491#38190#28155#21152' '#21452#20987#32534#36753
          ShowHint = True
          ParentShowHint = False
          FixedCols = 0
          FixedRows = 0
          RowCount = 0
          ColCount = 4
          Options = [goVertLine, goHorzLine, goColSizing, goRowSelect]
          ShowColumnTitles = True
          Columns = <
            item
              Title.Caption = 'ID'
              Width = 25
            end
            item
              Title.Caption = #22995#21517
            end
            item
              Title.Caption = #30005#35805
            end
            item
              Title.Caption = #37038#31665
            end>
          OnDblClick = GridPostDblClick
          OnMouseDown = GridPostMouseDown
          Anchors = [akLeft, akTop, akRight, akBottom]
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
      OnClick = N1Click
    end
    object N3: TUniMenuItem
      Caption = #21024#38500
      ImageIndex = 3
      OnClick = N3Click
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
