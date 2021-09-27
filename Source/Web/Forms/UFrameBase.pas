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
  uniPanel, ULibFun, uniTimer;

type
  TfFrameBase = class;
  TfFrameClass = class of TfFrameBase;

  PfFrameDict = ^TfFrameDict;
  TfFrameDict = record
    FEntity        : string;                         //字典实体标识
    FTables        : string;                         //涉及的表名称
    FFields        : string;                         //涉及的字段名称
    FExclude       : Boolean;                        //字段的使用方法(排除or仅包含)
    FMemo          : TArray<string>;                 //字典备注信息
  public
    function AddMemo(const nMemo: string): PfFrameDict;
    {*新增备注*}
    function MemoToText(const nTag: string = #13#10): string;
    function MemoToHTML: string;
    {*备注内容*}
  end;

  TfFrameConfig = record
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
    FTimerShow: TUniTimer;
    {*延迟事件*}
    procedure OnShowTimer(Sender: TObject);
  protected
    { Protected declarations }
    FParam: TCommandParam;
    {*命令参数*}
    procedure OnCreateFrame(Sender: TObject); virtual;
    procedure OnShowFrame(Sender: TObject); virtual;
    procedure OnDestroyFrame(Sender: TObject); virtual;
    procedure DoFrameConfig(nIni: TIniFile; const nLoad: Boolean); virtual;
    {*基类函数*}
  public
    { Public declarations }
    class function ConfigMe: TfFrameConfig; virtual;
    {*窗体描述*}
    function SetData(const nData: PCommandParam): Boolean; virtual;
    function GetData(var nData: TCommandParam): Boolean; virtual;
    {*读写参数*}
  end;

implementation

{$R *.dfm}
uses
  UManagerGroup, USysBusiness;

//Date: 2021-08-27
//Parm: 备注
//Desc: 新增备注
function TfFrameDict.AddMemo(const nMemo: string): PfFrameDict;
var nIdx: Integer;
begin
  Result := @Self;
  //return self address

  nIdx := Length(FMemo);
  SetLength(FMemo, nIdx + 1);
  FMemo[nIdx] := nMemo;
end;

//Date: 2021-08-27
//Parm: 分隔符
//Desc: 拼接备注字符串
function TfFrameDict.MemoToText(const nTag: string): string;
var nIdx: Integer;
begin
  Result := '';
  for nIdx := Low(FMemo) to High(FMemo) do
  begin
    if Result = '' then
         Result := FMemo[nIdx]
    else Result := Result + nTag + FMemo[nIdx];
  end;
end;

//Date: 2021-08-27
//Desc: 备注转html代码
function TfFrameDict.MemoToHTML: string;
var nIdx,nH: Integer;
begin
  Result := '';
  nH := High(FMemo);

  for nIdx := Low(FMemo) to nH do
  begin
    if Result = '' then
         Result := '<ol><font size="3" face="courier new"><li>' + FMemo[nIdx] +
                   '</li>' //项目符号: 1 2 3...
    else Result := Result + '<li>' + FMemo[nIdx] + '</li>';

    if nIdx >= nH then
      Result := Result + '</font></ol>';
    //xxxxx
  end;
end;

//------------------------------------------------------------------------------
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
    if ConfigMe.FUserConfig then
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
    if ConfigMe.FUserConfig then
      nIni := TWebSystem.UserConfigFile;
    DoFrameConfig(nIni, False);
  finally
    nIni.Free;
  end;
end;

//Date: 2021-08-07
//Desc: 延迟执行事件
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
//Desc: 描述frame信息
class function TfFrameBase.ConfigMe: TfFrameConfig;
var nInit: TfFrameConfig;
begin
  FillChar(nInit, SizeOf(TfFrameConfig), #0);
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
