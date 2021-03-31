unit UFormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, Vcl.Forms, UStyleModule,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinsDefaultPainters, cxContainer, cxEdit, dxLayoutcxEditAdapters,
  dxLayoutContainer, dxLayoutControlAdapters, cxPC, Vcl.ExtCtrls, dxDockControl,
  dxDockPanel, Vcl.Controls, Vcl.StdCtrls, dximctrl, cxCheckBox, dxToggleSwitch,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, dxStatusBar, cxClasses,
  System.Classes, dxLayoutControl, cxGroupBox, dxSkinsForm, cxMemo, cxLabel,
  Vcl.Menus, dxBar, dxBarExtItems, cxSplitter, cxButtonEdit;

type
  TfFormDBConfig = class(TForm)
    SBar1: TdxStatusBar;
    Timer1: TTimer;
    Group1: TcxGroupBox;
    EditDefDB: TcxComboBox;
    EditDefFit: TcxComboBox;
    EditDrivers: TcxComboBox;
    EditReConn: TdxToggleSwitch;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    Group2: TcxGroupBox;
    BarMgr1: TdxBarManager;
    dxBar1: TdxBar;
    BtnNew: TdxBarButton;
    BtnOpen: TdxBarButton;
    BtnSaveFile: TdxBarButton;
    BarSub1: TdxBarSubItem;
    BarS1: TdxBarSeparator;
    BtnExit: TdxBarButton;
    BarS2: TdxBarSeparator;
    BarSub2: TdxBarSubItem;
    BtnTest: TdxBarButton;
    Panel1: TPanel;
    cxSplitter1: TcxSplitter;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    EditFit: TcxComboBox;
    EditID: TcxTextEdit;
    EditName: TcxTextEdit;
    EditConn: TcxMemo;
    BtnSaveCfg: TdxBarButton;
    BtnDelCfg: TdxBarButton;
    Panel2: TPanel;
    Panel3: TPanel;
    ListCfg: TdxImageListBox;
    EditFilter: TcxButtonEdit;
    cxLabel8: TcxLabel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BtnNewClick(Sender: TObject);
    procedure BtnOpenClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure ListCfgClick(Sender: TObject);
    procedure EditFilterPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditFilterPropertiesChange(Sender: TObject);
    procedure BtnSaveCfgClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnDelCfgClick(Sender: TObject);
    procedure BtnTestClick(Sender: TObject);
    procedure EditDefDBPropertiesEditValueChanged(Sender: TObject);
  private
    { Private declarations }
    procedure InitFormData(const nCheck: Boolean = True);
    //��ʼ������
    procedure OpenConfigFile(const nFile: string);
    //�������ļ�
    procedure LoadConfigList(nFilter: string = ''; nOnlyList: Boolean = True);
    //���������б�
    procedure ShowFileInBar(const nFileName: string);
    //��ʾ�ļ���
  public
    { Public declarations }
  end;

var
  fFormDBConfig: TfFormDBConfig;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UDBManager, UManagerGroup, Vcl.Dialogs, UWaitIndicator;

var
  gDBFile: string;
  //���ݿ������ļ�

//Date: 2021-03-30
//Parm: �Ƿ���֤����
//Desc: ��ʼ����������
procedure TfFormDBConfig.InitFormData(const nCheck: Boolean);
var nIdx: Integer;
begin
  ListCfg.Clear;
  EditDefDB.Properties.Items.Clear;

  for nIdx := ComponentCount-1 downto 0 do
  begin
    if Components[nIdx] is TcxTextEdit then
      (Components[nIdx] as TcxTextEdit).Text := '';
    //xxxxx

    if Components[nIdx] is TcxComboBox then
      (Components[nIdx] as TcxComboBox).Text := '';
    //xxxxx

    if Components[nIdx] is TcxMemo then
      (Components[nIdx] as TcxMemo).Text := '';
    //xxxxx
  end;

  with EditDefFit.Properties do
  if (not nCheck) or (Items.Count < 1) then
  begin
    Items.Clear;
    TStringHelper.EnumItems<TDBType>(Items);
  end;

  with EditFit.Properties do
  if (not nCheck) or (Items.Count < 1) then
  begin
    Items.Clear;
    Items.AddStrings(EditDefFit.Properties.Items);
  end;

  with gMG.FDBManager,EditDrivers.Properties do
  if (not nCheck) or (Items.Count < 1) then
  begin
    Items.Clear;
    for nIdx := Low(Drivers) to High(Drivers) do
      Items.Add(Drivers[nIdx].DriverInfo.DrvName);
    //xxxxx
  end;
end;

//Date: 2021-03-30
//Parm: �����ļ�
//Desc: ��nFile�ļ�
procedure TfFormDBConfig.OpenConfigFile(const nFile: string);
var nStr: string;
begin
  ActiveControl := nil;
  InitFormData(True);
  gMG.FDBManager.LoadConfigFile(nFile);
  ShowFileInBar(nFile);

  with gMG.FDBManager do
  begin
    LoadConfigList('', False);
    EditDefDB.ItemIndex := EditDefDB.Properties.Items.IndexOf(DefaultDB);
    nStr := TStringHelper.Enum2Str(DefaultFit);
    EditDefFit.ItemIndex := EditDefFit.Properties.Items.IndexOf(nStr);

    nStr := Driver.DriverInfo.DrvName;
    EditDrivers.ItemIndex := EditDrivers.Properties.Items.IndexOf(nStr);
    EditReConn.Checked := AutoReconnect;
  end;
end;

//Date: 2021-03-31
//Parm: �ļ���
//Desc: ��״̬����ʾ�ļ���
procedure TfFormDBConfig.ShowFileInBar(const nFileName: string);
var nStr,nDir: string;
    nIdx: Integer;
begin
  gDBFile := nFileName;
  Group1.Enabled := nFileName <> '';
  BarSub2.Enabled := nFileName <> '';

  if nFileName = '' then
  begin
    SBar1.Panels[1].Text := '';
    Exit;
  end;

  nDir := ExtractFilePath(nFileName);
  nStr := ExtractFileName(nFileName);
  nIdx := Length(nFileName) - 3;

  while nIdx > 52 do
  begin
    nDir := Copy(nDir, 1, Length(nDir) - 1);
    nIdx := Length(nDir + nStr) - 3;

    if nIdx <= 52 then
    begin
      nDir := nDir + '..\';
    end;
  end;

  SBar1.Panels[1].Text := nDir + nStr;
  //show file
end;

//Date: 2021-03-30
//Parm: ɸѡ����;ֻˢ���б�
//Desc: ���������б�
procedure TfFormDBConfig.LoadConfigList(nFilter: string; nOnlyList: Boolean);
var nStr: string;
    nConn: TDBConnConfig;
begin
  if not nOnlyList then
  begin
    nStr := EditDefDB.Text;
    EditDefDB.Properties.Items.Clear;
  end;

  nFilter := LowerCase(nFilter);
  ListCfg.Clear;

  for nConn in gMG.FDBManager.DBList.Values do
  begin
    if not nConn.FValid then Continue;
    //invalid

    if (nFilter = '') or (Pos(nFilter, LowerCase(nConn.FID)) > 0) then
      ListCfg.AddItem(nConn.FID, 41);
    //xxxxx

    if not nOnlyList then
      EditDefDB.Properties.Items.Add(nConn.FID);
    //xxxxx
  end;

  if not nOnlyList then
    EditDefDB.ItemIndex := EditDefDB.Properties.Items.IndexOf(nStr);
  //xxxxx
end;

procedure TfFormDBConfig.FormCreate(Sender: TObject);
begin
  Timer1Timer(nil);
  FSM.SwitchSkinRandom;
  ShowFileInBar('');

  TApplicationHelper.LoadFormConfig(Self);
  InitFormData(False);
end;

procedure TfFormDBConfig.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TApplicationHelper.SaveFormConfig(Self);
end;

procedure TfFormDBConfig.Timer1Timer(Sender: TObject);
begin
  SBar1.Panels[0].Text := '��.ʱ��: ' + TDateTimeHelper.DateTime2Str(Now());
end;

//------------------------------------------------------------------------------
//Desc: �½�����
procedure TfFormDBConfig.BtnNewClick(Sender: TObject);
begin
  with TSaveDialog.Create(Application) do
  try
    Title := '�½�����';
    DefaultExt := '.ini';
    Filter := '�����ļ�(*.ini)|*.ini';
    Options := Options + [ofOverwritePrompt];

    if FileExists(gDBFile) then
         InitialDir := ExtractFilePath(gDBFile)
    else InitialDir := TApplicationHelper.gPath;

    if Execute(Handle) then
      OpenConfigFile(FileName);
    //xxxxx
  finally
    Free;
  end;
end;

//Desc: ������
procedure TfFormDBConfig.BtnOpenClick(Sender: TObject);
begin
  with TOpenDialog.Create(Application) do
  try
    Title := '������';
    Filter := '�����ļ�(*.ini)|*.ini';
    Options := Options + [ofFileMustExist];

    if FileExists(gDBFile) then
         InitialDir := ExtractFilePath(gDBFile)
    else InitialDir := TApplicationHelper.gPath;

    if Execute(Handle) then
      OpenConfigFile(FileName);
    //xxxxx
  finally
    Free;
  end;
end;

//Desc: �˳�
procedure TfFormDBConfig.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: ��ʾ����
procedure TfFormDBConfig.ListCfgClick(Sender: TObject);
var nStr: string;
    nConn: TDBConnConfig;
begin
  if (ListCfg.ItemIndex > -1) and
     (gMG.FDBManager.GetDB(ListCfg.Items[ListCfg.ItemIndex], nConn)) then
  begin
    EditID.Text := nConn.FID;
    EditName.Text := nConn.FName;
    EditConn.Text := nConn.FConn;

    nStr := TStringHelper.Enum2Str(nConn.FFitDB);
    EditFit.ItemIndex := EditFit.Properties.Items.IndexOf(nStr);
  end;
end;

//Desc: ����
procedure TfFormDBConfig.EditFilterPropertiesChange(Sender: TObject);
begin
  LoadConfigList(EditFilter.Text);
end;

//Desc: ȡ������
procedure TfFormDBConfig.EditFilterPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  EditFilter.Text := '';
end;

//Desc: ����������
procedure TfFormDBConfig.BtnSaveCfgClick(Sender: TObject);
var nConn: TDBConnConfig;
begin
  if not FSM.VerifyUIData(Self,
    procedure (const nCtrl: TControl; var nResult: Boolean; var nHint: string)
    var nStr: string;
        nIdx: Integer;
    begin
      if nCtrl = EditID  then
      begin
        nStr := Trim(EditID.Text);
        nResult := nStr <> '';
        if not nResult then
        begin
          nHint := '����д���ݿ��ʶ';
          Exit;
        end;

        for nIdx := 1 to Length(nStr) do
        if not CharInSet(nStr[nIdx], ['0'..'9','a'..'z','A'..'Z','_','.']) then
        begin
          nResult := False;
          nHint := '����д:��ĸ,����,�»���';
        end;
      end else

      if nCtrl = EditFit then
      begin
        nResult := EditFit.ItemIndex >= 0;
        nHint := '��ѡ�����ݿ�����';
      end;
    end ) then Exit;
  //verify failure

  with nConn do
  begin
    FValid := True;
    FChanged := True;

    FID    := EditID.Text;
    FName  := Trim(EditName.Text);
    FConn  := Trim(EditConn.Text);
    FFitDB := TStringHelper.Str2Enum<TDBType>(EditFit.Text);
  end;

  with gMG.FDBManager do
  begin
    AddDB(nConn);
    SaveConfigFile(gDBFile);
  end;

  LoadConfigList(EditFilter.Text, False);
  FSM.ShowMsg('�������');
end;

//Desc: ɾ��������
procedure TfFormDBConfig.BtnDelCfgClick(Sender: TObject);
var nConn: TDBConnConfig;
begin
  with gMG.FDBManager do
  begin
    if not GetDB(EditID.Text, nConn) then
    begin
      ActiveControl := EditID;
      FSM.ShowMsg('��Ч�����ݿ��ʶ');
      Exit;
    end;

    nConn.FValid := False;
    nConn.FChanged := True;
    AddDB(nConn);
    SaveConfigFile(gDBFile);

    LoadConfigList(EditFilter.Text, False);
    FSM.ShowMsg('�������');
  end;
end;

//Desc: ���Ե�ǰ����
procedure TfFormDBConfig.BtnTestClick(Sender: TObject);
var nObj: TObject;
    nConn: TDBConnConfig;
begin
  with nConn do
  begin
    FValid := False;
    FChanged := False;

    FID    := TDateTimeHelper.DateTimeSerial();
    FName  := Trim(EditName.Text);
    FConn  := Trim(EditConn.Text);
    FFitDB := TStringHelper.Str2Enum<TDBType>(EditFit.Text);
  end;

  nObj := nil;
  with gMG.FDBManager do
  try
    AddDB(nConn);
    ShowWaitForm(Self, '�����������ݿ�');

    nObj := DBQuery('Select 1+1', nil, nConn.FID);
    FSM.ShowMsg('���Գɹ�');
  finally
    ReleaseDBQuery(nObj);
    CloseWaitForm;
  end;
end;

//Desc: ��������
procedure TfFormDBConfig.EditDefDBPropertiesEditValueChanged(Sender: TObject);
begin
  if not (Sender as TWinControl).Focused then Exit;
  //�ǽ������

  with gMG.FDBManager do
  begin
    if Sender = EditDefDB then
    begin
      DefaultDB := EditDefDB.Text;
      SaveConfigFile(gDBFile);
    end else

    if Sender = EditDefFit then
    begin
      if EditDefFit.ItemIndex >= 0 then
      begin
        DefaultFit := TStringHelper.Str2Enum<TDBType>(EditDefFit.Text);
        SaveConfigFile(gDBFile);
      end;
    end else

    if Sender = EditDrivers then
    begin
      if EditDrivers.ItemIndex >= 0 then
      begin
        ActiveDriver(EditDrivers.Text);
        SaveConfigFile(gDBFile);
      end;
    end else

    if Sender = EditReConn then
    begin
      AutoReconnect := EditReConn.Checked;
      SaveConfigFile(gDBFile);
    end;
  end;
end;

end.
