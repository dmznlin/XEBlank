{*******************************************************************************
  作者: dmzn@163.com 2021-08-24
  描述: 组织架构
*******************************************************************************}
unit UFrameOrganization;

interface

uses
  System.SysUtils, System.Variants, System.Classes, System.IniFiles, ULibFun,
  UGlobalConst, MainModule, UFrameBase, uniGUITypes, uniGUIAbstractClasses,
  uniSplitter, uniTreeView, Data.DB, kbmMemTable, uniToolBar, uniPanel,
  uniGUIClasses, uniBasicGrid, uniDBGrid, Vcl.Controls, Vcl.Forms,
  uniGUIBaseClasses, UFrameNormal, Vcl.Menus, uniMainMenu;

type
  TfFrameOrganization = class(TfFrameNormal)
    TreeUnits: TUniTreeView;
    Splitter1: TUniSplitter;
    PMenu1: TUniPopupMenu;
    MenuEA: TUniMenuItem;
    MenuES: TUniMenuItem;
    MenuEL: TUniMenuItem;
    N4: TUniMenuItem;
    MenuCA: TUniMenuItem;
    MenuCS: TUniMenuItem;
    MenuQuery: TUniMenuItem;
    N8: TUniMenuItem;
    MenuCL: TUniMenuItem;
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure TreeUnitsNodeCollapse(Sender: TObject; Node: TUniTreeNode);
    procedure TreeUnitsNodeExpand(Sender: TObject; Node: TUniTreeNode);
    procedure TreeUnitsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MenuEAClick(Sender: TObject);
    procedure MenuQueryClick(Sender: TObject);
  private
    { Private declarations }
    FItems: TOrganizationItems;
    function FindNode(const nID: string): TUniTreeNode;
    //检索节点
  public
    { Public declarations }
    class function ConfigMe: TfFrameConfig; override;
    procedure OnInitFormData(const nWhere: string; const nQuery: TDataset;
      var nHasDone: Boolean); override;
    function InitFormDataSQL(const nWhere: string): string; override;
    procedure DoFrameConfig(nIni: TIniFile; const nLoad: Boolean); override;
  end;

implementation

{$R *.dfm}
uses
  UManagerGroup, UMgrDataDict, UGridHelper, USysBusiness, USysDB, USysConst;

procedure DictBuilder(const nList: TList);
var nEty: PDictEntity;
begin
  with TfFrameOrganization.ConfigMe do
    nEty := gDataDictManager.AddEntity(FDataDict.FEntity, FDesc, nList);
  //xxxxx

  with nEty.ByField('R_ID').FFooter do
  begin
    FFormat   := '合计:共 0 条';
    FKind     := fkCount;
    FPosition := fpAll;
  end; //扩展字典项
end;

class function TfFrameOrganization.ConfigMe: TfFrameConfig;
begin
  Result := inherited ConfigMe;
  Result.FDesc := '单位组织架构';
  Result.FDataDict.FTables := sTable_Organization;

  Result.FDataDict.
    AddMemo('所有查询字段需添加"t."前缀').
    AddMemo('字段 O_PName 内部名称为 a.O_Name');
  //添加备注
end;

procedure TfFrameOrganization.DoFrameConfig(nIni: TIniFile;
  const nLoad: Boolean);
var nInt: Integer;
begin
  inherited DoFrameConfig(nIni, nLoad);
  //do parent

  if nLoad then
  begin
    TreeUnits.Images := UniMainModule.SmallImages;
    TreeUnits.BorderStyle := ubsNone;

    with Splitter1.JSInterface do
    begin
      JSConfig('border', [true]);
      JSConfig('bodyBorder', [True]);
      //enable border

      JSCall('addCls', ['x-panel-border-leftright']);
      JSCall('setStyle', ['border-style', 'none solid none dashed']);
      //border style
    end;

    nInt := nIni.ReadInteger(Name, 'TreeWidth', 0);
    if nInt > 135 then
      TreeUnits.Width := nInt;
    //xxxxx
  end else
  begin
    nIni.WriteInteger(Name, 'TreeWidth', TreeUnits.Width);
  end;
end;

//Date: 2021-09-29
//Parm: 节点标识
//Desc: 检索标识为nID的节点
function TfFrameOrganization.FindNode(const nID: string): TUniTreeNode;
var nNode: TUniTreeNode;
begin
  Result := nil;
  nNode := TreeUnits.Items.GetFirstNode;

  while Assigned(nNode) do
  begin
    if Assigned(nNode.Data) and (POrganizationItem(nNode.Data).FID = nID) then
    begin
      Result := nNode;
      Break;
    end;

    nNode := nNode.GetNext;
  end;
end;

//Desc: 加载组织结构树
procedure TfFrameOrganization.OnInitFormData(const nWhere: string;
  const nQuery: TDataset; var nHasDone: Boolean);
var nStr,nLast: string;
    nIdx: Integer;
    nExpand: TStrings;
    nRoot: TUniTreeNode;
begin
  nExpand := nil;
  with TreeUnits,nQuery,TApplicationHelper do
  try
    Items.BeginUpdate;
    nExpand := gMG.FObjectPool.Lock(TStrings) as TStrings;
    nExpand.Clear;

    if Assigned(Selected) and Assigned(Selected.Data) then
         nLast := POrganizationItem(Selected.Data).FID
    else nLast := '';

    nRoot := Items.GetFirstNode;
    while Assigned(nRoot) do
    begin
      if nRoot.Expanded and Assigned(nRoot.Data) then
        nExpand.Add(POrganizationItem(nRoot.Data).FID);
      nRoot := nRoot.GetNext;
    end;

    Items.Clear;
    //clear first

    nStr := 'Select O_ID,O_Name,O_Parent,O_Type From %s';
    nStr := Format(nStr, [sTable_Organization]);
    gMG.FDBManager.DBQuery(nStr, nQuery);

    if RecordCount > 0 then
    begin
      SetLength(FItems, RecordCount);
      nIdx := 0;
      First;

      while not Eof do
      begin
        with FItems[nIdx] do
        begin
          FID     := FieldByName('O_ID').AsString;
          FName   := FieldByName('O_Name').AsString;
          FParent := FieldByName('O_Parent').AsString;

          nStr    := FieldByName('O_Type').AsString;
          FType   := TStringHelper.Str2Enum<TOrganizationStructure>(nStr);
        end;

        Inc(nIdx);
        Next;
      end;
    end;

    nRoot := TreeUnits.Items.AddChild(nil, sOrganizationNames[osGroup]+'列表');
    with nRoot do
    begin
      ImageIndex := 31;
      Data := nil;
    end;

    for nIdx := Low(FItems) to High(FItems) do
     if FItems[nIdx].FType = osGroup then
      with TreeUnits.Items.AddChild(nRoot, FItems[nIdx].FName) do
      begin
        ImageIndex := 22;
        Data := @FItems[nIdx];
      end;
    //new group

    for nIdx := Low(FItems) to High(FItems) do
     with FItems[nIdx] do
      if FType = osArea then
       with TreeUnits.Items.AddChild(FindNode(FParent), FName) do
        begin
          ImageIndex := 21;
          Data := @FItems[nIdx];
        end;
    //new area

    for nIdx := Low(FItems) to High(FItems) do
     with FItems[nIdx] do
      if FType = osFactory then
       with TreeUnits.Items.AddChild(FindNode(FParent), FName) do
        begin
          ImageIndex := 23;
          Data := @FItems[nIdx];
        end;
    //new area

    nRoot := Items.GetFirstNode;
    while Assigned(nRoot) do
    begin
      if Assigned(nRoot.Data) then
      begin
        nStr := POrganizationItem(nRoot.Data).FID;
        if nExpand.IndexOf(nStr) >= 0 then
          nRoot.Expanded := True;
        //xxxxx

        if (nLast <> '') and (nStr = nLast) then
        begin
          nRoot.Selected := True;
          nRoot.MakeVisible;
        end;
      end else

      if nRoot.HasChildren then
      begin
        nRoot.Expanded := True;
        //top node
      end;

      nRoot := nRoot.GetNext;
    end;
  finally
    gMG.FObjectPool.Release(nExpand);
    Items.EndUpdate;
  end;
end;

procedure TfFrameOrganization.TreeUnitsNodeCollapse(Sender: TObject;
  Node: TUniTreeNode);
begin
  inherited;
  //enable cllapse event
end;

procedure TfFrameOrganization.TreeUnitsNodeExpand(Sender: TObject;
  Node: TUniTreeNode);
begin
  inherited;
  //enable expand event
end;

//Desc: 加载组织结构数据
function TfFrameOrganization.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select t.*,a.O_Name as O_PName From %s t ' +
            'Left Join %s a On t.O_Parent=a.O_ID';
  Result := Format(Result, [sTable_Organization, sTable_Organization]);

  if nWhere <> '' then
    Result := Result + ' Where ' + nWhere;
  //xxxxx
end;

procedure TfFrameOrganization.BtnAddClick(Sender: TObject);
var nP: TCommandParam;
begin
  if Assigned(TreeUnits.Selected) then
       nP.Init(cCmd_AddData).AddP(TreeUnits.Selected.Data)
  else nP.Init(cCmd_AddData).AddP(nil);

  TWebSystem.ShowModalForm('TfFormOrganization', @nP,
    procedure(const nResult: Integer; const nParam: PCommandParam)
    begin
      if nResult = mrOK then
        InitFormData()
    end);
  //call add unit form
end;

procedure TfFrameOrganization.BtnEditClick(Sender: TObject);
var nP: TCommandParam;
begin
  if not (Assigned(TreeUnits.Selected) and Assigned(TreeUnits.Selected.Data)
    and Assigned(TreeUnits.Selected.Parent))  then
  begin
    UniMainModule.ShowMsg('请选择编辑节点');
    Exit;
  end;

  nP.Init(cCmd_EditData).AddP(TreeUnits.Selected.Parent.Data);
  //parent data
  nP.AddP(TreeUnits.Selected.Data);

  TWebSystem.ShowModalForm('TfFormOrganization', @nP,
    procedure(const nResult: Integer; const nParam: PCommandParam)
    begin
      if nResult = mrOK then
        InitFormData(FWhere)
    end);
  //call edit unit form
end;

procedure TfFrameOrganization.BtnDelClick(Sender: TObject);
var nNode: POrganizationItem;
begin
  if not (Assigned(TreeUnits.Selected) and
          Assigned(TreeUnits.Selected.Data)) then
  begin
    UniMainModule.ShowMsg('请选择要删除的节点');
    Exit;
  end;

  nNode := TreeUnits.Selected.Data;
  UniMainModule.QueryDlg(Format('确定要删除[ %s ]和所有子节点吗?', [nNode.FName]),
    procedure(const nType: TButtonClickType)
    var nP: TCommandParam;
    begin
      if nType <> ctYes then Exit;
      nP.Init(cCmd_DeleteData).AddP(nNode);
      //item data

      TWebSystem.ShowModalForm('TfFormOrganization', @nP,
        procedure(const nResult: Integer; const nParam: PCommandParam)
        begin
          if nResult = mrOK then
            InitFormData(FWhere)
        end, False);
      //call delete unit form
    end);
end;

//------------------------------------------------------------------------------
procedure TfFrameOrganization.TreeUnitsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    PMenu1.Popup(X, Y, TreeUnits);
  //xxxxx
end;

procedure TfFrameOrganization.MenuEAClick(Sender: TObject);

  //Desc: 展开nLevel的节点
  procedure ExpandTree(const nLevel: Integer; const nExpand: Boolean);
  var nNode: TUniTreeNode;
  begin
    nNode := TreeUnits.Items.GetFirstNode;
    while Assigned(nNode) do
    begin
      if nNode.Level = nLevel then
      begin
        if nExpand then
             nNode.Expand(False)
        else nNode.Collapse(False);
      end;

      nNode := nNode.GetNext;
    end;
  end;
begin
  if Sender = MenuEA then //expand all
  begin
    TreeUnits.FullExpand;
  end else

  if Sender = MenuCA then //collapse all
  begin
    TreeUnits.FullCollapse;
  end else

  if Sender = MenuES then //expand same
  begin
    if Assigned(TreeUnits.Selected) then
      ExpandTree(TreeUnits.Selected.Level, True);
    //xxxxx
  end else

  if Sender = MenuCS then //collapse same
  begin
    if Assigned(TreeUnits.Selected) then
      ExpandTree(TreeUnits.Selected.Level, False);
    //xxxxx
  end else

  if Sender = MenuEL then //expand low
  begin
    if Assigned(TreeUnits.Selected) then
      TreeUnits.Selected.Expand(True);
    //xxxxx
  end else

  if Sender = MenuCL then //collapse low
  begin
    if Assigned(TreeUnits.Selected) then
      TreeUnits.Selected.Collapse(True);
    //xxxxx
  end
end;

//Desc: 查询下级
procedure TfFrameOrganization.MenuQueryClick(Sender: TObject);
var nStr: string;
    nBind: PBindData;
begin
  nBind := TGridHelper.GetBindData(DBGridMain);
  if Assigned(nBind) then
       FWhere := nBind.FilterString()
  else FWhere := '';

  if not (Assigned(TreeUnits.Selected) and
          Assigned(TreeUnits.Selected.Data)) then
  begin
    InitFormData(FWhere);
    Exit;
  end;

  nStr := 'with CTE as (' +
          '  select O_ID from $TB where O_ID=''$ID''' +
          '  union all' +
          '  select a.O_ID from $TB a' +
          '  inner join CTE b on b.O_ID = a.O_Parent' +
          ') ' +
          'Select t.*,a.O_Name as O_PName From $TB t ' +
          '  Left Join $TB a On t.O_Parent=a.O_ID ' +
          'Where t.O_ID In (Select O_ID From CTE)';
  //xxxxx

  if FWhere <> '' then
    nStr := nStr + Format(' And (%s)', [FWhere]);
  //xxxxx

  with TStringHelper do
  nStr := MacroValue(nStr, [MI('$TB', sTable_Organization),
    MI('$ID', POrganizationItem(TreeUnits.Selected.Data).FID),
    MI('$Addr', sTable_OrgAddress), MI('$Con', sTable_OrgContact)]);
  InitFormData(FWhere, nil, nStr);
end;

initialization
  TWebSystem.AddFrame(TfFrameOrganization);
  gDataDictManager.AddDictBuilder(DictBuilder);
end.
