UNIT FormMain;

{******************************************************************************}
{******************************************************************************}

{**} INTERFACE {***************************************************************}

{**} USES {********************************************************************}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, AppEvnts,StdCtrls, Buttons,
  ////
  DirectDraw,DirectInput,UdxInputManager,DirectDrawUsing,BaseSprite,
  IronKaput, FileCtrl, DirectSound, UdxSoundManager, CheckLst,
  SoundManagerIronKaput,drawtimeandnumb;

{**} TYPE {********************************************************************}
  TMainForm = class(TForm)
    applicationEventsMain: TApplicationEvents;
    TimerTotalTime: TTimer;
    TimerTimeBlock: TTimer;
    TimerPolePl1: TTimer;
    TimerPolePl2: TTimer;
    TimerDefendBaza: TTimer;
    FileListBox1: TFileListBox;
    TimerEndLevel: TTimer;
    TimerStartLevel: TTimer;
    TimerGameOver: TTimer;
    TimerPreGO: TTimer;
    TimerGOStat: TTimer;
    TimerPl1PreShow: TTimer;
    TimerPl2PreShow: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure applicationEventsMainIdle(Sender: TObject;
      var Done: Boolean);
    procedure applicationEventsMainMinimize(Sender: TObject);
    procedure applicationEventsMainRestore(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure QueryDevices;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerTotalTimeTimer(Sender: TObject);
    procedure TimerTimeBlockTimer(Sender: TObject);
    procedure TimerPolePl1Timer(Sender: TObject);
    procedure TimerPolePl2Timer(Sender: TObject);
    procedure TimerDefendBazaTimer(Sender: TObject);
    procedure TimerEndLevelTimer(Sender: TObject);
    procedure TimerStartLevelTimer(Sender: TObject);
    procedure TimerGameOverTimer(Sender: TObject);
    procedure TimerPreGOTimer(Sender: TObject);
    procedure TimerGOStatTimer(Sender: TObject);
    procedure TimerPl2PreShowTimer(Sender: TObject);
    procedure TimerPl1PreShowTimer(Sender: TObject);
    procedure SetVolume(volumeindex: integer);
  PRIVATE
     //пользовательские поверхности
    DDSTankPlayer:   IDirectDrawSurface7; // танки игроков
    DDSBlocks:  IDirectDrawSurface7; // блоки
    DDSEffect:  IDirectDrawSurface7;  // эффекты
    DDSGameFon: IDirectDrawSurface7; // игровое поле
    DDSFire:    IDirectDrawSurface7;  // патрон
    DDSBonus:   IDirectDrawSurface7;  // бонусы
    DDSIndicator:   IDirectDrawSurface7;  // индикаторы
    DDSTankVrag:  IDirectDrawSurface7;  // танки врага
    DDSPole:      IDirectDrawSurface7;  // защитное поле танка
    DDSBaza:      IDirectDrawSurface7;
    DDSDefendBaza: IDirectDrawSurface7;
    DDSMenu:      IDirectDrawSurface7;
    DDSButton:      IDirectDrawSurface7;
    DDSPl2Panel:      IDirectDrawSurface7;
    DDSStagePre:      IDirectDrawSurface7;
    DDSStageName:      IDirectDrawSurface7;
    DDSGameOver:      IDirectDrawSurface7;
    DDSGameOverIdent:      IDirectDrawSurface7;
    DDSPause:         IDirectDrawSurface7;
    DDSPauseBuffer:   IDirectDrawSurface7;
    DDSlevelend:   IDirectDrawSurface7;
    DDSGOstat:   IDirectDrawSurface7;
    DDSMusicOnOff: IDirectDrawSurface7;
    DDSABC: IDirectDrawSurface7;
    DDSRol: IDirectDrawSurface7;
    DDSScore:  IDirectDrawSurface7;

    IsActive: boolean;       /// состояние приложения
    function RenderScene: HResult;
    function CheckCooperativeLevel: HResult;
    function RestoreSurfaces: HResult;
    function LoadStage(newfile: string):hresult;/// загрузка уровня
  PUBLIC
  END;

{**}// CONST {*******************************************************************}
    const
      ty = 20;
      t1x = 20;
      t2x = 356;
      t3x = 692;
      time1x =822;
      time2x =832;
      time3x =842;
      time4x =852;
      time5x =862;
      timey = 382;
      levelsdir='levels\';
{**} VAR {*********************************************************************}
   MainForm: TMainForm;
   InputManager: TdxInputManager;
   DDMain: CDisplay; // главный интерфейс ДиректДро

   OSTankPlayer:   COutSurface;  // танки игроков
   OSGameFon: COutSurface; // игровое поле
   OSBonus:   COutSurface; // бонус
   OSIndicator: COutSurface; // индикатор
   OSTankVrag: COutSurface; // танки врага
   OSPole: COutSurface; // защитное поле
   OSBaza: COutSurface;
   OSDefendBaza: COutSurface;
   OSMenu: COutSurface;
   OSButton: COutSurface;
   OSPl2Panel: COutSurface;
   OSStagePre: COutSurface;
   OSStageName: COutSurface;
   OSGameOver: COutSurface;
   OSGameOverIdent: COutSurface;
   OSPause: COutSurface;
   OSPauseBuffer: COutSurface;
   OSlevelend: COutSurface;
   OSGOStat: COutSurface;
   OSMusicOnOff: COutSurface;
   OSABC: COutSurface;
   OSRol: COutSurface;
   OSScore: COutSurface;

   GameFon,SprMenu,SprButtonNoChek,SprPl2Panel,
   SPrStagePre,SprStageName,SPRGameOver,SPRGameOverIdent1,
   SPRGameOverIdent2, SPrPause, SPrPauseBuf,SPRLevelend,
   SPRGOStat: CSprite;
   SprNumb,SprBigNumb,SprStar,SprMinaInd, SprBron,SprPole, SPRDefendBaza,
   SprOpenBaza, SprButtonChek, SprMusic, SprABC,
   SprScore : CSprite;

   GameStart: boolean;
   StagePreStart: boolean;
   timeshowvrag: dword;
   tochkasvobodna: boolean;
   totaltime,timetonextlevel,timetostartlevel,
   timeshowGO,timePreGO,timeGOStat: integer;
   stagestart: boolean;
   buttonofchek: integer;
   timechekmenu: dword;
   countlevel: integer;
   thisLevel: integer;
   gamedirectory:  String;
   GOstat: boolean;
   pausestart, menustart ,     endlevel: boolean;
   Play: boolean;
   TimelastEscDown: dword;
   TotalTankDestroy: integer;
   music: boolean;
   StageName: string;
   masrole: array [0..4] of CSprite;
{**} IMPLEMENTATION

uses Start,Final, Math; {**********************************************************}

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
var i: integer;
begin
  GameStart:=false;
  stagestart:=false;
  StagePreStart:=false;
  buttonofchek:=1;
  gameover:=false;
  preGO:=false;
  GOstat:=false;
  menustart:=true;
  Screen.Cursor:=crnone;
  endlevel:=false;
  /// Инициализация DirectInput
  InputManager := TdxInputManager.Create(Handle);
  if FAILED(InputManager.Initialize) then
  begin
    FreeAndNil(InputManager);
    EXIT;
  end;
  InputManager.SetDeviceMask(idJoystick or idKeyboard or idJoystick1);
  ///
   SoundManager := TdxSoundManager.Create(handle);
  if FAILED(SoundManager.Initialize) then
  begin
    FreeAndNil(SoundManager);
  end;
  /// Инициализация главного объекта DirectDraw
  DDMain:=CDisplay.Create;
  if FAILED(DDMain.CreateFullScreen(handle,1024,768,32)) then
  begin
    ShowMessage('Error initializing DirectDraw...');
    Halt;
  end;
  /// Создание внеэкранных поверхностей
  OSTankPlayer:=COutSurface.Create(DDMain,DDSTankPlayer,896,672,true);
  OSTankVrag:=COutSurface.Create(DDMain,DDStankvrag,672,336,true);
  OSBloks:=COutSurface.Create(DDMain,DDSBlocks,1000,1000,true);

  OSGameFon:=COutSurface.Create(DDMain,DDSGameFon,1024,768,false);
  OSFire:=COutSurface.Create(DDMain,DDSFire,20,40,true);
  OSPole:=COutSurface.Create(DDMain,DDSPole,112,896,true);
  OSBaza:=COutSurface.Create(DDMain,DDSBaza,56,840,true);

  OSEffect:=COutSurface.Create(DDMain,DDSEffect,448,2800,true);
  OSBonus:=COutSurface.Create(DDMain,DDSBonus,336,840,true);
  OSDefendBaza:=COutSurface.Create(DDMain,DDSDefendBaza,336,1120,true);
  OSMenu:=COutSurface.Create(DDMain,DDSMenu,1024,768,false);
  OSButton:=COutSurface.Create(DDMain,DDSButton,780,400,false);
  OSGameOverIdent:=COutSurface.Create(DDMain,DDSGameOverIdent,
                                          214,226,false);
  OSPause:=COutSurface.Create(DDMain,DDSPause,527,202,false);
  OSPauseBuffer:=COutSurface.Create(DDMain,DDSPauseBuffer,1024,768,false);

  OSPl2Panel:=COutSurface.Create(DDMain,DDSPl2Panel,214,113,false);
  OSStagePre:=COutSurface.Create(DDMain,DDSStagePre,1024,768,false);
  OSStageName:=COutSurface.Create(DDMain,DDSStageName,517,364,false);
  OSGameOver:=COutSurface.Create(DDMain,DDSGameOver,1024,768,false);
  OSlevelend:=COutSurface.Create(DDMain,DDSlevelend,527,202,false);
  OSGOStat:=COutSurface.Create(DDMain,DDSGOStat,1024,768,false);
  OSIndicator:=COutSurface.Create(DDMain,DDSIndicator,200,300,true);
  OSMusicOnOff:=COutSurface.Create(DDMain,DDSMusicOnOff,160,160,false);
  OSABC:=COutSurface.Create(DDMain,DDSABC,30,1360,false);
  OSRol:= COutSurface.Create(DDMain,DDSrol,25,1320,false);
  OSScore:= COutSurface.Create(DDMain,DDSScore,25,484,false);
  //////
  RestoreSurfaces;  /// заполнение поверхностей
  //////
  ////// инициалтзация спрайтов
  SprMenu:=CSprite.Create(OSMenu,0,0,1024,768,1);
  SprButtonNoChek:=CSprite.Create(OSButton,390,0,390,400,1);
  SprPl2Panel:=CSprite.Create(OSPl2Panel,0,0,214,113,1);
  SprStagePre:=CSprite.Create(OSStagePre,0,0,1024,768,1);
  SprStageName:=CSprite.Create(OSStageName,0,0,517,364,1);
  SprGameOver:=CSprite.Create(OSGameOver,0,0,1024,768,1);
  SprGameOverIdent1:=CSprite.Create(OSGameOverIdent,0,0,214,113,1);
  SprGameOverIdent2:=CSprite.Create(OSGameOverident,0,113,214,113,1);
  SprPause:=CSprite.Create(OSPause,0,0,527,202,1);
  SPrPauseBuf:=CSprite.Create(OSPauseBuffer,0,0,1024,768,1);
  SPrlevelend:=CSprite.Create(OSlevelend,0,0,527,202,1);
  SPrGOStat:=CSprite.Create(OSGOStat,0,0,1024,768,1);

    SprPole:=CSprite.Create(OSPole,0,0,112,112,8);
  SprNumb:=CSprite.Create(OSIndicator,0,0,9,12,11);
  SprBigNumb:=CSprite.Create(OSIndicator,99,0,19,22,11);
  SprStar:=CSprite.Create(OSIndicator,9,0,90,30,3);
  SprBron:=CSprite.Create(OSIndicator,9,90,90,30,3);
  SprMinaInd:=CSprite.Create(OSIndicator,9,180,72,26,3);
  SprDefendBaza:=CSprite.Create(OSDefendBaza,0,0,168,112,10);
  SprOpenBaza:=CSprite.Create(OSDefendBaza,168,0,168,112,10);
  SprButtonChek:=CSprite.Create(OSButton,0,0,390,80,5);
  SprMusic:= CSprite.Create(OSMusicOnOff,0,0,160,80,2);
  SprABC:=  CSprite.Create(OSABC,0,0,30,40,34);
  for I := 0 to 4 do
    begin
      masrole[i]:= CSprite.Create(OSRol,0,0,25,44,30);
    end;
  SprScore:= CSprite.Create(OSScore,0,0,25,44,11);
  ////// Инициализация игровых объектов
  GameFon:=CSprite.Create(OSGameFon,0,0,1024,768,1);
  masofPlayerTank[1]:=CTank.Create(OSTankPlayer,0,0,56,56,6);
  masofPlayerTank[1].initid(1);    //  сделал по галимому
  masofPlayerTank[2]:=CTank.Create(OSTankPlayer,0,336,56,56,6);
  masofPlayerTank[2].initid(2);

  gamedirectory:=FileListBox1.Directory;
  FileListBox1.Directory := levelsdir;
  countlevel:=FileListBox1.Items.Count-2;
  FileListBox1.Directory:=gamedirectory;
  FileListBox1.Enabled:=false;
  ////////////////////////////////////////
  MMenu:=CSound.create('data\audio\music\menumusic.wav',0,true);
  MButton:=CSound.create('data\audio\effect\menu.WAV',1,false);
  MLevelStart:=CSound.create('data\audio\music\level.wav',2,false);
  MFirePl:=CSound.create('data\audio\effect\vistrel.wav',3,false);
  MFireVrag:=CSound.create('data\audio\effect\vistrel.wav',4,false);
  MDomBah:=CSound.create('data\audio\effect\dom.wav',5,false);
  MZaborBah:=CSound.create('data\audio\effect\zabor.wav',6,false);
  MBonus:=CSound.create('data\audio\effect\bonus.wav',7,false);
  MTankBah:=CSound.create('data\audio\effect\tankbah.wav',8,false);
  MPopadanie:=CSound.create('data\audio\effect\popal.wav',9,false);
  MDrdr:=CSound.create('data\audio\effect\drdr.wav',10,true);
  MGameOver:=CSound.create('data\audio\effect\gameover.wav',11,true);
  MBazaBah:=CSound.create('data\audio\effect\baza.wav',12,false);
  Mbazaclose:=CSound.create('data\audio\effect\bazaclose.wav',13,false);
  Mbaraban:=CSound.create('data\audio\effect\baraban.WAV',14,true);
  SetVolume(0);
  music:=true;
  masrole[1].StartTime:=GetTickCount;
end;

{******************************************************************************}
{** Освобождаем ресурсы при завершении работы программы                      **}
{******************************************************************************}
procedure TMainForm.FormDestroy(Sender: TObject);
begin
  DDMain.FreeDirectDraw;
  FreeAndNil(InputManager);
  //if SoundManager <> NIL then
  //   FreeAndNil(SoundManager);
end;

{******************************************************************************}
{** Проверка режима взаимодействия                                           **}
{******************************************************************************}
function TMainForm.CheckCooperativeLevel: HResult;
begin
  // Проверка текущего режима
  Result := DDMain.TestCl;

  // Если что-то не так, то ...
  while Result <> DD_OK do
  begin
    // Продолжаем обрабатывать сообщения
    Application.ProcessMessages;

    // И снова проверяем
    Result := DDMain.TestCL;
  end;
end;

{******************************************************************************}
{** Заполняем поверхности **}
{******************************************************************************}
function TMainForm.RestoreSurfaces: HResult;
begin
  // Восстанавливаем все поверхности
  Result := DDMain.RestoreAS;
  If Result <> DD_OK then Halt;
  OSTankPlayer.DrawBTM('data\sprite\tanks\tankplayer.bmp',$00ff0de1);
  OSTankVrag.DrawBTM('data\sprite\tanks\vrag.bmp',$00ff0de1);
  OSGameFon.DrawBTM('data\sprite\fon.bmp',0);
  OSFire.DrawBTM('data\sprite\fire.bmp',$00ff0de1);
  OSBloks.DrawBTM('data\sprite\bloks.bmp',$00ff0de1);
  OSEffect.DrawBTM('data\sprite\effects.bmp',$00ff0de1);
  OSBonus.DrawBTM('data\sprite\bonus.bmp',$00ff0de1);
  OSIndicator.DrawBTM('data\sprite\indicator.bmp',$00ff0de1);
  OSPole.DrawBTM('data\sprite\pole.bmp',$00ff0de1);
  OSBaza.DrawBTM('data\sprite\baza.bmp',$00ff0de1);
  OSDefendBaza.DrawBTM('data\sprite\closebaza.bmp',$00ff0de1);
  OSMenu.DrawBTM('data\sprite\menu.bmp',0);
  OSButton.DrawBTM('data\sprite\button.bmp',0);
  OSPl2Panel.DrawBTM('data\sprite\player2panel.bmp',0);
  OSStagePre.DrawBTM('data\sprite\StagePre.bmp',0);
  OSGameOver.DrawBTM('data\sprite\gameover.bmp',0);
  OSGameOverIdent.DrawBTM('data\sprite\GO12.bmp',0);
  OSPause.DrawBTM('data\sprite\pause.bmp',0);
  OSlevelend.DrawBTM('data\sprite\levelend.bmp',0);
  OSGOStat.DrawBTM('data\sprite\gostat.bmp',0);
  OSMusicOnOff.DrawBTM('data\sprite\musicONOFF.bmp',0);
  OSABC.DrawBTM('data\sprite\ABC.bmp',0);
  OSrol.DrawBTM('data\sprite\rol.bmp',0);
  OSScore.DrawBTM('data\sprite\scores.bmp',0);
end;

{******************************************************************************}
{** Прорисовка сцены                                                         **}
{******************************************************************************}
function TMainForm.RenderScene: HResult;
var j,i:integer;
  buf: CTank;
begin
  // результат по умолчанию
  Result := E_FAIL;
  // Очищаем вторичную поверхность
  DDMain.ClearSecondSurf(clBlack);

  if gamestart then
  BEGIN
  if StagePreStart=true then
  begin
      SPrStagePre.DrawKadr(0,0,1);
        //////////// Подготовка уровня////////
    if stageStart=false then
    begin
      //OSStageName.DrawBTM(levelsdir+inttostr(thisLevel)+'\levelname.bmp',0);
      SPRDefendBaza.SetKadrI(1);
      timetonextlevel:=0;
      timeshowGO:=0;
      timePreGO:=0;
      countfire:=0;
      countelem:=0;
      counteffect:=0;
      countoscolki:=0;
      countbonus:=0;
      vragintime:=0;
      ubito:=0;
      countToscolki:=0;
      vragovpokazano:=0;
      stoptime:=false;
      timeblock:=0;
      defendbaza:=false;
      DefendBazaTime:=0;
      timeGOStat:=0;
      bazadestroy:=false;
      Play:=false;
      countstena:=0;
      countmina:=0;
      countmost:=0;
      pausestart:=false;
      LoadStage(levelsdir+inttostr(thisLevel)+'\stage.txt');
      SprOpenBaza.SetKadrI(10);
      if masofPlayerTank[1].getnlife>0 then
      begin
        masofPlayerTank[1].restore(x1,y1,1);
        masofPlayerTank[1].SetMina(3);
        masofPlayerTank[1].setneujazvimost(true);
        polePl1:=10;
      end;


     if (countplayers>1) and (masofPlayerTank[2].getnlife>0)  then
      begin
        masofPlayerTank[2].SetMina(3);
        masofPlayerTank[2].restore(x2,y2,1);
        masofPlayerTank[2].setneujazvimost(true);
        polePl2:=10;
      end;
      stageStart:=true;
      MLevelStart.PlayAudio;
   end;
   //SprStageName.DrawKadr(285,230,1);
    drawABC(StageName,100,100, SprABC);
  end ELSE
  if gameover=true then
  begin
    play:=false;
    if GOstat=true then
    begin
        TimerGOStat.Enabled:=true;
        SPRGOStat.DrawKadr(0,0,1);
        drawnumbtime(0,start.GamePlayTime,742,430,SprBigNumb,2);
        drawnumb(TotalTankDestroy,742,376,SprBigNumb,2);
        drawnumb(totalScores,742,319,SprBigNumb,2);
    end else
      begin
        TimerGameOver.Enabled:=true;
        SPRGameOver.DrawKadr(0,0,1);
      end;
  end else
  BEGIN

  if PreGO then
  begin
      TimerPreGO.Enabled:=true;
  end;
  if pausestart=false then
  BEGIN
  play:=true;
  TimerTotalTime.Enabled:=true;

  GameFon.DrawKadr(0,0,1);
  if countplayers>1 then SprPl2Panel.DrawKadr(792,552,1);

//////////Упорядочивание воронок от танка///////////////////
  j:=countToscolki;
  if countToscolki>0 then
    while j>0 do begin
      if masofTOscolki[j].GetDestroy=true then
      begin
        masofTOscolki[j]:=nil;
        masofTOscolki[j]:=masofTOscolki[countToscolki];
        countToscolki:=countToscolki-1;
      end;
      j:=j-1;
    end;
/////////Прорисовка воронок от танков///////////////////////////////

  if countToscolki>0 then
  begin
     for j:=1 to countToscolki do
     begin
        masofTOscolki[j].SetVid(1);
        masofTOscolki[j].otobrazit;
     end;
  end;

  /////////////////////////////////////////////
  if countmost>0 then
  begin
     for j:=1 to countmost do
     begin
        masofmost[j].otobrazit;
     end;
  end;

  ////////////////Запуск таймера отстановки времени////////////////////////
  if stoptime then
  begin
      TimerTimeBlock.Enabled:=true
  end else TimerTimeBlock.Enabled:=false;
  ////////////////////////////////////////////

  /////////////////////Запуск таймера неуязвимости танка///////////////////
  if masofPlayerTank[1].getneujazvimost then TimerPolePl1.Enabled:=true
  else TimerPolePl1.Enabled:=false;
  if countplayers>1 then
  begin
    if masofPlayerTank[2].getneujazvimost then TimerPolePl2.Enabled:=true
    else TimerPolePl2.Enabled:=false;
  end;
  /////////////////////////////////////////////


  /////Упорядочивание массива врагов//////////////////
  for i:=ubito+1 to  vragovpokazano do
  begin
    if (masofVragTank[i].GetDestroy=true) then
    begin
      if masofVragTank[i].getstarlevel=1 then
           totalScores:=totalScores+50;
      if masofVragTank[i].getstarlevel=2 then
           totalScores:=totalScores+100;
      if masofVragTank[i].getstarlevel=3 then
           totalScores:=totalScores+150;
      ubitotobonus:=ubitotobonus+1;

        ///////// Расчет Вывода бонусов//////////////////////////

      if ubitotobonus>=4 then
       begin
          countbonus:=countbonus+1;
          masofBonus[countbonus]:=CBonus.Create(OSBonus,
          masofVragTank[i].GetX,masofVragTank[i].getY,RandomRange(1,7));
          ubitotobonus:=0;
        end;
      ///////////////////////////////////////////////////////////////
      if (i<>ubito+1) then
      begin
        buf:=masofVragTank[i];
        masofVragTank[i]:=masofVragTank[ubito+1];
        masofVragTank[ubito+1]:=buf;
      end;
      ubito:=ubito+1;
      vragintime:=vragintime-1;
      TotalTankDestroy:=TotalTankDestroy+1;
    end;
  end;
////////////////////////////////////////////////////////


  ////////Вывод осколков/////////////////////////////
  if countoscolki>0 then
  begin
     i:=1;
     for j:=1 to countoscolki do
     begin
        if masofOscolki[j].GetKolKadr>1 then
        begin
          masofOscolki[j].SetVid(i);
          masofOscolki[j].otobrazit;
          i:=i+1;
          if i>3 then i:=1;
        end else
        begin
          masofOscolki[j].SetVid(1);
          masofOscolki[j].otobrazit;
        end;
     end;
  end;
  /////////////////////////////////////////////////////////////

  /////////Упорядочивание массива мин//////////////////////
   j:=countmina;
  if countmina>0 then
    while j>0 do begin
      if masofmina[j].GetDestroy=true then
      begin
        masofmina[j]:=nil;
        masofmina[j]:=masofmina[countmina];
        countmina:=countmina-1;
      end;
      j:=j-1;
    end;
/////////////////////////////////////////////////////////

   //////////////Активация мин игроков//////////////////////
   if countmina>0 then
      for i:=1 to countmina do
      begin
          if masofmina[i].GetActive=false then
              if GetTickCount-masofmina[i].GetTimetoActive>1500 then
                  masofmina[i].SetActive(true);
      end;
  /////////////////Прорисовка мин///////////////////////
   if countmina>0 then
      for i:=1 to countmina do
        if masofmina[i].GetActive then
            masofmina[i].Animate(masofmina[i].GetX,
            masofmina[i].GetY,100) else
            masofmina[i].DrawKadr(masofmina[i].GetX,
            masofmina[i].GetY,2);
   ////////////////////////////////////////////////////////

  /////////Упорядочивание массива элементов карты/////////////////
  j:=countelem;
  if countelem>0 then
    while j>0 do begin
      if masofElem[j].GetDestroy=true then
      begin
        if masofElem[j].GetRazmer=true then
        begin
          countoscolki:=countoscolki+1;
          masofOscolki[countoscolki]:=CElement.Create(OSBloks,196,0,112,112,3);
          masofOscolki[countoscolki].createVoronka(masofElem[j].GetX-28,
          masofElem[j].GetY-28,1);
          MDomBah.PlayAudio;
        end else
        begin
          countoscolki:=countoscolki+1;
          masofOscolki[countoscolki]:=CElement.Create(OSBloks,308,0,28,28,1);
          masofOscolki[countoscolki].createVoronka(masofElem[j].GetX,
          masofElem[j].GetY,1);
          MZaborBah.PlayAudio;
        end;
        masofElem[j]:=nil;
        masofElem[j]:=masofElem[countelem];
        countelem:=countelem-1;
      end;
      j:=j-1;
    end;
  ////////


   /////Прорисовка всех элементов карты
  if countelem>0 then
  begin
      for j:=1 to countelem do
          masofElem[j].otobrazit;
  end;
  if (bazadestroy=false) then baza.Animate(baza.GetX,baza.GetY,30);
   /////////////////////////////////

    /////////////////////////////////
   /// прорисовка всех снарядов////
   if countfire>0 then begin
      for j:=1 to countfire do
          masoffire[j].polet;
   end;

  ////////////////////////////////////////////

  if defendbaza then
  begin
    TimerDefendBaza.Enabled:=true;
    if SPRDefendBaza.AnimateONE(300,636,100) then
    begin
        if countstena>0 then
        begin
          for j:=1 to countstena do
          begin
            countelem:=countelem+1;
            masofElem[countelem]:=masofstena[j];
            masofElem[countelem].SetDestroy(false);
          end;
          countstena:=0;
        end;
        SPRDefendBaza.DrawKadr(300,636,10);
    end;
  end else
        begin
          TimerDefendBaza.Enabled:=false;
          SprOpenBaza.AnimateONE(300,636,100);
        end;



   ///// Проверка снарядов на столкновение///////
   for i:=1 to countfire-1 do
      if ((masoffire[i].GetX>=masoffire[i+1].GetX-6) and
        (masoffire[i].GetX<=masoffire[i+1].GetX+12)) and
        ((masoffire[i].GetY>=masoffire[i+1].GetY-6)and
        (masoffire[i].GetY<=masoffire[i+1].GetY+12)) then
         begin
        createeffect(masoffire[i].GetX-51,masoffire[i].GetY-51,2);
            masoffire[i].setdestroy(true);
            masoffire[i+1].setdestroy(true);
         end;


   //// Упорядочивание массива снарядов//////////////////////////////////
   j:=countfire;
  if countfire>0 then
    while j>0 do begin
      if masoffire[j].GetDestroy=true then
      begin
        masoffire[j]:=nil;
        masoffire[j]:=masoffire[countfire];
        countfire:=countfire-1;
      end;
      j:=j-1;
    end;
   /////////////////////////////////////
   j:=countbonus;
  if countbonus>0 then
    while j>0 do begin
      if masofBonus[j].GetDestroy=true then
      begin
        masofBonus[j]:=nil;
        masofBonus[j]:=masofBonus[countbonus];
        countbonus:=countbonus-1;
      end;
      j:=j-1;
    end;
   ///////////////////////////////////////
  //// Движение танков игроков или стоп на месте//////////////////////
   for i:=1 to countplayers do
   begin
      if masofPlayerTank[i].GetMoveFlag then
      begin
        if  masofPlayerTank[i].Move(masofPlayerTank[i].GetOrientation)=
        false then
              masofPlayerTank[i].Probuksovka;
      end else
      masofPlayerTank[i].NotMove;
      masofPlayerTank[i].SetOrientation(masofPlayerTank[i].GetOrientation);
  end;
   //////////////////////////////////////////////////////////
  /// Появление танков врага на поле///////////////////
    tochkasvobodna:=true;
   if vragovpokazano<countvrag then
   begin /// враг
      if vragintime<6 then
      begin
        if GetTickCount-timeshowvrag>3000 then
        begin
          case RandomRange(1,4) of
          1: begin
                for i:=ubito+1 to vragovpokazano do
                  if (masofVragTank[i].GetX>=20) and
                   (masofVragTank[i].GetX<=76) and
                   (masofVragTank[i].GetY>=20) and
                   (masofVragTank[i].GetY<=76) then
                   tochkasvobodna:=false;
                for i:=1 to countplayers do
                    if (masofPlayerTank[i].GetX>=20) and
                   (masofPlayerTank[i].GetX<=76) and
                   (masofPlayerTank[i].GetY>=20) and
                   (masofPlayerTank[i].GetY<=76) then
                   tochkasvobodna:=false;


                if tochkasvobodna then
                  begin
                   vragovpokazano:=vragovpokazano+1;
                   masofVragTank[vragovpokazano].restore(t1x,ty,2);
                   vragintime:=vragintime+1;
                    timeshowvrag:=GetTickCount;
                  end;
             end;
          2: begin
                for i:=ubito+1 to vragovpokazano do
                  if (masofVragTank[i].GetX>=t2x) and
                   (masofVragTank[i].GetX<=(t2x+56)) and
                   (masofVragTank[i].GetY>=20) and
                   (masofVragTank[i].GetY<=76) then
                   tochkasvobodna:=false;

                for i:=1 to countplayers do
                    if (masofPlayerTank[i].GetX>=t2x) and
                   (masofPlayerTank[i].GetX<=(t2x+56)) and
                   (masofPlayerTank[i].GetY>=20) and
                   (masofPlayerTank[i].GetY<=76) then
                   tochkasvobodna:=false;

                if tochkasvobodna then
                begin
                  vragovpokazano:=vragovpokazano+1;
                  masofVragTank[vragovpokazano].restore(t2x,ty,2);
                  vragintime:=vragintime+1;
                  timeshowvrag:=GetTickCount;
                end;
              end;
          3: begin
              for i:=ubito+1 to vragovpokazano do
                if (masofVragTank[i].GetX>=t3x) and
                   (masofVragTank[i].GetX<=(t3x+56)) and
                   (masofVragTank[i].GetY>=20) and
                   (masofVragTank[i].GetY<=76) then
                   tochkasvobodna:=false;

                for i:=1 to countplayers do
                    if (masofPlayerTank[i].GetX>=t3x) and
                   (masofPlayerTank[i].GetX<=(t3x+56)) and
                   (masofPlayerTank[i].GetY>=20) and
                   (masofPlayerTank[i].GetY<=76) then
                   tochkasvobodna:=false;


                if tochkasvobodna then
                begin
                  vragovpokazano:=vragovpokazano+1;
                  masofVragTank[vragovpokazano].restore(t3x,ty,2);
                  vragintime:=vragintime+1;
                  timeshowvrag:=GetTickCount;
                end;
             end;
          end;
        end;
      end;
   end;
   if ubito<countvrag then
   begin
    for i:=ubito+1 to vragovpokazano do
      begin
        if stoptime=false then
        begin
          if masofVragTank[i].GetY>=691 then
          begin
            if masofVragTank[i].GetX<358 then
                masofVragTank[i].SetOrientation(4)
              else masofVragTank[i].SetOrientation(3);
          end;
          masofVragTank[i].VragMove;
          masofVragTank[i].VragFire;
        end
        else masofVragTank[i].notmove;
      end;
   end;

/////////////////////////////////////////////////////////////////////

  /////Прорисовка Леса (плохая реализация!!!!!)
  if countelem>0 then
  begin
      for j:=1 to countelem do
          if masofElem[j].GetProzrachnost=1 then
                masofElem[j].otobrazit;
  end;
  /////////////////////////////////

  //// Прорисовка всех эффектов
  if counteffect>0 then
    for  j:=1 to counteffect do
      masofEffect1[j].show;

  ///// Упорядочивание массива эффектов ???
  j:=counteffect;
  if counteffect>0 then
    while j>0 do begin
      if masofEffect1[j].GetDestroy=true then
      begin
        masofEffect1[j]:=nil;
        masofEffect1[j]:=masofEffect1[counteffect];
        counteffect:=counteffect-1;
      end;
      j:=j-1;
    end;
  if countbonus>0 then
    for i:=1 to countbonus do
      masofbonus[i].show;
  ////////////////////////////////////////////////////
  if Pl1Preshow then
        TimerPl1PreShow.Enabled:=true;
  if Pl2Preshow then
        TimerPl2PreShow.Enabled:=true;


  ////////////////////////////////////////////
   /////////////////////////////
  {  drawnumb(masofPlayerTank[1].GetGlobalZdvigX ,965,340,SprNumb,1);
    drawnumb(masofPlayerTank[2].GetGlobalZdvigX,965,320,SprNumb,1);
    drawnumb(masofPlayerTank[1].GetGlobalZdvigY ,990,340,SprNumb,1);
    drawnumb(masofPlayerTank[2].GetGlobalZdvigY,990,320,SprNumb,1);
   }

   drawnumb(totalScores,965,382,SprNumb,1);
   if (countplayers>1) and (masofPlayerTank[2].getnlife>=1)
   and (prego=false)   then
   begin
      drawnumb(masofPlayerTank[2].getnlife,846,630,SprNumb,1);
      //////////////////////////////////////
      if masofPlayerTank[2].getneujazvimost then
      SprPole.Animate(masofPlayerTank[2].GetX-28,
      masofPlayerTank[2].GetY-28,40);
      ////////////////////////////////////
      if masofPlayerTank[2].getstarlevel=1 then
        SprStar.DrawKadr(891,574,1);
      if masofPlayerTank[2].getstarlevel=2 then
        SprStar.DrawKadr(891,574,2);
      if masofPlayerTank[2].getstarlevel=3 then
        SprStar.DrawKadr(891,574,3);
      if masofPlayerTank[2].getdefendintime=1 then
        SprBron.DrawKadr(891,604,1);
      if masofPlayerTank[2].getdefendintime=2 then
        SprBron.DrawKadr(891,604,2);
      if masofPlayerTank[2].getdefendintime=3 then
        SprBron.DrawKadr(891,604,3);
      if masofPlayerTank[2].getmina=1 then
        SprMinaInd.DrawKadr(909,634,1);
      if masofPlayerTank[2].getmina=2 then
        SprMinaInd.DrawKadr(909,634,2);
      if masofPlayerTank[2].getmina=3 then
        SprMinaInd.DrawKadr(909,634,3);
   end else
       if (countplayers>1) then SPRGameOverIdent2.DrawKadr(792,552,1);

  if (masofPlayerTank[1].getnlife>=1) and (prego=false) then
  BEGIN
  //////////////////////////////////////////
  if masofPlayerTank[1].getneujazvimost then
      SprPole.Animate(masofPlayerTank[1].GetX-28,
      masofPlayerTank[1].GetY-28,40);
    ////////////////////////////////////////////////////////////////
      drawnumb(masofPlayerTank[1].getnlife,846,502,SprNumb,1);
  ///////////////////////////////////////////////////////////////
  if masofPlayerTank[1].getstarlevel=1 then
        SprStar.DrawKadr(891,446,1);

  if masofPlayerTank[1].getstarlevel=2 then
        SprStar.DrawKadr(891,446,2);

  if masofPlayerTank[1].getstarlevel=3 then
        SprStar.DrawKadr(891,446,3);

        /////////
  if masofPlayerTank[1].getdefendintime=1 then
        SprBron.DrawKadr(891,476,1);

  if masofPlayerTank[1].getdefendintime=2 then
        SprBron.DrawKadr(891,476,2);

  if masofPlayerTank[1].getdefendintime=3 then
        SprBron.DrawKadr(891,476,3);

  //////////////////////
  if masofPlayerTank[1].getmina=1 then
        SprMinaInd.DrawKadr(909,506,1);

  if masofPlayerTank[1].getmina=2 then
        SprMinaInd.DrawKadr(909,506,2);
  if masofPlayerTank[1].getmina=3 then
        SprMinaInd.DrawKadr(909,506,3);
  END else SPRGameOverIdent1.DrawKadr(792,424,1);

    drawnumb(thisLevel,908,107,SprNumb,1);
    drawnumbTime(1,totaltime,862,382,SprNumb,1);
       drawnumb(countvrag-vragovpokazano,908,192,SprNumb,1);
   if (ubito>=countvrag) and (bazadestroy=false) then
    begin
      if endlevel=false then
      begin
          for I := 0 to 4 do
          begin
            masrole[i].StartTime:=GetTickCount;
            masrole[i].SetKadrI(random(30));
          end;
          MBaraban.PlayAudio;
          MDrdr.StopAudio;
      end;
      TimerEndLevel.Enabled:=true;
      //if endlevel=false then totalScores:=totalScores+totaltime*10;
      endlevel:=true;
      TimerTotalTime.Enabled:=false;
      SPRLevelend.DrawKadr(249,283,1);
      //drawnumb(totalScores,627,398,SprNumb,1);
      drawnumbrol(totalScores,615,388,5,SprScore,masrole);
    end;
   END;

   END;
  END;

  if pausestart then
  begin
        SPrPauseBuf.DrawKadr(0,0,1);
        SPrPause.DrawKadr(249,283,1);
        TimerTotalTime.Enabled:=false;
        TimerTimeBlock.Enabled:=false;
        TimerPolePl1.Enabled:=false;
        TimerPolePl2.Enabled:=false;
        TimerDefendBaza.Enabled:=false;
        TimerEndLevel.Enabled:=false;
        TimerStartLevel.Enabled:=false;
        TimerGameOver.Enabled:=false;
        TimerPreGO.Enabled:=false;
  end;



{*****************************************************************}
 If gamestart=false then
 begin
   SprMenu.DrawKadr(0,0,1);
   SprButtonNoChek.DrawKadr(128,218,1);
   if buttonofchek=1 then SprButtonChek.DrawKadr(128,218,1);
   if buttonofchek=2 then SprButtonChek.DrawKadr(128,298,2);
   if buttonofchek=3 then SprButtonChek.DrawKadr(128,378,3);
   if buttonofchek=4 then SprButtonChek.DrawKadr(128,458,4);
   if buttonofchek=5 then SprButtonChek.DrawKadr(128,538,5);
   if music then SprMusic.DrawKadr(450,538,1) else
         SprMusic.DrawKadr(450,538,2);
   gamestart:=false;
 end;
{*****************************************************************}

  // Проверяем режим работы
  CheckCooperativeLevel;
    // Переключаем поверхности

  Result := DDMain.DDSFlip;

  // Если есть потерянные поверхности, то ...
  if Result = DDERR_SURFACELOST then
  begin
    // ... восстанавливаем их
    Result := RestoreSurfaces;
  end;
end;

{******************************************************************************}
{** Различные действия                                                       **}
{******************************************************************************}
procedure TMainForm.applicationEventsMainIdle(Sender: TObject;
  var Done: Boolean);
begin
  if IsActive then
  begin
      RenderScene;
      QueryDevices;
      if (menustart) then mMenu.PlayAudio else MMenu.StopAudio;
      if (play) and (pausestart=false) and (stagestart)
      and (gameover=false) and (endlevel=false) then
           MDrdr.PlayAudio  else MDrdr.StopAudio;
      if gameover then MGameOver.PlayAudio else MGameOver.StopAudio;
  end;
  Done := FALSE;
end;

{******************************************************************************}
{** Сворачиваем приложение                                                   **}
{******************************************************************************}
procedure TMainForm.applicationEventsMainMinimize(Sender: TObject);
begin
  IsActive := FALSE;
end;

{******************************************************************************}
{** Восстанавливаем приложение                                               **}
{******************************************************************************}
procedure TMainForm.applicationEventsMainRestore(Sender: TObject);
begin
  IsActive := TRUE;
end;

{******************************************************************************}
{** Приложение активно                                                       **}
{******************************************************************************}
procedure TMainForm.FormActivate(Sender: TObject);
begin
  IsActive := TRUE;
end;

/////////////////////////////////////////////////////////
//// Инициализация уровня////////
/////////////////////////////////////////////////////////
function TMainForm.LoadStage(newfile: string):hresult;
var
  Slist: TStringList;
   switch: integer;
   x1,y1: integer;
   i,j: integer;
   vid: integer;
begin
    Slist:=TStringList.Create;
    slist.LoadFromFile(newfile);

     y1:=20;
  i:=100;
  while i<=2600 do
  begin
    x1:=20;
    for j:=1 to 26 do begin
      switch:=(StrToInt(Slist.Values[inttoStr(i+j)])) div 10;
      vid:= (StrToInt(Slist.Values[inttoStr(i+j)])) mod 10;
      if vid=0 then vid:=10;
      case switch  of
      6:  begin
              countmost:=countmost+1;
              masofmost[countmost]:=CElement.Create(OSBloks,84,560,56,56,2);
              masofmost[countmost].createmost(x1,y1,vid);
            end;
      5:  begin
              countelem:=countelem+1;
              masofElem[countelem]:=CElement.Create(OSBloks,392,0,56,56,1);
              masofElem[countelem].createGora(x1,y1,vid);
            end;
      4:  begin
              countelem:=countelem+1;
              masofElem[countelem]:=CElement.Create(OSBloks,84,0,56,56,10);
              masofElem[countelem].createWater(x1,y1,vid);
            end;
      2:  begin
              countelem:=countelem+1;
              masofElem[countelem]:=CElement.Create(OSBloks,28,0,56,56,10);
              masofElem[countelem].createDom(x1,y1,vid);
            end;
      3:  begin
              countelem:=countelem+1;
              masofElem[countelem]:=CElement.Create(OSBloks,140,0,56,56,1);
              masofElem[countelem].createLes(x1,y1,vid);
            end;
      1:  begin
              countelem:=countelem+1;
              masofElem[countelem]:=CElement.Create(OSBloks,0,0,28,28,10);
              masofElem[countelem].createZabor(x1,y1,vid);
            end;
      7:  begin
              Baza:=CElement.Create(OSBaza,0,0,56,56,15);
              Baza.createBASA(356,692,1);
            end;
      8:  begin
              countmina:=countmina+1;
              masofmina[countmina]:=CElement.Create(OSBloks,0,280,28,28,2);
              masofmina[countmina].createVoronka(x1,y1,1);
              masofmina[countmina].SetActive(true);
          end;
      end;
      x1:=x1+28;
    end;
     i:=i+100;
     y1:=y1+28;
  end;
  totaltime:=StrToInt(Slist.ValueFromIndex[676]);
  j:=0;
  countvrag:=StrToInt(Slist.ValueFromIndex[678]);
  for i:=679 to 678+countvrag do
  begin
     vid:=StrToInt(Slist.ValueFromIndex[i]);
     j:=j+1;
     case vid of
        1: begin
              masofVragTank[j]:=CTank.Create(OSTankVrag,0,0,56,56,6);
              masofVragTank[j].initvrag(1);
           end;
        2: begin
              masofVragTank[j]:=CTank.Create(OSTankVrag,224,0,56,56,6);
              masofVragTank[j].initvrag(2);
           end;
        3: begin
              masofVragTank[j]:=CTank.Create(OSTankVrag,448,0,56,56,6);
              masofVragTank[j].initvrag(3);
           END;
     end;
  end;
  StageName:=Slist.ValueFromIndex[677];
     /////////////
  result:=MB_OK;
end;


procedure TMainForm.QueryDevices;
var
  KeyBuffer:   TdxKeyboardState;
  JoyBuffer:   TdxJoyState;
  JoyBuffer1:   TdxJoyState;
begin
  if SUCCEEDED(InputManager.GetKeyboardState(@KeyBuffer)) then
  begin


  if pausestart=false then
  begin


    if KeyBuffer[DIK_Up] = $080 then
      if KeyBuffer[DIK_Left] <> $080 then
          if KeyBuffer[DIK_Right] <> $080 then
                                    begin
                                      if play then
                                      begin
                                       masofPlayerTank[1].SetOrientation(1);
                                       masofPlayerTank[1].SetMoveGlag(true);
                                      end;
                                    end;
    if KeyBuffer[DIK_Down] = $080 then
      if KeyBuffer[DIK_Up] <> $080 then
        if KeyBuffer[DIK_Left] <> $080 then
          if KeyBuffer[DIK_Right] <> $080 then
                                            begin
                                        if play then
                                    begin
                                      masofPlayerTank[1].SetOrientation(2);
                                      masofPlayerTank[1].SetMoveGlag(true);
                                     end;
                                    end;


    if KeyBuffer[DIK_Left] = $080 then
      if KeyBuffer[DIK_Right] <> $080 then
                                 begin
                                      masofPlayerTank[1].SetOrientation(3);
                                      masofPlayerTank[1].SetMoveGlag(true);
                                     end;

    if KeyBuffer[DIK_Right] = $080 then
                                   begin
                                      masofPlayerTank[1].SetOrientation(4);
                                      masofPlayerTank[1].SetMoveGlag(true);
                                     end;

   {  if SUCCEEDED(InputManager.GetJoystickState(@JoyBuffer,1)) then
     begin
        if JoyBuffer.ly<32511 then   //vniz
      begin
         masofPlayerTank[1].SetOrientation(1);
         masofPlayerTank[1].SetMoveGlag(true);
      end;
      if JoyBuffer.ly>32511 then    //vverh
      begin
        masofPlayerTank[1].SetOrientation(2);
        masofPlayerTank[1].SetMoveGlag(true);
      end;
      if JoyBuffer.lx>32511 then   //vpravo
      begin
        masofPlayerTank[1].SetOrientation(4);
        masofPlayerTank[1].SetMoveGlag(true);
      end;
      if JoyBuffer.lx<32511 then    //vlevo
      begin
        masofPlayerTank[1].SetOrientation(3);
        masofPlayerTank[1].SetMoveGlag(true);
      end;
    end;
      if stagestart and(StagePreStart=false) then
      begin
        if JoyBuffer.rgbButtons[1] > 0 then //2
        begin
          masofPlayerTank[1].createmina;
        end;

        if JoyBuffer.rgbButtons[0] > 0 then   //1
        begin
           masofPlayerTank[1].Fire;
        end;
      end;                                      }







    // ПРОВЕРКА СОБЫТИЙ ОТ Второго ИГРОКА!!!
if countplayers>1 then
BEGIN
    //// события на движение//////////////////////////

    if KeyBuffer[DIK_W] = $080 then
      if KeyBuffer[DIK_A] <> $080 then
          if KeyBuffer[DIK_D] <> $080 then
                                    if play then
                                    begin
                                      masofPlayerTank[2].SetOrientation(1);
                                      masofPlayerTank[2].SetMoveGlag(true);
                                     end;
    if KeyBuffer[DIK_S] = $080 then
      if KeyBuffer[DIK_W] <> $080 then
        if KeyBuffer[DIK_A] <> $080 then
          if KeyBuffer[DIK_D] <> $080 then
                                      if play then
                                    begin
                                      masofPlayerTank[2].SetOrientation(2);
                                      masofPlayerTank[2].SetMoveGlag(true);
                                     end;


    if KeyBuffer[DIK_A] = $080 then
      if KeyBuffer[DIK_D] <> $080 then
                                 begin
                                      masofPlayerTank[2].SetOrientation(3);
                                      masofPlayerTank[2].SetMoveGlag(true);
                                     end;

    if KeyBuffer[DIK_D] = $080 then
                                   begin
                                      masofPlayerTank[2].SetOrientation(4);
                                      masofPlayerTank[2].SetMoveGlag(true);
                                     end;

   if stagestart and(StagePreStart=false) then
   if KeyBuffer[DIK_Space] = $080 then  masofPlayerTank[2].Fire;
     if KeyBuffer[DIK_C] = $080 then
  begin
      masofPlayerTank[2].createmina;
  end;

 {    // Опрос джойстика
  if SUCCEEDED(InputManager.GetJoystickState(@JoyBuffer1,2)) then
  begin
    //// события на движение//////////////////////////
    if masofPlayerTank[2].GetZdvig=0 then
    begin
      if JoyBuffer1.ly<32511 then   //vniz
      begin
         masofPlayerTank[2].SetOrientation(1);
         masofPlayerTank[2].SetMoveGlag(true);
      end;
      if JoyBuffer1.ly>32511 then    //vverh
      begin
        masofPlayerTank[2].SetOrientation(2);
        masofPlayerTank[2].SetMoveGlag(true);
      end;
      if JoyBuffer1.lx>32511 then   //vpravo
      begin
        masofPlayerTank[2].SetOrientation(4);
        masofPlayerTank[2].SetMoveGlag(true);
      end;
      if JoyBuffer1.lx<32511 then    //vlevo
      begin
        masofPlayerTank[2].SetOrientation(3);
        masofPlayerTank[2].SetMoveGlag(true);
      end;
    end;
      if stagestart and(StagePreStart=false) then
      begin
        if JoyBuffer1.rgbButtons[1] > 0 then //2
        begin
          masofPlayerTank[2].createmina;
        end;

        if JoyBuffer1.rgbButtons[0] > 0 then   //1
        begin
           masofPlayerTank[2].Fire;
        end;
      end;
    end;                                          }



END;

////////////////////////////////////////////////////////////
  ////Выстрел первого танка/////
  if stagestart and (StagePreStart=false) then
      if KeyBuffer[DIK_RCONTROL] = $080 then
      begin
        masofPlayerTank[1].Fire;
      end;

  if KeyBuffer[DIK_RSHIFT] = $080 then
  begin
      masofPlayerTank[1].createmina;
  end;

  if KeyBuffer[DIK_RETurn] = $080 then
  begin
    if gamestart=false then
    BEGIN
      if buttonofchek=1 then
      begin
        gamestart:=true;
        stagestart:=false;
        TimerStartLevel.Enabled:=true;
        StagePreStart:=true;
        countplayers:=1;
        masofPlayerTank[1].setnlife(3);
        totalScores:=0;
        thisLevel:=1;
        Start.GamePlayTime:=0;
        TotalTankDestroy:=0;
        menustart:=false;
              masofPlayerTank[1].setstarlevel(0);
    end;
    if buttonofchek=2 then
    begin
        gamestart:=true;
        stagestart:=false;
        TimerStartLevel.Enabled:=true;
        StagePreStart:=true;
        countplayers:=2;
        masofPlayerTank[1].setnlife(3);
        masofPlayerTank[2].setnlife(3);
        masofPlayerTank[1].setstarlevel(0);
        masofPlayerTank[2].setstarlevel(0);
        totalScores:=0;
        thisLevel:=1;
        Start.GamePlayTime:=0;
        TotalTankDestroy:=0;
        menustart:=false;
    end;
    if buttonofchek=4 then
    begin
      menustart:=false;
      close;
      start.FormStart.Close;
    end;
    if buttonofchek=3 then
    begin
      menustart:=false;
      Application.CreateForm(TFormFinal, FormFinal);
      FormFinal.Show;
      close;
    end;
    MButton.PlayAudio;
  end;
  END;

 END;  ///Pause

 if (PreGO=false) and (endlevel=false) then
 BEGIN
  if KeyBuffer[DIK_ESCAPE] = $080 then
  begin
    if GetTickCount-TimelastEscDown>300 then
    begin
     if pausestart then
     begin
        pausestart:=false;
     end else
     if play then
     begin
        pausestart:=true;
        OSPauseBuffer.CopySurf(DDMain,0,0,1024-1,768-1);
     end;
     TimelastEscDown:=GetTickCount;
    end;
  end;
 END;  //ESC

   if play=true then
   begin
      if KeyBuffer[DIK_RETurn] = $080 then
      begin
          if countplayers>1 then
          begin
            if ((masofPlayerTank[2].getnlife<=0) and
              (masofPlayerTank[1].getnlife>=2)) then
              begin
                masofPlayerTank[1].setnlife(masofPlayerTank[1].getnlife-1);
                masofPlayerTank[2].setnlife(1);
                masofPlayerTank[2].restore(x2,y2,1);
                masofPlayerTank[2].setneujazvimost(true);
                polePl2:=10;
              end else
               if((masofPlayerTank[2].getnlife>=2) and
              (masofPlayerTank[1].getnlife<=0)) then
              begin
                masofPlayerTank[2].setnlife(masofPlayerTank[2].getnlife-1);
                masofPlayerTank[1].setnlife(1);
                masofPlayerTank[1].restore(x1,y1,1);
                masofPlayerTank[1].setneujazvimost(true);
                polePl1:=10;
              end

          end;
      end;
   end;


 if KeyBuffer[DIK_Down] = $080 then
 begin
   if gamestart=false then
   begin
   if GetTickCount-timechekmenu>250 then
    begin
      buttonofchek:=buttonofchek+1;
      if buttonofchek>5 then buttonofchek:=1;
      timechekmenu:=GetTickCount;
      MButton.PlayAudio;
    end;
   end;
 end;

 if KeyBuffer[DIK_Up] = $080 then
 begin
  if gamestart=false then
  begin
    if GetTickCount-timechekmenu>250 then
    begin
      buttonofchek:=buttonofchek-1;
      if buttonofchek<1 then buttonofchek:=5;
      timechekmenu:=GetTickCount;
      MButton.PlayAudio;
    end;
  end;
 end;

 if KeyBuffer[DIK_Left] = $080 then
  if buttonofchek=5  then
   if gamestart=false then
     if GetTickCount-timechekmenu>250 then
     begin
        music:=true;
        SetVolume(0);
        timechekmenu:=GetTickCount;
     end;

 if KeyBuffer[DIK_Right] = $080 then
  if buttonofchek=5  then
   if gamestart=false then
    if GetTickCount-timechekmenu>250 then
    begin
      music:=false;
      SetVolume(-7000);
      timechekmenu:=GetTickCount;
    end;



  if KeyBuffer[DIK_Q] = $080 then
  begin
    if pausestart then
     begin
        stagestart:=false;
        GameStart:=false;
        pausestart:=false;
        menustart:=true;
        Play:=false;
     end;
  end;
  if KeyBuffer[DIK_M] = $080 then
    if GetTickCount-timechekmenu>250 then
    begin
      if pausestart then
      begin
       if music then
       begin
          SetVolume(-7000);
          music:=false;
        end else
        begin
          SetVolume(0);
          music:=true;
        end;
      end;
      timechekmenu:=GetTickCount;
    end;

 end;




end;


procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MMenu.StopAudio;
  //////////////////////
  OSTankPlayer.Destroy;
  OSBloks.Destroy;
  OSEffect.Destroy;
  OSGameFon.Destroy;
  OSFire.Destroy;
  OSIndicator.Destroy;
  OSTankVrag.Destroy;
  OSBonus.Destroy;
  OSPole.Destroy;
  OSBaza.Destroy;
  OSDefendBaza.Destroy;
  OSMenu.Destroy;
  OSButton.Destroy;
  OSPl2Panel.Destroy;
   OSStagePre.Destroy;
   OSStageName.Destroy;
   OSGameOver.Destroy;
   OSGameOverIdent.Destroy;
   OSPause.Destroy;
   OSPauseBuffer.Destroy;
   OSlevelend.Destroy;
   OSGOStat.Destroy;
   OSMusicOnOff.Destroy;
   OSABC.Destroy;
   OSRol.Destroy;
   OSScore.Destroy;
    action:=cafree;
end;

procedure TMainForm.TimerTotalTimeTimer(Sender: TObject);
begin
  if stoptime=false then totaltime:=totaltime-1;
  if totaltime<0 then
  begin
    TimerTotalTime.Enabled:=false;
    totaltime:=0;
  end;
end;


procedure TMainForm.TimerTimeBlockTimer(Sender: TObject);
begin
    timeblock:=timeblock+1;
    if timeblock>=10 then
    begin
      stoptime:=false;
      timeblock:=0;
    end;
end;

procedure TMainForm.TimerPolePl1Timer(Sender: TObject);
begin
    polePl1:=polePl1+1;
    if polePl1>=15 then
    begin
      masofPlayerTank[1].setneujazvimost(false);
      polePl1:=0;
    end;
end;

procedure TMainForm.TimerPolePl2Timer(Sender: TObject);
begin
    polePl2:=polePl2+1;
    if polePl2>=15 then
    begin
      masofPlayerTank[2].setneujazvimost(false);
      polePl2:=0;
    end;
end;

procedure TMainForm.TimerDefendBazaTimer(Sender: TObject);
var i,j: integer;
begin
    DefendBazaTime:=DefendBazaTime+1;
    if DefendBazaTime>=15 then
    begin
      SPRDefendBaza.SetKadrI(1);
      defendbaza:=false;
      SprOpenBaza.SetKadrI(1);
      DefendBazaTime:=0;
      TimerDefendBaza.Enabled:=false;
      if play then Mbazaclose.PlayAudio;
    end;
end;

procedure TMainForm.TimerEndLevelTimer(Sender: TObject);
begin
  timetonextlevel:=timetonextlevel+1;
  play:=false;
  MDrdr.StopAudio;
  if timetonextlevel>=5 then
  begin
    if (thisLevel>=countlevel) then
    begin
        //endlevel:=false;
        Application.CreateForm(TFormFinal, FormFinal);
        FormFinal.Show;
        close;
    end else
    begin
      thisLevel:=thisLevel+1;
      if thisLevel>countlevel then
      begin
        thisLevel:=1;
      end;
      polePl1:=0;
      polePl2:=0;
      TimerPolePl1.Enabled:=false;
      TimerPolePl2.Enabled:=false;
      TimerTotalTime.Enabled:=false;
      stagestart:=false;
      StagePreStart:=true;
      endlevel:=false;
      TimerStartLevel.Enabled:=true;
      TimerEndLevel.Enabled:=false;
      timetonextlevel:=0;
    end;
  end;
end;

procedure TMainForm.TimerStartLevelTimer(Sender: TObject);
begin
  timetostartlevel:=timetostartlevel+1;
  if timetostartlevel>=4 then
  begin
    StagePreStart:=false;
    TimerStartLevel.Enabled:=false;
    timetostartlevel:=0;
  end;
end;

procedure TMainForm.TimerGameOverTimer(Sender: TObject);
begin
   timeshowGO:=timeshowGO+1;
  if timeshowGO>=4 then
  begin
    TimerGameOver.Enabled:=false;
     timeshowGO:=0;
     GOstat:=true;
  end;
end;

procedure TMainForm.TimerPreGOTimer(Sender: TObject);
begin
  timePreGO:=timePreGO+1;
  if timePreGO>=4 then
  begin
    PreGO:=false;
    TimerPreGO.Enabled:=false;
     timePreGO:=0;
    gameover:=true;
    stagestart:=  false;
  end;
end;

procedure TMainForm.TimerGOStatTimer(Sender: TObject);
begin
    timeGOStat:=timeGOStat+1;
    if  timeGOStat>=4 then
    begin
      gameover:=false;
      stagestart:=false;
      GameStart:=false;
      GOStat:=false;
      timeGOStat:=0;
      TimerGOStat.Enabled:=false;
      menustart:=true;
    end;
end;

procedure TMainForm.TimerPl2PreShowTimer(Sender: TObject);
var i: integer;
begin
  i:=i+1;
  if i>=2 then
  begin
             masofPlayerTank[2].setneujazvimost(true);
                    polePl2:=10;
     masofPlayerTank[2].restore(x2,y2,1);
     i:=0;
     TimerPl2PreShow.Enabled:=false;
     Pl2Preshow:=false;
  end;
end;

procedure TMainForm.TimerPl1PreShowTimer(Sender: TObject);
var i: integer;
begin
  i:=i+1;
  if i>=2 then
  begin
             masofPlayerTank[1].setneujazvimost(true);
                    polePl1:=10;
     masofPlayerTank[1].restore(x1,y1,1);
     i:=0;
     TimerPl1PreShow.Enabled:=false;
     Pl1Preshow:=false;
  end;
end;

procedure TMainForm.SetVolume(volumeindex: Integer);
begin
  MMenu.VolumeAudio(0+Volumeindex);
  MButton.VolumeAudio(-1000+Volumeindex);
  MLevelStart.VolumeAudio(0+Volumeindex);
  MFirePl.VolumeAudio(-500+Volumeindex);
  MFireVrag.VolumeAudio(-1700+Volumeindex);
  MDomBah.VolumeAudio(0+Volumeindex);
  MZaborBah.VolumeAudio(0+Volumeindex);
  MBonus.VolumeAudio(0+Volumeindex);
  MTankBah.VolumeAudio(0+Volumeindex);
  MPopadanie.VolumeAudio(0+Volumeindex);
  MDrdr.VolumeAudio(-1000+Volumeindex);
  MGameOver.VolumeAudio(-1000+Volumeindex);
  MBazaBah.VolumeAudio(0+Volumeindex);
  Mbazaclose.VolumeAudio(-200+Volumeindex);
  Mbaraban.VolumeAudio(0+volumeindex);
end;

initialization
ubitotobonus:=0;
thisLevel:=1;




END.

