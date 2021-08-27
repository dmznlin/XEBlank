{*******************************************************************************
  作者: dmzn@163.com 2021-06-03
  描述: 提供数据表格和工具栏
*******************************************************************************}
unit UFrameNormal;

interface

uses
  SysUtils, Classes, Graphics, Controls, UFrameBase, MainModule, uniGUITypes,
  uniGUIAbstractClasses, Data.DB, System.IniFiles, UMgrDataDict, kbmMemTable,
  uniPageControl, UGridHelper, uniToolBar, uniPanel, uniGUIClasses,
  uniBasicGrid, uniDBGrid, Vcl.Forms, uniGUIBaseClasses;

type
  TfFrameNormal = class(TfFrameBase)
    DataSource1: TDataSource;
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
    MTable1: TkbmMemTable;
    procedure BtnExitClick(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
  private
    { Private declarations }
  protected
    { Protected declarations }
    FWhere: string;
    {*过滤条件*}
    FDataDict: TDictEntity;
    {*数据字典*}
    FActiveColumn: TUniBaseDBGridColumn;
    {*当前活动列*}
    procedure OnShowFrame(Sender: TObject); override;
    procedure DoFrameConfig(nIni: TIniFile; const nLoad: Boolean); override;
    {*创建释放*}
    function FilterColumnField: string; virtual;
    procedure OnLoadGridConfig(const nIni: TIniFile); virtual;
    procedure OnSaveGridConfig(const nIni: TIniFile); virtual;
    {*表格配置*}
    procedure OnInitFormData(const nWhere: string; const nQuery: TDataset;
    var nHasDone: Boolean); virtual;
    procedure InitFormData(const nWhere: string = '';
      const nQuery: TDataset = nil); virtual;
    function InitFormDataSQL(const nWhere: string): string; virtual;
    procedure AfterInitFormData; virtual;
    {*载入数据*}
    procedure OnFilterData(const nData: PBindData; const nFilterString: string;
      const nClearFilter: Boolean); virtual;
    {*数据查询*}
  public
    { Public declarations }
    class function DescMe: TfFrameDesc; override;
    {*窗体描述*}
  end;

implementation

{$R *.dfm}
uses
  UManagerGroup, ULibFun, UDBManager, USysBusiness, USysConst;

class function TfFrameNormal.DescMe: TfFrameDesc;
begin
  Result := inherited DescMe;
  Result.FUserConfig := True;
end;

procedure TfFrameNormal.DoFrameConfig(nIni: TIniFile; const nLoad: Boolean);
begin
  if nLoad then
  begin
    FWhere := '';
    FActiveColumn := nil;
    //init

    with DescMe.FDataDict,gDataDictManager do
    begin
      if FEntity = '' then
           FDataDict.Init(False)
      else GetEntity(FEntity, UniMainModule.FUser.FLangID, @FDataDict);
    end;

    OnLoadGridConfig(nIni);
    //载入用户配置
  end else
  begin
    OnSaveGridConfig(nIni);
    //保存用户配置
    if MTable1.Active then
      MTable1.Close;
    //清空数据集
  end;
end;

//Desc: 延迟加载数据
procedure TfFrameNormal.OnShowFrame(Sender: TObject);
var nBind: PBindData;
begin
  nBind := TGridHelper.GetBindData(DBGridMain);
  if Assigned(nBind) then
  begin
    nBind.SetAllFilterDefaultText();
    FWhere := nBind.FilterString();
  end;

  InitFormData(FWhere);
  //初始化数据
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
  FDataDict.FMemo := DescMe.FDataDict.MemoToHTML();
  //字典描述信息,用于辅助编辑字典数据

  with TGridHelper.BindData(DBGridMain)^ do
  begin
    FParentControl := Self;
    FFilterEvent := OnFilterData;
    FEntity := @FDataDict;
    FMemTable := MTable1;
    BuildColumnMenu(UniMainModule.SmallImages);
  end; //绑定表格数据和菜单

  TGridHelper.BindData(MTable1).FEntity := @FDataDict;
  //绑定数据
  TGridHelper.BuildDBGridColumn(@FDataDict, DBGridMain, FilterColumnField());
  //构建表头
  TGridHelper.UserDefineGrid(ClassName, DBGridMain, True, nIni);
  //加载自定义表头
end;

//Desc: 保存表格配置
procedure TfFrameNormal.OnSaveGridConfig(const nIni: TIniFile);
begin
  TGridHelper.UserDefineGrid(ClassName, DBGridMain, False, nIni);
  //保存自定义表头
  TGridHelper.UnbindData(MTable1);
  TGridHelper.UnbindData(DBGridMain);
  //解除字典
end;

//Desc: 构建数据载入SQL语句
function TfFrameNormal.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select * From ' + DescMe.FDataDict.FTables;
  if nWhere <> '' then
    Result := Result + ' Where ' + nWhere;
  //xxxxx
end;

//Date: 2021-06-30
//Parm: 查询条件;查询对象;是否完毕
//Desc: 执行默认的数据查询
procedure TfFrameNormal.OnInitFormData(const nWhere: string;
  const nQuery: TDataset; var nHasDone: Boolean);
begin

end;

//Desc: 载入界面数据
procedure TfFrameNormal.InitFormData(const nWhere: string;
  const nQuery: TDataset);
var nStr: string;
    nC: TDataset;
    nBool: Boolean;
begin
  nC := nil;
  try
    if Assigned(nQuery) then
         nC := nQuery
    else nC := gDBManager.LockDBQuery(DescMe.FDBConn);

    TGridHelper.SetBindFilterWhere(DBGridMain, nWhere);
    //记录查询条件

    nBool := False;
    OnInitFormData(nWhere, nC, nBool);
    if nBool then Exit;

    nStr := InitFormDataSQL(nWhere);
    if nStr = '' then Exit;

    gDBManager.DBQuery(nStr, nC);
    //db query
    MTable1.LoadFromDataSet(nC, [mtcpoStructure]);
    //转换数据集

    TGridHelper.BuidDataSetSortIndex(MTable1);
    //排序索引
    TGridHelper.SetGridColumnFormat(@FDataDict, MTable1);
    //列格式化
  finally
    if not Assigned(nQuery) then
      gDBManager.ReleaseDBQuery(nC);
    AfterInitFormData;
  end
end;

//Desc: 数据载入后
procedure TfFrameNormal.AfterInitFormData;
begin
  //null
end;

//Date: 2021-08-02
//Parm: 表格绑定数据;查询条件;是否清空
//Desc: 执行表格的查询操作
procedure TfFrameNormal.OnFilterData(const nData: PBindData;
  const nFilterString: string; const nClearFilter: Boolean);
begin
  if nFilterString = '' then
       FWhere := nData.FilterString
  else FWhere := nFilterString;
  InitFormData(FWhere);
end;

//------------------------------------------------------------------------------
//Desc: 关闭
procedure TfFrameNormal.BtnExitClick(Sender: TObject);
var nSheet: TUniTabSheet;
begin
  nSheet := Parent as TUniTabSheet;
  nSheet.Close;
end;

//Desc: 刷新
procedure TfFrameNormal.BtnRefreshClick(Sender: TObject);
var nBind: PBindData;
begin
  nBind := TGridHelper.GetBindData(DBGridMain);
  if Assigned(nBind) then
       FWhere := nBind.FilterString
  else FWhere := '';
  InitFormData(FWhere);
end;

//Desc: 导出
procedure TfFrameNormal.BtnExportClick(Sender: TObject);
var nStr,nFile: string;
begin
  if (not MTable1.Active) or (MTable1.RecordCount < 1) then
  begin
    UniMainModule.ShowMsg('没有需要导出的数据', True);
    Exit;
  end;

  nStr := '是否要导出当前表格内的数据?';
  UniMainModule.QueryDlg(nStr,
    procedure(const nType: TButtonClickType)
    begin
      if nType <> ctYes then Exit;
      nFile := TWebSystem.UserFile(ufExportXLS, False);

      if FileExists(nFile) then
        DeleteFile(nFile);
      //xxxxx

      nStr := TGridHelper.GridExportExcel(DBGridMain, nFile);
      if nStr = '' then
      begin
        UniSession.SendFile(nFile);
        //send file
      end else UniMainModule.ShowMsg(nStr, True);
    end);
  //xxxxx
end;

end.
