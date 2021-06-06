{*******************************************************************************
  作者: dmzn@163.com 2021-06-04
  描述: 动态密码
*******************************************************************************}
unit UFormDynPwd;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, UFormNormal, UFormBase,
  uniRadioGroup, uniPanel, System.Classes, Vcl.Controls, Vcl.Forms,
  uniGUIBaseClasses, uniButton, uniBitBtn, UniFSButton, uniGUIClasses, uniEdit,
  uniCheckBox, uniLabel, uniImage;

type
  TfFormDynPwd = class(TfFormNormal)
    EditCode: TUniEdit;
    UniLabel1: TUniLabel;
    UniLabel2: TUniLabel;
    UniLabel3: TUniLabel;
    ImageCode: TUniImage;
    UniLabel4: TUniLabel;
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function DescMe: TfFormDesc; override;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
  end;

implementation

{$R *.dfm}

uses
  UManagerGroup, UDBFun, ULibFun, MainModule, USysBusiness;

class function TfFormDynPwd.DescMe: TfFormDesc;
begin
  Result := inherited DescMe();
  Result.FDesc := '设置用户动态口令';
end;

function TfFormDynPwd.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
begin
  Result := inherited OnVerifyCtrl(Sender, nHint);

end;

procedure TfFormDynPwd.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  if not IsDataValid then Exit;
  //invalid

  ModalResult := mrOk;
  UniMainModule.ShowMsg('密码修改成功');
end;

initialization
  TWebSystem.AddForm(TfFormDynPwd);
end.
