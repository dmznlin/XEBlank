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
  //��ʼ��ϵͳ����
  TWebSystem.LoadSysParameter();
  //����ϵͳ���ò���

  with gSystem.FMain do
  begin
    Title := FActive.FTitleApp;
    //�������

    if FActive.FExtRoot <> '' then
      ExtRoot := FActive.FExtRoot;
    //ǰ�˽ű�·��
    if FActive.FUniRoot <> '' then
      UniRoot := FActive.FUniRoot;
    //��ܽű�·��

    Port := FActive.FPort;
    //����˿�
    if FileExists(FActive.FFavicon) then
      Favicon.LoadFromFile(FActive.FFavicon);
    //�ղؼ�ͼ��
  end;

  AutoCoInitialize := True;
  //�Զ���ʼ��COM����

  MainFormDisplayMode := mfPage;
  //ȫ��ҳ����ʾ

  gMG.FLogManager.StartService();
  //������־����

  try
    gMG.FMenuManager.LoadLanguage();
    //����������б�
  except
    on nErr: Exception do
    begin
      gMG.FLogManager.AddLog(TUniServerModule, 'ServerModule', nErr.Message);
    end;
  end;
end;

procedure TUniServerModule.UniGUIServerModuleBeforeShutdown(Sender: TObject);
begin
//
end;

initialization
  RegisterServerModuleClass(TUniServerModule);
end.
