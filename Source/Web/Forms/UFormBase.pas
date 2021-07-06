{*******************************************************************************
  ����: dmzn@163.com 2020-06-23
  ����: ��׼����
*******************************************************************************}
unit UFormBase;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, uniGUIForm,
  USysConst, uniGUIBaseClasses, uniGUIClasses, uniPanel;

type
  TfFormBase = class;
  TfFormClass = class of TfFormBase;

  TfFormDesc = record
    FName          : string;                         //����
    FDesc          : string;                         //����
    FVerifyAdmin   : Boolean;                        //��֤����Ա
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

procedure TfFormBase.UniFormCreate(Sender: TObject);
var nInit: TCommandParam;
begin
  FillChar(nInit, SizeOf(nInit), #0);
  FParam := nInit;
  OnCreateForm(Sender);
end;

procedure TfFormBase.UniFormDestroy(Sender: TObject);
begin
  OnDestroyForm(Sender);
end;

procedure TfFormBase.OnCreateForm(Sender: TObject);
begin
  //null
end;

procedure TfFormBase.OnDestroyForm(Sender: TObject);
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
