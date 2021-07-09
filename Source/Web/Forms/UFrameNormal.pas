{*******************************************************************************
  作者: dmzn@163.com 2021-06-03
  描述: 提供数据表格和工具栏
*******************************************************************************}
unit UFrameNormal;

interface

uses
  SysUtils, Classes, Graphics, Controls, UFrameBase, MainModule, uniGUITypes,
  uniGUIAbstractClasses, Data.DB, System.IniFiles, UMgrDataDict, kbmMemTable,
  uniPageControl, uniPanel, uniGUIClasses, uniBasicGrid, uniDBGrid, Vcl.Forms,
  uniGUIBaseClasses, Vcl.Menus, uniMainMenu, uniToolBar;

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
    HMenu1: TUniPopupMenu;
    MenuGridAdjust: TUniMenuItem;
    MenuEditDict: TUniMenuItem;
    procedure DBGridMainAjaxEvent(Sender: TComponent; EventName: string;
      Params: TUniStrings);
    procedure MenuGridAdjustClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
    procedure MenuEditDictClick(Sender: TObject);
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
           InitDict(@FDataDict, False)
      else GetEntity(FEntity, UniMainModule.FUser.FLangID, @FDataDict);
    end;

    OnLoadGridConfig(nIni);
    //载入用户配置
    InitFormData;
    //初始化数据
  end else
  begin
    OnSaveGridConfig(nIni);
    //保存用户配置
    if MTable1.Active then
      MTable1.Close;
    //清空数据集
  end;
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

  TGridHelper.BindEntity(MTable1, @FDataDict);
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
  TGridHelper.UnbindEntity(MTable1);
  TGridHelper.UnbindEntity(DBGridMain);
  //解除字典
  TGridHelper.UserDefineGrid(ClassName, DBGridMain, False, nIni);
  //保存自定义表头
end;

//Desc: 构建数据载入SQL语句
function TfFrameNormal.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select * From ' + DescMe.FDataDict.FTables;
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

//------------------------------------------------------------------------------
//Desc: 处理表格事件
procedure TfFrameNormal.DBGridMainAjaxEvent(Sender: TComponent;
  EventName: string; Params: TUniStrings);
var nStr: string;
    nInt: Integer;
    nSA: TStringHelper.TStringArray;
begin
  if EventName = TGridHelper.sEvent_DBGridHeaderPopmenu then
  begin
    FActiveColumn := nil;
    nStr := Params.Values['col'];

    if TStringHelper.IsNumber(nStr) then
    begin
      nInt := StrToInt(nStr);
      if (nInt >= 0) and (nInt < DBGridMain.Columns.Count) then
      begin
        FActiveColumn := DBGridMain.Columns[nInt];
        //获取菜单所在的列
      end;
    end;

    if TStringHelper.SplitArray(Params.Values['xy'], nSA, ',', tpTrim, 2) then
    begin
      MenuEditDict.Enabled := UniMainModule.FUser.FIsAdmin;
      MenuGridAdjust.Checked := UniMainModule.FGridColumnAdjust;
      HMenu1.Popup(StrToInt(nSA[0]), StrToInt(nSA[1]), UniMainModule.MainForm);
    end;
  end;
end;

//Desc: 允许调整表格宽度和顺序
procedure TfFrameNormal.MenuGridAdjustClick(Sender: TObject);
begin
  with DBGridMain, UniMainModule do
  begin
    FGridColumnAdjust := not FGridColumnAdjust;
    if FGridColumnAdjust then
      ShowMsg('表格的每一列可以调整位置和宽度', False, '重新打开生效');
    //xxxxx
  end;
end;

//Desc: 编辑表格数据字典
procedure TfFrameNormal.MenuEditDictClick(Sender: TObject);
var nP: TCommandParam;
begin
  nP.Init.AddS(DescMe.FDataDict.FEntity).AddP(@FDataDict).AddO(MTable1);
  if Assigned(FActiveColumn) then
    nP.AddO(FActiveColumn);
  //xxxxx

  TWebSystem.ShowModalForm('TfFormEditDataDict', @nP);
end;

//Desc: 关闭
procedure TfFrameNormal.BtnExitClick(Sender: TObject);
var nSheet: TUniTabSheet;
begin
  nSheet := Parent as TUniTabSheet;
  nSheet.Close;
end;

//Desc: 刷新
procedure TfFrameNormal.BtnRefreshClick(Sender: TObject);
begin
  FWhere := '';
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
