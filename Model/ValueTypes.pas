unit ValueTypes;

interface

uses
  Classes,
  EngineTypes;

type
  TValueTyp = (
    vtValue,
    vtIntValue,
    vt0_1,
    vt1_1,
    vt12_12,
    vt24_24,

    vtClock,
    vtClockDiv,
    vtNote,
    vtTempo,

    // Scope types
    vtScopeRange,

    // Sequencer types
    vtSequencerMode,
    vtSequencerValueRange,
    vtSequencerPlayMode

  );

  TScopeRange = (sr0_1, sr1_1, sr12_12, sr24_24);

  TSequencerMode = (smControl, smGate);
  TSequencerValueRange = (vr0_1, vr1_1, vr12_12, vr24_24);
  TSequencerPlayMode = (pmForward, pmBackward, pmPingPong, pmRandom);


  TValueProperties = class(TObject)
    protected
      FValueTyp : TValueTyp;
      FIsEnum : Boolean;
      FMinValue : TValue;
      FMaxValue : TValue;
      FStepSize : TValue;
      FStepSizeFine : TValue;
      FFormatStr : String;
      FNameList : TStringList;

    public
      constructor Create;
      destructor Destroy; override;

      function  ValueToStr(Value : TValue) : String; virtual;
      procedure Quantize(Value : PValue); virtual;
      procedure Clamp(Value : PValue); virtual;

    private
      procedure PrepareEnum(Names : Array of String);

    public
      property  InputTyp : TValueTyp read FValueTyp;
      property  IsEnum : Boolean read FIsEnum;
      property  MinValue : TValue read FMinValue;
      property  MaxValue : TValue read FMaxValue;
      property  StepSize : TValue read FStepSize;
      property  StepSizeFine : TValue read FStepSizeFine;
      property  NameList : TStringList read FNameList;

  end;

  TValueProperties_Value = class(TValueProperties)
    public
      constructor Create;

  end;

  TValueProperties_IntValue = class(TValueProperties)
    public
      constructor Create;

  end;

  TValueProperties_0_1 = class(TValueProperties)
    public
      constructor Create;

  end;

  TValueProperties_1_1 = class(TValueProperties)
    public
      constructor Create;

  end;

  TValueProperties_12_12 = class(TValueProperties)
    public
      constructor Create;

  end;

  TValueProperties_24_24 = class(TValueProperties)
    public
      constructor Create;

  end;

  TValueProperties_Clock = class(TValueProperties)
    public
      constructor Create;

  end;

  TValueProperties_ClockDiv = class(TValueProperties)
    public
      constructor Create;

      function  ValueToStr(Value : TValue) : String; override;

  end;

  TValueProperties_Note = class(TValueProperties)
    public
      constructor Create;

      function  ValueToStr(Value : TValue) : String; override;

  end;

  TValueProperties_Tempo = class(TValueProperties)
    public
      constructor Create;

  end;

  TValueProperties_ScopeRange = class(TValueProperties)
    public
      constructor Create;

  end;

  TValueProperties_SequencerMode = class(TValueProperties)
    public
      constructor Create;

  end;

  TValueProperties_SequencerValueRange = class(TValueProperties)
    public
      constructor Create;

  end;

  TValueProperties_SequencerPlayMode = class(TValueProperties)
    public
      constructor Create;

  end;





  TValuePropertiesManager = class(TObject)
    private
      FValuePropertiesList : TList;

    public
      constructor Create;
      destructor Destroy; override;

      function  GetValueProperties(ValueTyp : TValueTyp) : TValueProperties;

      class function GetInstance : TValuePropertiesManager;

  end;

implementation

uses
  SysUtils;

var
  _ValuePropertiesManager : TValuePropertiesManager;

////////////////////////////////////////////////////////////////////////////////
// TValueProperties                                                           //
////////////////////////////////////////////////////////////////////////////////

constructor TValueProperties.Create;
begin
  inherited Create;

  FIsEnum := false;
  FMinValue := 0.0;
  FMaxValue := 0.0;
  FStepSize := 1.0;
  FStepSizeFine := 1.0;
  FFormatStr := '%f';
  FNameList := TStringList.Create;
end;

destructor TValueProperties.Destroy;
begin
  FNameList.Destroy;

  inherited Destroy;
end;

function  TValueProperties.ValueToStr(Value : TValue) : String;
begin
  if FIsEnum then
    Result := FNameList[trunc(Value)]
  else
    Result := Format(FFormatStr, [Value]);
end;

procedure TValueProperties.Quantize(Value : PValue);
begin
  Value^ := trunc(Value^ / FStepSizeFine) * FStepSizeFine;
end;

procedure TValueProperties.Clamp(Value : PValue);
begin
  if Value^ < FMinValue then Value^ := FMinValue;
  if Value^ > FMaxValue then Value^ := FMaxValue;
end;

procedure TValueProperties.PrepareEnum(Names : Array of String);
var
  Index : Integer;
begin
  for Index := 0 to High(Names) do
    FNameList.Add(Names[Index]);

  FIsEnum := true;
  FMinValue := 0.0;
  FMaxValue := FNameList.Count - 1;
  FStepSize := 1.0;
  FStepSizeFine := 1.0;
end;

////////////////////////////////////////////////////////////////////////////////
// TValueProperties_Value                                                     //
////////////////////////////////////////////////////////////////////////////////

constructor TValueProperties_Value.Create;
begin
  inherited Create;

  FValueTyp := vtValue;
  FMinValue := -1000.0;
  FMaxValue := 1000.0;
  FStepSize := 0.01;
  FStepSizeFine := 0.001;
  FFormatStr := '%.2f';
end;

////////////////////////////////////////////////////////////////////////////////
// TValueProperties_IntValue                                                  //
////////////////////////////////////////////////////////////////////////////////

constructor TValueProperties_IntValue.Create;
begin
  inherited Create;

  FValueTyp := vtIntValue;
  FMinValue := -1000.0;
  FMaxValue := 1000.0;
  FStepSize := 1.0;
  FStepSizeFine := 1.0;
  FFormatStr := '%.0f';
end;

////////////////////////////////////////////////////////////////////////////////
// TValueProperties_0_1                                                       //
////////////////////////////////////////////////////////////////////////////////

constructor TValueProperties_0_1.Create;
begin
  inherited Create;

  FValueTyp := vt0_1;
  FMinValue := 0.0;
  FMaxValue := 1.0;
  FStepSize := 0.01;
  FStepSizeFine := 0.001;
  FFormatStr := '%.2f';
end;

////////////////////////////////////////////////////////////////////////////////
// TValueProperties_1_1                                                       //
////////////////////////////////////////////////////////////////////////////////

constructor TValueProperties_1_1.Create;
begin
  inherited Create;

  FValueTyp := vt1_1;
  FMinValue := -1.0;
  FMaxValue := 1.0;
  FStepSize := 0.01;
  FStepSizeFine := 0.001;
  FFormatStr := '%.2f';
end;

////////////////////////////////////////////////////////////////////////////////
// TValueProperties_12_12                                                     //
////////////////////////////////////////////////////////////////////////////////

constructor TValueProperties_12_12.Create;
begin
  inherited Create;

  FValueTyp := vt12_12;
  FMinValue := -12.0;
  FMaxValue := 12.0;
  FStepSize := 1.0;
  FStepSizeFine := 1.0;
  FFormatStr := '%.0f';
end;

////////////////////////////////////////////////////////////////////////////////
// TValueProperties_24_24                                                     //
////////////////////////////////////////////////////////////////////////////////

constructor TValueProperties_24_24.Create;
begin
  inherited Create;

  FValueTyp := vt24_24;
  FMinValue := -24.0;
  FMaxValue := 24.0;
  FStepSize := 1.0;
  FStepSizeFine := 1.0;
  FFormatStr := '%.0f';
end;

////////////////////////////////////////////////////////////////////////////////
// TValueProperties_Clock                                                     //
////////////////////////////////////////////////////////////////////////////////

constructor TValueProperties_Clock.Create;
begin
  inherited Create;

  FValueTyp := vtClock;
  FMinValue := 0.0;
  FMaxValue := 1.0;
  FStepSize := 1.0;
  FStepSizeFine := 1.0;
  FFormatStr := '%.2f';
end;

////////////////////////////////////////////////////////////////////////////////
// TValueProperties_ClockDiv                                                  //
////////////////////////////////////////////////////////////////////////////////

constructor TValueProperties_ClockDiv.Create;
begin
  inherited Create;

  FValueTyp := vtClockDiv;
  FMinValue := 1.0;
  FMaxValue := 32.0;
  FStepSize := 1.0;
  FStepSizeFine := 1.0;
  FFormatStr := '%.0f';
end;

function  TValueProperties_ClockDiv.ValueToStr(Value : TValue) : String;
const
  CLOCKDIV_NAME : Array[0..31] of String = (
    '1/32', '1/16', '', '1/8', '', '', '', '1/4',
    '', '', '', '', '', '', '', '1/2',
    '', '', '', '', '', '', '', '',
    '', '', '', '', '', '', '', '1/1'
  );
var
  ClockDiv : Integer;
begin
  ClockDiv := trunc(Value);
  Result := IntToStr(ClockDiv);
  if CLOCKDIV_NAME[ClockDiv - 1] <> '' then
    Result := Result + ' (' + CLOCKDIV_NAME[ClockDiv - 1] + ')';
end;

////////////////////////////////////////////////////////////////////////////////
// TValueProperties_Note                                                      //
////////////////////////////////////////////////////////////////////////////////

constructor TValueProperties_Note.Create;
begin
  inherited Create;

  FValueTyp := vtNote;
  FMinValue := 0.0;
  FMaxValue := 127.0;
  FStepSize := 1.0;
  FStepSizeFine := 1.0;
  FFormatStr := '%.0f';
end;

function  TValueProperties_Note.ValueToStr(Value : TValue) : String;
const
  NOTE_NAME : Array[0..11] of String =
    ('C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B');
var
  Note : Integer;
begin
  Note := trunc(Value);
  Result := NOTE_NAME[(Note - 60) mod 12] + IntToStr((Note - 60) div 12 + 1);
end;

////////////////////////////////////////////////////////////////////////////////
// TValueProperties_Tempo                                                     //
////////////////////////////////////////////////////////////////////////////////

constructor TValueProperties_Tempo.Create;
begin
  inherited Create;

  FValueTyp := vtTempo;
  FMinValue := 1.0;
  FMaxValue := 200.0;
  FStepSize := 0.1;
  FStepSizeFine := 0.01;
  FFormatStr := '%.2f bpm';
end;

////////////////////////////////////////////////////////////////////////////////
// TValueProperties_ScopeRange                                                //
////////////////////////////////////////////////////////////////////////////////

constructor TValueProperties_ScopeRange.Create;
begin
  inherited Create;

  FValueTyp := vtScopeRange;
  PrepareEnum([
    '0..1',
    '-1..1',
    '-12..12',
    '-24..24'
  ]);
end;

////////////////////////////////////////////////////////////////////////////////
// TValueProperties_SequencerMode                                             //
////////////////////////////////////////////////////////////////////////////////

constructor TValueProperties_SequencerMode.Create;
begin
  inherited Create;

  FValueTyp := vtSequencerMode;
  PrepareEnum([
    'Control',
    'Gate'
  ]);
end;

////////////////////////////////////////////////////////////////////////////////
// TValueProperties_SequencerValueRange                                       //
////////////////////////////////////////////////////////////////////////////////

constructor TValueProperties_SequencerValueRange.Create;
begin
  inherited Create;

  FValueTyp := vtSequencerValueRange;
  PrepareEnum([
    '0..1',
    '-1..1',
    '-12..12',
    '-24..24'
  ]);
end;

////////////////////////////////////////////////////////////////////////////////
// TValueProperties_SequencerPlayMode                                         //
////////////////////////////////////////////////////////////////////////////////

constructor TValueProperties_SequencerPlayMode.Create;
begin
  inherited Create;

  FValueTyp := vtSequencerPlayMode;
  PrepareEnum([
    'Forward',
    'Backward',
    'PingPong',
    'Random'
  ]);
end;

////////////////////////////////////////////////////////////////////////////////
// TValuePropertiesManager                                                    //
////////////////////////////////////////////////////////////////////////////////

constructor TValuePropertiesManager.Create;
begin
  inherited Create;

  FValuePropertiesList := TList.Create;

  FValuePropertiesList.Add(TValueProperties_Value.Create);
  FValuePropertiesList.Add(TValueProperties_IntValue.Create);
  FValuePropertiesList.Add(TValueProperties_0_1.Create);
  FValuePropertiesList.Add(TValueProperties_1_1.Create);
  FValuePropertiesList.Add(TValueProperties_12_12.Create);
  FValuePropertiesList.Add(TValueProperties_24_24.Create);
  FValuePropertiesList.Add(TValueProperties_Clock.Create);
  FValuePropertiesList.Add(TValueProperties_ClockDiv.Create);
  FValuePropertiesList.Add(TValueProperties_Note.Create);
  FValuePropertiesList.Add(TValueProperties_Tempo.Create);
  FValuePropertiesList.Add(TValueProperties_ScopeRange.Create);
  FValuePropertiesList.Add(TValueProperties_SequencerMode.Create);
  FValuePropertiesList.Add(TValueProperties_SequencerValueRange.Create);
  FValuePropertiesList.Add(TValueProperties_SequencerPlayMode.Create);
end;

destructor TValuePropertiesManager.Destroy;
var
  Index : Integer;
begin
  for Index := 0 to FValuePropertiesList.Count - 1 do
    TValueProperties(FValuePropertiesList[Index]).Destroy;

  inherited Destroy;
end;

function  TValuePropertiesManager.GetValueProperties(ValueTyp : TValueTyp) : TValueProperties;
var
  Index : Integer;
begin
  for Index := 0 to FValuePropertiesList.Count - 1 do
  begin
    Result := FValuePropertiesList[Index];
    if Result.FValueTyp = ValueTyp then Exit;
  end;

  Result := nil;
end;

class function TValuePropertiesManager.GetInstance : TValuePropertiesManager;
begin
  if not Assigned(_ValuePropertiesManager) then
    _ValuePropertiesManager := TValuePropertiesManager.Create;
  Result := _ValuePropertiesManager;
end;

end.
