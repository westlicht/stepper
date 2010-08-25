unit SequenceEvent;

interface

uses
  Classes;

type
  TSequenceEventTyp = (
    // Track only event types
    etPitch,
    etVelocity,
    etGateOn,
    etGateOff,
    // Global event types
    etNoteOn,
    etNoteOff,
    etController
  );

  TSequenceEvent = class(TObject)
    public
      Beat : Integer;
      Offset : Single;
      Typ : TSequenceEventTyp;
      Data1 : Byte;
      Data2 : Byte;

  end;

  TSequenceEventQueue = class(TObject)
    private
      FEventList : TList;
      FIndex : Integer;

    public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;

      procedure AddEvent(Event : TSequenceEvent); overload;
      procedure AddEvent(Beat : Integer; Offset : Single; Typ : TSequenceEventTyp; Data1, Data2 : Byte); overload;
      function  GetFirst : TSequenceEvent;
      function  GetNext : TSequenceEvent;
      procedure Remove; 

  end;

implementation

constructor TSequenceEventQueue.Create;
begin
  inherited Create;

  FEventList := TList.Create;
end;

destructor TSequenceEventQueue.Destroy;
begin
  Clear;
  
  FEventList.Destroy;

  inherited Destroy;
end;

procedure TSequenceEventQueue.Clear;
var
  Index : Integer;
begin
  for Index := 0 to FEventList.Count - 1 do
    TSequenceEvent(FEventList[Index]).Destroy;

  FEventList.Clear;
end;

procedure TSequenceEventQueue.AddEvent(Event : TSequenceEvent);
begin
  FEventList.Add(Event);
end;

procedure TSequenceEventQueue.AddEvent(Beat : Integer; Offset : Single; Typ : TSequenceEventTyp; Data1, Data2 : Byte);
var
  Event : TSequenceEvent;
begin
  Event := TSequenceEvent.Create;
  Event.Beat := Beat;
  Event.Offset := Offset;
  Event.Typ := Typ;
  Event.Data1 := Data1;
  Event.Data2 := Data2;
  AddEvent(Event);
end;

function  TSequenceEventQueue.GetFirst : TSequenceEvent;
begin
  FIndex := 0;
  Result := GetNext;
end;

function  TSequenceEventQueue.GetNext : TSequenceEvent;
begin
  Result := nil;
  if FIndex < FEventList.Count then
  begin
    Result := FEventList[FIndex];
    inc(FIndex);
  end;
end;

procedure TSequenceEventQueue.Remove;
begin
  if FIndex < FEventList.Count then
    FEventList.Delete(FIndex);
end;

end.
