unit UISimpleSlider;

interface

uses
  Graphics,
  Classes,
  Types,
  Controls,
  Forms,
  UIImageLibrary,
  EngineTypes;

type
  TUISimpleSlider = class(TGraphicControl)
    private
      FBackground : TColor;
      FColor : TColor;
      FBorderColor : TColor;
      FMinValue : TValue;
      FMaxValue : TValue;
      FValue : TValue;
      FStepSize : TValue;

      FOnChange : TNotifyEvent;

    public
      constructor Create(AOwner : TComponent); override;
      destructor Destroy; override;
      procedure Click; override;

    protected
      procedure MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer); override;
      procedure MouseUp(Button : TMouseButton; Shift : TShiftState; X, Y: Integer); override;
      procedure MouseMove(Shift : TShiftState; X, Y : Integer); override;
      procedure Paint; override;

    private
      procedure FireOnChange;

      procedure SetMinValue(MinValue : TValue);
      procedure SetMaxValue(MaxValue : TValue);
      procedure SetValue(Value : TValue);
      procedure SetStepSize(StepSize : TValue);

    public
      property  Background : TColor read FBackground write FBackground;
      property  Color : TColor read FColor write FColor;
      property  BorderColor : TColor read FBorderColor write FBorderColor;
      property  MinValue : TValue read FMinValue write SetMinValue;
      property  MaxValue : TValue read FMaxValue write SetMaxValue;
      property  Value : TValue read FValue write SetValue;
      property  StepSize : TValue read FStepSize write SetStepSize; 

      property  OnChange : TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

uses
  SysUtils;

var
  _MouseDown : Boolean;

constructor TUISimpleSlider.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FBackground := clBlack;
  FColor := clGreen;
  FBorderColor := clLime;
  FMinValue := 0;
  FMaxValue := 100;
  FValue := 50;
  FStepSize := 1.0;
end;

destructor TUISimpleSlider.Destroy;
begin
  inherited Destroy;
end;

procedure TUISimpleSlider.Click;
begin
end;

procedure TUISimpleSlider.MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  if Button = mbLeft then
  begin
    Screen.Cursor := crCross;
    _MouseDown := true;
  end;
end;

procedure TUISimpleSlider.MouseUp(Button : TMouseButton; Shift : TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    Screen.Cursor := crDefault;
    _MouseDown := false;
  end;
end;

procedure TUISimpleSlider.MouseMove(Shift : TShiftState; X, Y : Integer);
var
  NewValue : TValue;
begin
  if _MouseDown or (ssShift in Shift) then
  begin
    NewValue := (1.0 - Y / ClientHeight) * (FMaxValue - FMinValue) + FMinValue;
    SetValue(NewValue);
  end;
end;

procedure TUISimpleSlider.Paint;
var
  SliderHeight : Integer;
begin
  Canvas.Pen.Color := FBackground;
  Canvas.Pen.Style := psSolid;
  Canvas.Brush.Color := FBackground;
  Canvas.Brush.Style := bsSolid;
  Canvas.Rectangle(0, 0, ClientWidth, ClientHeight);

  SliderHeight := trunc(((FValue - FMinValue) / (FMaxValue - FMinValue)) * ClientHeight);
  Canvas.Pen.Color := BorderColor;
  Canvas.Brush.Color := Color;
  Canvas.Rectangle(1, ClientHeight - SliderHeight, ClientWidth - 2, ClientHeight + 1);
{
  Canvas.Brush.Style := bsClear;

  Dst.Left := 0;
  Dst.Top := 0;
  Dst.Right := ClientWidth;
  Dst.Bottom := ClientHeight;
  Canvas.Font.Color := clWhite;
  Canvas.Font.Height := 8;
  Canvas.TextRect(
    Dst,
    (ClientWidth - Canvas.TextWidth(Text)) div 2,
    (ClientHeight - Canvas.TextHeight(Text)) div 2,
    IntToStr(Value)
  );
}
end;

procedure TUISimpleSlider.FireOnChange;
begin
  if Assigned(FOnChange) and Enabled then
    FOnChange(Self);
end;

procedure TUISimpleSlider.SetMinValue(MinValue : TValue);
begin
  if MinValue <> FMinValue then
  begin
    FMinValue := MinValue;
    if FMinValue > FMaxValue then
      FMinValue := FMaxValue;
    if FValue < FMinValue then
      FValue := FMinValue;
    Paint;
    FireOnChange;
  end;
end;

procedure TUISimpleSlider.SetMaxValue(MaxValue : TValue);
begin
  if MaxValue <> FMaxValue then
  begin
    FMaxValue := MaxValue;
    if FMaxValue < FMinValue then
      FMaxValue := FMinValue;
    if FValue > FMaxValue then
      FValue := FMaxValue;
    Paint;
    FireOnChange;
  end;
end;

procedure TUISimpleSlider.SetValue(Value : TValue);
begin
  if Value <> FValue then
  begin
    FValue := Value;
    if FValue > FMaxValue then
      FValue := FMaxValue;
    if FValue < FMinValue then
      FValue := FMinValue;
    FValue := trunc(FValue / FStepSize) * FStepSize;
    Paint;
    FireOnChange;
  end;
end;

procedure TUISimpleSlider.SetStepSize(StepSize : TValue);
begin
  FStepSize := StepSize;
  SetValue(FValue);
end;

end.
