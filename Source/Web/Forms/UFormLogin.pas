{*******************************************************************************
  作者: dmzn@163.com 2018-04-20
  描述: 登录
*******************************************************************************}
unit UFormLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uniGUITypes, uniGUIForm, UniFSToast, uniGUIBaseClasses, uniGUIClasses,
  UniFSConfirm, Vcl.Menus, uniMainMenu, UniFSButton, uniButton, uniBitBtn,
  uniMenuButton, UniFSMenuButton, uniEdit, uniLabel, uniPanel, uniImage;

type
  TfFormLogin = class(TUniLoginForm)
    ImageLogo: TUniImage;
    UniSimplePanel1: TUniSimplePanel;
    UniLabel1: TUniLabel;
    EditUser: TUniEdit;
    UniLabel2: TUniLabel;
    EditPwd: TUniEdit;
    ImageKey: TUniImage;
    BtnOK: TUniFSMenuButton;
    PMenu1: TUniPopupMenu;
    BtnExit: TUniFSButton;
    N1: TUniMenuItem;
    MenuInitDB: TUniMenuItem;
    MenuInitUserPwd: TUniMenuItem;
    FSToast1: TUniFSToast;
    MenuDES: TUniMenuItem;
    N2: TUniMenuItem;
    FSConfirm1: TUniFSConfirm;
    procedure UniLoginFormCreate(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure MenuDESClick(Sender: TObject);
    procedure MenuInitDBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function fFormLogin: TfFormLogin;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, ULibFun, Data.DB, USysDB, USysBusiness, USysConst;

function fFormLogin: TfFormLogin;
begin
  Result := TfFormLogin(UniMainModule.GetFormInstance(TfFormLogin));
end;

procedure TfFormLogin.UniLoginFormCreate(Sender: TObject);
begin
  ImageKey.Url := gSystem.FImages.FImgKey;
  ImageLogo.Url := gSystem.FImages.FImgLogo;

  UniMainModule.FSToast1 := FSToast1;
  UniMainModule.FSConfirm1 := FSConfirm1;
end;

//Desc: 数据编码
procedure TfFormLogin.MenuDESClick(Sender: TObject);
begin
  UniMainModule.VerifyAdministrator(
    procedure(const nType: TButtonClickType; const nText: string)
    begin
      if nType = ctYes then
        TSysFun.ShowModalForm('TfFormEncrypt');
      //xxxxx
    end, Self);
end;

//Desc: 初始化数据库
procedure TfFormLogin.MenuInitDBClick(Sender: TObject);
begin
  UniMainModule.VerifyAdministrator(
    procedure(const nType: TButtonClickType; const nText: string)
    begin
      if nType = ctYes then
        TSysFun.ShowModalForm('TfFormInitDB');
      //xxxxx
    end, Self);
end;

//Desc: 登录
procedure TfFormLogin.BtnOKClick(Sender: TObject);
var nStr: string;
    nQuery: TDataSet;
begin
  EditUser.Text := Trim(EditUser.Text);
  if EditUser.Text = '' then
  begin
    ShowMessage('请输入用户名');
    Exit;
  end;


  ModalResult := mrOk;
{
  nQuery := nil;
  with ULibFun.TStringHelper do
  try
    nStr := 'Select U_NAME,U_PASSWORD,U_GROUP,U_Identity from $a ' +
            'Where U_NAME=''$b'' and U_State=1';

    nStr := MacroValue(nStr, [MI('$a',sTable_User),
                              MI('$b',EditUser.Text)]);
    //xxxxx

    nQuery := LockDBQuery(ctMain);
    DBQuery(nStr, nQuery);

    if (nQuery.RecordCount <> 1) or
       (nQuery.FieldByName('U_PASSWORD').AsString <> EditPwd.Text) then
    begin
      ShowMessage('错误的用户名或密码,请重新输入');
      Exit;
    end;

    with UniMainModule.FUserConfig do
    begin
      FUserID := EditUser.Text;
      FUserName := nQuery.FieldByName('U_NAME').AsString;
      FUserPwd := EditPwd.Text;
      FGroupID := nQuery.FieldByName('U_GROUP').AsString;
      FIsAdmin := nQuery.FieldByName('U_Identity').AsString = '0';
    end;

    //--------------------------------------------------------------------------
    nStr := 'Select D_Value,D_Memo From %s Where D_Name=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam]);

    with DBQuery(nStr, nQuery),UniMainModule.FUserConfig do
    if RecordCount > 0 then
    begin
      First;
      while not Eof do
      begin
        nStr := Fields[1].AsString;
        if nStr = sFlag_WXServiceMIT then
          FWechatURL := Fields[0].AsString;
        //xxxxx
        Next;
      end;
    end;

    //--------------------------------------------------------------------------
    

    ModalResult := mrOk;
  finally
    ReleaseDBQuery(nQuery);
  end; }
end;

initialization
  RegisterAppFormClass(TfFormLogin);
end.
