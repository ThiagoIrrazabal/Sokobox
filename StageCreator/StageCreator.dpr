program StageCreator;

uses
  Vcl.Forms,
  ufrmStageCreator in 'ufrmStageCreator.pas' {frmStageCreator},
  uStageJSON in '..\Classes\StageJSON\uStageJSON.pas',
  StringFactory in '..\Factorys\StringFactory.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmStageCreator, frmStageCreator);
  Application.Run;
end.
