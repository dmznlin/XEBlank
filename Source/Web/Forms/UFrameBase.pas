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

  TfFrameDict = record
    FEntity        : string;                         //�ֵ�ʵ���ʶ
    FTables        : string;                         //�漰�ı�����
    FFields        : string;                         //�漰���ֶ�����
    FExclude       : Boolean;                        //�ֶε�ʹ�÷���(�ų�or������)
  end;

  TfFrameDesc = record
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
    class function DescMe: TfFrameDesc; virtual;
    {*��������*}
    function SetData(const nData: PCommandParam): Boolean; virtual;
    function GetData(var nData: TCommandParam): Boolean; virtual;
    {*��д����*}
  end;

implementation

{$R *.dfm}
uses
  UManagerGroup, USysBusiness;

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
    if DescMe.FUserConfig then
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
    if DescMe.FUserConfig then
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
class function TfFrameBase.DescMe: TfFrameDesc;
var nInit: TfFrameDesc;
begin
  FillChar(nInit, SizeOf(TfFrameDesc), #0);
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
