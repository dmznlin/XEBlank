{*******************************************************************************
  作者: dmzn@163.com 2021-05-27
  描述: 编辑系统菜单项
*******************************************************************************}
unit UFormEditSysMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, UFormNormal, UFormBase,
  MainModule, UMenuManager, uniMultiItem, uniComboBox, uniGUIClasses, uniEdit,
  uniPanel, System.Classes, Vcl.Controls, Vcl.Forms, uniGUIBaseClasses,
  uniButton, uniBitBtn, UniFSButton, UniFSCombobox, uniCheckBox, uniGroupBox,
  uniLabel;

type
  TfFormEditSysMenu = class(TfFormNormal)
    EditTitle: TUniEdit;
    EditImg: TUniComboBox;
    EditAction: TUniComboBox;
    EditData: TUniComboBox;
    UniGroupBox1: TUniGroupBox;
    CheckExpand: TUniCheckBox;
    CheckDesktop: TUniCheckBox;
    CheckWeb: TUniCheckBox;
    CheckMobile: TUniCheckBox;
    UniLabel1: TUniLabel;
    procedure EditActionChange(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FMenuItem: PMenuItem;
    {*菜单数据*}
    procedure ApplyData(const nMenu: PMenuItem);
    {*设置生效*}
  public
    { Public declarations }
    class function DescMe: TfFormDesc; override;
    procedure OnCreateForm(Sender: TObject); override;
    function SetData(const nData: PFormCommandParam): Boolean; override;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
  end;

implementation

{$R *.dfm}

uses
  uniGUIVars, UManagerGroup, ULibFun, USysMenu, USysBusiness, USysConst;

class function TfFormEditSysMenu.DescMe: TfFormDesc;
begin
  Result := inherited DescMe();
  Result.FVerifyAdmin := True;
  Result.FDesc := '编辑系统菜单项';
end;

procedure TfFormEditSysMenu.OnCreateForm(Sender: TObject);
begin
  inherited;
  FMenuItem := nil;
end;

function TfFormEditSysMenu.SetData(const nData: PFormCommandParam): Boolean;
var nIdx: Integer;
begin
  Result := inherited SetData(nData);
  FMenuItem := nData.FParamP;

  EditTitle.Text := FMenuItem.FTitle;
  EditData.Text := FMenuItem.FActionData;

  TStringHelper.FillList(EditAction.Items, sMenuAction);
  EditAction.ItemIndex := Ord(FMenuItem.FAction);
  EditActionChange(nil);

  CheckExpand.Checked := FMenuItem.FExpaned;
  CheckDesktop.Checked := Desktop in FMenuItem.FDeploy;
  CheckWeb.Checked := Web in FMenuItem.FDeploy;
  CheckMobile.Checked := Mobile in FMenuItem.FDeploy;

  with EditImg,UniMainModule do
  try
    Items.BeginUpdate;
    Items.Clear;

    IconItems.Clear;
    EditImg.Images := SmallImages;

    for nIdx := 0 to SmallImages.Count-1 do
    begin
      with IconItems.Add do
      begin
        Caption := IntToStr(nIdx);
        ImageIndex := nIdx;
      end;

      Items.Add(IntToStr(nIdx));
      if FMenuItem.FImgIndex = nIdx then
        EditImg.ItemIndex := nIdx;
      //xxxxx
    end;
  finally
    Items.EndUpdate;
  end;
end;

//Desc: 切换动作数据
procedure TfFormEditSysMenu.EditActionChange(Sender: TObject);
var nIdx: Integer;
begin
  if EditAction.ItemIndex = Ord(maNewForm) then
  begin
    with EditData.Items,TWebSystem,TStringHelper do
    try
      BeginUpdate;
      Clear;

      for nIdx := Low(Forms) to High(Forms) do
      with Forms[nIdx].DescMe do
      begin
        AddObject(Format('%2d.%s', [nIdx+1, FDesc]), Pointer(nIdx));
        if Assigned(FMenuItem) and (FMenuItem.FActionData = FName) then
          EditData.ItemIndex := nIdx;
        //xxxxx
      end;
    finally
      EndUpdate;
    end;
  end;
end;

//Date: 2021-06-01
//Parm: 验证数据
//Desc: 验证界面是否有效
function TfFormEditSysMenu.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
begin
  Result := inherited OnVerifyCtrl(Sender, nHint);
  if Sender = EditTitle then
  begin
    EditTitle.Text := Trim(EditTitle.Text);
    Result := EditTitle.Text <> '';
    nHint := '请填写菜单标题';
  end else

  if Sender = EditAction then
  begin
    Result := EditAction.ItemIndex >= 0;
    nHint := '请选择菜单动作';
  end;
end;

//Date: 2021-06-01
//Parm: 菜单项
//Desc: 将界面设置应用到nMenu
procedure TfFormEditSysMenu.ApplyData(const nMenu: PMenuItem);
var nIdx: Integer;
begin
  nMenu.FTitle := EditTitle.Text;
  nMenu.FImgIndex := EditImg.ItemIndex;
  nMenu.FAction := TMenuAction(EditAction.ItemIndex);

  if (nMenu.FAction = maNewForm) and (EditData.ItemIndex >= 0) then
  begin
    nIdx := Integer(EditData.Items.Objects[EditData.ItemIndex]);
    nMenu.FActionData := TWebSystem.Forms[nIdx].DescMe.FName;
  end else nMenu.FActionData := EditData.Text;

  nMenu.FExpaned := CheckExpand.Checked;
  nMenu.FDeploy := [];
  if CheckDesktop.Checked then Include(nMenu.FDeploy, Desktop);
  if CheckWeb.Checked then Include(nMenu.FDeploy, Web);
  if CheckMobile.Checked then Include(nMenu.FDeploy, Mobile);
end;

//Desc: 保存
procedure TfFormEditSysMenu.BtnOKClick(Sender: TObject);
var nMenu: TMenuItem;
begin
  if not IsDataValid then Exit;
  //invalid

  if Assigned(FMenuItem) and (
    (FMenuItem.FUserID <> '') or UniMainModule.FUser.FIsAdmin) then
  begin
    ApplyData(FMenuItem);
    gMenuManager.AddMenu(FMenuItem);
    //自定义或系统菜单,直接保存

    ModalResult := mrOk;
    UniMainModule.ShowMsg('菜单保存成功');
    Exit;
  end;

  if Assigned(FMenuItem) and (FMenuItem.FUserID = '') then
  begin
    nMenu := FMenuItem^;
    ApplyData(@nMenu);

    with nMenu do
    begin
      FRecordID  := '';
      FPMenu     := '';
      FNewOrder  := -1;

      FEntity    := sEntity_User;
      FLang      := UniMainModule.FUser.FLangID;
      FUserID    := UniMainModule.FUser.FUserID;
    end;

    gMenuManager.AddMenu(@nMenu);
    //系统菜单转自定义
  end else
  begin
    ApplyData(@nMenu);
    //new menu

    with nMenu do
    begin
      FRecordID  := '';
      FPMenu     := '';
      FNewOrder  := -1;

      FProgID    := gSystem.FMain.FActive.FProgram;
      FEntity    := sEntity_User;
      FLang      := UniMainModule.FUser.FLangID;
      FUserID    := UniMainModule.FUser.FUserID;
    end;

    gMenuManager.AddMenu(@nMenu);
    //新添加菜单项
  end;

  ModalResult := mrOk;
  UniMainModule.ShowMsg('菜单保存成功,重启后生效');
end;

initialization
  TWebSystem.AddForm(TfFormEditSysMenu);
end.
