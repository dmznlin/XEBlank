{*******************************************************************************
  ����: dmzn@163.com 2021-06-03
  ����: Frame����

  ��ע:
  *.TfFrameDesc:
    1.FDBConn: ��ָ�����ݿ��������,���ڶ����ݿ�ʱ�Զ��л�.
    2.FVerifyAdmin: �Ƿ���֤����Ա��̬����.
    3.FUserConfig: �Ƿ��Զ������û�˽�������ļ�.
    4.FDataDict.FEntity: ָ��Ҫ���ص������ֵ�ʵ��,�����Զ�������ͷ.
    5.FDataDict.FTables: ָ����ʼ�������ֵ�ʱ�õ��ı�����,�ɶ����(���ŷָ�).
    6.FDataDict.FFields: ָ����ʼ�������ֵ�ʱ�õ��ı��ֶ�,�ɶ��ֶ�(���ŷָ�).
    7.FDataDict.FExclude: True,������FFields�ֶ�;False,������FFields�ֶ�
*******************************************************************************}
unit UFrameBase;

interface

uses
  SysUtils, Classes, Graphics, Controls, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Vcl.Forms, System.IniFiles, uniGUIBaseClasses,
  uniPanel, ULibFun, uniTimer;

type
  TfFrameBase = class;
  TfFrameClass = class of TfFrameBase;

  PfFrameDict = ^TfFrameDict;
  TfFrameDict = record
    FEntity        : string;                         //�ֵ�ʵ���ʶ
    FTables        : string;                         //�漰�ı�����
    FFields        : string;                         //�漰���ֶ�����
    FExclude       : Boolean;                        //�ֶε�ʹ�÷���(�ų�or������)
    FMemo          : TArray<string>;                 //�ֵ䱸ע��Ϣ
  public
    function AddMemo(const nMemo: string): PfFrameDict;
    {*������ע*}
    function MemoToText(const nTag: string = #13#10): string;
    function MemoToHTML: string;
    {*��ע����*}
  end;

  TfFrameConfig = record
    FName          : string;                         //����
    FDesc          : string;                         //����
    FDBConn        : string;                         //���ݿ��ʶ
    FDataDict      : TfFrameDict;                    //�����ֵ�
    FVerifyAdmin   : Boolean;                        //��֤����Ա
    FUserConfig    : Boolean;                        //�û��Զ�������
  end;

  TfFrameBase = class(TUniFrame)
    PanelWork: TUniContainerPanel;
    procedure UniFrameCreate(Sender: TObject);
    procedure UniFrameDestroy(Sender: TObject);
  private
    { Private declarations }
    FTimerShow: TUniTimer;
    {*�ӳ��¼�*}
    procedure OnShowTimer(Sender: TObject);
  protected
    { Protected declarations }
    FParam: TCommandParam;
    {*�������*}
    procedure OnCreateFrame(Sender: TObject); virtual;
    procedure OnShowFrame(Sender: TObject); virtual;
    procedure OnDestroyFrame(Sender: TObject); virtual;
    procedure DoFrameConfig(nIni: TIniFile; const nLoad: Boolean); virtual;
    {*���ຯ��*}
  public
    { Public declarations }
    class function ConfigMe: TfFrameConfig; virtual;
    {*��������*}
    function SetData(const nData: PCommandParam): Boolean; virtual;
    function GetData(var nData: TCommandParam): Boolean; virtual;
    {*��д����*}
  end;

implementation

{$R *.dfm}
uses
  UManagerGroup, USysBusiness;

//Date: 2021-08-27
//Parm: ��ע
//Desc: ������ע
function TfFrameDict.AddMemo(const nMemo: string): PfFrameDict;
var nIdx: Integer;
begin
  Result := @Self;
  //return self address

  nIdx := Length(FMemo);
  SetLength(FMemo, nIdx + 1);
  FMemo[nIdx] := nMemo;
end;

//Date: 2021-08-27
//Parm: �ָ���
//Desc: ƴ�ӱ�ע�ַ���
function TfFrameDict.MemoToText(const nTag: string): string;
var nIdx: Integer;
begin
  Result := '';
  for nIdx := Low(FMemo) to High(FMemo) do
  begin
    if Result = '' then
         Result := FMemo[nIdx]
    else Result := Result + nTag + FMemo[nIdx];
  end;
end;

//Date: 2021-08-27
//Desc: ��עתhtml����
function TfFrameDict.MemoToHTML: string;
var nIdx,nH: Integer;
begin
  Result := '';
  nH := High(FMemo);

  for nIdx := Low(FMemo) to nH do
  begin
    if Result = '' then
         Result := '<ol><font size="3" face="courier new"><li>' + FMemo[nIdx] +
                   '</li>' //��Ŀ����: 1 2 3...
    else Result := Result + '<li>' + FMemo[nIdx] + '</li>';

    if nIdx >= nH then
      Result := Result + '</font></ol>';
    //xxxxx
  end;
end;

//------------------------------------------------------------------------------
procedure TfFrameBase.UniFrameCreate(Sender: TObject);
var nIni: TIniFile;
begin
  FParam.Init;
  FTimerShow := TUniTimer.Create(Self);
  with FTimerShow do
  begin
    RunOnce := True;
    Interval := 100;
    OnTimer := OnShowTimer;
  end;

  OnCreateFrame(Sender);
  nIni := nil;
  try
    if ConfigMe.FUserConfig then
      nIni := TWebSystem.UserConfigFile;
    DoFrameConfig(nIni, True);
  finally
    nIni.Free;
  end;
end;

procedure TfFrameBase.UniFrameDestroy(Sender: TObject);
var nIni: TIniFile;
begin
  OnDestroyFrame(Sender);
  nIni := nil;
  try
    if ConfigMe.FUserConfig then
      nIni := TWebSystem.UserConfigFile;
    DoFrameConfig(nIni, False);
  finally
    nIni.Free;
  end;
end;

//Date: 2021-08-07
//Desc: �ӳ�ִ���¼�
procedure TfFrameBase.OnShowTimer(Sender: TObject);
begin
  OnShowFrame(Self);
end;

procedure TfFrameBase.OnCreateFrame(Sender: TObject);
begin
  //null
end;

procedure TfFrameBase.OnShowFrame(Sender: TObject);
begin
  //null
end;

procedure TfFrameBase.OnDestroyFrame(Sender: TObject);
begin
  //null
end;

procedure TfFrameBase.DoFrameConfig(nIni: TIniFile; const nLoad: Boolean);
begin
  //null
end;

//Date: 2021-06-03
//Desc: ����frame��Ϣ
class function TfFrameBase.ConfigMe: TfFrameConfig;
var nInit: TfFrameConfig;
begin
  FillChar(nInit, SizeOf(TfFrameConfig), #0);
  Result := nInit;
  //fill default

  with Result do
  begin
    FVerifyAdmin  := False;
    FUserConfig   := False;
    FName         := ClassName;
    FDBConn       := gMG.FDBManager.DefaultDB;

    FDataDict.FEntity := 'DE_' + ClassName;
    FDataDict.FExclude := True; //Ĭ���ų�FTablesָ�����ֶ�
  end;
end;

//Date: 2021-06-03
//Parm: ����
//Desc: ����Frame�Ĳ���
function TfFrameBase.SetData(const nData: PCommandParam): Boolean;
begin
  if Assigned(nData) then
    FParam := nData^;
  Result := True;
end;

//Date: 2021-06-03
//Parm: ����
//Desc: ��ȡFrame������,����nData��
function TfFrameBase.GetData(var nData: TCommandParam): Boolean;
begin
  Result := True;
end;

end.
