unit UILed;

interface

uses
  Classes,
  Graphics,
  Controls,
  Types,
  UIImageLibrary;

type
  TUILed = class(TGraphicControl)
    private
      FBackground : TColor;
      FState : Integer;
      FImageCollection : TUIImageCollection;

    public
      constructor Create(AOwner : TComponent); override;
      destructor Destroy; override;

    protected
      procedure Paint; override;

    private
      procedure SetState(State : Integer);

    public
      property  Background : TColor read FBackground write FBackground;
      property  State : Integer read FState write SetState;
      property  ImageCollection : TUIImageCollection read FImageCollection write FImageCollection;

  end;

implementation

constructor TUILed.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FBackground := clBlack;
  FState := 0;
  FImageCollection := nil;
end;

destructor TUILed.Destroy;
begin
  inherited Destroy;
end;

procedure TUILed.Paint;
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

procedure TUILed.SetState(State : Integer);
begin
  if State <> FState then
  begin
    FState := State;
    Paint;
  end;
end;

end.

