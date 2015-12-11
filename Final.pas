unit Final;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MPlayer, ExtCtrls;

type
  TFormFinal = class(TForm)
    Panel1: TPanel;
    MediaPlayer1: TMediaPlayer;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormFinal: TFormFinal;

implementation
uses FormMain;
var w,h:integer;
    MO: boolean;
    timefinal: integer;
{$R *.dfm}

procedure TFormFinal.FormCreate(Sender: TObject);
begin
    timefinal:=0;
    mo:=false;
    H:=Screen.Height;
    W:=Screen.Width;
    Left:=0;
    Top:=0;
    Width:=W;
    Height:=H;
    Panel1.Left:=0;
    Panel1.Top:=0;
    Panel1.Height:=H;
    Panel1.Width:=W;
   // MediaPlayer1.FileName:='data\video\final.wmv';
   // MediaPlayer1.Open;
    Panel1.Visible:=true;
    Timer1.Enabled:=true;
   // MediaPlayer1.Play;
    MO:=true;
end;

procedure TFormFinal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action:=cafree;
end;

procedure TFormFinal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
      if (Key=VK_Escape) then
    begin
      if mo then
      begin
        MediaPlayer1.Stop;
        MediaPlayer1.Close;
        Panel1.Visible:=false;
        mo:=false;
        Application.CreateForm(TMainForm, MainForm);
        MainForm.Show;
        close;
      end;
    end;
end;

procedure TFormFinal.Timer1Timer(Sender: TObject);
begin
  timefinal:=timefinal+1;
  if timefinal=1 then
  begin
    mo:=false;
    H:=Screen.Height;
    W:=Screen.Width;
    Left:=0;
    Top:=0;
    Width:=W;
    Height:=H;
    Panel1.Left:=0;
    Panel1.Top:=0;
    Panel1.Height:=H;
    Panel1.Width:=W;
    MediaPlayer1.FileName:='data\video\final.wmv';
    MediaPlayer1.Open;
    MediaPlayer1.DisplayRect:=Rect(0,0,W,H);
    Panel1.Visible:=true;
   // Timer1.Enabled:=true;
    MediaPlayer1.Play;
    MO:=true;
  end;
  if timefinal>=82 then
  begin
   if mo then
      begin
        MediaPlayer1.Stop;
        MediaPlayer1.Close;
        Panel1.Visible:=false;
        mo:=false;
        Application.CreateForm(TMainForm, MainForm);
        MainForm.Show;
        close;
      end;
  end;
end;

end.
