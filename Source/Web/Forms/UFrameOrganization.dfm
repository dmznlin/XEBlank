inherited fFrameOrganization: TfFrameOrganization
  inherited PanelWork: TUniContainerPanel
    inherited DBGridMain: TUniDBGrid
      Left = 159
      Width = 411
    end
    inherited ToolBarMain: TUniToolBar
      inherited BtnAdd: TUniToolButton
        OnClick = BtnAddClick
      end
      inherited BtnEdit: TUniToolButton
        OnClick = BtnEditClick
      end
      inherited BtnDel: TUniToolButton
        OnClick = BtnDelClick
      end
    end
    object TreeUnits: TUniTreeView
      Left = 0
      Top = 41
      Width = 153
      Height = 312
      Hint = ''
      Items.FontData = {0100000000}
      Align = alLeft
      TabOrder = 4
      Color = clWindow
      OnNodeExpand = TreeUnitsNodeExpand
      OnNodeCollapse = TreeUnitsNodeCollapse
    end
    object Splitter1: TUniSplitter
      Left = 153
      Top = 41
      Width = 6
      Height = 312
      Hint = ''
      Align = alLeft
      ParentColor = False
      Color = clBtnFace
    end
  end
end
