{*******************************************************************************
  ����: dmzn@163.com 2020-06-23
  ����: ��׼����
*******************************************************************************}
unit UFormBase;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, uniGUIForm,
  System.IniFiles, ULibFun, uniGUIBaseClasses, uniGUIClasses, uniPanel;

type
  TfFormBase = class;
  TfFormClass = class of TfFormBase;

  TfFormDesc = record
    FName          : string;                         //����
    FDesc          : string;                         //����
    FVerifyAdmin   : Boolean;                        //��֤����Ա
    FUserConfig    : Boolean;                        //�û��Զ�������
  end;

  TFormModalResult = reference to  procedure(const nResult: Integer;
    const nParam: PCommandParam = nil);
  //ģʽ�������ص�

  TfFormBase = class(TUniForm)
    PanelWork: TUniSimplePanel;
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
  protected
    { Protected declarations }
    FParam: TCommandParam;
    {*�������*}
    procedure OnCreateForm(Sender: TObject); virtual;
    procedure OnDestroyForm(Sender: TObject); virtual;
    procedure DoFormConfig(nIni: TIniFile; const nLoad: Boolean); virtual;
    {*���ຯ��*}
  public
    { Public declarations }
    class function DescMe: TfFormDesc; virtual;
    {*��������*}
    function SetData(const nData: PCommandParam): Boolean; virtual;
    function GetData(var nData: TCommandParam): Boolean; virtual;
    {*��д����*}
  end;

implementation

{$R *.dfm}
uses
  USysBusiness;

procedure TfFormBase.UniFormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  FParam.Init;
  OnCreateForm(Sender);
  nIni := nil;
  try
    if DescMe.FUserConfig then
      nIni := TWebSystem.UserConfigFile;
    DoFormConfig(nIni, True);
  finally
    nIni.Free;
  end;
end;

procedure TfFormBase.UniFormDestroy(Sender: TObject);
var nIni: TIniFile;
begin
  OnDestroyForm(Sender);
  nIni := nil;
  try
    if DescMe.FUserConfig then
      nIni := TWebSystem.UserConfigFile;
    DoFormConfig(nIni, False);
  finally
    nIni.Free;
  end;
end;

procedure TfFormBase.OnCreateForm(Sender: TObject);
begin
  //null
end;

procedure TfFormBase.OnDestroyForm(Sender: TObject);
begin
  //null
end;

procedure TfFormBase.DoFormConfig(nIni: TIniFile; const nLoad: Boolean);
begin
  //null
end;

//Date: 2021-05-06
//Desc: ����������Ϣ
class function TfFormBase.DescMe: TfFormDesc;
var nInit: TfFormDesc;
begin
  FillChar(nInit, SizeOf(TfFormDesc), #0);
  Result := nInit;
  //fill default

  Result.FName := ClassName;
  Result.FVerifyAdmin := False;
end;

//Date: 2021-04-27
//Parm: ����
//Desc: ���ô���Ĳ���
function TfFormBase.SetData(const nData: PCommandParam): Boolean;
begin
  if Assigned(nData) then
    FParam := nData^;
  Result := True;
end;

//Date: 2021-04-27
//Parm: ����
//Desc: ��ȡ���������,����nData��
function TfFormBase.GetData(var nData: TCommandParam): Boolean;
begin
  Result := True;
end;

end.
