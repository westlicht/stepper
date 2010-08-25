program PmMidi;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  PortMidi in 'PortMidi.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
