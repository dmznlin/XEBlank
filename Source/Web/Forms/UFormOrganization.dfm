inherited fFormOrganization: TfFormOrganization
  ClientHeight = 215
  ClientWidth = 387
  Caption = ''
  ExplicitWidth = 393
  ExplicitHeight = 240
  PixelsPerInch = 96
  TextHeight = 12
  inherited BtnExit: TUniFSButton
    Left = 304
    Top = 181
    ExplicitLeft = 236
    ExplicitTop = 106
  end
  inherited BtnOK: TUniFSButton
    Left = 221
    Top = 181
    ExplicitLeft = 153
    ExplicitTop = 106
  end
  inherited PanelWork: TUniSimplePanel
    Width = 371
    Height = 165
    ExplicitWidth = 303
    ExplicitHeight = 90
    object wPage: TUniPageControl
      Left = 0
      Top = 0
      Width = 371
      Height = 165
      Hint = ''
      ActivePage = Sheet1
      Align = alClient
      TabOrder = 1
      ExplicitTop = 2
      ExplicitWidth = 454
      ExplicitHeight = 234
      object Sheet1: TUniTabSheet
        Hint = ''
        Caption = #22522#26412#20449#24687
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 454
        ExplicitHeight = 234
        object EditType: TUniComboBox
          Left = 3
          Top = 16
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
          Left = 5
          Top = 52
          Width = 260
          Hint = ''
          Text = ''
          TabOrder = 1
          FieldLabel = #32452#32455#21517#31216
          FieldLabelWidth = 56
        end
        object EditValid: TUniDateTimePicker
          Left = 5
          Top = 88
          Width = 260
          Hint = ''
          DateTime = 44468.000000000000000000
          DateFormat = 'yyyy-MM-dd'
          TimeFormat = 'HH:mm:ss'
          TabOrder = 2
          FieldLabel = #26377#25928#26085#26399
          FieldLabelWidth = 56
        end
      end
      object Sheet2: TUniTabSheet
        Hint = ''
        Caption = #37197#32622#21442#25968
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 454
        ExplicitHeight = 234
      end
      object Sheet3: TUniTabSheet
        Hint = ''
        Caption = #36890#35759#22320#22336
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 454
        ExplicitHeight = 234
      end
      object Sheet4: TUniTabSheet
        Hint = ''
        Caption = #32852#31995#26041#24335
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 454
        ExplicitHeight = 234
      end
    end
  end
end
