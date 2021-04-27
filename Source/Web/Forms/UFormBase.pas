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
  TfFormBase = class(TUniForm)
    PanelWork: TUniSimplePanel;
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
  protected
    { Protected declarations }
    FParam: TFormCommandParam;
    {*�������*}
    procedure OnCreateForm(Sender: TObject); virtual;
    procedure OnDestroyForm(Sender: TObject); virtual;
    {*���ຯ��*}
  public
    { Public declarations }
    function SetData(const nData: PFormCommandParam): Boolean; virtual;
    function GetData(var nData: TFormCommandParam): Boolean; virtual;
    {*��д����*}
  end;

implementation

{$R *.dfm}

procedure TfFormBase.UniFormCreate(Sender: TObject);
begin
  FillChar(FParam, SizeOf(FParam), #0);
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

//Date: 2021-04-27
//Parm: ����
//Desc: ���ô���Ĳ���
function TfFormBase.SetData(const nData: PFormCommandParam): Boolean;
begin
  if Assigned(nData) then
    FParam := nData^;
  Result := True;
end;

//Date: 2021-04-27
//Parm: ����
//Desc: ��ȡ���������,����nData��
function TfFormBase.GetData(var nData: TFormCommandParam): Boolean;
begin
  Result := True;
end;

end.
