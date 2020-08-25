unit ufrmSignUp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ExtDlgs,
  Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, uJSONUser;

type
  TfrmSignUp = class(TForm)
    pnlImgLogin: TGridPanel;
    pnlImage: TPanel;
    pnlBody: TGridPanel;
    pnlUser: TPanel;
    lblUser: TLabel;
    pnlEnter: TPanel;
    pnlSignUp: TPanel;
    pnlEdtUserBorder: TPanel;
    pnlEdtUser: TPanel;
    edtUser: TEdit;
    imgUser: TImage;
    pnlPassword: TPanel;
    lblPassword: TLabel;
    pnlEdtPasswordBorder: TPanel;
    pnlEdtPassword: TPanel;
    imgPassword: TImage;
    edtPassword: TEdit;
    imgEdit: TImage;
    dlgImage: TOpenDialog;
    pnlCircle: TPanel;
    imgLogin: TImage;
    procedure edtUserEnter(Sender: TObject);
    procedure edtUserExit(Sender: TObject);
    procedure edtPasswordEnter(Sender: TObject);
    procedure edtPasswordExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure pnlSignUpMouseEnter(Sender: TObject);
    procedure pnlSignUpMouseLeave(Sender: TObject);
    procedure imgLoginMouseEnter(Sender: TObject);
    procedure imgLoginMouseLeave(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgLoginClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pnlSignUpClick(Sender: TObject);
    procedure edtUserChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FTop, FLeft, FHeight, FWidth: Integer;
    BMP: TBitmap;
    JPG: TJPEGImage;
    PNG: TPngImage;
    FUser: TUsersClass;
    Path: TFileName;
    FMaxLength: Integer;
    function Save(const User: TUsersClass): Boolean;
  public
    { Public declarations }
    property MaxLength: Integer read FMaxLength write FMaxLength;
  end;

var
  frmSignUp: TfrmSignUp;

implementation

{$R *.dfm}

procedure TfrmSignUp.edtPasswordEnter(Sender: TObject);
begin
  pnlEdtPasswordBorder.Color := clHighlight;

  if (edtPassword.Text = 'Password') then
    edtPassword.Clear;
end;

procedure TfrmSignUp.edtPasswordExit(Sender: TObject);
begin
  pnlEdtPasswordBorder.Color := clBtnFace;

  if (edtPassword.Text = EmptyStr) then
    edtPassword.Text := 'Password';
end;

procedure TfrmSignUp.edtUserChange(Sender: TObject);
begin
  if (lblUser.Caption = 'Username exists') then
  begin
    if not FileExists(Path + '\' + edtUser.Text) then
    begin
      lblUser.Caption := 'User name or Email Adress';
      lblUser.Font.Color := clGray;
    end;
  end;
end;

procedure TfrmSignUp.edtUserEnter(Sender: TObject);
begin
  pnlEdtUserBorder.Color := clHighlight;

  if (edtUser.Text = 'Username') then
    edtUser.Clear;
end;

procedure TfrmSignUp.edtUserExit(Sender: TObject);
begin
  pnlEdtUserBorder.Color := clBtnFace;

  if (edtUser.Text = EmptyStr) then
    edtUser.Text := 'Username';
end;

procedure TfrmSignUp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(BMP) then
    FreeAndNil(BMP);
  if Assigned(PNG) then
    FreeAndNil(PNG);
  if Assigned(JPG) then
    FreeAndNil(JPG);
end;

procedure TfrmSignUp.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
    Self.Close;
end;

procedure TfrmSignUp.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
    Perform(WM_NEXTDLGCTL,0,0);
end;

procedure TfrmSignUp.FormShow(Sender: TObject);
var
  BX: TRect;
  mdo: HRGN;
begin
  edtUser.MaxLength := FMaxLength;
  Path := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'users';
  FTop := imgEdit.Top;
  FLeft := imgEdit.Left;
  FHeight := imgEdit.Height;
  FWidth := imgEdit.Width;

  with pnlCircle do
  begin
    BX := ClientRect;
    mdo := CreateRoundRectRgn(BX.Left, BX.Top, BX.Right,
    BX.Bottom, 75, 75);
    Perform(EM_GETRECT, 0, lParam(@BX));
    InflateRect(BX, 10, 10);
    Perform(EM_SETRECTNP, 0, lParam(@BX));
    SetWindowRgn(Handle, mdo, True);
    Invalidate;
  end;
end;

procedure TfrmSignUp.imgLoginClick(Sender: TObject);
begin
  if dlgImage.Execute() then
  begin
    if (ExtractFileExt(dlgImage.FileName) = '.bmp') then
    begin
      if Assigned(BMP) then
        FreeAndNil(BMP);

      BMP := TBitmap.Create;
      BMP.LoadFromFile(dlgImage.FileName);
      imgLogin.Picture.Graphic := BMP;
    end
    else if (ExtractFileExt(dlgImage.FileName) = '.png') then
    begin
      if Assigned(PNG) then
        FreeAndNil(PNG);

      PNG := TPngImage.Create;
      PNG.LoadFromFile(dlgImage.FileName);
      imgLogin.Picture.Graphic := PNG;
    end
    else if (ExtractFileExt(dlgImage.FileName) = '.jpeg') or
      ((ExtractFileExt(dlgImage.FileName) = '.jpg')) then
    begin
      if Assigned(JPG) then
        FreeAndNil(JPG);

      JPG := TJPEGImage.Create;
      JPG.LoadFromFile(dlgImage.FileName);
      imgLogin.Picture.Graphic := JPG;
    end;
  end;
end;

procedure TfrmSignUp.imgLoginMouseEnter(Sender: TObject);
begin
  imgEdit.Left := FLeft - 2;
  imgEdit.Top := FTop - 2;
  imgEdit.Height := FHeight + 4;
  imgEdit.Width := FWidth + 4;
end;

procedure TfrmSignUp.imgLoginMouseLeave(Sender: TObject);
begin
  imgEdit.Left := FLeft;
  imgEdit.Top := FTop;
  imgEdit.Height := FHeight;
  imgEdit.Width := FWidth;
end;

function TfrmSignUp.Save(const User: TUsersClass): Boolean;
var
  Attributes: Integer;
  lFile: TStringList;
begin
  if not FileExists(Path + '\' + User.user.name) then
  begin
    try
      Attributes := faArchive + faHidden + faReadOnly;
      lFile := TStringList.Create;
      try
        lFile.Add(User.ToJsonString);
        lFile.SaveToFile(Path + '\' + User.user.name);
        FileSetAttr(Path + '\' + User.user.name, Attributes);
      finally
        FreeAndNil(lFile);
      end;

      Result := True;
    except
      Result := False;
    end;
  end
  else
  begin
    lblUser.Caption := 'Username exists';
    lblUser.Font.Color := clRed;
    Result := False;
  end;
end;

procedure TfrmSignUp.pnlSignUpClick(Sender: TObject);
var
  lExit: Boolean;
begin
  lExit := False;
  if (edtUser.Text = EmptyStr) or (edtUser.Text = 'Username') then
  begin
    lblUser.Caption := 'Enter username';
    lblUser.Font.Color := clRed;
    lExit := True;
  end
  else
  begin
    lblUser.Caption := 'User name or Email Adress';
    lblUser.Font.Color := clGray;
  end;

  if (edtPassword.Text = EmptyStr) or (edtPassword.Text = 'Password') then
  begin
    lblPassword.Caption := 'Enter password';
    lblPassword.Font.Color := clRed;
    lExit := True;
  end
  else
  begin
    lblPassword.Caption := 'Password';
    lblPassword.Font.Color := clGray;
  end;

  if not(lExit) then
  begin
    FUser := TUsersClass.Create;
    try
      FUser.user.name := edtUser.Text;
      FUser.user.password := edtPassword.Text;
      FUser.user.path := dlgImage.FileName;
      if Save(FUser) then
        Self.Close;
    finally
      FreeAndNil(FUser);
    end;
  end;
end;

procedure TfrmSignUp.pnlSignUpMouseEnter(Sender: TObject);
begin
  pnlSignUp.Cursor := crHandPoint;
  pnlSignUp.Margins.Left := 8;
  pnlSignUp.Margins.Top := 8;
  pnlSignUp.Margins.Right := 8;
  pnlSignUp.Margins.Bottom := 8;
end;

procedure TfrmSignUp.pnlSignUpMouseLeave(Sender: TObject);
begin
  pnlSignUp.Cursor := crDefault;
  pnlSignUp.Margins.Left := 10;
  pnlSignUp.Margins.Top := 10;
  pnlSignUp.Margins.Right := 10;
  pnlSignUp.Margins.Bottom := 10;
end;

end.
