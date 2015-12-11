unit SoundManagerIronKaput;

interface

uses
DirectSound, UdxSoundManager;

var
SoundManager: TdxSoundManager;

type

CSound = class (TdxSound)
private
  nomer: integer;
  playstatus: boolean;
  cikl: boolean;
public
  constructor create(WAVFileName: string; newnomer: integer;
  newcikl: boolean);
  function StopAudio:hresult;
  function VolumeAudio(volume:integer):hresult;
  function PlayAudio:hresult;
  function getplaystatus: boolean;
end;





implementation

constructor CSound.create(WAVFileName: string; newnomer: integer;
  newcikl: boolean);
begin
  SoundManager.CreateSound(WAVFileName);
  nomer:=newnomer;
  cikl:=newcikl;
  playstatus:=false;
end;

//---------Play-----------
function CSound.PlayAudio:hresult;
var
  Sound: TdxSound;
begin
  if cikl then
  begin
    if playstatus=false then
    begin
      playstatus:=true;
      Sound := SoundManager.GetSound(nomer);
      if Sound <> NIL then  Sound.PlaySound(cikl);
    end;
  end else
    begin
      Sound := SoundManager.GetSound(nomer);
      if Sound <> NIL then  Sound.PlaySound(cikl);
    end;
end;



//-------- STOP --------

function CSound.StopAudio:hresult;
var
  Sound: TdxSound;
begin
  Sound := SoundManager.GetSound(nomer);
  if Sound <> NIL then  Sound.StopSound;
  if cikl then  playstatus:=false;
end;

//-------- VOLUME --------
function CSound.VolumeAudio(volume:integer):hresult;
var
  Sound: TdxSound;
begin
  Sound := SoundManager.GetSound(nomer);
  if Sound = NIL then EXIT;
  Sound.SetVolume(volume);
end;

function CSound.getplaystatus: boolean;
begin
  result:=playstatus;
end;



end.
 