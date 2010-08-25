(*******************************************************************************
 *
 * Description:
 * This unit implements the network message factory. This factory is used to
 * create network messages.
 *
 * Author:
 * Simon Kallweit, Kallweit Electronics
 *
 * ToDo:
 * Nothing
 *
 * History:
 * 21.08.2003 - SK - Initial release
 *
 ******************************************************************************)

unit ModuleFactory;

interface

uses
  Classes,
  Document,
  UIModule;

type
  TModuleClass = class of TModule;
  TUIModuleClass = class of TUIModule;

  (**
   * Describes a registered network message class
   *)
  TModuleFactoryItem = class(TObject)
    private
      FModuleClass : TModuleClass;
      FUIModuleClass : TUIModuleClass;
      FName : String;
      FCounter : Integer;

    public
      property  ModuleClass : TModuleClass read FModuleClass;
      property  UIModuleClass : TUIModuleClass read FUIModuleClass;
      property  Name : String read FName;

  end;

  (**
   * This class implements the network message factory. This factory is used
   * to create all network messages, locally or remotly. Messages to be used
   * in the protocol are registered with the RegisterClass() command. The order
   * messages are registered has to be the same on the server and client! The
   * factory assigns unique message ids which are used for the communication.
   *)
  TModuleFactory = class(TObject)
    private
      FClassList : TStringList;

    public
      constructor Create;
      destructor Destroy; override;

      procedure RegisterClass(ModuleClass : TModuleClass; UIModuleClass : TUIModuleClass; Name : String);

      function  CreateModule(ClassName : String; Document : TDocument; Group : TGroup) : TModule;
      function  CreateUIModule(Module : TModule; AOwner : TComponent) : TUIModule;

    private
      function  GetModuleCount : Integer;
      function  GetModule(Index : Integer) : TModuleFactoryItem;
      function  GetNameByClassName(ClassName : String) : String;

    public
      class function GetInstance : TModuleFactory;

    public
      property  ModuleCount : Integer read GetModuleCount;
      property  Module[Index : Integer] : TModuleFactoryItem read GetModule;
      property  NameByClassName[ClassName : String] : String read GetNameByClassName;

  end;

implementation

uses
  SysUtils;

var
  _ModuleFactory : TModuleFactory;

(**
 * Description:
 * Standard constructor.
 *)
constructor TModuleFactory.Create;
begin
  inherited Create;

  FClassList := TStringList.Create;
end;

(**
 * Description:
 * Standard destructor.
 *)
destructor TModuleFactory.Destroy;
var
  Index : Integer;
begin
  for Index := 0 to FClassList.Count - 1 do
    TModuleFactoryItem(FClassList.Objects[Index]).Destroy;
  FClassList.Destroy;

  inherited Destroy;
end;

(**
 * Description:
 * This method is used to register a new class in the Module factory. The
 * factory automatically creates a unique network Module ID for the class and
 * creates an entry in the class dictionary.
 *
 * Parameters:
 * AClass - Class to register
 *)
procedure TModuleFactory.RegisterClass(ModuleClass : TModuleClass; UIModuleClass : TUIModuleClass; Name : String);
var
  Item : TModuleFactoryItem;
begin
  Assert(ModuleClass.InheritsFrom(TModule));

  Item := TModuleFactoryItem.Create;
  Item.FModuleClass := ModuleClass;
  Item.FUIModuleClass := UIModuleClass;
  Item.FName := Name;
  Item.FCounter := 0;

  FClassList.AddObject(ModuleClass.ClassName, Item);
end;

(**
 * Description:
 * This method is used to create a Module object based on the class name.
 * Only creates objects of registered Module classes!
 *
 * Parameters:
 * ClassName - Name of the class to create an object from
 *
 * Returns:
 * Returns the newly created object or nil if class was not found
 *)
function  TModuleFactory.CreateModule(ClassName : String; Document : TDocument; Group : TGroup) : TModule;
var
  Item : TModuleFactoryItem;
  Index : Integer;
begin
  Result := nil;
  Index := FClassList.IndexOf(ClassName);
  if Index >= 0 then
  begin
    Item := TModuleFactoryItem(FClassList.Objects[Index]);
    Item.FCounter := Item.FCounter + 1;
    Result := Item.FModuleClass.Create(Document, Group);
    Result.Name := Result.Name + Format(' %d', [Item.FCounter]);
  end;
end;

function  TModuleFactory.CreateUIModule(Module : TModule; AOwner : TComponent) : TUIModule;
var
  Item : TModuleFactoryItem;
  Index : Integer;
begin
  Result := nil;
  Index := FClassList.IndexOf(Module.ClassName);
  if Index >= 0 then
  begin
    Item := TModuleFactoryItem(FClassList.Objects[Index]);
    Result := Item.FUIModuleClass.Create(AOwner);
  end;
end;

function  TModuleFactory.GetModuleCount : Integer;
begin
  Result := FClassList.Count;
end;

function  TModuleFactory.GetModule(Index : Integer) : TModuleFactoryItem;
begin
  Result := FClassList.Objects[Index] as TModuleFactoryItem;
end;

function  TModuleFactory.GetNameByClassName(ClassName : String) : String;
var
  Index : Integer;
begin
  Result := '';
  for Index := 0 to FClassList.Count - 1 do
    if TModuleFactoryItem(FClassList.Objects[Index]).FModuleClass.ClassName = ClassName then
    begin
      Result := TModuleFactoryItem(FClassList.Objects[Index]).FName;
      Exit;
    end;
end;

class function TModuleFactory.GetInstance : TModuleFactory;
begin
  if not Assigned(_ModuleFactory) then
    _ModuleFactory := TModuleFactory.Create;
  Result := _ModuleFactory;
end;

end.

