program AdminPwd;

uses
  Vcl.Forms,
  UFormMain in 'UFormMain.pas' {Form1},
  UStyleModule in '..\..\Common\UStyleModule.pas' {FSM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFSM, FSM);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
