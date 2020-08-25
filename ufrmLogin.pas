unit ufrmLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, uJSONUser;

type
  TfrmLogin = class(TForm)
    pnlImgLogin: TGridPanel;
    pnlImage: TPanel;
    pnlBody: TGridPanel;
    pnlUser: TPanel;
    lblUser: TLabel;
    pnlRemember: TPanel;
    ckbRememberme: TCheckBox;
    pnlEnter: TPanel;
    pnlLogin: TPanel;
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
    lblSignup: TLabel;
    pnlCircle: TPanel;
    imgLogin: TImage;
    procedure edtUserEnter(Sender: TObject);
    procedure edtUserExit(Sender: TObject);
    procedure edtPasswordEnter(Sender: TObject);
    procedure edtPasswordExit(Sender: TObject);
    procedure lblSignupMouseEnter(Sender: TObject);
    procedure lblSignupMouseLeave(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure pnlLoginMouseEnter(Sender: TObject);
    procedure pnlLoginMouseLeave(Sender: TObject);
    procedure lblSignupClick(Sender: TObject);
    procedure pnlImageMouseEnter(Sender: TObject);
    procedure pnlImageMouseLeave(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pnlLoginClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edtPasswordKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    UserPath, Path: TFileName;
    BMP: TBitmap;
    JPG: TJPEGImage;
    PNG: TPngImage;
    FUser: TUsersClass;
    FMaxLength: Integer;
    procedure ChangeImage(const Path: TFileName);
    procedure Login(const Login, Senha: string);
  public
    { Public declarations }
    property User: TUsersClass read FUser write FUser;
    property MaxLength: Integer read FMaxLength write FMaxLength;
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

uses ufrmSignUp, System.IniFiles;

procedure TfrmLogin.edtPasswordEnter(Sender: TObject);
begin
  if (lblPassword.Font.Color = clRed) then
    pnlEdtPasswordBorder.Color := clRed
  else
    pnlEdtPasswordBorder.Color := clHighlight;

  if (edtPassword.Text = 'Password') then
    edtPassword.Clear;
end;

procedure TfrmLogin.edtPasswordExit(Sender: TObject);
begin
  pnlEdtPasswordBorder.Color := clBtnFace;

  if (edtPassword.Text = EmptyStr) then
    edtPassword.Text := 'Password';
end;

procedure TfrmLogin.edtPasswordKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
    pnlLoginClick(pnlLogin);
end;

procedure TfrmLogin.edtUserEnter(Sender: TObject);
begin
  if (lblUser.Font.Color = clRed) then
    pnlEdtUserBorder.Color := clRed
  else
    pnlEdtUserBorder.Color := clHighlight;

  if (edtUser.Text = 'Username') then
    edtUser.Clear;
end;

procedure TfrmLogin.edtUserExit(Sender: TObject);
begin
  pnlEdtUserBorder.Color := clBtnFace;

  if (edtUser.Text = EmptyStr) then
    edtUser.Text := 'Username';

  if (edtUser.Text <> 'Username') then
  begin
    if FileExists(UserPath + '\' + edtUser.Text) then
      ChangeImage(UserPath + '\' + edtUser.Text);
  end;
end;

procedure TfrmLogin.ChangeImage(const Path: TFileName);
var
  User: TUsersClass;
  lFile: TStringList;
begin
  lFile := TStringList.Create;
  try
    lFile.LoadFromFile(Path);
    User := TUsersClass.FromJsonString(lFile.Text);
    try
      if (ExtractFileExt(User.user.path) = '.bmp') then
      begin
        if Assigned(BMP) then
          FreeAndNil(BMP);

        BMP := TBitmap.Create;
        BMP.LoadFromFile(User.user.path);
        imgLogin.Picture.Graphic := BMP;
      end
      else if (ExtractFileExt(User.user.path) = '.png') then
      begin
        if Assigned(PNG) then
          FreeAndNil(PNG);

        PNG := TPngImage.Create;
        PNG.LoadFromFile(User.user.path);
        imgLogin.Picture.Graphic := PNG;
      end
      else if (ExtractFileExt(User.user.path) = '.jpeg') or
        ((ExtractFileExt(User.user.path) = '.jpg')) then
      begin
        if Assigned(JPG) then
          FreeAndNil(JPG);

        JPG := TJPEGImage.Create;
        JPG.LoadFromFile(User.user.path);
        imgLogin.Picture.Graphic := JPG;
      end;
    finally
      FreeAndNil(User);
    end;
  finally
    FreeAndNil(lFile);
  end;
end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
var
  IniFile: TIniFile;
  Attributes: Integer;
begin
  if Assigned(BMP) then
    FreeAndNil(BMP);
  if Assigned(PNG) then
    FreeAndNil(PNG);
  if Assigned(JPG) then
    FreeAndNil(JPG);

  if ckbRememberme.Checked and Assigned(FUser) then
  begin
    Attributes := faArchive + faNormal;
    FileSetAttr(Path + 'remember.ini', Attributes);

    IniFile := TIniFile.Create(Path + 'remember.ini');
    try
      IniFile.WriteString('Login', 'Username', FUser.user.name);
    finally
      FreeAndNil(IniFile);
    end;

    Attributes := faArchive + faHidden + faReadOnly;
    FileSetAttr(Path + 'remember.ini', Attributes);
  end;
end;

procedure TfrmLogin.FormDestroy(Sender: TObject);
begin
  if Assigned(FUser) then
    FreeAndNil(FUser);
end;

procedure TfrmLogin.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
    Close;
end;

procedure TfrmLogin.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
    Perform(WM_NEXTDLGCTL,0,0);
end;

procedure TfrmLogin.FormShow(Sender: TObject);
var
  Attributes: Integer;
  BX: TRect;
  mdo: HRGN;
  IniFile: TIniFile;
begin
  edtUser.MaxLength := FMaxLength;
  Path := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  UserPath := Path + 'users';
  if not DirectoryExists(UserPath) then
    ForceDirectories(UserPath);

  Attributes := faDirectory + faHidden;
  FileSetAttr(UserPath, Attributes);

  with pnlCircle do
  begin
    BX := ClientRect;
    mdo := CreateRoundRectRgn(BX.Left, BX.Top, BX.Right,
    BX.Bottom, 100, 100);
    Perform(EM_GETRECT, 0, lParam(@BX));
    InflateRect(BX, - 4, - 4);
    Perform(EM_SETRECTNP, 0, lParam(@BX));
    SetWindowRgn(Handle, mdo, True);
    Invalidate;
  end;

  IniFile := TIniFile.Create(Path + 'remember.ini');
  try
    edtUser.Text := IniFile.ReadString('Login', 'Username', 'Username');
    ckbRememberme.Checked := (edtUser.Text <> 'Username');
  finally
    FreeAndNil(IniFile);
  end;
end;

procedure TfrmLogin.lblSignupClick(Sender: TObject);
var
  frmSignUp: TfrmSignUp;
begin
  frmSignUp := TfrmSignUp.Create(Self);
  try
    frmSignUp.MaxLength := FMaxLength;
    frmSignUp.ShowModal;
  finally
    FreeAndNil(frmSignUp);
  end;
end;

procedure TfrmLogin.lblSignupMouseEnter(Sender: TObject);
begin
  lblSignup.Cursor := crHandPoint;
end;

procedure TfrmLogin.lblSignupMouseLeave(Sender: TObject);
begin
  lblSignup.Cursor := crDefault;
end;

procedure TfrmLogin.pnlImageMouseEnter(Sender: TObject);
begin
  imgLogin.Margins.Left := 0;
  imgLogin.Margins.Top := 0;
  imgLogin.Margins.Right := 0;
  imgLogin.Margins.Bottom := 0;
end;

procedure TfrmLogin.pnlImageMouseLeave(Sender: TObject);
begin
  imgLogin.Margins.Left := 1;
  imgLogin.Margins.Top := 1;
  imgLogin.Margins.Right := 1;
  imgLogin.Margins.Bottom := 1;
end;

procedure TfrmLogin.pnlLoginClick(Sender: TObject);
begin
  if (edtUser.Text <> 'Username') then
  begin
    if FileExists(UserPath + '\' + edtUser.Text) then
    begin
      lblUser.Caption := 'User name or Email Adress';
      lblUser.Font.Color := clGray;
      if (edtUser.Focused) then
        pnlEdtUserBorder.Color := clHighlight
      else pnlEdtUserBorder.Color := clBtnFace;
      ChangeImage(UserPath + '\' + edtUser.Text);
      Login(edtUser.Text, edtPassword.Text);
    end
    else
    begin
      lblUser.Caption := 'Username does not exist';
      lblUser.Font.Color := clRed;
      pnlEdtUserBorder.Color := clRed;
      edtUser.SetFocus;
    end;
  end;
end;

procedure TfrmLogin.Login(const Login, Senha: string);
var
  lUser: TUsersClass;
  lFile: TStringList;
begin
  lFile := TStringList.Create;
  try
    lFile.LoadFromFile(UserPath + '\' + Login);
    lUser := TUsersClass.FromJsonString(lFile.Text);
    try
      if (lUser.user.password = edtPassword.Text) then
      begin
        lblPassword.Caption := 'Password';
        lblPassword.Font.Color := clGray;
        if (edtPassword.Focused) then
          pnlEdtPasswordBorder.Color := clHighlight
        else pnlEdtPasswordBorder.Color := clBtnFace;

        if Assigned(lUser) then
          FreeAndNil(lUser);

        FUser := TUsersClass.FromJsonString(lFile.Text);
        ModalResult := mrOk;
      end
      else
      begin
        lblPassword.Caption := 'Incorrect password';
        lblPassword.Font.Color := clRed;
        pnlEdtPasswordBorder.Color := clRed;
      end;
    finally
      FreeAndNil(lUser);
    end;
  finally
    FreeAndNil(lFile);
  end;
end;

procedure TfrmLogin.pnlLoginMouseEnter(Sender: TObject);
begin
  pnlLogin.Cursor := crHandPoint;
  pnlLogin.Margins.Left := 8;
  pnlLogin.Margins.Top := 8;
  pnlLogin.Margins.Right := 8;
  pnlLogin.Margins.Bottom := 8;
end;

procedure TfrmLogin.pnlLoginMouseLeave(Sender: TObject);
begin
  pnlLogin.Cursor := crDefault;
  pnlLogin.Margins.Left := 10;
  pnlLogin.Margins.Top := 10;
  pnlLogin.Margins.Right := 10;
  pnlLogin.Margins.Bottom := 10;
end;

end.
