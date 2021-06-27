inherited fFormEditSysMenu: TfFormEditSysMenu
  ClientHeight = 301
  ClientWidth = 319
  Caption = #32534#36753#33756#21333
  ExplicitWidth = 325
  ExplicitHeight = 326
  PixelsPerInch = 96
  TextHeight = 12
  inherited BtnExit: TUniFSButton
    Left = 236
    Top = 267
    ExplicitLeft = 265
    ExplicitTop = 261
  end
  inherited BtnOK: TUniFSButton
    Left = 153
    Top = 267
    ExplicitLeft = 182
    ExplicitTop = 261
  end
  inherited PanelWork: TUniSimplePanel
    Width = 303
    Height = 251
    ExplicitWidth = 332
    ExplicitHeight = 245
    object EditTitle: TUniEdit
      Left = 5
      Top = 20
      Width = 291
      Hint = ''
      MaxLength = 50
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      FieldLabel = #33756#21333#26631#39064':'
      FieldLabelWidth = 58
      ExplicitWidth = 320
    end
    object EditImg: TUniComboBox
      Left = 5
      Top = 53
      Width = 291
      Hint = ''
      Style = csDropDownList
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      FieldLabel = #33756#21333#22270#26631':'
      FieldLabelWidth = 58
      IconItems = <>
      ExplicitWidth = 320
    end
    object EditAction: TUniComboBox
      Left = 5
      Top = 87
      Width = 291
      Hint = ''
      Style = csDropDownList
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
      FieldLabel = #33756#21333#21160#20316':'
      FieldLabelWidth = 58
      IconItems = <
        item
        end>
      OnChange = EditActionChange
      ExplicitWidth = 320
    end
    object EditData: TUniComboBox
      Left = 5
      Top = 120
      Width = 291
      Hint = ''
      MaxLength = 320
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
      FieldLabel = #21160#20316#21442#25968':'
      FieldLabelWidth = 58
      IconItems = <
        item
        end>
      ExplicitWidth = 320
    end
    object UniGroupBox1: TUniGroupBox
      Left = 5
      Top = 155
      Width = 291
      Height = 90
      Hint = ''
      Caption = #36873#39033
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 5
      ExplicitWidth = 286
      object CheckExpand: TUniCheckBox
        Left = 8
        Top = 20
        Width = 112
        Height = 17
        Hint = ''
        Caption = #33258#21160#23637#24320#23376#33756#21333
        TabOrder = 1
      end
      object CheckDesktop: TUniCheckBox
        Left = 8
        Top = 47
        Width = 75
        Height = 17
        Hint = ''
        Caption = #26700#38754#21487#29992
        TabOrder = 2
      end
      object CheckWeb: TUniCheckBox
        Left = 105
        Top = 47
        Width = 75
        Height = 17
        Hint = ''
        Caption = 'Web'#21487#29992
        TabOrder = 3
      end
      object CheckMobile: TUniCheckBox
        Left = 201
        Top = 47
        Width = 85
        Height = 17
        Hint = ''
        Caption = #31227#21160#31471#21487#29992
        TabOrder = 4
      end
      object UniLabel1: TUniLabel
        Left = 8
        Top = 67
        Width = 240
        Height = 12
        Hint = ''
        Caption = #27880':'#33756#21333#39033#40664#35748'('#20840#19981#36873')'#21487#20197#22312#25152#26377#24179#21488#20351#29992'.'
        TabOrder = 5
      end
    end
  end
end
