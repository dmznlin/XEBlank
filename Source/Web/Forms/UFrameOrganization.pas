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
  uniGUIBaseClasses, UFrameNormal;

type
  TfFrameOrganization = class(TfFrameNormal)
    TreeUnits: TUniTreeView;
    Splitter1: TUniSplitter;
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
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
  UManagerGroup, UMgrDataDict, USysBusiness, USysDB, USysConst;

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
begin
  Result := nil;

end;

//Desc: 加载组织结构树
procedure TfFrameOrganization.OnInitFormData(const nWhere: string;
  const nQuery: TDataset; var nHasDone: Boolean);
var nStr,nLast: string;
    nIdx: Integer;
    nExpand: TStrings;
    nRoot: TUniTreeNode;

    //Desc: 展开节点
    procedure ExpandNode(const nPNode: TUniTreeNode; const nExpand: Boolean);
    var i: Integer;
    begin

    end;
begin
  nExpand := nil;
  with TreeUnits,nQuery,TApplicationHelper do
  try
    Items.BeginUpdate;
    nExpand := gMG.FObjectPool.Lock(TStrings) as TStrings;
    nExpand.Clear;

    if Assigned(Selected) then
         nLast := POrganizationItem(Selected.Data).FID
    else nLast := '';

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
  finally
    gMG.FObjectPool.Release(nExpand);
    Items.EndUpdate;
  end;
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
begin
  //
end;

procedure TfFrameOrganization.BtnDelClick(Sender: TObject);
begin
  //
end;

initialization
  TWebSystem.AddFrame(TfFrameOrganization);
  gDataDictManager.AddDictBuilder(DictBuilder);
end.
