UNIT UdxInputManager;

{******************************************************************************}
{**  DirectInput: работа с различными устройствами ввода                     **}
{**  Автор: Есенин Сергей Анатольевич                                        **}
{******************************************************************************}

{**} INTERFACE {***************************************************************}

{**} USES {********************************************************************}
  Windows, ComObj, ActiveX, DirectInput;

{**} CONST {*******************************************************************}
  idKeyboard  = $00000001;
  idMouse     = $00000002;
  idJoystick  = $00000008;
  idJoystick1  = $00000004;

{**} TYPE {********************************************************************}
  PdxKeyboardState = ^TdxKeyboardState;
  TdxKeyboardState = array [0..255] of Byte;

  PdxMouseState = ^TdxMouseState;
  TdxMouseState = TDIMouseState;

  PdxJoyState = ^TdxJoyState;
  TdxJoyState = TDIJoyState;

  TdxInputManager = class
  PRIVATE
    FDirectInput:   IDirectInput8;

    FKeyboard: IDirectInputDevice8;
    FMouse:    IDirectInputDevice8;
    FJoystick: IDirectInputDevice8;
    FJoystick1: IDirectInputDevice8;

    FAcquireKeyboard: boolean;
    FAcquireMouse:    boolean;
    FAcquireJoystick: boolean;
    FAcquireJoystick1: boolean;

    FHandle: THandle;
  PUBLIC
    constructor Create(AHandle: THandle);
    destructor Destroy; override;

    function Initialize: HRESULT;

    procedure SetDeviceMask(DeviceMask: DWORD);

    function GetKeyboardState(KeyboardBuffer: PdxKeyboardState): HRESULT;
    function GetMouseState(MouseBuffer: PdxMouseState): HRESULT;
    function GetJoystickState(JoyBuffer: PdxJoyState; joyid: integer): HRESULT;
  END;

  var
  FJoyCount: integer;
  FJoyList: TGUIDList;

{**} IMPLEMENTATION {**********************************************************}

{**} { TdxInputManager } {*****************************************************}

{******************************************************************************}
{**  Конструктор класса                                                      **}
{******************************************************************************}  
constructor TdxInputManager.Create(AHandle: THandle);
begin
  // Обнуляем ссылки на объекты
  FDirectInput   := NIL;

  FKeyboard := NIL;
  FMouse    := NIL;
  FJoystick := NIL;
  FJoystick1 := NIL;

  // Запоминаем указатель на главную форму
  FHandle := AHandle;
end;

{******************************************************************************}
{**  Деструктор класса                                                       **}
{******************************************************************************}
destructor TdxInputManager.Destroy;
begin
  if FJoystick <> NIL then
  begin
    FJoystick.Unacquire;
    FJoystick := NIL;
  end;

  if FJoystick1 <> NIL then
  begin
    FJoystick1.Unacquire;
    FJoystick1 := NIL;
  end;

  if FMouse <> NIL then
  begin
    FMouse.Unacquire;
    FMouse := NIL;
  end;

  if FKeyboard <> NIL then
  begin
    FKeyboard.Unacquire;
    FKeyboard := NIL;
  end;

  FDirectInput := NIL;
end;

{******************************************************************************}
{**  Перечисление игровых устройств                                          **}
{******************************************************************************}


function EnumJoysticks(const pdinst: PDIDeviceInstance;
  pvRef: pointer): boolean; stdcall;
begin
  CopyMemory(@FJoyList[FJoyCount], @pdinst^.guidInstance, SizeOf(TGUID));
  inc(FJoyCount);
  Result := DIENUM_CONTINUE;
end;

{******************************************************************************}
{**  Инициализация подсистемы                                                **}
{******************************************************************************}
function TdxInputManager.Initialize: HRESULT;
var
  I: integer;
begin
  // Инициализируем подсистему DirectInput
  Result := DirectInput8Create(HInstance, DIRECTINPUT_VERSION,
    IID_IDirectInput8, FDirectInput, NIL);
  if FAILED(Result) then EXIT;

  // Создаём объекты для работы с клавиатурой и мышью
  Result := FDirectInput.CreateDevice(GUID_SysKeyboard, FKeyboard, NIL);
  if FAILED(Result) then EXIT;
  Result := FDirectInput.CreateDevice(GUID_SysMouse, FMouse, NIL);
  if FAILED(Result) then EXIT;

  // Обнуляем число игровых устройств и список их идентификаторов
  FJoyCount := 0;
  ZeroMemory(@FJoyList, SizeOf(FJoyList));

  // Получаем список идентификаторов игровых устройств
  Result := FDirectInput.EnumDevices(
    DI8DEVCLASS_GAMECTRL,
    @EnumJoysticks,
    NIL,
    DIEDFL_ATTACHEDONLY);
  if FAILED(Result) then EXIT;

  // Создаем игровое устройство
  for I := 0 to FJoyCount - 1 do
  begin
    if i=0 then
        Result := FDirectInput.CreateDevice(FJoyList[0], FJoystick, NIL);
    if i=1 then
        Result := FDirectInput.CreateDevice(FJoyList[1], FJoystick1, NIL);
   // if SUCCEEDED(Result) then Break;
  end;
  if FAILED(Result) then EXIT;

  // Устанавливаем форматы каждого из устройств
  Result := FKeyboard.SetDataFormat(c_dfDIKeyboard);
  if FAILED(Result) then EXIT;
  Result := FMouse.SetDataFormat(c_dfDIMouse);
  if FAILED(Result) then EXIT;

  if FJoystick <> NIL then
  begin
    Result := FJoystick.SetDataFormat(c_dfDIJoystick);
    if FAILED(Result) then EXIT;
  end;

  if FJoystick1 <> NIL then
  begin
    Result := FJoystick1.SetDataFormat(c_dfDIJoystick);
    if FAILED(Result) then EXIT;
  end;

  // Устанавливаем уровни взаимодействия
  if FKeyboard <> NIL then
  begin
    Result := FKeyboard.SetCooperativeLevel(FHandle, DISCL_BACKGROUND or DISCL_NONEXCLUSIVE);
    if FAILED(Result) then EXIT;
  end;

  if FMouse <> NIL then
  begin
    Result := FMouse.SetCooperativeLevel(FHandle, DISCL_BACKGROUND or DISCL_NONEXCLUSIVE);
    if FAILED(Result) then EXIT;
  end;
  
  if FJoystick <> NIL then
  begin
    Result := FJoystick.SetCooperativeLevel(FHandle, DISCL_BACKGROUND or DISCL_EXCLUSIVE);
  end;

  if FJoystick1 <> NIL then
  begin
    Result := FJoystick1.SetCooperativeLevel(FHandle,
    DISCL_BACKGROUND or DISCL_EXCLUSIVE);
  end;
end;

{******************************************************************************}
{**  Опрос состояния клавиатуры                                              **}
{******************************************************************************}
function TdxInputManager.GetKeyboardState(KeyboardBuffer: PdxKeyboardState): HRESULT;
begin
  result := E_FAIL;
  if not (FAcquireKeyboard) or (FKeyboard = NIL) then EXIT;

  // Опрос клавиатуры
  Result := FKeyboard.GetDeviceState(SizeOf(KeyboardBuffer^), KeyboardBuffer);

  // Если устройство потеряно
  if Result = DIERR_INPUTLOST then
  begin
    // Захватываем снова
    FKeyboard.Acquire();

    // Производим повторный опрос
    Result := FKeyboard.GetDeviceState(SizeOf(KeyboardBuffer^), KeyboardBuffer);
  end;
end;

{******************************************************************************}
{**  Опрос состояния мыши                                                    **}
{******************************************************************************}
function TdxInputManager.GetMouseState(MouseBuffer: PdxMouseState): HRESULT;
begin
  result := E_FAIL;
  if not (FAcquireMouse) or (FMouse = NIL) then EXIT;

  // Производим опрос мыши, данные записываются в буфер-массив
  Result := FMouse.GetDeviceState(SizeOf(MouseBuffer^), MouseBuffer);

  // Если устройство потеряно
  if Result = DIERR_INPUTLOST then
  begin
    // Захватываем снова
    FMouse.Acquire();

    // Производим повторный опрос
    Result := FMouse.GetDeviceState(SizeOf(MouseBuffer^), MouseBuffer);
  end;
end;

{******************************************************************************}
{**  Опрос состояния джойстика                                               **}
{******************************************************************************}
function TdxInputManager.GetJoystickState(JoyBuffer: PdxJoyState;
              joyid: integer): HRESULT;
begin
  result := E_FAIL;
  if joyid=1 then
  begin
    if not (FAcquireJoystick) or (FJoystick = NIL) then EXIT;

    // Опрашиваем состояние джойстика
    Result := FJoystick.GetDeviceState(SizeOf(JoyBuffer^), JoyBuffer);

    // Если устройство потеряно
    if Result = DIERR_INPUTLOST then
    begin
      // Захватываем снова
      FJoystick.Acquire();

      // Производим повторный опрос
      Result := FJoystick.GetDeviceState(SizeOf(JoyBuffer^), JoyBuffer);
    end;
  end;
  if joyid=2 then
  begin
      if not (FAcquireJoystick1) or (FJoystick1 = NIL) then EXIT;

    // Опрашиваем состояние джойстика
    Result := FJoystick1.GetDeviceState(SizeOf(JoyBuffer^), JoyBuffer);

    // Если устройство потеряно
    if Result = DIERR_INPUTLOST then
    begin
      // Захватываем снова
      FJoystick1.Acquire();

      // Производим повторный опрос
      Result := FJoystick1.GetDeviceState(SizeOf(JoyBuffer^), JoyBuffer);
    end;
  end;

end;

{******************************************************************************}
{**  Установка параметров опроса                                             **}
{******************************************************************************}
procedure TdxInputManager.SetDeviceMask(DeviceMask: DWORD);
begin
  // Установка флагов опроса устройств
  FAcquireKeyboard := ((DeviceMask and idKeyboard) = idKeyboard);
  FAcquireMouse := ((DeviceMask and idMouse) = idMouse);
  FAcquireJoystick := ((DeviceMask and idJoystick) = idJoystick);
  FAcquireJoystick1 := ((DeviceMask and idJoystick1) = idJoystick1);

  // Получение доступа или запрещение доступа к устройству в зависимости от флага
  if FKeyboard <> NIL then
  begin
    if (DeviceMask and idKeyboard) = idKeyboard then FKeyboard.Acquire else FKeyboard.Unacquire;
  end;

  if FMouse <> NIL then
  begin
    if (DeviceMask and idMouse) = idMouse then FMouse.Acquire else FMouse.Unacquire;
  end;

  if FJoystick <> NIL then
  begin
    if (DeviceMask and idJoystick) = idJoystick then FJoystick.Acquire else FJoystick.Unacquire;
  end;

  if FJoystick1 <> NIL then
  begin
    if (DeviceMask and idJoystick1) = idJoystick1 then
    FJoystick1.Acquire else FJoystick1.Unacquire;
  end;
end;

END.
