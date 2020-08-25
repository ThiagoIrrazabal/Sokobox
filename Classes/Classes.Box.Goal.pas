unit Classes.Box.Goal;

interface

uses
  Interfaces.Box.Goal,
  Vcl.ExtCtrls,
  System.Classes,
  System.Types,
  Vcl.Imaging.pngimage,
  Vcl.Controls;

type
  TBoxGoal = class(TInterfacedObject, IBoxGoal)
  strict private
  var
    FPosition: TPoint;
    FImage: TImage;
    FOwner: TGridPanel;
    png: TPngImage;
    FKey: Integer;
  public
    class function New(const AOwner: TGridPanel): IBoxGoal;
    destructor Destroy; override;
    function Position(const Value: TPoint): IBoxGoal; overload;
    function Position: TPoint; overload;
    function Owner(const Value: TGridPanel): IBoxGoal; overload;
    function Owner: TGridPanel; overload;
    function Key(const Value: Integer): IBoxGoal; overload;
    function Key: Integer; overload;
    function CreateImages: IBoxGoal;
    function ChangeParent: IBoxGoal;
  end;

implementation

uses
  System.SysUtils;

{ TBoxGoal }

function TBoxGoal.ChangeParent: IBoxGoal;
var
  Panel: TWinControl;
begin
  Result := Self;
  Panel := TWinControl(FOwner.ControlCollection.Controls[FPosition.X - 1, FPosition.Y - 1]);
  FImage.Parent := Panel;
end;

function TBoxGoal.CreateImages: IBoxGoal;
var
  Panel: TWinControl;
begin
  Result := Self;
  Panel := TWinControl(FOwner.ControlCollection.Controls[FPosition.X - 1, FPosition.Y - 1]);
  FImage := TImage.Create(Panel);
  FImage.Parent := Panel;
  FImage.Align := alClient;
  if Assigned(png) then
    FreeAndNil(png);
  png := TPngImage.Create;
  png.LoadFromResourceName(HInstance, 'boxgoal');
  FImage.Picture.Graphic := png;
end;

destructor TBoxGoal.Destroy;
begin
  FOwner.ControlCollection.RemoveControl(FImage);
  FreeAndNil(FImage);
  if Assigned(png) then
    FreeAndNil(png);
  inherited;
end;

function TBoxGoal.Key: Integer;
begin
  Result := FKey;
end;

function TBoxGoal.Key(const Value: Integer): IBoxGoal;
begin
  Result := Self;
  FKey := Value;
end;

class function TBoxGoal.New(const AOwner: TGridPanel): IBoxGoal;
begin
  Result := Self.Create;
  Result.Owner(AOwner);
end;

function TBoxGoal.Owner: TGridPanel;
begin
  Result := FOwner;
end;

function TBoxGoal.Owner(const Value: TGridPanel): IBoxGoal;
begin
  Result := Self;
  FOwner := Value;
end;

function TBoxGoal.Position(const Value: TPoint): IBoxGoal;
begin
  Result := Self;
  FPosition := Value;
end;

function TBoxGoal.Position: TPoint;
begin
  Result := FPosition;
end;

end.
