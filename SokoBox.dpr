program SokoBox;

{$R *.dres}

uses
  Vcl.Forms,
  ufrmSokoBox in 'ufrmSokoBox.pas' {frmSokoBox},
  Interfaces.Floor in 'Interfaces\Interfaces.Floor.pas',
  uStageJSON in 'Classes\StageJSON\uStageJSON.pas',
  StringFactory in 'Factorys\StringFactory.pas',
  Interfaces.Wall in 'Interfaces\Interfaces.Wall.pas',
  Classes.Wall in 'Classes\Classes.Wall.pas',
  Classes.Floor in 'Classes\Classes.Floor.pas',
  Interfaces.Box in 'Interfaces\Interfaces.Box.pas',
  Classes.Box in 'Classes\Classes.Box.pas',
  Interfaces.Goal in 'Interfaces\Interfaces.Goal.pas',
  Classes.Goal in 'Classes\Classes.Goal.pas',
  Interfaces.Box.Goal in 'Interfaces\Interfaces.Box.Goal.pas',
  Classes.Box.Goal in 'Classes\Classes.Box.Goal.pas',
  Interfaces.Player in 'Interfaces\Interfaces.Player.pas',
  Classes.Player in 'Classes\Classes.Player.pas',
  ufrmWin in 'ufrmWin.pas' {frmWin},
  ufrmGame in 'ufrmGame.pas' {frmGame},
  ufrmLogin in '..\Login\ufrmLogin.pas' {frmLogin},
  ufrmSignUp in '..\Login\ufrmSignUp.pas' {frmSignUp},
  uJSONUser in '..\Login\uJSONUser.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmSokoBox, frmSokoBox);
  ReportMemoryLeaksOnShutdown := True;
  Application.Run;
end.
