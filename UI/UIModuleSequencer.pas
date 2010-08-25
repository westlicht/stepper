unit UIModuleSequencer;

interface

uses
  Classes,
  Graphics,
  Controls,
  StdCtrls,
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
  EngineTypes,
  ValueTypes,
  ModuleSequencer;

type
  TUIModuleSequencerDisplayMode = (dmSpinEdit, dmRotary, dmSlider);

  TUIModuleSequencer = class;

  TUIModuleSequencerStep = class(TObject)
    private
      FParent : TWinControl;
      FSequencer : TUIModuleSequencer;
      FInputStep : TInput;
      FIndex : Integer;
      FPositionLed : TUILed;
      FSlider : TUISimpleSlider;
      FLabel : TLabel;
      FTieButton : TUISwitchButton;

    public
      constructor Create(Parent : TWinControl; Sequencer : TUIModuleSequencer; Index : Integer);
      destructor Destroy; override;

      procedure SetValue(Value : TValue);
      procedure SetTie(Tie : Boolean);
      procedure UpdateValueTyp;

  end;

  TUIModuleSequencer = class(TUIModule)
    private
      FModule : TModuleSequencer;

      FInputMode : TUIInput;
      FInputValueRange : TUIInput;
      FInputPlayMode : TUIInput;
      FInputClockDiv : TUIInput;
      FInputFirstStep : TUIInput;
      FInputLastStep : TUIInput;
      FInputClock : TUIInput;

      FSequencePanel : TPanel;
      FStepList : TList;

    public
      constructor Create(AOwner : TComponent); override;
      destructor Destroy; override;

      procedure Rearrange; override;
      procedure Render; override;

      procedure UpdateSequence;

    protected
      procedure UpdateModule; override;

    private
      procedure UpdateStepValueTyp;

      procedure InputModeChange(Sender : TObject);
      procedure InputValueRangeChange(Sender : TObject);


      procedure FirstLastChange(Sender : TObject);
      procedure ValueChange(Sender : TObject);

      procedure ResizeSequence(Size : Integer);

      procedure FireOnRearrange;

    protected
      procedure SetModule(Module : TModule); override;

    public

  end;

implementation

uses
  SysUtils;

const
  STEP_WIDTH = 19;

////////////////////////////////////////////////////////////////////////////////
// TUIModuleSequencerStep                                                     //
////////////////////////////////////////////////////////////////////////////////

constructor TUIModuleSequencerStep.Create(Parent : TWinControl; Sequencer : TUIModuleSequencer; Index : Integer);
begin
  inherited Create;

  FParent := Parent;
  FSequencer := Sequencer;
  FInputStep := Sequencer.FModule.InputStepValue[Index];
  FIndex := Index;

  FPositionLed := TUILed.Create(FParent);
  FPositionLed.Parent := FParent;
  FPositionLed.ImageCollection := TUIImageLibrary.GetInstance.GetImageCollection('position_led');
  FPositionLed.Tag := Integer(Pointer(Self));

  FSlider := TUISimpleSlider.Create(FParent);
  FSlider.Parent := FParent;
  FSlider.Tag := Integer(Pointer(Self));
  FSlider.OnChange := FSequencer.ValueChange;

  FLabel := TLabel.Create(FParent);
  FLabel.Parent := FParent;
  FLabel.Color := clBlack;
  FLabel.Font.Name := 'Small Fonts';
  FLabel.Font.Size := 6;
  FLabel.Font.Color := clWhite;
  FLabel.Alignment := taCenter;

  FTieButton := TUISwitchButton.Create(FParent);
  FTieButton.Parent := FParent;
  FTieButton.Tag := Integer(Pointer(Self));
  FTieButton.StateCount := 2;
  FTieButton.ImageCollection := TUIImageLibrary.GetInstance.GetImageCollection('tie_button');
  FTieButton.OnChange := FSequencer.ValueChange;
end;

destructor TUIModuleSequencerStep.Destroy;
begin
  inherited Destroy;
end;

procedure TUIModuleSequencerStep.SetValue(Value : TValue);
begin
  FSlider.Enabled := false;
  FSlider.Value := Value;

  FLabel.Caption := FInputStep.ValueProperties.ValueToStr(FInputStep.Value);
{
  case FSequencer.FValueRange of
    vr0_1   : FLabel.Caption := Format('%.2f', [Value]);
    vr1_1   : FLabel.Caption := Format('%.2f', [Value]);
    vr12_12 : FLabel.Caption := Format('%.0f', [Value]);
    vr24_24 : FLabel.Caption := Format('%.0f', [Value]);
  end;
}
  FSlider.Enabled := true;
end;

procedure TUIModuleSequencerStep.SetTie(Tie : Boolean);
begin
  FTieButton.Enabled := false;
  FTieButton.State := Integer(Tie);
  FTieButton.Enabled := true;
end;

procedure TUIModuleSequencerStep.UpdateValueTyp;
begin
  FSlider.Enabled := false;
  FSlider.MinValue := FInputStep.ValueProperties.MinValue;
  FSlider.MaxValue := FInputStep.ValueProperties.MaxValue;
  FSlider.StepSize := FInputStep.ValueProperties.StepSize;
  case FInputStep.ValueTyp of
    vt0_1:
      begin
        FSlider.StepSize := 0.01;
      end;
    vt1_1:
      begin
        FSlider.StepSize := 0.01;
      end;
    vt12_12:
      begin
        FSlider.StepSize := 1.0;
      end;
    vt24_24:
      begin
        FSlider.StepSize := 1.0;
      end;
  end;
  FSlider.Value := FInputStep.Value;
  FSlider.Enabled := true;
end;

////////////////////////////////////////////////////////////////////////////////
// TUIModuleSequencer                                                         //
////////////////////////////////////////////////////////////////////////////////

constructor TUIModuleSequencer.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FModule := nil;

  FInputMode := TUIInput.Create(FModulePanel);
  FInputMode.Parent := FModulePanel;
  FInputMode.Left := 5;
  FInputMode.Top := 5;
  FInputMode.Width := 150;
  FInputMode.Height := 20;

  FInputValueRange := TUIInput.Create(FModulePanel);
  FInputValueRange.Parent := FModulePanel;
  FInputValueRange.Left := 5;
  FInputValueRange.Top := 30;
  FInputValueRange.Width := 150;
  FInputValueRange.Height := 20;

  FInputPlayMode := TUIInput.Create(FModulePanel);
  FInputPlayMode.Parent := FModulePanel;
  FInputPlayMode.Left := 5;
  FInputPlayMode.Top := 55;
  FInputPlayMode.Width := 150;
  FInputPlayMode.Height := 20;

  FInputClockDiv := TUIInput.Create(FModulePanel);
  FInputClockDiv.Parent := FModulePanel;
  FInputClockDiv.Left := 5;
  FInputClockDiv.Top := 80;
  FInputClockDiv.Width := 150;
  FInputClockDiv.Height := 20;

  FInputFirstStep := TUIInput.Create(FModulePanel);
  FInputFirstStep.Parent := FModulePanel;
  FInputFirstStep.Left := 5;
  FInputFirstStep.Top := 105;
  FInputFirstStep.Width := 150;
  FInputFirstStep.Height := 20;

  FInputLastStep := TUIInput.Create(FModulePanel);
  FInputLastStep.Parent := FModulePanel;
  FInputLastStep.Left := 5;
  FInputLastStep.Top := 130;
  FInputLastStep.Width := 150;
  FInputLastStep.Height := 20;

  FInputClock := TUIInput.Create(FModulePanel);
  FInputClock.Parent := FModulePanel;
  FInputClock.Left := 5;
  FInputClock.Top := 155;
  FInputClock.Width := 150;
  FInputClock.Height := 20;

  FSequencePanel := TPanel.Create(FModulePanel);
  FSequencePanel.Parent := FModulePanel;
  FSequencePanel.Left := 160;
  FSequencePanel.Top := 5;
  FSequencePanel.Width := 640;
  FSequencePanel.Height := 200;
  FSequencePanel.Color := clBlack;
  FSequencePanel.BevelOuter := bvNone;

  FStepList := TList.Create;

{
  FFirstLast := TUIFirstLastIndicator.Create(FSequencePanel);
  FFirstLast.Parent := FSequencePanel;
  FFirstLast.OnChange := FirstLastChange;


  FShowFirstLast := true;
  FShowPosition := true;
}
end;

destructor TUIModuleSequencer.Destroy;
begin
  ResizeSequence(0);

  FStepList.Destroy;

  inherited Destroy;
end;

procedure TUIModuleSequencer.Rearrange;
var
  Index : Integer;
  X : Integer;
  Y, Y1 : Integer;
  ValueDisplayMode : TUIValueDisplayMode;
  OldVisible : Boolean;
  ShowTie : Boolean;
begin
  if not Assigned(FModule) then Exit;

  OldVisible := Visible;
  Visible := false;

  FModulePanel.Width := 800;
  FModulePanel.Height := 180;

  Y := 0;

  FSequencePanel.Width := FStepList.Count * STEP_WIDTH;
  FSequencePanel.Height := 100;

  ShowTie := TSequencerMode(FModule.InputMode.IntValue) = smGate;

{
  if FShowFirstLast then
  begin
    FFirstLast.Visible := true;
    FFirstLast.Left := 0;
    FFirstLast.Top := Y;
    FFirstLast.Width := FStepList.Count * STEP_WIDTH;
    FFirstLast.Height := 8;
    inc(Y, 8);
  end else
  begin
    FFirstLast.Visible := false;
  end;
}

  for Index := 0 to FStepList.Count - 1 do
  with TUIModuleSequencerStep(FStepList[Index]) do
  begin
    X := Index * STEP_WIDTH;
    Y1 := Y;

    FPositionLed.Left := X;
    FPositionLed.Top := Y1;
    FPositionLed.Width := STEP_WIDTH;
    FPositionLed.Height := 16;
    inc(Y1, 16);

    FSlider.Left := X;
    FSlider.Top := Y1;
    FSlider.Width := STEP_WIDTH;
    FSlider.Height := 120;
    inc(Y1, 120);

    FLabel.Left := X;
    FLabel.Top := Y1;
    FLabel.Width := STEP_WIDTH;
    FLabel.Height := 20;
    inc(Y1, 20);

    if ShowTie then
    begin
      FTieButton.Visible := true;
      FTieButton.Left := X;
      FTieButton.Top := Y1;
      FTieButton.Width := STEP_WIDTH;
      FTieButton.Height := 24;
      inc(Y1, 24);
    end else
    begin
      FTieButton.Visible := false;
    end;
  end;

  Y := Y1;

  FSequencePanel.Height := Y;

//  FModulePanel.Height := Y;

  Visible := OldVisible;
  
  inherited Rearrange;
end;

procedure TUIModuleSequencer.Render;
var
  Index : Integer;
  Step : TUIModuleSequencerStep;
begin
  for Index := 0 to FStepList.Count - 1 do
  begin
    Step := FStepList[Index];
    if Index = FModule.InputPosition.IntValue then
      Step.FPositionLed.State := 1
    else
      Step.FPositionLed.State := 0;
  end;
end;

procedure TUIModuleSequencer.UpdateSequence;
begin
end;

procedure TUIModuleSequencer.UpdateModule;
var
  Index : Integer;
begin
{
  // Update first/last indicator
  FFirstLast.Enabled := false;
  FFirstLast.First := FModule.Sequence.First;
  FFirstLast.Last := FModule.Sequence.Last;
  FFirstLast.Enabled := true;
}

  // Update step display
  for Index := 0 to FStepList.Count - 1 do
  begin
//    TUIModuleSequencerStep(FStepList[Index]).SetTie(FModule.Sequence.Step[Index].Tie);
    TUIModuleSequencerStep(FStepList[Index]).SetValue(FModule.InputStepValue[Index].Value);
  end;

  inherited UpdateModule;
end;

procedure TUIModuleSequencer.UpdateStepValueTyp;
var
  Index : Integer;
begin
  for Index := 0 to FStepList.Count - 1 do
    TUIModuleSequencerStep(FStepList[Index]).UpdateValueTyp;
end;

procedure TUIModuleSequencer.InputModeChange(Sender : TObject);
begin
  FModule.UpdateStepValueTyp;
  UpdateStepValueTyp;
  Rearrange;
  UpdateModule;
end;

procedure TUIModuleSequencer.InputValueRangeChange(Sender : TObject);
begin
  FModule.UpdateStepValueTyp;
  UpdateStepValueTyp;
  Rearrange;
  UpdateModule;
end;

procedure TUIModuleSequencer.FirstLastChange(Sender : TObject);
begin
//  FModule.Sequence.First := FFirstLast.First;
//  FModule.Sequence.Last := FFirstLast.Last;
end;

procedure TUIModuleSequencer.ValueChange(Sender : TObject);
var
  Step : TUIModuleSequencerStep;
  Slider : TUISimpleSlider;
  Rotary : TUIRotary;
  SwitchButton : TUISwitchButton;
begin
  if Sender is TUISimpleSlider then
  begin
    Slider := Sender as TUISimpleSlider;
    Step := TUIModuleSequencerStep(Pointer(Slider.Tag));
    FModule.InputStepValue[Step.FIndex].Value := Slider.Value;
    Step.SetValue(Slider.Value);
  end;
end;

procedure TUIModuleSequencer.ResizeSequence(Size : Integer);
var
  OldSize : Integer;
  Index : Integer;
begin
  OldSize := FStepList.Count;
  if Size >= OldSize then
  begin
    for Index := OldSize to Size - 1 do
    begin
      FStepList.Add(TUIModuleSequencerStep.Create(FSequencePanel, Self, Index));
    end;
  end else
  begin
    for Index := OldSize - 1 downto Size do
    begin
      TUIModuleSequencerStep(FStepList[Index]).Destroy;
      FStepList.Delete(Index);
    end;
  end;
end;

procedure TUIModuleSequencer.FireOnRearrange;
begin
  if Assigned(FOnRearrange) and Enabled then
    FOnRearrange(Self);
end;

procedure TUIModuleSequencer.SetModule(Module : TModule);
begin
  FModule := Module as TModuleSequencer;

  FInputMode.Input := FModule.InputMode;
  FInputValueRange.Input := FModule.InputValueRange;
  FInputPlayMode.Input := FModule.InputPlayMode;
  FInputClockDiv.Input := FModule.InputClockDiv;
  FInputFirstStep.Input := FModule.InputFirstStep;
  FInputLastStep.Input := FModule.InputLastStep;
  FInputClock.Input := FModule.InputClock;

  ResizeSequence(FModule.Size);

  FInputMode.OnChange := InputModeChange;
  FInputValueRange.OnChange := InputValueRangeChange;

  UpdateStepValueTyp;

  inherited SetModule(Module);
end;

end.
