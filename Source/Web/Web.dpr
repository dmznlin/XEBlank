program Web;

uses
  FastMM4,
  Forms,
  ServerModule in 'ServerModule.pas' {UniServerModule: TUniGUIServerModule},
  MainModule in 'MainModule.pas' {UniMainModule: TUniGUIMainModule},
  UFormMain in 'UFormMain.pas' {fFormMain: TUniForm},
  USysBusiness in 'Common\USysBusiness.pas',
  USysConst in 'Common\USysConst.pas',
  USysFun in 'Common\USysFun.pas',
  USysRemote in 'Common\USysRemote.pas',
  UFormBase in 'Forms\UFormBase.pas' {fFormBase: TUniForm},
  UFormLogin in 'Forms\UFormLogin.pas' {fFormLogin: TUniLoginForm};

{$R *.res}

begin
  Application.Initialize;
  TUniServerModule.Create(Application);
  Application.Run;
end.
