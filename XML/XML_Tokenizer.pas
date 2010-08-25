(*******************************************************************************
 *
 * Description:
 * This unit implements a tokenizer class to tokenize an XML string.
 *
 * Author:
 * Simon Kallweit, Kallweit Electronics
 *
 * ToDo:
 * Nothing
 *
 * History:
 * 03.11.2003 - SK - Initial release
 *
 ******************************************************************************)

unit XML_Tokenizer;

interface

uses
  Classes,
  XML_Node;

type
  (** Token types in the XML structure *)
  TTokenTypXML = (ttSpecial, ttStart, ttEnd, ttStartEnd, ttText);

  (**
   * This class implements a tokenizer for XML strings.
   *)
  TXMLTokenizer = class(TObject)
    private
      FValueList : TStringList;

    public
      constructor Create;
      destructor Destroy; override;

      procedure TokenizeXML(Text : String; TokenList : TStringList);
      function  GetTokenTypXML(Token : String) : TTokenTypXML;

      function  ExtractName(Text : String) : String;
      procedure ExtractAttributes(Text : String; AttributeList : TXMLAttributeList);

  end;

implementation

uses
  SysUtils;

(**
 * Description:
 * Standard constructor.
 *)
constructor TXMLTokenizer.Create;
begin
  inherited Create;

  FValueList := TStringList.Create;
end;

(**
 * Description:
 * Standard destructor.
 *)
destructor TXMLTokenizer.Destroy;
begin
  FValueList.Destroy;

  inherited Destroy;
end;

(**
 * Description:
 * This method is used to tokenize an XML string. It returns the tags in the
 * XML as a list of strings. A tag can be one of the following:
 *
 * Special  : <?xml ... ?>
 * Start    : <type ... >
 * End      : </type>
 * StartEnd : <type ... />
 * Text     : just plain text
 *
 * Parameters:
 * Text - String containing the XML document
 * TokenList - String list to add the tokens to
 *)
procedure TXMLTokenizer.TokenizeXML(Text : String; TokenList : TStringList);

  procedure AddToken(Token : String);
  begin
    Token := Trim(Token);
    if Token <> '' then TokenList.Add(Token);
  end;

var
  Index : Integer;
  Character : Char;
  StartIndex : Integer;
  Token : String;
begin
  StartIndex := 1;

  // Loop through characters in the string
  for Index := 1 to Length(Text) do
  begin
    // Fetch a character from the string
    Character := Text[Index];

    // Check for token splitting
    if Character = '<' then
    begin
      if StartIndex < Index then
      begin
        Token := Copy(Text, StartIndex, Index - StartIndex);
        AddToken(Token);
      end;
      StartIndex := Index;
    end else
    if Character = '>' then
    begin
      if StartIndex < Index then
      begin
        Token := Copy(Text, StartIndex, Index - StartIndex + 1);
        AddToken(Token);
      end;
      StartIndex := Index + 1;
    end;
  end;
end;

(**
 * Description:
 * This method is used to return the type of an XML token. The following types
 * are supported:
 *
 * ttSpecial  : <?xml ... ?>
 * ttStart    : <type ... >
 * ttEnd      : </type>
 * ttStartEnd : <type ... />
 * ttText     : just plain text
 *
 * Parameters:
 * Token - Token to get type from
 *
 * Returns:
 * Returns the type of the given token
 *)
function  TXMLTokenizer.GetTokenTypXML(Token : String) : TTokenTypXML;
var
  Len : Integer;
begin
  Result := ttText;

  Len := Length(Token);

  if Len > 0 then
  begin
    if Token[1] = '<' then
    begin
      if Len > 1 then
      begin
        if Token[2] = '?' then
        begin
          Result := ttSpecial;
        end else
        if Token[2] = '/' then
        begin
          Result := ttEnd;
        end else
        if Token[Len - 1] = '/' then
        begin
          Result := ttStartEnd;
        end else
        begin
          Result := ttStart;
        end;
      end;
    end;
  end;
end;

(**
 * Description:
 * This method is used to extract the name of a XML node.
 *
 * Parameters:
 * Text - Text to extract name from
 *
 * Returns:
 * Returns the name of the node.
 *)
function  TXMLTokenizer.ExtractName(Text : String) : String;
var
  Index : Integer;
begin
  Result := '';
  Index := Pos(' ', Text);

  if Index = 0 then
    Text := Copy(Text, 2, Length(Text) - 2)
  else
    Text := Copy(Text, 2, Pos(' ', Text) - 2);

  if (Text[1] = '/') or (Text[1] = '?') then Delete(Text, 1, 1);
  if (Text[Length(Text)] = '/') then Delete(Text, Length(Text), 1);

  Result := Text;
end;

(**
 * Description:
 * This method is used to extract the attributes of a XML node.
 *
 * Parameters:
 * Text - Text to extract attributes from
 * AttributeList - List of attributes to add to
 *)
procedure TXMLTokenizer.ExtractAttributes(Text : String; AttributeList : TXMLAttributeList);
type
  TScanState = (ssIdle, ssFound1, ssFound2, ssFound3);
var
  Index : Integer;
  Str : String;
  P : Integer;
  Name, Value : String;

  Character : Char;
  StartIndex : Integer;
  ScanState : TScanState;

begin
  FValueList.Clear;

  ScanState := ssIdle;
  StartIndex := 0;
  for Index := 1 to Length(Text) do
  begin
    Character := Text[Index];

    case ScanState of
      ssIdle :
        begin
          if Character = ' ' then StartIndex := Index else
            if (StartIndex > 0) and (Character = '=') then ScanState := ssFound1;
        end;
      ssFound1 :
        begin
          if Character = '"' then ScanState := ssFound2;
        end;
      ssFound2 :
        begin
          if Character = '"' then
          begin
            FValueList.Add(Copy(Text, StartIndex + 1, Index - StartIndex));
            ScanState := ssIdle;
            StartIndex := Index + 1; 
          end;
        end;
    end;
  end;

  for Index := 0 to FValueList.Count - 1 do
  begin
    Str := FValueList[Index];
    P := Pos('=', Str);
    if P = 0 then Continue;
    Name := Copy(Str, 1, P - 1);
    Value := '';

    P := Pos('"', Str);
    if P > 0 then
    begin
      Delete(Str, 1, P);
      P := Pos('"', Str);
      if P > 0 then Value := Copy(Str, 1, P - 1);
    end;

    AttributeList.Add(Name, Value);
  end;
end;

end.
