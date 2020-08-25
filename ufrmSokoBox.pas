unit ufrmSokoBox;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus, System.Actions,
  Vcl.ActnList, System.Generics.Collections, uStageJSON, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, ufrmGame, Interfaces.Player;

type
  TfrmSokoBox = class(TForm)
    Actions: TActionList;
    actNewGame: TAction;
    actExit: TAction;
    tmrLoadJSONS: TTimer;
    pnlBorderRigth: TPanel;
    pnlBorderTop: TPanel;
    pnlTop: TPanel;
    pnlRigth: TPanel;
    pnlMoves: TPanel;
    pnlTop5: TPanel;
    pnlPlayer1: TPanel;
    pnlPlayer2: TPanel;
    pnlPlayer3: TPanel;
    pnlPlayer4: TPanel;
    pnlPlayer5: TPanel;
    actContinue: TAction;
    actRestart: TAction;
    pnlMenu: TPanel;
    pnlBorderNewGame: TPanel;
    pnlNewGame: TPanel;
    pnlBorderLoad: TPanel;
    pnlLoad: TPanel;
    pnlBorderRestart: TPanel;
    pnlRestart: TPanel;
    pnlBorderExit: TPanel;
    pnlExit: TPanel;
    imgLoad: TImage;
    imgNewGame: TImage;
    imgRestart: TImage;
    imgExit: TImage;
    pnlBackGround: TGridPanel;
    procedure actExitExecute(Sender: TObject);
    procedure tmrLoadJSONSTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actNewGameExecute(Sender: TObject);
    procedure actContinueExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure actRestartExecute(Sender: TObject);
    procedure pnlNewGameMouseEnter(Sender: TObject);
    procedure pnlNewGameMouseLeave(Sender: TObject);
    procedure pnlNewGameClick(Sender: TObject);
    procedure pnlLoadClick(Sender: TObject);
    procedure pnlRestartClick(Sender: TObject);
    procedure pnlExitClick(Sender: TObject);
    procedure pnlMenuMouseEnter(Sender: TObject);
    procedure pnlPlayer2MouseEnter(Sender: TObject);
    procedure pnlMovesMouseEnter(Sender: TObject);
    procedure pnlTopMouseEnter(Sender: TObject);
    procedure pnlBorderTopMouseEnter(Sender: TObject);
    procedure pnlRigthMouseEnter(Sender: TObject);
    procedure pnlBorderRigthMouseEnter(Sender: TObject);
    procedure pnlTop5MouseEnter(Sender: TObject);
    procedure pnlPlayer1MouseEnter(Sender: TObject);
    procedure pnlPlayer3MouseEnter(Sender: TObject);
    procedure pnlPlayer4MouseEnter(Sender: TObject);
    procedure pnlPlayer5MouseEnter(Sender: TObject);
    procedure pnlBorderNewGameMouseEnter(Sender: TObject);
    procedure imgNewGameMouseEnter(Sender: TObject);
    procedure imgLoadMouseEnter(Sender: TObject);
    procedure imgRestartMouseEnter(Sender: TObject);
    procedure imgExitMouseEnter(Sender: TObject);
    procedure pnlBackGroundMouseEnter(Sender: TObject);
    procedure BackGroundMouseEnter(Sender: TObject);
    procedure FormMouseEnter(Sender: TObject);
    procedure imgNewGameMouseLeave(Sender: TObject);
    procedure imgRestartMouseLeave(Sender: TObject);
    procedure imgExitMouseLeave(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure imgLoadMouseLeave(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  const
    C_OPENED: Int16 = 200;
    C_CLOSED: Int16 = 65;
    procedure CriaFormularioGame(lStage: TStage);
    procedure CarregarImagens;
    function Login: Boolean;
    procedure CloseGame;
    procedure NextStage;
    procedure SaveRecord(const Moves: Integer);
    procedure SaveIniRecord(const PlayerName: string; const Position: Integer);
    procedure SavePlayerRecord(const PlayerName: string; const Moves: Integer);
  var
    pngNew,
    pngLoad,
    pngRestart,
    pngExit: TPngImage;
    FStage: Int16;
    FJSONS: TObjectList<TStage>;
    FPlayerName: string;
    FLoaded: Boolean;
    FMoves: Integer;
    FPerfectMoves: Integer;
    frmGame: TfrmGame;
    procedure LoadEnabled;
    procedure LoadRecords;
    procedure LoadFromDirectory(const Value: string);
    function HaveAttr(const Attr, Val: Integer): Boolean;
    function FindStage(const Stage: Int16): TStage;
    procedure SetMoves(const Value: Integer);
    procedure MenuOpen;
    procedure MenuClose;
    procedure Winner;
  public
    { Public declarations }
  end;

var
  frmSokoBox: TfrmSokoBox;

implementation

{$R *.dfm}

uses StringFactory,
     System.IniFiles,
     ufrmWin,
     ufrmLogin,
     uJSONUser,
     Math;

procedure TfrmSokoBox.actContinueExecute(Sender: TObject);
var
  IniFile: TIniFile;
  lStage: TStage;
begin
  IniFile := TIniFile.Create(System.SysUtils.IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'stage');
  try
    FMoves := 0;
    FStage := IniFile.ReadInteger('STAGE', FPlayerName, 1);
    lStage := FindStage(FStage);
    pnlTop.Caption := 'Stage: ' + lStage.Stage.Number.ToString;
    FPerfectMoves := lStage.Stage.PerfectMoves;
    CriaFormularioGame(lStage);
  finally
    FreeAndNil(IniFile);
  end;
end;

procedure TfrmSokoBox.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmSokoBox.MenuOpen;
begin
  pnlMenu.Width := C_OPENED;
  pnlNewGame.Caption := 'New';
  pnlLoad.Caption := 'Load';
  pnlRestart.Caption := 'Reset';
  pnlExit.Caption := 'Exit';
end;

procedure TfrmSokoBox.SetMoves(const Value: Integer);
begin
  FMoves := Value;
  pnlMoves.Caption := 'Moves: ' + Value.ToString;
end;

procedure TfrmSokoBox.pnlMenuMouseEnter(Sender: TObject);
begin
  MenuOpen;
end;

function TfrmSokoBox.FindStage(const Stage: Int16): TStage;
begin
  Result := nil;
  for Result in FJSONS do
  begin
    if (Result.Stage.Number = Stage) then
      Exit;
  end;
end;

procedure TfrmSokoBox.actNewGameExecute(Sender: TObject);
var
  lStage: TStage;
begin
  FMoves := 0;
  lStage := FindStage(1);
  pnlTop.Caption := 'Stage: ' + lStage.Stage.Number.ToString;
  FPerfectMoves := lStage.Stage.PerfectMoves;
  CriaFormularioGame(lStage);
end;

procedure TfrmSokoBox.actRestartExecute(Sender: TObject);
var
  lStage: TStage;
begin
  FMoves := 0;
  lStage := FindStage(FStage);
  pnlTop.Caption := 'Stage: ' + lStage.Stage.Number.ToString;
  FPerfectMoves := lStage.Stage.PerfectMoves;
  CriaFormularioGame(lStage);
end;

procedure TfrmSokoBox.MenuClose;
begin
  pnlMenu.Width := C_CLOSED;
  pnlNewGame.Caption := EmptyStr;
  pnlLoad.Caption := EmptyStr;
  pnlRestart.Caption := EmptyStr;
  pnlExit.Caption := EmptyStr;
end;

procedure TfrmSokoBox.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(FJSONS);
  if Assigned(frmGame) then
  begin
    frmGame.Close;
    FreeAndNil(frmGame);
  end;
end;

procedure TfrmSokoBox.FormDestroy(Sender: TObject);
begin
  if Assigned(pngNew) then
    FreeAndNil(pngNew);
  if Assigned(pngLoad) then
    FreeAndNil(pngLoad);
  if Assigned(pngRestart) then
    FreeAndNil(pngRestart);
  if Assigned(pngExit) then
    FreeAndNil(pngExit);
end;

procedure TfrmSokoBox.pnlTop5MouseEnter(Sender: TObject);
begin
  MenuClose;
end;

procedure TfrmSokoBox.pnlBackGroundMouseEnter(Sender: TObject);
begin
  MenuClose;
end;

procedure TfrmSokoBox.pnlBorderNewGameMouseEnter(Sender: TObject);
begin
  MenuOpen;
end;

procedure TfrmSokoBox.pnlBorderRigthMouseEnter(Sender: TObject);
begin
  MenuClose;
end;

procedure TfrmSokoBox.pnlBorderTopMouseEnter(Sender: TObject);
begin
  MenuClose;
end;

procedure TfrmSokoBox.pnlExitClick(Sender: TObject);
begin
  if ((Sender is TPanel) and (TPanel(Sender).Tag = 0)) or
    ((Sender is TImage) and (TPanel(TImage(Sender).Parent).Tag = 0)) then
    actExitExecute(actExit);
end;

procedure TfrmSokoBox.pnlLoadClick(Sender: TObject);
begin
  if ((Sender is TPanel) and (TPanel(Sender).Tag = 0)) or
    ((Sender is TImage) and (TPanel(TImage(Sender).Parent).Tag = 0)) then
  begin
    pnlRestart.Tag := 0;
    actContinueExecute(actContinue);
  end;
end;

procedure TfrmSokoBox.pnlMovesMouseEnter(Sender: TObject);
begin
  MenuClose;
end;

procedure TfrmSokoBox.pnlNewGameClick(Sender: TObject);
begin
  if ((Sender is TPanel) and (TPanel(Sender).Tag = 0)) or
    ((Sender is TImage) and (TPanel(TImage(Sender).Parent).Tag = 0)) then
  begin
    pnlRestart.Tag := 0;
    actNewGameExecute(actNewGame);
  end;
end;

procedure TfrmSokoBox.pnlNewGameMouseEnter(Sender: TObject);
begin
  if (TPanel(Sender).Tag = 0) then
  begin
    TPanel(Sender).Color := $0068F50A;
    TPanel(Sender).Cursor := crDefault;
  end
  else
  begin
    TPanel(Sender).Color := clSilver;
    TPanel(Sender).Cursor := crNo;
  end;

  MenuOpen;
end;

procedure TfrmSokoBox.pnlNewGameMouseLeave(Sender: TObject);
begin
  TPanel(Sender).Color := clWhite;
  TPanel(Sender).Cursor := crDefault;
end;

procedure TfrmSokoBox.pnlPlayer1MouseEnter(Sender: TObject);
begin
  MenuClose;
end;

procedure TfrmSokoBox.pnlPlayer2MouseEnter(Sender: TObject);
begin
  MenuClose;
end;

procedure TfrmSokoBox.pnlPlayer3MouseEnter(Sender: TObject);
begin
  MenuClose;
end;

procedure TfrmSokoBox.pnlPlayer4MouseEnter(Sender: TObject);
begin
  MenuClose;
end;

procedure TfrmSokoBox.pnlPlayer5MouseEnter(Sender: TObject);
begin
  MenuClose;
end;

procedure TfrmSokoBox.pnlRestartClick(Sender: TObject);
begin
  if ((Sender is TPanel) and (TPanel(Sender).Tag = 0)) or
    ((Sender is TImage) and (TPanel(TImage(Sender).Parent).Tag = 0)) then
    actRestartExecute(actRestart);
end;

procedure TfrmSokoBox.pnlRigthMouseEnter(Sender: TObject);
begin
  MenuClose;
end;

procedure TfrmSokoBox.pnlTopMouseEnter(Sender: TObject);
begin
  MenuClose;
end;

procedure TfrmSokoBox.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  lDirection: TPlayerDirection;
begin
  if FLoaded then
  begin
    case Key of
      VK_UP: lDirection := TPlayerDirection.tpdUP;
      VK_DOWN: lDirection := TPlayerDirection.tpdDOWN;
      VK_LEFT: lDirection := TPlayerDirection.tpdLEFT;
      VK_RIGHT: lDirection := TPlayerDirection.tpdRIGHT;
    else lDirection := TPlayerDirection.tpdNone;
    end;

    if (lDirection <> TPlayerDirection.tpdNone) then
    begin
      frmGame.ChangeSquare(lDirection);
      Sleep(130);

      if frmGame.Winner then
        Winner;
    end;
  end;
end;

procedure TfrmSokoBox.FormMouseEnter(Sender: TObject);
begin
  MenuClose;
end;

procedure TfrmSokoBox.SaveRecord(const Moves: Integer);
var
  IniFile: TIniFile;
  Player1, Player2, Player3, Player4, Player5: string;
  Moves1, Moves2, Moves3, Moves4, Moves5: Integer;
begin
  SavePlayerRecord(FPlayerName, Moves);
  IniFile := TIniFile.Create(System.SysUtils.IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'records');
  try
    Player1 := IniFile.ReadString('STAGE' + frmGame.PStage.Stage.Number.ToString, 'player1', EmptyStr);
    Player2 := IniFile.ReadString('STAGE' + frmGame.PStage.Stage.Number.ToString, 'player2', EmptyStr);
    Player3 := IniFile.ReadString('STAGE' + frmGame.PStage.Stage.Number.ToString, 'player3', EmptyStr);
    Player4 := IniFile.ReadString('STAGE' + frmGame.PStage.Stage.Number.ToString, 'player4', EmptyStr);
    Player5 := IniFile.ReadString('STAGE' + frmGame.PStage.Stage.Number.ToString, 'player5', EmptyStr);
  finally
    FreeAndNil(IniFile);
  end;

  IniFile := TIniFile.Create(System.SysUtils.IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'playerrecord');
  try
    Moves1 := IniFile.ReadInteger('STAGE' + frmGame.PStage.Stage.Number.ToString, Player1, 0);
    Moves2 := IniFile.ReadInteger('STAGE' + frmGame.PStage.Stage.Number.ToString, Player2, 0);
    Moves3 := IniFile.ReadInteger('STAGE' + frmGame.PStage.Stage.Number.ToString, Player3, 0);
    Moves4 := IniFile.ReadInteger('STAGE' + frmGame.PStage.Stage.Number.ToString, Player4, 0);
    Moves5 := IniFile.ReadInteger('STAGE' + frmGame.PStage.Stage.Number.ToString, Player5, 0);
  finally
    FreeAndNil(IniFile);
  end;

  if (Moves1 = 0) or (Moves < Moves1) then
    SaveIniRecord(FPlayerName, 1)
  else if (Moves2 = 0) or (Moves < Moves2) then
    SaveIniRecord(FPlayerName, 2)
  else if (Moves3 = 0) or (Moves < Moves3) then
    SaveIniRecord(FPlayerName, 3)
  else if (Moves4 = 0) or (Moves < Moves4) then
    SaveIniRecord(FPlayerName, 4)
  else if (Moves5 = 0) or (Moves < Moves5) then
    SaveIniRecord(FPlayerName, 5);
end;

procedure TfrmSokoBox.SavePlayerRecord(const PlayerName: string; const Moves: Integer);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(System.SysUtils.IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'playerrecord');
  try
    IniFile.WriteInteger('STAGE' + frmGame.PStage.Stage.Number.ToString, PlayerName, Moves);
  finally
    FreeAndNil(IniFile);
  end;
end;

procedure TfrmSokoBox.SaveIniRecord(const PlayerName: string; const Position: Integer);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(System.SysUtils.IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'records');
  try
    IniFile.WriteString('STAGE' + frmGame.PStage.Stage.Number.ToString, 'player' + Position.ToString, PlayerName);
  finally
    FreeAndNil(IniFile);
  end;
end;

procedure TfrmSokoBox.NextStage;
var
  IniFile: TIniFile;
begin
  if ((FStage + 1) <= FJSONS.Count) then
  begin
    FStage := Succ(FStage);

    IniFile := TIniFile.Create(System.SysUtils.IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'stage');
    try
      IniFile.WriteInteger('STAGE', FPlayerName, FStage);
    finally
      FreeAndNil(IniFile);
    end;

    pnlRestartClick(pnlRestart);
  end
  else CloseGame;
end;

procedure TfrmSokoBox.CloseGame;
begin
  if Assigned(frmGame) then
  begin
    FLoaded := False;
    frmGame.Close;
    FreeAndNil(frmGame);
    pnlRestart.Tag := 1;
  end;
end;

procedure TfrmSokoBox.Winner;
var
  frmWin: TfrmWin;
begin
  SaveRecord(frmGame.MoveCounts);
  frmWin := TfrmWin.Create(nil)
                    .PerfectMoves(FPerfectMoves)
                    .Moves(frmGame.MoveCounts);
  try
    frmWin.ShowModal;
    if frmWin.CloseGame then
      CloseGame
    else if frmWin.NextStage then
      NextStage
    else if frmWin.Again then
      pnlRestartClick(pnlRestart);
  finally
    FreeAndNil(frmWin);
  end;
end;

procedure TfrmSokoBox.CriaFormularioGame(lStage: TStage);
begin
  if Assigned(frmGame) then
  begin
    frmGame.Close;
    FreeAndNil(frmGame);
  end;

  frmGame := TfrmGame.Create(pnlBackGround);
  frmGame.Parent := pnlBackGround;
  frmGame.PStage := lStage;
  frmGame.MenuClose := MenuClose;
  frmGame.Moves := SetMoves;
  frmGame.Width := Trunc(33 * (lStage.Stage.X * 1.2));
  frmGame.Height := Trunc(33 * (lStage.Stage.Y * 1.2));
  frmGame.Initialize;
  frmGame.Show;
  FLoaded := True;
  LoadRecords;
end;

procedure TfrmSokoBox.CarregarImagens;
begin
  pngNew := TPngImage.Create;
  try
    pngNew.LoadFromResourceName(HInstance, 'new');
  finally
    imgNewGame.Picture.Graphic := pngNew;
  end;

  pngLoad := TPngImage.Create;
  try
    pngLoad.LoadFromResourceName(HInstance, 'save');
  finally
    imgLoad.Picture.Graphic := pngLoad;
  end;

  pngRestart := TPngImage.Create;
  try
    pngRestart.LoadFromResourceName(HInstance, 'restart');
  finally
    imgRestart.Picture.Graphic := pngRestart;
  end;

  pngExit := TPngImage.Create;
  try
    pngExit.LoadFromResourceName(HInstance, 'exit');
  finally
    imgExit.Picture.Graphic := pngExit;
  end;
end;

function TfrmSokoBox.Login: Boolean;
var
  frmLogin: TfrmLogin;
begin
  frmLogin := TfrmLogin.Create(nil);
  try
    frmLogin.MaxLength := 10;
    Result := (frmLogin.ShowModal = mrOk);
    if Result then
      FPlayerName := frmLogin.User.user.name;
  finally
    FreeAndNil(frmLogin);
  end;
end;

procedure TfrmSokoBox.FormShow(Sender: TObject);
begin
  if Login then
  begin
    FMoves := 0;
    CarregarImagens;
    FLoaded := False;
    FPerfectMoves := 0;
    FStage := 1;
    FJSONS := TObjectList<TStage>.Create;
    tmrLoadJSONS.Enabled := True;
    MenuClose;
    LoadEnabled;
  end
  else Close;
end;

procedure TfrmSokoBox.tmrLoadJSONSTimer(Sender: TObject);
begin
  tmrLoadJSONS.Enabled := False;
  LoadFromDirectory(System.SysUtils.IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Stages');
end;

function TfrmSokoBox.HaveAttr(const Attr, Val: Integer): Boolean;
begin
  Result := Attr and Val = Val;
end;

procedure TfrmSokoBox.imgExitMouseEnter(Sender: TObject);
begin
  if (pnlExit.Tag = 0) then
  begin
    pnlExit.Color := $0068F50A;
    pnlExit.Cursor := crDefault;
  end
  else
  begin
    pnlExit.Color := clSilver;
    pnlExit.Cursor := crNo;
  end;

  MenuOpen;
end;

procedure TfrmSokoBox.imgExitMouseLeave(Sender: TObject);
begin
  pnlExit.Color := clWhite;
  pnlExit.Cursor := crDefault;
end;

procedure TfrmSokoBox.imgLoadMouseEnter(Sender: TObject);
begin
  if (pnlLoad.Tag = 0) then
  begin
    pnlLoad.Color := $0068F50A;
    pnlLoad.Cursor := crDefault;
  end
  else
  begin
    pnlLoad.Color := clSilver;
    pnlLoad.Cursor := crNo;
  end;

  MenuOpen;
end;

procedure TfrmSokoBox.imgLoadMouseLeave(Sender: TObject);
begin
  pnlLoad.Color := clWhite;
  pnlLoad.Cursor := crDefault;
end;

procedure TfrmSokoBox.imgNewGameMouseEnter(Sender: TObject);
begin
  if (pnlNewGame.Tag = 0) then
  begin
    pnlNewGame.Color := $0068F50A;
    pnlNewGame.Cursor := crDefault;
  end
  else
  begin
    pnlNewGame.Color := clSilver;
    pnlNewGame.Cursor := crNo;
  end;

  MenuOpen;
end;

procedure TfrmSokoBox.imgNewGameMouseLeave(Sender: TObject);
begin
  pnlNewGame.Color := clWhite;
  pnlNewGame.Cursor := crDefault;
end;

procedure TfrmSokoBox.imgRestartMouseEnter(Sender: TObject);
begin
  if (pnlRestart.Tag = 0) then
  begin
    pnlRestart.Color := $0068F50A;
    pnlRestart.Cursor := crDefault;
  end
  else
  begin
    pnlRestart.Color := clSilver;
    pnlRestart.Cursor := crNo;
  end;

  MenuOpen;
end;

procedure TfrmSokoBox.imgRestartMouseLeave(Sender: TObject);
begin
  pnlRestart.Color := clWhite;
  pnlRestart.Cursor := crDefault;
end;

procedure TfrmSokoBox.LoadEnabled;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(System.SysUtils.IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'stage');
  try
    pnlLoad.Tag := ifThen(IniFile.ReadInteger('STAGE', FPlayerName, 1) > 1, 0, 1);
  finally
    FreeAndNil(IniFile);
  end;
end;

procedure TfrmSokoBox.LoadFromDirectory(const Value: string);
var
  F: TSearchRec;
  Ret: Integer;
begin
  Ret := FindFirst(Value + '\*.json', faAnyFile, F);
  try
    while (Ret = 0) do
    begin
      if not HaveAttr(F.Attr, faDirectory) then
      begin
        FJSONS.Add(TStage.FromJSONString(TStringBuilder.New
                                                       .LoadFromFile((Value + '\' + F.Name))
                                                       .ToString));
      end;

      Ret := FindNext(F);
    end;
  finally
    FindClose(F);
  end;

  FJSONS.TrimExcess;
end;

procedure TfrmSokoBox.LoadRecords;
var
  IniFile: TIniFile;
begin
  if FLoaded then
  begin
    IniFile := TIniFile.Create(System.SysUtils.IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'records');
    try
      pnlPlayer1.Caption := IniFile.ReadString('STAGE' + frmGame.PStage.Stage.Number.ToString, 'player1', EmptyStr);
      pnlPlayer2.Caption := IniFile.ReadString('STAGE' + frmGame.PStage.Stage.Number.ToString, 'player2', EmptyStr);
      pnlPlayer3.Caption := IniFile.ReadString('STAGE' + frmGame.PStage.Stage.Number.ToString, 'player3', EmptyStr);
      pnlPlayer4.Caption := IniFile.ReadString('STAGE' + frmGame.PStage.Stage.Number.ToString, 'player4', EmptyStr);
      pnlPlayer5.Caption := IniFile.ReadString('STAGE' + frmGame.PStage.Stage.Number.ToString, 'player5', EmptyStr);
    finally
      FreeAndNil(IniFile);
    end;

    IniFile := TIniFile.Create(System.SysUtils.IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'playerrecord');
    try
      pnlPlayer1.Caption := pnlPlayer1.Caption + ' - ' +
        IniFile.ReadInteger('STAGE' + frmGame.PStage.Stage.Number.ToString, pnlPlayer1.Caption, 0).ToString;
      pnlPlayer2.Caption := pnlPlayer2.Caption + ' - ' +
        IniFile.ReadInteger('STAGE' + frmGame.PStage.Stage.Number.ToString, pnlPlayer2.Caption, 0).ToString;
      pnlPlayer3.Caption := pnlPlayer3.Caption + ' - ' +
        IniFile.ReadInteger('STAGE' + frmGame.PStage.Stage.Number.ToString, pnlPlayer3.Caption, 0).ToString;
      pnlPlayer4.Caption := pnlPlayer4.Caption + ' - ' +
        IniFile.ReadInteger('STAGE' + frmGame.PStage.Stage.Number.ToString, pnlPlayer4.Caption, 0).ToString;
      pnlPlayer5.Caption := pnlPlayer5.Caption + ' - ' +
        IniFile.ReadInteger('STAGE' + frmGame.PStage.Stage.Number.ToString, pnlPlayer5.Caption, 0).ToString;
    finally
      FreeAndNil(IniFile);
    end;
  end;
end;

procedure TfrmSokoBox.BackGroundMouseEnter(Sender: TObject);
begin
  MenuClose;
end;

end.
