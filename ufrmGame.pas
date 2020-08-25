unit ufrmGame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, System.Generics.Collections,
  Interfaces.Wall, Classes.Wall, Interfaces.Floor, Classes.Floor, Interfaces.Box, Classes.Box,
  Interfaces.Goal, Classes.Goal, Interfaces.Box.Goal, Classes.Box.Goal,
  Interfaces.Player, Classes.Player, uStageJSON;

type
  TMenuClose = procedure of Object;
  TSetMoves = procedure(const Value: Integer) of Object;

  TfrmGame = class(TForm)
    BackGround: TGridPanel;
    procedure FormMouseEnter(Sender: TObject);
    procedure BackGroundMouseEnter(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  var
    FMenuClose: TMenuClose;
    FWalls: TObjectDictionary<Integer, IWall>;
    FFloors: TObjectDictionary<Integer, IFloor>;
    FBoxs: TObjectDictionary<Integer, IBox>;
    FBoxsGoal: TObjectDictionary<Integer, IBoxGoal>;
    FGoals: TObjectDictionary<Integer, IGoal>;
    FPanels: TObjectDictionary<Integer, TPanel>;
    FPlayer: IPlayer;
    FMoves: TSetMoves;
    FMoveCount: Integer;
    FPStage: TStage;
    function IsBox(const Position: TPoint): IBox;
    function IsBoxGoal(const Position: TPoint): IBoxGoal;
    function IsFloor(const Position: TPoint): Boolean;
    function IsWall(const Position: TPoint): Boolean;
    function IsGoal(const Position: TPoint): Boolean;
    procedure CleanBackGround;
    procedure CleanDictionarys;
    procedure CreateDictionarys;
    procedure PlayerMove(const Player: IPlayer;
      const Position: TPoint);
    procedure ArredondarComponente(Componente: TWinControl;
      const Radius: SmallInt);
    procedure CreatPanels(const X, Y: Int16);
    procedure CreateFloors(const Stage: TStage);
    procedure CreateWalls(const Stage: TStage);
    procedure CreateBoxes(const Stage: TStage);
    procedure CreateBoxesGoals(const Stage: TStage);
    procedure CreateGoals(const Stage: TStage);
    procedure CreatePlayer(const Stage: TStage);
    procedure NewBackGround(const X, Y: Int16);
    procedure LoadStage(const Stage: TStage);
    { Private declarations }
  public
    { Public declarations }
    function Winner: Boolean;
    function MoveCounts: Integer;
    procedure Initialize;
    procedure ChangeSquare(const Direction: TPlayerDirection);
    property MenuClose: TMenuClose read FMenuClose write FMenuClose;
    property MoveCount: Integer read FMoveCount write FMoveCount;
    property Moves: TSetMoves read FMoves write FMoves;
    property PStage: TStage read FPStage write FPStage;
  end;

var
  frmGame: TfrmGame;

implementation

{$R *.dfm}

procedure TfrmGame.ChangeSquare(const Direction: TPlayerDirection);
var
  PlayerPosition, BoxPosition: TPoint;
  Box: IBox;
  BoxGoal: IBoxGoal;
begin
  FPlayer.Direction(Direction).ChangeImage;
  PlayerPosition.X := FPlayer.Position.X;
  PlayerPosition.Y := FPlayer.Position.Y;
  BoxPosition.X := FPlayer.Position.X;
  BoxPosition.Y := FPlayer.Position.Y;
  case Direction of
    tpdUP:
      begin
        PlayerPosition.Y := PlayerPosition.Y -1;
        BoxPosition.Y := PlayerPosition.Y -1;
      end;

    tpdDOWN:
      begin
        PlayerPosition.Y := PlayerPosition.Y +1;
        BoxPosition.Y := PlayerPosition.Y +1;
      end;

    tpdLEFT:
      begin
        PlayerPosition.X := PlayerPosition.X -1;
        BoxPosition.X := PlayerPosition.X -1;
      end;

    tpdRIGHT:
      begin
        PlayerPosition.X := PlayerPosition.X +1;
        BoxPosition.X := PlayerPosition.X +1;
      end;
  end;

  if (IsFloor(PlayerPosition)) then
  begin
    Box := IsBox(PlayerPosition);
    if Assigned(Box) then
    begin
      BoxGoal := IsBoxGoal(BoxPosition);
      if (IsFloor(BoxPosition) and
        not(IsGoal(BoxPosition)) and
        not(Assigned(IsBox(BoxPosition))) and
        not(Assigned(BoxGoal))) then
      begin
        Box.Position(BoxPosition)
           .ChangeParent;
        PlayerMove(FPlayer, PlayerPosition);
      end
      else if (IsGoal(BoxPosition) and
        not(Assigned(BoxGoal))) then
      begin
        FBoxs.Items[Box.Key] := nil;
        FBoxs.Remove(Box.Key);
        FBoxsGoal.Add(FBoxsGoal.Count + 1, TBoxGoal.New(BackGround).Key(FBoxsGoal.Count + 1).Position(BoxPosition).CreateImages);
        PlayerMove(FPlayer, PlayerPosition);
      end;
    end
    else
    begin
      BoxGoal := IsBoxGoal(PlayerPosition);
      if (Assigned(BoxGoal) and
        IsGoal(BoxPosition) and
        not(Assigned(IsBoxGoal(BoxPosition)))) then
      begin
        BoxGoal.Position(BoxPosition)
               .ChangeParent;
        PlayerMove(FPlayer, PlayerPosition);
      end
      else if (Assigned(BoxGoal) and
        not IsGoal(BoxPosition) and
        not IsWall(BoxPosition) and
        not(Assigned(IsBoxGoal(BoxPosition)))) then
      begin
        FBoxsGoal.Items[BoxGoal.Key] := nil;
        FBoxsGoal.Remove(BoxGoal.Key);
        FBoxs.Add(FBoxs.Count + 1, TBox.New(BackGround).Key(FBoxs.Count + 1).Position(BoxPosition).CreateImages);
        PlayerMove(FPlayer, PlayerPosition);
      end
      else if not(Assigned(BoxGoal)) then
        PlayerMove(FPlayer, PlayerPosition);
    end;

    FBoxsGoal.TrimExcess;
    FBoxs.TrimExcess;
  end;
end;

procedure TfrmGame.CleanBackGround;
var
  I: Integer;
begin
  for I := FWalls.Count - 1 downto 0 do
  begin
    FWalls.Remove(I);
  end;

  for I := FFloors.Count - 1 downto 0 do
  begin
    FFloors.Remove(I);
  end;

  for I := 0 to FBoxs.Count - 1 do
  begin
    FBoxs.Remove(I);
  end;

  for I := FBoxsGoal.Count - 1 downto 0 do
  begin
    FBoxsGoal.Remove(I);
  end;

  for I := FGoals.Count - 1 downto 0 do
  begin
    FGoals.Remove(I);
  end;

  for I := FPanels.Count - 1 downto 0 do
  begin
    FPanels.Items[I].Free;
    FPanels.Remove(I);
  end;

  CleanDictionarys;
  CreateDictionarys;
  BackGround.RowCollection.BeginUpdate;
  try
    BackGround.RowCollection.Clear;
  finally
    BackGround.RowCollection.EndUpdate;
  end;

  BackGround.ColumnCollection.BeginUpdate;
  try
    BackGround.ColumnCollection.Clear;
  finally
    BackGround.ColumnCollection.EndUpdate;
  end;
end;

procedure TfrmGame.CleanDictionarys;
begin
  FreeAndNil(FWalls);
  FreeAndNil(FFloors);
  FreeAndNil(FBoxs);
  FreeAndNil(FPanels);
  FreeAndNil(FGoals);
  FreeAndNil(FBoxsGoal);
end;

procedure TfrmGame.CreateBoxes(const Stage: TStage);
var
  Index: Integer;
  Pos: TPoint;
  Box: TBoxesDTO;
begin
  Index := 0;
  for Box in Stage.Stage.Boxes do
  begin
    Pos.X := Box.X;
    Pos.Y := Box.Y;
    FBoxs.Add(Index, TBox.New(BackGround).Key(Index).Position(Pos).CreateImages);
    Index := Succ(Index);
  end;
  FBoxs.TrimExcess;
end;

procedure TfrmGame.CreateBoxesGoals(const Stage: TStage);
var
  Index: Integer;
  Pos: TPoint;
  BoxGoal: TBoxesGoalDTO;
begin
  Index := 0;
  for BoxGoal in Stage.Stage.BoxesGoal do
  begin
    Pos.X := BoxGoal.X;
    Pos.Y := BoxGoal.Y;
    FBoxsGoal.Add(Index, TBoxGoal.New(BackGround).Key(Index).Position(Pos).CreateImages);
    Index := Succ(Index);
  end;
  FBoxsGoal.TrimExcess;
end;

procedure TfrmGame.CreateDictionarys;
begin
  FWalls := TObjectDictionary<Integer, IWall>.Create;
  FFloors := TObjectDictionary<Integer, IFloor>.Create;
  FBoxs := TObjectDictionary<Integer, IBox>.Create;
  FPanels := TObjectDictionary<Integer, TPanel>.Create;
  FGoals := TObjectDictionary<Integer, IGoal>.Create;
  FBoxsGoal := TObjectDictionary<Integer, IBoxGoal>.Create;
end;

procedure TfrmGame.CreateFloors(const Stage: TStage);
var
  Index: Integer;
  Pos: TPoint;
  Floor: TFloorsDTO;
begin
  Index := 0;
  for Floor in Stage.Stage.Floors do
  begin
    Pos.X := Floor.X;
    Pos.Y := Floor.Y;
    FFloors.Add(Index, TFloor.New(BackGround).Position(Pos).CreateImages);
    Index := Succ(Index);
  end;
  FFloors.TrimExcess;
end;

procedure TfrmGame.CreateGoals(const Stage: TStage);
var
  Index: Integer;
  Pos: TPoint;
  Goal: TGoalsDTO;
begin
  Index := 0;
  for Goal in Stage.Stage.Goals do
  begin
    Pos.X := Goal.X;
    Pos.Y := Goal.Y;
    FGoals.Add(Index, TGoal.New(BackGround).Position(Pos).CreateImages);
    Index := Succ(Index);
  end;
  FGoals.TrimExcess;
end;

procedure TfrmGame.CreatePlayer(const Stage: TStage);
var
  Pos: TPoint;
begin
  Pos.X := Stage.Stage.Player.X;
  Pos.Y := Stage.Stage.Player.Y;
  FPlayer := TPlayer.New(BackGround)
                    .Position(Pos)
                    .Direction(TPlayerDirection.tpdDOWN)
                    .CreateImages;
end;

procedure TfrmGame.CreateWalls(const Stage: TStage);
var
  Index: Integer;
  Pos: TPoint;
  Wall: TWallsDTO;
begin
  Index := 0;
  for Wall in Stage.Stage.Walls do
  begin
    Pos.X := Wall.X;
    Pos.Y := Wall.Y;
    FWalls.Add(Index, TWall.New(BackGround).Position(Pos).CreateImages);
    Index := Succ(Index);
  end;
  FWalls.TrimExcess;
end;

procedure TfrmGame.CreatPanels(const X, Y: Int16);
var
  lRows, lColumns, Key: Integer;
  Panel: TPanel;

  function NewPanel: TPanel;
  begin
    Result := TPanel.Create(BackGround);
    Result.BevelOuter := bvNone;
    Result.Width := 33;
    Result.Height := 33;
  end;
begin
  Key := 0;
  for lColumns := 0 to X - 1 do
  begin
    for lRows := 0 to Y - 1 do
    begin
      Panel := NewPanel;
      Panel.Align := alClient;
      Panel.Parent := BackGround;
      FPanels.Add(Key, Panel);
      Key := Succ(Key);
    end;
  end;
end;

procedure TfrmGame.ArredondarComponente(Componente: TWinControl;
  const Radius: SmallInt);
var
  R: TRect;
  Rgn: HRGN;
begin
  with Componente do
  begin
    R := ClientRect;
    Rgn := CreateRoundRectRgn(R.Left, R.Top, R.Right, R.Bottom, Radius, Radius);
    Perform(EM_GETRECT, 0, lParam(@R));
    InflateRect(R, -1, -1);
    Perform(EM_SETRECTNP, 0, lParam(@R));
    SetWindowRgn(Handle, Rgn, True);
    Invalidate;
  end;
end;

procedure TfrmGame.BackGroundMouseEnter(Sender: TObject);
begin
  MenuClose;
end;

procedure TfrmGame.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CleanDictionarys;
  FPlayer := nil;
end;

procedure TfrmGame.FormMouseEnter(Sender: TObject);
begin
  MenuClose;
end;

procedure TfrmGame.Initialize;
var
  Panel: TPanel;
begin
  CreateDictionarys;
  FMoveCount := 0;
  Moves(FMoveCount);
  CleanBackGround;
  NewBackGround(FPStage.Stage.X, FPStage.Stage.Y);
  CreatPanels(FPStage.Stage.X, FPStage.Stage.Y);
  LoadStage(FPStage);
  for Panel in FPanels.Values do
    ArredondarComponente(Panel, 5);
end;

function TfrmGame.IsBox(const Position: TPoint): IBox;
var
  Box: IBox;
begin
  Result := nil;
  for Box in FBoxs.Values do
  begin
    if ((Box.Position.X = Position.X) and (Box.Position.Y = Position.Y)) then
      Exit(Box);
  end;
end;

function TfrmGame.IsBoxGoal(const Position: TPoint): IBoxGoal;
var
  BoxGoal: IBoxGoal;
begin
  Result := nil;
  for BoxGoal in FBoxsGoal.Values do
  begin
    if ((BoxGoal.Position.X = Position.X) and (BoxGoal.Position.Y = Position.Y)) then
      Exit(BoxGoal);
  end;
end;

function TfrmGame.IsFloor(const Position: TPoint): Boolean;
var
  Floor: IFloor;
begin
  Result := False;
  for Floor in FFloors.Values do
  begin
    if ((Floor.Position.X = Position.X) and (Floor.Position.Y = Position.Y)) then
      Exit(True);
  end;
end;

function TfrmGame.IsGoal(const Position: TPoint): Boolean;
var
  Goal: IGoal;
begin
  Result := False;
  for Goal in FGoals.Values do
  begin
    if ((Goal.Position.X = Position.X) and (Goal.Position.Y = Position.Y)) then
      Exit(True);
  end;
end;

function TfrmGame.IsWall(const Position: TPoint): Boolean;
var
  Wall: IWall;
begin
  Result := False;
  for Wall in FWalls.Values do
  begin
    if ((Wall.Position.X = Position.X) and (Wall.Position.Y = Position.Y)) then
      Exit(True);
  end;
end;

procedure TfrmGame.LoadStage(const Stage: TStage);
begin
  BackGround.RowCollection.BeginUpdate;
  try
    BackGround.ColumnCollection.BeginUpdate;
    try
      CreateFloors(Stage);
      CreateWalls(Stage);
      CreateBoxes(Stage);
      CreateBoxesGoals(Stage);
      CreateGoals(Stage);
      CreatePlayer(Stage);
    finally
      BackGround.ColumnCollection.EndUpdate;
    end;
  finally
    BackGround.RowCollection.EndUpdate;
  end;
end;

function TfrmGame.MoveCounts: Integer;
begin
  Result := FMoveCount;
end;

procedure TfrmGame.NewBackGround(const X, Y: Int16);
var
  lRows, lColumns: Integer;
begin
  BackGround.ColumnCollection.BeginUpdate;
  try
    for lColumns := 0 to X - 1 do
    begin
      with BackGround.ColumnCollection.Add do
      begin
        SizeStyle := ssAbsolute;
        Value := 33;
      end;
    end;
  finally
    BackGround.ColumnCollection.EndUpdate;
  end;

  BackGround.RowCollection.BeginUpdate;
  try
    for lRows := 0 to Y - 1 do
    begin
      with BackGround.RowCollection.Add do
      begin
        SizeStyle := ssAbsolute;
        Value := 33;
      end;
    end;
  finally
    BackGround.RowCollection.EndUpdate;
  end;
end;

procedure TfrmGame.PlayerMove(const Player: IPlayer;
  const Position: TPoint);
begin
  Player.Position(Position)
        .ChangeParent;
  FMoveCount := Succ(FMoveCount);
  Moves(FMoveCount);
end;

function TfrmGame.Winner: Boolean;
begin
  Result := (FBoxsGoal.Count = FGoals.Count);
end;

end.
