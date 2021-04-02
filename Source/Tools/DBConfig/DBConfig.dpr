program DBConfig;

uses
  Vcl.Forms,
  UFormMain in 'UFormMain.pas' {fFormDBConfig},
  UStyleModule in '..\..\Common\UStyleModule.pas' {FSM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFSM, FSM);

  FSM.SwitchSkinRandom();
  if FSM.VerifyAdministrator then //verify
    Application.CreateForm(TfFormDBConfig, fFormDBConfig);
  Application.Run;
end.
