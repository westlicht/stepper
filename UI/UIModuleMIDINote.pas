unit UIModuleMIDINote;

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
  ModuleMIDINote;

type
  TUIModuleMIDINote = class(TUIModule)
    private
      FModule : TModuleMIDINote;
      FInputBaseNote : TUIInput;
      FInputPitchA : TUIInput;
      FInputPitchB : TUIInput;
      FInputPitchC : TUIInput;
      FInputGate : TUIInput;
      FInputGateThreshold : TUIInput;
      FInputVelocity : TUIInput;
      FMIDILed : TUILed;

    public
      constructor Create(AOwner : TComponent); override;
      destructor Destroy; override;

      procedure Rearrange; override;
      procedure Render; override;

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
// TUIModuleMIDINote                                                          //
////////////////////////////////////////////////////////////////////////////////

constructor TUIModuleMIDINote.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FModule := nil;

  FInputBaseNote := TUIInput.Create(FModulePanel);
  FInputBaseNote.Parent := FModulePanel;
  FInputBaseNote.Left := 5;
  FInputBaseNote.Top := 5;
  FInputBaseNote.Width := 150;
  FInputBaseNote.Height := 20;

  FInputPitchA := TUIInput.Create(FModulePanel);
  FInputPitchA.Parent := FModulePanel;
  FInputPitchA.Left := 5;
  FInputPitchA.Top := 30;
  FInputPitchA.Width := 150;
  FInputPitchA.Height := 20;

  FInputPitchB := TUIInput.Create(FModulePanel);
  FInputPitchB.Parent := FModulePanel;
  FInputPitchB.Left := 5;
  FInputPitchB.Top := 55;
  FInputPitchB.Width := 150;
  FInputPitchB.Height := 20;

  FInputPitchC := TUIInput.Create(FModulePanel);
  FInputPitchC.Parent := FModulePanel;
  FInputPitchC.Left := 5;
  FInputPitchC.Top := 80;
  FInputPitchC.Width := 150;
  FInputPitchC.Height := 20;



  FInputGate := TUIInput.Create(FModulePanel);
  FInputGate.Parent := FModulePanel;
  FInputGate.Left := 160;
  FInputGate.Top := 5;
  FInputGate.Width := 150;
  FInputGate.Height := 20;

  FInputGateThreshold := TUIInput.Create(FModulePanel);
  FInputGateThreshold.Parent := FModulePanel;
  FInputGateThreshold.Left := 160;
  FInputGateThreshold.Top := 30;
  FInputGateThreshold.Width := 150;
  FInputGateThreshold.Height := 20;



  FInputVelocity := TUIInput.Create(FModulePanel);
  FInputVelocity.Parent := FModulePanel;
  FInputVelocity.Left := 315;
  FInputVelocity.Top := 5;
  FInputVelocity.Width := 150;
  FInputVelocity.Height := 20;



  FMIDILed := TUILed.Create(FModulePanel);
  FMIDILed.Parent := FModulePanel;
  FMIDILed.Left := 700;
  FMIDILed.Top := 5;
  FMIDILed.Width := 16;
  FMIDILed.Height := 16;
  FMIDILed.ImageCollection := TUIImageLibrary.GetInstance.GetImageCollection('midi_led');
end;

destructor TUIModuleMIDINote.Destroy;
begin
  inherited Destroy;
end;

procedure TUIModuleMIDINote.Rearrange;
var
  OldVisible : Boolean;
begin
  OldVisible := Visible;
  Visible := false;

  FModulePanel.Width := 800;
  FModulePanel.Height := 105;

  Visible := OldVisible;

  inherited Rearrange;
end;

procedure TUIModuleMIDINote.Render;
begin
  FMIDILed.State := Integer(FModule.IsNoteOn);
end;

procedure TUIModuleMIDINote.UpdateModule;
begin
  inherited UpdateModule;
end;

procedure TUIModuleMIDINote.FireOnRearrange;
begin
  if Assigned(FOnRearrange) and Enabled then
    FOnRearrange(Self);
end;

procedure TUIModuleMIDINote.SetModule(Module : TModule);
begin
  FModule := Module as TModuleMIDINote;
  FInputBaseNote.Input := FModule.InputBaseNote;
  FInputPitchA.Input := FModule.InputPitchA;
  FInputPitchA.Input := FModule.InputPitchA;
  FInputPitchA.Input := FModule.InputPitchA;
  FInputPitchB.Input := FModule.InputPitchB;
  FInputPitchC.Input := FModule.InputPitchC;
  FInputGate.Input := FModule.InputGate;
  FInputGateThreshold.Input := FModule.InputGateThreshold;
  FInputVelocity.Input := FModule.InputVelocity;

  inherited SetModule(Module);
end;

end.
