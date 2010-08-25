unit EngineTypes;

interface

type
  TTimestamp = Single;
  TBeat = Longword;

  PValue = ^TValue;
  TValue = Single;

  PEngineFrame = ^TEngineFrame;
  TEngineFrame = record
    Timestamp : TTimestamp;  // Time in seconds
  end;

implementation

uses
  Engine;

end.
