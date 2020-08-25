unit Classes.Box;

interface

uses
  Interfaces.Box,
  Vcl.ExtCtrls,
  System.Classes,
  System.Types,
  Vcl.Imaging.pngimage,
  Vcl.Controls;

type
  TBox = class(TInterfacedObject, IBox)
  strict private
  var
    FPosition: TPoint;
    FImage: TImage;
    FOwner: TGridPanel;
    png: TPngImage;
    FKey: Integer;
  public
    class function New(const AOwner: TGridPanel): IBox;
    destructor Destroy; override;
    function Position(const Value: TPoint): IBox; overload;
    function Position: TPoint; overload;
    function Owner(const Value: TGridPanel): IBox; overload;
    function Owner: TGridPanel; overload;
    function Key(const Value: Integer): IBox; overload;
    function Key: Integer; overload;
    function CreateImages: IBox;
    function ChangeParent: IBox;
  end;

implementation

uses
  System.SysUtils;

{ TBox }

function TBox.ChangeParent: IBox;
var
  Panel: TWinControl;
begin
  Result := Self;
  Panel := TWinControl(FOwner.ControlCollection.Controls[FPosition.X - 1, FPosition.Y - 1]);
  FImage.Parent := Panel;
end;

function TBox.CreateImages: IBox;
begin
  Result := Self;
  FImage := TImage.Create(nil);
  FImage.Parent := TWinControl(FOwner.ControlCollection.Controls[FPosition.X - 1, FPosition.Y - 1]);
  FImage.Align := alClient;
  if Assigned(png) then
    FreeAndNil(png);
  png := TPngImage.Create;
  png.LoadFromResourceName(HInstance, 'box');
  FImage.Picture.Graphic := png;
end;

destructor TBox.Destroy;
begin
  FOwner.ControlCollection.RemoveControl(FImage);
  FreeAndNil(FImage);
  if Assigned(png) then
    FreeAndNil(png);
  inherited;
end;

function TBox.Key: Integer;
begin
  Result := FKey;
end;

function TBox.Key(const Value: Integer): IBox;
begin
  Result := Self;
  FKey := Value;
end;

class function TBox.New(const AOwner: TGridPanel): IBox;
begin
  Result := Self.Create;
  Result.Owner(AOwner);
end;

function TBox.Owner: TGridPanel;
begin
  Result := FOwner;
end;

function TBox.Owner(const Value: TGridPanel): IBox;
begin
  Result := Self;
  FOwner := Value;
end;

function TBox.Position(const Value: TPoint): IBox;
begin
  Result := Self;
  FPosition := Value;
end;

function TBox.Position: TPoint;
begin
  Result := FPosition;
end;

end.
