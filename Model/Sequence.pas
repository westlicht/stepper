unit Sequence;

interface

uses
  Classes,
  SyncObjs,
  SequenceEvent,
  XML_Document,
  XML_Node;

const
  SEQUENCE_MODE_STR : Array[0..3] of String = (
    'Pitch',
    'Gate',
    'Velocity',
    'Controller'
  );

  CONTROLLER_MODE_STR : Array[0..0] of String = (
    'Pitchbend'
  );

  RATE_STR : Array[0..6] of String = (
    '',
    '1/1',
    '1/2',
    '1/4',
    '1/8',
    '1/16',
    '1/32'
  );

  PLAY_MODE_STR : Array[0..3] of String = (
    'Forward',
    'Backward',
    'Ping Pong',
    'Random'
  );

type
  TSequenceMode = (smPitch, smGate, smVelocity, smController);
  TControllerMode = (cmPitchbend);
  TRate = Integer;
  TPlayMode = (pmForward, pmBackward, pmPingPong, pmRandom);
  TStepValue = Byte;

  TStep = class(TObject)
    public
      Value : TStepValue;
      Tie : Boolean;

  end;

  TSequence = class(TObject)
    private
      FEventQueue : TSequenceEventQueue;
      FProtectSequence : TCriticalSection;
      FName : String;
      FStepList : Array of TStep;
      FSize : Integer;
      FFirst : Integer;
      FLast : Integer;
      FSequenceMode : TSequenceMode;
      FRate : TRate;
      FPlayMode : TPlayMode;
      FPosition : Integer;
      FPlayDirection : Integer;

    public
      constructor Create(EventQueue : TSequenceEventQueue);
      destructor Destroy; override;

      procedure SaveToXML(Document : TXMLDocument; BaseNode : TXMLNode);
      procedure LoadFromXML(Document : TXMLDocument; BaseNode : TXMLNode);

      procedure Lock;
      procedure Unlock;

      procedure Reset;
      procedure Tick(Beat : Integer);

      procedure SetAllValues(Value : TStepValue);

    private
      function  GetStep(Index : Integer) : TStep;
      procedure SetSize(Size : Integer);

    public
      property  Name : String read FName write FName;
      property  Step[Index : Integer] : TStep read GetStep;
      property  Size : Integer read FSize write SetSize;
      property  First : Integer read FFirst write FFirst;
      property  Last : Integer read FLast write FLast;
      property  SequenceMode : TSequenceMode read FSequenceMode write FSequenceMode;
      property  Rate : TRate read FRate write FRate;
      property  PlayMode : TPlayMode read FPlayMode write FPlayMode;
      property  Position : Integer read FPosition write FPosition;

  end;

  function  SequenceModeToStr(SequenceMode : TSequenceMode) : String;
  function  StrToSequenceMode(Str : String) : TSequenceMode;
  function  ControllerModeToStr(ControllerMode : TControllerMode) : String;
  function  StrToControllerMode(Str : String) : TControllerMode;
  function  RateToStr(Rate : TRate) : String;
  function  StrToRate(Str : String) : TRate;
  function  PlayModeToStr(PlayMode : TPlayMode) : String;
  function  StrToPlayMode(Str : String) : TPlayMode;

implementation

uses
  SysUtils;

const
  DEFAULT_SIZE = 16;

////////////////////////////////////////////////////////////////////////////////
// Misc. functions                                                            //
////////////////////////////////////////////////////////////////////////////////

function  FindInList(List : Array of String; Str : String) : Integer;
var
  Index : Integer;
begin
  Result := 0;
  for Index := 0 to High(List) do
    if CompareText(Str, List[Index]) = 0 then
    begin
      Result := Index;
      Exit;
    end;
end;

function  SequenceModeToStr(SequenceMode : TSequenceMode) : String;
begin
  Result := SEQUENCE_MODE_STR[Integer(SequenceMode)];
end;

function  StrToSequenceMode(Str : String) : TSequenceMode;
begin
  Result := TSequenceMode(FindInList(SEQUENCE_MODE_STR, Str));
end;

function  ControllerModeToStr(ControllerMode : TControllerMode) : String;
begin
  Result := CONTROLLER_MODE_STR[Integer(ControllerMode)];
end;

function  StrToControllerMode(Str : String) : TControllerMode;
begin
  Result := TControllerMode(FindInList(CONTROLLER_MODE_STR, Str));
end;

function  RateToStr(Rate : TRate) : String;
begin
  Result := RATE_STR[Integer(Rate)];
end;

function  StrToRate(Str : String) : TRate;
begin
  Result := TRate(FindInList(RATE_STR, Str));
end;

function  PlayModeToStr(PlayMode : TPlayMode) : String;
begin
  Result := PLAY_MODE_STR[Integer(PlayMode)];
end;

function  StrToPlayMode(Str : String) : TPlayMode;
begin
  Result := TPlayMode(FindInList(PLAY_MODE_STR, Str));
end;

////////////////////////////////////////////////////////////////////////////////
// TSequence                                                                  //
////////////////////////////////////////////////////////////////////////////////

constructor TSequence.Create(EventQueue : TSequenceEventQueue);
begin
  inherited Create;

  FEventQueue := EventQueue;
  FProtectSequence := TCriticalSection.Create;
  FName := 'Default';
  FSize := 0;
  SetSize(DEFAULT_SIZE);
  FFirst := 0;
  FLast := DEFAULT_SIZE - 1;
  FSequenceMode := smPitch;
  FRate := 1;
  FPlayMode := pmForward;

  Reset;
end;

destructor TSequence.Destroy;
begin
  SetSize(0);
  FProtectSequence.Destroy;

  inherited Destroy;
end;

procedure TSequence.SaveToXML(Document : TXMLDocument; BaseNode : TXMLNode);
var
  Index : Integer;
  Step : TStep;
  Node : TXMLNode;
begin
  BaseNode.AttributeList.Add('Name', FName);
  BaseNode.AttributeList.Add('Size', IntToStr(FSize));
  BaseNode.AttributeList.Add('First', IntToStr(FFirst));
  BaseNode.AttributeList.Add('Last', IntToStr(FLast));
  BaseNode.AttributeList.Add('SequenceMode', SequenceModetoStr(FSequenceMode));
  BaseNode.AttributeList.Add('Rate', RateToStr(FRate));
  BaseNode.AttributeList.Add('PlayMode', PlayModeToStr(FPlayMode));

  for Index := 0 to FSize - 1 do
  begin
    Step := FStepList[Index];
    Node := BaseNode.CreateChild;
    Node.Name := 'Step';
    Node.AttributeList.Add('Value', IntToStr(Step.Value));
    Node.AttributeList.Add('Tie', IntToStr(Integer(Step.Tie)));
  end;
end;

procedure TSequence.LoadFromXML(Document : TXMLDocument; BaseNode : TXMLNode);
var
  Index : Integer;
  Step : TStep;
  Node : TXMLNode;
begin
  FName := BaseNode.AttributeList.ValueByName['Name'];
  SetSize(StrToInt(BaseNode.AttributeList.ValueByName['Size']));
  FFirst := StrToInt(BaseNode.AttributeList.ValueByName['First']);
  FLast := StrToInt(BaseNode.AttributeList.ValueByName['Last']);
  FSequenceMode := StrToSequenceMode(BaseNode.AttributeList.ValueByName['SequenceMode']);
  FRate := StrToRate(BaseNode.AttributeList.ValueByName['Rate']);
  FPlayMode := StrToPlayMode(BaseNode.AttributeList.ValueByName['PlayMode']);

  for Index := 0 to FSize - 1 do
  begin
    Step := FStepList[Index];
    Node := BaseNode.ChildList[Index];
    Step.Value := StrToInt(Node.AttributeList.ValueByName['Value']);
    Step.Tie := Boolean(StrToInt(Node.AttributeList.ValueByName['Tie']));
  end;
end;

procedure TSequence.Lock;
begin
  FProtectSequence.Acquire;
end;

procedure TSequence.Unlock;
begin
  FProtectSequence.Release;
end;

procedure TSequence.Reset;
begin
  case FPlayMode of
    pmForward:
      begin
        FPosition := FFirst;
      end;
    pmBackward:
      begin
        FPosition := FLast;
      end;
    pmPingPong:
      begin
        FPosition := FFirst;
      end;
    pmRandom:
      begin
        FPosition := Random(FLast - FFirst + 1) + FFirst;
      end;
  end;

  FPlayDirection := 1;
end;

procedure TSequence.Tick(Beat : Integer);
var
  NewPosition : Integer;
begin
  if Beat mod (1 shl (7 - FRate)) <> 0 then
    Exit;

  if Beat > 0 then
  begin
    case FPlayMode of
      pmForward:
        begin
          inc(FPosition);
          if FPosition > FLast then
            FPosition := FFirst;
        end;
      pmBackward:
        begin
          dec(FPosition);
          if FPosition < FFirst then
            FPosition := FLast;
        end;
      pmPingPong:
        begin
          FPosition := FPosition + FPlayDirection;
          if FPosition = FLast then
            FPlayDirection := -1
          else if FPosition = FFirst then
            FPlayDirection := 1;
  
          if FPosition > FLast then
          begin
            FPosition := FLast;
            FPlayDirection := -1;
          end else
          if FPosition < FFirst then
          begin
            FPosition := FFirst;
            FPlayDirection := 1;
          end;
        end;
      pmRandom:
        begin
          repeat
            NewPosition := Random(FLast - FFirst + 1) + FFirst;
          until NewPosition <> FPosition;
          FPosition := NewPosition;
        end;
    end;
  end;

  // Create events
  case FSequenceMode of
    smPitch:
      begin
        FEventQueue.AddEvent(Beat, 0.0, etPitch, FStepList[FPosition].Value, 0);
      end;            
    smGate:
      begin
        FEventQueue.AddEvent(Beat, 0.0, etGateOn, 0, 0);
        if not FStepList[FPosition].Tie then
          FEventQueue.AddEvent(Beat, 1.0, etGateOff, 0, 0);
      end;
    smVelocity:
      begin
        FEventQueue.AddEvent(Beat, 0.0, etVelocity, FStepList[FPosition].Value, 0);
      end;
    smController:
      begin
        FEventQueue.AddEvent(Beat, 0.0, etController, FStepList[FPosition].Value, 0);
      end;
  end;
end;

procedure TSequence.SetAllValues(Value : TStepValue);
var
  Index : Integer;
begin
  for Index := 0 to High(FStepList) do
    FStepList[Index].Value := Value;
end;

function  TSequence.GetStep(Index : Integer) : TStep;
begin
  Result := FStepList[Index];
end;

procedure TSequence.SetSize(Size : Integer);
var
  Index : Integer;
begin
  if Size >= FSize then
  begin
    SetLength(FStepList, Size);
    for Index := FSize to Size - 1 do
      FStepList[Index] := TStep.Create;
  end else
  begin
    for Index := Size to FSize - 1 do
      FStepList[Index].Destroy;
    SetLength(FStepList, Size);
  end;

  FSize := Size;
end;

end.
