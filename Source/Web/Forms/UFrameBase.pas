{*******************************************************************************
  ����: dmzn@163.com 2021-06-03
  ����: Frame����
*******************************************************************************}
unit UFrameBase;

interface

uses
  SysUtils, Classes, Graphics, Controls, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Vcl.Forms, uniGUIBaseClasses, uniGUImJSForm,
  uniPanel;

type
  TfFrameBase = class;
  TfFrameClass = class of TfFrameBase;

  TfFrameDesc = record
    FName          : string;                         //����
    FDesc          : string;                         //����
    FVerifyAdmin   : Boolean;                        //��֤����Ա
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
    procedure OnCreateFrame(Sender: TObject); virtual;
    procedure OnDestroyFrame(Sender: TObject); virtual;
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

procedure TfFrameBase.UniFrameCreate(Sender: TObject);
begin
  FillChar(FParam, SizeOf(FParam), #0);
  OnCreateFrame(Sender);
end;

procedure TfFrameBase.UniFrameDestroy(Sender: TObject);
begin
  OnDestroyFrame(Sender);
end;

procedure TfFrameBase.OnCreateFrame(Sender: TObject);
begin
  //null
end;

procedure TfFrameBase.OnDestroyFrame(Sender: TObject);
begin
  //null
end;

//Date: 2021-06-03
//Desc: ����frame��Ϣ
class function TfFrameBase.DescMe: TfFrameDesc;
begin
  FillChar(Result, SizeOf(TfFrameDesc), #0);
  Result.FName := ClassName;
  Result.FVerifyAdmin := False;
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
