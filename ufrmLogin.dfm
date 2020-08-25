object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 372
  ClientWidth = 249
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlImgLogin: TGridPanel
    Left = 0
    Top = 0
    Width = 249
    Height = 161
    Align = alTop
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        ColumnSpan = 2
        Control = pnlImage
        Row = 0
      end>
    RowCollection = <
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 0
    DesignSize = (
      249
      161)
    object pnlImage: TPanel
      Left = 66
      Top = 24
      Width = 117
      Height = 112
      Anchors = []
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      OnMouseEnter = pnlImageMouseEnter
      OnMouseLeave = pnlImageMouseLeave
      object pnlCircle: TPanel
        Left = 0
        Top = 0
        Width = 117
        Height = 112
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object imgLogin: TImage
          AlignWithMargins = True
          Left = 1
          Top = 1
          Width = 115
          Height = 110
          Margins.Left = 1
          Margins.Top = 1
          Margins.Right = 1
          Margins.Bottom = 1
          Align = alClient
          Stretch = True
          OnMouseEnter = pnlImageMouseEnter
          OnMouseLeave = pnlImageMouseLeave
          ExplicitLeft = 6
          ExplicitTop = 6
          ExplicitWidth = 111
          ExplicitHeight = 106
        end
      end
    end
  end
  object pnlBody: TGridPanel
    Left = 0
    Top = 161
    Width = 249
    Height = 211
    Align = alClient
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = pnlUser
        Row = 0
      end
      item
        Column = 0
        Control = pnlRemember
        Row = 2
      end
      item
        Column = 0
        Control = pnlEnter
        Row = 3
      end
      item
        Column = 0
        Control = pnlPassword
        Row = 1
      end>
    RowCollection = <
      item
        Value = 25.000000000000000000
      end
      item
        Value = 25.000000000000000000
      end
      item
        Value = 25.000000000000000000
      end
      item
        Value = 25.000000000000000000
      end>
    TabOrder = 1
    object pnlUser: TPanel
      Left = 0
      Top = 0
      Width = 249
      Height = 52
      Align = alClient
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object lblUser: TLabel
        AlignWithMargins = True
        Left = 10
        Top = 3
        Width = 229
        Height = 13
        Margins.Left = 10
        Margins.Right = 10
        Align = alTop
        Caption = 'User name or Email Adress'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 127
      end
      object pnlEdtUserBorder: TPanel
        AlignWithMargins = True
        Left = 10
        Top = 22
        Width = 229
        Height = 25
        Margins.Left = 10
        Margins.Right = 10
        Margins.Bottom = 5
        Align = alClient
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object pnlEdtUser: TPanel
          AlignWithMargins = True
          Left = 1
          Top = 1
          Width = 227
          Height = 23
          Margins.Left = 1
          Margins.Top = 1
          Margins.Right = 1
          Margins.Bottom = 1
          Align = alClient
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 0
          object imgUser: TImage
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 19
            Height = 17
            Align = alLeft
            Stretch = True
            ExplicitHeight = 19
          end
          object edtUser: TEdit
            AlignWithMargins = True
            Left = 25
            Top = 4
            Width = 202
            Height = 19
            Margins.Left = 0
            Margins.Top = 4
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alClient
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Text = 'Username'
            OnEnter = edtUserEnter
            OnExit = edtUserExit
          end
        end
      end
    end
    object pnlRemember: TPanel
      Left = 0
      Top = 104
      Width = 249
      Height = 52
      Align = alClient
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object lblSignup: TLabel
        Left = 0
        Top = 39
        Width = 249
        Height = 13
        Align = alBottom
        Alignment = taCenter
        Caption = 'Don'#39't have a login? Sign Up.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHighlight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        OnClick = lblSignupClick
        OnMouseEnter = lblSignupMouseEnter
        OnMouseLeave = lblSignupMouseLeave
        ExplicitWidth = 134
      end
      object ckbRememberme: TCheckBox
        AlignWithMargins = True
        Left = 10
        Top = 3
        Width = 229
        Height = 17
        Margins.Left = 10
        Margins.Right = 10
        Align = alTop
        Caption = 'Remember me'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
    end
    object pnlEnter: TPanel
      Left = 0
      Top = 156
      Width = 249
      Height = 55
      Align = alClient
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      object pnlLogin: TPanel
        AlignWithMargins = True
        Left = 10
        Top = 10
        Width = 229
        Height = 35
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Log In'
        Color = 16744448
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
        OnClick = pnlLoginClick
        OnMouseEnter = pnlLoginMouseEnter
        OnMouseLeave = pnlLoginMouseLeave
      end
    end
    object pnlPassword: TPanel
      Left = 0
      Top = 52
      Width = 249
      Height = 52
      Align = alClient
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object lblPassword: TLabel
        AlignWithMargins = True
        Left = 10
        Top = 3
        Width = 229
        Height = 13
        Margins.Left = 10
        Margins.Right = 10
        Align = alTop
        Caption = 'Password'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 46
      end
      object pnlEdtPasswordBorder: TPanel
        AlignWithMargins = True
        Left = 10
        Top = 22
        Width = 229
        Height = 25
        Margins.Left = 10
        Margins.Right = 10
        Margins.Bottom = 5
        Align = alClient
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object pnlEdtPassword: TPanel
          AlignWithMargins = True
          Left = 1
          Top = 1
          Width = 227
          Height = 23
          Margins.Left = 1
          Margins.Top = 1
          Margins.Right = 1
          Margins.Bottom = 1
          Align = alClient
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 0
          object imgPassword: TImage
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 19
            Height = 17
            Align = alLeft
            Proportional = True
            Stretch = True
            ExplicitHeight = 19
          end
          object edtPassword: TEdit
            AlignWithMargins = True
            Left = 25
            Top = 4
            Width = 202
            Height = 19
            Margins.Left = 0
            Margins.Top = 4
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alClient
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            PasswordChar = '*'
            TabOrder = 0
            Text = 'Password'
            OnEnter = edtPasswordEnter
            OnExit = edtPasswordExit
            OnKeyPress = edtPasswordKeyPress
          end
        end
      end
    end
  end
end
