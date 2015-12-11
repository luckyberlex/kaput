unit Logo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,

  DirectDraw,DirectInput,UdxInputManager,DirectDrawUsing,BaseSprite,
  ExtCtrls, MPlayer;

type
  TFormLogo = class(TForm)
    Panel1: TPanel;
    MediaPlayer1: TMediaPlayer;
    Timer1: TTimer;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormLogo: TFormLogo;
  i: integer = 0;

implementation

uses FormMain;

{$R *.dfm}

var w,h:integer;
MO: boolean;

procedure TFormLogo.FormCreate(Sender: TObject);
begin
ShowCursor(false);
MO:=false;
H:=Screen.Height;
W:=Screen.Width;

FormLogo.Left:=0;
FormLogo.Top:=0;

FormLogo.Width:=W;
FormLogo.Height:=H;

Image1.Left:=0;
Image1.Top:=0;
Image1.Height:=H;
Image1.Width:=W;

end;

procedure TFormLogo.Timer1Timer(Sender: TObject);
begin
  i:=i+1;
  if i=2 then
  begin
    Panel1.Left:=0;
    Panel1.Top:=0;
    Panel1.Height:=H;
    Panel1.Width:=W;
    MediaPlayer1.FileName:='data\video\start.wmv';
    MediaPlayer1.Open;
    MediaPlayer1.DisplayRect:=Rect(0,0,W,H);
    Panel1.Visible:=true;
    Image1.Visible:=false;
    MO:=true;
    MediaPlayer1.Play;
  end;
  if i=26 then
  begin
   Application.CreateForm(TMainForm, MainForm);
        MainForm.Show;
    close;
  end;
end;

procedure TFormLogo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action:=cafree;
end;

procedure TFormLogo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_Escape) then
  begin
    if mo then MediaPlayer1.Stop;
    Application.CreateForm(TMainForm, MainForm);
        MainForm.Show;
    close;
  end;
end;

end.
