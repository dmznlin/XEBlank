{*******************************************************************************
  ����: dmzn@163.com 2021-06-03
  ����: Frame����
*******************************************************************************}
unit UFrameBase;

interface

uses
  SysUtils, Classes, Graphics, Controls, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Vcl.Forms, System.IniFiles, uniGUIBaseClasses,
  uniPanel;

type
  TfFrameBase = class;
  TfFrameClass = class of TfFrameBase;

  TfFrameDesc = record
    FName          : string;                         //����
    FDesc          : string;                         //����
    FDBConn        : string;                         //���ݿ��ʶ
    FDictEntity    : string;                         //�����ֵ��ʶ
    FVerifyAdmin   : Boolean;                        //��֤����Ա
    FUserConfig    : Boolean;                        //�û��Զ�������
  end;

  PFrameCommandParam = ^TFrameCommandParam;
  TFrameCommandParam = record
    FCommand: integer;                               //����
    FParamA: Variant;
    FParamB: Variant;
    FParamC: Variant;
    FParamD: Variant;
    FParamE: Variant;                                //����A-E
    FParamP: Pointer;                                //ָ�����
  end;

  TfFrameBase = class(TUniFrame)
    PanelWork: TUniContainerPanel;
    procedure UniFrameCreate(Sender: TObject);
    procedure UniFrameDestroy(Sender: TObject);
  private
    { Private declarations }
  protected
    { Protected declarations }
    FParam: TFrameCommandParam;
    {*�������*}
    procedure OnCreateFrame(const nIni: TIniFile); virtual;
    procedure OnDestroyFrame(const nIni: TIniFile); virtual;
    {*���ຯ��*}
  public
    { Public declarations }
    class function DescMe: TfFrameDesc; virtual;
    {*��������*}
    function SetData(const nData: PFrameCommandParam): Boolean; virtual;
    function GetData(var nData: PFrameCommandParam): Boolean; virtual;
    {*��д����*}
  end;

implementation

{$R *.dfm}
uses
  UManagerGroup, USysBusiness;

procedure TfFrameBase.UniFrameCreate(Sender: TObject);
var nIni: TIniFile;
begin
  FillChar(FParam, SizeOf(FParam), #0);
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
begin
  FillChar(Result, SizeOf(TfFrameDesc), #0);
  with Result do
  begin
    FVerifyAdmin  := False;
    FUserConfig   := False;
    FName         := ClassName;
    FDBConn       := gMG.FDBManager.DefaultDB;
    FDictEntity   := 'DE_' + ClassName; //datadict entity
  end;
end;

//Date: 2021-06-03
//Parm: ����
//Desc: ����Frame�Ĳ���
function TfFrameBase.SetData(const nData: PFrameCommandParam): Boolean;
begin
  if Assigned(nData) then
    FParam := nData^;
  Result := True;
end;

//Date: 2021-06-03
//Parm: ����
//Desc: ��ȡFrame������,����nData��
function TfFrameBase.GetData(var nData: PFrameCommandParam): Boolean;
begin
  Result := True;
end;

end.
