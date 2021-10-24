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
    procedure LoadExtendData(const nOwner: string);
    procedure SaveExtendData(const nList: TStrings);
    //读写扩展数据
    procedure RefreshGrid();
    //刷新列表数据
    function GetExtendSelected: Integer;
    //选中的扩展数据
  public
    { Public declarations }
    class function ConfigMe: TfFormConfig; override;
    procedure DoFormConfig(nIni: TIniFile; const nLoad: Boolean); override;
    function SetData(const nData: PCommandParam): Boolean; override;
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
    LoadExtendData(FUnitID);
    RefreshGrid();
  end;
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
        end;

        Inc(nIdx);
        Next;
      end;
    end;
  finally
    gMG.FDBManager.ReleaseDBQuery(nQuery);
  end;
end;

procedure TfFormOrganization.RefreshGrid;
var nIdx,nInt: Integer;
begin
  GridPost.BeginUpdate;
  GridMail.BeginUpdate;
  try
    nInt := 0;
    for nIdx := Low(FAddress) to High(FAddress) do
     with FAddress[nIdx],GridPost do
      if FValid then
      begin
        Inc(nInt);
        RowCount := nInt;

        Cells[0, nInt] := FName;
        Cells[1, nInt] := FPost;
        Cells[2, nInt] := FAddr;
        Cells[3, nInt] := IntToStr(nIdx);
      end;

    nInt := 0;
    for nIdx := Low(FContact) to High(FContact) do
     with FContact[nIdx],GridMail do
      if FValid then
      begin
        Inc(nInt);
        RowCount := nInt;

        Cells[0, nInt] := FName;
        Cells[1, nInt] := FPhone;
        Cells[2, nInt] := FMail;
        Cells[3, nInt] := IntToStr(nIdx);
      end;
  finally
    GridPost.EndUpdate;
    GridMail.EndUpdate;
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
      end;

    for nIdx := Low(FContact) to High(FContact) do
    with FContact[nIdx] do
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
      end;
  end;
end;

//Date: 2021-10-23
//Desc: 返回选中的数据索引
function TfFormOrganization.GetExtendSelected: Integer;
begin
  Result := -1;
  if wPage.ActivePage = SheetAddress then
  begin
    if GridPost.Row >=0 then
    begin
      Result := StrToInt(GridPost.Cells[3, GridPost.Row]);
    end;
  end else

  if wPage.ActivePage = SheetContact then
  begin
    if GridMail.Row >=0 then
    begin
      Result := StrToInt(GridMail.Cells[3, GridMail.Row]);
    end;
  end;
end;

procedure TfFormOrganization.GridPostDblClick(Sender: TObject);
begin
  inherited;
  UniMainModule.ShowMsg('done');
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
    end;
  end;

  N4.Click();
  RefreshGrid();
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
    gMG.FDBManager.DBExecute(nList);
    //save to db
  finally
    gMG.FObjectPool.Release(nList);
  end;

  ModalResult := mrOk;
end;

initialization
  TWebSystem.AddForm(TfFormOrganization);
end.
