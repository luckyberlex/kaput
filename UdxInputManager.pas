UNIT UdxInputManager;

{******************************************************************************}
{**  DirectInput: ������ � ���������� ������������ �����                     **}
{**  �����: ������ ������ �����������                                        **}
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
{**  ����������� ������                                                      **}
{******************************************************************************}  
constructor TdxInputManager.Create(AHandle: THandle);
begin
  // �������� ������ �� �������
  FDirectInput   := NIL;

  FKeyboard := NIL;
  FMouse    := NIL;
  FJoystick := NIL;
  FJoystick1 := NIL;

  // ���������� ��������� �� ������� �����
  FHandle := AHandle;
end;

{******************************************************************************}
{**  ���������� ������                                                       **}
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
{**  ������������ ������� ���������                                          **}
{******************************************************************************}


function EnumJoysticks(const pdinst: PDIDeviceInstance;
  pvRef: pointer): boolean; stdcall;
begin
  CopyMemory(@FJoyList[FJoyCount], @pdinst^.guidInstance, SizeOf(TGUID));
  inc(FJoyCount);
  Result := DIENUM_CONTINUE;
end;

{******************************************************************************}
{**  ������������� ����������                                                **}
{******************************************************************************}
function TdxInputManager.Initialize: HRESULT;
var
  I: integer;
begin
  // �������������� ���������� DirectInput
  Result := DirectInput8Create(HInstance, DIRECTINPUT_VERSION,
    IID_IDirectInput8, FDirectInput, NIL);
  if FAILED(Result) then EXIT;

  // ������ ������� ��� ������ � ����������� � �����
  Result := FDirectInput.CreateDevice(GUID_SysKeyboard, FKeyboard, NIL);
  if FAILED(Result) then EXIT;
  Result := FDirectInput.CreateDevice(GUID_SysMouse, FMouse, NIL);
  if FAILED(Result) then EXIT;

  // �������� ����� ������� ��������� � ������ �� ���������������
  FJoyCount := 0;
  ZeroMemory(@FJoyList, SizeOf(FJoyList));

  // �������� ������ ��������������� ������� ���������
  Result := FDirectInput.EnumDevices(
    DI8DEVCLASS_GAMECTRL,
    @EnumJoysticks,
    NIL,
    DIEDFL_ATTACHEDONLY);
  if FAILED(Result) then EXIT;

  // ������� ������� ����������
  for I := 0 to FJoyCount - 1 do
  begin
    if i=0 then
        Result := FDirectInput.CreateDevice(FJoyList[0], FJoystick, NIL);
    if i=1 then
        Result := FDirectInput.CreateDevice(FJoyList[1], FJoystick1, NIL);
   // if SUCCEEDED(Result) then Break;
  end;
  if FAILED(Result) then EXIT;

  // ������������� ������� ������� �� ���������
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

  // ������������� ������ ��������������
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
{**  ����� ��������� ����������                                              **}
{******************************************************************************}
function TdxInputManager.GetKeyboardState(KeyboardBuffer: PdxKeyboardState): HRESULT;
begin
  result := E_FAIL;
  if not (FAcquireKeyboard) or (FKeyboard = NIL) then EXIT;

  // ����� ����������
  Result := FKeyboard.GetDeviceState(SizeOf(KeyboardBuffer^), KeyboardBuffer);

  // ���� ���������� ��������
  if Result = DIERR_INPUTLOST then
  begin
    // ����������� �����
    FKeyboard.Acquire();

    // ���������� ��������� �����
    Result := FKeyboard.GetDeviceState(SizeOf(KeyboardBuffer^), KeyboardBuffer);
  end;
end;

{******************************************************************************}
{**  ����� ��������� ����                                                    **}
{******************************************************************************}
function TdxInputManager.GetMouseState(MouseBuffer: PdxMouseState): HRESULT;
begin
  result := E_FAIL;
  if not (FAcquireMouse) or (FMouse = NIL) then EXIT;

  // ���������� ����� ����, ������ ������������ � �����-������
  Result := FMouse.GetDeviceState(SizeOf(MouseBuffer^), MouseBuffer);

  // ���� ���������� ��������
  if Result = DIERR_INPUTLOST then
  begin
    // ����������� �����
    FMouse.Acquire();

    // ���������� ��������� �����
    Result := FMouse.GetDeviceState(SizeOf(MouseBuffer^), MouseBuffer);
  end;
end;

{******************************************************************************}
{**  ����� ��������� ���������                                               **}
{******************************************************************************}
function TdxInputManager.GetJoystickState(JoyBuffer: PdxJoyState;
              joyid: integer): HRESULT;
begin
  result := E_FAIL;
  if joyid=1 then
  begin
    if not (FAcquireJoystick) or (FJoystick = NIL) then EXIT;

    // ���������� ��������� ���������
    Result := FJoystick.GetDeviceState(SizeOf(JoyBuffer^), JoyBuffer);

    // ���� ���������� ��������
    if Result = DIERR_INPUTLOST then
    begin
      // ����������� �����
      FJoystick.Acquire();

      // ���������� ��������� �����
      Result := FJoystick.GetDeviceState(SizeOf(JoyBuffer^), JoyBuffer);
    end;
  end;
  if joyid=2 then
  begin
      if not (FAcquireJoystick1) or (FJoystick1 = NIL) then EXIT;

    // ���������� ��������� ���������
    Result := FJoystick1.GetDeviceState(SizeOf(JoyBuffer^), JoyBuffer);

    // ���� ���������� ��������
    if Result = DIERR_INPUTLOST then
    begin
      // ����������� �����
      FJoystick1.Acquire();

      // ���������� ��������� �����
      Result := FJoystick1.GetDeviceState(SizeOf(JoyBuffer^), JoyBuffer);
    end;
  end;

end;

{******************************************************************************}
{**  ��������� ���������� ������                                             **}
{******************************************************************************}
procedure TdxInputManager.SetDeviceMask(DeviceMask: DWORD);
begin
  // ��������� ������ ������ ���������
  FAcquireKeyboard := ((DeviceMask and idKeyboard) = idKeyboard);
  FAcquireMouse := ((DeviceMask and idMouse) = idMouse);
  FAcquireJoystick := ((DeviceMask and idJoystick) = idJoystick);
  FAcquireJoystick1 := ((DeviceMask and idJoystick1) = idJoystick1);

  // ��������� ������� ��� ���������� ������� � ���������� � ����������� �� �����
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