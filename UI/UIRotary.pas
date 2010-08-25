unit UIRotary;

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
  TUIRotary = class(TGraphicControl)
    private
      FBackground : TColor;
      FImageCollection : TUIImageCollection;
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
      property  ImageCollection : TUIImageCollection read FImageCollection write FImageCollection;
      property  DisplayMode : TUIValueDisplayMode read FDisplayMode write SetDisplayMode;
      property  MinValue : Integer read FMinValue write SetMinValue;
      property  MaxValue : Integer read FMaxValue write SetMaxValue;
      property  Value : Integer read FValue write SetValue;

      property  OnChange : TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

uses
  SysUtils;

constructor TUIRotary.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FBackground := clBlack;
  FImageCollection := nil;
  FDisplayMode := dmValue; 
  FMinValue := 0;
  FMaxValue := 100;
  FValue := 50;
end;

destructor TUIRotary.Destroy;
begin
  inherited Destroy;
end;

procedure TUIRotary.Click;
begin
end;

procedure TUIRotary.MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
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

procedure TUIRotary.MouseUp(Button : TMouseButton; Shift : TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    Screen.Cursor := crDefault;
    Self.MouseCapture := false;
    FDragEnabled := false;
    Mouse.CursorPos := ClientToScreen(FDragOrigin);
  end;
end;

procedure TUIRotary.MouseMove(Shift : TShiftState; X, Y : Integer);
begin
  if FDragEnabled then
  begin
    SetValue(FValueOrigin - (Y - FDragOrigin.Y) div 3);
    
  end;
end;

procedure TUIRotary.Paint;
var
  Dst : TRect;
  Angle : Single;
  Radius : Single;
  X, Y : Integer;
  Text : String;
begin
  Canvas.Pen.Color := FBackground;
  Canvas.Pen.Style := psSolid;
  Canvas.Brush.Color := FBackground;
  Canvas.Brush.Style := bsSolid;
  Canvas.Rectangle(0, 0, ClientWidth, ClientHeight);

  Canvas.Pen.Color := clGray;
  Canvas.Arc(1, 1, ClientWidth - 2, ClientHeight - 2, ClientWidth, ClientHeight, 0, ClientHeight);
  Canvas.Pen.Color := clWhite;

  Angle := (FValue - FMinValue) / (FMaxValue - FMinValue) * (PI / 2 * 3) + PI / 4;

  Radius := ClientWidth / 2 - 3;
  X := Round((ClientWidth / 2) - Sin(Angle) * Radius);
  Y := Round((ClientWidth / 2) + Cos(Angle) * Radius);
  Canvas.MoveTo(X, Y);
  Radius := ClientWidth / 2;
  X := Round((ClientWidth / 2) - Sin(Angle) * Radius);
  Y := Round((ClientWidth / 2) + Cos(Angle) * Radius);
  Canvas.LineTo(X, Y);

  Text := UIFormatValue(Value, FDisplayMode);

  Dst.Left := 0;
  Dst.Top := 0;
  Dst.Right := ClientWidth;
  Dst.Bottom := ClientHeight;
  Canvas.Brush.Style := bsClear;
  Canvas.Font.Color := clWhite;
  Canvas.Font.Height := 8;
  Canvas.TextRect(
    Dst,
    (ClientWidth - Canvas.TextWidth(Text)) div 2,
    (ClientHeight - Canvas.TextHeight(Text)) div 2,
    Text
  );

  if not Assigned(FImageCollection) then
    Exit;

{  Bitmap := FImageCollection.BitmapList[FState];

  Src.Left := 0;
  Src.Top := 0;
  Src.Right := Bitmap.Width;
  Src.Bottom := Bitmap.Height;

  Dst.Left := (ClientWidth - Bitmap.Width) div 2;
  Dst.Top := (ClientHeight - Bitmap.Height) div 2;
  Dst.Right := Dst.Left + Bitmap.Width;
  Dst.Bottom := Dst.Top + Bitmap.Height;

  Canvas.CopyRect(Dst, Bitmap.Canvas, Src);}
end;

procedure TUIRotary.FireOnChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TUIRotary.SetDisplayMode(DisplayMode : TUIValueDisplayMode);
begin
  if DisplayMode <> FDisplayMode then
  begin
    FDisplayMode := DisplayMode;
    Paint;
  end;
end;

procedure TUIRotary.SetMinValue(MinValue : Integer);
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

procedure TUIRotary.SetMaxValue(MaxValue : Integer);
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

procedure TUIRotary.SetValue(Value : Integer);
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
