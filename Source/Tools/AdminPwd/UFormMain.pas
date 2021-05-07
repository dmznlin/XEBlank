{*******************************************************************************
  ����: dmzn@163.com 2020-10-26
  ����: ����Google Authenticator�Ķ�̬����������
*******************************************************************************}
unit UFormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, Vcl.Forms, UStyleModule,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinsDefaultPainters, cxContainer, cxEdit, Vcl.Menus, cxDropDownEdit,
  cxMaskEdit, cxButtonEdit, cxTextEdit, Vcl.StdCtrls, cxButtons, cxLabel,
  cxMemo, dxBarCode, cxGroupBox, Vcl.ExtCtrls, System.Classes, Vcl.Controls,
  dxStatusBar;

type
  TfFormAdminPwd = class(TForm)
    Timer1: TTimer;
    SBar1: TdxStatusBar;
    Group1: TcxGroupBox;
    Group2: TcxGroupBox;
    Group3: TcxGroupBox;
    BarCode1: TdxBarCode;
    EditReadMe: TcxMemo;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    BtnOK: TcxButton;
    EditUser: TcxTextEdit;
    EditLen: TcxTextEdit;
    EditKey: TcxButtonEdit;
    EditSys: TcxComboBox;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditKeyPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnOKClick(Sender: TObject);
    procedure EditSysPropertiesChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
  private
    { Private declarations }
    function LoadConfigData(): Boolean;
    //������������
    procedure LoadSystemIDList;
    //����ϵͳ��ʶ
    function GetSystemID(const nMakeNew: Boolean): string;
    //��ȡϵͳ��ʶ
    procedure SetDisplayKey(nShowKey: Boolean);
    //����������Կ
  public
    { Public declarations }
  end;

var
  fFormAdminPwd: TfFormAdminPwd;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UManagerGroup, UGoogleOTP;

const
  sSysPrefix  = '_';                  //ϵͳ��ʶǰ׺
  sConfigFile = 'AdminPwd.ini';       //�������ļ�

type
  TSystemKey = record
    FID   : string;   //��ʶ
    FName : string;   //����
    FKey  : string;   //��Կ
    FValid: Boolean;  //��Ч
  end;

var
  gAppSeed: string;
  //ϵͳ��������
  gSystemKeys: array of TSystemKey;
  //��Կ�б�

procedure TfFormAdminPwd.FormCreate(Sender: TObject);
var nStr: string;
begin
  SetLength(gSystemKeys, 0);
  SetDisplayKey(False);
  EditSys.Properties.Items.Clear;

  Timer1Timer(nil);
  FSM.SwitchSkinRandom;
  TApplicationHelper.LoadFormConfig(Self);

  with TApplicationHelper do
  begin
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

procedure TfFormAdminPwd.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TApplicationHelper.SaveFormConfig(Self);
end;

//Date: 2020-10-26
//Desc: ������������
function TfFormAdminPwd.LoadConfigData: Boolean;
var nStr: string;
    nIdx: Integer;
    nIni: TIniFile;
    nList: TStrings;
begin
  Result := False;
  with TApplicationHelper do
  begin
    if not FileExists(gPath + sConfigFile) then
    begin
      EditReadMe.Text := Format('���� %s ������', [sConfigFile]);
      Exit;
    end;

    nList := nil;
    nIni := TIniFile.Create(gPath + sConfigFile);
    try
      nStr := nIni.ReadString('Config', 'RunOn', '');
      if nStr = '' then
        nIni.WriteString('Config', 'RunOn', GetCPUIDStr());
      //init work pc id

      gAppSeed := nIni.ReadString('Config', 'ProgID', TGoogleOTP.MakeSecret());
      if not IsValidConfigFile(gPath + sConfigFile, gAppSeed) then
      begin
        EditReadMe.Text := Format('���� %s ����', [sConfigFile]);
        Exit;
      end;

      nStr := nIni.ReadString('Config', 'RunOn', '');
      if nStr <> GetCPUIDStr() then
      begin
        EditReadMe.Text := '��ֹ�ڸü���������д˳���';
        Exit;
      end;

      nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
      nIni.ReadSection('SystemName', nList);
      SetLength(gSystemKeys, nList.Count);

      for nIdx := 0 to nList.Count - 1 do
      with gSystemKeys[nIdx] do
      begin
        FValid := True;
        FID := nList[nIdx];

        FName := nIni.ReadString('SystemName', FID, 'noname');
        FKey := nIni.ReadString('SystemKey', FID, '');
        FKey := TEncodeHelper.Decode_3DES(FKey, TApplicationHelper.sDefaultAdminKey);
      end;

      LoadSystemIDList();
      //load list
      Result := True;
    finally
      gMG.FObjectPool.Release(nList);
      nIni.Free;
    end;
  end;
end;

procedure TfFormAdminPwd.Timer1Timer(Sender: TObject);
begin
  SBar1.Panels[0].Text := '��.ʱ��: ' + TDateTimeHelper.DateTime2Str(Now());
end;

//------------------------------------------------------------------------------
//Date: 2021-04-07
//Parm: ��ʾ��Կ
//Desc: ��ʾ��������Կ
procedure TfFormAdminPwd.SetDisplayKey(nShowKey: Boolean);
begin
  with EditKey.Properties do
  begin
    if nShowKey then
      nShowKey := TStringHelper.CopyLeft(GetSystemID(False), 1) <> sSysPrefix;
    //����ʾ�»���ǰ׺����Կ

    if (nShowKey and (EchoMode = eemNormal)) or
       ((not nShowKey) and (EchoMode = eemPassword)) then Exit;
    //has done

    if nShowKey then
    begin
      PasswordChar := #0;
      EchoMode := eemNormal;
      Buttons[1].ImageIndex := 46;
      Buttons[1].Hint := '���������Կ';
    end else
    begin
      PasswordChar := '*';
      EchoMode := eemPassword;
      Buttons[1].ImageIndex := 47;
      Buttons[1].Hint := '�����ʾ��Կ';
    end;
  end;
end;

//Desc: ˢ��ϵͳ��ʶ�б�
procedure TfFormAdminPwd.LoadSystemIDList;
var nStr: string;
    nIdx: Integer;
begin
  with EditSys.Properties do
  try
    nStr := GetSystemID(False);
    Items.BeginUpdate;
    Items.Clear;

    for nIdx := Low(gSystemKeys) to High(gSystemKeys) do
    with gSystemKeys[nIdx] do
    begin
      if not FValid then Continue;
      Items.AddObject(FName, Pointer(nIdx));

      if (nStr <> '') and (nStr = FID)  then
        EditSys.ItemIndex := Items.Count - 1;
      //xxxxx
    end;
  finally
    Items.EndUpdate;
  end;
end;

//Date: 2021-04-07
//Parm: �Ƿ񴴽�
//Desc: ��ȡ��ǰѡ�е�ϵͳ��ʶ
function TfFormAdminPwd.GetSystemID(const nMakeNew: Boolean): string;
var nIdx: Integer;
begin
  if EditSys.ItemIndex > -1 then
  begin
    nIdx := Integer(EditSys.Properties.Items.Objects[EditSys.ItemIndex]);
    Result := gSystemKeys[nIdx].FID;
  end else
  begin
    if nMakeNew then
         Result := TDateTimeHelper.DateTimeSerial()
    else Result := '';
  end;
end;

//Desc: ������Կ
procedure TfFormAdminPwd.N1Click(Sender: TObject);
var nStr,nPwd: string;
    nIdx: Integer;
    nIni: TIniFile;
begin
  if not FSM.VerifyUIData(Group2,
    procedure (const nCtrl: TControl; var nResult: Boolean; var nHint: string)
    begin
      if nCtrl = EditSys then
      begin
        EditSys.Text := Trim(EditSys.Text);
        nResult := EditSys.Text <> '';
        nHint := '����дϵͳ��ʶ����';
      end else

      if nCtrl = EditKey then
      begin
        nResult := EditKey.Text <> '';
        nHint := '����д������Կ';
      end;
    end
  ) then Exit;

  nStr := GetSystemID(True);
  if TStringHelper.CopyLeft(nStr, 1) = sSysPrefix then
  begin
    FSM.ShowMsg('Ĭ�ϱ�ʶ�޷�����');
    Exit;
  end;

  nIni := TIniFile.Create(TApplicationHelper.gPath + sConfigFile);
  try
    nIni.WriteString('SystemName', nStr, EditSys.Text);
    nPwd := TEncodeHelper.Encode_3DES(EditKey.Text, TApplicationHelper.sDefaultAdminKey);
    nIni.WriteString('SystemKey', nStr, nPwd);

    if EditSys.ItemIndex < 0 then
    begin
      nIdx := Length(gSystemKeys);
      SetLength(gSystemKeys, nIdx + 1);
    end else
    begin
      nIdx := Integer(EditSys.Properties.Items.Objects[EditSys.ItemIndex]);
      //exist item
    end;

    with gSystemKeys[nIdx] do
    begin
      FID   := nStr;
      FName := EditSys.Text;
      FKey  := Editkey.Text;
      FValid:= True;
    end;

    LoadSystemIDList();
  finally
    nIni.Free;
  end;

  with TApplicationHelper do
    AddVerifyData(gPath + sConfigFile, gAppSeed);
  FSM.ShowMsg('����ɹ�');
end;

//Desc: ɾ����Կ
procedure TfFormAdminPwd.N3Click(Sender: TObject);
var nStr: string;
    nIdx: Integer;
    nIni: TIniFile;
begin
  nStr := GetSystemID(False);
  if nStr = '' then
  begin
    EditSys.Text := '';
    Exit;
  end;

  if TStringHelper.CopyLeft(nStr, 1) = sSysPrefix then
  begin
    FSM.ShowMsg('Ĭ�ϱ�ʶ�޷�ɾ��');
    Exit;
  end;

  nIni := TIniFile.Create(TApplicationHelper.gPath + sConfigFile);
  try
    nIni.DeleteKey('SystemName', nStr);
    nIni.DeleteKey('SystemKey', nStr);
    //save file

    nIdx := Integer(EditSys.Properties.Items.Objects[EditSys.ItemIndex]);
    gSystemKeys[nIdx].FValid := False;
    LoadSystemIDList();
  finally
    nIni.Free;
  end;

  with TApplicationHelper do
    AddVerifyData(gPath + sConfigFile, gAppSeed);
  FSM.ShowMsg('ɾ���ɹ�');
end;

procedure TfFormAdminPwd.EditKeyPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if AButtonIndex = 0 then
  begin
    with TStringHelper,TGoogleOTP do
    begin
      if IsNumber(EditLen.Text, False) then
           EditKey.Text := MakeSecret(StrToInt(EditLen.Text), False)
      else EditKey.Text := MakeSecret(OTPLength, False);
    end;
  end else

  if AButtonIndex = 1 then
  begin
    SetDisplayKey(EditKey.Properties.EchoMode = eemPassword);
    //show or hide key
  end;
end;

procedure TfFormAdminPwd.EditSysPropertiesChange(Sender: TObject);
var nIdx: Integer;
begin
  if EditSys.ItemIndex > -1 then
  begin
    nIdx := Integer(EditSys.Properties.Items.Objects[EditSys.ItemIndex]);
    EditKey.Text := gSystemKeys[nIdx].FKey;
    SetDisplayKey(EditKey.Properties.EchoMode = eemNormal);
  end else
  begin
    EditKey.Text := '';
  end;
end;

procedure TfFormAdminPwd.BtnOKClick(Sender: TObject);
var nAccount,nSecret: string;
begin
  EditKey.Text := Trim(EditKey.Text);
  if EditKey.Text = '' then
  begin
    ActiveControl := EditKey;
    FSM.ShowMsg('����д��Ч����Կ');
    Exit;
  end;

  with TGoogleOTP do
  begin
    nAccount := Format('%s(%s)', [EditSys.Text, EditUser.Text]);
    nSecret := EncodeBase32(EditKey.Text);
    BarCode1.Text := MakeURI(nAccount, nSecret);

    SBar1.Panels[1].Text := '����: ' + CalAsString(nSecret);
    //for verify
  end;
end;

end.
