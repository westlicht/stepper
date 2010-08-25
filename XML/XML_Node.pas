(*******************************************************************************
 *
 * Description:
 * This unit implements a class that represents an XML node.
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

unit XML_Node;

interface

uses
  Classes;

type
  (**
   * This class implements a list of attributes for a XML node. The list stores
   * name:value pairs.
   *)
  TXMLAttributeList = class(TObject)
    private
      FNameList : TStringList;
      FValueList : TStringList;

    public
      constructor Create;
      destructor Destroy; override;

      procedure Assign(Source : TXMLAttributeList);

      procedure Clear;
      procedure Add(Name, Value : String);

    private
      function  GetIndexByName(Name : String) : Integer;

      function  GetCount : Integer;
      function  GetName(Index : Integer) : String;
      procedure SetName(Index : Integer; Name : String);
      function  GetValue(Index : Integer) : String;
      procedure SetValue(Index : Integer; Value : String);
      function  GetValueByName(Name : String) : String;
      procedure SetValueByName(Name : String; Value : String);

    public
      property  Count : Integer read GetCount;
      property  Name[Index : Integer] : String read GetName write SetName;
      property  Value[Index : Integer] : String read GetValue write SetValue;
      property  ValueByName[Name : String] : String read GetValueByName write SetValueByName;

  end;

  (**
   * This class implements a single node in the XML hirarchy.
   *)
  TXMLNode = class(TObject)
    private
      FName : String;
      FValue : String;
      FSpecial : Boolean;
      FParent : TXMLNode;
      FChildList : TList;
      FAttributeList : TXMLAttributeList;

    public
      constructor Create;
      destructor Destroy; override;

      procedure Assign(Source : TXMLNode);

      procedure AddChild(Node : TXMLNode);
      function  CreateChild : TXMLNode;
      procedure DestroyChild(Child : TXMLNode);
      procedure Clear;

      function  GetNode(Name : String) : TXMLNode;

    public
      property  Name : String read FName write FName;
      property  Value : String read FValue write FValue;
      property  Special : Boolean read FSpecial write FSpecial;
      property  Parent : TXMLNode read FParent write FParent;
      property  ChildList : TList read FChildList;
      property  AttributeList : TXMLAttributeList read FAttributeList;

  end;

implementation

////////////////////////////////////////////////////////////////////////////////
// TXMLAttributeList                                                          //
////////////////////////////////////////////////////////////////////////////////

(**
 * Description:
 * Standard constructor.
 *)
constructor TXMLAttributeList.Create;
begin
  inherited Create;

  FNameList := TStringList.Create;
  FValueList := TStringList.Create;
end;

(**
 * Description:
 * Standard destructor.
 *)
destructor TXMLAttributeList.Destroy;
begin
  FNameList.Destroy;
  FValueList.Destroy;

  inherited Destroy;
end;

(**
 * Description:
 * This method is used to copy the content of an attribute list to this list.
 *)
procedure TXMLAttributeList.Assign(Source : TXMLAttributeList);
begin
  Clear;
  FNameList.Assign(Source.FNameList);
  FValueList.Assign(Source.FValueList);
end;

(**
 * Description:
 * This method is used to clear the attribute list.
 *)
procedure TXMLAttributeList.Clear;
begin
  FNameList.Clear;
  FValueList.Clear;
end;

(**
 * Description:
 * This method is used to add a new attribute to the list.
 *
 * Parameters:
 * Name - Name of the attribute
 * Value - Value of the attribute
 *)
procedure TXMLAttributeList.Add(Name, Value : String);
begin
  FNameList.Add(Name);
  FValueList.Add(Value);
end;

function  TXMLAttributeList.GetIndexByName(Name : String) : Integer;
var
  Index : Integer;
begin
  Result := -1;
  for Index := 0 to FNameList.Count - 1 do
    if FNameList[Index] = Name then
    begin
      Result := Index;
      Break;
    end;
end;

function  TXMLAttributeList.GetCount : Integer;
begin
  Result := FNameList.Count;
end;

function  TXMLAttributeList.GetName(Index : Integer) : String;
begin
  Result := FNameList[Index];
end;

procedure TXMLAttributeList.SetName(Index : Integer; Name : String);
begin
  FNameList[Index] := Name;
end;

function  TXMLAttributeList.GetValue(Index : Integer) : String;
begin
  Result := FValueList[Index];
end;

procedure TXMLAttributeList.SetValue(Index : Integer; Value : String);
begin
  FValueList[Index] := Value;
end;

function  TXMLAttributeList.GetValueByName(Name : String) : String;
var
  Index : Integer;
begin
  Result := '';
  Index := GetIndexByName(Name);
  if Index >= 0 then Result := FValueList[Index]; 
end;

procedure TXMLAttributeList.SetValueByName(Name : String; Value : String);
var
  Index : Integer;
begin
  Index := GetIndexByName(Name);
  if Index >= 0 then FValueList[Index] := Value;
end;

////////////////////////////////////////////////////////////////////////////////
// TXMLNode                                                                   //
////////////////////////////////////////////////////////////////////////////////

(**
 * Description:
 * Standard constructor.
 *)
constructor TXMLNode.Create;
begin
  inherited Create;

  FName := '';
  FValue := '';
  FSpecial := false;
  FParent := nil;
  FChildList := TList.Create;
  FAttributeList := TXMLAttributeList.Create;
end;

(**
 * Description:
 * Standard destructor.
 *)
destructor TXMLNode.Destroy;
begin
  Clear;

  FChildList.Destroy;
  FAttributeList.Destroy;

  inherited Destroy;
end;

(**
 * Description:
 * This method is used to copy the content of a node to this node. This method
 * does not affect the tree hirarchy. It only replaces the data members of the
 * node object.
 *)
procedure TXMLNode.Assign(Source : TXMLNode);
begin
  FName := Source.FName;
  FValue := Source.FValue;
  FSpecial := Source.FSpecial;
  FAttributeList.Assign(Source.FAttributeList);
end;

(**
 * Description:
 * This method is used to add a new child node to this node. The child node's
 * parent property is automatically set to point to this node.
 *
 * Parameters:
 * Node - Node to add as a child node
 *)
procedure TXMLNode.AddChild(Node : TXMLNode);
begin
  Node.FParent := Self;
  FChildList.Add(Node);
end;

(**
 * Description:
 * This method is used to create a new child node.
 *
 * Returns:
 * Returns the newly created child node.
 *)
function  TXMLNode.CreateChild : TXMLNode;
begin
  Result := TXMLNode.Create;
  AddChild(Result);
end;

(**
 * Description:
 * This method is used to remove and destroy a child node, and all of it's
 * subnodes.
 *
 * Parameters:
 * Child - Child to destroy
 *)
procedure TXMLNode.DestroyChild(Child : TXMLNode);
begin
  FChildList.Remove(Child);
  Child.Destroy;
end;

(**
 * Description:
 * This method is used to clear the node. It destroyes and removes all child
 * nodes.
 *)
procedure TXMLNode.Clear;
var
  Index : Integer;
begin
  for Index := 0 to FChildList.Count - 1 do
  begin
    TXMLNode(FChildList[Index]).Clear;
    TXMLNode(FChildList[Index]).Destroy;
  end;
  FChildList.Clear;
end;

(**
 * Description:
 * This method is used to get a node by providing it's relative name in the node
 * hirarchy. The name is in the following format:
 *
 * node1.node2.node3
 *
 * Parameters:
 * Name - Relative name of the node
 *
 * Returns:
 * Returns the node or nil, if none was found.
 *)
function  TXMLNode.GetNode(Name : String) : TXMLNode;
var
  RemainingName : String;
  Index : Integer;
  Node : TXMLNode;
begin
  Result := nil;

  // Split the name into a leading and remaining part
  RemainingName := '';
  Index := Pos('.', Name);
  if Index > 0 then
  begin
    RemainingName := Copy(Name, Index + 1, Length(Name));
    Name := Copy(Name, 1, Index - 1);
  end;

  // Check the child nodes
  for Index := 0 to FChildList.Count - 1 do
  begin
    Node := FChildList[Index];
    if Node.Name = Name then
    begin
      if RemainingName = '' then
        Result := Node
      else
        Result := Node.GetNode(RemainingName);
        
      Break;
    end;
  end;
end;

end.
