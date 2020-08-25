unit ufrmStageCreator;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, Datasnap.DBClient, Vcl.DBCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, System.Generics.Collections;

type
  TfrmStageCreator = class(TForm)
    pnlInformations: TPanel;
    pnlImages: TPanel;
    dbgStages: TDBGrid;
    cdsStages: TClientDataSet;
    dsStages: TDataSource;
    cdsStagesNumber: TIntegerField;
    cdsStagesX: TIntegerField;
    cdsStagesY: TIntegerField;
    dbnStages: TDBNavigator;
    BackGround: TGridPanel;
    grpImages: TGridPanel;
    pnlWall: TPanel;
    imgWall: TImage;
    pnlFloor: TPanel;
    imgFloor: TImage;
    pnlBox: TPanel;
    imgBox: TImage;
    pnlBoxGoal: TPanel;
    imgBoxGoal: TImage;
    pnlGoal: TPanel;
    imgGoal: TImage;
    pnlPlayer: TPanel;
    imgPlayer: TImage;
    pnlBackGround: TGridPanel;
    btnSave: TButton;
    cdsStagesPerfectMoves: TIntegerField;
    procedure FormShow(Sender: TObject);
    procedure imgWallClick(Sender: TObject);
    procedure imgFloorClick(Sender: TObject);
    procedure imgBoxClick(Sender: TObject);
    procedure imgBoxGoalClick(Sender: TObject);
    procedure imgGoalClick(Sender: TObject);
    procedure imgPlayerClick(Sender: TObject);
    procedure cdsStagesAfterPost(DataSet: TDataSet);
    procedure btnSaveClick(Sender: TObject);
  private
  var
    FPanels: TObjectDictionary<Integer, TPanel>;
    FOpen: Boolean;

    procedure NewBackGround(const X, Y: Int16);
    procedure CreatPanels(const X, Y: Int16);
    procedure LimparTags;
    procedure LimparCores;
    procedure PanelMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    function ReturnImage: TImage;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmStageCreator: TfrmStageCreator;

implementation

{$R *.dfm}

uses uStageJSON, StringFactory;

procedure TfrmStageCreator.btnSaveClick(Sender: TObject);
var
  Stage: TStage;
  Panel: TPanel;
  Image: TImage;
  I, X, Y: Integer;
  Path: string;
  JSON: string;
  lJSON: TStringList;
begin
  Stage := TStage.Create;
  Stage.Stage.Number := cdsStagesNumber.AsInteger;
  Stage.Stage.X := cdsStagesX.AsInteger;
  Stage.Stage.Y := cdsStagesY.AsInteger;
  Stage.Stage.PerfectMoves := cdsStagesPerfectMoves.AsInteger;
  for Panel in FPanels.Values do
  begin
    for I := 0 to Panel.ControlCount - 1 do
    begin
      X := pnlBackGround.ControlCollection.Items[pnlBackGround.ControlCollection.IndexOf(Panel)].Column + 1;
      Y := pnlBackGround.ControlCollection.Items[pnlBackGround.ControlCollection.IndexOf(Panel)].Row + 1;
      Image := TImage(Panel.Controls[I]);
      case Image.Tag of
        1: Stage.Stage.AddWall(X, Y);
        2: Stage.Stage.AddFloor(X, Y);
        3:
          begin
            Stage.Stage.AddFloor(X, Y);
            Stage.Stage.AddBox(X, Y);
          end;

        4:
          begin
            Stage.Stage.AddFloor(X, Y);
            Stage.Stage.AddBoxGoal(X, Y);
          end;

        5:
          begin
            Stage.Stage.AddFloor(X, Y);
            Stage.Stage.AddGoal(X, Y);
          end;

        6:
          begin
            Stage.Stage.AddFloor(X, Y);
            Stage.Stage.AddPlayer(X, Y);
          end;
      end;
    end;
  end;

  Path := System.SysUtils.IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Stages';
  JSON := Stage.ToJSONString;
  lJSON := TStringList.Create;
  try
    lJSON.Add(JSON);
    lJSON.SaveToFile(System.SysUtils.IncludeTrailingPathDelimiter(Path) + 'stage' + cdsStagesNumber.AsString + '.json');
  finally
    FreeAndNil(lJSON);
  end;
end;

procedure TfrmStageCreator.cdsStagesAfterPost(DataSet: TDataSet);
var
  I: Integer;
begin
  if not(FOpen) then
  begin
    if Assigned(FPanels) then
    begin
      for I := FPanels.Count - 1 downto 0 do
      begin
        FPanels.Items[I].Free;
        FPanels.Remove(I);
      end;

      FreeAndNil(FPanels);
    end;

    pnlBackGround.RowCollection.BeginUpdate;
    try
      pnlBackGround.RowCollection.Clear;
    finally
      pnlBackGround.RowCollection.EndUpdate;
    end;

    pnlBackGround.ColumnCollection.BeginUpdate;
    try
      pnlBackGround.ColumnCollection.Clear;
    finally
      pnlBackGround.ColumnCollection.EndUpdate;
    end;

    FPanels := TObjectDictionary<Integer, TPanel>.Create;
    NewBackGround(cdsStagesX.AsInteger, cdsStagesY.AsInteger);
    CreatPanels(cdsStagesX.AsInteger, cdsStagesY.AsInteger);
  end;
end;

function TfrmStageCreator.ReturnImage: TImage;
begin
  if pnlWall.Tag = 1 then
    Result := imgWall
  else if pnlFloor.Tag = 1 then
    Result := imgFloor
  else if pnlBox.Tag = 1 then
    Result := imgBox
  else if pnlBoxGoal.Tag = 1 then
    Result := imgBoxGoal
  else if pnlGoal.Tag = 1 then
    Result := imgGoal
  else if pnlPlayer.Tag = 1 then
    Result := imgPlayer;
end;

procedure TfrmStageCreator.PanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  I: Integer;
  Image, RetImage: TImage;
begin
  if (Button = mbRight) then
  begin
    if (Sender is TImage) then
      TImage(Sender).Free;
  end
  else
  begin
    if (Sender is TPanel) then
    begin
      RetImage := ReturnImage;
      Image := TImage.Create(TComponent(Sender));
      Image.Parent := TWinControl(Sender);
      Image.Align := alClient;
      Image.Picture.Graphic := RetImage.Picture.Graphic;
      Image.OnMouseUp := PanelMouseUp;
      Image.Tag := RetImage.Tag;
    end;
  end;
end;

procedure TfrmStageCreator.CreatPanels(const X, Y: Int16);
var
  lRows, lColumns, Key: Integer;
  Panel: TPanel;

  function NewPanel: TPanel;
  begin
    Result := TPanel.Create(BackGround);
    Result.Width := 33;
    Result.Height := 33;
    Result.OnMouseUp := PanelMouseUp;
  end;
begin
  Key := 0;
  for lColumns := 0 to X - 1 do
  begin
    for lRows := 0 to Y - 1 do
    begin
      Panel := NewPanel;
      Panel.Align := alClient;
      Panel.Parent := pnlBackGround;
      FPanels.Add(Key, Panel);
      Key := Succ(Key);
    end;
  end;
end;

procedure TfrmStageCreator.FormShow(Sender: TObject);
var
  F: TSearchRec;
  Ret: Integer;
  Stage: TStage;
  Path: string;

  function HaveAttr(const Attr, Val: Integer): Boolean;
  begin
    Result := Attr and Val = Val;
  end;
begin
  FOpen := True;
  try
    cdsStages.CreateDataSet;
    Path := System.SysUtils.IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Stages';
//    Ret := FindFirst(Path + '\*.json', faAnyFile, F);
//    try
//      while (Ret = 0) do
//      begin
//        if not HaveAttr(F.Attr, faDirectory) then
//        begin
//          Stage := TStage.FromJSONString(TStringBuilder.New
//                                                       .LoadFromFile((Path + '\' + F.Name))
//                                                       .ToString);
//          cdsStages.Append;
//          cdsStagesNumber.AsInteger := Stage.Stage.Number;
//          cdsStagesX.AsInteger := Stage.Stage.X;
//          cdsStagesY.AsInteger := Stage.Stage.Y;
//          cdsStagesPerfectMoves.AsInteger := Stage.Stage.PerfectMoves;
//          cdsStages.Post;
//        end;
//
//        Ret := FindNext(F);
//      end;
//    finally
//      FindClose(F);
//    end;
  finally
    FOpen := False;
  end;
end;

procedure TfrmStageCreator.imgBoxClick(Sender: TObject);
begin
  LimparTags;
  LimparCores;
  pnlBox.Color := clGreen;
  pnlBox.Tag := 1;
end;

procedure TfrmStageCreator.imgBoxGoalClick(Sender: TObject);
begin
  LimparTags;
  LimparCores;
  pnlBoxGoal.Color := clGreen;
  pnlBoxGoal.Tag := 1;
end;

procedure TfrmStageCreator.imgFloorClick(Sender: TObject);
begin
  LimparTags;
  LimparCores;
  pnlFloor.Color := clGreen;
  pnlFloor.Tag := 1;
end;

procedure TfrmStageCreator.imgGoalClick(Sender: TObject);
begin
  LimparTags;
  LimparCores;
  pnlGoal.Color := clGreen;
  pnlGoal.Tag := 1;
end;

procedure TfrmStageCreator.imgPlayerClick(Sender: TObject);
begin
  LimparTags;
  LimparCores;
  pnlPlayer.Color := clGreen;
  pnlPlayer.Tag := 1;
end;

procedure TfrmStageCreator.LimparCores;
begin
  pnlWall.Color := clWhite;
  pnlFloor.Color := clWhite;
  pnlBox.Color := clWhite;
  pnlBoxGoal.Color := clWhite;
  pnlGoal.Color := clWhite;
  pnlPlayer.Color := clWhite;
end;

procedure TfrmStageCreator.LimparTags;
begin
  pnlWall.Tag := 0;
  pnlFloor.Tag := 0;
  pnlBox.Tag := 0;
  pnlBoxGoal.Tag := 0;
  pnlGoal.Tag := 0;
  pnlPlayer.Tag := 0;
end;

procedure TfrmStageCreator.imgWallClick(Sender: TObject);
begin
  LimparTags;
  LimparCores;
  pnlWall.Color := clGreen;
  pnlWall.Tag := 1;
end;


procedure TfrmStageCreator.NewBackGround(const X, Y: Int16);
var
  lRows, lColumns: Integer;
begin
  pnlBackGround.ColumnCollection.BeginUpdate;
  try
    for lColumns := 0 to X - 1 do
    begin

      with pnlBackGround.ColumnCollection.Add do
      begin
        SizeStyle := ssAbsolute;
        Value := 33;
      end;
    end;
  finally
    pnlBackGround.ColumnCollection.EndUpdate;
  end;

  pnlBackGround.RowCollection.BeginUpdate;
  try
    for lRows := 0 to Y - 1 do
    begin
      with pnlBackGround.RowCollection.Add do
      begin
        SizeStyle := ssAbsolute;
        Value := 33;
      end;
    end;
  finally
    pnlBackGround.RowCollection.EndUpdate;
  end;
end;

end.
