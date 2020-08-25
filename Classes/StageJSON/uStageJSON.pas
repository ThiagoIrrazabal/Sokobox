unit uStageJSON;

interface

uses
  System.Generics.Collections,
  Rest.JSON;

{$M+}

type
  TPlayerDTO = class
  private
    FX: Integer;
    FY: Integer;
  published
    property X: Integer read FX write FX;
    property Y: Integer read FY write FY;
  end;

  TGoalsDTO = class
  private
    FX: Integer;
    FY: Integer;
  published
    property X: Integer read FX write FX;
    property Y: Integer read FY write FY;
  end;

  TBoxesDTO = class
  private
    FX: Integer;
    FY: Integer;
  published
    property X: Integer read FX write FX;
    property Y: Integer read FY write FY;
  end;

  TBoxesGoalDTO = class
  private
    FX: Integer;
    FY: Integer;
  published
    property X: Integer read FX write FX;
    property Y: Integer read FY write FY;
  end;

  TFloorsDTO = class
  private
    FX: Integer;
    FY: Integer;
  published
    property X: Integer read FX write FX;
    property Y: Integer read FY write FY;
  end;

  TWallsDTO = class
  private
    FX: Integer;
    FY: Integer;
  published
    property X: Integer read FX write FX;
    property Y: Integer read FY write FY;
  end;

  TStageDTO = class
  private
    FBoxes: TArray<TBoxesDTO>;
    FBoxesGoal: TArray<TBoxesGoalDTO>;
    FFloors: TArray<TFloorsDTO>;
    FGoals: TArray<TGoalsDTO>;
    FNumber: Integer;
    FPlayer: TPlayerDTO;
    FWalls: TArray<TWallsDTO>;
    FX: Integer;
    FY: Integer;
    FPerfectMoves: Integer;
  published
    property Boxes: TArray<TBoxesDTO> read FBoxes write FBoxes;
    property BoxesGoal: TArray<TBoxesGoalDTO> read FBoxesGoal write FBoxesGoal;
    property Floors: TArray<TFloorsDTO> read FFloors write FFloors;
    property Goals: TArray<TGoalsDTO> read FGoals write FGoals;
    property Number: Integer read FNumber write FNumber;
    property Player: TPlayerDTO read FPlayer write FPlayer;
    property PerfectMoves: Integer read FPerfectMoves write FPerfectMoves;
    property Walls: TArray<TWallsDTO> read FWalls write FWalls;
    property X: Integer read FX write FX;
    property Y: Integer read FY write FY;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddWall(const X, Y: Integer);
    procedure AddFloor(const X, Y: Integer);
    procedure AddBox(const X, Y: Integer);
    procedure AddBoxGoal(const X, Y: Integer);
    procedure AddGoal(const X, Y: Integer);
    procedure AddPlayer(const X, Y: Integer);
  end;

  TStage = class
  private
    FStage: TStageDTO;
  published
    property Stage: TStageDTO read FStage write FStage;
  public
    constructor Create;
    destructor Destroy; override;
    function ToJSONString: string;
    class function FromJSONString(const JSON: string): TStage;
  end;

implementation

{ TStageDTO }

procedure TStageDTO.AddBox(const X, Y: Integer);
begin
  SetLength(FBoxes, Length(FBoxes) + 1);
  FBoxes[Length(FBoxes) - 1] := TBoxesDTO.Create;
  FBoxes[Length(FBoxes) - 1].FX := X;
  FBoxes[Length(FBoxes) - 1].FY := Y;
end;

procedure TStageDTO.AddBoxGoal(const X, Y: Integer);
begin
  SetLength(FBoxesGoal, Length(FBoxesGoal) + 1);
  FBoxesGoal[Length(FBoxesGoal) - 1] := TBoxesGoalDTO.Create;
  FBoxesGoal[Length(FBoxesGoal) - 1].FX := X;
  FBoxesGoal[Length(FBoxesGoal) - 1].FY := Y;
end;

procedure TStageDTO.AddFloor(const X, Y: Integer);
begin
  SetLength(FFloors, Length(FFloors) + 1);
  FFloors[Length(FFloors) - 1] := TFloorsDTO.Create;
  FFloors[Length(FFloors) - 1].FX := X;
  FFloors[Length(FFloors) - 1].FY := Y;
end;

procedure TStageDTO.AddGoal(const X, Y: Integer);
begin
  SetLength(FGoals, Length(FGoals) + 1);
  FGoals[Length(FGoals) - 1] := TGoalsDTO.Create;
  FGoals[Length(FGoals) - 1].FX := X;
  FGoals[Length(FGoals) - 1].FY := Y;
end;

procedure TStageDTO.AddPlayer(const X, Y: Integer);
begin
  FPlayer.FX := X;
  FPlayer.FY := Y;
end;

procedure TStageDTO.AddWall(const X, Y: Integer);
begin
  SetLength(FWalls, Length(FWalls) + 1);
  FWalls[Length(FWalls) - 1] := TWallsDTO.Create;
  FWalls[Length(FWalls) - 1].FX := X;
  FWalls[Length(FWalls) - 1].FY := Y;
end;

constructor TStageDTO.Create;
begin
  inherited;
  FPlayer := TPlayerDTO.Create;
end;

destructor TStageDTO.Destroy;
var
  Element: TObject;
begin
  FPlayer.Free;
  for Element in FWalls do
    Element.Free;
  for Element in FFloors do
    Element.Free;
  for Element in FBoxes do
    Element.Free;
  for Element in FGoals do
    Element.Free;
  for Element in FBoxesGoal do
    Element.Free;
  inherited;
end;

{ TStage }

constructor TStage.Create;
begin
  inherited;
  FStage := TStageDTO.Create;
end;

destructor TStage.Destroy;
begin
  FStage.Free;
  inherited;
end;

class function TStage.FromJSONString(const JSON: string): TStage;
begin
  Result := TJson.JsonToObject<TStage>(JSON);
end;

function TStage.ToJSONString: string;
begin
  Result := TJson.ObjectToJsonString(Self);
end;

end.
