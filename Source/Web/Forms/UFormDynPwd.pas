{*******************************************************************************
  作者: dmzn@163.com 2021-06-04
  描述: 动态密码
*******************************************************************************}
unit UFormDynPwd;

interface

uses
  Vcl.Graphics, System.SysUtils, UFormNormal, UFormBase, uniImage, uniLabel,
  uniGUIClasses, uniEdit, uniPanel, System.Classes, Vcl.Controls, Vcl.Forms,
  uniGUIBaseClasses, uniButton, uniBitBtn, UniFSButton, uniCheckBox;

type
  TfFormDynPwd = class(TfFormNormal)
    EditCode: TUniEdit;
    UniLabel1: TUniLabel;
    UniLabel2: TUniLabel;
    UniLabel3: TUniLabel;
    ImageCode: TUniImage;
    UniLabel4: TUniLabel;
    CheckClose: TUniCheckBox;
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FSecretKey: string;
    {*动态密钥*}
  public
    { Public declarations }
    class function DescMe: TfFormDesc; override;
    procedure OnCreateForm(Sender: TObject); override;
    procedure OnDestroyForm(Sender: TObject); override;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
  end;

implementation

{$R *.dfm}

uses
  DelphiZXIngQRCode, UGoogleOTP, UManagerGroup, UDBManager, UDBFun, ULibFun,
  MainModule, USysBusiness, USysConst;

class function TfFormDynPwd.DescMe: TfFormDesc;
begin
  Result := inherited DescMe();
  Result.FDesc := '设置用户动态口令';
end;

procedure TfFormDynPwd.OnCreateForm(Sender: TObject);
var nStr: string;
    nRow,nCol: Integer;
    nScale: Single;
    nBMP,nBigger: TBitmap;
    nCoder: TDelphiZXingQRCode;
begin
  inherited;
  CheckClose.Checked := False;
  CheckClose.Visible := UniMainModule.FUser.FDynamicPwd;

  nBMP := nil;
  nBigger := nil;
  nCoder := nil;
  try
    nCoder := TDelphiZXingQRCode.Create;
    with nCoder do
    begin
      nStr := Format('%s@%s', [UniMainModule.FUser.FUserName,
        gSystem.FMain.FActive.FTitleApp]);
      FSecretKey := TGoogleOTP.MakeSecret(6);
      //key

      Data := TGoogleOTP.MakeURI(nStr, FSecretKey);
      Encoding := qrUTF8BOM;
      QuietZone := 4; //QR四周的空白区域,宽度至少为4个module
    end;

    nBMP := TBitmap.Create;
    with nBMP do
    begin
      SetSize(nCoder.Rows, nCoder.Columns);
      for nRow := 0 to nCoder.Rows-1 do
       for nCol := 0 to nCoder.Columns-1 do
        if nCoder.IsBlack[nRow, nCol] then
             Canvas.Pixels[nCol, nRow] := clBlack
        else Canvas.Pixels[nCol, nRow] := clWhite;
    end;

    if ImageCode.Width < ImageCode.Height then
         nScale := ImageCode.Width / nBMP.Width
    else nScale := ImageCode.Height / nBMP.Height;

    nBigger := TBitmap.Create;
    with nBigger do
    begin
      PixelFormat := pf1bit;
      Width := Trunc(nBMP.Width * nScale);
      Height := Trunc(nBMP.Height * nScale);
      Canvas.StretchDraw(Rect(0, 0, nBigger.Width, nBigger.Height), nBMP);
    end;

    nBigger.SaveToFile(TWebSystem.UserFile(ufOPTCode));
    ImageCode.Url := TWebSystem.UserFile(ufOPTCode, True, True);
  finally
    nBigger.Free;
    nBMP.Free;
    nCoder.Free;
  end;
end;

procedure TfFormDynPwd.OnDestroyForm(Sender: TObject);
var nStr: string;
begin
  nStr := TWebSystem.UserFile(ufOPTCode);
  if FileExists(nStr) then
    DeleteFile(nStr);
  inherited;
end;

function TfFormDynPwd.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
begin
  Result := inherited OnVerifyCtrl(Sender, nHint);
  if CheckClose.Checked then Exit;
  
  if Sender = EditCode then
  begin
    Result := TStringHelper.IsNumber(EditCode.Text, False) and
              TGoogleOTP.Validate(FSecretKey, StrToInt(EditCode.Text));
    nHint := '请填写 6 位动态密码';
  end;
end;

procedure TfFormDynPwd.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  if not IsDataValid then Exit;
  //invalid

  with TSQLBuilder, TApplicationHelper, TEncodeHelper, UniMainModule do
  begin
    nStr := MakeSQLByStr([
      SF_IF([SF('U_DynPwd', sFlag_No),
             SF('U_DynPwd', sFlag_Yes)], CheckClose.Checked),
      //yes or no

      SF_IF(['', SF('U_Encrypt',
        Encode_3DES(FSecretKey, sDefaultKey))], CheckClose.Checked)
      //key
      ], TDBCommand.sTable_Users, SF('R_ID', FUser.FRecordID, sfVal), False);
    gDBManager.DBExecute(nStr);

    FUser.FEncryptKey := FSecretKey;
    FUser.FDynamicPwd := not CheckClose.Checked;
  end;

  ModalResult := mrOk;
  with TStringHelper do
  UniMainModule.ShowMsg(StrIF(['动态密码已关闭', '动态密码已启用'], CheckClose.Checked));
end;

initialization
  TWebSystem.AddForm(TfFormDynPwd);
end.
