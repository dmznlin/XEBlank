{*******************************************************************************
  ×÷Õß: dmzn@163.com 2021-04-28
  ÃèÊö: Êý¾Ý±àÂë
*******************************************************************************}
unit UFormEncrypt;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms,
  UFormBase, uniEdit, uniLabel, uniCheckBox, uniPanel, uniButton, uniGUIClasses,
  uniMemo, uniPageControl, uniGUIBaseClasses;

type
  TfFormEncrypt = class(TfFormBase)
    wPage1: TUniPageControl;
    Sheet1: TUniTabSheet;
    Sheet2: TUniTabSheet;
    BaseEncrypt: TUniMemo;
    BaseEncode: TUniButton;
    BaseDecode: TUniButton;
    BaseText: TUniMemo;
    UniPanel1: TUniPanel;
    CheckBase64: TUniCheckBox;
    UniPanel2: TUniPanel;
    CheckDes: TUniCheckBox;
    DesText: TUniMemo;
    DesEncrypt: TUniMemo;
    DesEncode: TUniButton;
    DesDecode: TUniButton;
    UniLabel1: TUniLabel;
    EditKey: TUniEdit;
    procedure UniFormCreate(Sender: TObject);
    procedure BaseEncodeClick(Sender: TObject);
    procedure DesEncodeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
 uniGUIVars, MainModule, ULibFun, UDBManager;

procedure TfFormEncrypt.UniFormCreate(Sender: TObject);
begin
  inherited;
  wPage1.ActivePageIndex := 0;
end;

//Desc: base64
procedure TfFormEncrypt.BaseEncodeClick(Sender: TObject);
begin
  with TEncodeHelper do
  begin
    if Sender = BaseEncode then
      BaseEncrypt.Text := EncodeBase64(Trim(BaseText.Text), CheckBase64.Checked);
    //xxxxxx

    if Sender = BaseDecode then
      BaseText.Text := DecodeBase64(Trim(BaseEncrypt.Text));
    //xxxxx
  end;
end;

//Desc: 3des
procedure TfFormEncrypt.DesEncodeClick(Sender: TObject);
var nKey: string;
begin
  with TEncodeHelper do
  begin
    if CheckDes.Checked then
         nKey := sDBEncryptKey
    else nKey := EditKey.Text;

    if nKey = '' then
    begin
      UniMainModule.ShowMsg('ÇëÌîÐ´ÃÜÔ¿', True);
      Exit;
    end;

    if Sender = DesEncode then
      DesEncrypt.Text := Encode_3DES(Trim(DesText.Text), nKey);
    //xxxxxx

    if Sender = DesDecode then
      DesText.Text := Decode_3DES(Trim(DesEncrypt.Text), nKey);
    //xxxxx
  end;
end;

initialization
  RegisterClass(TfFormEncrypt);
end.
