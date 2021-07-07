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
  uniPanel, ULibFun;

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
  protected
    { Protected declarations }
    FParam: TCommandParam;
    {*�������*}
    procedure OnCreateFrame(const nIni: TIniFile); virtual;
    procedure OnDestroyFrame(const nIni: TIniFile); virtual;
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
  nIni := nil;
  try
    if DescMe.FUserConfig then
      nIni := TWebSystem.UserConfigFile;
    //�����Զ�������

    OnCreateFrame(nIni);
    //���ദ��
  finally
    nIni.Free;
  end;
end;

procedure TfFrameBase.UniFrameDestroy(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := nil;
  try
    if DescMe.FUserConfig then
      nIni := TWebSystem.UserConfigFile;
    //�����Զ�������

    OnDestroyFrame(nIni);
    //���ദ��
  finally
    nIni.Free;
  end;
end;

procedure TfFrameBase.OnCreateFrame(const nIni: TIniFile);
begin
  //null
end;

procedure TfFrameBase.OnDestroyFrame(const nIni: TIniFile);
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
