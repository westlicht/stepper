unit MidiPort;

interface

uses
  SysUtils,
  Classes,
  Windows,
  WinProcs,
  WinTypes,
  MMSystem;

type
  (**
   * Midi exception, used throughout the midi classes
   *)
  EMidiException = class(Exception);

  TMidiEventTyp = (
    etNoteOff  = $08,
    etNoteOn   = $09
  );

  PMidiEvent = ^TMidiEvent;
  TMidiEvent = record
    Channel : Byte;
    Typ : TMidiEventTyp;
    Data1, Data2 : Byte;
    SysEx : Pointer;
    Len : Integer;
  end;

 	PMidiCtlInfo = ^TMidiCtlInfo;
	TMidiCtlInfo = record
		hMem : THandle; 				{ Memory handle for this record }
		PBuffer : Pointer;	{ Pointer to the MIDI input data buffer }
		hWindow : HWnd;					{ Control's window handle }
		SysexOnly : Boolean;			{ Only process System Exclusive input }
	end;

  (**
   * Abstract base class for both MIDI input and output ports
   *)
  TMidiPort = class(TObject)
    protected
      FDeviceID : Integer;
      FEnabled : Boolean;

    public
      constructor Create(DeviceID : Integer);
      destructor Destroy; override;

      procedure Open; virtual; abstract;
      procedure Close; virtual; abstract;

    public
      property  Enabled : Boolean read FEnabled;

  end;

  (**
   * Class representing a midi input port
   *)
  TMidiInPort = class(TMidiPort)
    private

    public

  end;

  (**
   * Class representing a midi output port
   *)
  TMidiOutPort = class(TMidiPort)
    private
      FHandle : HMIDIOUT;

    public
      procedure Open; override;
      procedure Close; override;

      procedure SendEvent(Event : PMidiEvent);

      procedure PutShort(Status, Data1, Data2 : Byte);
      procedure PutLong(Data : Pointer; Len : Word);

  end;

  (**
   * Device type used for device descriptor
   *)
  TMidiDeviceTyp = (dtIn, dtOut);

  (**
   * Midi device descriptor (both input and output)
   *)
  TMidiDevice = class(TObject)
    public
      DeviceID : Integer;
      Typ : TMidiDeviceTyp;
      Name : String;
      MID : Word;
      PID : Word;
      DriverVersion : Cardinal;
      Support : Cardinal;

  end;

  (**
   * Midi manager responsible for enumeration of midi devices, as well as
   * creating input and output ports.
   *)
  TMidiManager = class(TObject)
    private
      FInDeviceList : TList;
      FOutDeviceList : TList;

    public
      constructor Create;
      destructor Destroy; override;

      procedure EnumerateDevices;

      function  CreateInPort(DeviceID : Integer) : TMidiInPort;
      function  CreateOutPort(DeviceID : Integer) : TMidiOutPort;

    private
      procedure ClearDevices;

      function  GetInDeviceCount : Integer;
      function  GetInDevice(Index : Integer) : TMidiDevice;
      function  GetInDeviceByName(Name : String) : TMidiDevice;
      function  GetOutDeviceCount : Integer;
      function  GetOutDevice(Index : Integer) : TMidiDevice;
      function  GetOutDeviceByName(Name : String) : TMidiDevice;

    public
      property  InDeviceCount : Integer read GetInDeviceCount;
      property  InDevice[Index : Integer] : TMidiDevice read GetInDevice;
      property  InDeviceByName[Name : String] : TMidiDevice read GetInDeviceByName;
      property  OutDeviceCount : Integer read GetOutDeviceCount;
      property  OutDevice[Index : Integer] : TMidiDevice read GetOutDevice;
      property  OutDeviceByName[Name : String] : TMidiDevice read GetOutDeviceByName;

  end;

  procedure CreateMidiEvent(Event : PMidiEvent; Typ : TMidiEventTyp; Data1, Data2 : Byte);
  procedure CreateMidiSysexEvent(Event : PMidiEvent; Data : Pointer; Len : Integer);

implementation

////////////////////////////////////////////////////////////////////////////////
// Misc.                                                                      //
////////////////////////////////////////////////////////////////////////////////

procedure CreateMidiEvent(Event : PMidiEvent; Typ : TMidiEventTyp; Data1, Data2 : Byte);
begin
  Event^.Typ := Typ;
  Event^.Data1 := Data1;
  Event^.Data2 := Data2;
  Event^.SysEx := nil;
end;

procedure CreateMidiSysexEvent(Event : PMidiEvent; Data : Pointer; Len : Integer);
begin
  Event^.SysEx := Data;
  Event^.Len := Len;
end;

////////////////////////////////////////////////////////////////////////////////
// TMidiPort                                                                  //
////////////////////////////////////////////////////////////////////////////////

constructor TMidiPort.Create(DeviceID : Integer);
begin
  inherited Create;

  FDeviceID := DeviceID;
  FEnabled := false;
end;

destructor TMidiPort.Destroy;
begin
  Close;
  
  inherited Destroy;
end;

////////////////////////////////////////////////////////////////////////////////
// TMidiInPort                                                                //
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// TMidiOutPort                                                               //
////////////////////////////////////////////////////////////////////////////////

procedure TMidiOutPort.Open;
var
  Result : Integer;
begin
  if FEnabled then Close;

  Result := midiOutOpen(@FHandle, FDeviceID, 0, 0, CALLBACK_NULL);

  if (Result <> MMSYSERR_NOERROR) then
    raise EMidiException.Create('Cannot open output port');

  FEnabled := true;
end;

procedure TMidiOutPort.Close;
begin
  if FEnabled then
  begin
    midiOutClose(FHandle);

    FEnabled := false;
  end;
end;

procedure TMidiOutPort.SendEvent(Event : PMidiEvent);
var
  Status : Byte;
begin
  if (Event^.SysEx = nil) then
  begin
    Status := Event^.Channel and $0F;
    Status := Status or ((Byte(Event^.Typ) and $0F) shl 4); 

    PutShort(Status, Event^.Data1, Event^.Data2);
  end;
end;

procedure TMidiOutPort.PutShort(Status, Data1, Data2 : Byte);
var
	Msg : DWORD;
begin
	Msg := DWORD(Status) or (DWORD(Data1) shl 8) or (DWORD(Data2) shl 16);

	if midiOutShortMsg(FHandle, Msg) <> MMSYSERR_NOERROR then
    raise EMidiException.Create('Cannot put short message');
end;


procedure TMidiOutPort.PutLong(Data : Pointer; Len : Word);
{ Notes: This works asynchronously; you send your sysex output by
calling this function, which returns immediately. When the MIDI device
driver has finished sending the data the MidiOutPut function in this
component is called, which will in turn call the OnMidiOutput method
if the component user has defined one. }
{ TODO: Combine common functions with PutTimedLong into subroutine }
//var
//	MyMidiHdr: TMyMidiHdr;
begin
{	// Initialize the header and allocate buffer memory
	MyMidiHdr := TMyMidiHdr.Create(msgLength);

	// Copy the data over to the MidiHdr buffer
	// We can't just use the caller's PChar because the buffer memory
	// has to be global, shareable, and locked.
	StrMove(MyMidiHdr.SysexPointer, TheSysex, msgLength);

	// Store the MyMidiHdr address in the header so we can find it again quickly
  // (see the MidiOutput proc)
	MyMidiHdr.hdrPointer^.dwUser := DWORD(MyMidiHdr);

  // Get MMSYSTEM's blessing for this header
	FError := midiOutPrepareHeader(FMidiHandle,MyMidiHdr.hdrPointer,
		sizeof(TMIDIHDR));
	if Ferror > 0 then
		raise EMidiOutputError.Create(MidiOutErrorString(FError));

  // Send it
	FError := midiOutLongMsg(FMidiHandle, MyMidiHdr.hdrPointer,
		sizeof(TMIDIHDR));
	if Ferror > 0 then
		raise EMidiOutputError.Create(MidiOutErrorString(FError));
}
end;

////////////////////////////////////////////////////////////////////////////////
// TMidiManager                                                               //
////////////////////////////////////////////////////////////////////////////////

constructor TMidiManager.Create;
begin
  inherited Create;

  FInDeviceList := TList.Create;
  FOutDeviceList := TList.Create;

  EnumerateDevices;
end;

destructor TMidiManager.Destroy;
begin
  ClearDevices;
  FInDeviceList.Destroy;
  FOutDeviceList.Destroy;

  inherited Destroy;
end;

procedure TMidiManager.EnumerateDevices;
var
  DeviceID : Integer;
  InCaps : MIDIINCAPS;
  OutCaps : MIDIOUTCAPS;
  Result : Integer;
  Device : TMidiDevice;
begin
  ClearDevices;

  for DeviceID := 0 to midiInGetNumDevs do
  begin
    Result := midiInGetDevCaps(DeviceID, @InCaps, SizeOf(InCaps));
    if Result = MMSYSERR_NOERROR then
    begin
      Device := TMidiDevice.Create;
      Device.DeviceID := DeviceID;
      Device.Typ := dtIn;
      Device.Name := InCaps.szPname;
      Device.MID := InCaps.wMid;
      Device.PID := InCaps.wPid;
      Device.Support := InCaps.dwSupport;
      FInDeviceList.Add(Device);
    end;
  end;

  for DeviceID := 0 to midiOutGetNumDevs do
  begin
    Result := midiOutGetDevCaps(DeviceID, @OutCaps, SizeOf(OutCaps));
    if Result = MMSYSERR_NOERROR then
    begin
      Device := TMidiDevice.Create;
      Device.DeviceID := DeviceID;
      Device.Typ := dtOut;
      Device.Name := OutCaps.szPname;
      Device.MID := OutCaps.wMid;
      Device.PID := OutCaps.wPid;
      Device.Support := OutCaps.dwSupport;
      FOutDeviceList.Add(Device);
    end;
  end;
end;

function  TMidiManager.CreateInPort(DeviceID : Integer) : TMidiInPort;
begin
  if (DeviceID < 0) or (DeviceID >= GetInDeviceCount) then
    raise EMidiException.Create('Invalid DeviceID');

//  Result := TMidiInPort.Create(DeviceID);
  Result := nil;
end;

function  TMidiManager.CreateOutPort(DeviceID : Integer) : TMidiOutPort;
begin
  if (DeviceID < 0) or (DeviceID >= GetOutDeviceCount) then
    raise EMidiException.Create('Invalid DeviceID');

  Result := TMidiOutPort.Create(DeviceID);
end;

procedure TMidiManager.ClearDevices;
var
  Index : Integer;
begin
  for Index := 0 to FInDeviceList.Count - 1 do
    TMidiDevice(FInDeviceList[Index]).Destroy;
  FInDeviceList.Clear;

  for Index := 0 to FOutDeviceList.Count - 1 do
    TMidiDevice(FOutDeviceList[Index]).Destroy;
  FOutDeviceList.Clear;
end;

function  TMidiManager.GetInDeviceCount : Integer;
begin
  Result := FInDeviceList.Count;
end;

function  TMidiManager.GetInDevice(Index : Integer) : TMidiDevice;
begin
  Result := nil;
  if (Index >= 0) and (Index < GetInDeviceCount) then
    Result := FInDeviceList[Index];
end;

function  TMidiManager.GetInDeviceByName(Name : String) : TMidiDevice;
var
  Index : Integer;
begin
  Result := nil;
  for Index := 0 to GetInDeviceCount - 1 do
    if TMidiDevice(FInDeviceList[Index]).Name = Name then
    begin
      Result := FInDeviceList[Index];
      Break;
    end;
end;

function  TMidiManager.GetOutDeviceCount : Integer;
begin
  Result := FOutDeviceList.Count;
end;

function  TMidiManager.GetOutDevice(Index : Integer) : TMidiDevice;
begin
  Result := nil;
  if (Index >= 0) and (Index < GetOutDeviceCount) then
    Result := FOutDeviceList[Index];
end;

function  TMidiManager.GetOutDeviceByName(Name : String) : TMidiDevice;
var
  Index : Integer;
begin
  Result := nil;
  for Index := 0 to GetOutDeviceCount - 1 do
    if TMidiDevice(FOutDeviceList[Index]).Name = Name then
    begin
      Result := FOutDeviceList[Index];
      Break;
    end;
end;

end.
