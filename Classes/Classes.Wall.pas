unit Classes.Wall;

interface

uses
  Interfaces.Wall,
  Vcl.ExtCtrls,
  System.Classes,
  System.Types,
  Vcl.Imaging.pngimage,
  Vcl.Controls;

type
  TWall = class(TInterfacedObject, IWall)
  strict private
  var
    FPosition: TPoint;
    FImage: TImage;
    FOwner: TGridPanel;
    png: TPngImage;
  public
    class function New(const AOwner: TGridPanel): IWall;
    destructor Destroy; override;
    function Position(const Value: TPoint): IWall; overload;
    function Position: TPoint; overload;
    function Owner(const Value: TGridPanel): IWall; overload;
    function Owner: TGridPanel; overload;
    function CreateImages: IWall;
  end;

implementation

uses
  System.SysUtils;

{ TWall }

function TWall.CreateImages: IWall;
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
  png.LoadFromResourceName(HInstance, 'wall');
  FImage.Picture.Graphic := png;
end;

destructor TWall.Destroy;
begin
  FOwner.ControlCollection.RemoveControl(FImage);
  FreeAndNil(FImage);
  if Assigned(png) then
    FreeAndNil(png);
  inherited;
end;

class function TWall.New(const AOwner: TGridPanel): IWall;
begin
  Result := Self.Create;
  Result.Owner(AOwner);
end;

function TWall.Owner: TGridPanel;
begin
  Result := FOwner;
end;

function TWall.Owner(const Value: TGridPanel): IWall;
begin
  Result := Self;
  FOwner := Value;
end;

function TWall.Position(const Value: TPoint): IWall;
begin
  Result := Self;
  FPosition := Value;
end;

function TWall.Position: TPoint;
begin
  Result := FPosition;
end;

end.
