inherited fFrameOrganization: TfFrameOrganization
  inherited PanelWork: TUniContainerPanel
    inherited DBGridMain: TUniDBGrid
      Left = 159
      Width = 411
      OnDblClick = DBGridMainDblClick
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
      OnMouseDown = TreeUnitsMouseDown
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
  object PMenu1: TUniPopupMenu
    Images = UniMainModule.SmallImages
    Left = 16
    Top = 200
    object MenuQuery: TUniMenuItem
      Caption = #26597#35810#19979#32423
      ImageIndex = 38
      OnClick = MenuQueryClick
    end
    object N8: TUniMenuItem
      Caption = '-'
    end
    object MenuEA: TUniMenuItem
      Caption = #20840#37096#23637#24320
      ImageIndex = 17
      OnClick = MenuEAClick
    end
    object MenuES: TUniMenuItem
      Caption = #23637#24320#21516#32423
      OnClick = MenuEAClick
    end
    object MenuEL: TUniMenuItem
      Caption = #23637#24320#19979#32423
      OnClick = MenuEAClick
    end
    object N4: TUniMenuItem
      Caption = '-'
    end
    object MenuCA: TUniMenuItem
      Caption = #20840#37096#25910#36215
      ImageIndex = 18
      OnClick = MenuEAClick
    end
    object MenuCS: TUniMenuItem
      Caption = #25910#36215#21516#32423
      OnClick = MenuEAClick
    end
    object MenuCL: TUniMenuItem
      Caption = #25910#36215#19979#32423
      OnClick = MenuEAClick
    end
  end
end
