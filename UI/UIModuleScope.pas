unit UIModuleScope;

interface

uses
  Classes,
  Graphics,
  Controls,
  ExtCtrls,
  Types,
  Forms,
  UITypes,
  UIImageLibrary,
  UILed,
  UISwitchButton,
  UIPopupButton,
  UIRotary,
  UISimpleSlider,
  UISpinEdit,
  UIFirstLastIndicator,
  UIModule,
  UIScope,
  UIInput,
  Document,
  ValueTypes,
  ModuleScope;

type
  TUIModuleScope = class(TUIModule)
    private
      FModule : TModuleScope;
      FInputSignal : TUIInput;
      FInputRange : TUIInput;
      FScope : TUIScope;

    public
      constructor Create(AOwner : TComponent); override;
      destructor Destroy; override;

      procedure Rearrange; override;
      procedure Render; override;

    protected
      procedure UpdateModule; override;

    private
      procedure FireOnRearrange;

      procedure InputRangeChange(Sender : TObject);
      function  ScopeGetSample(Index : Integer) : Single;

    protected
      procedure SetModule(Module : TModule); override;

    public

  end;

implementation

////////////////////////////////////////////////////////////////////////////////
// TUIModuleScope                                                             //
////////////////////////////////////////////////////////////////////////////////

constructor TUIModuleScope.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FModule := nil;

  FInputSignal := TUIInput.Create(FModulePanel);
  FInputSignal.Parent := FModulePanel;
  FInputSignal.Left := 5;
  FInputSignal.Top := 5;
  FInputSignal.Width := 150;
  FInputSignal.Height := 20;

  FInputRange := TUIInput.Create(FModulePanel);
  FInputRange.Parent := FModulePanel;
  FInputRange.Left := 5;
  FInputRange.Top := 30;
  FInputRange.Width := 150;
  FInputRange.Height := 20;
  FInputRange.OnChange := InputRangeChange;

  FScope := TUIScope.Create(FModulePanel);
  FScope.Parent := FModulePanel;
  FScope.Left := 160;
  FScope.Top := 5;
  FScope.BorderSize := 5;
  FScope.OnGetSample := ScopeGetSample;
end;

destructor TUIModuleScope.Destroy;
begin
  inherited Destroy;
end;

procedure TUIModuleScope.Rearrange;
var
  OldVisible : Boolean;
begin
  OldVisible := Visible;
  Visible := false;

  FModulePanel.Width := 800;
  FModulePanel.Height := 150;

  FScope.Width := FModulePanel.Width - FScope.Left - FScope.Top;
  FScope.Height := FModulePanel.Height - FScope.Top * 2;

  Visible := OldVisible;

  inherited Rearrange;
end;

procedure TUIModuleScope.Render;
begin
  FScope.Repaint;
end;

procedure TUIModuleScope.UpdateModule;
begin
  inherited UpdateModule;
end;

procedure TUIModuleScope.FireOnRearrange;
begin
  if Assigned(FOnRearrange) and Enabled then
    FOnRearrange(Self);
end;

procedure TUIModuleScope.InputRangeChange(Sender : TObject);
begin
  case TScopeRange(FInputRange.IntValue) of
    sr0_1:
      begin
        FScope.RangeStart := 0.0;
        FScope.RangeEnd := 1.0;
      end;
    sr1_1:
      begin
        FScope.RangeStart := -1.0;
        FScope.RangeEnd := 1.0;
      end;
    sr12_12:
      begin
        FScope.RangeStart := -12.0;
        FScope.RangeEnd := 12.0;
      end;
    sr24_24:
      begin
        FScope.RangeStart := -24.0;
        FScope.RangeEnd := 24.0;
      end;
  end;
end;

function  TUIModuleScope.ScopeGetSample(Index : Integer) : Single;
begin
  Result := FModule.Sample[Index];
end;

procedure TUIModuleScope.SetModule(Module : TModule);
begin
  FModule := Module as TModuleScope;
  FInputSignal.Input := FModule.InputSignal;
  FInputRange.Input := FModule.InputRange;
  FScope.Size := FModule.Size;

  inherited SetModule(Module);
end;

end.
