unit Observer;

interface

uses
  Classes;

type
  TObserverEvent = Longword;

  TObserverOnNotify = procedure(Sender : TObject; Event : TObserverEvent) of object;

  TObservable = class;

  TObserver = class(TObject)
    private
      FEnabled : Boolean;
      FObservableList : TList;
      FEventMask : TObserverEvent;
      FOnNotify : TObserverOnNotify;

    public
      constructor Create;
      destructor Destroy; override;

      procedure Connect(Observable : TObservable);
      procedure Disconnect(Observable : TObservable);
      procedure DisconnectAll;

    private
      procedure Notify(Sender : TObject; Event : TObserverEvent);

    public
      property  Enabled : Boolean read FEnabled write FEnabled;
      property  EventMask : TObserverEvent read FEventMask write FEventMask;
      property  OnNotify : TObserverOnNotify read FOnNotify write FOnNotify;

  end;

  TObservable = class(TObject)
    private
      FEnabled : Boolean;
      FObserverList : TList;

    public
      constructor Create;
      destructor Destroy; override;

      procedure Connect(Observer : TObserver);
      procedure Disconnect(Observer : TObserver);
      procedure DisconnectAll;

      procedure Notify(Sender : TObject; Event : TObserverEvent);

    public
      property  Enabled : Boolean read FEnabled write FEnabled;

  end;

implementation

////////////////////////////////////////////////////////////////////////////////
// TObserver                                                                  //
////////////////////////////////////////////////////////////////////////////////

constructor TObserver.Create;
begin
  inherited Create;

  FObservableList := TList.Create;
  FEnabled := true;
  FEventMask := $FFFFFFFF;
  FOnNotify := nil;
end;

destructor TObserver.Destroy;
begin
  DisconnectAll;

  FObservableList.Destroy;

  inherited Destroy;
end;

procedure TObserver.Connect(Observable : TObservable);
begin
  if FObservableList.IndexOf(Observable) < 0 then
    FObservableList.Add(Observable);

  if Observable.FObserverList.IndexOf(Self) < 0 then
    Observable.FObserverList.Add(Self);
end;

procedure TObserver.Disconnect(Observable: TObservable);
begin
  FObservableList.Remove(Observable);
  Observable.FObserverList.Remove(Self);
end;

procedure TObserver.DisconnectAll;
var
  Index : Integer;
begin
  for Index := FObservableList.Count - 1 downto 0 do
    TObservable(FObservableList[Index]).Disconnect(Self);
end;

procedure TObserver.Notify(Sender : TObject; Event : TObserverEvent);
begin
  if FEnabled and Assigned(FOnNotify) and (Event and FEventMask > 0) then
    FOnNotify(Sender, Event);
end;

////////////////////////////////////////////////////////////////////////////////
// TObservable                                                                //
////////////////////////////////////////////////////////////////////////////////

constructor TObservable.Create;
begin
  inherited Create;

  FObserverList := TList.Create;
  FEnabled := true;
end;

destructor TObservable.Destroy;
begin
  DisconnectAll;  

  FObserverList.Destroy;
  
  inherited Destroy;
end;

procedure TObservable.Connect(Observer : TObserver);
begin
  if FObserverList.IndexOf(Observer) < 0 then
    FObserverList.Add(Observer);

  if Observer.FObservableList.IndexOf(Self) < 0 then
    Observer.FObservableList.Add(Self);
end;

procedure TObservable.Disconnect(Observer : TObserver);
begin
  FObserverList.Remove(Observer);

  Observer.FObservableList.Remove(Self);
end;

procedure TObservable.DisconnectAll;
var
  Index : Integer;
begin
  for Index := FObserverList.Count - 1 downto 0 do
    TObserver(FObserverList[Index]).Disconnect(Self);
end;

procedure TObservable.Notify(Sender : TObject; Event : TObserverEvent);
var
  Index : Integer;
begin
  if not FEnabled then Exit;

  for Index := 0 to FObserverList.Count - 1 do
    TObserver(FObserverList[Index]).Notify(Sender, Event);
end;

end.
