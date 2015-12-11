object MainForm: TMainForm
  Left = 258
  Top = 200
  BorderStyle = bsNone
  Caption = 'DirectDraw: Example 5'
  ClientHeight = 373
  ClientWidth = 416
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object FileListBox1: TFileListBox
    Left = 201
    Top = -100
    Width = 71
    Height = 73
    FileType = [ftDirectory]
    ItemHeight = 13
    TabOrder = 0
  end
  object applicationEventsMain: TApplicationEvents
    OnIdle = applicationEventsMainIdle
    OnMinimize = applicationEventsMainMinimize
    OnRestore = applicationEventsMainRestore
    Left = 48
    Top = 16
  end
  object TimerTotalTime: TTimer
    Enabled = False
    OnTimer = TimerTotalTimeTimer
    Left = 48
    Top = 56
  end
  object TimerTimeBlock: TTimer
    Enabled = False
    OnTimer = TimerTimeBlockTimer
    Left = 80
    Top = 56
  end
  object TimerPolePl1: TTimer
    Enabled = False
    OnTimer = TimerPolePl1Timer
    Left = 112
    Top = 56
  end
  object TimerPolePl2: TTimer
    Enabled = False
    OnTimer = TimerPolePl2Timer
    Left = 144
    Top = 56
  end
  object TimerDefendBaza: TTimer
    Enabled = False
    OnTimer = TimerDefendBazaTimer
    Left = 176
    Top = 56
  end
  object TimerEndLevel: TTimer
    Enabled = False
    OnTimer = TimerEndLevelTimer
    Left = 48
    Top = 88
  end
  object TimerStartLevel: TTimer
    Enabled = False
    OnTimer = TimerStartLevelTimer
    Left = 80
    Top = 88
  end
  object TimerGameOver: TTimer
    Enabled = False
    OnTimer = TimerGameOverTimer
    Left = 112
    Top = 88
  end
  object TimerPreGO: TTimer
    Enabled = False
    OnTimer = TimerPreGOTimer
    Left = 144
    Top = 88
  end
  object TimerGOStat: TTimer
    Enabled = False
    OnTimer = TimerGOStatTimer
    Left = 176
    Top = 88
  end
  object TimerPl1PreShow: TTimer
    Enabled = False
    OnTimer = TimerPl1PreShowTimer
    Left = 80
    Top = 152
  end
  object TimerPl2PreShow: TTimer
    Enabled = False
    OnTimer = TimerPl2PreShowTimer
    Left = 48
    Top = 152
  end
end
