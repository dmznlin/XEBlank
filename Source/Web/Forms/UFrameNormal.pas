{*******************************************************************************
  作者: dmzn@163.com 2021-06-03
  描述: 提供数据表格和工具栏
*******************************************************************************}
unit UFrameNormal;

interface

uses
  SysUtils, Classes, Graphics, Controls, UFrameBase, MainModule, uniGUITypes,
  uniGUIAbstractClasses, Data.DB, System.IniFiles, Datasnap.DBClient,
  UMgrDataDict, uniToolBar, uniPanel, uniGUIClasses, uniBasicGrid, uniDBGrid,
  Vcl.Forms, uniGUIBaseClasses;

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
  protected
    { Protected declarations }
    FDataDict: TDictEntity;
    {*数据字典*}
    procedure OnCreateFrame(const nIni: TIniFile); override;
    procedure OnDestroyFrame(const nIni: TIniFile); override;
    {*创建释放*}
    function FilterColumnField: string; virtual;
    procedure OnLoadGridConfig(const nIni: TIniFile); virtual;
    procedure OnSaveGridConfig(const nIni: TIniFile); virtual;
    {*表格配置*}
  public
    { Public declarations }
    class function DescMe: TfFrameDesc; override;
    {*窗体描述*}
  end;

implementation

{$R *.dfm}
uses
  UManagerGroup, USysBusiness;

class function TfFrameNormal.DescMe: TfFrameDesc;
begin
  Result := inherited DescMe;
  Result.FUserConfig := True;
end;

procedure TfFrameNormal.OnCreateFrame(const nIni: TIniFile);
begin
  with DescMe.FDataDict,gDataDictManager do
  begin
    if FEntity = '' then
         InitDict(@FDataDict, False)
    else GetEntity(FEntity, UniMainModule.FUser.FLangID, @FDataDict);
  end;

  OnLoadGridConfig(nIni);
  //载入用户配置
end;

procedure TfFrameNormal.OnDestroyFrame(const nIni: TIniFile);
begin
  OnSaveGridConfig(nIni);
  //保存用户配置
end;

//Desc: 过滤不显示字段
function TfFrameNormal.FilterColumnField: string;
begin
  Result := '';
end;

//Desc: 构建表格
procedure TfFrameNormal.OnLoadGridConfig(const nIni: TIniFile);
begin
  if FDataDict.FEntity = '' then Exit;
  //没有字典数据

  TGridHelper.BindEntity(ClientDS, @FDataDict);
  TGridHelper.BindEntity(DBGridMain, @FDataDict);
  //绑定数据字典

  TGridHelper.BuildDBGridColumn(@FDataDict, DBGridMain, FilterColumnField());
  //构建表头
  TGridHelper.UserDefineGrid(ClassName, DBGridMain, True, nIni);
  //加载自定义表头
end;

//Desc: 保存表格配置
procedure TfFrameNormal.OnSaveGridConfig(const nIni: TIniFile);
begin
  TGridHelper.UnbindEntity(ClientDS);
  TGridHelper.UnbindEntity(DBGridMain);
  //解除字典
  TGridHelper.UserDefineGrid(ClassName, DBGridMain, False, nIni);
  //保存自定义表头
end;

end.
