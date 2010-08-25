unit ModuleScope;

interface

uses
  XML_Document,
  XML_Node,
  Document,
  EngineTypes,
  ValueTypes;

type
  TModuleScope = class(TModule)
    private
      FSize : Integer;
      FPosition : Integer;
      FHistory : Array of TValue;
      FInputSignal : TInput;
      FInputRange : TInput;

    public
      constructor Create(Document : TDocument; Group : TGroup); override;
      destructor Destroy; override;

      procedure Clear; override;

      procedure Reset; override;
      procedure Process(Frame : PEngineFrame); override;

      procedure SaveToXML(Document : TXMLDocument; BaseNode : TXMLNode); override;
      procedure LoadFromXML(Document : TXMLDocument; BaseNode : TXMLNode); override;

    private
      procedure SetSize(Size : Integer);
      function  GetSample(Index : Integer) : TValue;

    public
      property  Size : Integer read FSize write SetSize;
      property  Sample[Index : Integer] : TValue read GetSample;
      property  InputSignal : TInput read FInputSignal;
      property  InputRange : TInput read FInputRange;

  end;

implementation

uses
  UIModuleScope,
  ModuleFactory,
  Engine;

constructor TModuleScope.Create(Document : TDocument; Group : TGroup);
begin
  inherited Create(Document, Group);

  FName := 'Scope';

  FInputSignal := CreateInput('Input', vtValue, [ioCanConnect], 0.0);
  FInputRange := CreateInput('Range', vtScopeRange, [ioCanEdit], 0);

  SetSize(512);
  FSize := Size;
  SetLength(FHistory, FSize);

  Reset;
end;

destructor TModuleScope.Destroy;
begin
  inherited Destroy;
end;

procedure TModuleScope.Clear;
begin
  inherited Clear;
end;

procedure TModuleScope.Reset;
var
  Index : Integer;
begin
  for Index := 0 to FSize - 1 do
    FHistory[Index] := 0.0;

  FPosition := 0;
end;

procedure TModuleScope.Process(Frame : PEngineFrame);
begin
//  FInputSignal.Value := Sin(FPosition / 50);
  FPosition := (FPosition + 1) mod FSize;
  FHistory[FPosition] := FInputSignal.CurrentValue;
end;

procedure TModuleScope.SaveToXML(Document : TXMLDocument; BaseNode : TXMLNode);
begin
  inherited SaveToXML(Document, BaseNode);
end;

procedure TModuleScope.LoadFromXML(Document : TXMLDocument; BaseNode : TXMLNode);
begin
  inherited LoadFromXML(Document, BaseNode);
end;

procedure TModuleScope.SetSize(Size : Integer);
begin
  FSize := Size;
  SetLength(FHistory, FSize);
end;

function  TModuleScope.GetSample(Index : Integer) : TValue;
begin
  Result := FHistory[(FPosition + FSize - Index) mod FSize];
end;

initialization
begin
  TModuleFactory.GetInstance.RegisterClass(TModuleScope, TUIModuleScope, 'Scope');
end;

end.
