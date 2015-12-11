unit Start;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TFormStart = class(TForm)
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormStart: TFormStart;
  GamePlayTime: dword;

implementation
  uses Logo;
  var
      i: integer = 0;
{$R *.dfm}

procedure TFormStart.Timer1Timer(Sender: TObject);
begin
    i:=i+1;
    if i=1 then
    begin
      Application.CreateForm(TFormLogo, FormLogo);
      FormLogo.Show;
    end;
end;

procedure TFormStart.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    action:=cafree;
end;

procedure TFormStart.Timer2Timer(Sender: TObject);
begin
  GamePlayTime:=GamePlayTime+1;
end;

initialization
GamePlayTime:=0;

end.
