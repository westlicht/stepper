unit UIModuleClock;

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
  UIInput,
  Document,
  ModuleClock;

type
  TUIModuleClock = class(TUIModule)
    private
      FModule : TModuleClock;
      FInputBPM : TUIInput;

    public
      constructor Create(AOwner : TComponent); override;
      destructor Destroy; override;

      procedure Rearrange; override;

    protected
      procedure UpdateModule; override;

    private
      procedure FireOnRearrange;

    protected
      procedure SetModule(Module : TModule); override;

    public

  end;

implementation

////////////////////////////////////////////////////////////////////////////////
// TUIModuleClock                                                             //
////////////////////////////////////////////////////////////////////////////////

constructor TUIModuleClock.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FModule := nil;

  FInputBPM := TUIInput.Create(FModulePanel);
  FInputBPM.Parent := FModulePanel;
  FInputBPM.Left := 5;
  FInputBPM.Top := 5;
  FInputBPM.Width := 150;
  FInputBPM.Height := 20;
end;

destructor TUIModuleClock.Destroy;
begin
  inherited Destroy;
end;

procedure TUIModuleClock.Rearrange;
var
  OldVisible : Boolean;
begin
  OldVisible := Visible;
  Visible := false;

  FModulePanel.Width := 800;
  FModulePanel.Height := 30;

  Visible := OldVisible;

  inherited Rearrange;
end;

procedure TUIModuleClock.UpdateModule;
begin
  inherited UpdateModule;
end;

procedure TUIModuleClock.FireOnRearrange;
begin
  if Assigned(FOnRearrange) and Enabled then
    FOnRearrange(Self);
end;

procedure TUIModuleClock.SetModule(Module : TModule);
begin
  FModule := Module as TModuleClock;
  FInputBPM.Input := FModule.InputBPM;

  inherited SetModule(Module);
end;

end.
