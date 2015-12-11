object FormLogo: TFormLogo
  Left = 223
  Top = 113
  BorderStyle = bsNone
  Caption = 'FormLogo'
  ClientHeight = 453
  ClientWidth = 787
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 787
    Height = 453
    Align = alClient
    Center = True
    Proportional = True
  end
  object Panel1: TPanel
    Left = 176
    Top = 56
    Width = 321
    Height = 145
    Caption = 'Panel1'
    Color = clBlack
    TabOrder = 0
    Visible = False
  end
  object MediaPlayer1: TMediaPlayer
    Left = 192
    Top = 320
    Width = 253
    Height = 30
    Display = Panel1
    Visible = False
    TabOrder = 1
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 264
    Top = 152
  end
end
