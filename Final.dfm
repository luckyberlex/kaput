object FormFinal: TFormFinal
  Left = 394
  Top = 153
  BorderStyle = bsNone
  Caption = 'FormFinal'
  ClientHeight = 334
  ClientWidth = 483
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 121
    Caption = 'Panel1'
    Color = clBlack
    TabOrder = 0
  end
  object MediaPlayer1: TMediaPlayer
    Left = 120
    Top = 232
    Width = 253
    Height = 30
    Display = Panel1
    Visible = False
    TabOrder = 1
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 24
    Top = 288
  end
end
