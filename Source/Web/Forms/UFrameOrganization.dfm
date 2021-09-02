inherited fFrameOrganization: TfFrameOrganization
  inherited PanelWork: TUniContainerPanel
    inherited DBGridMain: TUniDBGrid
      Left = 160
      Width = 612
    end
    object TreeUnits: TUniTreeView
      Left = 0
      Top = 45
      Width = 153
      Height = 450
      Hint = ''
      Items.FontData = {0100000000}
      Align = alLeft
      TabOrder = 4
      Color = clWindow
      ExplicitTop = 46
    end
    object Splitter1: TUniSplitter
      Left = 153
      Top = 45
      Width = 6
      Height = 450
      Hint = ''
      Align = alLeft
      ParentColor = False
      Color = clBtnFace
      ExplicitLeft = 114
      ExplicitTop = 46
    end
    object PanelLine: TUniSimplePanel
      Left = 159
      Top = 45
      Width = 1
      Height = 450
      Hint = ''
      ParentColor = False
      Border = True
      Align = alLeft
      TabOrder = 6
      ExplicitLeft = 153
    end
  end
end
