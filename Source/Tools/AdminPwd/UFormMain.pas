{*******************************************************************************
  ����: dmzn@163.com 2020-10-26
  ����: ����Google Authenticator�Ķ�̬����������
*******************************************************************************}
unit UFormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, Vcl.Forms, UStyleModule,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinsDefaultPainters, cxContainer, cxEdit, dxLayoutcxEditAdapters,
  dxLayoutControlAdapters, Vcl.Menus, dxLayoutContainer, Vcl.StdCtrls,
  cxButtons, cxButtonEdit, cxMaskEdit, cxDropDownEdit, cxTextEdit, dxBarCode,
  cxMemo, cxClasses, dxLayoutControl, Vcl.Controls, dxStatusBar, System.Classes,
  Vcl.ExtCtrls;

type
  TfFormMain = class(TForm)
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
    //������������
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UManagerGroup, UGoogleOTP;

type
  TSystemKey = record
    FID   : string;   //��ʶ
    FName : string;   //����
    FKey  : string;   //��Կ
  end;

var
  gSystemKeys: array of TSystemKey;

procedure TfFormMain.FormCreate(Sender: TObject);
var nStr: string;
begin
  SetLength(gSystemKeys, 0);
  EditSys.Properties.Items.Clear;

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
//Desc: ������������
function TfFormMain.LoadConfigData: Boolean;
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
      EditReadMe.Text := Format('���� %s ������', [gFormConfig]);
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
        EditReadMe.Text := Format('���� %s ����', [gFormConfig]);
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

procedure TfFormMain.Timer1Timer(Sender: TObject);
begin
  SBar1.Panels[0].Text := '��.ʱ��: ' + TDateTimeHelper.DateTime2Str(Now());
end;

procedure TfFormMain.EditKeyPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  with TStringHelper,TGoogleOTP do
  begin
    if IsNumber(EditLen.Text, False) then
         EditKey.Text := MakeSecret(StrToInt(EditLen.Text), False)
    else EditKey.Text := MakeSecret(OTPLength, False);
  end;
end;

procedure TfFormMain.EditSysPropertiesChange(Sender: TObject);
var nIdx: Integer;
begin
  if EditSys.ItemIndex > -1 then
  begin
    nIdx := Integer(EditSys.Properties.Items.Objects[EditSys.ItemIndex]);
    EditKey.Text := gSystemKeys[nIdx].FKey;
  end;
end;

procedure TfFormMain.BtnOKClick(Sender: TObject);
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
