{*******************************************************************************
  作者: dmzn@163.com 2021-06-03
  描述: Frame基类
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
    FName          : string;                         //类名
    FDesc          : string;                         //描述
    FDBConn        : string;                         //数据库标识
    FDictEntity    : string;                         //数据字典标识
    FVerifyAdmin   : Boolean;                        //验证管理员
    FUserConfig    : Boolean;                        //用户自定义配置
  end;

  PFrameCommandParam = ^TFrameCommandParam;
  TFrameCommandParam = record
    FCommand: integer;                               //命令
    FParamA: Variant;
    FParamB: Variant;
    FParamC: Variant;
    FParamD: Variant;
    FParamE: Variant;                                //参数A-E
    FParamP: Pointer;                                //指针参数
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
    {*命令参数*}
    procedure OnCreateFrame(const nIni: TIniFile); virtual;
    procedure OnDestroyFrame(const nIni: TIniFile); virtual;
    {*基类函数*}
  public
    { Public declarations }
    class function DescMe: TfFrameDesc; virtual;
    {*窗体描述*}
    function SetData(const nData: PFrameCommandParam): Boolean; virtual;
    function GetData(var nData: PFrameCommandParam): Boolean; virtual;
    {*读写参数*}
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
    //启用自定义配置

    OnCreateFrame(nIni);
    //子类处理
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
    //启用自定义配置

    OnDestroyFrame(nIni);
    //子类处理
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
//Desc: 描述frame信息
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
//Parm: 参数
//Desc: 设置Frame的参数
function TfFrameBase.SetData(const nData: PFrameCommandParam): Boolean;
begin
  if Assigned(nData) then
    FParam := nData^;
  Result := True;
end;

//Date: 2021-06-03
//Parm: 参数
//Desc: 读取Frame的数据,存入nData中
function TfFrameBase.GetData(var nData: PFrameCommandParam): Boolean;
begin
  Result := True;
end;

end.
