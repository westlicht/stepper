(*******************************************************************************
 *
 * Description:
 * This unit implements a extremely simple XML parser/writer. It represents the
 * XML document in a simple tree hirarchy.
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

unit XML_Document;

interface

uses
  Classes,
  XML_Node;

type
  (**
   * This class implements a simple XML parser/writer. It represents the XML
   * document as a simple tree hirarchy.
   *)
  TXMLDocument = class(TObject)
    private
      FRootNode : TXMLNode;

    public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;
      procedure New;

      procedure LoadFromFile(FileName : String);
      procedure LoadFromStream(Stream : TStream);
      procedure LoadFromString(Text : String);

      procedure SaveToFile(FileName : String);
      procedure SaveToStream(Stream : TStream);
      function  SaveToString : String;

      function  GetNode(Name : String) : TXMLNode;

      function  PrintDebugTree : String;

    private
      procedure ParseXML(XML : String);
      function  WriteXML : String;

    public
      property  RootNode : TXMLNode read FRootNode;

  end;

implementation

uses
  XML_Tokenizer;

(**
 * Description:
 * Standard constructor.
 *)
constructor TXMLDocument.Create;
begin
  inherited Create;

  FRootNode := TXMLNode.Create;
  FRootNode.Name := 'RootNode';
end;

(**
 * Description:
 * Standard destructor.
 *)
destructor TXMLDocument.Destroy;
begin
  Clear;

  FRootNode.Destroy;
  
  inherited Destroy;
end;

(**
 * Description:
 * This method is used to clear the XML document.
 *)
procedure TXMLDocument.Clear;
begin
  FRootNode.Clear;
end;

(**
 * Description:
 * This method is used to create a new XML document. It creates the special XML
 * tag with version 1.0.
 *)
procedure TXMLDocument.New;
var
  Node : TXMLNode;
begin
  Clear;
  Node := FRootNode.CreateChild;
  Node.Special := true;
  Node.Name := 'xml';
  Node.AttributeList.Add('version', '1.0');
end;

(**
 * Description:
 * This method is used to load an XML document from a file.
 *
 * Parameters:
 * FileName - Filename of the XML document to load
 *)
procedure TXMLDocument.LoadFromFile(FileName : String);
var
  Stream : TMemoryStream;
begin
  Stream := nil;
  try
    Stream := TMemoryStream.Create;
    Stream.LoadFromFile(FileName);
    LoadFromStream(Stream);
  finally
    Stream.Destroy;
  end;
end;

(**
 * Description:
 * This method is used to load an XML document from a stream.
 *
 * Parameters:
 * Stream - Stream to load XML document from
 *)
procedure TXMLDocument.LoadFromStream(Stream : TStream);
var
  Text : String;
begin
  try
    Stream.Position := 0;
    SetLength(Text, Stream.Size);
    Stream.ReadBuffer(Text[1], Stream.Size);
    LoadFromString(Text);
  finally
  end;
end;

(**
 * Description:
 * This method is used to load an XML document from a string.
 *
 * Parameters:
 * Text - String to load XML document from
 *)
procedure TXMLDocument.LoadFromString(Text : String);
begin
  Clear;
  ParseXML(Text);
end;

(**
 * Description:
 * This method is used to save the XML document to a file.
 *
 * Parameters:
 * FileName - Filename to save XML document to
 *)
procedure TXMLDocument.SaveToFile(FileName : String);
var
  Stream : TMemoryStream;
begin
  Stream := nil;
  try
    Stream := TMemoryStream.Create;
    SaveToStream(Stream);
    Stream.SaveToFile(FileName);
  finally
    Stream.Destroy;
  end;
end;

(**
 * Description:
 * This method is used to save the XML document to a stream.
 *
 * Parameters:
 * Stream - Stream to save XML document to
 *)
procedure TXMLDocument.SaveToStream(Stream : TStream);
var
  Text : String;
begin
  try
    Text := SaveToString;
    Stream.Write(Text[1], Length(Text));
  finally
  end;
end;

(**
 * Description:
 * This method is used to save the XML document to a string.
 *
 * Returns:
 * Returns the XML document as a string.
 *)
function  TXMLDocument.SaveToString : String;
begin
  Result := WriteXML;
end;

(**
 * Description:
 * This method is used to get a node by providing it's name in the hirarchy.
 * The name is in the following format:
 *
 * node1.node2.node3
 *
 * Parameters:
 * Name - Absolute name of the node
 *
 * Returns:
 * Returns the node or nil, if none was found.
 *)
function  TXMLDocument.GetNode(Name : String) : TXMLNode;
begin
  Result := FRootNode.GetNode(Name);
end;

(**
 * Description:
 * This method is used to print a debug string showing the structure of the
 * XML document in a tree like form.
 *
 * Returns:
 * Returns a debug string.
 *)
function  TXMLDocument.PrintDebugTree : String;

  function PrintNode(Tab : Integer; Node : TXMLNode) : String;
  var
    Prefix : String;
    Index : Integer;
  begin
    Prefix := ' ';
    for Index := 0 to Tab - 1 do begin Prefix := Prefix + '  '; end;

    Result := Result + Prefix + '+Name - ' + Node.Name + #13 + #10;
    Prefix := Prefix + ' ';
    Result := Result + Prefix + 'Value - ' + Node.Value + #13 + #10;

    if Node.Special then
      Result := Result + Prefix + 'Special - yes' + #13 + #10;

    for Index := 0 to Node.AttributeList.Count - 1 do
      Result := Result + Prefix + Node.AttributeList.Name[Index] + ' = ' + Node.AttributeList.Value[Index] + #13 + #10;

    for Index := 0 to Node.ChildList.Count - 1 do
      Result := Result + PrintNode(Tab + 1, Node.ChildList[Index]);
  end;

begin
  Result := PrintNode(0, FRootNode);  
end;

(**
 * Description:
 * This method is used to parse an XML document from a string.
 *
 * Parameters:
 * XML - String containing the XML
 *)
procedure TXMLDocument.ParseXML(XML : String);
var
  Tokenizer : TXMLTokenizer;
  TokenList : TStringList;
  Index : Integer;
  Token : String;
  TokenTypXML : TTokenTypXML;
  CurrentNode : TXMLNode;
  NewNode : TXMLNode;
begin
  Tokenizer := TXMLTokenizer.Create;
  TokenList := TStringList.Create;

  // Tokenize the XML string
  Tokenizer.TokenizeXML(XML, TokenList);

  CurrentNode := FRootNode;

  // Parse structure
  for Index := 0 to TokenList.Count - 1 do
  begin
    // Get next token from the token list
    Token := TokenList[Index];

    // Get the type of the current token
    TokenTypXML := Tokenizer.GetTokenTypXML(Token);

    case TokenTypXML of
      ttSpecial :
        begin
          // Create a new node
          NewNode := TXMLNode.Create;
          NewNode.Name := Tokenizer.ExtractName(Token);
          NewNode.Special := true;

          // Extract attributes
          Tokenizer.ExtractAttributes(Token, NewNode.AttributeList);

          // Add node as childnode
          CurrentNode.AddChild(NewNode);
        end;
      ttStart :
        begin
          // Create a new node
          NewNode := TXMLNode.Create;
          NewNode.Name := Tokenizer.ExtractName(Token);

          // Extract attributes
          Tokenizer.ExtractAttributes(Token, NewNode.AttributeList);

          // Add node as childnode
          CurrentNode.AddChild(NewNode);
          CurrentNode := NewNode;
        end;
      ttEnd :
        begin
          // Step to parent of current node
          if Tokenizer.ExtractName(Token) <> CurrentNode.Name then Break;
          CurrentNode := CurrentNode.Parent;
          if not Assigned(CurrentNode) then Break;
        end;
      ttStartEnd :
        begin
          // Create a new node
          NewNode := TXMLNode.Create;
          NewNode.Name := Tokenizer.ExtractName(Token);

          // Extract attributes
          Tokenizer.ExtractAttributes(Token, NewNode.AttributeList);

          // Add node as childnode
          CurrentNode.AddChild(NewNode);
        end;
      ttText :
        begin
          // Assign value to the current node
          CurrentNode.Value := Token;
        end;
    end;
  end;

  Tokenizer.Destroy;
  TokenList.Destroy;
end;

(**
 * Description:
 * This method is used to write the XML document to a string. 
 *
 * Returns:
 * Returns the XML document as a string.
 *)
function  TXMLDocument.WriteXML : String;

  function WriteNode(Tab : Integer; Node : TXMLNode) : String;
  var
    Index : Integer;
    Prefix : String;
    Str : String;
  begin
    Result := '';
    
    // Don't export the root node
    if Tab >= 0 then
    begin
      // Sum up a prefix with spaces
      Prefix := '';
      for Index := 0 to Tab - 1 do Prefix := Prefix + '  ';

      if ((Node.Value = '') and (Node.ChildList.Count < 1)) or (Node.Special) then
      begin
        // Export a compact node
        Str := Prefix + '<';
        if Node.Special then Str := Str + '?';
        Str := Str + Node.Name;
        if Node.AttributeList.Count > 0 then
        begin
          for Index := 0 to Node.AttributeList.Count - 1 do
            Str := Str + ' ' + Node.AttributeList.Name[Index] + '="' + Node.AttributeList.Value[Index] + '"';
        end;
        if Node.Special then Str := Str + '?>' else Str := Str + '/>';

        // Recursivly write nodes
        if Node.ChildList.Count > 0 then
        begin
          Str := Str + #13 + #10;
          for Index := 0 to Node.ChildList.Count - 1 do
            Str := Str + WriteNode(Tab + 1, Node.ChildList[Index]);
        end;
      end else
      begin
        // Export a non-compact node
        Str := Prefix + '<';
        if Node.Special then Str := Str + '?';
        Str := Str + Node.Name;
        if Node.AttributeList.Count > 0 then
        begin
          for Index := 0 to Node.AttributeList.Count - 1 do
            Str := Str + ' ' + Node.AttributeList.Name[Index] + '="' + Node.AttributeList.Value[Index] + '"';
        end;
        Str := Str + '>';

        if Node.Value <> '' then
        begin
          Str := Str + Node.Value;
        end else
        begin
          Str := Str + #13 + #10;
          // Recursivly write nodes
          for Index := 0 to Node.ChildList.Count - 1 do
            Str := Str + WriteNode(Tab + 1, Node.ChildList[Index]);
          Str := Str + Prefix;
        end;

        Str := Str + '<';
        if Node.Special then Str := Str + '?';
        Str := Str + '/';
        Str := Str + Node.Name;
        Str := Str + '>';
      end;

      Result := Str + #13 + #10;
    end else
    begin
      // Recursivly write nodes
      for Index := 0 to Node.ChildList.Count - 1 do
        Result := Result + WriteNode(Tab + 1, Node.ChildList[Index]);
    end;
  end;
begin
  Result := WriteNode(-1, FRootNode);
end;

end.
