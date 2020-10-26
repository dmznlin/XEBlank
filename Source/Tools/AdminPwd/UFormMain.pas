unit UFormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, Vcl.Forms, UStyleModule,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinsDefaultPainters, cxClasses, dxLayoutContainer, dxLayoutControl,
  Vcl.Controls, dxStatusBar, System.Classes, Vcl.ExtCtrls, cxContainer, cxEdit,
  dxLayoutcxEditAdapters, cxLabel, dxBarCode, cxTextEdit, cxMemo, cxGroupBox,
  cxButtonEdit, cxMaskEdit, cxDropDownEdit, dxLayoutControlAdapters, Vcl.Menus,
  Vcl.StdCtrls, cxButtons;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    SBar1: TdxStatusBar;
    Layout1: TdxLayoutControl;
    Layout1Group_Root: TdxLayoutGroup;
    dxLayoutItem1: TdxLayoutItem;
    EditReadMe: TcxMemo;
    dxLayoutItem3: TdxLayoutItem;
    BarCode1: TdxBarCode;
    dxLayoutGroup1: TdxLayoutGroup;
    EditUser: TcxTextEdit;
    dxLayoutItem2: TdxLayoutItem;
    EditLen: TcxTextEdit;
    dxLayoutItem4: TdxLayoutItem;
    EditSys: TcxComboBox;
    dxLayoutItem6: TdxLayoutItem;
    EditKey: TcxButtonEdit;
    dxLayoutItem7: TdxLayoutItem;
    dxLayoutGroup2: TdxLayoutGroup;
    BtnOK: TcxButton;
    dxLayoutItem5: TdxLayoutItem;
    dxLayoutGroup3: TdxLayoutGroup;
    dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup;
    dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup;
    dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditKeyPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnOKClick(Sender: TObject);
    procedure EditSysPropertiesChange(Sender: TObject);
  private
    { Private declarations }
    function LoadConfigData(): Boolean;
    //载入配置数据
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UManagerGroup, UGoogleOTP;

type
  TSystemKey = record
    FID   : string;   //标识
    FName : string;   //名称
    FKey  : string;   //密钥
  end;

var
  gSystemKeys: array of TSystemKey;

procedure TForm1.FormCreate(Sender: TObject);
var nStr: string;
begin
  SetLength(gSystemKeys, 0);
  EditSys.Properties.Items.Clear;

  TGoogleOTP.InitOPT;
  Timer1Timer(nil);
  FSM.SwitchSkinRandom;

  with TApplicationHelper do
  begin
    gPath := ExtractFilePath(Application.ExeName);
    gFormConfig := 'AdminPwd.ini';

    if not LoadConfigData() then
    begin
      BtnOK.Enabled := False;
      Exit;
    end;

    if EditSys.Properties.Items.Count > 0 then
      EditSys.ItemIndex := 0;
    //xxxxx

    nStr := gPath + 'AdminPwd.rdm';
    if FileExists(nStr) then
      EditReadMe.Lines.LoadFromFile(nStr);
    //xxxxx
  end;
end;

//Date: 2020-10-26
//Desc: 载入配置数据
function TForm1.LoadConfigData: Boolean;
var nStr: string;
    nIdx: Integer;
    nIni: TIniFile;
    nList: TStrings;
begin
  Result := False;
  with TApplicationHelper do
  begin
    if not FileExists(gPath + gFormConfig) then
    begin
      EditReadMe.Text := Format('配置 %s 不存在', [gFormConfig]);
      Exit;
    end;

    nList := nil;
    nIni := TIniFile.Create(gPath + gFormConfig);
    try
      nStr := nIni.ReadString('Config', 'RunOn', '');
      if nStr = '' then
        nIni.WriteString('Config', 'RunOn', GetCPUIDStr());
      //init work pc id

      nStr := nIni.ReadString('Config', 'ProgID', TGoogleOTP.MakeSecret());
      if not IsValidConfigFile(gPath + gFormConfig, nStr) then
      begin
        EditReadMe.Text := Format('配置 %s 已损坏', [gFormConfig]);
        Exit;
      end;

      nStr := nIni.ReadString('Config', 'RunOn', '');
      if nStr <> GetCPUIDStr() then
      begin
        EditReadMe.Text := '禁止在该计算机上运行此程序';
        Exit;
      end;

      nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
      nIni.ReadSection('SystemName', nList);
      SetLength(gSystemKeys, nList.Count);

      for nIdx := 0 to nList.Count - 1 do
      with gSystemKeys[nIdx] do
      begin
        FID := nList[nIdx];
        FName := nIni.ReadString('SystemName', FID, 'noname');
        FKey := nIni.ReadString('DefaultKey', FID, '');

        EditSys.Properties.Items.AddObject(FName, Pointer(nIdx));
        //xxxxx
      end;

      Result := True;
      //verify done
    finally
      gMG.FObjectPool.Release(nList);
      nIni.Free;
    end;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  SBar1.Panels[0].Text := '※.时钟: ' + TDateTimeHelper.DateTime2Str(Now());
end;

procedure TForm1.EditKeyPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  with TStringHelper,TGoogleOTP do
  begin
    if IsNumber(EditLen.Text, False) then
         EditKey.Text := MakeSecret(StrToInt(EditLen.Text), False)
    else EditKey.Text := MakeSecret(OTPLength, False);
  end;
end;

procedure TForm1.EditSysPropertiesChange(Sender: TObject);
var nIdx: Integer;
begin
  if EditSys.ItemIndex > -1 then
  begin
    nIdx := Integer(EditSys.Properties.Items.Objects[EditSys.ItemIndex]);
    EditKey.Text := gSystemKeys[nIdx].FKey;
  end;
end;

procedure TForm1.BtnOKClick(Sender: TObject);
var nAccount,nSecret: string;
begin
  EditKey.Text := Trim(EditKey.Text);
  if EditKey.Text = '' then
  begin
    ActiveControl := EditKey;
    FSM.ShowMsg('请填写有效的密钥');
    Exit;
  end;

  with TGoogleOTP do
  begin
    nAccount := Format('%s(%s)', [EditSys.Text, EditUser.Text]);
    nSecret := EncodeBase32(EditKey.Text);
    BarCode1.Text := MakeURI(nAccount, nSecret);

    SBar1.Panels[1].Text := '密码: ' + CalAsString(nSecret);
    //for verify
  end;
end;

end.
