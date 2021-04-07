program DBConfig;

uses
  Vcl.Forms,
  Winapi.Windows,
  UFormMain in 'UFormMain.pas' {fFormDBConfig},
  UStyleModule in '..\..\Common\UStyleModule.pas' {FSM: TDataModule};

{$R *.res}

var
  gMutexHwnd: Hwnd;
  //互斥句柄

begin
  gMutexHwnd := CreateMutex(nil, True, 'RunSoft_XE_DBConfig');
  //创建互斥量
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    ReleaseMutex(gMutexHwnd);
    CloseHandle(gMutexHwnd); Exit;
  end; //已有一个实例

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFSM, FSM);

  FSM.SwitchSkinRandom();
  if FSM.VerifyAdministrator then //verify
    Application.CreateForm(TfFormDBConfig, fFormDBConfig);
  Application.Run;

  ReleaseMutex(gMutexHwnd);
  CloseHandle(gMutexHwnd);
end.
