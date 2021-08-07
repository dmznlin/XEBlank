{*******************************************************************************
  ����: dmzn@163.com 2021-07-19
  ����: DBGrid��StringGrid��ز���

  ��ע:
  *.TGridHelper��ͨ���ֵ乹����ͷ,�־û���ͷ��ȡ�˳��������.
  *.���в�����Ҫ�Ȱ��㹻������,����:
    with TGridHelper.BindData(DBGridMain)^ do
    begin
      FParentControl := Self;
      FEntity := @FDataDict;
      FMemTable := MTable1;
      BuildColumnMenu(UniMainModule.SmallImages);
    end;
  *.���в���������,�����:
    TGridHelper.UnbindData(DBGridMain);
*******************************************************************************}
unit UGridHelper;

{$I Link.Inc}
interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, System.SyncObjs,
  System.IniFiles, System.Variants, Data.DB, kbmMemTable,
  Vcl.Controls, Vcl.Forms, Vcl.Grids, Vcl.Graphics, Vcl.Menus,
  //----------------------------------------------------------------------------
  uniGUIAbstractClasses, uniGUITypes, uniGUIClasses, uniDBGrid, uniStringGrid,
  MainModule, uniMainMenu, uniImageList, uniPanel, uniEdit,
  //----------------------------------------------------------------------------
  UManagerGroup, UMgrDataDict, ULibFun, USysBusiness, USysConst;

const
  cMenu_GridAdjust           = $01;
  cMenu_EditDict             = $02;
  cMenu_GroupEnable          = $03;
  cMenu_GroupClose           = $04;
  cMenu_GroupCloseAuto       = $05;
  cMenu_ExpandAll            = $06;
  cMenu_CollapseAll          = $07;
  cMenu_QueryFor             = $08;
  cMenu_QueryData            = $09;
  {*�˵�����*}

  sEvent_DBGridHeaderPopmenu = 'DBGridHeaderPopmenu';
  sEvent_StrGridColumnResize = 'StringGridColResize';
  {*��������*}

type
  PDateRange = ^TDateRange;
  TDateRange = record
    FBegin  : TDateTime;                              //��ʼʱ��
    FEnd    : TDateTime;                              //����ʱ��
    FTag    : Integer;                                //��ʶ
    FDefult : Boolean;                                //Ĭ��ʹ��
    FUseMe  : Boolean;                                //��������
  end;
  TDateRanges = TArray<TDateRange>;

  TOnBuildMenu = reference to procedure (const nItem: TUniMenuItem);
  //�Զ���˵�
  PBindData = ^TBindData;
  TOnFilterData = procedure (const nData: PBindData;
    const nClearFilter: Boolean) of object;
  //����������

  TBindData = record
  private
    FColumnMenu     : TUniPopupMenu;                  //��ͷ��ݲ˵�
    FGroupField     : string;                         //���ڷ�����ֶ�
    FGroupCloseAuto : Boolean;                        //�Զ�ȡ������
    FActiveColumn   : TUniBaseDBGridColumn;           //��ǰ���
    FFilterPanel    : TUniHiddenPanel;                //����ɸѡ���
    FFilterWhere    : string;                         //��������
    FFilterDate     : TDateRanges;                    //��������ʱ��
  public
    FParentControl  : TWinControl;                    //���ڿؼ�
    FEntity         : PDictEntity;                    //�ֵ�ʵ������
    FMemTable       : TkbmMemTable;                   //������ݼ�
    FDBGrid         : TUniDBGrid;                     //���ݱ��
    FFilterEvent    : TOnFilterData;                  //���������¼�
  public
    procedure Init();
    {*��ʼ��*}
    procedure BuildColumnMenu(const nImages: TUniCustomImageList = nil;
      const nOnBind: TOnBuildMenu = nil);
    {*�����˵�*}
    function GetMenu(const nTag: Integer): TUniMenuItem;
    function GetDateRange(const nTag: Integer): PDateRange;
    {*��������*}
    function FilterString(): string;
    function FindFilterCtrl(const nIdx: Integer): TControl;
    function AddFilterCtrl(const nIdx: Integer): TControl;
    function GetFilterCtrl(const nField: string): TControl;
    {*���ݹ���*}
    procedure SetAllFilterDefaultText();
    procedure SetFilterDefaultText(const nEdit: TUniEdit);
    {*�����ı�*}
  end;

  TGridHelper = class
  private
    class var
      FGridHelper: TGridHelper;
      {*����ʵ��*}
      FSyncLock: TCriticalSection;
      {*ȫ��ͬ����*}
      FBindData: TDictionary<TObject, PBindData>;
      {*���ݼ����ֵ�*}
  public
    class procedure Init(const nForce: Boolean = False); static;
    {*��ʼ��*}
    class procedure Release; static;
    {*�ͷ���Դ*}
    class procedure WriteLog(const nEvent: string); static;
    {*��¼��־*}
    class function GetHelper: TGridHelper;
    {*��ȡʵ��*}
    class procedure SyncLock; static;
    class procedure SyncUnlock; static;
    {*ȫ��ͬ��*}
    class function BindData(const nObj: TObject): PBindData; static;
    class procedure UnbindData(const nObj: TObject); static;
    class function GetBindData(const nObj: TObject): PBindData; static;
    class function GetBindByMenu(const nMenu: TMenu): PBindData; static;
    class function GetBindByFilter(const nCtrl: TControl): PBindData; static;
    class function SetBindFilterWhere(const nObj: TObject;
      const nWhere: string): Boolean; static;
    {*������*}
    class procedure BuildDBGridColumn(const nEntity: PDictEntity;
      const nGrid: TUniDBGrid; const nFilter: string = ''); static;
    {*�������*}
    class procedure BuidDataSetSortIndex(const nMT: TkbmMemTable); static;
    {*��������*}
    class procedure SetGridColumnFormat(const nEntity: PDictEntity;
      const nMT: TkbmMemTable); static;
    {*��ʽ����ʾ*}
    class procedure DoStringGridColumnResize(const nGrid: TObject;
      const nParam: TUniStrings); static;
    {*�����ֶ�*}
    class procedure UserDefineGrid(const nForm: string; const nGrid: TUniDBGrid;
      const nLoad: Boolean; nIni: TIniFile = nil); static;
    class procedure UserDefineStringGrid(const nForm: string;
      const nGrid: TUniStringGrid;
      const nLoad: Boolean; nIni: TIniFile = nil); static;
    {*�Զ�����*}
    class function GridExportExcel(const nGrid: TUniDBGrid;
      const nFile: string): string; static;
    {*��������*}
    procedure DoGridFilterCtrlDbClick(Sender: TObject);
    procedure DoGridClearFilters(Sender: TObject);
    procedure DoGridColumnFilter(Sender: TUniDBGrid;
      const nColumn: TUniDBGridColumn; const nValue: Variant);
    {*���ݹ���*}
    procedure DoColumnMenuClick(Sender: TObject);
    procedure DoGridEvent(Sender: TComponent; nEventName: string;
      nParams: TUniStrings);
    {*�����¼�*}
    procedure DoColumnFormat(Sender: TField; var nText: string;
      nDisplayText: Boolean);
    {*�ֶθ�ʽ��*}
    procedure DoColumnSort(nCol: TUniDBGridColumn; nDirection: Boolean);
    {*�ֶ�����*}
    procedure DoColumnSummary(nCol: TUniDBGridColumn; nValue: Variant);
    procedure DoColumnSummaryResult(nCol: TUniDBGridColumn;
      nValue: Variant; nAttribs: TUniCellAttribs; var nResult: string);
    {*�ֶκϼ�*}
  end;

implementation

//Date: 2021-07-19
//Desc: ��ʼ��������
procedure TBindData.Init();
var nInit: TBindData;
begin
  FillChar(nInit, SizeOf(TBindData), #0);
  Self := nInit;
end;

//Date: 2021-07-19
//Parm: ͼ���б�;�Զ���˵�
//Desc: ������ͷ��ݲ˵�
procedure TBindData.BuildColumnMenu(const nImages: TUniCustomImageList;
 const nOnBind: TOnBuildMenu);
var nMenu,nSub: TUniMenuItem;

  //Desc: �Զ���˵�����
  procedure UserDefine(const nParent: TUniMenuItem);
  var nIdx: Integer;
  begin
    for nIdx := nParent.Count - 1 downto 0 do
    begin
      if Assigned(nOnBind) then
        nOnBind(nParent.Items[nIdx]);
      //do user define event

      if nParent.Items[nIdx].Count > 0 then
      begin
        UserDefine(nParent.Items[nIdx]);
        Continue;
      end;

      if nParent.Items[nIdx].Tag > 0 then
        nParent.Items[nIdx].OnClick := TGridHelper.GetHelper.DoColumnMenuClick;
      //click event
    end;
  end;
begin
  if Assigned(FColumnMenu) then Exit;
  FColumnMenu := TUniPopupMenu.Create(FParentControl);
  FColumnMenu.Images := nImages;

  nMenu := TUniMenuItem.Create(FColumnMenu);
  with nMenu do
  begin
    Caption := '�������';
    Tag := cMenu_GridAdjust;
    CheckItem := True;
    FColumnMenu.Items.Add(nMenu);
  end;

  nMenu := TUniMenuItem.Create(FColumnMenu);
  with nMenu do
  begin
    Caption := '�༭���';
    Tag := cMenu_EditDict;
    ImageIndex := 13;
    FColumnMenu.Items.Add(nMenu);
  end;

  nMenu := TUniMenuItem.Create(FColumnMenu);
  with nMenu do
  begin
    Caption := '-';
    FColumnMenu.Items.Add(nMenu);
  end;

  //----------------------------------------------------------------------------
  nMenu := TUniMenuItem.Create(FColumnMenu);
  with nMenu do
  begin
    Caption := '���ݷ���';
    ImageIndex := 32;
    FColumnMenu.Items.Add(nMenu);
  end;

  nSub := TUniMenuItem.Create(FColumnMenu);
  with nSub do
  begin
    Caption := 'ʹ�ô��з���';
    Tag := cMenu_GroupEnable;
    ImageIndex := 21;
    nMenu.Add(nSub);
  end;

  nSub := TUniMenuItem.Create(FColumnMenu);
  with nSub do
  begin
    Caption := '����������ʾ';
    Tag := cMenu_GroupClose;
    ImageIndex := 20;
    nMenu.Add(nSub);
  end;

  nSub := TUniMenuItem.Create(FColumnMenu);
  with nSub do
  begin
    Caption := '�Զ���������';
    Tag := cMenu_GroupCloseAuto;
    CheckItem := True;
    nMenu.Add(nSub);
  end;

  nSub := TUniMenuItem.Create(FColumnMenu);
  with nSub do
  begin
    Caption := '-';
    nMenu.Add(nSub);
  end;

  nSub := TUniMenuItem.Create(FColumnMenu);
  with nSub do
  begin
    Caption := 'չ��ȫ������';
    Tag := cMenu_ExpandAll;
    ImageIndex := 17;
    nMenu.Add(nSub);
  end;

  nSub := TUniMenuItem.Create(FColumnMenu);
  with nSub do
  begin
    Caption := '����ȫ������';
    Tag := cMenu_CollapseAll;
    ImageIndex := 18;
    nMenu.Add(nSub);
  end;

  //----------------------------------------------------------------------------
  nMenu := TUniMenuItem.Create(FColumnMenu);
  with nMenu do
  begin
    Caption := '���ݲ�ѯ';
    ImageIndex := 38;
    FColumnMenu.Items.Add(nMenu);
  end;

  nSub := TUniMenuItem.Create(FColumnMenu);
  with nSub do
  begin
    Caption := '��ѯ˵��';
    Tag := cMenu_QueryFor;
    ImageIndex := 4;
    nMenu.Add(nSub);
  end;

  nSub := TUniMenuItem.Create(FColumnMenu);
  with nSub do
  begin
    Caption := '��ǰ��ѯ';
    Tag := cMenu_QueryData;
    ImageIndex := 32;
    nMenu.Add(nSub);
  end;

  UserDefine(FColumnMenu.Items);
  //�Զ���˵���
end;

//Date: 2021-07-19
//Parm: �˵���ʶ
//Desc: ����nName�Ĳ˵���
function TBindData.GetMenu(const nTag: Integer): TUniMenuItem;
  function FindMenu(const nParent: TUniMenuItem): TUniMenuItem;
  var nIdx: Integer;
  begin
    Result := nil;
    //default

    for nIdx := nParent.Count - 1 downto 0 do
    begin
      if nParent.Items[nIdx].Tag = nTag then
      begin
        Result := nParent.Items[nIdx];
        Break;
      end;

      if nParent.Items[nIdx].Count > 0 then
      begin
        Result := FindMenu(nParent.Items[nIdx]);
        //find sub
        if Assigned(Result) then Break;
      end;
    end;
  end;
begin
  Result := FindMenu(FColumnMenu.Items);
end;

//Date: 2021-08-07
//Parm: FEntity.FItems����
//Desc: ��������ΪnIdx����������
function TBindData.GetDateRange(const nTag: Integer): PDateRange;
var i: Integer;
begin
  for i := Low(FFilterDate) to High(FFilterDate) do
   if FFilterDate[i].FTag = nTag then
   begin
     Result := @FFilterDate[i];
     Exit;
   end;

  Result := nil;
end;

//Date: 2021-08-07
//Parm: �ֶ�����
//Desc: �����ֶ�ΪnField�Ĺ������
function TBindData.GetFilterCtrl(const nField: string): TControl;
var i,nIdx: Integer;
begin
  for i := FFilterPanel.ControlCount-1 downto 0 do
  begin
    nIdx := FFilterPanel.Controls[i].Tag;
    if CompareText(nField, FEntity.FItems[nIdx].FDBItem.FField) = 0 then
    begin
      Result := FFilterPanel.Controls[i];
      Exit;
    end;
  end;

  Result := nil;
end;

//Date: 2021-08-01
//Parm: FEntity.FItems����
//Desc: ��������ΪnIdx�Ĺ������
function TBindData.FindFilterCtrl(const nIdx: Integer): TControl;
var i: Integer;
begin
  for i := FFilterPanel.ControlCount-1 downto 0 do
   if FFilterPanel.Controls[i].Tag = nIdx then
   begin
     Result := FFilterPanel.Controls[i];
     Exit;
   end;

  Result := nil;
end;

//Date: 2021-08-01
//Parm: FEntity.FItems����
//Desc: ����nIdx�ֵ���,�����������
function TBindData.AddFilterCtrl(const nIdx: Integer): TControl;
var nInt: Integer;
    nEdit: TUniEdit;
begin
  if not Assigned(FFilterPanel) then
  begin
    FFilterPanel := TUniHiddenPanel.Create(FParentControl);
    FFilterPanel.Parent := FDBGrid.Parent;
    //this needs to have a parent assigned and coexist with the TUniDBGrid
    FFilterPanel.Visible := False;
  end;

  Result := FindFilterCtrl(nIdx);
  if Assigned(Result) then Exit;
  if not FEntity.FItems[nIdx].FQuery then Exit;

  nEdit := TUniEdit.Create(FParentControl);
  with nEdit do
  begin
    Parent := FFilterPanel;
    CharEOL := #13;
    EmptyText := 'search...';

    Tag := nIdx;
    ClearButton := True;
  end;

  Result := nEdit;
  with FEntity.FItems[nIdx] do
  begin
    if FDBItem.FType in [ftDate, ftTime, ftDateTime] then //for datetime
    begin
      nInt := Length(FFilterDate);
      SetLength(FFilterDate, nInt + 1);
      with FFilterDate[nInt] do
      begin
        FTag     := nIdx;
        FDefult  := FQDefault;
        FUseMe   := FQDefault;

        if FDBItem.FType = ftDate then
        begin
          FBegin := Date();
          FEnd   := FBegin + 1;
        end else
        begin
          FBegin := Now();
          FEnd   := Now() + 1/(24 * 3600);
        end;
      end;

      with nEdit do
      begin
        Hint := '˫����ѯ��';
        ShowHint := True;
        ReadOnly := True;
        OnDblClick := TGridHelper.GetHelper.DoGridFilterCtrlDbClick;
      end;
    end;
  end;
end;

//Date: 2021-08-07
//Parm: �������
//Desc: ʹ��nEdit��ʱ�����������ı�����
procedure TBindData.SetFilterDefaultText(const nEdit: TUniEdit);
var nRange: PDateRange;
begin
  nEdit.Text := '';
  //clear filter string
  nRange := GetDateRange(nEdit.Tag);

  if Assigned(nRange) and nRange.FUseMe then
  begin
    with TDateTimeHelper do
    begin
      case FEntity.FItems[nEdit.Tag].FDBItem.FType of
       ftDate:
        nEdit.Text := '��' + Date2Str(nRange.FBegin) +
                      ',<' + Date2Str(nRange.FEnd);
       ftTime:
        nEdit.Text := '��' + Time2Str(nRange.FBegin) +
                      ',<' + Time2Str(nRange.FEnd);
       ftDateTime:
        nEdit.Text := '��' + DateTime2Str(nRange.FBegin) +
                      ',<' + DateTime2Str(nRange.FEnd);
      end;
    end;
  end;
end;

//Date: 2021-08-07
//Desc: �������й��������Ĭ���ı�
procedure TBindData.SetAllFilterDefaultText;
var nIdx: Integer;
begin
  for nIdx := FFilterPanel.ControlCount-1 downto 0 do
   if FFilterPanel.Controls[nIdx] is TUniEdit then
    SetFilterDefaultText(FFilterPanel.Controls[nIdx] as TUniEdit);
  //set default text
end;

//Date: 2021-08-02
//Desc: ���ݹ����������SQL Where
function TBindData.FilterString: string;
const
  sAnd = 'and';
  sOR  = 'or';
  sNot = 'not';
  sEqual = '=';
  sGreater = '>';
  sSmaller = '<';
var nStr,nTmp: string;
    nLike: Boolean;
    nFirst: TObject;
    nActiveEdit: TUniEdit;
    nActiveDate: PDateRange;
    nIdx,nL,nH,nPos: Integer;
    nArray: TStringHelper.TStringArray;

    function MakeSQLWhere: string;
    var i: Integer;
    begin
      Result := '';
      nH := High(nArray);

      for i := nL to nH do
      with FEntity.FItems[nActiveEdit.Tag], TStringHelper, TDateTimeHelper do
      begin
        if nArray[i] = '' then Continue;
        //empty

        //examp: not,lucy,or %lily
        nPos := Pos(' ', nArray[i]);
        if nPos > 1 then
        begin
          nTmp := LowerCase(CopyLeft(nArray[i], nPos - 1));
          //���ӷ�

          if (nTmp = sAnd) or (nTmp = sOR) or (nTmp = sNot) then
          begin
            nArray[i] := TrimLeft(CopyNoLeft(nArray[i], nPos));
            if nArray[i] = '' then Exit;
          end;

          if i > nL then
          begin
            if nTmp = sOR then
              Result := Result + ' or '
            else
            if nTmp = sNot then
              Result := Result + ' and not '
            else
              Result := Result + ' and ';
          end;
        end else
        begin
          if i > nL then
            Result := Result + ' and ';
          //xxxxx
        end;

        if FDBItem.FType in [ftSmallint, ftInteger, ftWord] then
        begin
          nTmp := CopyLeft(nArray[i], 1);
          if StrArrayIndex(nTmp, [sEqual, sGreater, sSmaller]) < 0 then
               Result := Result + FDBItem.FField + '=' + nArray[i]
          else Result := Result + FDBItem.FField + nArray[i];
        end else
        begin
          nTmp := CopyLeft(nArray[i], 1);
          nLike := nTmp = '%';

          if nLike or (nTmp = '=') then
          begin
            nArray[i] := TrimLeft(CopyNoLeft(nArray[i], 1));
            if nArray[i] = '' then Exit;
          end;

          if nLike then
               Result := Result + FDBItem.FField + ' Like ''%' + nArray[i] + '%'''
          else Result := Result + FDBItem.FField + '=''' + nArray[i] + '''';
        end;
      end;
    end;

    procedure ParseSQLWhere(var nWhere: string);
    begin
      if Assigned(nActiveDate) then //datetime field
      begin
        if not nActiveDate.FUseMe then Exit;
        //invalid filter

        if nWhere = '' then
             nStr := '('
        else nStr := ' and (';

        with FEntity.FItems[nActiveEdit.Tag].FDBItem, TDateTimeHelper do
        begin
          nTmp := FField + '>=''%s'' and ' + FField + '<''%s''';
          case FType of
           ftDate:
            nTmp := Format(nTmp, [Date2Str(nActiveDate.FBegin),
                                  Date2Str(nActiveDate.FEnd)]);
           ftTime:
            nTmp := Format(nTmp, [Time2Str(nActiveDate.FBegin),
                                  Time2Str(nActiveDate.FEnd)]);
           ftDateTime:
            nTmp := Format(nTmp, [DateTime2Str(nActiveDate.FBegin),
                                  DateTime2Str(nActiveDate.FEnd)]);
          end;
        end;

        nWhere := nWhere + nStr + nTmp + ')';
        Exit;
      end;

      nStr := Trim(nActiveEdit.Text);
      if nStr = '' then Exit;
      //no data to parse

      TStringHelper.SplitArray(nStr, nArray, ',', tpTrim);
      nL := Low(nArray);
      if nL < 0 then Exit; //empty filter string

      nTmp := LowerCase(nArray[nL]);
      if nWhere = '' then
      begin
        nStr := '(';
      end else
      begin
        if nTmp = sOR then
          nStr := ' or ('
        else
        if nTmp = sNot then
          nStr := ' and not ('
        else
          nStr := ' and (';
      end;

      if TStringHelper.StrArrayIndex(nTmp, [sAnd, sOR, sNot]) >= 0 then
        Inc(nL);
      nWhere := nWhere + nStr + MakeSQLWhere + ')';
    end;
begin
  Result := '';
  if not Assigned(FFilterPanel) then Exit; //no filter control
  nFirst := nil;

  for nIdx := FFilterPanel.ControlCount-1 downto 0 do
   if FFilterPanel.Controls[nIdx] is TUniEdit then
    with FFilterPanel.Controls[nIdx] as TUniEdit, TStringHelper do
    begin
      nActiveDate := GetDateRange(Tag);
      if Assigned(nActiveDate) then
      begin
        if nActiveDate.FUseMe then
          nFirst := FFilterPanel.Controls[nIdx];
        //ʱ������,Ĭ��Ϊ and
      end else
      begin
        if Trim(Text) = '' then Continue;
        nPos := Pos(',', Text);

        if nPos > 1 then
        begin
          nStr := LowerCase(Trim(CopyLeft(Text, nPos - 1)));
          if StrArrayIndex(nStr, [sOR, sNot]) < 0 then
            nFirst := FFilterPanel.Controls[nIdx];
          //���ӷ����� or �� not
        end else
        begin
          nFirst := FFilterPanel.Controls[nIdx];
          //û�����ӷ�,Ĭ��Ϊ and
        end;
      end;

      if Assigned(nFirst) then
      begin
        nActiveEdit := FFilterPanel.Controls[nIdx] as TUniEdit;
        ParseSQLWhere(Result);
        //�ȴ������ӷ�Ϊ and �Ĺ�������
        Break;
      end;
    end;

  for nIdx := FFilterPanel.ControlCount-1 downto 0 do
  if ((not Assigned(nFirst)) or (FFilterPanel.Controls[nIdx] <> nFirst)) and
      (FFilterPanel.Controls[nIdx] is TUniEdit) then
  begin
    nActiveDate := GetDateRange(FFilterPanel.Controls[nIdx].Tag);
    nActiveEdit := FFilterPanel.Controls[nIdx] as TUniEdit;
    ParseSQLWhere(Result);
  end; //�������ݹ�������
end;

//------------------------------------------------------------------------------
class procedure TGridHelper.Init(const nForce: Boolean);
begin
  if nForce then
    FGridHelper := nil;
  //xxxxx

  if nForce or (not Assigned(FSyncLock)) then
    FSyncLock := TCriticalSection.Create;
  //xxxxx

  if nForce or (not Assigned(FBindData)) then
    FBindData := TDictionary<TObject, PBindData>.Create();
  //xxxxx
end;

class procedure TGridHelper.Release;
begin
  FreeAndNil(FGridHelper);
  FreeAndNil(FBindData);
  FreeAndNil(FSyncLock);
end;

//Date: 2021-07-31
//Desc: ��¼��־
class procedure TGridHelper.WriteLog(const nEvent: string);
begin
  gMG.FLogManager.AddLog(TGridHelper, '�������չ', nEvent);
end;

//Date: 2021-06-25
//Desc: ��ȡʵ��
class function TGridHelper.GetHelper: TGridHelper;
begin
  if not Assigned(FGridHelper)  then
    FGridHelper := TGridHelper.Create;
  Result := FGridHelper;
end;

//Date: 2021-06-27
//Desc: ȫ��ͬ������
class procedure TGridHelper.SyncLock;
begin
  FSyncLock.Enter;
end;

//Date: 2021-06-27
//Desc: ȫ��ͬ���������
class procedure TGridHelper.SyncUnlock;
begin
  FSyncLock.Leave;
end;

//Date: 2021-06-27
//Parm: ����
//Desc: ����nObj�İ�����
class function TGridHelper.BindData(const nObj: TObject): PBindData;
begin
  SyncLock;
  try
    if FBindData.TryGetValue(nObj, Result) then Exit;
    //use original data

    if not Assigned(Result) then
    begin
      New(Result);
      FBindData.Add(nObj, Result);
      //new data

      Result.Init();
      if nObj is TUniDBGrid then
        Result.FDBGrid := nObj as TUniDBGrid;
      //xxxxx
    end;
  finally
    SyncUnlock;
  end;
end;

//Date: 2021-06-27
//Parm: ����
//Desc: ���nObj�İ�����
class procedure TGridHelper.UnbindData(const nObj: TObject);
var nData: PBindData;
begin
  SyncLock;
  try
    if FBindData.TryGetValue(nObj, nData) then
    begin
      Dispose(nData);
      FBindData.Remove(nObj);
    end;
  finally
    SyncUnlock;
  end;
end;

class function TGridHelper.GetBindData(const nObj: TObject): PBindData;
begin
  SyncLock;
  try
    if not FBindData.TryGetValue(nObj, Result) then
      Result := nil;
    //xxxxx
  finally
    SyncUnlock;
  end;
end;

//Date: 2021-07-19
//Parm: �˵�
//Desc: ��������nMenu������
class function TGridHelper.GetBindByMenu(const nMenu: TMenu): PBindData;
begin
  SyncLock;
  try
    for Result in FBindData.Values do
      if Result.FColumnMenu = nMenu then Exit;
    Result := nil;
  finally
    SyncUnlock;
  end;
end;

//Date: 2021-08-07
//Parm: �������
//Desc: ��������nCtrl�������������
class function TGridHelper.GetBindByFilter(const nCtrl: TControl):PBindData;
begin
  SyncLock;
  try
    for Result in FBindData.Values do
      if Result.FFilterPanel = nCtrl.Parent then Exit;
    Result := nil;
  finally
    SyncUnlock;
  end;
end;

//Date: 2021-08-07
//Parm: ����;��������
//Desc: ����nObj.BindData.FFilterWhere
class function TGridHelper.SetBindFilterWhere(const nObj: TObject;
  const nWhere: string): Boolean;
var nBind: PBindData;
begin
  nBind := GetBindData(nObj);
  Result := Assigned(nBind);

  if Result then
    nBind.FFilterWhere := nWhere;
  //xxxxx
end;

//Date: 2021-06-25
//Parm: �����ֵ�;�б�;�ų��ֶ�
//Desc: ʹ�������ֵ�nEntity����nGrid�ı�ͷ
class procedure TGridHelper.BuildDBGridColumn(const nEntity: PDictEntity;
  const nGrid: TUniDBGrid; const nFilter: string);
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
    nBind: PBindData;
    nColumn: TUniBaseDBGridColumn;
begin
  nBind := GetBindData(nGrid);
  if not (Assigned(nBind) and Assigned(nBind.FParentControl) and
    Assigned(nBind.FEntity)) then
  begin
    nStr := 'UGridHelper.BuildDBGridColumn: Grid "%s" Need BindData First.';
    nStr := Format(nStr, [nGrid.Name]);
    
    TGridHelper.WriteLog(nStr);
    raise Exception.Create(nStr);
  end;

  nList := nil;
  with nGrid, TStringHelper do
  try
    nGrid.BeginUpdate;
    Columns.Clear;
    //clear first

    BorderStyle := ubsNone;
    LoadMask.Message := '��������';
    Options := [dgTitles, dgIndicator, dgColLines, dgRowLines, dgRowSelect];

    if UniMainModule.FGridColumnAdjust then
      Options := Options + [dgColumnResize, dgColumnMove];
    //ѡ�����

    ReadOnly := True;
    WebOptions.Paged := True;
    WebOptions.PageSize := 1000;

    nStr := 'headercontextmenu=function headercontextmenu(ct, column, e, t, eOpts)' +
      '{ajaxRequest($O, ''$E'', [''xy='' + e.getXY(),''col='' + column.dataIndex])}';
    //grid column popmenu

    nStr := MacroValue(nStr, [MI('$O', nGrid.JSName),
      MI('$E', sEvent_DBGridHeaderPopmenu)]);
    //xxxxx

    if nGrid.ClientEvents.ExtEvents.IndexOf(nStr) < 0 then
      nGrid.ClientEvents.ExtEvents.Add(nStr);
    //xxxxx

    if not Assigned(OnAjaxEvent) then
      OnAjaxEvent := GetHelper.DoGridEvent;
    if not Assigned(OnClearFilters) then
      OnClearFilters := GetHelper.DoGridClearFilters;
    if not Assigned(OnColumnFilter) then
      OnColumnFilter := GetHelper.DoGridColumnFilter;
    if not Assigned(OnColumnSort) then
      OnColumnSort := GetHelper.DoColumnSort;
    if not Assigned(OnColumnSummary) then
      OnColumnSummary := GetHelper.DoColumnSummary;
    if not Assigned(OnColumnSummaryResult) then
      OnColumnSummaryResult := GetHelper.DoColumnSummaryResult;
    //xxxxx

    if nFilter <> '' then
    begin
      nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
      TStringHelper.Split(nFilter, nList, ';', tpTrim);
    end;

    with Summary do
    begin
      Enabled := False;
      GrandTotal := False;
    end;

    for nIdx := Low(nEntity.FItems) to High(nEntity.FItems) do
    with nEntity.FItems[nIdx] do
    begin
      if FMSelect and (not (dgMultiSelect in Options)) then
        Options := Options + [dgMultiSelect, dgCheckSelect, dgCheckSelectCheckOnly];
      //xxxxx

      if not FVisible then Continue;
      if Assigned(nList) and (nList.IndexOf(FDBItem.FField) >= 0) then
        Continue;
      //�ֶα�����,������ʾ

      nColumn := Columns.Add;
      with nColumn do
      begin
        Tag := nIdx;
        Width := FWidth;
        Sortable := True;
        Locked := FLocked;

        Alignment := FAlign;
        Title.Alignment := FAlign;
        Title.Caption := FTitle;
        FieldName := FDBItem.FField;

        if (FFooter.FKind = fkSum) or (FFooter.FKind = fkCount) then
        begin
          nColumn.ShowSummary := True;
          Summary.Enabled := True;
        end;

        if FQuery then //���ݹ���
        begin
          if not (dgFilterClearButton in Options) then
            Options := Options + [dgFilterClearButton];
          //xxxxx

          Filtering.Enabled := True;
          Filtering.Editor := nBind.AddFilterCtrl(nIdx);
        end;
      end;
    end;
  finally
    nGrid.EndUpdate;
    gMG.FObjectPool.Release(nList);
  end;
end;

//Date: 2021-06-25
//Parm: ������;���;��ȡ
//Desc: ��дnForm.nGrid���û�����
class procedure TGridHelper.UserDefineGrid(const nForm: string;
  const nGrid: TUniDBGrid; const nLoad: Boolean; nIni: TIniFile);
var nStr: string;
    i,j,nCount: Integer;
    nS,nE: TDateTime;
    nBool: Boolean;
    nList: TStrings;
    nBind: PBindData;
    nDateR: PDateRange;
begin
  nBool := Assigned(nIni);
  nList := nil;
  //init

  with TStringHelper do
  try
    nGrid.BeginUpdate;
    nCount := nGrid.Columns.Count - 1;
    //column count

    nBind := GetBindData(nGrid);
    if not nBool then
      nIni := TWebSystem.UserConfigFile;
    //xxxxx

    if nLoad then
    begin
      nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
      nStr := nIni.ReadString(nForm, 'GridIndex_' + nGrid.Name, '');
      if Split(nStr, nList, '', tpNo, nGrid.Columns.Count) then
      begin
        for i := 0 to nCount do
        begin
          if not IsNumber(nList[i], False) then Continue;
          //not valid

          for j := 0 to nCount do
          if nGrid.Columns[j].Tag = StrToInt(nList[i]) then
          begin
            nGrid.Columns[j].Index := i;
            Break;
          end;
        end;
      end;

      nStr := nIni.ReadString(nForm, 'GridWidth_' + nGrid.Name, '');
      if Split(nStr, nList, '', tpNo, nGrid.Columns.Count) then
      begin
        for i := 0 to nCount do
         if IsNumber(nList[i], False) then
          nGrid.Columns[i].Width := StrToInt(nList[i]);
        //apply width
      end;

      nStr := nIni.ReadString(nForm, 'GridVisible_' + nGrid.Name, '');
      if Split(nStr, nList, '', tpNo, nGrid.Columns.Count) then
      begin
        for i := 0 to nCount do
          nGrid.Columns[i].Visible := nList[i] = '1';
        //apply visible
      end;

      if Assigned(nBind) then
      begin
        nStr := nIni.ReadString(nForm, 'GridGroupAutoClose_' + nGrid.Name, '');
        nBind.FGroupCloseAuto := nStr = 'Y';
        nBind.FGroupField := '';

        nStr := nIni.ReadString(nForm, 'GridGroupField_' + nGrid.Name, '');
        if nStr <> '' then //for group
        begin
          for i := 0 to nCount do
           if nGrid.Columns[i].FieldName = nStr then
            with nGrid.Grouping do
            begin
              FieldName := nStr;
              FieldCaption := nGrid.Columns[i].Title.Caption;

              Collapsible := True;
              Enabled := True;
              Break;
            end;

          if not nBind.FGroupCloseAuto then
            nBind.FGroupField := nStr;
          //xxxxx
        end;


        for i := 0 to nCount do
        begin
          j := nGrid.Columns[i].Tag;
          with nBind.FEntity.FItems[j] do
          begin
            if FDBItem.FType <> ftDate then Continue;
            //only init date field

            nDateR := nBind.GetDateRange(j);
            if Assigned(nDateR) then
            begin
              TWebSystem.InitDateRange(nForm, nGrid.Name + IntToStr(j),
                nS, nE, nIni);
              //����Ĭ��ʱ������

              nDateR.FBegin := nS;
              nDateR.FEnd := nE;
            end;
          end;
        end;
      end;
    end else
    begin
      if UniMainModule.FGridColumnAdjust then //save manual adjust grid
      begin
        nStr := '';
        for i := 0 to nCount do
        begin
          nStr := nStr + IntToStr(nGrid.Columns[i].Tag);
          if i <> nCount then nStr := nStr + ';';
        end;
        nIni.WriteString(nForm, 'GridIndex_' + nGrid.Name, nStr);

        nStr := '';
        for i := 0 to nCount do
        begin
          nStr := nStr + IntToStr(nGrid.Columns[i].Width);
          if i <> nCount then nStr := nStr + ';';
        end;
        nIni.WriteString(nForm, 'GridWidth_' + nGrid.Name, nStr);
      end;

      nStr := '';
      for i := 0 to nCount do
      begin
        if nGrid.Columns[i].Visible then
             nStr := nStr + '1'
        else nStr := nStr + '0';
        if i <> nCount then nStr := nStr + ';';
      end;
      nIni.WriteString(nForm, 'GridVisible_' + nGrid.Name, nStr);

      if Assigned(nBind) then
      begin
        if nBind.FGroupCloseAuto then
             nStr := 'Y'
        else nStr := 'N';

        nIni.WriteString(nForm, 'GridGroupAutoClose_' + nGrid.Name, nStr);
        nIni.WriteString(nForm, 'GridGroupField_' + nGrid.Name, nBind.FGroupField);

        for i := 0 to nCount do
        begin
          j := nGrid.Columns[i].Tag;
          with nBind.FEntity.FItems[j] do
          begin
            if FDBItem.FType <> ftDate then Continue;
            //only init date field

            nDateR := nBind.GetDateRange(j);
            if Assigned(nDateR) then
            begin
              TWebSystem.SaveDateRange(nForm, nGrid.Name + IntToStr(j),
                nDateR.FBegin, nDateR.FEnd, nIni);
              //����ʱ������
            end;
          end;
        end;
      end;
    end;
  finally
    nGrid.EndUpdate;
    gMG.FObjectPool.Release(nList);

    if not nBool then
      nIni.Free;
    //xxxxx
  end;
end;

//Date: 2021-06-25
//Parm: ������;���;��ȡ
//Desc: ��дnForm.nGrid���û�����
class procedure TGridHelper.UserDefineStringGrid(const nForm: string;
  const nGrid: TUniStringGrid; const nLoad: Boolean; nIni: TIniFile);
var nStr: string;
    nIdx,nCount: Integer;
    nBool: Boolean;
    nList: TStrings;
begin
  nBool := Assigned(nIni);
  nList := nil;
  //init

  with TStringHelper do
  try
    nGrid.BeginUpdate;
    nCount := nGrid.Columns.Count - 1;
    //column num

    if not nBool then
      nIni := TWebSystem.UserConfigFile;
    //xxxxx

    if nLoad then
    begin
      nStr := 'columnresize=function columnresize(ct,column,width,eOpts){'+
        'ajaxRequest($O, ''$E'', [''idx=''+column.dataIndex,''w=''+width])}';
      //add resize event

      nStr := MacroValue(nStr, [MI('$O', nGrid.JSName),
        MI('$E', sEvent_StrGridColumnResize)]);
      //xxxx

      nIdx := nGrid.ClientEvents.ExtEvents.IndexOf(nStr);
      if goColSizing in nGrid.Options then
      begin
        if nIdx < 0 then
        begin
          nGrid.ClientEvents.ExtEvents.Add(nStr);
          //����¼�����

          if not Assigned(nGrid.OnAjaxEvent) then
            nGrid.OnAjaxEvent := GetHelper.DoGridEvent;
          //����¼�����
        end;
      end else
      begin
        if nIdx >= 0 then
          nGrid.ClientEvents.ExtEvents.Delete(nIdx);
        //xxxxx
      end;

      nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
      nStr := nIni.ReadString(nForm, 'GridWidth_' + nGrid.Name, '');

      if Split(nStr, nList, '', tpNo, nGrid.Columns.Count) then
      begin
        for nIdx := 0 to nCount do
         if (nGrid.Columns[nIdx].Width>0) and IsNumber(nList[nIdx], False) then
          nGrid.Columns[nIdx].Width := StrToInt(nList[nIdx]);
        //apply width
      end;
    end else

    if goColSizing in nGrid.Options then
    begin
      nStr := '';
      for nIdx := 0 to nCount do
      begin
        nStr := nStr + IntToStr(nGrid.Columns[nIdx].Width);
        if nIdx <> nCount then nStr := nStr + ';';
      end;
      nIni.WriteString(nForm, 'GridWidth_' + nGrid.Name, nStr);
    end;
  finally
    nGrid.EndUpdate;
    gMG.FObjectPool.Release(nList);
    if not nBool then
      nIni.Free;
    //xxxxx
  end;
end;

//Date: 2021-06-27
//Parm: ���;����
//Desc: �û������п�ʱ����,���û������Ľ��Ӧ�õ�nGrid
class procedure TGridHelper.DoStringGridColumnResize(const nGrid: TObject;
  const nParam: TUniStrings);
var nStr: string;
    nIdx,nW: Integer;
begin
  with TStringHelper,TUniStringGrid(nGrid) do
  begin
    nStr := nParam.Values['idx'];
    if IsNumber(nStr, False) then
         nIdx := StrToInt(nStr)
    else nIdx := -1;

    if (nIdx < 0) or (nIdx >= Columns.Count) then Exit;
    //out of range

    nStr := nParam.Values['w'];
    if IsNumber(nStr, False) then
         nW := StrToInt(nStr)
    else nW := -1;

    if nW < 0 then Exit;
    if nW > 320 then
      nW := 320;
    Columns[nIdx].Width := nW;
  end;
end;

//Date: 2021-06-25
//Desc: �������¼�
procedure TGridHelper.DoGridEvent(Sender: TComponent; nEventName: string;
  nParams: TUniStrings);
var nStr: string;
    nInt: Integer;
    nBind: PBindData;
    nSA: TStringHelper.TStringArray;
begin
  if nEventName = sEvent_StrGridColumnResize then
  begin
    DoStringGridColumnResize(Sender, nParams);
    //�û������п�
  end else

  if nEventName = sEvent_DBGridHeaderPopmenu then
  begin
    nBind := GetBindData(Sender);
    if not Assigned(nBind) then Exit;
    nBind.FActiveColumn := nil;

    nStr := nParams.Values['col'];
    if TStringHelper.IsNumber(nStr) then
    begin
      nInt := StrToInt(nStr);
      if (nInt >= 0) and (nInt < nBind.FDBGrid.Columns.Count) then
      begin
        nBind.FActiveColumn := nBind.FDBGrid.Columns[nInt];
        //��ȡ�˵����ڵ���
      end;
    end;

    if Assigned(nBind.FColumnMenu) and
       TStringHelper.SplitArray(nParams.Values['xy'], nSA, ',', tpTrim, 2) then
    begin
      nBind.GetMenu(cMenu_EditDict).Enabled := UniMainModule.FUser.FIsAdmin;
      nBind.GetMenu(cMenu_GridAdjust).Checked := UniMainModule.FGridColumnAdjust;
      //normal
      nBind.GetMenu(cMenu_GroupEnable).Enabled := Assigned(nBind.FActiveColumn);
      nBind.GetMenu(cMenu_GroupClose).Enabled := nBind.FGroupField <> '';
      nBind.GetMenu(cMenu_GroupCloseAuto).Checked := nBind.FGroupCloseAuto;
      nBind.GetMenu(cMenu_ExpandAll).Enabled := nBind.FDBGrid.Grouping.Enabled;
      nBind.GetMenu(cMenu_CollapseAll).Enabled := nBind.FDBGrid.Grouping.Enabled;
      //group

      nBind.FColumnMenu.Popup(StrToInt(nSA[0]), StrToInt(nSA[1]),
        UniMainModule.MainForm);
      //show menu
    end;
  end;
end;

//Date: 2021-07-19
//Desc: ��ͷ�˵��¼�
procedure TGridHelper.DoColumnMenuClick(Sender: TObject);
var nStr: string;
    nBind: PBindData;
    nP: TCommandParam;
begin
  nBind := GetBindByMenu((Sender as TUniMenuItem).GetParentMenu);
  if not Assigned(nBind) then Exit;
  //no bind data

  case TComponent(Sender).Tag of
   cMenu_GridAdjust: //�����������Ⱥ�˳��
    begin
      with UniMainModule do
      begin
        FGridColumnAdjust := not FGridColumnAdjust;
        if FGridColumnAdjust then
          ShowMsg('����ÿһ�п��Ե���λ�úͿ��', False, '���´���Ч');
        //xxxxx
      end;
    end;
   cMenu_EditDict: //�༭��������ֵ�
    begin
      nP.Init.AddS(nBind.FEntity.FEntity).
              AddP(nBind.FEntity).AddO(nBind.FMemTable);
      //xxxxx

      if Assigned(nBind.FActiveColumn) then
        nP.AddO(nBind.FActiveColumn);
      //xxxxx

      TWebSystem.ShowModalForm('TfFormEditDataDict', @nP);
    end;
   cMenu_GroupEnable: //���÷���
    begin
      nBind.FGroupField := nBind.FActiveColumn.FieldName;
      nStr := Format('��&quot;%s&quot;������ʾ', [nBind.FActiveColumn.Title.Caption]);
      UniMainModule.ShowMsg(nStr, False, '���´���Ч');
    end;
   cMenu_GroupClose: //�رշ���
    begin
      nBind.FGroupField := '';
      UniMainModule.ShowMsg('��ȡ��������ʾ', False, '���´���Ч');
    end;
   cMenu_GroupCloseAuto: //�Զ��رշ���
    begin
      nBind.FGroupCloseAuto := not nBind.FGroupCloseAuto;
    end;
   cMenu_ExpandAll: //չ������
    begin
      with nBind.FDBGrid do
       if Grouping.Collapsible then
        JSInterface.JSCall('getView().getFeature("grouping").expandAll', []);
      //xxxxx
    end;
   cMenu_CollapseAll: //�������
    begin
      with nBind.FDBGrid do
       if Grouping.Collapsible then
        JSInterface.JSCall('getView().getFeature("grouping").collapseAll', []);
      //xxxxx
    end;
   cMenu_QueryFor: //��ѯ˵��
    begin
      nStr := gPath + sLocalDir + 'QueryFor.' + UniMainModule.FUser.FLangID;
      if FileExists(nStr) then
      begin
        nP.Init(cCmd_ViewFile).AddS([nStr, '��ѯ˵��']);
        TWebSystem.ShowModalForm('TfFormMemo', @nP);
        Exit;
      end;

      nStr := '�����ʽ: ���ӷ�,����1,...,����n<ul>' +
        '<li>���ӷ�: and, or, not</li>' +
        '<li>����: �ַ���(lucy),��ֵ(123),�ȽϷ�(<,=,>)</li></ul>����: <ul>' +
        '<li>lucy,lily: ��ѯlucy��lily</li>' +
        '<li>lucy,or lily: ��ѯlucy��lily</li>' +
        '<li>not,lucy: ��ѯ������lucy</li>' +
        '<li>not,lucy,lily: ��ѯ������lucy��lily</li>' +
        '<li>>10,<20: ��ѯ����10,С��20</li></ul>';
      //xxxxx

      nP.Init(cCmd_ViewData).AddS([nStr, '��ѯ˵��']);
      TWebSystem.ShowModalForm('TfFormMemo', @nP);
    end;
   cMenu_QueryData: //��ǰ��ѯ����
    begin
      nP.Init(cCmd_ViewData).AddS([TStringHelper.StrIF(['��', nBind.FFilterWhere],
        nBind.FFilterWhere = ''), '��ѯ����']);
      TWebSystem.ShowModalForm('TfFormMemo', @nP);
    end;
  end;
end;

//Date: 2021-08-07
//Desc: �����������˫��
procedure TGridHelper.DoGridFilterCtrlDbClick(Sender: TObject);
var nIdx: Integer;
    nBind: PBindData;
    nDateR: PDateRange;
    nP: TCommandParam;
begin
  nBind := GetBindByFilter(Sender as TControl);
  if not (Assigned(nBind) and Assigned(nBind.FFilterEvent)) then Exit;

  nIdx := (Sender as TComponent).Tag;
  with nBind.FEntity.FItems[nIdx] do
  begin
    nDateR := nBind.GetDateRange(nIdx);
    if not Assigned(nDateR) then Exit;

    nP.Init(cCmd_EditData).AddI(Ord(FDBItem.FType)).
      AddP([@nDateR.FBegin, @nDateR.FEnd, @nDateR.FUseMe]);
    //init param

    TWebSystem.ShowModalForm('TfFormDateFilter', @nP,
      procedure(const nResult: Integer; const nParam: PCommandParam)
      begin
        if nResult = mrOk then
        begin
          nBind.SetFilterDefaultText(Sender as TUniEdit);
          //nBind.FFilterEvent(nBind, False);
        end;
      end);
  end;
end;

//Date: 2021-08-01
//Desc: �������в�ѯ����
procedure TGridHelper.DoGridClearFilters(Sender: TObject);
var nBind: PBindData;
begin
  nBind := GetBindData(Sender);
  if Assigned(nBind) and Assigned(nBind.FFilterEvent) then
  begin
    nBind.SetAllFilterDefaultText();
    //set default text

    nBind.FFilterEvent(nBind, True);
    //do event
  end;
end;

//Date: 2021-08-01
//Desc: ��������
procedure TGridHelper.DoGridColumnFilter(Sender: TUniDBGrid;
  const nColumn: TUniDBGridColumn; const nValue: Variant);
var nBind: PBindData;
begin
  nBind := GetBindData(Sender);
  if Assigned(nBind) and Assigned(nBind.FFilterEvent) then
  begin
    nBind.FFilterEvent(nBind, False);
    //do event
  end;
end;

//Date: 2021-06-25
//Parm: �����ֵ�;���ݼ�;�����¼�
//Desc: ����nClientDS���ݸ�ʽ��
class procedure TGridHelper.SetGridColumnFormat(const nEntity: PDictEntity;
  const nMT: TkbmMemTable);
var nIdx: Integer;
    nField: TField;
begin
  for nIdx := Low(nEntity.FItems) to High(nEntity.FItems) do
  with nEntity.FItems[nIdx] do
  begin
    if FFormat.FStyle <> fsFixed then Continue;
    if Trim(FFormat.FData) = '' then Continue;

    nField := nMT.FindField(FDBItem.FField);
    if Assigned(nField) then
    begin
      nField.Tag := nIdx;
      nField.OnGetText := GetHelper.DoColumnFormat;
    end;
  end;
end;

//Date: 2021-06-25
//Parm: �ֶ�;��������;��ǰ��ʾ
//Desc: �����ݸ�ʽ��Ϊ��ʾ����
procedure TGridHelper.DoColumnFormat(Sender: TField; var nText: string;
  nDisplayText: Boolean);
var nStr: string;
    nIdx,nInt: Integer;
    nBind: PBindData;
begin
  SyncLock;
  try
    if not FBindData.TryGetValue(Sender.DataSet, nBind) then Exit;
    //no bind datadict

    with nBind.FEntity.FItems[Sender.Tag] do
    begin
      nStr := Trim(Sender.AsString) + '=';
      if nStr = '=' then Exit;

      nIdx := Pos(nStr, FFormat.FData);
      if nIdx < 1 then Exit;

      nInt := nIdx + Length(nStr);     //start
      nStr := Copy(FFormat.FData, nInt, Length(FFormat.FData) - nInt + 1);

      nInt := Pos(';', nStr);
      if nInt < 2 then
           nText := nStr
      else nText := Copy(nStr, 1, nInt - 1);
    end;
  finally
    SyncUnlock;
  end;
end;

//Date: 2021-06-24
//Parm: ���ݼ�
//Desc: ����nDS����������
class procedure TGridHelper.BuidDataSetSortIndex(const nMT: TkbmMemTable);
var nStr: string;
    nIdx: Integer;
begin
  with nMT do
  begin
    for nIdx := FieldCount-1 downto 0 do
    begin
      nStr := Fields[nIdx].FieldName + '_asc';
      if IndexDefs.IndexOf(nStr) < 0 then
        AddIndex(nStr, Fields[nIdx].FieldName, []);
      //xxxxx

      nStr := Fields[nIdx].FieldName + '_des';
      if IndexDefs.IndexOf(nStr) < 0 then
        AddIndex(nStr, Fields[nIdx].FieldName, [ixDescending]);
      //xxxxx
    end;
  end;
end;

//Date: 2021-06-27
//Parm: ������;����ʽ
//Desc: ����nDirection��nCol����
procedure TGridHelper.DoColumnSort(nCol: TUniDBGridColumn; nDirection: Boolean);
var nStr: string;
    nMT: TkbmMemTable;
begin
  if TUniDBGrid(nCol.Grid).DataSource.DataSet is TkbmMemTable then
       nMT := TUniDBGrid(nCol.Grid).DataSource.DataSet as TkbmMemTable
  else Exit;

  if nDirection then
       nStr := nCol.FieldName + '_asc'
  else nStr := nCol.FieldName + '_des';

  if nMT.IndexDefs.IndexOf(nStr) >= 0 then
    nMT.IndexName := nStr;
  //xxxxx
end;

//Date: 2021-06-27
//Parm: ������;�ϼ�ֵ
//Desc: ��nColִ�кϼ�
procedure TGridHelper.DoColumnSummary(nCol: TUniDBGridColumn; nValue: Variant);
var nBind: PBindData;
begin
  SyncLock;
  try
    if not FBindData.TryGetValue(nCol.Grid, nBind) then Exit;
    //no bind datadict

    with nBind.FEntity.FItems[nCol.Tag] do
    begin
      if FFooter.FKind = fkSum then //sum
      begin
        if nCol.AuxValue = NULL then
             nCol.AuxValue := nCol.Field.AsFloat
        else nCol.AuxValue := nCol.AuxValue + nCol.Field.AsFloat;
      end else

      if FFooter.FKind = fkCount then //count
      begin
        if nCol.AuxValue = NULL then
             nCol.AuxValue := 1
        else nCol.AuxValue := nCol.AuxValue + 1;
      end;
    end;
  finally
    SyncUnlock;
  end;
end;

//Date: 2021-06-27
//Parm: ������
//Desc: ��ʾnCol�ϼƽ��
procedure TGridHelper.DoColumnSummaryResult(nCol: TUniDBGridColumn;
  nValue: Variant; nAttribs: TUniCellAttribs; var nResult: string);
var nF: Double;
    nI: Integer;
    nBind: PBindData;
begin
  SyncLock;
  try
    if not FBindData.TryGetValue(nCol.Grid, nBind) then Exit;
    //no bind datadict

    with nBind.FEntity.FItems[nCol.Tag] do
    begin
      if FFooter.FKind = fkSum then //sum
      begin
        if nCol.AuxValue = Null then Exit;
        nF := nCol.AuxValue;
        nResult := FormatFloat(FFooter.FFormat, nF );

        nAttribs.Font.Style := [fsBold];
        nAttribs.Font.Color := clNavy;
      end else

      if FFooter.FKind = fkCount then //count
      begin
        if nCol.AuxValue = Null then Exit;
        nI := nCol.AuxValue;
        nResult := FormatFloat(FFooter.FFormat, nI);

        nAttribs.Font.Style := [fsBold];
        nAttribs.Font.Color := clNavy;
      end;
    end;

    nCol.AuxValue := NULL;
  finally
    SyncUnlock;
  end;
end;

class function TGridHelper.GridExportExcel(const nGrid: TUniDBGrid;
  const nFile: string): string;
begin

end;

initialization
  TGridHelper.Init(True);
finalization
  TGridHelper.Release;
end.


