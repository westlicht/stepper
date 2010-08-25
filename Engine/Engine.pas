unit Engine;

interface

uses
  Classes,
  SyncObjs,
  StopWatch,
  Observer,
  EngineTypes,
  Document,
  DocumentEvents;

type
  TEngineTask = class;

  TEngine = class(TObject)
    private
      FDocument : TDocument;
      FDocumentObserver : TObserver;
      FTask : TEngineTask;
      FModuleList : TList;
      FPriorityList : TList;
      FUpdateFrequency : Integer;

    public
      constructor Create;
      destructor Destroy; override;

      procedure Reset;
      procedure Start;
      procedure Stop;

      class function GetInstance : TEngine;

    private
      procedure UpdateModuleList;
      procedure UpdatePriorityList;
      procedure Process;

      procedure DocumentObserverNotify(Sender : TObject; Event : TObserverEvent);

      procedure SetDocument(Document : TDocument);

    public
      property  Document : TDocument read FDocument write SetDocument;

  end;

  TEngineTask = class(TThread)
    private
      FEngine : TEngine;
      FStopWatch : TStopWatch;
      FTime : Single;

    public
      constructor Create(Engine : TEngine);
      destructor Destroy; override;

    protected
      procedure Execute; override;

  end;

implementation

uses
  SysUtils;

var
  _Engine : TEngine;
  
////////////////////////////////////////////////////////////////////////////////
// TEngine                                                                    //
////////////////////////////////////////////////////////////////////////////////

constructor TEngine.Create;
begin
  inherited Create;

  FDocument := nil;
  FDocumentObserver := TObserver.Create;
  FDocumentObserver.OnNotify := DocumentObserverNotify;

  FModuleList := TList.Create;
  FPriorityList := TList.Create;
  FUpdateFrequency := 1000; // Hz
end;

destructor TEngine.Destroy;
begin
  Stop;

  FModuleList.Destroy;
  FPriorityList.Destroy;

  inherited Destroy;
end;

procedure TEngine.Reset;
var
  Index : Integer;
begin
  UpdatePriorityList;

  for Index := 0 to FModuleList.Count - 1 do
    TModule(FModuleList[Index]).Reset;
end;

procedure TEngine.Start;
begin
  Stop;

  FTask := TEngineTask.Create(Self);
  FTask.Resume;
end;

procedure TEngine.Stop;
begin
  if Assigned(FTask) then
  begin
    FTask.Terminate;
    FTask.WaitFor;
    FTask.Destroy;
    FTask := nil;
  end;
end;

class function TEngine.GetInstance : TEngine;
begin
  if not Assigned(_Engine) then
    _Engine := TEngine.Create;
  Result := _Engine;
end;

procedure TEngine.UpdateModuleList;
var
  GroupIndex : Integer;
  Group : TGroup;
  ModuleIndex : Integer;
begin
  FModuleList.Clear;

  Document.Lock;

  for GroupIndex := 0 to FDocument.GroupCount - 1 do
  begin
    Group := FDocument.Group[GroupIndex];
    for ModuleIndex := 0 to Group.ModuleCount - 1 do
      FModuleList.Add(Group.Module[ModuleIndex]);
  end;

  Document.Unlock;
end;

procedure TEngine.UpdatePriorityList;
begin
  FPriorityList.Assign(FModuleList);
end;

procedure TEngine.Process;
var
  Frame : TEngineFrame;
  Index : Integer;
  Module : TModule;
begin
  Frame.Timestamp := FTask.FTime;

  FDocument.Lock;

  // Process "processors" in priority order
  for Index := 0 to FPriorityList.Count - 1 do
  begin
    Module := FPriorityList[Index];
    Module.Process(@Frame);
  end;

  FDocument.Unlock;
end;

procedure TEngine.DocumentObserverNotify(Sender : TObject; Event : TObserverEvent);
begin
  case Event of
    EVENT_DOCUMENT_CLEAR,
    EVENT_DOCUMENT_LOAD,
    EVENT_DOCUMENT_DESTROY_GROUP,
    EVENT_DOCUMENT_CREATE_MODULE,
    EVENT_DOCUMENT_DESTROY_MODULE:
      begin
        UpdateModuleList;
        UpdatePriorityList;
      end;
  end;
end;

procedure TEngine.SetDocument(Document : TDocument);
begin
  if Document <> FDocument then
  begin
    FDocument := Document;
    FDocumentObserver.DisconnectAll;
    FDocumentObserver.Connect(FDocument.Observable);
    UpdateModuleList;
    UpdatePriorityList;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// TEngineTask                                                                //
////////////////////////////////////////////////////////////////////////////////

constructor TEngineTask.Create(Engine : TEngine);
begin
  inherited Create(true);

  FEngine := Engine;
  FStopWatch := TStopWatch.Create;

  Priority := tpTimeCritical;
end;

destructor TEngineTask.Destroy;
begin
  FStopWatch.Destroy;

  inherited Destroy;
end;

procedure TEngineTask.Execute;
var
  Base : Single;
  Ticks : Integer;
  NewTicks : Integer;
  Interval : Integer;
begin
  Base := 0.0;
  Ticks := 0;
  Interval := 1000 div FEngine.FUpdateFrequency;

  FStopWatch.Start;

  while not Terminated do
  begin
    NewTicks := FStopWatch.ElapsedTime;

    while (Ticks <= NewTicks) do
    begin
      FTime := Base + Ticks / 1000.0;
      FEngine.Process;
      inc(Ticks, Interval);
    end;

    if Ticks > $FFFFFFF then
    begin
      Ticks := 0;
      FStopWatch.Start;
      Base := FTime;
    end;

    Sleep(1);
  end;
end;

end.
