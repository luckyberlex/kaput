unit BaseSprite;
interface
uses
DirectDraw,DirectDrawUsing,Graphics,SysUtils,Types,windows;

type
  CSprite = class            // базовый класс
  protected
    xx, yy  : integer;    // координаты на поверхности(верхний левый угол)
    width   : integer;    // ширина , высота спрайта
    height  : integer;
    OutSurface : COutSurface;      // указатель поверхности
    NKadr: integer;        //  количество кадров анимации
    KadrI: integer;        //  текущий кадр
  public
    LastKadrTime: Dword;    //  время последней анимации
    StartTime: Dword;
    TimeAnimate: dword;
    constructor Create(var Surf: COutSurface;
          lx,ly,newwidth,newheight:integer;   newNKadr: integer);
  // методы доступа
    function  getwidth: integer;
    function  getheight: integer;
    function  getXX: integer;
    function  getYY: integer;
  // методы установки параметров
    function  setXX(newXX: integer): hresult;
    function  setYY(newYY: integer): hresult;
  // прорисовать прямоугольник с поверхности на буфере
    function  DrawRect(newx,newy,x1,y1,x2,y2: integer) :hresult;
    function  getOS: COutSurface;
    function DrawKadr(x,y: integer; newKadrPos: integer):hresult;
    function DrawNextKadr(x,y: integer):Hresult;
    function DrawLastViewKadr(x,y: integer):Hresult;
    function Animate(x,y,FrameTime: dword): Hresult;
    function GetKolKadr: integer;
    function AnimateONE(x,y,FrameTime: dword): boolean;
    function SetKadrI(newparam: integer): hresult;
    function AnimateT(x,y,FrameTime,Animatetime: dword):boolean;
  end;
implementation
//////////////////////// CBlock////////////////////////////////
function CSprite.DrawRect(newx,newy,x1,y1,x2,y2: integer) :hresult;
var
  imgRect: TRect;
begin
  if newx<0 then
   begin
   x1:=x1+abs(0-newx);
  newx:=0;
   end;
  if newy<0 then
   begin
   y1:=y1+abs(0-newy);
  newy:=0;
   end;

   if newx>1024-(x2-x1) then
   begin
      x2:=x2-abs(newx+(x2-x1)-1024);
   end;

  if newy>768-(y2-y1) then
   begin
      y2:=y2-abs(newy+(y2-y1)-768);
   end;
  imgRect := Rect(x1, y1, x2, y2);
  if OutSurface.GetUseColorKey then
    outSurface.GetDisplay.GetDDSSecondary.BltFast
    (newX, newY,OutSurface.GetSurface , @imgRect,DDBLTFAST_WAIT or DDBLTFAST_SRCCOLORKEY)
 else
    outSurface.GetDisplay.GetDDSSecondary.BltFast
    (newX, newY, OutSurface.GetSurface, @imgRect,DDBLTFAST_WAIT);
end;

function CSprite.getwidth: integer;
begin
  Result := width;
end;
function CSprite.getheight: integer;
begin
  Result := height;
end;

function  CSprite.getOS: COutSurface;
begin
   Result := OutSurface;
end;

constructor CSprite.Create(var Surf: COutSurface;
          lx,ly,newwidth,newheight:integer;   newNKadr: integer);
begin
   self.OutSurface:=Surf;
   xx:=lx;
   yy:=ly;
   width:=newwidth;
   height:=newheight;
   NKadr:=newNKadr;
   KadrI:=1;

end;

function CSprite.DrawKadr(x,y: integer; newKadrPos: integer):Hresult;
var
  x1,x2,y1,y2: integer;
begin
  x1:=xx;
  y1:=yy+height*(newKadrPos-1);
  x2:=xx+width;
  y2:=y1+height;
  DrawRect(x,y,x1,y1,x2,y2);
  KadrI:=newKadrPos;
end;

function CSprite.DrawNextKadr(x,y: integer):Hresult;
begin
  KadrI:=KadrI+1;
  if KadrI>NKadr then KadrI:=1;
  DrawKadr(x,y,KadrI);
end;

function CSprite.DrawLastViewKadr(x,y: integer):Hresult;
begin
  DrawKadr(x,y,KadrI);
end;

function CSprite.Animate(x,y,FrameTime: dword):Hresult;
begin
  if (GetTickCount-Self.LastKadrTime)>=FrameTime then
  begin
    DrawNextKadr(x,y);
    Self.LastKadrTime:=GetTickCount;
  end
    else DrawLastViewKadr(x,y);
end;

function CSprite.GetKolKadr: integer;
begin
  result:=NKadr;
end;

function  CSprite.getXX: integer;
begin
  result:=xx;
end;

function  CSprite.getYY: integer;
begin
  result:= YY;
end;

function  CSprite.setXX(newXX: integer): hresult;
begin
  xx:=newXX;
end;
function  CSprite.setYY(newYY: integer): hresult;
begin
  yy:=newYY;
end;

function CSprite.AnimateOne(x,y,FrameTime: dword):boolean;
begin
  if KadrI=NKadr then
  begin
     Result:=true;
  end else
  if (GetTickCount-Self.LastKadrTime)>=FrameTime then
  begin
    DrawNextKadr(x,y);
    Self.LastKadrTime:=GetTickCount;
    Result:=False;
  end
    else
    begin
      DrawLastViewKadr(x,y);
      Result:=false;
    end;

end;

function CSprite.SetKadrI(newparam: integer): hresult;
begin
   KadrI:= newparam;
end;


function CSprite.AnimateT(x,y,FrameTime,Animatetime: dword):boolean;
begin
  if LastKadrTime>=(StartTime+AnimateTime)  then
  begin
     Result:=true;
  end else
  if (GetTickCount-Self.LastKadrTime)>=FrameTime then
  begin
    DrawNextKadr(x,y);
    Self.LastKadrTime:=GetTickCount;
    Result:=False;
  end
    else
    begin
      DrawLastViewKadr(x,y);
      Result:=false;
    end;
end;

end.
