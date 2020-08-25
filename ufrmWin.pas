unit ufrmWin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Imaging.pngimage;

type
  TfrmWin = class(TForm)
    pnlBorder: TPanel;
    pnlBackGround: TPanel;
    lblCongratulations: TLabel;
    grpImages: TGridPanel;
    pnl1Star: TPanel;
    pnl2Star: TPanel;
    Panel1: TPanel;
    img1Star: TImage;
    img2Star: TImage;
    img3Star: TImage;
    pnlBottons: TGridPanel;
    pnlAgain: TPanel;
    pnlNext: TPanel;
    pnlImgNext: TPanel;
    imgNext: TImage;
    pnlImgAgain: TPanel;
    imgAgain: TImage;
    procedure FormShow(Sender: TObject);
    procedure imgAgainMouseEnter(Sender: TObject);
    procedure imgAgainMouseLeave(Sender: TObject);
    procedure imgNextMouseLeave(Sender: TObject);
    procedure imgNextMouseEnter(Sender: TObject);
    procedure imgNextClick(Sender: TObject);
    procedure imgAgainClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FPerfectMoves: Integer;
    FMoves: Integer;
    FNextStage: Boolean;
    FCloseGame: Boolean;
    FAgain: Boolean;
    FPngRestart,
    FPngNext,
    FPng1Star,
    FPng2Star,
    FPng3Star: TPngImage;
    procedure FillStarts(const Star1, Star2, Star3: Boolean);
  public
    { Public declarations }
    function PerfectMoves(const Value: Integer): TfrmWin; overload;
    function PerfectMoves: Integer; overload;
    function Moves(const Value: Integer): TfrmWin; overload;
    function Moves: Integer; overload;
    property NextStage: Boolean read FNextStage write FNextStage;
    property Again: Boolean read FAgain write FAgain;
    property CloseGame: Boolean read FCloseGame write FCloseGame;
  end;

implementation

{$R *.dfm}

{ TfrmWin }

function TfrmWin.Moves(const Value: Integer): TfrmWin;
begin
  Result := Self;
  FMoves := Value;
end;

procedure TfrmWin.FillStarts(const Star1, Star2, Star3: Boolean);
begin
  if (Star1) then
  begin
    FPng1Star := TPngImage.Create;
    try
      FPng1Star.LoadFromResourceName(HInstance, 'star');
    finally
      img1Star.Picture.Graphic := FPng1Star;
    end;
  end;

  FPng2Star := TPngImage.Create;
  try
    if (Star2) then
    begin
      FPng2Star.LoadFromResourceName(HInstance, 'star')
    end
    else
    begin
      FPng2Star.LoadFromResourceName(HInstance, 'graystar')
    end;
  finally
    img2Star.Picture.Graphic := FPng2Star;
  end;

  FPng3Star := TPngImage.Create;
  try
    if (Star3) then
    begin
      FPng3Star.LoadFromResourceName(HInstance, 'star')
    end
    else
    begin
      FPng3Star.LoadFromResourceName(HInstance, 'graystar')
    end;
  finally
    img3Star.Picture.Graphic := FPng3Star;
  end;
end;

procedure TfrmWin.FormDestroy(Sender: TObject);
begin
  if Assigned(FPngRestart) then
    FreeAndNil(FPngRestart);
  if Assigned(FPngNext) then
    FreeAndNil(FPngNext);
  if Assigned(FPng1Star) then
    FreeAndNil(FPng1Star);
  if Assigned(FPng2Star) then
    FreeAndNil(FPng2Star);
  if Assigned(FPng3Star) then
    FreeAndNil(FPng3Star);
end;

procedure TfrmWin.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
  begin
    FCloseGame := True;
    ModalResult := mrOk;
  end;
end;

procedure TfrmWin.FormShow(Sender: TObject);
var
  ValueFromStar: Integer;
  Values: TArray<Integer>;
begin
  FCloseGame := False;
  FNextStage := False;
  FAgain := False;

  FPngRestart := TPngImage.Create;
  try
    FPngRestart.LoadFromResourceName(HInstance, 'restart');
  finally
    imgAgain.Picture.Graphic := FPngRestart;
  end;

  FPngNext := TPngImage.Create;
  try
    FPngNext.LoadFromResourceName(HInstance, 'next');
  finally
    imgNext.Picture.Graphic := FPngNext;
  end;

  ValueFromStar := trunc(FPerfectMoves div 4);

  SetLength(Values, 3);
  Values[0] := FPerfectMoves + (ValueFromStar * 2);
  Values[1] := FPerfectMoves + ValueFromStar;
  Values[2] := FPerfectMoves;

  FillStarts(True, (FMoves < Values[0]), (FMoves = Values[2]));
end;

procedure TfrmWin.imgAgainClick(Sender: TObject);
begin
  FAgain := True;
  ModalResult := mrOk;
end;

procedure TfrmWin.imgAgainMouseEnter(Sender: TObject);
begin
  pnlImgAgain.Color := $0068F50A;
end;

procedure TfrmWin.imgAgainMouseLeave(Sender: TObject);
begin
  pnlImgAgain.Color := clWhite;
end;

procedure TfrmWin.imgNextClick(Sender: TObject);
begin
  FNextStage := True;
  ModalResult := mrOk;
end;

procedure TfrmWin.imgNextMouseEnter(Sender: TObject);
begin
  pnlImgNext.Color := $0068F50A;
end;

procedure TfrmWin.imgNextMouseLeave(Sender: TObject);
begin
  pnlImgNext.Color := clWhite;
end;

function TfrmWin.Moves: Integer;
begin
  Result := FMoves;
end;

function TfrmWin.PerfectMoves(const Value: Integer): TfrmWin;
begin
  Result := Self;
  FPerfectMoves := Value;
end;

function TfrmWin.PerfectMoves: Integer;
begin
  Result := FPerfectMoves;
end;

end.
