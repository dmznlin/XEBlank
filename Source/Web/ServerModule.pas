{*******************************************************************************
  作者: dmzn@163.com 2020-06-23
  描述: 系统全局控制模块
*******************************************************************************}
unit ServerModule;

interface

uses
  Classes, SysUtils, Data.Win.ADODB, uniGUIServer, uniGUITypes, UManagerGroup,
  ULibFun;

type
  TUniServerModule = class(TUniGUIServerModule)
    procedure UniGUIServerModuleBeforeInit(Sender: TObject);
    procedure UniGUIServerModuleBeforeShutdown(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure FirstInit; override;
  public
    { Public declarations }
  end;

function UniServerModule: TUniServerModule;

implementation

{$R *.dfm}

uses
  UniGUIVars, USysConst, USysBusiness;

function UniServerModule: TUniServerModule;
begin
  Result:=TUniServerModule(UniGUIServerInstance);
end;

procedure TUniServerModule.FirstInit;
begin
  InitServerModule(Self);
end;

procedure TUniServerModule.UniGUIServerModuleBeforeInit(Sender: TObject);
begin
  TWebSystem.InitSystemEnvironment;
  //初始化系统环境
  TWebSystem.LoadSysParameter();
  //载入系统配置参数

  with gSystem.FMain do
  begin
    Title := FPrograms[FActive].FTitleApp;
    //程序标题
    Port := FPrograms[FActive].FPort;
    //服务端口

    if FileExists(FPrograms[FActive].FFavicon) then
      Favicon.LoadFromFile(FPrograms[FActive].FFavicon);
    //收藏夹图标
  end;

//  with gSystem do
//  begin
//    FExtJS := ReplaceGlobalPath(FExtJS);
//    FUniJS := ReplaceGlobalPath(FUniJS);
//    Logger.AddLog('TUniServerModule', FExtJS);
//
//    if DirectoryExists(FExtJS) then
//      ExtRoot := FExtJS;
//    //xxxxx
//
//    if DirectoryExists(FUniJS) then
//      UniRoot := FUniJS;
//    //xxxxx
//  end;

  AutoCoInitialize := True;
  //自动初始化COM对象

  gMG.FLogManager.StartService();
  //启动日志服务
end;

procedure TUniServerModule.UniGUIServerModuleBeforeShutdown(Sender: TObject);
begin
//
end;

initialization
  RegisterServerModuleClass(TUniServerModule);
end.
