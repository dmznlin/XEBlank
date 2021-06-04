program Web;

uses
  FastMM4,
  Forms,
  ServerModule in 'ServerModule.pas' {UniServerModule: TUniGUIServerModule},
  MainModule in 'MainModule.pas' {UniMainModule: TUniGUIMainModule},
  UFormMain in 'UFormMain.pas' {fFormMain: TUniForm},
  UFormLogin in 'Forms\UFormLogin.pas' {fFormLogin: TUniLoginForm},
  UFormBase in 'Forms\UFormBase.pas' {fFormBase: TUniForm},
  UFormNormal in 'Forms\UFormNormal.pas' {fFormNormal: TUniForm},
  UFrameBase in 'Forms\UFrameBase.pas' {fFrameBase: TUniFrame},
  UFrameNormal in 'Forms\UFrameNormal.pas' {fFrameNormal: TUniFrame},
  USysModule in 'Common\USysModule.pas',
  USysBusiness in 'Common\USysBusiness.pas',
  USysConst in 'Common\USysConst.pas';

{$R *.res}

begin
  Application.Initialize;
  TUniServerModule.Create(Application);
  Application.Run;
end.
