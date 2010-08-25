unit ModuleClock;

interface

uses
  XML_Document,
  XML_Node,
  Document,
  EngineTypes,
  ValueTypes;

type
  TModuleClock = class(TModule)
    private
      FLastTick : TTimestamp;
      FInputBPM : TInput;
      FOutputClock : TOutput;

    public
      constructor Create(Document : TDocument; Group : TGroup); override;
      destructor Destroy; override;

      procedure Clear; override;

      procedure Reset; override;
      procedure Process(Frame : PEngineFrame); override;

      procedure SaveToXML(Document : TXMLDocument; BaseNode : TXMLNode); override;
      procedure LoadFromXML(Document : TXMLDocument; BaseNode : TXMLNode); override;

    public
      property  InputBPM : TInput read FInputBPM;
      property  OutputClock : TOutput read FOutputClock;

  end;

implementation

uses
  UIModuleClock,
  ModuleFactory,
  Engine,
  EngineConsts;

constructor TModuleClock.Create(Document : TDocument; Group : TGroup);
begin
  inherited Create(Document, Group);

  FName := 'Clock';
  FInputBPM := CreateInput('Tempo', vtTempo, [ioCanConnect, ioCanEdit, ioClamp], 120.0);
  FOutputClock := CreateOutput('Clock', vtClock, 0.0);

  Reset;
end;

destructor TModuleClock.Destroy;
begin
  inherited Destroy;
end;

procedure TModuleClock.Clear;
begin
  inherited Clear;
end;

procedure TModuleClock.Reset;
begin
  FLastTick := 0.0;
end;
                           
procedure TModuleClock.Process(Frame : PEngineFrame);
var
  BPM : TValue;
  TickLength : TValue;
begin
  BPM := FInputBPM.CurrentValue;
  TickLength := 60.0 / (BPM * ENGINE_BASE_MEASURE);

  while (Frame^.Timestamp - FLastTick) >= TickLength do
    FLastTick := FLastTick + TickLength;

  // Output a falling sawtooth with range 0..1
  FOutputClock.Value := (Frame^.Timestamp - FLastTick) / TickLength;
end;

procedure TModuleClock.SaveToXML(Document : TXMLDocument; BaseNode : TXMLNode);
begin
  inherited SaveToXML(Document, BaseNode);
end;

procedure TModuleClock.LoadFromXML(Document : TXMLDocument; BaseNode : TXMLNode);
begin
  inherited LoadFromXML(Document, BaseNode);
end;

initialization
begin
  TModuleFactory.GetInstance.RegisterClass(TModuleClock, TUIModuleClock, 'Clock');
end;

end.
