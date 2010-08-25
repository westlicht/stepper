unit UISwitchButton;

interface

uses
  Graphics,
  Classes,
  Types,
  Controls,
  UIImageLibrary;

type
  TUISwitchButton = class(TGraphicControl)
    private
      FBackground : TColor;
      FState : Integer;
      FStateCount : Integer;
      FImageCollection : TUIImageCollection;

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

      procedure SetState(State : Integer);
      procedure SetStateCount(StateCount : Integer);

    public
      property  Background : TColor read FBackground write FBackground;
      property  State : Integer read FState write SetState;
      property  StateCount : Integer read FStateCount write SetStateCount;
      property  ImageCollection : TUIImageCollection read FImageCollection write FImageCollection;
      property  OnChange : TNotifyEvent read FOnChange write FOnChange;

  end;

implementation

constructor TUISwitchButton.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FBackground := clBlack;
  FState := 0;
  FImageCollection := nil;
end;

destructor TUISwitchButton.Destroy;
begin
  inherited Destroy;
end;

procedure TUISwitchButton.Click;
begin
  if FStateCount > 0 then
    SetState((FState + 1) mod FStateCount);
end;

procedure TUISwitchButton.MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
end;

procedure TUISwitchButton.MouseUp(Button : TMouseButton; Shift : TShiftState; X, Y: Integer);
begin
end;

procedure TUISwitchButton.MouseMove(Shift : TShiftState; X, Y : Integer);
begin
end;

procedure TUISwitchButton.Paint;
var
  Bitmap : TBitmap;
  Src, Dst : TRect;
begin
  Canvas.Pen.Color := FBackground;
  Canvas.Pen.Style := psSolid;
  Canvas.Brush.Color := FBackground;
  Canvas.Brush.Style := bsSolid;
  Canvas.Rectangle(0, 0, ClientWidth, ClientHeight);

  if not Assigned(FImageCollection) then
    Exit;

  if FState >= FImageCollection.BitmapList.Count then
    Exit;

  Bitmap := FImageCollection.BitmapList[FState];

  Src.Left := 0;
  Src.Top := 0;
  Src.Right := Bitmap.Width;
  Src.Bottom := Bitmap.Height;

  Dst.Left := (ClientWidth - Bitmap.Width) div 2;
  Dst.Top := (ClientHeight - Bitmap.Height) div 2;
  Dst.Right := Dst.Left + Bitmap.Width;
  Dst.Bottom := Dst.Top + Bitmap.Height;

  Canvas.CopyRect(Dst, Bitmap.Canvas, Src);
end;

procedure TUISwitchButton.FireOnChange;
begin
  if Assigned(FOnChange) and Enabled then
    FOnChange(Self);
end;

procedure TUISwitchButton.SetState(State : Integer);
begin
  if State <> FState then
  begin
    FState := State;
    FireOnChange;
    Paint;
  end;
end;

procedure TUISwitchButton.SetStateCount(StateCount : Integer);
begin
  if StateCount <> FStateCount then
  begin
    FStateCount := StateCount;
    if FState >= FStateCount then
      SetState(FStateCount - 1); 
  end;
end;

end.
