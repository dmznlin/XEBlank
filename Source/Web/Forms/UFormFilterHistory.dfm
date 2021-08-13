inherited fFormFilterHistory: TfFormFilterHistory
  ClientHeight = 351
  ClientWidth = 574
  Caption = ''
  BorderStyle = bsSizeable
  ExplicitWidth = 582
  ExplicitHeight = 378
  PixelsPerInch = 96
  TextHeight = 12
  inherited BtnExit: TUniFSButton
    Left = 491
    Top = 317
    ExplicitLeft = 491
    ExplicitTop = 317
  end
  inherited BtnOK: TUniFSButton
    Left = 408
    Top = 317
    ExplicitLeft = 408
    ExplicitTop = 317
  end
  inherited PanelWork: TUniSimplePanel
    Width = 558
    Height = 301
    ExplicitWidth = 558
    ExplicitHeight = 301
    object Splitter1: TUniSplitter
      Left = 150
      Top = 0
      Width = 6
      Height = 301
      Hint = ''
      Align = alLeft
      ParentColor = False
      Color = clBtnFace
      ExplicitLeft = 446
      ExplicitTop = 16
    end
    object Memo1: TUniMemo
      Left = 156
      Top = 0
      Width = 402
      Height = 301
      Hint = ''
      ScrollBars = ssBoth
      Align = alClient
      TabOrder = 2
    end
    object PanelL: TUniSimplePanel
      Left = 0
      Top = 0
      Width = 150
      Height = 301
      Hint = ''
      ParentColor = False
      Border = True
      Align = alLeft
      TabOrder = 3
      object List1: TUniListBox
        Left = 0
        Top = 0
        Width = 150
        Height = 226
        Hint = ''
        Align = alClient
        TabOrder = 1
        BorderStyle = ubsNone
        OnClick = List1Click
        ExplicitLeft = 8
        ExplicitHeight = 128
      end
      object PanelB: TUniSimplePanel
        Left = 0
        Top = 226
        Width = 150
        Height = 75
        Hint = ''
        ParentColor = False
        Align = alBottom
        TabOrder = 2
        ExplicitWidth = 250
        DesignSize = (
          150
          75)
        object BtnAdd: TUniButton
          Left = 52
          Top = 50
          Width = 46
          Height = 22
          Hint = ''
          Caption = #20445#23384
          Anchors = [akTop, akRight]
          TabOrder = 1
          OnClick = BtnAddClick
          ExplicitLeft = 152
        end
        object BtnDel: TUniButton
          Left = 101
          Top = 50
          Width = 46
          Height = 22
          Hint = ''
          Caption = #21024#38500
          Anchors = [akTop, akRight]
          TabOrder = 2
          OnClick = BtnDelClick
          ExplicitLeft = 201
        end
        object EditName: TUniEdit
          Left = 2
          Top = 2
          Width = 145
          Hint = ''
          Text = ''
          Anchors = [akLeft, akRight]
          TabOrder = 3
          FieldLabel = #21517#31216':'
          FieldLabelWidth = 27
          FieldLabelAlign = laTop
          ExplicitWidth = 245
        end
      end
    end
  end
end
