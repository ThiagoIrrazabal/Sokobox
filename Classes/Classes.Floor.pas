unit Classes.Floor;

interface

uses
  Interfaces.Floor,
  Vcl.ExtCtrls,
  System.Classes,
  System.Types,
  Vcl.Imaging.pngimage,
  Vcl.Controls;

type
  TFloor = class(TInterfacedObject, IFloor)
  strict private
  var
    FPosition: TPoint;
    FImage: TImage;
    FOwner: TGridPanel;
    FGoal: Boolean;
    png: TPngImage;
  public
    class function New(const AOwner: TGridPanel): IFloor;
    destructor Destroy; override;
    function Position(const Value: TPoint): IFloor; overload;
    function Position: TPoint; overload;
    function Goal(const Value: Boolean): IFloor; overload;
    function Goal: Boolean; overload;
    function Owner(const Value: TGridPanel): IFloor; overload;
    function Owner: TGridPanel; overload;
    function CreateImages: IFloor;
  End;

implementation

uses
  System.SysUtils, Vcl.Graphics;

{ TFloor }

function TFloor.CreateImages: IFloor;
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
  png.LoadFromResourceName(HInstance, 'floor');
  FImage.Picture.Graphic := png;
end;

destructor TFloor.Destroy;
begin
  FOwner.ControlCollection.RemoveControl(FImage);
  FreeAndNil(FImage);
  if Assigned(png) then
    FreeAndNil(png);
  inherited;
end;

function TFloor.Goal: Boolean;
begin
  Result := FGoal;
end;

class function TFloor.New(const AOwner: TGridPanel): IFloor;
begin
  Result := Self.Create;
  Result.Owner(AOwner);
end;

function TFloor.Goal(const Value: Boolean): IFloor;
begin
  Result := Self;
end;

function TFloor.Owner: TGridPanel;
begin
  Result := FOwner;
end;

function TFloor.Owner(const Value: TGridPanel): IFloor;
begin
  Result := Self;
  FOwner := Value;
end;

function TFloor.Position(const Value: TPoint): IFloor;
begin
  Result := Self;
  FPosition := Value;
end;

function TFloor.Position: TPoint;
begin
  Result := FPosition;
end;

end.
