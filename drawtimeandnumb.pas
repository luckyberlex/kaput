unit drawtimeandnumb;

interface

uses
types, BaseSprite;

function drawnumb(total: dword; nx,ny:integer;
                var spr: CSprite;  int: integer): hresult;
function drawnumbTime(tochnost: integer; total: dword; nx,ny:integer;
                        var  spr: CSprite; int: integer): hresult;
function drawABC(str: string; nx,ny: integer;
                        var spr: CSprite): hresult;
function drawnumbrol(total: dword; nx,ny:integer; nznak: integer;
                  var spr: CSprite;
              var sprrole: array of CSprite): hresult;
implementation

uses IronKaput;

function drawnumbTime(tochnost: integer; total: dword; nx,ny:integer;
                        var  spr: CSprite; int: integer): hresult;
var g,i: integer;
   mas: array [1..12] of integer;
begin
  g:=0;
  if tochnost<>1 then
  begin
  if total>35999 then
  begin
    g:=g+1;
    mas[g]:=total div 36000 ;
    total:=total-36000*mas[g];
  end;
  if total>3599 then
  begin
    g:=g+1;
    mas[g]:=total div 3600;
    total:=total-3600*mas[g];
  end else
 		begin
		  g:=g+1;
		  mas[g]:=0;
		end;
   g:=g+1;
   mas[g]:=-1;
  end;
  if total>599 then
  begin
    g:=g+1;
    mas[g]:=total div 600;
    total:=total-600*mas[g];
  end else if g>0 then
 		begin
		  g:=g+1;
		  mas[g]:=0;
		end;
  if total>59 then
  begin
    g:=g+1;
    mas[g]:=total div 60;
    total:=total-60*mas[g];
  end else
  	begin
      if tochnost=1 then
      begin
		    g:=g+1;
		    mas[g]:=0;
      end else
      begin
		    g:=g+1;
		    mas[g]:=1;
      end
		end;
  if tochnost=1 then
  begin
    g:=g+1;
    mas[g]:=-1;
    if total>9 then
    begin
      g:=g+1;
      mas[g]:=total div 10;
      total:=total-10*mas[g];
    end else
    begin
		  g:=g+1;
		  mas[g]:=0;
		end;
    if total>0 then
    begin
      g:=g+1;
      mas[g]:=total mod 10;
      total:=total-10*mas[g];
    end else
    	begin
		    g:=g+1;
		     mas[g]:=0;
		  end;
  end;

  i:=g;
  while i>0 do
  begin
    case mas[i] of
    0: Spr.DrawKadr(nx,ny,1);
    1: Spr.DrawKadr(nx,ny,2);
    2: Spr.DrawKadr(nx,ny,3);
    3: Spr.DrawKadr(nx,ny,4);
    4: Spr.DrawKadr(nx,ny,5);
    5: Spr.DrawKadr(nx,ny,6);
    6: Spr.DrawKadr(nx,ny,7);
    7: Spr.DrawKadr(nx,ny,8);
    8: Spr.DrawKadr(nx,ny,9);
    9: Spr.DrawKadr(nx,ny,10);
    -1: Spr.DrawKadr(nx,ny,11);
    end;
    if int=2 then
    begin
      nx:=nx-21;
    end else  nx:=nx-10;
    i:=i-1;
  end;
end;

function drawnumb(total: dword; nx,ny:integer;
                var spr: CSprite;  int: integer): hresult;
var g,i: integer;
   mas: array [1..20] of dword;
begin
    g:=0;
  if total>99999 then
  begin
    g:=g+1;
    mas[g]:=total div 100000;
    total:=total-100000*mas[g];
  end;
  if total>9999 then
  begin
    g:=g+1;
    mas[g]:=total div 10000;
    total:=total-10000*mas[g];
  end else if g>0 then
 		begin
		  g:=g+1;
		  mas[g]:=0;
		end;
  if total>999 then
  begin
    g:=g+1;
    mas[g]:=total div 1000;
    total:=total-1000*mas[g];
  end else if g>0 then
 		begin
		  g:=g+1;
		  mas[g]:=0;
		end;
  if total>99 then
  begin
    g:=g+1;
    mas[g]:=total div 100;
    total:=total-100*mas[g];
  end else if g>0 then
 		begin
		  g:=g+1;
		  mas[g]:=0;
		end;
  if total>9 then
  begin
    g:=g+1;
    mas[g]:=total div 10;
    total:=total-10*mas[g];
  end else if g>0 then
 		begin
		  g:=g+1;
		  mas[g]:=0;
		end;
  if total>0 then
  begin
    g:=g+1;
    mas[g]:=total mod 10;
    total:=total-10*mas[g];
  end else
  	begin
		  g:=g+1;
		  mas[g]:=0;
		end;
  i:=g;
  while i>0 do
  begin
    case mas[i] of
    0: Spr.DrawKadr(nx,ny,1);
    1: Spr.DrawKadr(nx,ny,2);
    2: Spr.DrawKadr(nx,ny,3);
    3: Spr.DrawKadr(nx,ny,4);
    4: Spr.DrawKadr(nx,ny,5);
    5: Spr.DrawKadr(nx,ny,6);
    6: Spr.DrawKadr(nx,ny,7);
    7: Spr.DrawKadr(nx,ny,8);
    8: Spr.DrawKadr(nx,ny,9);
    9: Spr.DrawKadr(nx,ny,10);
    end;
    if int=2 then
    begin
      nx:=nx-21;
    end else  nx:=nx-10;
    i:=i-1;
  end;
end;

function drawABC(str: string; nx,ny: integer;
                        var spr: CSprite): hresult;
var
  i,N: integer;
begin
  for I := 1 to Length(str) do
  begin
    N:=34;
    if str[i]= 'À' then N:=1;
    if str[i]= 'Á' then N:=2;
    if str[i]= 'Â' then N:=3;
    if str[i]= 'Ã' then N:=4;
    if str[i]= 'Ä' then N:=5;
    if str[i]= 'Å' then N:=6;
    if str[i]= '¨' then N:=7;
    if str[i]= 'Æ' then N:=8;
    if str[i]= 'Ç' then N:=9;
    if str[i]= 'È' then N:=10;
    if str[i]= 'É' then N:=11;
    if str[i]= 'Ê' then N:=12;
    if str[i]= 'Ë' then N:=13;
    if str[i]= 'Ì' then N:=14;
    if str[i]= 'Í' then N:=15;
    if str[i]= 'Î' then N:=16;
    if str[i]= 'Ï' then N:=17;
    if str[i]= 'Ð' then N:=18;
    if str[i]= 'Ñ' then N:=19;
    if str[i]= 'Ò' then N:=20;
    if str[i]= 'Ó' then N:=21;
    if str[i]= 'Ô' then N:=22;
    if str[i]= 'Õ' then N:=23;
    if str[i]= 'Ö' then N:=24;
    if str[i]= '×' then N:=25;
    if str[i]= 'Ø' then N:=26;
    if str[i]= 'Ù' then N:=27;
    if str[i]= 'Ú' then N:=28;
    if str[i]= 'Û' then N:=29;
    if str[i]= 'Ü' then N:=30;
    if str[i]= 'Ý' then N:=31;
    if str[i]= 'Þ' then N:=32;
    if str[i]= 'ß' then N:=33;
    Spr.DrawKadr(nx,ny,N);
    nx:=nx+30;
  end;
end;

function drawnumbrol(total: dword; nx,ny:integer;  nznak: integer;
                  var spr: CSprite;
              var sprrole: array of CSprite): hresult;
var g,i,time,nx1: integer;
   mas: array [1..20] of dword;
begin
  nx1:=nx;
  g:=0;
  if total>99999 then
  begin
    g:=g+1;
    mas[g]:=total div 100000;
    total:=total-100000*mas[g];
  end;
  if total>9999 then
  begin
    g:=g+1;
    mas[g]:=total div 10000;
    total:=total-10000*mas[g];
  end else if g>0 then
 		begin
		  g:=g+1;
		  mas[g]:=0;
		end;
  if total>999 then
  begin
    g:=g+1;
    mas[g]:=total div 1000;
    total:=total-1000*mas[g];
  end else if g>0 then
 		begin
		  g:=g+1;
		  mas[g]:=0;
		end;
  if total>99 then
  begin
    g:=g+1;
    mas[g]:=total div 100;
    total:=total-100*mas[g];
  end else if g>0 then
 		begin
		  g:=g+1;
		  mas[g]:=0;
		end;
  if total>9 then
  begin
    g:=g+1;
    mas[g]:=total div 10;
    total:=total-10*mas[g];
  end else if g>0 then
 		begin
		  g:=g+1;
		  mas[g]:=0;
		end;
  if total>0 then
  begin
    g:=g+1;
    mas[g]:=total mod 10;
    total:=total-10*mas[g];
  end else
  	begin
		  g:=g+1;
		  mas[g]:=0;
		end;
  for I := 1 to nznak-g do
    begin
      Spr.DrawKadr(nx,ny,11);
      nx:=nx+25;
    end;
  i:=1;
  while i<=g do
  begin
    case mas[i] of
    0: Spr.DrawKadr(nx,ny,1);
    1: Spr.DrawKadr(nx,ny,2);
    2: Spr.DrawKadr(nx,ny,3);
    3: Spr.DrawKadr(nx,ny,4);
    4: Spr.DrawKadr(nx,ny,5);
    5: Spr.DrawKadr(nx,ny,6);
    6: Spr.DrawKadr(nx,ny,7);
    7: Spr.DrawKadr(nx,ny,8);
    8: Spr.DrawKadr(nx,ny,9);
    9: Spr.DrawKadr(nx,ny,10);
    end;
    nx:=nx+25;
    i:=i+1;
  end;
  time:=500;
  for i := 0 to nznak-1 do
    begin
      sprrole[i].AnimateT(nx1,ny,50,time);
      if i=nznak-1 then
        if sprrole[i].AnimateT(nx1,ny,50,time)=true then
            mbaraban.stopaudio;

      nx1:=nx1+25;
      time:=time+500;

   end;
end;

end.
