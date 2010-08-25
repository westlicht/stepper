unit Document;

interface

uses
  Classes,
  SyncObjs,
  XML_Document,
  XML_Node,
  Observer,
  EngineTypes,
  ValueTypes;

type
  TSelectOperation = (soSelectNone, soSelectAll, soSelectSingle, soSelectAdd, soSelectRemove);

  TDocument = class;
  TDocumentObject = class(TObject)
    protected
      FDocument : TDocument;
      FObjectID : Integer;
      FName : String;

    public
      constructor Create(Document : TDocument);
      destructor Destroy; override;

    protected
      procedure SaveToXML(Document : TXMLDocument; BaseNode : TXMLNode); virtual;
      procedure LoadFromXML(Document : TXMLDocument; BaseNode : TXMLNode); virtual;
      procedure PostLoad; virtual;

      procedure SetName(Name : String); virtual;

    public
      property  Document : TDocument read FDocument;
      property  ObjectID : Integer read FObjectID;
      property  Name : String read FName write SetName;
      
  end;

  TInputOption = (
    ioCanConnect,
    ioCanEdit,
    ioClamp
  );

  TInputOptions = set of TInputOption;

  TGroup = class;
  TModule = class;
  TOutput = class;

  TInput = class(TDocumentObject)
    private
      FModule : TModule;
      FValue : TValue;
      FDefaultValue : TValue;
      FValueTyp : TValueTyp;
      FValueProperties : TValueProperties;
      FOptions : TInputOptions;
      FOutput : TOutput;
      FOutputObjectID : Integer;

    public
      constructor Create(Document : TDocument; Module : TModule);
      destructor Destroy; override;

      procedure SaveToXML(Document : TXMLDocument; BaseNode : TXMLNode); override;
      procedure LoadFromXML(Document : TXMLDocument; BaseNode : TXMLNode); override;
      procedure PostLoad; override;

      procedure Connect(Output : TOutput);
      procedure Disconnect;

    private
      procedure SetIntValue(IntValue : Integer);
      function  GetIntValue : Integer;
      function  GetCurrentValue : TValue;
      function  GetCurrentIntValue : Integer;
      procedure SetValueTyp(ValueTyp : TValueTyp);
      function  GetIsConnected : Boolean;

    public
      property  Module : TModule read FModule;
      property  Value : TValue read FValue write FValue;
      property  IntValue : Integer read GetIntValue write SetIntValue;
      property  DefaultValue : TValue read FDefaultValue write FDefaultValue;
      property  CurrentValue : TValue read GetCurrentValue;
      property  CurrentIntValue : Integer read GetCurrentIntValue;
      property  ValueTyp : TValueTyp read FValueTyp write SetValueTyp;
      property  ValueProperties : TValueProperties read FValueProperties;
      property  Options : TInputOptions read FOptions;
      property  Output : TOutput read FOutput;
      property  IsConnected : Boolean read GetIsConnected;

  end;

  TOutput = class(TDocumentObject)
    private
      FModule : TModule;
      FValue : TValue;
      FDefaultValue : TValue;
      FValueTyp : TValueTyp;
      FValueProperties : TValueProperties;
      FInputList : TList;

    public
      constructor Create(Document : TDocument; Module : TModule);
      destructor Destroy; override;

      procedure SaveToXML(Document : TXMLDocument; BaseNode : TXMLNode); override;
      procedure LoadFromXML(Document : TXMLDocument; BaseNode : TXMLNode); override;

      procedure Connect(Input : TInput);
      procedure Disconnect(Input : TInput);
      procedure DisconnectAll;

    private
      procedure SetValueTyp(ValueTyp : TValueTyp);

    public
      property  Module : TModule read FModule;
      property  Value : TValue read FValue write FValue;
      property  DefaultValue : TValue read FDefaultValue write FDefaultValue;
      property  ValueTyp : TValueTyp read FValueTyp write SetValueTyp;
      property  ValueProperties : TValueProperties read FValueProperties;

  end;

  TModule = class(TDocumentObject)
    protected
      FGroup : TGroup;
      FSelected : Boolean;
      FMinimized : Boolean;
      FInputList : TList;
      FOutputList : TList;
      FObservable : TObservable;

    public
      constructor Create(Document : TDocument; Group : TGroup); virtual;
      destructor Destroy; override;

      procedure Clear; virtual;

      procedure Reset; virtual;
      procedure Process(Frame : PEngineFrame); virtual;

      procedure SaveToXML(Document : TXMLDocument; BaseNode : TXMLNode); override;
      procedure LoadFromXML(Document : TXMLDocument; BaseNode : TXMLNode); override;

    protected
      function  CreateInput(Name : String; ValueTyp : TValueTyp; Options : TInputOptions; DefaultValue : TValue) : TInput;
      function  CreateOutput(Name : String; ValueTyp : TValueTyp; DefaultValue : TValue) : TOutput;

      procedure SetName(Name : String); override;

    private
      procedure SetSelected(Selected : Boolean);
      procedure SetMinimized(Minimized : Boolean);
      function  GetInputCount : Integer;
      function  GetInput(Index : Integer) : TInput;
      function  GetOutputCount : Integer;
      function  GetOutput(Index : Integer) : TOutput;

    public
      property  Group : TGroup read FGroup;
      property  Selected : Boolean read FSelected write SetSelected;
      property  Minimized : Boolean read FMinimized write SetMinimized;
      property  InputCount : Integer read GetInputCount;
      property  Input[Index : Integer] : TInput read GetInput;
      property  OutputCount : Integer read GetOutputCount;
      property  Output[Index : Integer] : TOutput read GetOutput;
      property  Observable : TObservable read FObservable;

  end;

  TGroup = class(TDocumentObject)
    private
      FSelected : Boolean;
      FModuleList : TList;
      FObservable : TObservable;

    public
      constructor Create(Document : TDocument);
      destructor Destroy; override;

      procedure Clear; virtual;

      procedure SaveToXML(Document : TXMLDocument; BaseNode : TXMLNode); override;
      procedure LoadFromXML(Document : TXMLDocument; BaseNode : TXMLNode); override;

      function  CreateModule(ClassName : String) : TModule;
      procedure DestroyModule(Module : TModule);

      procedure SelectModule(Operation : TSelectOperation; Module : TModule);
      procedure RemoveSelectedModules;

    private
      procedure SetSelected(Selected : Boolean);
      function  GetModuleCount : Integer;
      function  GetModule(Index : Integer) : TModule;

    public
      property  Selected : Boolean read FSelected write SetSelected;
      property  ModuleCount : Integer read GetModuleCount;
      property  Module[Index : Integer] : TModule read GetModule;
      property  Observable : TObservable read FObservable;

  end;

  TDocument = class(TObject)
    private
      FProtectDocument : TCriticalSection;
      FObjectList : TList;
      FGroupList : TList;
      FObservable : TObservable;
      FCurrentObjectID : Integer;

    public
      constructor Create;
      destructor Destroy; override;

      procedure New;

      procedure SaveToXML(Document : TXMLDocument; BaseNode : TXMLNode);
      procedure LoadFromXML(Document : TXMLDocument; BaseNode : TXMLNode);

      procedure SaveToFile(FileName : String);
      procedure LoadFromFile(FileName : String);

      function  CreateGroup : TGroup;
      procedure DestroyGroup(Group : TGroup);

      procedure SelectGroup(Operation : TSelectOperation; Group : TGroup);
      function  GetFirstSelectedGroup : TGroup;

      procedure Lock;
      procedure Unlock;

    private
      procedure AddObject(Obj : TDocumentObject);
      procedure RemoveObject(Obj : TDocumentObject);

      function  GetNewObjectID : Integer;
      procedure SetUsedObjectID(ObjectID : Integer);

      procedure ClearGroupList;

      function  GetObjectByID(ID : Integer) : TDocumentObject;
      function  GetGroupCount : Integer;
      function  GetGroup(Index : Integer) : TGroup;

    public
      property  ObjectByID[ID : Integer] : TDocumentObject read GetObjectByID;
      property  GroupCount : Integer read GetGroupCount;
      property  Group[Index : Integer] : TGroup read GetGroup;
      property  Observable : TObservable read FObservable;

  end;

implementation

uses
  SysUtils,
  DocumentEvents,
  ModuleFactory;

////////////////////////////////////////////////////////////////////////////////
// TDocumentObject                                                            //
////////////////////////////////////////////////////////////////////////////////

constructor TDocumentObject.Create(Document : TDocument);
begin
  inherited Create;

  FDocument := Document;
  FObjectID := FDocument.GetNewObjectID;
  FName := '';
  FDocument.AddObject(Self);
end;

destructor TDocumentObject.Destroy;
begin
  FDocument.RemoveObject(Self);

  inherited Destroy;
end;

procedure TDocumentObject.SaveToXML(Document : TXMLDocument; BaseNode : TXMLNode);
begin
  BaseNode.AttributeList.Add('Name', FName);
  BaseNode.AttributeList.Add('ObjectID', IntToStr(FObjectID));
end;

procedure TDocumentObject.LoadFromXML(Document : TXMLDocument; BaseNode : TXMLNode);
begin
  FName := BaseNode.AttributeList.ValueByName['Name'];
  FObjectID := StrToInt(BaseNode.AttributeList.ValueByName['ObjectID']);
  FDocument.SetUsedObjectID(FObjectID);
end;

procedure TDocumentObject.PostLoad;
begin
end;

procedure TDocumentObject.SetName(Name : String);
begin
  FName := Name;
end;
  
////////////////////////////////////////////////////////////////////////////////
// TInput                                                                     //
////////////////////////////////////////////////////////////////////////////////

constructor TInput.Create(Document : TDocument; Module : TModule);
begin
  inherited Create(Document);

  FModule := Module;
end;

destructor TInput.Destroy;
begin
  Disconnect;

  inherited Destroy;
end;

procedure TInput.SaveToXML(Document : TXMLDocument; BaseNode : TXMLNode);
begin
  inherited SaveToXML(Document, BaseNode);

  BaseNode.Name := 'Input';

  BaseNode.AttributeList.Add('Value', Format('%.5f', [FValue]));
  if Assigned(FOutput) then
    BaseNode.AttributeList.Add('Output', IntToStr(FOutput.FObjectID))
  else
    BaseNode.AttributeList.Add('Output', '0');
end;

procedure TInput.LoadFromXML(Document : TXMLDocument; BaseNode : TXMLNode);
begin
  inherited LoadFromXML(Document, BaseNode);

  FValue := StrToFloat(BaseNode.AttributeList.ValueByName['Value']);
  FOutputObjectID := StrToInt(BaseNode.AttributeList.ValueByName['Output']);
end;

procedure TInput.PostLoad;
begin
  if FOutputObjectID > 0 then
    Connect(FDocument.ObjectByID[FOutputObjectID] as TOutput);
end;

procedure TInput.Connect(Output : TOutput);
begin
  Disconnect;

  FOutput := Output;
  if FOutput.FInputList.IndexOf(Self) < 0 then
    FOutput.FInputList.Add(Self);
end;

procedure TInput.Disconnect;
begin
  if Assigned(FOutput) then
  begin
    FOutput.FInputList.Remove(Self);
    FOutput := nil;
  end;
end;

procedure TInput.SetIntValue(IntValue : Integer);
begin
  FValue := IntValue;
end;

function  TInput.GetIntValue : Integer;
begin
  Result := trunc(FValue);
end;

function  TInput.GetCurrentValue : TValue;
begin
  if Assigned(FOutput) then
    Result := FOutput.Value
  else
    Result := FValue;

  if ioClamp in FOptions then
    FValueProperties.Clamp(@Result);
end;

function  TInput.GetCurrentIntValue : Integer;
begin
  Result := trunc(GetCurrentValue);
end;

procedure TInput.SetValueTyp(ValueTyp : TValueTyp);
begin
  if ValueTyp <> FValueTyp then
  begin
    FValueTyp := ValueTyp;
    FValueProperties := TValuePropertiesManager.GetInstance.GetValueProperties(FValueTyp);
    FValueProperties.Quantize(@FValue);
    FValueProperties.Clamp(@FValue);
  end;
end;

function  TInput.GetIsConnected : Boolean;
begin
  Result := Assigned(FOutput);
end;

////////////////////////////////////////////////////////////////////////////////
// TOutput                                                                    //
////////////////////////////////////////////////////////////////////////////////

constructor TOutput.Create(Document : TDocument; Module : TModule);
begin
  inherited Create(Document);

  FModule := Module;
  FInputList := TList.Create;
end;

destructor TOutput.Destroy;
begin
  DisconnectAll;
  FInputList.Destroy;

  inherited Destroy;
end;

procedure TOutput.SaveToXML(Document : TXMLDocument; BaseNode : TXMLNode);
begin
  inherited SaveToXML(Document, BaseNode);

  BaseNode.Name := 'Output';
end;

procedure TOutput.LoadFromXML(Document : TXMLDocument; BaseNode : TXMLNode);
begin
  inherited LoadFromXML(Document, BaseNode);
end;

procedure TOutput.Connect(Input : TInput);
begin
  Input.FOutput := Self;
  if FInputList.IndexOf(Input) < 0 then
    FInputList.Add(Input);
end;

procedure TOutput.Disconnect(Input : TInput);
begin
  Input.FOutput := nil;
  FInputList.Remove(Input);
end;

procedure TOutput.DisconnectAll;
var
  Index : Integer;
begin
  for Index := 0 to FInputList.Count - 1 do
    TInput(FInputList[Index]).FOutput := nil;
  FInputList.Clear;
end;

procedure TOutput.SetValueTyp(ValueTyp : TValueTyp);
begin
  if ValueTyp <> FValueTyp then
  begin
    FValueTyp := ValueTyp;
    FValueProperties := TValuePropertiesManager.GetInstance.GetValueProperties(FValueTyp);
    FValueProperties.Quantize(@FValue);
    FValueProperties.Clamp(@FValue);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// TModule                                                                    //
////////////////////////////////////////////////////////////////////////////////

constructor TModule.Create(Document : TDocument; Group : TGroup);
begin
  inherited Create(Document);

  FGroup := Group;
  FSelected := false;
  FMinimized := false;
  FInputList := TList.Create;
  FOutputList := TList.Create;
  FObservable := TObservable.Create;
end;

destructor TModule.Destroy;
var
  Index : Integer;
begin
  for Index := 0 to FInputList.Count - 1 do
    TInput(FInputList[Index]).Destroy;
  for Index := 0 to FOutputList.Count - 1 do
    TOutput(FOutputList[Index]).Destroy;
  FInputList.Destroy;
  FOutputList.Destroy;
  FObservable.Destroy;

  inherited Destroy;
end;

procedure TModule.Clear;
begin
  FObservable.Notify(Self, EVENT_MODULE_CLEAR);
end;

procedure TModule.Reset;
begin
end;

procedure TModule.Process(Frame : PEngineFrame);
begin
end;

procedure TModule.SaveToXML(Document : TXMLDocument; BaseNode : TXMLNode);
var
  SectionNode, Node : TXMLNode;
  Index : Integer;
begin
  inherited SaveToXML(Document, BaseNode);

  BaseNode.Name := 'Module';
  BaseNode.AttributeList.Add('Class', Self.ClassName);
  BaseNode.AttributeList.Add('Minimized', BoolToStr(FMinimized));

  SectionNode := BaseNode.CreateChild;
  SectionNode.Name := 'InputList';
  for Index := 0 to FInputList.Count - 1 do
  begin
    Node := SectionNode.CreateChild;
    TInput(FInputList[Index]).SaveToXML(Document, Node);
  end;

  SectionNode := BaseNode.CreateChild;
  SectionNode.Name := 'OutputList';
  for Index := 0 to FOutputList.Count - 1 do
  begin
    Node := SectionNode.CreateChild;
    TOutput(FOutputList[Index]).SaveToXML(Document, Node);
  end;
end;

procedure TModule.LoadFromXML(Document : TXMLDocument; BaseNode : TXMLNode);
var
  Node, SectionNode : TXMLNode;
  Index : Integer;
begin
  inherited LoadFromXML(Document, BaseNode);

  FMinimized := StrToBool(BaseNode.AttributeList.ValueByName['Minimized']);

  SectionNode := BaseNode.GetNode('InputList');
  for Index := 0 to SectionNode.ChildList.Count - 1 do
  begin
    Node := SectionNode.ChildList[Index];
    TInput(FInputList[Index]).LoadFromXML(Document, Node);
  end;

  SectionNode := BaseNode.GetNode('OutputList');
  for Index := 0 to SectionNode.ChildList.Count - 1 do
  begin
    Node := SectionNode.ChildList[Index];
    TOutput(FOutputList[Index]).LoadFromXML(Document, Node);
  end;
end;

function  TModule.CreateInput(Name : String; ValueTyp : TValueTyp; Options : TInputOptions; DefaultValue : TValue) : TInput;
begin
  Result := TInput.Create(FDocument, Self);
  Result.FName := Name;
  Result.FValueTyp := ValueTyp;
  Result.FValueProperties := (TValuePropertiesManager.GetInstance).GetValueProperties(ValueTyp);
  Result.FOptions := Options;
  Result.FDefaultValue := DefaultValue;
  Result.FValue := DefaultValue;
  FInputList.Add(Result);
end;

function  TModule.CreateOutput(Name : String; ValueTyp : TValueTyp; DefaultValue : TValue) : TOutput;
begin
  Result := TOutput.Create(FDocument, Self);
  Result.FName := Name;
  Result.FValueTyp := ValueTyp;
  Result.FValueProperties := (TValuePropertiesManager.GetInstance).GetValueProperties(ValueTyp);
  Result.FDefaultValue := DefaultValue;
  Result.FValue := DefaultValue;
  FOutputList.Add(Result);
end;

procedure TModule.SetName(Name : String);
begin
  inherited SetName(Name);
  FObservable.Notify(Self, EVENT_MODULE_NAME_CHANGED);
end;

procedure TModule.SetSelected(Selected : Boolean);
begin
  if (Selected <> FSelected) then
  begin
    FSelected := Selected;
    FObservable.Notify(Self, EVENT_MODULE_SELECTED_CHANGED);
    FGroup.FObservable.Notify(FGroup, EVENT_GROUP_SELECT_MODULE);
  end;
end;

procedure TModule.SetMinimized(Minimized : Boolean);
begin
  if (Minimized <> FMinimized) then
  begin
    FMinimized := Minimized;
    FObservable.Notify(Self, EVENT_MODULE_MINIMIZED_CHANGED);
  end;
end;

function  TModule.GetInputCount : Integer;
begin
  Result := FInputList.Count;
end;

function  TModule.GetInput(Index : Integer) : TInput;
begin
  Result := FInputList[Index];
end;

function  TModule.GetOutputCount : Integer;
begin
  Result := FOutputList.Count;
end;

function  TModule.GetOutput(Index : Integer) : TOutput;
begin
  Result := FOutputList[Index];
end;

////////////////////////////////////////////////////////////////////////////////
// TGroup                                                                     //
////////////////////////////////////////////////////////////////////////////////

constructor TGroup.Create(Document : TDocument);
begin
  inherited Create(Document);

  FName := 'Group';
  FSelected := false;
  FModuleList := TList.Create;
  FObservable := TObservable.Create;
end;

destructor TGroup.Destroy;
begin
  Clear;
  FModuleList.Destroy;
  FObservable.Destroy;

  inherited Destroy;
end;

procedure TGroup.Clear;
var
  Index : Integer;
begin
  for Index := 0 to FModuleList.Count - 1 do
    TModule(FModuleList[Index]).Destroy;
  FModuleList.Clear;
  FObservable.Notify(Self, EVENT_GROUP_DESTROY_MODULE);
  FDocument.FObservable.Notify(Self, EVENT_DOCUMENT_DESTROY_MODULE);
end;

procedure TGroup.SaveToXML(Document : TXMLDocument; BaseNode : TXMLNode);
var
  SectionNode : TXMLNode;
  Node : TXMLNode;
  Index : Integer;
begin
  inherited SaveToXML(Document, BaseNode);

  BaseNode.Name := 'Group';

  SectionNode := BaseNode.CreateChild;
  SectionNode.Name := 'ModuleList';

  for Index := 0 to FModuleList.Count - 1 do
  begin
    Node := SectionNode.CreateChild;
    TModule(FModuleList[Index]).SaveToXML(Document, Node);
  end;
end;

procedure TGroup.LoadFromXML(Document : TXMLDocument; BaseNode : TXMLNode);
var
  SectionNode : TXMLNode;
  Node : TXMLNode;
  Index : Integer;
  Module : TModule;
begin
  inherited LoadFromXML(Document, BaseNode);

  SectionNode := BaseNode.GetNode('ModuleList');

  for Index := 0 to SectionNode.ChildList.Count - 1 do
  begin
    Node := SectionNode.ChildList[Index];
    if Assigned(Node) then
    begin
      Module := TModuleFactory.GetInstance.CreateModule(Node.AttributeList.ValueByName['Class'], FDocument, Self);
      Module.LoadFromXML(Document, Node);
      FModuleList.Add(Module);
    end;
  end;
end;

function  TGroup.CreateModule(ClassName : String) : TModule;
begin
  FDocument.Lock;
  Result := TModuleFactory.GetInstance.CreateModule(ClassName, FDocument, Self);
  FDocument.Unlock;
  FModuleList.Add(Result);
  FObservable.Notify(Self, EVENT_GROUP_CREATE_MODULE);
  FDocument.FObservable.Notify(Self, EVENT_DOCUMENT_CREATE_MODULE);
end;

procedure TGroup.DestroyModule(Module : TModule);
begin
  FDocument.Lock;
  FModuleList.Remove(Module);
  Module.Destroy;
  FDocument.Unlock;
  FObservable.Notify(Self, EVENT_GROUP_DESTROY_MODULE);
  FDocument.FObservable.Notify(Self, EVENT_DOCUMENT_DESTROY_MODULE);
end;

procedure TGroup.SelectModule(Operation : TSelectOperation; Module : TModule);
var
  Index : Integer;
begin
  case Operation of
    soSelectNone:
      begin
        FObservable.Enabled := false;
        for Index := 0 to FModuleList.Count - 1 do
          TModule(FModuleList[Index]).Selected := false;
        FObservable.Enabled := true;
        FObservable.Notify(Self, EVENT_GROUP_SELECT_MODULE);
      end;
    soSelectAll:
      begin
        FObservable.Enabled := false;
        for Index := 0 to FModuleList.Count - 1 do
          TModule(FModuleList[Index]).Selected := true;
        FObservable.Enabled := true;
        FObservable.Notify(Self, EVENT_GROUP_SELECT_MODULE);
      end;
    soSelectSingle:
      begin
        FObservable.Enabled := false;
        for Index := 0 to FModuleList.Count - 1 do
          TModule(FModuleList[Index]).Selected := false;
        Module.Selected := true;
        FObservable.Enabled := true;
        FObservable.Notify(Self, EVENT_GROUP_SELECT_MODULE);
      end;
    soSelectAdd:
      begin
        Module.Selected := true;
      end;
    soSelectRemove:
      begin
        Module.Selected := false;
      end;
  end;
end;

procedure TGroup.RemoveSelectedModules;
var
  Index : Integer;
begin
  for Index := FModuleList.Count - 1 downto 0 do
    if TModule(FModuleList[Index]).Selected then
      DestroyModule(FModuleList[Index]);
end;

procedure TGroup.SetSelected(Selected : Boolean);
begin
  if Selected <> FSelected then
  begin
    FSelected := Selected;
    FObservable.Notify(Self, EVENT_GROUP_SELECTED_CHANGED);
    FDocument.FObservable.Notify(FDocument, EVENT_DOCUMENT_SELECT_GROUP);
  end;
end;

function  TGroup.GetModuleCount : Integer;
begin
  Result := FModuleList.Count;
end;

function  TGroup.GetModule(Index : Integer) : TModule;
begin
  Result := FModuleList[Index];
end;

////////////////////////////////////////////////////////////////////////////////
// TDocument                                                                  //
////////////////////////////////////////////////////////////////////////////////

constructor TDocument.Create;
begin
  inherited Create;

  FProtectDocument := TCriticalSection.Create;
  FObjectList := TList.Create;
  FGroupList := TList.Create;
  FObservable := TObservable.Create;
end;

destructor TDocument.Destroy;
begin
  ClearGroupList;
  FGroupList.Destroy;
  FObjectList.Destroy;
  FObservable.Destroy;
  FProtectDocument.Destroy;

  inherited Destroy;
end;

procedure TDocument.New;
begin
  FCurrentObjectID := 1;
  ClearGroupList;
  FObservable.Notify(Self, EVENT_DOCUMENT_CLEAR);
end;

procedure TDocument.SaveToXML(Document : TXMLDocument; BaseNode : TXMLNode);
var
  SectionNode : TXMLNode;
  Node : TXMLNode;
  Index : Integer;
begin
  SectionNode := BaseNode.CreateChild;
  SectionNode.Name := 'General';

  SectionNode := BaseNode.CreateChild;
  SectionNode.Name := 'GroupList';

  for Index := 0 to FGroupList.Count - 1 do
  begin
    Node := SectionNode.CreateChild;
    TGroup(FGroupList[Index]).SaveToXML(Document, Node);
  end;
end;

procedure TDocument.LoadFromXML(Document : TXMLDocument; BaseNode : TXMLNode);
var
  SectionNode : TXMLNode;
  Node : TXMLNode;
  Index : Integer;
  Group : TGroup;
begin
  New;

  SectionNode := BaseNode.GetNode('General');
  if Assigned(SectionNode) then
  begin
  end;

  SectionNode := BaseNode.GetNode('GroupList');

  for Index := 0 to SectionNode.ChildList.Count - 1 do
  begin
    Node := SectionNode.ChildList[Index];
    if Assigned(Node) then
    begin
      Group := CreateGroup;
      Group.LoadFromXML(Document, Node);
    end;
  end;

  for Index := 0 to FObjectList.Count - 1 do
    TDocumentObject(FObjectList[Index]).PostLoad;

  FObservable.Notify(Self, EVENT_DOCUMENT_LOAD);
end;

procedure TDocument.SaveToFile(FileName : String);
var
  Document: TXMLDocument;
  Node : TXMLNode;
begin
  Document := TXMLDocument.Create;
  Document.New;
  Node := Document.RootNode.CreateChild;
  Node.Name := 'Project';
  SaveToXML(Document, Node);
  Document.SaveToFile(FileName);
  Document.Destroy;
end;

procedure TDocument.LoadFromFile(FileName : String);
var
  Document: TXMLDocument;
  Node : TXMLNode;
begin
  Document := TXMLDocument.Create;
  Document.LoadFromFile(FileName);
  Node := Document.RootNode.GetNode('Project');
  LoadFromXML(Document, Node);
  Document.Destroy;
end;

function  TDocument.CreateGroup : TGroup;
begin
  Lock;
  Result := TGroup.Create(Self);
  FGroupList.Add(Result);
  Unlock;
  FObservable.Notify(Self, EVENT_DOCUMENT_CREATE_GROUP);
end;

procedure TDocument.DestroyGroup(Group : TGroup);
begin
  Lock;
  FGroupList.Remove(Group);
  Group.Destroy;
  Unlock;
  FObservable.Notify(Self, EVENT_DOCUMENT_DESTROY_GROUP);
end;

procedure TDocument.SelectGroup(Operation : TSelectOperation; Group : TGroup);
var
  Index : Integer;
begin
  case Operation of
    soSelectNone:
      begin
        FObservable.Enabled := false;
        for Index := 0 to FGroupList.Count - 1 do
          TGroup(FGroupList[Index]).Selected := false;
        FObservable.Enabled := true;
        FObservable.Notify(Self, EVENT_DOCUMENT_SELECT_GROUP);
      end;
    soSelectAll:
      begin
        FObservable.Enabled := false;
        for Index := 0 to FGroupList.Count - 1 do
          TGroup(FGroupList[Index]).Selected := true;
        FObservable.Enabled := true;
        FObservable.Notify(Self, EVENT_DOCUMENT_SELECT_GROUP);
      end;
    soSelectSingle:
      begin
        FObservable.Enabled := false;
        for Index := 0 to FGroupList.Count - 1 do
          TGroup(FGroupList[Index]).Selected := false;
        Group.Selected := true;
        FObservable.Enabled := true;
        FObservable.Notify(Self, EVENT_DOCUMENT_SELECT_GROUP);
      end;
    soSelectAdd:
      begin
        Group.Selected := true;
      end;
    soSelectRemove:
      begin
        Group.Selected := false;
      end;
  end;
end;

function  TDocument.GetFirstSelectedGroup : TGroup;
var
  Index : Integer;
begin
  Result := nil;
  for Index := 0 to FGroupList.Count - 1 do
  begin
    Result := FGroupList[Index];
    if Result.Selected then
      Exit;
  end;
end;

procedure TDocument.AddObject(Obj : TDocumentObject);
begin
  FObjectList.Add(Obj);
end;

procedure TDocument.RemoveObject(Obj : TDocumentObject);
begin
  FObjectList.Remove(Obj);
end;

function  TDocument.GetNewObjectID : Integer;
begin
  Result := FCurrentObjectID;
  inc(FCurrentObjectID);
end;

procedure TDocument.SetUsedObjectID(ObjectID : Integer);
begin
  if ObjectID >= FCurrentObjectID then
    FCurrentObjectID := ObjectID + 1;
end;

procedure TDocument.ClearGroupList;
var
  Index : Integer;
begin
  Lock;
  for Index := 0 to FGroupList.Count - 1 do
    TGroup(FGroupList[Index]).Destroy;
  FGroupList.Clear;
  Unlock;
  FObservable.Notify(Self, EVENT_DOCUMENT_DESTROY_GROUP);
end;

procedure TDocument.Lock;
begin
  FProtectDocument.Acquire;
end;

procedure TDocument.Unlock;
begin
  FProtectDocument.Release;
end;

function  TDocument.GetObjectByID(ID : Integer) : TDocumentObject;
var
  Index : Integer;
begin
  Result := nil;
  for Index := 0 to FObjectList.Count - 1 do
    if TDocumentObject(FObjectList[Index]).FObjectID = ID then
    begin
      Result := FObjectList[Index];
      Exit;
    end;
end;

function  TDocument.GetGroupCount : Integer;
begin
  Result := FGroupList.Count;
end;

function  TDocument.GetGroup(Index : Integer) : TGroup;
begin
  Result := FGroupList[Index];
end;

end.
