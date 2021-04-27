{*******************************************************************************
  ����: dmzn@163.com 2018-04-20
  ����: ��¼
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
    FSConfirm1: TUniFSConfirm;
    FSToast1: TUniFSToast;
    MenuBase64: TUniMenuItem;
    MenuDES: TUniMenuItem;
    N2: TUniMenuItem;
    procedure UniLoginFormCreate(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function fFormLogin: TfFormLogin;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, ULibFun, Data.DB, USysDB, USysConst;

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

//Desc: ��¼
procedure TfFormLogin.BtnOKClick(Sender: TObject);
var nStr: string;
    nQuery: TDataSet;
begin
  EditUser.Text := Trim(EditUser.Text);
  if EditUser.Text = '' then
  begin
    ShowMessage('�������û���');
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
      ShowMessage('������û���������,����������');
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
