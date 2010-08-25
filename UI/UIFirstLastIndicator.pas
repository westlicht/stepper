unit UIFirstLastIndicator;

interface

uses
  Graphics,
  Classes,
  Types,
  Controls,
  Forms,
  UIImageLibrary;

type
  TUIFirstLastIndicator = class(TGraphicControl)
    private
      FBackground : TColor;
      FColor : TColor;
      FStepCount : Integer;
      FFirst : Integer;
      FLast : Integer;

      FDragFirst : Boolean;
      FDragLast : Boolean;

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

      procedure SetStepCount(StepCount : Integer);
      procedure SetFirst(First : Integer);
      procedure SetLast(Last : Integer);

    public
      property  Background : TColor read FBackground write FBackground;
      property  Color : TColor read FColor write FColor;
      property  StepCount : Integer read FStepCount write SetStepCount;
      property  First : Integer read FFirst write SetFirst;
      property  Last : Integer read FLast write SetLast;

      property  OnChange : TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

uses
  SysUtils;

constructor TUIFirstLastIndicator.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FBackground := clBlack;
  FColor := clWhite;
  FStepCount := 1;
  FFirst := 0;
  FLast := 0;
end;

destructor TUIFirstLastIndicator.Destroy;
begin
  inherited Destroy;
end;

procedure TUIFirstLastIndicator.Click;
begin
end;

procedure TUIFirstLastIndicator.MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  if Button = mbLeft then
  begin
    Self.MouseCapture := true;
    Screen.Cursor := crCross;
    FDragFirst := true;
    MouseMove([], X, Y);
  end else if Button = mbRight then
  begin
    Self.MouseCapture := true;
    Screen.Cursor := crCross;
    FDragLast := true;
    MouseMove([], X, Y);
  end;
end;

procedure TUIFirstLastIndicator.MouseUp(Button : TMouseButton; Shift : TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    Self.MouseCapture := false;
    Screen.Cursor := crDefault;
    FDragFirst := false;
  end else if Button = mbRight then
  begin
    Self.MouseCapture := false;
    Screen.Cursor := crDefault;
    FDragLast := false;
  end;
end;

procedure TUIFirstLastIndicator.MouseMove(Shift : TShiftState; X, Y : Integer);
begin
  if FDragFirst then
  begin
    SetFirst(X div (ClientWidth div FStepCount));
  end;

  if FDragLast then
  begin
    SetLast(X div (ClientWidth div FStepCount));
  end;
end;

procedure TUIFirstLastIndicator.Paint;
var
  StepWidth : Integer;
  Index : Integer;
  X1, X2 : Integer;
begin
  Canvas.Pen.Color := FBackground;
  Canvas.Pen.Style := psSolid;
  Canvas.Brush.Color := FBackground;
  Canvas.Brush.Style := bsSolid;
  Canvas.Rectangle(0, 0, ClientWidth, ClientHeight);

  StepWidth := ClientWidth div FStepCount;

  // Draw scale
  Canvas.Pen.Color := clGray;
  Canvas.Pen.Width := 1;

  Canvas.MoveTo(0, 0);
  Canvas.LineTo(ClientWidth, 0);

  for Index := 0 to FStepCount do
  begin
    X1 := Index * StepWidth;
    if Index = FStepCount then
      dec(X1);
    Canvas.MoveTo(X1, 0);
    Canvas.LineTo(X1, ClientHeight);
  end;

  X1 := FFirst * StepWidth;
  X2 := (FLast + 1) * StepWidth - 1;
  if FLast + 1 < FStepCount then
    inc(X2);

  Canvas.Pen.Color := FColor;
  Canvas.Pen.Width := 3;

  Canvas.MoveTo(X1, 1);
  Canvas.LineTo(X1, ClientHeight div 2);

  Canvas.MoveTo(X2, 1);
  Canvas.LineTo(X2, ClientHeight div 2);

  Canvas.MoveTo(X1, 1);
  Canvas.LineTo(X2, 1);
end;

procedure TUIFirstLastIndicator.FireOnChange;
begin
  if Assigned(FOnChange) and Enabled then
    FOnChange(Self);
end;

procedure TUIFirstLastIndicator.SetStepCount(StepCount : Integer);
begin
  if StepCount <> FStepCount then
  begin
    FStepCount := StepCount;
    if FStepCount < 1 then FStepCount := 1;
    SetLast(Last);
    FireOnChange;
    Paint;
  end;
end;

procedure TUIFirstLastIndicator.SetFirst(First : Integer);
begin
  if First <> FFirst then
  begin
    FFirst := First;
    if FFirst < 0 then FFirst := 0;
    if FFirst >= FStepCount then FFirst := FStepCount - 1;
    if FFirst > FLast then FLast := FFirst;
    FireOnChange;
    Paint;
  end;
end;

procedure TUIFirstLastIndicator.SetLast(Last : Integer);
begin
  if Last <> FLast then
  begin
    FLast := Last;
    if FLast < 0 then FLast := 0;
    if FLast >= FStepCount then FLast := FStepCount - 1;
    if FLast < FFirst then FFirst := FLast;
    FireOnChange;
    Paint;
  end;
end;

end.
