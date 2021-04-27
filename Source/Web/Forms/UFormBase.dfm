object fFormBase: TfFormBase
  Left = 0
  Top = 0
  ClientHeight = 170
  ClientWidth = 302
  Caption = ''
  BorderStyle = bsSingle
  OldCreateOrder = False
  BorderIcons = [biSystemMenu]
  MonitoredKeys.Keys = <>
  OnCreate = UniFormCreate
  OnDestroy = UniFormDestroy
  DesignSize = (
    302
    170)
  PixelsPerInch = 96
  TextHeight = 13
  object PanelWork: TUniSimplePanel
    Left = 8
    Top = 8
    Width = 286
    Height = 150
    Hint = ''
    ParentColor = False
    Border = True
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
  end
end
