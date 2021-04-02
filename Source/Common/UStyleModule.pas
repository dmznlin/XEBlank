{*******************************************************************************
  ����: dmzn@163.com 2019-02-26
  ����: ���������Ԫ
*******************************************************************************}
unit UStyleModule;

interface

uses
  System.SysUtils, System.Classes, dxSkinsCore,
  dxSkinOffice2007Blue, dxSkinOffice2007Silver, dxSkinCaramel,
  dxSkinSpringTime, dxSkinSummer2008, dxSkinValentine, dxSkinXmas2008Blue,
  System.ImageList, Vcl.ImgList, Vcl.Controls, cxImageList, cxGraphics,
  cxLookAndFeels, dxSkinsForm, cxClasses, cxEdit, cxLookAndFeelPainters,
  dxAlertWindow, dxSkinsDefaultPainters, dxLayoutLookAndFeels, cxContainer;

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
  private
    { Private declarations }
    FDefaultSkin: string;
    {*Ĭ������*}
  public
    { Public declarations }
    procedure LoadSkinNames(const nList: TStrings);
    {*�����б�*}
    procedure SwitchSkinRandom(const nOverDefault: Boolean = False);
    procedure SwitchSkin(const nSkin: string; const nVerify: Boolean);
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
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(TApplicationHelper.gFormConfig);
  try
    FDefaultSkin := nIni.ReadString('Config', 'Theme', '');
    if FDefaultSkin <> '' then
      SwitchSkin(FDefaultSkin, True);
    //xxxxx
  finally
    nIni.Free;
  end;
end;

//Date: 2019-02-27
//Parm: �б�
//Desc: ��ǰ���õ�Ƥ���б�
procedure TFSM.LoadSkinNames(const nList: TStrings);
var nIdx: Integer;
begin
  nList.Clear;
  for nIdx := 0 to cxLookAndFeelPaintersManager.Count - 1 do
   with cxLookAndFeelPaintersManager[nIdx] do
    if (LookAndFeelStyle = lfsSkin) and (not IsInternalPainter) then
     nList.Add(LookAndFeelName);
  //xxxxx
end;

//Date: 2019-02-27
//Parm: ��������;��֤�����Ƿ���Ч
//Desc: �л�����ΪnSkin
procedure TFSM.SwitchSkin(const nSkin: string; const nVerify: Boolean);
var nList: TStrings;
begin
  nList := nil;
  try
    if nVerify then
    begin
      nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
      LoadSkinNames(nList);
      if nList.IndexOf(nSkin) < 0 then Exit;
    end;

    if SkinManager.SkinName <> nSkin then
      SkinManager.SkinName := nSkin;
    //xxxxx
  finally
    gMG.FObjectPool.Release(nList);
  end;
end;

//Date: 2020-10-26
//Parm: ����Ĭ��
//Desc: ����л�����
procedure TFSM.SwitchSkinRandom(const nOverDefault: Boolean);
var nIdx: Integer;
    nList: TStrings;
begin
  if (FDefaultSkin <> '') and (not nOverDefault) then Exit;
  //use default skin

  nList := nil;
  try
    nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
    FSM.LoadSkinNames(nList);
    nIdx := Random(nList.Count);

    if nIdx < nList.Count then
      FSM.SwitchSkin(nList[nIdx], False);
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
begin
  Result := InputDlg('���������Ա��̬����:', '��֤', nStr, 0, False) and
            TStringHelper.IsNumber(nStr, False);
  //xxxxx

  if Result then
   with TGoogleOTP do
    Result := Validate(EncodeBase32('sys_admin'), StrToInt(nStr));
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
//Parm: ��Ϣ;����;���ھ��
//Desc: ��ʾ�Ի���
procedure TFSM.ShowDlg(const nMsg: string; nTitle: string);
begin
  if nTitle = '' then
    nTitle := '��ʾ';
  ShowMsgBox(nMsg, nTitle);
end;

//Date: 2021-03-29
//Parm: ��Ϣ;����;���ھ��
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
