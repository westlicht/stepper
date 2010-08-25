unit AppConfig;

interface

uses
  Classes,
  XML_Document,
  XML_Node;

type
  TAppConfigOperation = (coLoad, coSave);
  TAppConfigHandlerProcess = procedure(Document : TXMLDocument; BaseNode : TXMLNode; Operation : TAppConfigOperation) of object;

  TAppConfigHandler = class(TObject)
    public
      Name : String;
      Process : TAppConfigHandlerProcess;
  end;

  TAppConfig = class(TObject)
    private
      FFileName : String;
      FHandlerList : TList;
      FRecentProjectList : TStringList;

    public
      constructor Create(FileName : String);
      destructor Destroy; override;

      procedure RegisterHandler(Name : String; Process : TAppConfigHandlerProcess);

      procedure Clear;
      procedure Load;
      procedure Save;

      procedure AddRecentProject(FileName : String);

    private
      procedure GeneralConfigProcess(Document : TXMLDocument; BaseNode : TXMLNode; Operation : TAppConfigOperation);

    public
      property  RecentProjectList : TStringList read FRecentProjectList;

  end;

implementation

const
  MAX_RECENT_PROJECTS = 20;
    
constructor TAppConfig.Create(FileName : String);
begin
  FFileName := FileName;
  FHandlerList := TList.Create;
  FRecentProjectList := TStringList.Create;

  RegisterHandler('General', GeneralConfigProcess);
end;

destructor TAppConfig.Destroy;
var
  Index : Integer;
begin
  for Index := 0 to FHandlerList.Count - 1 do
    TAppConfigHandler(FHandlerList[Index]).Destroy;
  FHandlerList.Destroy;
  FRecentProjectList.Destroy;
end;

procedure TAppConfig.RegisterHandler(Name : String; Process : TAppConfigHandlerProcess);
var
  Handler : TAppConfigHandler;
begin
  Handler := TAppConfigHandler.Create;
  Handler.Name := Name;
  Handler.Process := Process;
  FHandlerList.Add(Handler)
end;

procedure TAppConfig.Clear;
begin
  FRecentProjectList.Clear;
end;

procedure TAppConfig.Load;
var
  XML : TXMLDocument;
  BaseNode : TXMLNode;
  SectionNode : TXMLNode;
  Handler : TAppConfigHandler;
  Index : Integer;
begin
  Clear;

  XML := TXMLDocument.Create;

  try
    XML.LoadFromFile(FFileName);
  except
    Exit;
  end;

  BaseNode := XML.RootNode.GetNode('Config');

  // Process handlers
  for Index := 0 to FHandlerList.Count - 1 do
  begin
    Handler := FHandlerList[Index];
    SectionNode := BaseNode.GetNode(Handler.Name);
    if Assigned(SectionNode) then
    begin
      Handler.Process(XML, SectionNode, coLoad);
    end else
    begin
      // FIXME handle this!
    end;
  end;

  XML.Destroy;
end;

procedure TAppConfig.Save;
var
  XML : TXMLDocument;
  BaseNode : TXMLNode;
  SectionNode : TXMLNode;
  Handler : TAppConfigHandler;
  Index : Integer;
begin
  XML := TXMLDocument.Create;
  XML.New;

  BaseNode := XML.RootNode.CreateChild;
  BaseNode.Name := 'Config';

  // Process handlers
  for Index := 0 to FHandlerList.Count - 1 do
  begin
    Handler := FHandlerList[Index];
    SectionNode := BaseNode.CreateChild;
    SectionNode.Name := Handler.Name;
    Handler.Process(XML, SectionNode, coSave);
  end;

  try
    XML.SaveToFile(FFileName);
  except
  end;

  XML.Destroy;
end;

procedure TAppConfig.AddRecentProject(FileName : String);
begin
  if FRecentProjectList.IndexOf(FileName) < 0 then
  begin
    FRecentProjectList.Insert(0, FileName);
    while FRecentProjectList.Count > MAX_RECENT_PROJECTS do
      FRecentProjectList.Delete(FRecentProjectList.Count - 1);
  end;
end;

procedure TAppConfig.GeneralConfigProcess(Document : TXMLDocument; BaseNode : TXMLNode; Operation : TAppConfigOperation);
var
  SectionNode, Node : TXMLNode;
  Index : Integer;
begin
  case Operation of
    coLoad:
      begin
        SectionNode := BaseNode.GetNode('RecentProjectList');
        if Assigned(SectionNode) then
        begin
          for Index := 0 to SectionNode.ChildList.Count - 1 do
          begin
            Node := SectionNode.ChildList[Index];
            FRecentProjectList.Add(Node.Value);
          end;
        end;
      end;
    coSave:
      begin
        SectionNode := BaseNode.CreateChild;
        SectionNode.Name := 'RecentProjectList';

        for Index := 0 to FRecentProjectList.Count - 1 do
        begin
          Node := SectionNode.CreateChild;
          Node.Name := 'Project';
          Node.Value := FRecentProjectList[Index];
        end;
      end;
  end;
end;

end.
