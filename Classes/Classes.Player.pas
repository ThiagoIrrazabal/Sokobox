unit Classes.Player;

interface

uses
  Interfaces.Player,
  Vcl.ExtCtrls,
  System.Classes,
  System.Types,
  Vcl.Imaging.pngimage,
  Vcl.Controls;

type
  TPlayer = class(TInterfacedObject, IPlayer)
  strict private
  var
    FPosition: TPoint;
    FImage: TImage;
    FOwner: TGridPanel;
    FDirection: TPlayerDirection;
    png: TPngImage;
  public
    class function New(const AOwner: TGridPanel): IPlayer;
    destructor Destroy; override;
    function Position(const Value: TPoint): IPlayer; overload;
    function Position: TPoint; overload;
    function Owner(const Value: TGridPanel): IPlayer; overload;
    function Owner: TGridPanel; overload;
    function Direction(const Value: TPlayerDirection): IPlayer; overload;
    function Direction: TPlayerDirection; overload;
    function CreateImages: IPlayer;
    function ChangeImage: IPlayer;
    function ChangeParent: IPlayer;
  end;

implementation

uses
  System.SysUtils;

{ TPlayer }

function TPlayer.ChangeImage: IPlayer;
begin
  Result := Self;
  if Assigned(png) then
    FreeAndNil(png);
  png := TPngImage.Create;
  case FDirection of
    tpdUP: png.LoadFromResourceName(HInstance, 'up');
    tpdDOWN: png.LoadFromResourceName(HInstance, 'down');
    tpdLEFT: png.LoadFromResourceName(HInstance, 'left');
    tpdRIGHT: png.LoadFromResourceName(HInstance, 'right');
  end;
  FImage.Picture.Graphic := png;
end;

function TPlayer.ChangeParent: IPlayer;
var
  Panel: TWinControl;
begin
  Result := Self;
  Panel := TWinControl(FOwner.ControlCollection.Controls[FPosition.X - 1, FPosition.Y - 1]);
  FImage.Parent := Panel;
end;

function TPlayer.CreateImages: IPlayer;
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
  png.LoadFromResourceName(HInstance, 'down');
  FImage.Picture.Graphic := png;
end;

destructor TPlayer.Destroy;
begin
  FOwner.ControlCollection.RemoveControl(FImage);
  FreeAndNil(FImage);
  if Assigned(png) then
    FreeAndNil(png);
  inherited;
end;

function TPlayer.Direction: TPlayerDirection;
begin
  Result := FDirection;
end;

function TPlayer.Direction(const Value: TPlayerDirection): IPlayer;
begin
  Result := Self;
  FDirection := Value;
end;

class function TPlayer.New(const AOwner: TGridPanel): IPlayer;
begin
  Result := Self.Create;
  Result.Owner(AOwner);
end;

function TPlayer.Owner: TGridPanel;
begin
  Result := FOwner;
end;

function TPlayer.Owner(const Value: TGridPanel): IPlayer;
begin
  Result := Self;
  FOwner := Value;
end;

function TPlayer.Position(const Value: TPoint): IPlayer;
begin
  Result := Self;
  FPosition := Value;
end;

function TPlayer.Position: TPoint;
begin
  Result := FPosition;
end;

end.
