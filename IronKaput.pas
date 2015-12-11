// КЛАССЫ ИГРОВЫХ ОБЪЕКТОВ "ЖЕЛЕЗНЫЙ КАПУТ"
// АВТОР: БЕРЁЗА А.В.

unit IronKaput;

interface

Uses DirectDraw,DirectDrawUsing,BaseSprite, types,Windows,Classes,
SoundManagerIronKaput,IronKaputBase;

const
  x1 = 468;
  x2 = 244;
  y1 = 692;
  y2 = 692;
type
  CTank = class(CGameElement)
  private
    vid: integer;
    FireSpeed: integer;       // скорострельность
    DefendFull: integer;      // максимальная броня
    DefendInTime: integer;    // броня на текущий момент
    Zdvig:    integer;        // для ровного смещения по 28 пикселей
    Orientation: integer;      // направление
    MoveFlag: boolean;         // стоит или едет;
    LastFireTime: dword;      // последнеее время выстрела
    NLife: integer;           // количество жизней оставшееся
    StarLevel: integer;       // уровень звезды
    LastMoveTime: dword;
    ConstMoveTime: integer;
    ConstMoveSdvig: integer;
    identificator: integer;   // 1 - первый игрок
                              // 2 - второй игрок
                              // 3 - противник
    bigzdvig: integer;
    timepovorot: integer;
    pregrada: boolean;
    stolknovenie: boolean;
    neujazvimost: boolean;
    mina: integer;
    lasttimemina: dword;
    globalzdvigY: integer;
    globalzdvigX: integer;
  public
    function Move(napravlenie: integer): boolean;  // движение
    function Fire: Hresult;                        // огонь
    function NotMove: Hresult;                     // стоять
    function Show(newx, newy: integer): Hresult;
    function Probuksovka: hresult;
    function initid(newid: integer):hresult;
    function GetZdvig: integer;
    function GetGlobalZdvigY: integer;
    function GetGlobalZdvigX: integer;
    function SETGlobalZdvigY(newparam: integer): hresult;
    function SETGlobalZdvigX(newparam: integer): hresult;
    function GetOrientation: integer;
    function GetMoveFlag: boolean;
    function SetOrientation(newOrient: integer):hresult;
    function SetZdvig(newzdvig: integer): hresult;
    function SetMoveGlag(param: boolean): hresult;
    function restore(newx,newy,neworient: integer): hresult;
    function init: hresult;
    function getstarlevel: integer;
    function getnlife: integer;
    function setnlife(newparam: integer): integer;
    function getdefendintime: integer;
    function setdefendintime(newparam: integer): integer;
    function popadanie(idpuli: integer): hresult;
    function initvrag(newvid: integer): hresult;
    function VragMove: boolean;
    function VragFire: Hresult;
    function getneujazvimost: boolean;
    function setneujazvimost(newparam: boolean): HRESULT;
    function getmina: integer;
    function SetMina(newparam: integer): hresult;
    function createmina: hresult;
    function GetID: integer;
    function setstarlevel(param: integer): integer;
  end;

  CFire = class (CGameElement)
  private
    napravlenie: integer;
    parent:  integer;  // // true->противника  false->игрока  //
  public
    function polet: hresult;
    Function SetParent(newParent: integer): hresult;
  end;

  CElement = class (CGameElement)
  private
    proletSnaryada: boolean;
    Unichtozhenie:  boolean;
    ProezdTanka:    boolean;
    razmer:         boolean; // true->56x56  false->28z28
    vid:            integer; // кадр
    sila:           integer;
    prozrachnost:   integer;
    basa:           boolean;
    active:         boolean;
    timetoactive:   dword;
  public
    function createWater(newx,newy: integer;
                                newkadr: integer): hresult;
    function createDom(newx,newy: integer;
                                newkadr: integer): hresult;
    function createGora(newx,newy: integer;
                                newkadr: integer): hresult;
    function createLes(newx,newy: integer;
                                newkadr: integer): hresult;
    function createmost(newx,newy: integer;
                                newkadr: integer): hresult;
   function createZabor(newx,newy: integer;
                                newkadr: integer): hresult;
    function createVoronka(newx,newy: integer;
                                newkadr: integer): hresult;
    function createBASA(newx,newy: integer;
                                newkadr: integer): hresult;
    function otobrazit:hresult;
    function GetproletSnaryada: boolean;
    function GetUnichtozhenie:  boolean;
    function GetProezdTanka:    boolean;
    function GetRazmer: boolean;
    function GetSila: integer;
    function SetSila(newparam: integer): integer;
    function GetVid: integer;
    function SetVid(newparam: integer): integer;
    function GetProzrachnost: integer;
    function SetActive(newparam: boolean): HRESULT;
    function SetTimetoactive(newparam: dword): HRESULT;
    function GetActive: boolean;
    function GetTimetoActive: dword;
  end;

  // эффекты выводятся хреново(неудобно)
  CEffect = class(CGameElement)
  private
  public
      function show: hresult;
      function init(newx,newy: integer): hresult;
  end;

  CBonus = class(CGameElement)
  private
    id: integer;
  public
    constructor Create(var Surf: COutSurface; newx,newy,vid: integer);
    function show: hresult;
  end;

  var
    masoffire: array[1..150] of CFire;
    countfire: integer;
    masofElem: array [1..500] of CElement;
    countelem: integer;
    masofPlayerTank: array [1..2]  of CTank;
    countplayers: integer;
    masofEffect1: array [1..150] of CEffect;
    counteffect: integer;
    masofOscolki: array [1..500] of CElement;
    countoscolki: integer;
    masofTOscolki: array [1..500] of CElement;
    countToscolki: integer;
    masofBonus: array [1..100] of CBonus;
    countbonus: integer;
    masofVragTank: array [1..100] of CTank;
    countvrag: integer;
    masofstena: array [1..100] of CElement;
    countstena: integer;
    masofmina: array [1..100] of CElement;
    countmina: integer;
    countmost: integer;
    masofmost: array [1..100] of CElement;
    Baza: CElement;
    OSEffect: COutSurface;
    OSBloks:   COutSurface;  // блоки
    OSFire:    COutSurface; // патрон
    ubito:  integer;
    vragintime: integer;
    vragovpokazano: integer;
    ubitotobonus: integer;
    stoptime: boolean;
    timeblock: integer;
    polePl1: integer;
    polePl2,kadrclosebaza: integer;
    defendbaza: boolean;
    defendbazaTime: integer;
    gameover: boolean;
    PreGO: boolean;
    totalScores: dword;
    bazadestroy: boolean;
    Pl1Preshow,Pl2PreShow: boolean;
    inradius: boolean;


    //////////////////////////////////////////////
    MMenu,MButton,MLevelStart,MFirePl,MFireVrag,MDomBah,
    MZaborBah,MBonus,MTankBah,MPopadanie,MDrdr,MGameOver,
    MBazaBah,  Mbazaclose, MBaraban: CSound;
    ///////////////////////////////////////////////



function CreateEffect(x,y, vid: integer): hresult;

implementation

uses Math;

{*************************************************************}
            ////CTANK/////
{*************************************************************}


function CTank.GetID: integer;
begin
  Result:=identificator;
end;

function CTank.setstarlevel(param: integer): integer;
begin
  self.StarLevel:=param;
  init;
end;

function CTank.SETGlobalZdvigY(newparam: integer): hresult;
begin
  globalzdvigY:=newparam;
end;
function CTank.SETGlobalZdvigX(newparam: integer): hresult;
begin
    globalzdvigX:=newparam;
end;

function CTank.Move(napravlenie: integer): boolean;
var
  j,i: integer;
  nalichiepregrady: boolean;
  buf: ctank;
begin
  result:=true;
  ConstMoveSdvig:=2;
  stolknovenie:=false;
  if self.identificator=1 then
  begin
     i:=2;
  end;
  if self.identificator=2 then
  begin
     i:=1;
  end;
  case napravlenie of
     1: begin                  // vverh
          if y>20 then
          begin
                if countelem>0 then
                 for j:=1 to countelem do
                 begin
                    if masofElem[j].GetRazmer=true then
                    begin
                      if (masofElem[j].GetX>GetX-56) and
                      (masofElem[j].GetX<GetX+56) and
                      (masofElem[j].GetY=GetY-56) then
                        if masofElem[j].GetProezdTanka=false then
                                      nalichiepregrady:=true;
                    end else
                      if (masofElem[j].GetX>GetX-28) and
                       (masofElem[j].GetX<GetX+56) and
                       (masofElem[j].GetY=GetY-28) then
                      if masofElem[j].GetProezdTanka=false then
                                        nalichiepregrady:=true;
                end;

              if countplayers>1 then
               BEGIN
                    if ((masofPlayerTank[i].GetX>GetX-56) and
                      (masofPlayerTank[i].GetX<GetX+56)) and
                      (masofPlayerTank[i].GetY+56=GetY) then
                       begin
                         nalichiepregrady:=true;
                         stolknovenie:=true;
                      end;
                end;

               for i:=ubito+1 to vragovpokazano do
                 begin
                    if ((masofVragTank[i].GetX>GetX-56) and
                      (masofVragTank[i].GetX<GetX+56)) and
                      (masofVragTank[i].GetY=GetY-56) then
                      begin
                         nalichiepregrady:=true;
                          stolknovenie:=true;
                      end;
                  end;

                if nalichiepregrady<>true then
                      begin
                       if GetTickCount-LastMoveTime>ConstMoveTime then
                       begin
                          y:=y-ConstMoveSdvig;
                          Animate(x,y,30);
                          zdvig:=zdvig+ConstMoveSdvig;
                          globalzdvigY:=globalzdvigY+ConstMoveSdvig;
                          LastMoveTime:=GetTickCount;
                       end else  Animate(x,y-1,30);
                      end;
           end else nalichiepregrady:=true;
        end;
      2: begin                  // vniz
          if y<692 then
          begin
                if countelem>0 then
                for j:=1 to countelem do
                begin
                if masofElem[j].GetRazmer=true then
                    begin
                      if (masofElem[j].GetX>GetX-56) and
                      (masofElem[j].GetX<GetX+56) and
                      (masofElem[j].GetY=GetY+56) then
                        if masofElem[j].GetProezdTanka=false then
                         nalichiepregrady:=true;
                    end else
                         if (masofElem[j].GetX>GetX-28) and
                       (masofElem[j].GetX<GetX+56) and
                      (masofElem[j].GetY=GetY+56) then
                        if masofElem[j].GetProezdTanka=false then
                         nalichiepregrady:=true;

                end;

               if countplayers>1 then
               BEGIn
                  if ((masofPlayerTank[i].GetX>GetX-56) and
                      (masofPlayerTank[i].GetX<GetX+56)) and
                      (masofPlayerTank[i].GetY=GetY+56) then
                      begin
                          nalichiepregrady:=true;
                          stolknovenie:=true;
                      end;
               end;

               for i:=ubito+1 to vragovpokazano do
                 begin
                    if ((masofVragTank[i].GetX>GetX-56) and
                      (masofVragTank[i].GetX<GetX+56)) and
                      (masofVragTank[i].GetY=GetY+56) then
                      begin
                         nalichiepregrady:=true;
                          stolknovenie:=true;
                      end;
                  end;

                  if zdvig=0 then
                 if ((356>=Getx-42) and
                   (356<=Getx+42)) and
                      (692=Gety+56) then
                      nalichiepregrady:=true;

               if nalichiepregrady<>true then
                      begin
                       if GetTickCount-LastMoveTime>ConstMoveTime then
                       begin
                          y:=y+ConstMoveSdvig;
                          Animate(x,y,30);
                          zdvig:=zdvig+ConstMoveSdvig;
                          globalzdvigY:=globalzdvigY-ConstMoveSdvig;
                          LastMoveTime:=GetTickCount;
                       end  else  Animate(x,y+1,30);
                      end;
           end else nalichiepregrady:=true;
        end;
      3: begin                  //vlevo
          if x>20 then
          begin
                if countelem>0 then
                 for j:=1 to countelem do
                 begin
                    if masofElem[j].GetRazmer=true then
                    begin
                      if (masofElem[j].GetY>GetY-56) and
                      (masofElem[j].GetY<GetY+56) and
                      (masofElem[j].GetX=GetX-56) then
                        if masofElem[j].GetProezdTanka=false then
                            nalichiepregrady:=true;
                    end else
                      if (masofElem[j].GetY>GetY-28) and
                       (masofElem[j].GetY<GetY+56) and
                        (masofElem[j].GetX=GetX-28) then
                        if masofElem[j].GetProezdTanka=false then
                                      nalichiepregrady:=true;
                 end;

          if countplayers>1 then
          begin
                    if ((masofPlayerTank[i].GetY>GetY-56) and
                      (masofPlayerTank[i].GetY<GetY+56)) and
                        (masofPlayerTank[i].GetX+56=getX) then
                        begin
                            nalichiepregrady:=true;
                            stolknovenie:=true;
                        end;

           end;

                 if zdvig=0 then
                 if ((692>=GetY-42) and
                   (692<=GetY+42)) and
                      (356=GetX-56) then
                      nalichiepregrady:=true;


              for i:=ubito+1 to vragovpokazano do
                 begin
                    if ((masofVragTank[i].GetY>GetY-56) and
                      (masofVragTank[i].GetY<GetY+56)) and
                      (masofVragTank[i].GetX=GetX-56) then
                      begin
                         nalichiepregrady:=true;
                          stolknovenie:=true;
                      end;
                  end;

                 if nalichiepregrady<>true then
                      begin
                       if GetTickCount-LastMoveTime>ConstMoveTime then
                       begin
                          x:=x-ConstMoveSdvig;
                          Animate(x,y,30);
                          zdvig:=zdvig+ConstMoveSdvig;
                          globalzdvigX:=globalzdvigX-ConstMoveSdvig;
                          LastMoveTime:=GetTickCount;
                       end else  Animate(x-1,y,30);
                      end;
           end else nalichiepregrady:=true;
        end;
      4: begin                  //vpravo
          if x<692 then
          begin
                if countelem>0 then
                 for j:=1 to countelem do
                 begin
                    if masofElem[j].GetRazmer=true then
                    begin
                      if (masofElem[j].GetY>GetY-56) and
                      (masofElem[j].GetY<GetY+56)  and
                      (masofElem[j].GetX=GetX+56) then
                        if masofElem[j].GetProezdTanka=false then
                            nalichiepregrady:=true;
                    end else
                           if (masofElem[j].GetY>GetY-28) and
                       (masofElem[j].GetY<GetY+56) and
                        (masofElem[j].GetX=GetX+56) then
                        if masofElem[j].GetProezdTanka=false then
                                      nalichiepregrady:=true;
                 end;

              if countplayers>1 then
              begin
                 if ((masofPlayerTank[i].GetY>GetY-56) and
                   (masofPlayerTank[i].GetY<GetY+56)) and
                      (masofPlayerTank[i].GetX=GetX+56) then
                      begin
                            nalichiepregrady:=true;
                            stolknovenie:=true;
                      end;
               end;

                 if zdvig=0 then
                 if ((692>=GetY-42) and
                   (692<=GetY+42)) and
                      (356=GetX+56) then
                      nalichiepregrady:=true;

                for i:=ubito+1 to vragovpokazano do
                 begin
                    if ((masofVragTank[i].GetY>GetY-56) and
                      (masofVragTank[i].GetY<GetY+56)) and
                      (masofVragTank[i].GetX=GetX+56) then
                      begin
                         nalichiepregrady:=true;
                          stolknovenie:=true;
                      end;
                  end;

                 if nalichiepregrady<>true then
                      begin
                       if GetTickCount-LastMoveTime>ConstMoveTime then
                       begin
                          x:=x+ConstMoveSdvig;
                          Animate(x,y,30);
                          zdvig:=zdvig+ConstMoveSdvig;
                          globalzdvigX:=globalzdvigX+ConstMoveSdvig;
                          LastMoveTime:=GetTickCount;
                       end else  Animate(x+1,y,30);
                      end;
           end else nalichiepregrady:=true;
        end;
  end;   //case

                  //////////////////////////
                 if countbonus>0 then
                 for j:=1 to countbonus do
                 begin
                    if self.identificator<>3 then
                    begin
                      if ((masofbonus[j].getx-45<=GetX) and
                        (masofbonus[j].getx+45>=GetX)) and
                        ((masofbonus[j].getY-45<=GetY) and
                        (masofbonus[j].getY+45>=GetY)) then
                         begin
                            totalScores:=totalScores+25;
                            MBonus.PlayAudio;
                           //if masofbonus[j].GetDestroy=false then
                            if masofbonus[j].id=5 then
                            begin
                                  starlevel:=StarLevel+1;
                                  if starlevel>3 then StarLevel:=3;
                                  init;
                            end;

                  /////////////////////////////////////////
                          if masofbonus[j].id=1 then
                            begin
                              for i:=ubito+1 to  vragovpokazano do
                              begin
                                masofVragTank[i].setdefendintime(1);
                                masofVragTank[i].popadanie(1);
                            end;
                          end;
                  //////////////////////////////////////
                        if masofbonus[j].id=4 then NLife:=NLife+1;
                  ///////////////////////////////////////
                        if masofbonus[j].id=3 then
                        begin
                         stoptime:=true;
                         timeblock:=0;
                        end;
                  ////////////////////////////////////////////////
                        if masofbonus[j].id=2 then
                        begin
                          neujazvimost:=true;
                          if identificator=1 then polePl1:=0;
                          if identificator=2 then polePl2:=0;
                        end;
                  ///////////////////////////////////////////////////
                        if masofbonus[j].id=6 then
                        begin
                          for i:=ubito+1 to  vragovpokazano do
                              begin
                                if (masofVragTank[i].GetY>590) and
                                (masofVragTank[i].GetX>250) and
                                (masofVragTank[i].GetX<460) then
                                begin
                                  masofVragTank[i].setdefendintime(1);
                                  masofVragTank[i].popadanie(1);
                                end;
                              end;
                         for i:=1 to countplayers do
                            if (masofPlayerTank[i].GetY>590) and
                            (masofPlayerTank[i].GetX>250)
                             and (masofPlayerTank[i].GetX<460) then
                             begin
                               if masofPlayerTank[i].GetID=1 then
                                masofPlayerTank[i].restore(x1,y1,1);
                               if masofPlayerTank[i].GetID=2 then
                                masofPlayerTank[i].restore(x2,y2,1);
                             end;
                          if defendbaza=false then
                          begin
                              Mbazaclose.PlayAudio;
                              kadrclosebaza:=1;
                          end;
                          defendbaza:=true;
                          DefendBazaTime:=0;
                        end;
                  ///////////////////////////////////////////////////
                      masofbonus[j].SetDestroy(true);
                 end;
               end;//if self
            end; //for
                //////////////////////////////

              {************************************}
            If countmina>0 then
              for i:=1 to countmina do
                if masofmina[i].GetActive then
                  if (getx>=masofmina[i].GetX-28) and
                  (getx<=masofmina[i].GetX) and
                  (gety>=masofmina[i].GetY-28) and
                  (getY<=masofmina[i].GetY) then
                    begin
                        DefendInTime:=1;
                        popadanie(3);
                        masofmina[i].SetDestroy(true);
                    end;
            {************************************}
  if nalichiepregrady=true then
  begin
    result:=false;
    MoveFlag:=false;
  end;

  if zdvig>=2 then
  begin
    zdvig:=0;
    MoveFlag:=false;
  end;

  if abs(globalzdvigY)>=14 then
  begin
    globalzdvigY:=0;
  end;

    if abs(globalzdvigX)>=14 then
  begin
    globalzdvigX:=0;
  end;

end;



function CTank.Fire: Hresult;
begin
  if GetTickCount-LastFireTime>FireSpeed then
  begin
    LastFireTime:=GetTickCount;
    countfire:=countfire+1;
    case (Orientation) of
      1: begin
          masoffire[countfire]:=CFire.Create(OSFire,0,0,10,10,1);
          masoffire[countfire].SetX(X+23);
          masoffire[countfire].SetY(Y);
          masoffire[countfire].napravlenie:=1;
        end;
      2: begin
          masoffire[countfire]:=CFire.Create(OSFire,0,20,10,10,1);
          masoffire[countfire].SetX(x+23);
          masoffire[countfire].SetY(y+55);
          masoffire[countfire].napravlenie:=2;
        end;
      3: begin
          masoffire[countfire]:=CFire.Create(OSFire,0,30,10,10,1);
          masoffire[countfire].SetX(x);
          masoffire[countfire].SetY(y+23);
          masoffire[countfire].napravlenie:=3;
        end;
      4: begin
          masoffire[countfire]:=CFire.Create(OSFire,0,10,10,10,1);
          masoffire[countfire].SetX(x+55);
          masoffire[countfire].SetY(y+23);
          masoffire[countfire].napravlenie:=4;
        end;
    end; // case
      masoffire[countfire].SetParent(identificator);
      MFirePl.PlayAudio;
  end;  //if

end;

function CTank.NotMove: Hresult;
begin
  DrawLastViewKadr(x,y);
end;

function CTank.Show(newx, newy: integer): Hresult;
begin
  x:=newx;
  y:=newy;
  DrawKadr(x,y,1);
end;

function CTank.GetZdvig: integer;
begin
  result:=zdvig;
end;

function CTank.SetOrientation(newOrient: integer):hresult;
begin
  if stolknovenie=false then
  begin
  case newOrient of
    1:  begin
          if (Orientation=2)  then
          begin
             setXX(getwidth+vid);
             Orientation:=newOrient;
          end
          else
            if globalzdvigX=0 then
            begin
             setXX(getwidth+vid);
             Orientation:=newOrient;
            end;
        end;
    2:  begin
          if (Orientation=1) then
          begin
             setXX(0+vid);
             Orientation:=newOrient;
          end
          else if globalzdvigX=0 then
          begin
             setXX(0+vid);
             Orientation:=newOrient;
          end;
        end;
    3:  begin
          if (Orientation=4)  then
          begin
            setXX(getwidth*3+vid);
            Orientation:=newOrient;
          end
          else if globalzdvigY=0 then
          begin
             setXX(getwidth*3+vid);
             Orientation:=newOrient;
          end;
        end;
    4:  begin
          if (Orientation=3) then
          begin
             setXX(getwidth*2+vid);
             Orientation:=newOrient;
          end
          else if globalzdvigY=0 then
          begin
             setXX(getwidth*2+vid);
             Orientation:=newOrient;
          end;
        end;
    end; //case
  end else// if stolknovenie=false then
  begin
    Orientation:=newOrient;
    case newOrient of
      1: setXX(getwidth+vid);
      2: setXX(0+vid);
      3: setXX(getwidth*3+vid);
      4: setXX(getwidth*2+vid);
    end;
  end;
end;

function Ctank.SetZdvig(newzdvig: integer): hresult;
begin
  zdvig:=newzdvig;
end;

function Ctank.GetOrientation: integer;
begin
  result:= Orientation;
  DrawLastViewKadr(x,y);
end;

function CTank.GetMoveFlag: boolean;
begin
  result:=MoveFlag;
end;

function CTank.SetMoveGlag(param: boolean): hresult;
begin
  MoveFlag:=param;
end;

function CTank.Probuksovka: hresult;
begin
  Animate(x,y,30);
end;


function  CTank.restore(newx,newy,neworient: integer): hresult;
begin
  destroy:=false;
  x:=newx;
  y:=newy;
  zdvig:=0;
  MoveFlag:=false;
  SetOrientation(neworient);
  LastFireTime:=GetTickCount;
  globalzdvigY:=0;
  globalzdvigX:=0;
end;




function CTank.initid(newid: integer): hresult;
begin
   identificator:=newid;
   StarLevel:=0;
   init;
   NLife:=3;
   vid:=0;
   destroy:=false;
   neujazvimost:=false;
   mina:=3;
end;

function Ctank.init: hresult;
begin
    destroy:=false;
   case starlevel of
   0: begin
        FireSpeed:=1200;
        ConstMoveTime:=15;
        DefendFull:=1;
        DefendInTime:=DefendFull;
        vid:=0;
      end;
   1: begin
        FireSpeed:=1000;
        ConstMoveTime:=15;
        DefendFull:=2;
        DefendInTime:=DefendFull;
        vid:=224;
      end;
   2: begin
        FireSpeed:=750;
        ConstMoveTime:=10;
        DefendFull:=2;
        DefendInTime:=DefendFull;
        vid:=448;
      end;
   3: begin
        FireSpeed:=500;
        ConstMoveTime:=10;
        DefendFull:=3;
        DefendInTime:=DefendFull;
        vid:=672;
      end;
   end;
end;

function Ctank.initvrag(newvid: integer): hresult;
begin
     neujazvimost:=false;
     destroy:=false;
     StarLevel:=newvid;
     identificator:=3;
     globalzdvigY:=0;
     globalzdvigX:=0;
        case starlevel of
   1: begin
        FireSpeed:=2000;
        ConstMoveTime:=20;
        DefendFull:=1;
        DefendInTime:=DefendFull;
        vid:=0;
      end;
   2: begin
        FireSpeed:=1900;
        ConstMoveTime:=10;
        DefendFull:=1;
        DefendInTime:=DefendFull;
        vid:=224;
      end;
   3: begin
        FireSpeed:=1800;
        ConstMoveTime:=20;
        DefendFull:=3;
        DefendInTime:=DefendFull;
        vid:=448;
      end;
   end;
end;

function Ctank.getstarlevel: integer;
begin
  Result:=StarLevel;
end;

function Ctank.getdefendintime: integer;
begin
  Result:= defendintime;
end;
///////////////////////////////////////////////////////////////////
function Ctank.popadanie(idpuli: integer): hresult;
var i,j: integer;
buf: Ctank;
begin
  if ((identificator<>3) and (idpuli=3))
        or ((identificator=3) and (idpuli<>3)) then
  begin
     if neujazvimost=false then
     begin
      if DefendInTime=1 then
      begin
        MTankBah.PlayAudio;
        createeffect(GetX-28,GetY-28,1);
        countToscolki:=countToscolki+1;
        masofTOscolki[countToscolki]:=CElement.Create(OSBloks,336,0,56,56,1);
        masofTOscolki[countToscolki].createVoronka(GetX,GetY,1);

        if countToscolki>1 then
        begin
          for j:=1 to countToscolki-1 do
          begin
            if (masofTOscolki[j].GetX>masofTOscolki[countToscolki].GetX-56)
            and (masofTOscolki[j].GetX<masofTOscolki[countToscolki].GetX+56)
            and (masofTOscolki[j].GetY>masofTOscolki[countToscolki].GetY-56)
            and (masofTOscolki[j].GetY<masofTOscolki[countToscolki].GetY+56)
            then masofTOscolki[j].SetDestroy(true);
          end;
        end;

        if identificator=3 then destroy:=true;
        if identificator<>3 then
        begin
          StarLevel:=0;
          init;
          NLife:=NLife-1;
          if nlife<=0 then
          begin
                restore(-100,-100,1);
                NLife:=0;
                if countplayers>1 then
                begin
                    if (masofPlayerTank[1].getnlife=0) and
                     (masofPlayerTank[2].getnlife=0) then
                       PreGO:=true;
                end else PreGO:=true;
          end  else
            begin
              if identificator=1 then
              begin
                 Pl1Preshow:=true;
                 restore(-1000,-1000,1);
              end;
              if identificator=2 then
              begin
                  Pl2PreShow:=true;
                    restore(-1000,-1000,1);
              end;
            end;
        end;

      end else
            begin
              MPopadanie.PlayAudio;
              DefendInTime:=DefendInTime-1;
              createeffect(GetX-28,GetY-28,2);
            end;
      end;
    end;

end;
///////////////////////////////////////////////////////////////
function Ctank.setdefendintime(newparam: integer): integer;
begin
    DefendInTime:=newparam;
end;


function Ctank.GetGlobalZdvigY: integer;
begin
  Result:=globalzdvigY;
end;
function Ctank.GetGlobalZdvigX: integer;
begin
  Result:=globalzdvigX;
end;
///////////////////////////////////////////////////////////////
function Ctank.VragMove: boolean;
var
  j,i,napravlenie: integer;
  pregradasleva,
  pregradasprava,
  pregradasverhu,
  pregradasnizu,
  nalichiepregrady: boolean;
begin
  result:=true;
  ConstMoveSdvig:=2;
  stolknovenie:=false;
  napravlenie:=Orientation;
  nalichiepregrady:=false;
  pregradasleva:=false;
  pregradasprava:=false;
  pregradasverhu:=false;
  pregradasnizu:=false;
  pregrada:=false;
  case napravlenie of
     1: begin                  // vverh
          if y>20 then
          begin
              if countelem>0 then
              begin
                 for j:=1 to countelem do
                 begin
                    if masofElem[j].GetRazmer=true then
                    begin
                      if (masofElem[j].GetX>GetX-56) and
                      (masofElem[j].GetX<GetX+56) and
                      (masofElem[j].GetY=GetY-56) then
                      if masofElem[j].GetProezdTanka=false then
                        begin
                            pregradasverhu:=true;
                            nalichiepregrady:=true;
                        end;
                    end else
                      if (masofElem[j].GetX>GetX-28) and
                       (masofElem[j].GetX<GetX+56)  and
                       (masofElem[j].GetY=GetY-28) then
                        if masofElem[j].GetProezdTanka=false then
                        begin
                          pregradasverhu:=true;
                          nalichiepregrady:=true;
                        end;
                end;
            end;

            for i:=1 to countplayers do
                begin
                    if ((masofPlayerTank[i].GetX>GetX-56) and
                      (masofPlayerTank[i].GetX<GetX+56)) and
                      (masofPlayerTank[i].GetY=GetY-56) then
                      begin
                         nalichiepregrady:=true;
                          stolknovenie:=true;
                      end;
                end;

             for i:=ubito+1 to vragovpokazano do
                 begin
                    if self<>masofVragTank[i] then
                    if ((masofVragTank[i].GetX>GetX-56) and
                      (masofVragTank[i].GetX<GetX+56)) and
                      (masofVragTank[i].GetY=GetY-56) then
                      begin
                         nalichiepregrady:=true;
                          stolknovenie:=true;
                      end;
                  end;

        end else
        begin
         pregradasverhu:=true;
         nalichiepregrady:=true;
        end;
           if nalichiepregrady=false then
           begin
                       if GetTickCount-LastMoveTime>ConstMoveTime then
                       begin
                          y:=y-ConstMoveSdvig;
                          Animate(x,y,30);
                          zdvig:=zdvig+ConstMoveSdvig;
                          globalzdvigY:=globalzdvigY-ConstMoveSdvig;
                          LastMoveTime:=GetTickCount;
                       end else  Animate(x,y-1,30);
          end else Probuksovka;
        end;
      2: begin                  // vniz
          if y<692 then
          begin
              if countelem>0 then
              begin
                for j:=1 to countelem do
                begin
                if masofElem[j].GetRazmer=true then
                    begin
                      if (masofElem[j].GetX>GetX-56) and
                      (masofElem[j].GetX<GetX+56)and
                      (masofElem[j].GetY=GetY+56) then
                        if masofElem[j].GetProezdTanka=false then
                        begin
                          pregradasnizu:=true;
                          nalichiepregrady:=true;
                          pregrada:=true;
                        end;
                    end else
                         if (masofElem[j].GetX>GetX-28) and
                       (masofElem[j].GetX<GetX+56)  and
                      (masofElem[j].GetY=GetY+56) then
                        if masofElem[j].GetProezdTanka=false then
                        begin
                          nalichiepregrady:=true;
                          pregradasnizu:=true;
                          pregrada:=true;
                        end;
                end;
              end;


              for i:=1 to countplayers do
                if ((masofPlayerTank[i].GetX>GetX-56) and
                      (masofPlayerTank[i].GetX<GetX+56)) and
                      (masofPlayerTank[i].GetY=GetY+56) then
                      begin
                          nalichiepregrady:=true;
                          stolknovenie:=true;
                      end;



              if zdvig=0 then
                 if ((356>=Getx-42) and
                   (356<=Getx+42)) and
                      (692=Gety+56) then
                      nalichiepregrady:=true;

              if zdvig=0 then
                for i:=ubito+1 to vragovpokazano do
                 begin
                    if self<>masofVragTank[i] then
                      if ((masofVragTank[i].GetX>GetX-56) and
                        (masofVragTank[i].GetX<GetX+56)) and
                        (masofVragTank[i].GetY=GetY+56) then
                        begin
                          nalichiepregrady:=true;
                          stolknovenie:=true;
                        end;
                  end;
          end else
          begin
            pregradasnizu:=true;
            nalichiepregrady:=true;
          end;
          //////////////////
                   if nalichiepregrady=false then
                   begin
                       if GetTickCount-LastMoveTime>ConstMoveTime then
                       begin
                          y:=y+ConstMoveSdvig;
                          Animate(x,y,30);
                          zdvig:=zdvig+ConstMoveSdvig;
                          globalzdvigY:=globalzdvigY+ConstMoveSdvig;
                          LastMoveTime:=GetTickCount;
                       end  else  Animate(x,y+1,30);
                   end else Probuksovka;
        end;
      3: begin                  //vlevo
          if x>20 then
          begin
              if countelem>0 then
                 for j:=1 to countelem do
                 begin
                    if masofElem[j].GetRazmer=true then
                    begin
                      if (masofElem[j].GetY>GetY-56) and
                      (masofElem[j].GetY<GetY+56) and
                      (masofElem[j].GetX=GetX-56) then
                        if masofElem[j].GetProezdTanka=false then
                        begin
                            pregradasleva:=true;
                            nalichiepregrady:=true;
                            if masofElem[j].GetUnichtozhenie then
                            pregrada:=true;
                        end;
                    end else
                      if (masofElem[j].GetY>GetY-28) and
                       (masofElem[j].GetY<GetY+56) and
                        (masofElem[j].GetX=GetX-28) then
                        if masofElem[j].GetProezdTanka=false then
                        begin
                            pregradasleva:=true;
                            nalichiepregrady:=true;
                            if masofElem[j].GetUnichtozhenie then
                            pregrada:=true;
                        end;
                 end;

              for i:=ubito+1 to vragovpokazano do
                 begin
                    if ((masofVragTank[i].GetY>GetY-56) and
                      (masofVragTank[i].GetY<GetY+56)) and
                      (masofVragTank[i].GetX=GetX-56) then
                      begin
                         nalichiepregrady:=true;
                         stolknovenie:=true;
                      end;
                  end;


                 if zdvig=0 then
                 if ((692>=GetY-42) and
                   (692<=GetY+42)) and
                      (356=GetX-56) then
                      nalichiepregrady:=true;


                for i:=1 to countplayers do
                  begin
                   if self<>masofVragTank[i] then
                    if ((masofPlayerTank[i].GetY>GetY-56) and
                      (masofPlayerTank[i].GetY<GetY+56)) and
                        (masofPlayerTank[i].GetX=GetX-56) then
                        begin
                            nalichiepregrady:=true;
                            stolknovenie:=true;
                        end;
                  end;
            end else
                        begin
                            pregradasleva:=true;
                            nalichiepregrady:=true;
                        end;

                  if nalichiepregrady=false then
                  begin
                       if GetTickCount-LastMoveTime>ConstMoveTime then
                       begin
                          x:=x-ConstMoveSdvig;
                          Animate(x,y,30);
                          zdvig:=zdvig+ConstMoveSdvig;
                          globalzdvigX:=globalzdvigX-ConstMoveSdvig;
                          LastMoveTime:=GetTickCount;
                       end else  Animate(x-1,y,30);
                  end else Probuksovka;
        end;
      4: begin                  //vpravo
          if x<692 then
          begin
              if countelem>0 then
              begin
                 for j:=1 to countelem do
                 begin
                    if masofElem[j].GetRazmer=true then
                    begin
                      if (masofElem[j].GetY>GetY-56) and
                      (masofElem[j].GetY<GetY+56) and
                      (masofElem[j].GetX=GetX+56) then
                        if masofElem[j].GetProezdTanka=false then
                        begin
                           pregradasprava:=true;
                            nalichiepregrady:=true;
                            if masofElem[j].GetUnichtozhenie then
                            pregrada:=true;
                        end;
                    end else
                        if (masofElem[j].GetY>GetY-28) and
                       (masofElem[j].GetY<GetY+56) and
                        (masofElem[j].GetX=GetX+56) then
                        if masofElem[j].GetProezdTanka=false then
                            begin
                           pregradasprava:=true;
                            nalichiepregrady:=true;
                            if masofElem[j].GetUnichtozhenie then
                            pregrada:=true;
                        end;
                 end;
              end;

                for i:=1 to countplayers do
                 if ((masofPlayerTank[i].GetY>GetY-56) and
                   (masofPlayerTank[i].GetY<GetY+56)) and
                      (masofPlayerTank[i].GetX=GetX+56) then
                      begin
                            nalichiepregrady:=true;
                            stolknovenie:=true;
                      end;

                             if zdvig=0 then
                 if ((692>=GetY-42) and
                   (692<=GetY+42)) and
                      (356=GetX+56) then
                      nalichiepregrady:=true;

                for i:=ubito+1 to vragovpokazano do
                 begin
                    if self<>masofVragTank[i] then
                    if ((masofVragTank[i].GetY>GetY-56) and
                      (masofVragTank[i].GetY<GetY+56)) and
                      (masofVragTank[i].GetX=GetX+56) then
                      begin
                         nalichiepregrady:=true;
                         stolknovenie:=true;
                      end;
                  end;
          end else
                       begin
                           pregradasprava:=true;
                            nalichiepregrady:=true;
                        end;

                   if nalichiepregrady=false then
                   begin
                       if GetTickCount-LastMoveTime>ConstMoveTime then
                       begin
                          x:=x+ConstMoveSdvig;
                          globalzdvigX:=globalzdvigX+ConstMoveSdvig;
                          Animate(x,y,30);
                          zdvig:=zdvig+ConstMoveSdvig;
                          LastMoveTime:=GetTickCount;
                       end else  Animate(x+1,y,30);
                   end else Probuksovka;
        end;
  end;   //case

       {  if countbonus>0 then
                 for j:=1 to countbonus do
                 begin
                    if self.identificator=3 then
                    begin
                      if ((masofbonus[j].getx-45<=GetX) and
                        (masofbonus[j].getx+45>=GetX)) and
                        ((masofbonus[j].getY-45<=GetY) and
                        (masofbonus[j].getY+45>=GetY)) then
                         begin
                          masofbonus[j].SetDestroy(true);
                        end;
                    end;
                 end;

        }
  {************************************}
            If countmina>0 then
              for i:=1 to countmina do
                if masofmina[i].GetActive then
                  if (getx>=masofmina[i].GetX-28) and
                  (getx<=masofmina[i].GetX) and
                  (gety>=masofmina[i].GetY-28) and
                  (getY<=masofmina[i].GetY) then
                    begin
                        DefendInTime:=1;
                        popadanie(1);
                        masofmina[i].SetDestroy(true);
                    end;
            {************************************}




   /////////////////////////////////////////////////////////
  if zdvig>=2 then
  begin
    zdvig:=0;
    MoveFlag:=false;
  end;

  if abs(globalzdvigY)>=14 then
  begin
    globalzdvigY:=0;
    bigzdvig:=bigzdvig-1;
  end;

    if abs(globalzdvigX)>=14 then
  begin
    globalzdvigX:=0;
    bigzdvig:=bigzdvig-1;
  end;

  if nalichiepregrady then bigzdvig:=0;

  {inradius:=false;
  for i:=1 to countplayers do
  begin
    if GetX+112>masofPlayerTank[i].GetX then
    begin
      SetOrientation(2);
      inradius:=true;
    end;
    if GetX-112<masofPlayerTank[i].GetX then
    begin
      SetOrientation(1);
      inradius:=true;
    end;
    if GetY+112>masofPlayerTank[i].GetX then
    begin
      SetOrientation(4);
      inradius:=true;
    end;
    if GetX-112<masofPlayerTank[i].GetX then
    begin
      SetOrientation(3);
      inradius:=true;
    end;
  end;  }

  if inradius=false then
  begin
    if bigzdvig<=0 then
    begin
      if Orientation<>2 then
      begin
          if GetTickCount-timepovorot>1000 then
          begin
            SetOrientation(2);
            bigzdvig:=RandomRange(5,26);
            timepovorot:=GetTickCount;
          end else NotMove;
      end
      else
      begin
        if GetTickCount-timepovorot>1000 then
          begin
            SetOrientation(RandomRange(2,5));
            bigzdvig:=RandomRange(1,26);
            timepovorot:=GetTickCount;
          end else  NotMove;
      end;
    end;
  end;




end;

function CTank.getnlife: integer;
begin
 Result:=NLife;
end;

function CTank.setnlife(newparam: integer): integer;
begin
 NLife:=newparam;
end;

function CTank.VragFire: Hresult;
var
  i: integer;
  tanknalinii: boolean;
begin
  tanknalinii:=false;
  for i:=ubito+1 to vragovpokazano do
  begin
    if self<>masofVragTank[i] then
    begin
      if (Orientation=4) then
        if pregrada<>true then tanknalinii:=true;

      if (Orientation=3) then
        if pregrada<>true then tanknalinii:=true;
      if (Orientation=2) then
        if pregrada<>true then
          if ((masofVragTank[i].GetX>=GetX-56) and
             (masofVragTank[i].GetX<=GetX+56)) and
             (masofVragTank[i].GetY>GetY) then
                    tanknalinii:=true;

      if {masofVragTank[i].}GetY>=691 then
       begin
          if (Orientation=4) then
            {if ((masofVragTank[i].GetY>=GetY-100) and
             (masofVragTank[i].GetY<=GetY+32)) and
             (masofVragTank[i].GetX>Getx) and
             (masofVragTank[i].GetX<=358)  then
                tanknalinii:=true else} tanknalinii:=false;
      if (Orientation=3) then
         {if ((masofVragTank[i].GetY>=GetY-100) and
             (masofVragTank[i].GetY<=GetY+32)) and
             (masofVragTank[i].GetX<Getx) and
             (masofVragTank[i].GetX>358) then
                    tanknalinii:=true else} tanknalinii:=false;
       end;

    end;
  end;
  if (GetTickCount-LastFireTime>FireSpeed) and
  (tanknalinii=false) then
  begin
    LastFireTime:=GetTickCount;
    countfire:=countfire+1;
    case (Orientation) of
      1: begin
          masoffire[countfire]:=CFire.Create(OSFire,0,0,10,10,1);
          if StarLevel=3 then masoffire[countfire].setXX(10);
          masoffire[countfire].SetX(X+23);
          masoffire[countfire].SetY(Y);
          masoffire[countfire].napravlenie:=1;
        end;
      2: begin
          masoffire[countfire]:=CFire.Create(OSFire,0,20,10,10,1);
          if StarLevel=3 then masoffire[countfire].setXX(10);
          masoffire[countfire].SetX(x+23);
          masoffire[countfire].SetY(y+55);
          masoffire[countfire].napravlenie:=2;
        end;
      3: begin
          masoffire[countfire]:=CFire.Create(OSFire,0,30,10,10,1);
          if StarLevel=3 then masoffire[countfire].setXX(10);
          masoffire[countfire].SetX(x);
          masoffire[countfire].SetY(y+23);
          masoffire[countfire].napravlenie:=3;
        end;
      4: begin
          masoffire[countfire]:=CFire.Create(OSFire,0,10,10,10,1);
          if StarLevel=3 then masoffire[countfire].setXX(10);
          masoffire[countfire].SetX(x+55);
          masoffire[countfire].SetY(y+23);
          masoffire[countfire].napravlenie:=4;
        end;
    end; // case
      masoffire[countfire].SetParent(identificator);
      MFireVrag.PlayAudio;
  end;  //if

end;

function CTank.getmina: integer;
begin
  Result:=mina;
end;

function Ctank.getneujazvimost: boolean;
begin
  Result:=neujazvimost;
end;
function CTank.setneujazvimost(newparam: boolean): HRESULT;
begin
  neujazvimost:=newparam;
end;


function Ctank.SetMina(newparam: integer): hresult;
begin
  mina:=newparam;
end;

function CTank.createmina: HRESULT;
begin
    if GetTickCount-lasttimemina>500 then
    if mina>0 then
    begin
     countmina:=countmina+1;
     masofmina[countmina]:=CElement.Create(OSBloks,0,280,28,28,2);
     masofmina[countmina].createVoronka(GetX+14,
     GetY+14,1);
     mina:=mina-1;
     lasttimemina:=GetTickCount;
     masofmina[countmina].SetActive(false);
     masofmina[countmina].SetTimetoactive(GetTickCount);
    end;
end;
//////////////////////////////////////////////////////////////
//////////////// CFIRE /////////////////////////////////////////
//////////////////////////////////////////////////////////////



////////////////////////////////////
function CFire.polet: hresult;
var
  j,i,newcountelem: integer;
  buf: CTank;
begin
  case napravlenie of
    1:  y:=y-7;
    2:  y:=y+7;
    3:  x:=x-7;
    4:  x:=x+7;
  end;

        newcountelem:=countelem;
        if countelem>0 then
             for j:=1 to countelem do
             begin
                if (masofElem[j].GetRazmer=true) then
                begin
                  if ((masofElem[j].GetY+56>GetY) and
                    (masofElem[j].GetY-6<GetY)) and
                    ((masofElem[j].GetX+56>GetX) and
                    (masofElem[j].GetX-6<GetX)) then
                       if masofElem[j].GetproletSnaryada=false then
                       begin
                          destroy:=true;
                          if masofElem[j].GetUnichtozhenie=true then
                          begin
                  if masofElem[j].GetSila>0 then
                  begin
                    MPopadanie.PlayAudio;
                    masofElem[j].SetSila(masofElem[j].GetSila-1);
                    masofElem[j].SetVid(masofElem[j].GetVid+1);

                    createeffect(masofElem[j].GetX-28,
                                          masofElem[j].GetY-28,2);
                  end else
                  begin
                  createeffect(masofElem[j].GetX-28,
                                          masofElem[j].GetY-28,1);
                   masofElem[j].SetDestroy(true);

                  end;

                           end;
                       end;
                end else
                     if ((masofElem[j].GetY+28>GetY) and
                    (masofElem[j].GetY-6<GetY)) and
                    ((masofElem[j].GetX+28>GetX) and
                    (masofElem[j].GetX-6<GetX)) then
                       if masofElem[j].GetproletSnaryada=false then
                       begin
                          destroy:=true;
                          if masofElem[j].GetUnichtozhenie=true then
                          begin
                          if (masofElem[j].GetY>=636) and
                          (masofElem[j].GetX>=300) and
                          (masofElem[j].GetX<=440) then
                          begin
                            if defendbaza=false then
                            begin
                                countstena:=countstena+1;
                                masofstena[countstena]:=masofElem[j];
                           masofElem[j].SetDestroy(true);

                  createeffect(masofElem[j].GetX-42,
                                          masofElem[j].GetY-42,2);
                            end else
                            begin
                              createeffect(GetX-56,GetY-56,2);
                            end;
                          end else
                          begin
                          masofElem[j].SetDestroy(true);

                           createeffect(masofElem[j].GetX-42,
                                          masofElem[j].GetY-42,2);
                          end;
                       end;
                  end;
             end;

              for i:=1 to countplayers do
                if ((GetX>masofPlayerTank[i].GetX) and
                   (GetX<masofPlayerTank[i].GetX+51)) and
                   ((GetY>masofPlayerTank[i].GetY)and
                   (GetY<masofPlayerTank[i].GetY+51)) then
                   begin
                    destroy:=true;
                    masofPlayerTank[i].popadanie(parent);
                   end;

              for i:=ubito+1 to  vragovpokazano do
                  if ((GetX>masofVragTank[i].GetX) and
                   (GetX<masofVragTank[i].GetX+51)) and
                   ((GetY>masofVragTank[i].GetY)and
                   (GetY<masofVragTank[i].GetY+51)) then
                   begin
                    destroy:=true;
                    masofVragTank[i].popadanie(parent);
                  end;

           if ((GetX>356) and
              (GetX<412)) and
              (GetY>692) then
           begin
              destroy:=true;
              if preGO=false then
              begin
        createeffect(328,664,1);
        if PreGO=false then MBazaBah.PlayAudio;
          countoscolki:=countoscolki+1;
          masofOscolki[countoscolki]:=CElement.Create(OSBloks,196,0,112,112,3);
          masofOscolki[countoscolki].createVoronka(328,664,1);
              end;
            PreGO:=true;
            bazadestroy:=true;
           end;


  if (GetY>738) or
    (GetY<22) or
    (Getx>738) or
    (Getx<22) then
    destroy:=true;
  if destroy=false then
        DrawKadr(x,y,1);


end;




Function CFire.SetParent(newParent: integer): hresult;
begin
  parent:=newParent;
end;

////////////////////////////////////////////////////////////////////
///////////////CELEMENT/////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
function CElement.createBASA(newx,newy: integer;
                                newkadr: integer): hresult;
begin
  proletSnaryada:=false;
  Unichtozhenie:=true;
  ProezdTanka:=false;
  x:=newx;
  y:=newy;
  destroy:=false;
  razmer:=True;
  vid:=newkadr;
  sila:=0;
  basa:=true;
end;

function CElement.createWater(newx,newy: integer;
                                newkadr: integer): hresult;
begin
  proletSnaryada:=true;
  Unichtozhenie:=false;
  ProezdTanka:=false;
  x:=newx;
  y:=newy;
  destroy:=false;
  razmer:=True;
  vid:=newkadr;
  sila:=0;
end;

function CElement.createDom(newx,newy: integer;
                                newkadr: integer): hresult;
begin
  proletSnaryada:=false;
  Unichtozhenie:=true;
  ProezdTanka:=false;
  x:=newx;
  y:=newy;
  destroy:=false;
  razmer:=true;
  vid:=newkadr;
  sila:=2;
end;
function CElement.createGora(newx,newy: integer;
                                newkadr: integer): hresult;
begin
  proletSnaryada:=false;
  Unichtozhenie:=false;
  ProezdTanka:=false;
  x:=newx;
  y:=newy;
  destroy:=false;
  razmer:=true;
  vid:=newkadr;
  sila:=0;
end;
function CElement.createLes(newx,newy: integer;
                                newkadr: integer): hresult;
begin
  proletSnaryada:=true;
  Unichtozhenie:=false;
  ProezdTanka:=true;
  x:=newx;
  y:=newy;
  destroy:=false;
  razmer:=true;
  vid:=newkadr;
  sila:=0;
  prozrachnost:=1;
end;
function CElement.createmost(newx,newy: integer;
                                newkadr: integer): hresult;
begin
  proletSnaryada:=true;
  Unichtozhenie:=false;
  ProezdTanka:=true;
  x:=newx;
  y:=newy;
  destroy:=false;
  razmer:=true;
  vid:=newkadr;
  sila:=0;
end;

function CElement.createZabor(newx,newy: integer;
                                newkadr: integer): hresult;
begin
  proletSnaryada:=false;
  Unichtozhenie:=true;
  ProezdTanka:=false;
  x:=newx;
  y:=newy;
  destroy:=false;
  razmer:=false;
  vid:=newkadr;
  sila:=0;
end;

function CElement.createVoronka(newx,newy: integer;
                                newkadr: integer): hresult;
begin
  proletSnaryada:=true;
  Unichtozhenie:=false;
  ProezdTanka:=true;
  x:=newx;
  y:=newy;
  destroy:=false;
  razmer:=true;
  vid:=newkadr;
  sila:=0;
end;

function CElement.otobrazit:hresult;
var
  x11,x22,y11,y22,TY,TX: integer;
begin
  TY:=y;
  TX:=x;
  x11:=getXX;
  y11:=getyy+getheight*(vid-1);
  x22:=getxx+getwidth;
  y22:=y11+getheight;
  if getwidth=112 then
  begin
    if y<20 then
    begin
      y11:=y11+20-TY;
      TY:=20;
    end;
    if y>=663 then
    begin
      y22:=y22-28;
    end;
    if x>=663 then
    begin
      x22:=x22-28;
    end;
    if x<20 then
    begin
      x11:=x11+20-TX;
      TX:=20;
    end;
  end;
  DrawRect(Tx,Ty,x11,y11,x22,y22);
end;



function CElement.GetProzrachnost: integer;
begin
  result:=prozrachnost;
end;

function CElement.GetproletSnaryada: boolean;
begin
  result:=proletSnaryada;
end;
function CElement.GetUnichtozhenie:  boolean;
begin
  result:=Unichtozhenie;
end;
function CElement.GetProezdTanka:    boolean;
begin
  result:=ProezdTanka;
end;



function CElement.GetRazmer: boolean;
begin
  result:=razmer;
end;

function CElement.GetSila: integer;
begin
  Result:=sila;
end;
function CElement.SetSila(newparam: integer): integer;
begin
  sila:=newparam;
end;



function CElement.GetVid: integer;
begin
  Result:=vid;
end;
function CElement.SetVid(newparam: integer): integer;
begin
  vid:=newparam;
end;

function CElement.SetActive(newparam: boolean): HRESULT;
begin
  active:=newparam;
end;

function CElement.SetTimetoactive(newparam: dword): HRESULT;
begin
  timetoactive:=newparam;
end;

function CElement.GetActive: boolean;
begin
  Result:=active;
end;

function CElement.GetTimetoActive: dword;
begin
  Result:=timetoactive;
end;



/////////////////////////////////////////////////////

function CEffect.show: hresult;
begin
  Animate(x,y,30);
  if kadri=NKadr-1 then destroy:=true;
end;

function CEffect.init(newx,newy: integer): hresult;
begin
  x:=newx;
  y:=newy;
  destroy:=false;
end;


//////////////////////////////////////////////////////////////
constructor Cbonus.Create(var Surf: COutSurface; newx,newy,vid: integer);
begin
   self.OutSurface:=Surf;
   id:=vid;
   case id of
    1:  begin
         xx:=0;
         yy:=0;
        end;
    2:  begin
         xx:=56;
         yy:=0;
        end;
    3:  begin
         xx:=112;
         yy:=0;
        end;
     4:  begin
         xx:=168;
         yy:=0;
        end;
     5:  begin
         xx:=224;
         yy:=0;
        end;
     6:  begin
         xx:=280;
         yy:=0;
        end;
     end;
   width:=56;
   height:=56;
   NKadr:=15;
   KadrI:=1;
   x:=newx;
   y:=newy;
end;


function CBonus.show: hresult;
begin
  Animate(x,y,50);
end;

function CreateEffect(x,y, vid: integer): hresult;
var i,j,zdvig: integer;
begin
  counteffect:=counteffect+1;
  i:=RandomRange(1,3);
  case vid of
    1: begin
          if i=1 then zdvig:=0 else zdvig:=112;
         masofEffect1[counteffect]:=CEffect.Create(OSEffect,zdvig,0,112,112,25);
         masofEffect1[counteffect].init(X,Y);
       end;
    2: begin
          if i=1 then zdvig:=224 else zdvig:=336;
         masofEffect1[counteffect]:=CEffect.Create(OSEffect,zdvig,0,112,112,20);
         masofEffect1[counteffect].init(X,Y);
       end;
    end;
end;

Initialization

end.
