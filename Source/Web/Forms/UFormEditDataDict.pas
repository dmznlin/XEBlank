{*******************************************************************************
  作者: dmzn@163.com 2021-07-07
  描述: 编辑数据字典
*******************************************************************************}
unit UFormEditDataDict;

interface

uses
  System.SysUtils, System.Classes, UFormBase, ULibFun, uniGUIBaseClasses,
  uniGUIClasses, System.IniFiles, UMgrDataDict, MainModule, uniGUITypes,
  uniPanel, uniButton, uniEdit, uniSplitter, uniBasicGrid, uniStringGrid,
  Vcl.Controls, Vcl.Forms, uniMultiItem, uniComboBox;

type
  TfFormEditDataDict = class(TfFormBase)
    PanelClient: TUniSimplePanel;
    PanelTop: TUniSimplePanel;
    EditEntity: TUniEdit;
    GridItems: TUniStringGrid;
    UniSplitter1: TUniSplitter;
    PanelDetail: TUniSimplePanel;
    BtnUp: TUniButton;
    BtnDown: TUniButton;
    BtnSave: TUniButton;
    BtnAdd: TUniButton;
    BtnDel: TUniButton;
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
    EditPre: TUniEdit;
    EditMemo: TUniEdit;
    EditField: TUniComboBox;
    procedure BtnUpClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
  private
    { Private declarations }
    FEntity: TDictEntity;
    {*字典实体*}
    procedure LoadEntityItems();
    {*载入实体*}
    function RowToItem(nRow: Integer = -1): Integer;
    {*行号转换*}
  public
    { Public declarations }
    class function DescMe: TfFormDesc; override;
    function SetData(const nData: PCommandParam): Boolean; override;
    procedure DoFormConfig(nIni: TIniFile; const nLoad: Boolean); override;
  end;

implementation

{$R *.dfm}
uses
  USysBusiness;

const
  cDel = #9;

class function TfFormEditDataDict.DescMe: TfFormDesc;
begin
  Result := inherited DescMe();
  Result.FUserConfig := True;
  Result.FDesc := '编辑表格字典';
end;

procedure TfFormEditDataDict.DoFormConfig(nIni: TIniFile; const nLoad: Boolean);
var nInt: Integer;
begin
  if nLoad then
  begin
    FEntity.Init(False);
    GridItems.RowCount := 0;
    TWebSystem.LoadFormConfig(Self, nIni);

    nInt := nIni.ReadInteger(Name, 'GridWidth', 0);
    if nInt > 200 then
      GridItems.Width := nInt;
    //xxxxx

    for nInt := PanelDetail.ControlCount-1 downto 0 do
     if PanelDetail.Controls[nInt] is TUniPanel then
      TUniPanel(PanelDetail.Controls[nInt]).BorderStyle := ubsNone;
    //clear border
  end else
  begin
    TWebSystem.SaveFormConfig(Self, nIni);
    nIni.WriteInteger(Name, 'GridWidth', GridItems.Width);
  end;

  TGridHelper.UserDefineStringGrid(Name, GridItems, nLoad, nIni);
  //string grid
end;

function TfFormEditDataDict.SetData(const nData: PCommandParam): Boolean;
begin
  Result := inherited SetData(nData);
  if nData.IsValid(ptStr) then
    EditEntity.Text := nData.Str[0];
  //xxxxx

  if nData.IsValid(ptPtr) then
  begin
    FEntity := PDictEntity(nData.Ptr[0])^;
    SetLength(FEntity.FItems, Length(FEntity.FItems)); //申请新空间
    LoadEntityItems();
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
    FEntity.FItems[RowToItem()].FTitle := cDel;
    nIdx := GridItems.Row;
    LoadEntityItems();

    if GridItems.RowCount > nIdx then
         GridItems.Row := nIdx
    else GridItems.Row := nIdx - 1;
  end;
end;

initialization
  TWebSystem.AddForm(TfFormEditDataDict);
end.
