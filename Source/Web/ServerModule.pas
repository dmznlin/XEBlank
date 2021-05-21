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

  gMG.FMenuManager.LoadLanguage();
  //����������б�
end;

procedure TUniServerModule.UniGUIServerModuleBeforeShutdown(Sender: TObject);
begin
//
end;

initialization
  RegisterServerModuleClass(TUniServerModule);
end.
