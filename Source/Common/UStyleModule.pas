{*******************************************************************************
  ����: dmzn@163.com 2019-02-26
  ����: ���������Ԫ
*******************************************************************************}
unit UStyleModule;

interface

uses
  System.SysUtils, System.Classes, dxSkinsCore, dxCore, dxSkinsDefaultPainters,
  cxLookAndFeelPainters, cxGraphics, dxLayoutLookAndFeels, dxAlertWindow,
  System.ImageList, Vcl.ImgList, Vcl.Controls, cxImageList, cxLookAndFeels,
  dxSkinsForm, cxClasses, cxEdit;

type
  TVerifyUIData = reference to procedure (const nCtrl: TControl;
   var nResult: Boolean; var nHint: string);
  //��֤�������

  TFSM = class(TDataModule)
    EditStyle1: TcxDefaultEditStyleController;
    SkinManager: TdxSkinController;
    Image16: TcxImageList;
    AlertManager1: TdxAlertWindowManager;
    Image32: TcxImageList;
    dxLayout1: TdxLayoutLookAndFeelList;
    dxLayoutWeb1: TdxLayoutWebLookAndFeel;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FSkins: TStrings;
    FSkinDir: string;
    FSkinActive: string;
    {*�����*}
    FAdminKey: string;
    {*����Ա��Կ*}
  public
    { Public declarations }
    procedure LoadSkinNames(const nList: TStrings);
    {*�����б�*}
    procedure SwitchSkinRandom(const nOverDefault: Boolean = False);
    procedure SwitchSkin(const nSkin: string);
    {*�л�����*}
    procedure ShowMsg(const nMsg: string; nTitle: string = '');
    {*��Ϣ��*}
    procedure ShowDlg(const nMsg: string; nTitle: string = '');
    function QueryDlg(const nMsg: string; nTitle: string = ''): Boolean;
    function InputDlg(const nMsg,nTitle: string; var nValue: string;
      const nSize: Word = 0; const nPwd: Boolean = False): Boolean;
    {*��ʾ��*}
    function VerifyAdministrator: Boolean;
    {*��֤���*}
    function VerifyUIData(const nParent: TWinControl;
      const nVerify: TVerifyUIData; const nShowMsg: Boolean = True;
      const nVerifySub: Boolean = True): Boolean;
    {*��֤����*}
    property Skins: TStrings read FSkins;
    property SkinActive: string read FSkinActive;
    property AdminKey: string read FAdminKey write FAdminKey;
    {*�������*}
  end;

var
  FSM: TFSM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  System.IniFiles, Vcl.Forms, ULibFun, UManagerGroup, UGoogleOTP,
  UFormInputbox, UFormMessagebox;

procedure TFSM.DataModuleCreate(Sender: TObject);
var nStr: string;
    nIni: TIniFile;
begin
  FAdminKey := '';
  //key for admin
  FSkins := TStringList.Create;
  FSkinDir := TApplicationHelper.gPath + 'Skins' + PathDelim;

  nIni := TIniFile.Create(TApplicationHelper.gFormConfig);
  try
    nStr := nIni.ReadString('Config', 'SkinDir', '');
    if nStr <> '' then
    begin
      nStr := TApplicationHelper.ReplaceGlobalPath(nStr);
      FSkinDir := TApplicationHelper.RegularPath(nStr);
    end;

    nStr := nIni.ReadString('Config', 'Theme', '');
    if nStr <> '' then
    begin
      LoadSkinNames(nil);
      SwitchSkin(nStr);
    end;
  finally
    nIni.Free;
  end;
end;

procedure TFSM.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(FSkins);
end;

//Date: 2019-02-27
//Parm: �б�
//Desc: ��ǰ���õ�Ƥ���б�
procedure TFSM.LoadSkinNames(const nList: TStrings);
var nStr: string;
    nIdx: Integer;
    nSList: TStrings;
    nRet: Integer;
    nSR: TSearchRec;
begin
  if (not Assigned(nList)) or (FSkins.Count < 1) then //load skin files
  begin
    FSkins.Clear;
    nSList := TStringList.Create;

    nRet := FindFirst(FSkinDir + '*.skinres', faAnyFile, nSR);
    while nRet = 0 do
    try
      nSList.Clear;
      nStr := FSkinDir + nSR.Name;
      dxSkinsUserSkinPopulateSkinNames(nStr, nSList);

      for nIdx := 0 to nSList.Count-1 do
        FSkins.AddPair(nSList[nIdx], nStr);
      nRet := FindNext(nSR);
    except
      on nErr: Exception do
      begin
        gMG.FLogManager.AddLog('FSM.LoadSkinNames: ' + nErr.Message);
        Break;
      end;
    end;

    nSList.Free;
    FindClose(nSR); //find close

    for nIdx := 0 to cxLookAndFeelPaintersManager.Count - 1 do
     with cxLookAndFeelPaintersManager[nIdx] do
      if (LookAndFeelStyle = lfsSkin) and (not IsInternalPainter) then
       FSkins.AddPair(LookAndFeelName, '');
    //xxxxx
  end;

  if Assigned(nList) then
  begin
    nList.Clear;
    for nIdx := 0 to FSkins.Count-1 do
      nList.Add(FSkins.Names[nIdx]);
    //xxxxx
  end;
end;

//Date: 2019-02-27
//Parm: ��������
//Desc: �л�����ΪnSkin
procedure TFSM.SwitchSkin(const nSkin: string);
var nStr: string;
    nIdx: Integer;
begin
  for nIdx := FSkins.Count-1 downto 0 do
  if CompareText(nSkin, FSkins.Names[nIdx]) = 0 then
  begin
    if FSkinActive = FSkins.Names[nIdx] then
      Break;
    //skin enabled

    nStr := FSkins.ValueFromIndex[nIdx];
    if FileExists(nStr) then
    begin
      SkinManager.SkinName := 'UserSkin';
      dxSkinsUserSkinLoadFromFile(nStr, nSkin);
    end else
    begin
      if SkinManager.SkinName <> nSkin then
        SkinManager.SkinName := nSkin;
      //xxxxx
    end;

    FSkinActive := FSkins.Names[nIdx];
    Break;
  end;
end;

//Date: 2020-10-26
//Parm: ����Ĭ��
//Desc: ����л�����
procedure TFSM.SwitchSkinRandom(const nOverDefault: Boolean);
var nIdx: Integer;
    nList: TStrings;
begin
  if (FSkinActive <> '') and (not nOverDefault) then Exit;
  //use default skin

  nList := nil;
  try
    nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
    FSM.LoadSkinNames(nList);
    nIdx := Random(nList.Count);

    if nIdx < nList.Count then
      FSM.SwitchSkin(nList[nIdx]);
    //xxxxx
  finally
    gMG.FObjectPool.Release(nList);
  end;
end;

//Date: 2019-03-01
//Parm: ������;��֤����;�Ƿ���Ϣ��;��֤������
//Desc: ��֤nParent�µ����пؼ�������Ч
function TFSM.VerifyUIData(const nParent: TWinControl;
  const nVerify: TVerifyUIData; const nShowMsg,nVerifySub: Boolean): Boolean;
var nStr: string;
    nIdx: Integer;
begin
  Result := True;
  for nIdx := 0 to nParent.ControlCount - 1 do
  begin
    nVerify(nParent.Controls[nIdx], Result, nStr);
    //call-back to verify data

    if not Result then
    begin
      if nShowMsg then
      begin
        if nStr <> '' then
          ShowMsg(nStr);
        //xxxxx

        if nParent.Controls[nIdx] is TWinControl then
          (nParent.Controls[nIdx] as TWinControl).SetFocus;
        //xxxxx
      end;

      Exit;
    end;

    if nVerifySub and (nParent.Controls[nIdx] is TWinControl) then
    begin
      Result := VerifyUIData(nParent.Controls[nIdx] as TWinControl,
        nVerify, nShowMsg);
      if not Result then Exit;      
    end;
  end;
end;

//Date: 2021-04-02
//Desc: ʹ�ö�̬������֤�Ƿ�Ϊ����Ա
function TFSM.VerifyAdministrator: Boolean;
var nStr: string;
    nPrm: TApplicationHelper.TAppParam;
begin
  Result := InputDlg('���������Ա��̬����:', '��֤', nStr, 0, False) and
            TStringHelper.IsNumber(nStr, False);
  if not Result then Exit;

  if FAdminKey = '' then
  begin
    if FileExists(TApplicationHelper.gSysConfig) then
    begin
      nPrm.FAdminKey := '';
      TApplicationHelper.LoadParameters(nPrm, nil, False);

      if nPrm.FAdminKey <> '' then
        FAdminKey := nPrm.FAdminKey;
      //new key
    end;

    if FAdminKey = '' then
      FAdminKey := TApplicationHelper.sDefaultKey;
    //default key
  end;

  with TGoogleOTP do
    Result := Validate(EncodeBase32(FAdminKey), StrToInt(nStr));
  //xxxxx
end;

//Date: 2019-02-28
//Parm: ��Ϣ����;����
//Desc: ������Ϣ��
procedure TFSM.ShowMsg(const nMsg: string; nTitle: string);
begin
  if nTitle = '' then
    nTitle := '��ʾ';
  AlertManager1.Show(nTitle, nMsg, 5);
end;

//Date: 2021-03-29
//Parm: ��Ϣ;����
//Desc: ��ʾ�Ի���
procedure TFSM.ShowDlg(const nMsg: string; nTitle: string);
begin
  if nTitle = '' then
    nTitle := '��ʾ';
  ShowMsgBox(nMsg, nTitle);
end;

//Date: 2021-03-29
//Parm: ��Ϣ;����
//Desc: ѯ�ʶԻ���
function TFSM.QueryDlg(const nMsg: string; nTitle: string): Boolean;
begin
  if nTitle = '' then
    nTitle := 'ѯ��';
  Result := ShowQueryBox(nMsg, nTitle);
end;

//Date: 2021-04-02
//Parm: ��Ϣ;����;ֵ;��С;�Ƿ�����
//Desc: ��ʾ�����
function TFSM.InputDlg(const nMsg, nTitle: string; var nValue: string;
  const nSize: Word; const nPwd: Boolean): Boolean;
begin
  if nPwd then
       Result := ShowInputPWDBox(nMsg, nTitle, nValue, nSize)
  else Result := ShowInputBox(nMsg, nTitle, nValue, nSize);
end;

end.
