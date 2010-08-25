unit ModuleSequencer;

interface

uses
  XML_Document,
  XML_Node,
  Document,
  EngineTypes,
  ValueTypes;

type
  TModuleSequencer = class(TModule)
    private
      FSize : Integer;

      FInputMode : TInput;
      FInputValueRange : TInput;
      FInputPlayMode : TInput;
      FInputClockDiv : TInput;
      FInputFirstStep : TInput;
      FInputLastStep : TInput;
      FInputPosition : TInput;
      FInputClock : TInput;
      FInputStepValue : Array of TInput;
      FOutputSignal : TOutput;

      FLastClock : TValue;
      FBeat : TValue;
      FLastBeat : TValue;
      FPingPongDirection : Integer;

    public
      constructor Create(Document : TDocument; Group : TGroup); override;
      destructor Destroy; override;

      procedure Clear; override;

      procedure Reset; override;
      procedure Process(Frame : PEngineFrame); override;

      procedure SaveToXML(Document : TXMLDocument; BaseNode : TXMLNode); override;
      procedure LoadFromXML(Document : TXMLDocument; BaseNode : TXMLNode); override;

      procedure UpdateStepValueTyp;

    private
      procedure Step;

      function  GetInputStepValue(Index : Integer) : TInput;

    public
      property  Size : Integer read FSize;
      property  InputMode : TInput read FInputMode;
      property  InputValueRange : TInput read FInputValueRange;
      property  InputPlayMode : TInput read FInputPlayMode;
      property  InputClockDiv : TInput read FInputClockDiv;
      property  InputFirstStep : TInput read FInputFirstStep;
      property  InputLastStep : TInput read FInputLastStep;
      property  InputPosition : TInput read FInputPosition;
      property  InputClock : TInput read FInputClock;
      property  InputStepValue[Index : Integer] : TInput read GetInputStepValue;

  end;

implementation

uses
  SysUtils,
  UIModuleSequencer,
  ModuleFactory;

constructor TModuleSequencer.Create(Document : TDocument; Group : TGroup);
var
  Index : Integer;
begin
  inherited Create(Document, Group);

  FName := 'Sequencer';

  FSize := 32;

  FInputMode := CreateInput('Mode', vtSequencerMode, [ioCanEdit], 0.0);
  FInputValueRange := CreateInput('Range', vtSequencerValueRange, [ioCanEdit], 0.0);
  FInputPlayMode := CreateInput('Play Mode', vtSequencerPlayMode, [ioCanEdit], 0.0);
  FInputClockDiv := CreateInput('Clock Div', vtClockDiv, [ioCanEdit], 1.0);
  FInputFirstStep := CreateInput('First', vtIntValue, [ioCanEdit], 0.0);
  FInputLastStep := CreateInput('Last', vtIntValue, [ioCanEdit], FSize - 1);
  FInputPosition := CreateInput('Position', vtIntValue, [ioCanEdit], 0.0);
  FInputClock := CreateInput('Clock', vtClock, [ioCanConnect], 0.0);
  FOutputSignal := CreateOutput('Signal', vtValue, 0.0);

  SetLength(FInputStepValue, FSize);
  for Index := 0 to FSize - 1 do
    FInputStepValue[Index] := CreateInput('Step ' + IntToStr(Index), vtValue, [ioCanEdit, ioCanConnect], 0.0);

  UpdateStepValueTyp;
end;

destructor TModuleSequencer.Destroy;
begin
  inherited Destroy;
end;

procedure TModuleSequencer.Clear;
begin
  inherited Clear;
end;

procedure TModuleSequencer.Reset;
begin
  FInputPosition.Value := 0.0;
  FBeat := 0.0;
  FLastBeat := 0.0;
  FLastClock := 0.0;
  FPingPongDirection := 1;
end;

procedure TModuleSequencer.Process(Frame : PEngineFrame);
var
  NewClock : TValue;
  Position : Integer;
begin
  // Derive beat from incoming clock
  NewClock := FInputClock.CurrentValue;
  if NewClock < FLastClock then
  begin
    FBeat := trunc(FBeat) + 1.0 + NewClock;
  end else
  begin
    FBeat := trunc(FBeat) + NewClock;
  end;

  FLastClock := NewClock;

  // Update step position
  if FInputPosition.IsConnected then
  begin
    Position := FInputPosition.CurrentIntValue;
    inc(Position, FInputFirstStep.CurrentIntValue);
    Position := Position mod (FInputLastStep.CurrentIntValue - FInputFirstStep.CurrentIntValue);
    FOutputSignal.Value := FInputStepValue[Position].Value;
  end else
  begin
    if ((trunc(FBeat) mod FInputClockDiv.CurrentIntValue) = 0) and (trunc(FBeat) > FLastBeat) then
    begin
      Step;
      FLastBeat := trunc(FBeat);
    end;
    FOutputSignal.Value := FInputStepValue[trunc(FInputPosition.CurrentValue) mod FSize].Value;
  end;
end;

procedure TModuleSequencer.SaveToXML(Document : TXMLDocument; BaseNode : TXMLNode);
begin
  inherited SaveToXML(Document, BaseNode);
end;

procedure TModuleSequencer.LoadFromXML(Document : TXMLDocument; BaseNode : TXMLNode);
var
  Node : TXMLNode;
begin
  inherited LoadFromXML(Document, BaseNode);

  UpdateStepValueTyp;
end;

procedure TModuleSequencer.UpdateStepValueTyp;
var
  Mode : TSequencerMode;
  ValueRange : TSequencerValueRange;
  ValueTyp : TValueTyp;
  Index : Integer;
begin
  Mode := TSequencerMode(FInputMode.IntValue);
  ValueRange := TSequencerValueRange(FInputValueRange.IntValue);

  case Mode of
    smControl:
      begin
        case ValueRange of
          vr0_1   : ValueTyp := vt0_1;
          vr1_1   : ValueTyp := vt1_1;
          vr12_12 : ValueTyp := vt12_12;
          vr24_24 : ValueTyp := vt24_24;
        end;
      end;
    smGate:
      begin
        ValueTyp := vt0_1;
      end;
  end;

  for Index := 0 to FSize - 1 do
    FInputStepValue[Index].ValueTyp := ValueTyp;
end;

procedure TModuleSequencer.Step;
var
  PlayMode : TSequencerPlayMode;
  Position : Integer;
  First : Integer;
  Last : Integer;
begin
  PlayMode := TSequencerPlayMode(FInputPlayMode.IntValue);
  Position := FInputPosition.IntValue;
  First := FInputFirstStep.CurrentIntValue;
  Last := FInputLastStep.CurrentIntValue;

  case PlayMode of
    pmForward:
      begin
        inc(Position);
        if Position < First then Position := First;
        if Position > Last then Position := First;
      end;
    pmBackward:
      begin
        dec(Position);
        if Position < First then Position := Last;
        if Position > Last then Position := Last;
      end;
    pmPingPong:
      begin
        inc(Position, FPingPongDirection);
        if FPingPongDirection > 0 then
        begin
          if Position > Last then FPingPongDirection := -1;
        end else
        begin
          if Position < First then FPingPongDirection := 1;
        end;

        if Position < First then Position := First;
        if Position > Last then Position := Last;
      end;
    pmRandom:
      begin
        Position := First + Random(Last - First + 1);
      end;
  end;

  FInputPosition.IntValue := Position;
end;

function  TModuleSequencer.GetInputStepValue(Index : Integer) : TInput;
begin
  Result := FInputStepValue[Index];
end;

initialization
begin
  TModuleFactory.GetInstance.RegisterClass(TModuleSequencer, TUIModuleSequencer, 'Sequencer');
end;

end.
