{*******************************************************************************
  作者: dmzn@163.com 2021-06-03
  描述: 提供数据表格和工具栏
*******************************************************************************}
unit UFrameNormal;

interface

uses
  SysUtils, Classes, Graphics, Controls, UFrameBase, MainModule, uniGUITypes,
  uniGUIAbstractClasses, Data.DB, Datasnap.DBClient, uniPanel, uniGUIClasses,
  uniBasicGrid, uniDBGrid, uniToolBar, Vcl.Forms, uniGUIBaseClasses,
  uniGUImJSForm;

type
  TfFrameNormal = class(TfFrameBase)
    DataSource1: TDataSource;
    ClientDS: TClientDataSet;
    DBGridMain: TUniDBGrid;
    PanelQuick: TUniSimplePanel;
    UniToolBar1: TUniToolBar;
    BtnAdd: TUniToolButton;
    BtnEdit: TUniToolButton;
    BtnDel: TUniToolButton;
    BtnS1: TUniToolButton;
    BtnRefresh: TUniToolButton;
    BtnS2: TUniToolButton;
    BtnPrint: TUniToolButton;
    BtnPreview: TUniToolButton;
    BtnExport: TUniToolButton;
    BtnS3: TUniToolButton;
    BtnExit: TUniToolButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



end.
