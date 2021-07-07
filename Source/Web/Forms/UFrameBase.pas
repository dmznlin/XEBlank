{*******************************************************************************
  作者: dmzn@163.com 2021-06-03
  描述: Frame基类

  备注:
  *.TfFrameDesc:
    1.FDBConn: 从指定数据库加载数据,用于多数据库时自动切换.
    2.FVerifyAdmin: 是否验证管理员动态口令.
    3.FUserConfig: 是否自动创建用户私有配置文件.
    4.FDataDict.FEntity: 指定要加载的数据字典实体,用于自动构建表头.
    5.FDataDict.FTables: 指定初始化数据字典时用到的表名称,可多个表(逗号分隔).
    6.FDataDict.FFields: 指定初始化数据字典时用到的表字段,可多字段(逗号分隔).
    7.FDataDict.FExclude: True,不包含FFields字段;False,仅包含FFields字段
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
    FEntity        : string;                         //字典实体标识
    FTables        : string;                         //涉及的表名称
    FFields        : string;                         //涉及的字段名称
    FExclude       : Boolean;                        //字段的使用方法(排除or仅包含)
  end;

  TfFrameDesc = record
    FName          : string;                         //类名
    FDesc          : string;                         //描述
    FDBConn        : string;                         //数据库标识
    FDataDict      : TfFrameDict;                    //数据字典
    FVerifyAdmin   : Boolean;                        //验证管理员
    FUserConfig    : Boolean;                        //用户自定义配置
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
    {*命令参数*}
    procedure OnCreateFrame(const nIni: TIniFile); virtual;
    procedure OnDestroyFrame(const nIni: TIniFile); virtual;
    {*基类函数*}
  public
    { Public declarations }
    class function DescMe: TfFrameDesc; virtual;
    {*窗体描述*}
    function SetData(const nData: PCommandParam): Boolean; virtual;
    function GetData(var nData: TCommandParam): Boolean; virtual;
    {*读写参数*}
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
    FDataDict.FExclude := True; //默认排除FTables指定的字段
  end;
end;

//Date: 2021-06-03
//Parm: 参数
//Desc: 设置Frame的参数
function TfFrameBase.SetData(const nData: PCommandParam): Boolean;
begin
  if Assigned(nData) then
    FParam := nData^;
  Result := True;
end;

//Date: 2021-06-03
//Parm: 参数
//Desc: 读取Frame的数据,存入nData中
function TfFrameBase.GetData(var nData: TCommandParam): Boolean;
begin
  Result := True;
end;

end.
