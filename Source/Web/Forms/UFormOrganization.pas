{*******************************************************************************
  作者: dmzn@163.com 2021-09-29
  描述: 组织结构信息
*******************************************************************************}
unit UFormOrganization;

interface

uses
  System.SysUtils, UFormNormal, UFormBase, System.IniFiles, ULibFun, Data.DB,
  MainModule, uniGUITypes, UGlobalConst, Vcl.Menus, uniMainMenu, uniBasicGrid,
  uniStringGrid, uniMemo, uniDateTimePicker, uniEdit, uniGUIClasses,
  uniMultiItem, uniComboBox, uniPanel, uniPageControl, System.Classes,
  Vcl.Controls, Vcl.Forms, uniGUIBaseClasses, uniButton, uniBitBtn, UniFSButton;

type
  TfFormOrganization = class(TfFormNormal)
    wPage: TUniPageControl;
    Sheet1: TUniTabSheet;
    Sheet2: TUniTabSheet;
    SheetAddress: TUniTabSheet;
    SheetContact: TUniTabSheet;
    EditType: TUniComboBox;
    EditName: TUniEdit;
    EditValid: TUniDateTimePicker;
    EditParent: TUniEdit;
    EditPName: TUniEdit;
    EditCode: TUniEdit;
    EditPAddr: TUniMemo;
    GridPost: TUniStringGrid;
    PMenu1: TUniPopupMenu;
    N1: TUniMenuItem;
    N2: TUniMenuItem;
    N3: TUniMenuItem;
    N4: TUniMenuItem;
    EditMName: TUniEdit;
    EditMPhone: TUniEdit;
    EditMMail: TUniMemo;
    GridMail: TUniStringGrid;
    procedure BtnOKClick(Sender: TObject);
    procedure GridPostMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N4Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure GridPostDblClick(Sender: TObject);
    procedure EditPNameChange(Sender: TObject);
    procedure N3Click(Sender: TObject);
  private
    { Private declarations }
    FUnitID: string;
    FParentID: string;
    //节点标识
    FAddress: TOrgAddressItems;
    FContact: TOrgContactItems;
    //扩展数据
    procedure AddTypes(nTypes: TApplicationHelper.TOrganizationStructures;
      const nParent: TApplicationHelper.TOrganizationStructure);
    //添加组织类型
    procedure LoadUnitData(const nUnit: string);
    procedure LoadExtendData(const nOwner: string);
    procedure SaveExtendData(const nList: TStrings);
    //读写扩展数据
    procedure RefreshGrid(const nGrid: TUniStringGrid = nil);
    //刷新列表数据
    procedure SelecteExtend(const nIdx: Integer = -1);
    function GetExtendSelected(const nUI: Boolean): Integer;
    //选中的扩展数据
  public
    { Public declarations }
    class function ConfigMe: TfFormConfig; override;
    procedure DoFormConfig(nIni: TIniFile; const nLoad: Boolean); override;
    function SetData(const nData: PCommandParam): Boolean; override;
    class function CallMe(const nData: PCommandParam): Boolean; override;
  end;

implementation

{$R *.dfm}

uses
  UManagerGroup, UDBFun, USysBusiness, UGridHelper, USysDB, USysConst;

class function TfFormOrganization.ConfigMe: TfFormConfig;
begin
  Result := inherited ConfigMe();
  Result.FUserConfig := True;
  Result.FDesc := '组织结构信息';
end;

procedure TfFormOrganization.DoFormConfig(nIni: TIniFile; const nLoad: Boolean);
begin
  if nLoad then
  begin
    FUnitID := '';
    FParentID := '';
    SetLength(FAddress, 0);
    SetLength(FContact, 0);
    GridPost.RowCount := 0;
    GridMail.RowCount := 0;

    BtnOK.Enabled := False;
    wPage.ActivePageIndex := 0;
    EditValid.DateTime := TDateTimeHelper.Str2Date('2099-12-31');

    with EditPAddr.JSInterface do
    begin
      JSConfig('maxLength', '320');
      JSConfig('enforceMaxLength', 'true');
    end;

    with EditMMail.JSInterface do
    begin
      JSConfig('maxLength', '320');
      JSConfig('enforceMaxLength', 'true');
    end;
  end;

  TGridHelper.UserDefineStringGrid(Name, GridPost, nLoad, nIni);
  TGridHelper.UserDefineStringGrid(Name, GridMail, nLoad, nIni);
end;

function TfFormOrganization.SetData(const nData: PCommandParam): Boolean;
var nPNode: POrganizationItem;
begin
  Result := inherited SetData(nData);
  case nData.Command of
    cCmd_AddData : Caption := '添加';
    cCmd_EditData: Caption := '修改';
  end;

  if (nData.Command = cCmd_AddData) or (nData.Command = cCmd_EditData) then
  begin
    if nData.IsValid(ptPtr) then
    begin
      nPNode := nData.Ptr[0];
      if Assigned(nPNode) then
      begin
        FParentID := nPNode.FID;
        AddTypes([], nPNode.FType);
        EditParent.Text := sOrganizationNames[nPNode.FType] + ' ' + nPNode.FName;
      end else
      begin
        AddTypes([osGroup], osGroup);
        EditParent.Text := sOrganizationNames[osGroup] + '列表';
      end;
    end;
  end;

  if (nData.Command = cCmd_EditData) and nData.IsValid(ptPtr, 2) then
  begin
    nPNode := nData.Ptr[1];
    EditName.Text := nPNode.FName;
    EditType.Text := sOrganizationNames[nPNode.FType];

    FUnitID := nPNode.FID;
    LoadUnitData(FUnitID);
    LoadExtendData(FUnitID);
    RefreshGrid();
  end;
end;

class function TfFormOrganization.CallMe(const nData: PCommandParam): Boolean;
var nStr: string;
    nNode: POrganizationItem;
begin
  Result := False;
  if (nData.Command <> cCmd_DeleteData) or (not nData.IsValid(ptPtr)) then Exit;
  nNode := nData.Ptr[0];

  UniMainModule.ShowMsg(nNode.FName);
end;

//Date: 2021-10-08
//Parm: 待添加类型;父类型
//Desc: 向列表添加组织类型
procedure TfFormOrganization.AddTypes(
  nTypes: TApplicationHelper.TOrganizationStructures;
  const nParent: TApplicationHelper.TOrganizationStructure);
begin
  with EditType do
  try
    Items.BeginUpdate;
    Items.Clear;

    if nTypes = [] then
    begin
      case nParent of
       osGroup   : nTypes := [osArea];      //集团下级: 区域
       osArea    : nTypes := [osFactory];   //区域下级: 工厂
       osFactory : nTypes := [];            //工厂下级: 无
      end;
    end;

    if osGroup in nTypes then Items.Add(sOrganizationNames[osGroup]);
    if osArea in nTypes then Items.Add(sOrganizationNames[osArea]);
    if osFactory in nTypes then Items.Add(sOrganizationNames[osFactory]);

    if Items.Count > 0 then
      ItemIndex := 0; //first default
    BtnOK.Enabled := Items.Count > 0;
  finally
    Items.EndUpdate;
  end;
end;

//Date: 2021-10-29
//Parm: 组织标识
//Desc: 载入nUnit的数据
procedure TfFormOrganization.LoadUnitData(const nUnit: string);
var nStr: string;
    nQuery: TDataSet;
begin
  nQuery := nil;
  try
    nStr := 'Select * From %s Where O_ID=''%s''';
    nStr := Format(nStr, [sTable_Organization, nUnit]);
    nQuery := gMG.FDBManager.DBQuery(nStr);

    with nQuery do
    if RecordCount > 0 then
    begin
      EditValid.DateTime := FieldByName('O_ValidOn').AsDateTime;
    end;
  finally
    gMG.FDBManager.ReleaseDBQuery(nQuery);
  end;
end;

//Date: 2021-10-18
//Parm: 拥有者标识
//Desc: 载入nOwner的扩展数据
procedure TfFormOrganization.LoadExtendData(const nOwner: string);
var nStr: string;
    nIdx: Integer;
    nQuery: TDataSet;
begin
  nQuery := nil;
  try
    nStr := 'Select * From %s Where A_Owner=''%s''';
    nStr := Format(nStr, [sTable_OrgAddress, nOwner]);
    nQuery := gMG.FDBManager.DBQuery(nStr);

    with nQuery do
    if RecordCount > 0 then
    begin
      SetLength(FAddress, RecordCount);
      nIdx := 0;
      First;

      while not Eof do
      begin
        with FAddress[nIdx] do
        begin
          FID       := FieldByName('A_ID').AsString;
          FName     := FieldByName('A_Name').AsString;
          FPost     := FieldByName('A_PostCode').AsString;
          FAddr     := FieldByName('A_Address').AsString;
          FOwner    := FieldByName('A_Owner').AsString;

          FValid    := True;
          FModified := False;
          FSelected := False;
        end;

        Inc(nIdx);
        Next;
      end;
    end;

    //--------------------------------------------------------------------------
    nStr := 'Select * From %s Where C_Owner=''%s''';
    nStr := Format(nStr, [sTable_OrgContact, nOwner]);
    nQuery := gMG.FDBManager.DBQuery(nStr, nQuery);

    with nQuery do
    if RecordCount > 0 then
    begin
      SetLength(FContact, RecordCount);
      nIdx := 0;
      First;

      while not Eof do
      begin
        with FContact[nIdx] do
        begin
          FID       := FieldByName('C_ID').AsString;
          FName     := FieldByName('C_Name').AsString;
          FPhone    := FieldByName('C_Phone').AsString;
          FMail     := FieldByName('C_Mail').AsString;
          FOwner    := FieldByName('C_Owner').AsString;

          FValid    := True;
          FModified := False;
          FSelected := False;
        end;

        Inc(nIdx);
        Next;
      end;
    end;
  finally
    gMG.FDBManager.ReleaseDBQuery(nQuery);
  end;
end;

procedure TfFormOrganization.RefreshGrid(const nGrid: TUniStringGrid = nil);
var nIdx,nInt: Integer;
begin
  GridPost.BeginUpdate;
  GridMail.BeginUpdate;
  try
    if (nGrid = nil) or (nGrid = GridPost) then
    begin
      nInt := 0;
      for nIdx := Low(FAddress) to High(FAddress) do
       if FAddress[nIdx].FValid then Inc(nInt);
      GridPost.RowCount := nInt;

      nInt := 0;
      for nIdx := Low(FAddress) to High(FAddress) do
       with FAddress[nIdx],GridPost do
        if FValid then
        begin
          Cells[0, nInt] := IntToStr(nIdx);
          Cells[1, nInt] := FName;
          Cells[2, nInt] := FPost;
          Cells[3, nInt] := FAddr;

          if FSelected then
            Row := nInt;
          Inc(nInt);
        end;
    end;

    if (nGrid = nil) or (nGrid = GridMail) then
    begin
      nInt := 0;
      for nIdx := Low(FContact) to High(FContact) do
       if FContact[nIdx].FValid then Inc(nInt);
      GridMail.RowCount := nInt;

      nInt := 0;
      for nIdx := Low(FContact) to High(FContact) do
       with FContact[nIdx],GridMail do
        if FValid then
        begin
          Cells[0, nInt] := IntToStr(nIdx);
          Cells[1, nInt] := FName;
          Cells[2, nInt] := FPhone;
          Cells[3, nInt] := FMail;

          if FSelected then
            Row := nInt;
          Inc(nInt);
        end;
    end;
  finally
    GridPost.EndUpdate;
    GridMail.EndUpdate;
  end;
end;

//Date: 2021-10-26
//Parm: 索引
//Desc: 设置选中数据
procedure TfFormOrganization.SelecteExtend(const nIdx: Integer);
var i: Integer;
begin
  if wPage.ActivePage = SheetAddress then
  begin
    for i := Low(FAddress) to High(FAddress) do
      FAddress[i].FSelected := False;
    //xxxxx

    if nIdx > -1  then
      FAddress[nIdx].FSelected := True;
    //xxxxx
  end else

  if wPage.ActivePage = SheetContact then
  begin
    for i := Low(FContact) to High(FContact) do
      FContact[i].FSelected := False;
    //xxxxx

    if nIdx > -1  then
      FContact[nIdx].FSelected := True;
    //xxxxx
  end;
end;

//Date: 2021-10-23
//Parm: 界面数据
//Desc: 返回选中的数据索引
function TfFormOrganization.GetExtendSelected(const nUI: Boolean): Integer;
var nIdx: Integer;
begin
  Result := -1;
  if wPage.ActivePage = SheetAddress then
  begin
    if nUI then
    begin
      if GridPost.Row >=0 then
      begin
        Result := StrToInt(GridPost.Cells[0, GridPost.Row]);
      end;
    end else
    begin
      for nIdx := Low(FAddress) to High(FAddress) do
      if FAddress[nIdx].FSelected and FAddress[nIdx].FValid then
      begin
        Result := nIdx;
        Break;
      end;
    end;
  end else

  if wPage.ActivePage = SheetContact then
  begin
    if nUI then
    begin
      if GridMail.Row >=0 then
      begin
        Result := StrToInt(GridMail.Cells[0, GridMail.Row]);
      end;
    end else
    begin
      for nIdx := Low(FContact) to High(FContact) do
      if FContact[nIdx].FSelected and FContact[nIdx].FValid then
      begin
        Result := nIdx;
        Break;
      end;
    end;
  end;
end;

procedure TfFormOrganization.GridPostDblClick(Sender: TObject);
var nIdx: Integer;
begin
  nIdx := GetExtendSelected(True);
  if nIdx < 0 then Exit;
  SelecteExtend(nIdx);

  if wPage.ActivePage = SheetAddress then
  with FAddress[nIdx] do
  begin
    EditPName.Text := FName;
    EditCode.Text := FPost;
    EditPAddr.Text := FAddr;
  end else

  if wPage.ActivePage = SheetContact then
  with FContact[nIdx] do
  begin
    EditMName.Text := FName;
    EditMPhone.Text := FPhone;
    EditMMail.Text := FMail;
  end;
end;

procedure TfFormOrganization.EditPNameChange(Sender: TObject);
var nIdx: Integer;
begin
  nIdx := GetExtendSelected(False);
  if nIdx < 0 then Exit;

  if wPage.ActivePage = SheetAddress then
  with FAddress[nIdx] do
  begin
    if Sender = EditPName then FName := EditPName.Text else
    if Sender = EditCode then  FPost := EditCode.Text else
    if Sender = EditPAddr then FAddr := EditPAddr.Text;

    FModified := True;
    RefreshGrid(GridPost);
  end else

  if wPage.ActivePage = SheetContact then
  with FContact[nIdx] do
  begin
    if Sender = EditMName then  FName := EditMName.Text else
    if Sender = EditMPhone then FPhone := EditMPhone.Text else
    if Sender = EditMMail then  FMail := EditMMail.Text;

    FModified := True;
    RefreshGrid(GridMail);
  end;
end;

procedure TfFormOrganization.GridPostMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    PMenu1.Popup(X, Y, Sender);
  //xxxxx
end;

//Desc: 添加项
procedure TfFormOrganization.N1Click(Sender: TObject);
var nIdx: Integer;
begin
  if wPage.ActivePage = SheetAddress then
  begin
    for nIdx := Low(FAddress) to High(FAddress) do
     with FAddress[nIdx] do
      if FValid and (FID = '') and (FName = '') then Exit;
    //has new item

    ActiveControl := EditPName;
    nIdx := Length(FAddress);
    SetLength(FAddress, nIdx + 1);

    with FAddress[nIdx] do
    begin
      FValid := True;
      FModified := False;
      SelecteExtend(nIdx);

      RefreshGrid(GridPost);
      N4Click(nil);
      ActiveControl := EditPName;
    end;
  end;

  if wPage.ActivePage = SheetContact then
  begin
    for nIdx := Low(FContact) to High(FContact) do
     with FContact[nIdx] do
      if FValid and (FID = '') and (FName = '') then Exit;
    //has new item

    ActiveControl := EditMName;
    nIdx := Length(FContact);
    SetLength(FContact, nIdx + 1);

    with FContact[nIdx] do
    begin
      FValid := True;
      FModified := False;
      SelecteExtend(nIdx);

      RefreshGrid(GridMail);
      N4Click(nil);
      ActiveControl := EditMName;
    end;
  end;
end;

//Desc: 删除
procedure TfFormOrganization.N3Click(Sender: TObject);
var nIdx: Integer;
begin
  nIdx := GetExtendSelected(True);
  if nIdx < 0 then Exit;

  if wPage.ActivePage = SheetAddress then
  begin
    FAddress[nIdx].FValid := False;
    FAddress[nIdx].FSelected := False;
    RefreshGrid(GridPost);
  end;

  if wPage.ActivePage = SheetContact then
  begin
    FContact[nIdx].FValid := False;
    FAddress[nIdx].FSelected := False;
    RefreshGrid(GridMail);
  end;
end;

//Desc: 重置内容
procedure TfFormOrganization.N4Click(Sender: TObject);
var nIdx: Integer;
begin
  with wPage.ActivePage do
  begin
    for nIdx := ControlCount - 1 downto 0 do
    begin
      if Controls[nIdx] is TUniEdit then
        (Controls[nIdx] as TUniEdit).Text := '';
      //xxxxx

      if Controls[nIdx] is TUniMemo then
        (Controls[nIdx] as TUniMemo).Clear;
      //xxxxx
    end;
  end;
end;

//Date: 2021-10-18
//Parm: SQL列表
//Desc: 构建保存SQL,存入nList
procedure TfFormOrganization.SaveExtendData(const nList: TStrings);
var nStr: string;
    nIdx: Integer;
    nIsNew: Boolean;
begin
  with TSQLBuilder do
  begin
    for nIdx := Low(FAddress) to High(FAddress) do
    with FAddress[nIdx] do
    begin
      if FValid and FModified then
      begin
        nIsNew := FID = '';
        nStr := TSQLBuilder.MakeSQLByStr([
          SF('A_Name', FName),
          SF('A_PostCode', FPost),
          SF('A_Address', FAddr),

          SF_IF([SF('A_ID', TDBCommand.SnowflakeID), ''], nIsNew),
          SF_IF([SF('A_Owner', FUnitID), ''], nIsNew)
          ], sTable_OrgAddress, SF('A_ID', FID), nIsNew);
        nList.Add(nStr);
      end else

      if (not FValid) and (FID <> '') then
      begin
        nStr := 'Delete From %s Where A_ID=''%s''';
        nStr := Format(nStr, [sTable_OrgAddress, FID]);
        nList.Add(nStr);
      end;
    end;

    for nIdx := Low(FContact) to High(FContact) do
    with FContact[nIdx] do
    begin
      if FValid and FModified then
      begin
        nIsNew := FID = '';
        nStr := TSQLBuilder.MakeSQLByStr([
          SF('C_Name', FName),
          SF('C_Phone', FPhone),
          SF('C_Mail', FMail),

          SF_IF([SF('C_ID', TDBCommand.SnowflakeID), ''], nIsNew),
          SF_IF([SF('C_Owner', FUnitID), ''], nIsNew)
          ], sTable_OrgContact, SF('C_ID', FID), nIsNew);
        nList.Add(nStr);
      end else

      if (not FValid) and (FID <> '') then
      begin
        nStr := 'Delete From %s Where C_ID=''%s''';
        nStr := Format(nStr, [sTable_OrgContact, FID]);
        nList.Add(nStr);
      end;
    end;
  end;
end;

procedure TfFormOrganization.BtnOKClick(Sender: TObject);
var nStr: string;
    nIsNew: Boolean;
    nList: TStrings;
begin
  if EditType.ItemIndex < 0 then
  begin
    UniMainModule.ShowMsg('无效的组织类型');
    Exit;
  end;

  EditName.Text := Trim(EditName.Text);
  if EditName.Text = '' then
  begin
    UniMainModule.ShowMsg('请填写组织名称');
    Exit;
  end;

  nList := nil;
  with TStringHelper,TSQLBuilder,TDateTimeHelper do
  try
    nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
    nList.Clear;

    nIsNew := FParam.Command = cCmd_AddData;
    if nIsNew then
      FUnitID := TDBCommand.SnowflakeID;
    //xxxxx

    nStr := MakeSQLByStr([
      SF('O_Name', EditName.Text),
      SF('O_NamePy', GetPinYin(EditName.Text)),
      SF('O_Type', Enum2Str(TGlobalBusiness.Name2Organization(EditType.Text))),
      SF('O_ValidOn', Date2Str(EditValid.DateTime)),

      SF_IF([SF('O_ID', FUnitID), ''], nIsNew),
      SF_IF([SF('O_Parent', FParentID), ''], nIsNew)
      ], sTable_Organization, SF('O_ID', FUnitID), nIsNew);
    nList.Add(nStr);

    SaveExtendData(nList);
    gMG.FDBManager.DBExecute(nList); //save to db
  finally
    gMG.FObjectPool.Release(nList);
  end;

  ModalResult := mrOk;
end;

initialization
  TWebSystem.AddForm(TfFormOrganization);
end.
