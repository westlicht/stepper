unit UISpinEdit;

interface

uses
  Graphics,
  Classes,
  Types,
  Controls,
  Forms,
  UITypes,
  UIImageLibrary;

type
  TUISpinEdit = class(TGraphicControl)
    private
      FBackground : TColor;
      FDisplayMode : TUIValueDisplayMode;
      FMinValue : Integer;
      FMaxValue : Integer;
      FValue : Integer;

      FDragEnabled : Boolean;
      FDragOrigin : TPoint;
      FValueOrigin : Integer;

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

      procedure SetDisplayMode(DisplayMode : TUIValueDisplayMode);
      procedure SetMinValue(MinValue : Integer);
      procedure SetMaxValue(MaxValue : Integer);
      procedure SetValue(Value : Integer);

    public
      property  Background : TColor read FBackground write FBackground;
      property  DisplayMode : TUIValueDisplayMode read FDisplayMode write SetDisplayMode;
      property  MinValue : Integer read FMinValue write SetMinValue;
      property  MaxValue : Integer read FMaxValue write SetMaxValue;
      property  Value : Integer read FValue write SetValue;

      property  OnChange : TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

uses
  SysUtils;

constructor TUISpinEdit.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FBackground := clBlack;
  FDisplayMode := dmValue;
  FMinValue := 0;
  FMaxValue := 100;
  FValue := 50;
end;

destructor TUISpinEdit.Destroy;
begin
  inherited Destroy;
end;

procedure TUISpinEdit.Click;
begin
end;

procedure TUISpinEdit.MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  if Button = mbLeft then
  begin
    Screen.Cursor := crCross;
    Self.MouseCapture := true;
    FDragEnabled := true;
    FDragOrigin := Point(X, Y);
    FValueOrigin := FValue;
  end;
end;

procedure TUISpinEdit.MouseUp(Button : TMouseButton; Shift : TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    Screen.Cursor := crDefault;
    Self.MouseCapture := false;
    FDragEnabled := false;
    Mouse.CursorPos := ClientToScreen(FDragOrigin);
  end;
end;

procedure TUISpinEdit.MouseMove(Shift : TShiftState; X, Y : Integer);
begin
  if FDragEnabled then
  begin
    SetValue(FValueOrigin - (Y - FDragOrigin.Y) div 3);
    
  end;
end;

procedure TUISpinEdit.Paint;
var
  Dst : TRect;
  Text : String;
begin
  Canvas.Pen.Color := FBackground;
  Canvas.Pen.Style := psSolid;
  Canvas.Brush.Color := FBackground;
  Canvas.Brush.Style := bsSolid;
  Canvas.Rectangle(0, 0, ClientWidth, ClientHeight);

  Text := UIFormatValue(Value, FDisplayMode);

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
    Text
  );
end;

procedure TUISpinEdit.FireOnChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TUISpinEdit.SetDisplayMode(DisplayMode : TUIValueDisplayMode);
begin
  if DisplayMode <> FDisplayMode then
  begin
    FDisplayMode := DisplayMode;
    Paint;
  end;
end;

procedure TUISpinEdit.SetMinValue(MinValue : Integer);
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

procedure TUISpinEdit.SetMaxValue(MaxValue : Integer);
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

procedure TUISpinEdit.SetValue(Value : Integer);
begin
  if Value <> FValue then
  begin
    FValue := Value;
    if FValue > FMaxValue then
      FValue := FMaxValue;
    if FValue < FMinValue then
      FValue := FMinValue;
    Paint;
    FireOnChange;
  end;
end;

end.
