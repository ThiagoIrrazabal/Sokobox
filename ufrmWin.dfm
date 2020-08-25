object frmWin: TfrmWin
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Congratulations'
  ClientHeight = 142
  ClientWidth = 236
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBorder: TPanel
    Left = 0
    Top = 0
    Width = 236
    Height = 142
    Align = alClient
    BevelOuter = bvNone
    Color = clTeal
    ParentBackground = False
    TabOrder = 0
    object pnlBackGround: TPanel
      AlignWithMargins = True
      Left = 2
      Top = 2
      Width = 232
      Height = 138
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Align = alClient
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object lblCongratulations: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 10
        Width = 226
        Height = 18
        Margins.Top = 10
        Align = alTop
        Alignment = taCenter
        Caption = 'Congratulations'
        Font.Charset = OEM_CHARSET
        Font.Color = 44287
        Font.Height = -19
        Font.Name = 'Terminal'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 166
      end
      object grpImages: TGridPanel
        AlignWithMargins = True
        Left = 50
        Top = 34
        Width = 132
        Height = 67
        Margins.Left = 50
        Margins.Right = 50
        Align = alTop
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 33.330000000000000000
          end
          item
            Value = 33.340000000000000000
          end
          item
            Value = 33.330000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = pnl1Star
            Row = 1
          end
          item
            Column = 1
            Control = pnl2Star
            Row = 0
            RowSpan = 2
          end
          item
            Column = 2
            Control = Panel1
            Row = 1
          end>
        RowCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end>
        TabOrder = 0
        DesignSize = (
          132
          67)
        object pnl1Star: TPanel
          Left = 5
          Top = 33
          Width = 32
          Height = 34
          Anchors = []
          BevelOuter = bvNone
          TabOrder = 0
          object img1Star: TImage
            AlignWithMargins = True
            Left = 0
            Top = 1
            Width = 32
            Height = 32
            Margins.Left = 0
            Margins.Top = 1
            Margins.Right = 0
            Margins.Bottom = 1
            Align = alClient
            ExplicitLeft = -32
            ExplicitTop = -32
            ExplicitWidth = 105
            ExplicitHeight = 105
          end
        end
        object pnl2Star: TPanel
          AlignWithMargins = True
          Left = 48
          Top = 19
          Width = 33
          Height = 41
          Margins.Left = 0
          Margins.Top = 12
          Margins.Right = 0
          Margins.Bottom = 0
          Anchors = []
          BevelOuter = bvNone
          TabOrder = 1
          object img2Star: TImage
            AlignWithMargins = True
            Left = 1
            Top = 5
            Width = 32
            Height = 32
            Margins.Left = 1
            Margins.Top = 5
            Margins.Right = 0
            Margins.Bottom = 4
            Align = alClient
            ExplicitLeft = -32
            ExplicitTop = -32
            ExplicitWidth = 105
            ExplicitHeight = 105
          end
        end
        object Panel1: TPanel
          Left = 92
          Top = 33
          Width = 34
          Height = 34
          Anchors = []
          BevelOuter = bvNone
          TabOrder = 2
          object img3Star: TImage
            AlignWithMargins = True
            Left = 1
            Top = 1
            Width = 32
            Height = 32
            Margins.Left = 1
            Margins.Top = 1
            Margins.Right = 1
            Margins.Bottom = 1
            Align = alClient
            ExplicitLeft = -32
            ExplicitTop = -32
            ExplicitWidth = 105
            ExplicitHeight = 105
          end
        end
      end
      object pnlBottons: TGridPanel
        Left = 0
        Top = 104
        Width = 232
        Height = 34
        Align = alClient
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
            Control = pnlAgain
            Row = 0
          end
          item
            Column = 1
            Control = pnlNext
            Row = 0
          end>
        RowCollection = <
          item
            Value = 100.000000000000000000
          end>
        TabOrder = 1
        object pnlAgain: TPanel
          Left = 0
          Top = 0
          Width = 116
          Height = 34
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object pnlImgAgain: TPanel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 33
            Height = 28
            Align = alLeft
            BevelOuter = bvNone
            Color = clWhite
            ParentBackground = False
            TabOrder = 0
            OnMouseEnter = imgAgainMouseEnter
            OnMouseLeave = imgAgainMouseLeave
            object imgAgain: TImage
              Left = 0
              Top = 0
              Width = 33
              Height = 28
              Align = alClient
              Center = True
              OnClick = imgAgainClick
              OnMouseEnter = imgAgainMouseEnter
              OnMouseLeave = imgAgainMouseLeave
              ExplicitLeft = 1
              ExplicitWidth = 32
              ExplicitHeight = 32
            end
          end
        end
        object pnlNext: TPanel
          Left = 116
          Top = 0
          Width = 116
          Height = 34
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object pnlImgNext: TPanel
            AlignWithMargins = True
            Left = 80
            Top = 3
            Width = 33
            Height = 28
            Align = alRight
            BevelOuter = bvNone
            Color = clWhite
            ParentBackground = False
            TabOrder = 0
            OnMouseEnter = imgNextMouseEnter
            OnMouseLeave = imgNextMouseLeave
            object imgNext: TImage
              Left = 0
              Top = 0
              Width = 33
              Height = 28
              Align = alClient
              Center = True
              OnClick = imgNextClick
              OnMouseEnter = imgNextMouseEnter
              OnMouseLeave = imgNextMouseLeave
              ExplicitLeft = 88
              ExplicitWidth = 32
              ExplicitHeight = 34
            end
          end
        end
      end
    end
  end
end
