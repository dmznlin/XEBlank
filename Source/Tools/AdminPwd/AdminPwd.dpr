program AdminPwd;

uses
  Vcl.Forms,
  UFormMain in 'UFormMain.pas' {fFormAdminPwd},
  UStyleModule in '..\..\Common\UStyleModule.pas' {FSM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFSM, FSM);
  Application.CreateForm(TfFormAdminPwd, fFormAdminPwd);
  Application.Run;
end.
