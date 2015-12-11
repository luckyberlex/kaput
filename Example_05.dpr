program Example_05;

uses
  Forms,
  FormMain in 'FormMain.pas' {MainForm},
  DirectDrawUsing in 'DirectDrawUsing.pas',
  BaseSprite in 'BaseSprite.pas',
  UdxInputManager in 'UdxInputManager.pas',
  IronKaput in 'IronKaput.pas',
  Logo in 'Logo.pas' {FormLogo},
  Start in 'Start.pas' {FormStart},
  Final in 'Final.pas' {FormFinal},
  SoundManagerIronKaput in 'SoundManagerIronKaput.pas',
  drawtimeandnumb in 'drawtimeandnumb.pas',
  IronKaputBase in 'IronKaputBase.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Iron kaput';
  Application.CreateForm(TFormStart, FormStart);
  Application.Run;
end.
