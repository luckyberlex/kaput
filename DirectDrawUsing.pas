// КЛАССЫ ДЛЯ РАБОТЫ С DIRECTDRAW
// АВТОР: БЕРЕЗА А.В.

unit DirectDrawUsing;

interface

uses Windows,DirectDraw,Graphics,SysUtils,Types;

type
   CDisplay = class
   private
    FDD7: IDirectDraw7;
    FDDSPrimary: IDirectDrawSurface7;
    FDDSSecondary: IDirectDrawSurface7;
   public
    //инициализация DirectDraw
    function CreateFullScreen(hwnd: HWND;
                width,height,BPP:integer): HResult;
    //освобождение ресурсов
    procedure FreeDirectDraw;
      //функции доступа
    function GetDD7  : IDIRECTDRAW7;
    function GetDDSPrimary : IDIRECTDRAWSURFACE7;
    function GetDDSSecondary  : IDIRECTDRAWSURFACE7;
   ///
    function TestCL:Hresult;
    Function RestoreAS:Hresult;
    function DDSFlip:Hresult;
       //очистка буффера
    function ClearSecondSurf(Color: Cardinal):HRESULT;
  end;
////////////////////////////////////////////////////////////////////
  COutSurface = class
  private
    Surface: IDirectDrawSurface7;
    Display: CDisplay;
    UseColorKey: bool;
  public
    //создает внеэкранную поверхность нужного размера
  constructor Create( var newDisp: Cdisplay;
              var newSurface: IDirectDrawSurface7;
              x,y:integer;
              newUseColorKey: bool);

  //инициализируем поверхность и переносим на нее bmp из файла
  function DrawBTM (
    filename: String;               // имя файла
    colorkeyinit: dword):           // установка ключа прозрачности
  HResult;

  //перенос поверхности на вторичную поверхность(подготовка буфера)
 { function DrawOnSecSurf (
    x,y:integer;                    // координаты в буфере
                                    //координаты на исходной поверхности
    lx,ly:integer;                  // левый верхний
    rx,ry:integer):                  // нижний правый
  Hresult;        }


    //очистка поверхности
  function ClearSurface(
    Color: Cardinal):                 //цвет фона
  HRESULT;


  //перенос bmp на поверхность
  function DDCopyBitmap(
    DDSurface: IDirectDrawSurface7;  // поверхность
    Bitmap: TBitmap;                 // указатель на bmp
    dx, dy: integer):                // размеры bmp
  HRESULT;

  function GetSurface: IDirectDrawSurface7;
  function GetUseColorKey: bool;
  function GetDisplay: CDisplay;
  function CopySurf( var newDisp: Cdisplay;x,y,h,w:integer):hresult;
end;



///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////

implementation
function COutSurface.GetSurface: IDirectDrawSurface7;
begin
  Result:=Surface;
end;
function COutSurface.GetUseColorKey: bool;
begin
  Result:=UseColorKey;
end;
function COutSurface.GetDisplay: CDisplay;
begin
  Result:=Display;
end;
constructor COutSurface.Create( var newDisp: Cdisplay;
                        var newSurface: IDirectDrawSurface7;
                        x,y:integer;
                        newUseColorKey: bool);
var
  ddsd: TDDSurfaceDesc2;
  result: hresult;
begin
  self.Surface:=newSurface;
  Self.Display:=newDisp;
  UseColorKey:=newUseColorKey;

   // Внеэкранная поверхность
    // Параметры внеэкранной поверхности
    ZeroMemory (@ddsd, SizeOf(ddsd));
    ddsd.dwSize   := SizeOf(ddsd);
    ddsd.dwFlags  := DDSD_CAPS or DDSD_WIDTH or DDSD_HEIGHT;
    ddsd.dwWidth  :=  x;
    ddsd.dwHeight :=  y;
    ddsd.ddsCaps.dwCaps := DDSCAPS_OFFSCREENPLAIN;
  // Создаем внеэкранную поверхность
  result:=Display.FDD7.CreateSurface(ddsd,Self.Surface, NIL);
  if FAILED(result) then EXIT;

end;


function COutSurface.DDCopyBitmap(DDSurface: IDirectDrawSurface7; Bitmap: TBitmap;
  dx, dy: integer): HRESULT;
var
  hdcImage: HDC;
  dc: HDC;
  bm: HBitmap;
begin
  // Результат по умолчанию
  result := E_FAIL;
  if (Bitmap = NIL) or (DDSurface = NIL) then EXIT;

  // Создаем конткст устройства совместимого с указанным в памяти
  hdcImage := CreateCompatibleDC(0);
  // Выбираем объект
  bm := SelectObject(hdcImage, Bitmap.Handle);

  // Получаем контекст устройства
  result := DDSurface.GetDC(dc);

  if (result = DD_OK) then begin
    // Копируем изображение
    BitBlt(dc, 0, 0, dx, dy, hdcImage, 0, 0, SRCCOPY);

    // Освобождаем контекст устройства
    DDSurface.ReleaseDC(dc);
  end;

  // Освобождаем ресурсы
  SelectObject(hdcImage, bm);
  DeleteDC(hdcImage);
end;



//////////////////////////////////////////////////////////////////
function COutSurface.DrawBTM(filename: String;colorkeyinit: dword): HResult;
var
  bitmap: TBitmap;
  ddck: TDDColorKey;
begin
  // Внеэкранная поверхность
  bitmap := TBitmap.Create;
  try
    bitmap.LoadFromFile(filename);
    DDCopyBitmap(Self.Surface, bitmap, bitmap.Width, bitmap.Height);
    if Self.UseColorKey then begin
      // Устанавливаем цветовой ключ
      ddck.dwColorSpaceLowValue := colorkeyinit;
      ddck.dwColorSpaceHighValue := ddck.dwColorSpaceLowValue;
      Result := Self.Surface.SetColorKey(DDCKEY_SRCBLT, @ddck);
    end;
  finally
    FreeAndNil(bitmap);
  end;

end;

//////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////

function COutSurface.ClearSurface(Color: Cardinal) : HRESULT;
var
  ddbltfx : TDDBLTFX;
begin
  // Результат по умолчанию
  Result := E_FAIL;
  if Surface = NIL then EXIT;

  // Задаем цвет фона
  ZeroMemory(@ddbltfx, SizeOf(ddbltfx));
  ddbltfx.dwSize := SizeOf(ddbltfx);
  ddbltfx.dwFillColor := Color;

  // Заполняем поверхность
  Result := Surface.Blt(NIL, NIL, NIL, DDBLT_COLORFILL or DDBLT_WAIT, @DDBLTFX);
end;



/////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////






function Cdisplay.ClearSecondSurf(Color: Cardinal):hresult;
var
  ddbltfx : TDDBLTFX;
begin
  // Результат по умолчанию
  Result := E_FAIL;
  if FddsSecondary = NIL then EXIT;

  // Задаем цвет фона
  ZeroMemory(@ddbltfx, SizeOf(ddbltfx));
  ddbltfx.dwSize := SizeOf(ddbltfx);
  ddbltfx.dwFillColor := Color;

  // Заполняем поверхность
  Result := FddsSecondary.Blt(NIL, NIL, NIL, DDBLT_COLORFILL or DDBLT_WAIT, @DDBLTFX);
end;



function Cdisplay.GetDD7  : IDIRECTDRAW7;
begin
  Result :=FDD7;
end;

function Cdisplay.GetDDSPrimary : IDIRECTDRAWSURFACE7;
begin
  Result := FDDSPrimary ;
end;

function Cdisplay.GetDDSSecondary  : IDIRECTDRAWSURFACE7;
begin
  Result := FDDSSecondary;
end;


  function CDisplay.TestCL:Hresult;
  begin
    result:=Fdd7.TestCooperativeLevel;
  end;

  Function CDisplay.RestoreAS:Hresult;
  begin
    result:=Fdd7.RestoreAllSurfaces;
  end;

  function CDisplay.DDSFlip:Hresult;
  begin
    result:=FDDSPrimary.Flip(NIL, DDFLIP_WAIT);
  end;


function CDisplay.CreateFullScreen(hwnd: HWND;
                width,height,BPP:integer): HResult;
var
  ddsd: TDDSurfaceDesc2;
  ddscaps: TDDSCaps2;
begin
  // Создание объекта DirectDraw
  Result := DirectDrawCreateEx (NIL, FDD7, IDirectDraw7, NIL);
  if Result <> DD_OK then Exit;

  // Установка уровня взаимодействия
  Result := FDD7.SetCooperativeLevel(hwnd, DDSCL_FULLSCREEN or DDSCL_EXCLUSIVE);
  if Result <> DD_OK then Exit;

  // Установка полноэкранного режима
  Result := FDD7.SetDisplayMode(width, height, BPP, 0, 0);
  if Result <> DD_OK then Exit;

  // Параметры основной поверхности
  ZeroMemory(@ddsd, SizeOf(ddsd));
  ddsd.dwSize := SizeOf(ddsd);
  ddsd.dwFlags := DDSD_CAPS or DDSD_BACKBUFFERCOUNT;
  ddsd.ddsCaps.dwCaps := DDSCAPS_PRIMARYSURFACE or DDSCAPS_COMPLEX or DDSCAPS_FLIP;
  ddsd.dwBackBufferCount := 1;

  // Создаем первичную поверхность
  Result := FDD7.CreateSurface(ddsd, FDDSPrimary, NIL);
  if Result <> DD_OK then Exit;

  // Вторичная поверхность
  ZeroMemory(@ddscaps, SizeOf(ddscaps));
  ddscaps.dwCaps := DDSCAPS_BACKBUFFER;
  Result := FDDSPrimary.GetAttachedSurface(ddscaps, FDDSSecondary);
  if Result <> DD_OK then Exit;
end;

//////////////////////////////////////////////////////////////////
procedure CDisplay.FreeDirectDraw;
begin
  FDDSSecondary := NIL;
  FDDSPrimary := NIL;
  FDD7 := NIL;
end;

//////////////////////////////////////////////////////////////////////

function COutSurface.CopySurf( var newDisp: Cdisplay;
                          x,y,h,w:integer):hresult;
var
  OSRect: TRect;
begin
  OSRect := Rect(x, y, x+w-20, y+h-20);
  Surface.BltFast
  (0, 0, newDisp.GetDDSSecondary,nil, DDBLTFAST_WAIT);
end;



END.
