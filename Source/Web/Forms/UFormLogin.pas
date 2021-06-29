{*******************************************************************************
  ����: dmzn@163.com 2018-04-20
  ����: ��¼
*******************************************************************************}
unit UFormLogin;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uniGUITypes, uniGUIForm, UniFSConfirm, uniGUIBaseClasses, uniGUIClasses,
  UniFSToast, Vcl.Menus, uniMainMenu, UniFSButton, uniButton, uniBitBtn,
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
    MenuInitMenu: TUniMenuItem;
    FSToast1: TUniFSToast;
    MenuDES: TUniMenuItem;
    N2: TUniMenuItem;
    FSConfirm1: TUniFSConfirm;
    N3: TUniMenuItem;
    MenuSatus: TUniMenuItem;
    MenuLog: TUniMenuItem;
    MenuInitDD: TUniMenuItem;
    procedure UniLoginFormCreate(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure MenuDESClick(Sender: TObject);
    procedure MenuInitDBClick(Sender: TObject);
    procedure MenuInitMenuClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure MenuSatusClick(Sender: TObject);
    procedure MenuLogClick(Sender: TObject);
    procedure MenuInitDDClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function fFormLogin: TfFormLogin;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, ULibFun, UDBFun, USysBusiness, USysConst;

function fFormLogin: TfFormLogin;
begin
  Result := TfFormLogin(UniMainModule.GetFormInstance(TfFormLogin));
end;

procedure TfFormLogin.UniLoginFormCreate(Sender: TObject);
begin
  ImageKey.Url := gSystem.FImages.FImgKey.FFile;
  ImageLogo.Url := gSystem.FImages.FImgLogo.FFile;

  UniMainModule.FSToast1 := FSToast1;
  UniMainModule.FSConfirm1 := FSConfirm1;

  {$IFDEF Debug}
  EditUser.Text := 'admin';
  EditPwd.Text  := 'admin';
  {$ENDIF}
end;

//Desc: ���ݱ���
procedure TfFormLogin.MenuDESClick(Sender: TObject);
begin
  UniMainModule.VerifyAdministrator(
    procedure(const nType: TButtonClickType; const nText: string)
    begin
      if nType = ctYes then
        TWebSystem.ShowModalForm('TfFormEncrypt');
      //xxxxx
    end, Self);
end;

//Desc: ��ʼ�����ݿ�
procedure TfFormLogin.MenuInitDBClick(Sender: TObject);
begin
  UniMainModule.VerifyAdministrator(
    procedure(const nType: TButtonClickType; const nText: string)
    begin
      if nType = ctYes then
        TWebSystem.ShowModalForm('TfFormInitDB');
      //xxxxx
    end, Self);
end;

//Desc: ��ʼ�������ֵ�(DataDict)
procedure TfFormLogin.MenuInitDDClick(Sender: TObject);
begin
  UniMainModule.VerifyAdministrator(
    procedure(const nType: TButtonClickType; const nText: string)
    begin
      if nType = ctYes then
        TWebSystem.ShowModalForm('TfFormInitDataDict');
      //xxxxx
    end, Self);
end;

//Desc: ��ʼ��ϵͳ�˵�
procedure TfFormLogin.MenuInitMenuClick(Sender: TObject);
begin
  UniMainModule.VerifyAdministrator(
    procedure(const nType: TButtonClickType; const nText: string)
    begin
      if nType = ctYes then
        TWebSystem.ShowModalForm('TfFormInitMenus');
      //xxxxx
    end, Self);
end;

//Desc: �ڴ����
procedure TfFormLogin.MenuSatusClick(Sender: TObject);
begin
  UniMainModule.VerifyAdministrator(
    procedure(const nType: TButtonClickType; const nText: string)
    begin
      if nType = ctYes then
        TWebSystem.ShowModalForm('TfFormMemStatus');
      //xxxxx
    end, Self);
end;

//Desc: ʵʱ��־
procedure TfFormLogin.MenuLogClick(Sender: TObject);
begin
  UniMainModule.VerifyAdministrator(
    procedure(const nType: TButtonClickType; const nText: string)
    begin
      if nType = ctYes then
        TWebSystem.ShowModalForm('TfFormRunLog');
      //xxxxx
    end, Self);
end;

//Desc: �˳�
procedure TfFormLogin.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: ��¼
procedure TfFormLogin.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  with UniMainModule do
  begin
    EditUser.Text := Trim(EditUser.Text);
    if EditUser.Text = '' then
    begin
      ShowMsg('�������û���');
      Exit;
    end;

    nStr := TDBCommand.GetUser(EditUser.Text, FUser);
    if nStr <> '' then
    begin
      ShowMsg(nStr);
      Exit;
    end;

    if EditPwd.Text <> FUser.FPassword then
    begin
      ShowMsg('��¼�������');
      Exit;
    end;

    if FUser.FValidOn < Now() then
    begin
      ShowMsg('�ʻ��ѹ���,����ϵ����Ա');
      Exit;
    end;

    ModalResult := mrOk;
  end;
end;

initialization
  RegisterAppFormClass(TfFormLogin);
end.
