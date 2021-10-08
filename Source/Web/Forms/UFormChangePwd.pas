{*******************************************************************************
  作者: dmzn@163.com 2021-06-04
  描述: 修改密码
*******************************************************************************}
unit UFormChangePwd;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, UFormNormal, UFormBase,
  uniRadioGroup, uniPanel, System.Classes, Vcl.Controls, Vcl.Forms,
  uniGUIBaseClasses, uniButton, uniBitBtn, UniFSButton, uniGUIClasses, uniEdit,
  uniCheckBox;

type
  TfFormChangePwd = class(TfFormNormal)
    EditTwice: TUniEdit;
    EditNew: TUniEdit;
    EditPwd: TUniEdit;
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function ConfigMe: TfFormConfig; override;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
  end;

implementation

{$R *.dfm}

uses
  UManagerGroup, UDBFun, ULibFun, MainModule, USysBusiness;

class function TfFormChangePwd.ConfigMe: TfFormConfig;
begin
  Result := inherited ConfigMe();
  Result.FDesc := '修改用户登录密码';
end;

function TfFormChangePwd.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
begin
  Result := inherited OnVerifyCtrl(Sender, nHint);
  if Sender = EditPwd then
  begin
    Result := EditPwd.Text = UniMainModule.FUser.FPassword;
    nHint := '请输入正确的旧密码';
  end else

  if Sender = EditNew then
  begin
    Result := Length(EditNew.Text) > 0;
    nHint := '请输入新密码';
  end else

  if Sender = EditTwice then
  begin
    Result := EditTwice.Text = EditNew.Text;
    nHint := '两次输入的新密码不一致';
  end;
end;

procedure TfFormChangePwd.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  if not IsDataValid then Exit;
  //invalid

  nStr := 'Update %s Set U_Password=''%s'' Where R_ID=%s';
  nStr := Format(nStr, [TDBCommand.sTable_Users,
    TEncodeHelper.Encode_3DES(EditNew.Text, TApplicationHelper.sDefaultKey),
    UniMainModule.FUser.FRecordID]);
  gMG.FDBManager.DBExecute(nStr);

  UniMainModule.FUser.FPassword := EditNew.Text;
  ModalResult := mrOk;
  UniMainModule.ShowMsg('密码修改成功');
end;

initialization
  TWebSystem.AddForm(TfFormChangePwd);
end.
