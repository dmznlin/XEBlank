{*******************************************************************************
  作者: dmzn@163.com 2021-07-07
  描述: 编辑数据字典
*******************************************************************************}
unit UFormEditDataDict;

interface

uses
  System.SysUtils, System.Classes, UFormBase, ULibFun, uniGUIBaseClasses,
  uniGUIClasses, System.IniFiles, UMgrDataDict, MainModule, uniGUITypes,
  uniBasicGrid, uniStringGrid, uniButton, uniMultiItem, uniComboBox, uniEdit,
  uniPanel, uniSplitter, Vcl.Controls, Vcl.Forms;

type
  TfFormEditDataDict = class(TfFormBase)
    PanelClient: TUniSimplePanel;
    PanelTop: TUniSimplePanel;
    EditEntity: TUniEdit;
    UniSplitter1: TUniSplitter;
    PanelDetail: TUniSimplePanel;
    PanelBase: TUniPanel;
    PanelDB: TUniPanel;
    PanelFormat: TUniPanel;
    PanelGroup: TUniPanel;
    EditTitle: TUniEdit;
    EditWidth: TUniEdit;
    EditAlign: TUniComboBox;
    EditVisible: TUniComboBox;
    EditTable: TUniEdit;
    EditFType: TUniComboBox;
    EditKey: TUniComboBox;
    EditFText: TUniEdit;
    EditData: TUniEdit;
    EditStype: TUniComboBox;
    EditDisplay: TUniEdit;
    EditFormat: TUniEdit;
    EditGType: TUniComboBox;
    EditGPos: TUniComboBox;
    EditFWidth: TUniEdit;
    EditFieldQry: TUniEdit;
    EditMemo: TUniEdit;
    EditField: TUniComboBox;
    PanelDBottom: TUniSimplePanel;
    BtnApply: TUniButton;
    BtnReloead: TUniButton;
    PanelL: TUniSimplePanel;
    GridItems: TUniStringGrid;
    PanelLBottom: TUniSimplePanel;
    BtnUp: TUniButton;
    BtnDown: TUniButton;
    BtnAdd: TUniButton;
    BtnDel: TUniButton;
    BtnSave: TUniButton;
    BtnLoad: TUniButton;
    EditLock: TUniComboBox;
    EditMulti: TUniComboBox;
    EditQuery: TUniComboBox;
    EditQDefault: TUniComboBox;
    BtnMemo: TUniButton;
    procedure BtnUpClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure GridItemsDblClick(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
    procedure BtnReloeadClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnLoadClick(Sender: TObject);
    procedure BtnMemoClick(Sender: TObject);
  private
    { Private declarations }
    FEntity: TDictEntity;
    {*字典实体*}
    FActiveItem: Integer;
    {*当前编辑*}
    procedure InitFormData();
    {*初始化界面*}
    procedure LoadEntityItems();
    {*载入实体*}
    procedure LoadItemToForm();
    {*载入字典项*}
    function RowToItem(nRow: Integer = -1): Integer;
    function ItemToRow(nItem: Integer = -1): Integer;
    {*行号转换*}
  public
    { Public declarations }
    class function ConfigMe: TfFormConfig; override;
    function SetData(const nData: PCommandParam): Boolean; override;
    procedure DoFormConfig(nIni: TIniFile; const nLoad: Boolean); override;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
  end;

implementation

{$R *.dfm}
uses
  Vcl.StdCtrls, Data.DB, kbmMemTable, UManagerGroup, UGridHelper,
  USysBusiness, USysConst;

const
  cDel = #9;

class function TfFormEditDataDict.ConfigMe: TfFormConfig;
begin
  Result := inherited ConfigMe();
  Result.FUserConfig := True;
  Result.FDesc := '编辑表格字典';
end;

procedure TfFormEditDataDict.DoFormConfig(nIni: TIniFile; const nLoad: Boolean);
var nInt: Integer;
begin
  if nLoad then
  begin
    FActiveItem := -1;
    GridItems.RowCount := 0;

    FEntity.Init(False);
    InitFormData();
    TWebSystem.LoadFormConfig(Self, nIni);

    nInt := nIni.ReadInteger(Name, 'PanelWidth', 0);
    if nInt > 200 then
      PanelL.Width := nInt;
    //xxxxx

    for nInt := PanelDetail.ControlCount-1 downto 0 do
     if PanelDetail.Controls[nInt] is TUniPanel then
      TUniPanel(PanelDetail.Controls[nInt]).BorderStyle := ubsNone;
    //clear border
  end else
  begin
    TWebSystem.SaveFormConfig(Self, nIni);
    nIni.WriteInteger(Name, 'PanelWidth', PanelL.Width);
  end;

  TGridHelper.UserDefineStringGrid(Name, GridItems, nLoad, nIni);
  //string grid
end;

procedure TfFormEditDataDict.InitFormData;
begin
  with EditAlign do
  try
    Items.BeginUpdate;
    TStringHelper.EnumItems<TAlignment>(Items, True);
  finally
    Items.EndUpdate;
  end;

  with EditVisible do
  try
    Items.BeginUpdate;
    Items.Clear;
    Items.Add('0.可见');
    Items.Add('1.隐藏');
  finally
    Items.EndUpdate;
  end;

  with EditLock do
  try
    Items.BeginUpdate;
    Items.Clear;
    Items.Add('0.否');
    Items.Add('1.是');
  finally
    Items.EndUpdate;
  end;

  with EditMulti do
  try
    Items.BeginUpdate;
    Items.Clear;
    Items.Add('0.否');
    Items.Add('1.是');
  finally
    Items.EndUpdate;
  end;

  with EditQuery do
  try
    Items.BeginUpdate;
    Items.Clear;
    Items.Add('0.否');
    Items.Add('1.是');
  finally
    Items.EndUpdate;
  end;

  with EditQDefault do
  try
    Items.BeginUpdate;
    Items.Clear;
    Items.Add('0.否');
    Items.Add('1.是');
  finally
    Items.EndUpdate;
  end;

  with EditFType do
  try
    Items.BeginUpdate;
    TStringHelper.EnumItems<TFieldType>(Items, True);
  finally
    Items.EndUpdate;
  end;

  with EditKey do
  try
    Items.BeginUpdate;
    Items.Clear;
    Items.Add('0.否');
    Items.Add('1.是');
  finally
    Items.EndUpdate;
  end;

  with EditStype do
  try
    Items.BeginUpdate;
    TStringHelper.EnumItems<TDictFormatStyle>(Items, True);
  finally
    Items.EndUpdate;
  end;

  with EditGType do
  try
    Items.BeginUpdate;
    TStringHelper.EnumItems<TDictFooterKind>(Items, True);
  finally
    Items.EndUpdate;
  end;

  with EditGPos do
  try
    Items.BeginUpdate;
    TStringHelper.EnumItems<TDictFooterPosition>(Items, True);
  finally
    Items.EndUpdate;
  end;

  EnumSubControl(PanelDetail,
    procedure (Sender: TObject)
    begin
      if Sender is TUniComboBox then
       with Sender as TUniComboBox do
       begin
         ItemIndex := 0;
         Style := csDropDown;
       end;
    end);
  //set default
end;

function TfFormEditDataDict.SetData(const nData: PCommandParam): Boolean;
var nIdx: Integer;
    nTable: TkbmMemTable;
begin
  Result := inherited SetData(nData);
  if nData.IsValid(ptStr) then
    EditEntity.Text := nData.Str[0];
  //xxxxx

  if nData.IsValid(ptPtr) then
  begin
    BtnLoad.Enabled := False;
    EditEntity.ReadOnly := True;
    FEntity := PDictEntity(nData.Ptr[0])^;

    BtnMemo.Visible := FEntity.FMemo <> '';
    SetLength(FEntity.FItems, Length(FEntity.FItems)); //申请新空间
    LoadEntityItems();
  end;

  if nData.IsValid(ptObj) then
  begin
    nTable := nData.Obj[0] as TkbmMemTable;
    if not nTable.Active then Exit;

    with EditField do
    try
      Items.BeginUpdate;
      Items.Clear;

      for nIdx := 0 to nTable.FieldCount-1 do
        Items.Add(nTable.Fields[nIdx].FieldName);
      //xxxxx
    finally
      Items.EndUpdate;
    end;
  end;
end;

//Date: 2021-08-27
//Desc: 显示字典说明
procedure TfFormEditDataDict.BtnMemoClick(Sender: TObject);
var nP: TCommandParam;
begin
  nP.Init(cCmd_ViewData).AddS([FEntity.FMemo, '字典说明']);
  TWebSystem.ShowModalForm('TfFormMemo', @nP);
end;

//Date: 2021-07-16
//Desc: 加载指定实体
procedure TfFormEditDataDict.BtnLoadClick(Sender: TObject);
begin
  with UniMainModule do
  begin
    if EditEntity.Text = '' then
    begin
      ShowMsg('请填写实体标识');
      Exit;
    end;

    FActiveItem := -1;
    gDataDictManager.GetEntity(EditEntity.Text, FUser.FLangID, @FEntity);
    if FEntity.FEntity = '' then
    begin
      GridItems.RowCount := 0;
      FEntity.FEntity := EditEntity.Text;
      FEntity.FLang := FUser.FLangID;

      ShowMsg('实体不存在,已创建');
      Exit;
    end;

    LoadEntityItems();
    //load data to form
  end;
end;

//Date: 2021-07-13
//Desc: 加载nEntity到列表
procedure TfFormEditDataDict.LoadEntityItems();
var nIdx,nInt: Integer;
begin
  GridItems.BeginUpdate;
  try
    nInt := 0;
    GridItems.ColCount := 3;
    GridItems.RowCount := Length(FEntity.FItems);

    for nIdx := Low(FEntity.FItems) to High(FEntity.FItems) do
    with FEntity.FItems[nIdx] do
    begin
      if FTitle = cDel then Continue;
      //has deleted

      GridItems.Cells[0, nInt] := IntToStr(nIdx);
      GridItems.Cells[1, nInt] := FDBItem.FField;
      GridItems.Cells[2, nInt] := FTitle;
      Inc(nInt);
    end;

    if GridItems.RowCount > nInt then
      GridItems.RowCount := nInt;
    //adjust
  finally
    GridItems.EndUpdate;
  end;
end;

//Date: 2021-07-16
//Desc: 载入当前字典项到界面
procedure TfFormEditDataDict.LoadItemToForm;
begin
  with FEntity.FItems[FActiveItem] do
  begin
    EditTitle.Text      := FTitle;
    EditWidth.Text      := IntToStr(FWidth);
    EditAlign.ItemIndex := Ord(FAlign);

    if FVisible then
         EditVisible.ItemIndex := 0
    else EditVisible.ItemIndex := 1;

    if FLocked then
         EditLock.ItemIndex := 1
    else EditLock.ItemIndex := 0;

    if FMSelect then
         EditMulti.ItemIndex := 1
    else EditMulti.ItemIndex := 0;

    if FQuery then
         EditQuery.ItemIndex := 1
    else EditQuery.ItemIndex := 0;

    if FQDefault then
         EditQDefault.ItemIndex := 1
    else EditQDefault.ItemIndex := 0;

    EditTable.Text      := FDBItem.FTable;
    EditField.Text      := FDBItem.FField;
    EditFType.ItemIndex := Ord(FDBItem.FType);
    EditFWidth.Text     := IntToStr(FDBItem.FWidth);
    EditFieldQry.Text   := FDBItem.FFieldQry;

    if FDBItem.FIsKey then
         EditKey.ItemIndex := 1
    else EditKey.ItemIndex := 0;

    EditStype.ItemIndex := Ord(FFormat.FStyle);
    EditData.Text       := FFormat.FData;
    EditFText.Text      := FFormat.FFormat;
    EditMemo.Text       := FFormat.FExtMemo ;

    EditDisplay.Text    := FFooter.FDisplay;
    EditFormat.Text     := FFooter.FFormat;
    EditGType.ItemIndex := Ord(FFooter.FKind);
    EditGPos.ItemIndex  := Ord(FFooter.FPosition);
  end;
end;

//Date: 2021-07-14
//Parm: 列表行号
//Desc: 行号对应的字典项索引
function TfFormEditDataDict.RowToItem(nRow: Integer): Integer;
begin
  if nRow < 0 then
    nRow := GridItems.Row;
  //default

  if nRow >= 0 then
       Result := StrToInt(GridItems.Cells[0, nRow])
  else Result := -1;
end;

//Date: 2021-07-16
//Parm: 字典索引
//Desc: 字典索引对应的行号
function TfFormEditDataDict.ItemToRow(nItem: Integer): Integer;
var nStr: string;
    nIdx: Integer;
begin
  if nItem < 0 then
    nItem := FActiveItem;
  //default

  Result := -1;
  if nItem < 0 then Exit;
  nStr := IntToStr(nItem);

  for nIdx := GridItems.RowCount -1 downto 0 do
  if GridItems.Cells[0, nIdx] = nStr then
  begin
    Result := nIdx;
    Break;
  end;
end;

//Desc: 上下移动字典
procedure TfFormEditDataDict.BtnUpClick(Sender: TObject);
var nIdx,nNow,nNext: Integer;
    nTmp: TDictItem;
begin
  if GridItems.Row < 0 then
  begin
    if GridItems.RowCount > 0 then
      UniMainModule.ShowMsg('请选择要移动的行');
    Exit;
  end;

  nIdx := 0; //default
  if Sender = BtnUp then
  begin
    nIdx := GridItems.Row - 1;
    if nIdx < 0 then Exit; //has top
  end else

  if Sender = BtnDown then
  begin
    nIdx := GridItems.Row + 1;
    if nIdx >= GridItems.RowCount then Exit; //has bottom
  end;

  nNow := RowToItem();
  nNext := RowToItem(nIdx);
  //item index

  nTmp := FEntity.FItems[nNow];
  FEntity.FItems[nNow] := FEntity.FItems[nNext];
  FEntity.FItems[nNext] := nTmp;

  LoadEntityItems();
  //refresh

  if nNow = FActiveItem then
    FActiveItem := nNext;
  GridItems.Row := nIdx;
end;

//Desc: 新建字典
procedure TfFormEditDataDict.BtnAddClick(Sender: TObject);
var nIdx: Integer;
begin
  for nIdx := Low(FEntity.FItems) to High(FEntity.FItems) do
   with FEntity.FItems[nIdx] do
    if (FTitle = '') and (FDBItem.FField = '') then Exit;
  //has new item

  FEntity.AddDict('', '');
  LoadEntityItems();
  GridItems.Row := GridItems.RowCount - 1;
end;

//Desc: 删除字典
procedure TfFormEditDataDict.BtnDelClick(Sender: TObject);
var nIdx: Integer;
begin
  if GridItems.Row >= 0 then
  begin
    nIdx := RowToItem();
    FEntity.FItems[nIdx].FTitle := cDel;
    //delete

    if nIdx = FActiveItem then
      FActiveItem := -1;
    //xxxxxx

    nIdx := GridItems.Row;
    LoadEntityItems();
    //reload

    if GridItems.RowCount > nIdx then
         GridItems.Row := nIdx
    else GridItems.Row := nIdx - 1;
  end;
end;

//Desc: 加载选中项到界面
procedure TfFormEditDataDict.GridItemsDblClick(Sender: TObject);
begin
  if GridItems.Row >= 0 then
  begin
    FActiveItem := RowToItem();
    LoadItemToForm();
  end;
end;

//Desc: 撤销用户修改
procedure TfFormEditDataDict.BtnReloeadClick(Sender: TObject);
begin
  if FActiveItem >= 0 then
    LoadItemToForm();
  //xxxxx
end;

function TfFormEditDataDict.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
begin
  Result := True;
  if Sender = EditWidth then
  begin
    if not TStringHelper.IsNumber(EditWidth.Text, False) then
      EditWidth.Text := '100';
    //xxxxx
  end else

  if Sender = EditFWidth then
  begin
    if not TStringHelper.IsNumber(EditFWidth.Text, False) then
      EditFWidth.Text := '0';
    //xxxxx
  end else

  if Sender is TUniComboBox then
  begin
    if Sender = EditField then Exit;
    //no action

    with Sender as TUniComboBox do
     if ItemIndex < 0 then
      ItemIndex := 0;
    //set default item
  end;
end;

//Desc: 使用后填写的参数生效
procedure TfFormEditDataDict.BtnApplyClick(Sender: TObject);
var nIdx: Integer;
begin
  if (FActiveItem < 0) or (not IsDataValid) then Exit;
  //invalid user input

  with FEntity.FItems[FActiveItem] do
  begin
    FTitle := EditTitle.Text;
    FWidth := StrToInt(EditWidth.Text);
    FAlign := TAlignment(EditAlign.ItemIndex);
    FVisible := EditVisible.ItemIndex = 0;
    FLocked := EditLock.ItemIndex = 1;
    FMSelect := EditMulti.ItemIndex = 1;
    FQuery := EditQuery.ItemIndex = 1;
    FQDefault := EditQDefault.ItemIndex = 1;

    FDBItem.FTable := EditTable.Text;
    FDBItem.FField := EditField.Text;
    FDBItem.FType := TFieldType(EditFType.ItemIndex);
    FDBItem.FWidth := StrToInt(EditFWidth.Text);
    FDBItem.FFieldQry := EditFieldQry.Text;
    FDBItem.FIsKey := EditKey.ItemIndex = 1;

    FFormat.FStyle := TDictFormatStyle(EditStype.ItemIndex);
    FFormat.FData := EditData.Text;
    FFormat.FFormat := EditFText.Text;
    FFormat.FExtMemo := EditMemo.Text;

    FFooter.FDisplay := EditDisplay.Text;
    FFooter.FFormat := EditFormat.Text;
    FFooter.FKind := TDictFooterKind(EditGType.ItemIndex);
    FFooter.FPosition := TDictFooterPosition(EditGPos.ItemIndex);

    nIdx := ItemToRow(FActiveItem);
    if nIdx >= 0 then
    begin
      GridItems.Cells[1, nIdx] := FDBItem.FField;
      GridItems.Cells[2, nIdx] := FTitle;
    end;

    UniMainModule.ShowMsg('参数已提交,保存后生效');
  end;
end;

//Desc: 保存字典
procedure TfFormEditDataDict.BtnSaveClick(Sender: TObject);
var nStr: string;
    nIdx,nInt: Integer;
    nList: TStrings;
begin
  if FEntity.FEntity = '' then Exit;
  //no entity
  if Length(FEntity.FItems) < 1 then Exit;
  //no item

  nList := nil;
  try
    nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
    nList.Clear;
    //init

    nStr := 'Delete From %s Where D_Entity=''%s'' And D_LangID=''%s''';
    nStr := Format(nStr, [TDataDictManager.sTable_DataDict,
                          FEntity.FEntity, FEntity.FLang]);
    nList.Add(nStr); //clear first

    nInt := 0;
    for nIdx := Low(FEntity.FItems) to High(FEntity.FItems) do
    with FEntity.FItems[nIdx] do
    begin
      if FTitle = cDel then Continue;
      //delete

      if (FTitle = '') and (FDBItem.FField = '') then Continue;
      //new item

      FRecordID := '';
      FIndex := nInt;
      Inc(nInt);

      nStr := gDataDictManager.BuilDictSQL(@FEntity, nIdx);
      nList.Add(nStr);
    end;

    gMG.FDBManager.DBExecute(nList);
  finally
    gMG.FObjectPool.Release(nList);
  end;

  ModalResult := mrOk;
  UniMainModule.ShowMsg('字典数据已保存,重新加载生效');
end;

initialization
  TWebSystem.AddForm(TfFormEditDataDict);
end.
