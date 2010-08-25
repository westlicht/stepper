unit ModuleMIDINote;

interface

uses
  XML_Document,
  XML_Node,
  Document,
  EngineTypes,
  ValueTypes;

type
  TModuleMIDINote = class(TModule)
    private
      FLastValue : TValue;
      FCurrentNote : Integer;

      FLastTick : TTimestamp;


      FInputBaseNote : TInput;
      FInputPitchA : TInput;
      FInputPitchB : TInput;
      FInputPitchC : TInput;
      FInputGate : TInput;
      FInputGateThreshold : TInput;
      FInputVelocity : TInput;

    public
      constructor Create(Document : TDocument; Group : TGroup); override;
      destructor Destroy; override;

      procedure Clear; override;

      procedure Reset; override;
      procedure Process(Frame : PEngineFrame); override;

      procedure SaveToXML(Document : TXMLDocument; BaseNode : TXMLNode); override;
      procedure LoadFromXML(Document : TXMLDocument; BaseNode : TXMLNode); override;

    private
      procedure SendNoteOn(Pitch, Velocity : TValue);
      procedure SendNoteOff;

      function  GetIsNoteOn : Boolean;

    public
      property  InputBaseNote : TInput read FInputBaseNote;
      property  InputPitchA : TInput read FInputPitchA;
      property  InputPitchB : TInput read FInputPitchB;
      property  InputPitchC : TInput read FInputPitchC;
      property  InputGate : TInput read FInputGate;
      property  InputGateThreshold : TInput read FInputGateThreshold;
      property  InputVelocity : TInput read FInputVelocity;

      property  IsNoteOn : Boolean read GetIsNoteOn;

  end;

implementation

uses
  UIModuleMIDINote,
  ModuleFactory,
  Engine,
  EngineConsts,
  Device,
  MidiPort;

constructor TModuleMIDINote.Create(Document : TDocument; Group : TGroup);
begin
  inherited Create(Document, Group);

  FName := 'MIDI Note';
  FInputBaseNote := CreateInput('Base Note', vtNote, [ioCanEdit], 60.0);
  FInputPitchA := CreateInput('Pitch A', vtIntValue, [ioCanConnect, ioCanEdit], 0.0);
  FInputPitchB := CreateInput('Pitch B', vtIntValue, [ioCanConnect, ioCanEdit], 0.0);
  FInputPitchC := CreateInput('Pitch C', vtIntValue, [ioCanConnect, ioCanEdit], 0.0);
  FInputGate := CreateInput('Gate', vtValue, [ioCanConnect, ioCanEdit], 0.0);
  FInputGateThreshold := CreateInput('Gate Threshold', vtValue, [ioCanConnect, ioCanEdit], 0.0);
  FInputVelocity := CreateInput('Velocity', vt0_1, [ioCanConnect, ioCanEdit], 1.0);

  Reset;
end;

destructor TModuleMIDINote.Destroy;
begin
  inherited Destroy;
end;

procedure TModuleMIDINote.Clear;
begin
  inherited Clear;
end;

procedure TModuleMIDINote.Reset;
begin
  FLastValue := 0.0;
  FCurrentNote := -1;
  
  FLastTick := 0.0;
end;

procedure TModuleMIDINote.Process(Frame : PEngineFrame);
var
  NewValue : TValue;
  Pitch : TValue;
  Velocity : TValue;
begin
  NewValue := FInputGate.CurrentValue;

  if FCurrentNote < 0 then
  begin
    if NewValue > FInputGateThreshold.CurrentValue then
    begin
      Pitch := FInputBaseNote.CurrentValue;
      Pitch := Pitch + FInputPitchA.CurrentValue;
      Pitch := Pitch + FInputPitchB.CurrentValue;
      Pitch := Pitch + FInputPitchC.CurrentValue;
      Velocity := FInputVelocity.CurrentValue;
      SendNoteOn(Pitch, Velocity);
    end;
  end else
  begin
    if NewValue <= FInputGateThreshold.CurrentValue then
      SendNoteOff;
  end;
end;

procedure TModuleMIDINote.SaveToXML(Document : TXMLDocument; BaseNode : TXMLNode);
begin
  inherited SaveToXML(Document, BaseNode);
end;

procedure TModuleMIDINote.LoadFromXML(Document : TXMLDocument; BaseNode : TXMLNode);
begin
  inherited LoadFromXML(Document, BaseNode);
end;

procedure TModuleMIDINote.SendNoteOn(Pitch, Velocity : TValue);
var
  Event : TMidiEvent;
begin
  if Pitch < 0.0 then Pitch := 0.0;
  if Pitch > 127.0 then Pitch := 127.0;
  FCurrentNote := trunc(Pitch);

  if Velocity < 0.0 then Velocity := 0.0;
  if Velocity > 1.0 then Velocity := 1.0;

  CreateMidiEvent(@Event, etNoteon, FCurrentNote, trunc(Velocity * 127.0));

  TDeviceManager.GetInstance.Output[0].SendEvent(@Event);
end;

procedure TModuleMIDINote.SendNoteOff;
var
  Event : TMidiEvent;
begin
  if FCurrentNote < 0 then Exit;

  CreateMidiEvent(@Event, etNoteOff, FCurrentNote, 64);

  TDeviceManager.GetInstance.Output[0].SendEvent(@Event);

  FCurrentNote := -1;
end;

function  TModuleMIDINote.GetIsNoteOn : Boolean;
begin
  Result := FCurrentNote >= 0;
end;

initialization
begin
  TModuleFactory.GetInstance.RegisterClass(TModuleMIDINote, TUIModuleMIDINote, 'MIDI Note');
end;

end.
