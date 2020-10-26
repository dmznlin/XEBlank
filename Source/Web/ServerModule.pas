{*******************************************************************************
  ����: dmzn@163.com 2020-06-23
  ����: ϵͳȫ�ֿ���ģ��
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
  UniGUIVars, USysFun, USysConst, USysBusiness;

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
  InitSystemEnvironment;
  //��ʼ��ϵͳ����
  LoadSysParameter();
  //����ϵͳ���ò���

  if not TApplicationHelper.IsValidConfigFile(gPath + sConfigFile,
    gSystem.FProgID) then
  begin
    raise Exception.Create(sInvalidConfig);
    //�����ļ����Ķ�
  end;

  Title := gSystem.FAppTitle;
  //�������
  Port := gSystem.FPort;
  //����˿�

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
  //�Զ���ʼ��COM����
end;

procedure TUniServerModule.UniGUIServerModuleBeforeShutdown(Sender: TObject);
begin
  gMG.FObjectPool.RegistMe(False);
  //�رն����
end;

initialization
  RegisterServerModuleClass(TUniServerModule);
end.
