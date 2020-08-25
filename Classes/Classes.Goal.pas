unit Classes.Goal;

interface

uses
  Interfaces.Goal,
  Vcl.ExtCtrls,
  System.Classes,
  System.Types,
  Vcl.Imaging.pngimage,
  Vcl.Controls;

type
  TGoal = class(TInterfacedObject, IGoal)
  strict private
  var
    FPosition: TPoint;
    FImage: TImage;
    FOwner: TGridPanel;
    png: TPngImage;
  public
    class function New(const AOwner: TGridPanel): IGoal;
    destructor Destroy; override;
    function Position(const Value: TPoint): IGoal; overload;
    function Position: TPoint; overload;
    function Owner(const Value: TGridPanel): IGoal; overload;
    function Owner: TGridPanel; overload;
    function CreateImages: IGoal;
  end;

implementation

uses
  System.SysUtils;

{ TGoal }

function TGoal.CreateImages: IGoal;
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
  png.LoadFromResourceName(HInstance, 'goal');
  FImage.Picture.Graphic := png;
end;

destructor TGoal.Destroy;
begin
  FOwner.ControlCollection.RemoveControl(FImage);
  FreeAndNil(FImage);
  if Assigned(png) then
    FreeAndNil(png);
  inherited;
end;

class function TGoal.New(const AOwner: TGridPanel): IGoal;
begin
  Result := Self.Create;
  Result.Owner(AOwner);
end;

function TGoal.Owner: TGridPanel;
begin
  Result := FOwner;
end;

function TGoal.Owner(const Value: TGridPanel): IGoal;
begin
  Result := Self;
  FOwner := Value;
end;

function TGoal.Position(const Value: TPoint): IGoal;
begin
  Result := Self;
  FPosition := Value;
end;

function TGoal.Position: TPoint;
begin
  Result := FPosition;
end;

end.
