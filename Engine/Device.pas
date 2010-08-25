unit Device;

interface

uses
  Classes,
  XML_Document,
  XML_Node,
  MidiPort,
  AppConfig;

type
  TDeviceManager = class;

  TOutputDevice = class(TObject)
    private
      FManager : TDeviceManager;
      FName : String;
      FPort : String;
      FChannel : Integer;
      FIsConnected : Boolean;
      FOutPort : TMidiOutPort;

    public
      constructor Create(Manager : TDeviceManager);
      destructor Destroy; override;

      procedure Connect;

      procedure SendEvent(Event : PMidiEvent);

    public
      property  Name : String read FName write FName;
      property  Port : String read FPort write FPort;
      property  Channel : Integer read FChannel write FChannel;
      property  IsConnected : Boolean read FIsConnected;

  end;

  TDeviceManager = class(TObject)
    private
      FMidiManager : TMidiManager;
      FOutputList : TList;

    public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;

      procedure Connect;

      function  AddOutputDevice : TOutputDevice;
      procedure RemoveOutputDevice(OutputDevice : TOutputDevice);
      procedure ClearOutputDevices;

      class function GetInstance : TDeviceManager;  

    private
      procedure ConfigProcess(Document : TXMLDocument; BaseNode : TXMLNode; Operation : TAppConfigOperation);

      function  GetOutputCount : Integer;
      function  GetOutput(Index : Integer) : TOutputDevice;

    public
      property  MidiManager : TMidiManager read FMidiManager;
      property  OutputCount : Integer read GetOutputCount;
      property  Output[Index : Integer] : TOutputDevice read GetOutput;

  end;

implementation

uses
  SysUtils,
  AppMain;

var
  _DeviceManager : TDeviceManager;

////////////////////////////////////////////////////////////////////////////////
// TOutputDevice                                                              //
////////////////////////////////////////////////////////////////////////////////

constructor TOutputDevice.Create(Manager : TDeviceManager);
begin
  inherited Create;

  FManager := Manager;
  FName := 'Device';
  FPort := '-';
  FChannel := 1;
  FIsConnected := false;
  FOutPort := nil;
end;

destructor TOutputDevice.Destroy;
begin
  if Assigned(FOutPort) then
    FOutPort.Destroy;

  inherited Destroy;
end;

procedure TOutputDevice.Connect;
var
  Device : TMidiDevice;
begin
  if Assigned(FOutPort) then
  begin
    FOutPort.Destroy;
    FOutPort := nil;
  end;

  Device := FManager.FMidiManager.OutDeviceByName[FPort];
  if Assigned(Device) then
  begin
    FOutPort := FManager.FMidiManager.CreateOutPort(Device.DeviceID);
    FOutPort.Open;
  end;
end;

procedure TOutputDevice.SendEvent(Event : PMidiEvent);
begin
  if Assigned(FOutPort) then
  begin
    Event^.Channel := FChannel;
    FOutPort.SendEvent(Event);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// TDeviceManager                                                             //
////////////////////////////////////////////////////////////////////////////////

constructor TDeviceManager.Create;
begin
  inherited Create;

  App.Config.RegisterHandler('Devices', ConfigProcess);

  FMidiManager := TMidiManager.Create;
  FMidiManager.EnumerateDevices;

  FOutputList := TList.Create;
end;

destructor TDeviceManager.Destroy;
begin
  FMidiManager.Destroy;
  FOutputList.Destroy;

  inherited Destroy;
end;

procedure TDeviceManager.Clear;
begin
  ClearOutputDevices;
end;

procedure TDeviceManager.Connect;
var
  Index : Integer;
begin
  for Index := 0 to FOutputList.Count - 1 do
    TOutputDevice(FOutputList[Index]).Connect;
end;

function  TDeviceManager.AddOutputDevice : TOutputDevice;
begin
  Result := TOutputDevice.Create(Self);
  FOutputList.Add(Result);
end;

procedure TDeviceManager.RemoveOutputDevice(OutputDevice : TOutputDevice);
begin
  FOutputList.Remove(OutputDevice);
  OutputDevice.Destroy;
end;

procedure TDeviceManager.ClearOutputDevices;
var
  Index : Integer;
begin
  for Index := 0 to FOutputList.Count - 1 do
    TOutputDevice(FOutputList[Index]).Destroy;
  FOutputList.Clear;
end;

class function TDeviceManager.GetInstance : TDeviceManager;
begin
  if not Assigned(_DeviceManager) then
    _DeviceManager := TDeviceManager.Create;
  Result := _DeviceManager;
end;  

procedure TDeviceManager.ConfigProcess(Document : TXMLDocument; BaseNode : TXMLNode; Operation : TAppConfigOperation);
var
  SectionNode, Node : TXMLNode;
  Index : Integer;
  OutputDevice : TOutputDevice;
begin
  case Operation of
    coLoad:
      begin
        Clear;
        SectionNode := BaseNode.GetNode('OutputList');
        if Assigned(SectionNode) then
        begin
          for Index := 0 to SectionNode.ChildList.Count - 1 do
          begin
            Node := SectionNode.ChildList[Index];
            OutputDevice := AddOutputDevice;
            OutputDevice.Name := Node.AttributeList.ValueByName['Name'];
            OutputDevice.Port := Node.AttributeList.ValueByName['Port'];
            OutputDevice.Channel := StrToInt(Node.AttributeList.ValueByName['Channel']);
          end;
        end;
      end;
    coSave:
      begin
        SectionNode := BaseNode.CreateChild;
        SectionNode.Name := 'OutputList';

        for Index := 0 to FOutputList.Count - 1 do
        begin
          OutputDevice := FOutputList[Index];
          Node := SectionNode.CreateChild;
          Node.Name := 'Output';
          Node.AttributeList.Add('Name', OutputDevice.Name);
          Node.AttributeList.Add('Port', OutputDevice.Port);
          Node.AttributeList.Add('Channel', IntToStr(OutputDevice.Channel));
        end;
      end;
  end;
end;

function  TDeviceManager.GetOutputCount : Integer;
begin
  Result := FOutputList.Count;
end;

function  TDeviceManager.GetOutput(Index : Integer) : TOutputDevice;
begin
  Result := FOutputList[Index];
end;

end.
