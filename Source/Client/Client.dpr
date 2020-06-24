program Client;

uses
  Vcl.Forms,
  UFormMain in 'UFormMain.pas' {fFormMain},
  UStyleModule in '..\Common\UStyleModule.pas',
  UFormLogin in 'UFormLogin.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFSM, FSM);
  Application.CreateForm(TfFormLogin, fFormLogin);
  Application.Run;
end.
