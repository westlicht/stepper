unit UITypes;

interface

type
  TUIValueDisplayMode = (dmValue, dmNote);

function  UIFormatValue(Value : Byte; DisplayMode : TUIValueDisplayMode) : String;
function  UIValueToNote(Value : Byte) : String;

implementation

uses
  SysUtils;

function  UIFormatValue(Value : Byte; DisplayMode : TUIValueDisplayMode) : String;
begin
  case DisplayMode of
    dmValue : Result := IntToStr(Value);
    dmNote  : Result := UIValueToNote(Value);
  end;
end;

function  UIValueToNote(Value : Byte) : String;
const
  NOTE_TABLE : Array[0..11] of String = ('C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B');
begin
  Result := Format('%s%d', [NOTE_TABLE[Value mod 12], Value div 12 - 1]);  
end;

end.
