{*******************************************************************************
  作者: dmzn@163.com 2020-06-23
  描述: 标准窗体
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
    FName  : string;                   //类名
    FDesc  : string;                   //描述
  end;

  PFormCommandParam = ^TFormCommandParam;
  TFormCommandParam = record
    FCommand: integer;                               //命令
    FParamA: Variant;
    FParamB: Variant;
    FParamC: Variant;
    FParamD: Variant;
    FParamE: Variant;                                //参数A-E
    FParamP: Pointer;                                //指针参数
  end;

  TFormModalResult = reference to  procedure(const nResult: Integer;
    const nParam: PFormCommandParam = nil);
  //模式窗体结果回调

  TfFormBase = class(TUniForm)
    PanelWork: TUniSimplePanel;
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
  protected
    { Protected declarations }
    FParam: TFormCommandParam;
    {*命令参数*}
    procedure OnCreateForm(Sender: TObject); virtual;
    procedure OnDestroyForm(Sender: TObject); virtual;
    {*基类函数*}
  public
    { Public declarations }
    class function DescMe: TfFormDesc; virtual;
    {*窗体描述*}
    function SetData(const nData: PFormCommandParam): Boolean; virtual;
    function GetData(var nData: TFormCommandParam): Boolean; virtual;
    {*读写参数*}
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

//Date: 2021-05-06
//Desc: 描述窗体信息
class function TfFormBase.DescMe: TfFormDesc;
begin
  FillChar(Result, SizeOf(TfFormDesc), #0);
  Result.FName := ClassName;
end;

//Date: 2021-04-27
//Parm: 参数
//Desc: 设置窗体的参数
function TfFormBase.SetData(const nData: PFormCommandParam): Boolean;
begin
  if Assigned(nData) then
    FParam := nData^;
  Result := True;
end;

//Date: 2021-04-27
//Parm: 参数
//Desc: 读取窗体的数据,存入nData中
function TfFormBase.GetData(var nData: TFormCommandParam): Boolean;
begin
  Result := True;
end;

end.
