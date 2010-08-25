unit UIScope;

interface

uses
  Graphics,
  Classes,
  Types,
  Controls,
  Forms,
  UIColors,
  UIImageLibrary;

type
  TUIScopeOnGetSample = function(Index : Integer) : Single of object;

  TUIScope = class(TGraphicControl)
    private
      FSize : Integer;
      FBorderSize : Integer;
      FRangeStart : Single;
      FRangeEnd : Single;
      FBackground : TColor;
      FGraphColor : TColor;
      FBorderColor : TColor;
      FBackbuffer : TBitmap;

      FOnGetSample : TUIScopeOnGetSample;

    public
      constructor Create(AOwner : TComponent); override;
      destructor Destroy; override;

    protected
      procedure Paint; override;

    private
      procedure DrawBackbuffer;
      function  GetSample(Index : Integer) : Single;

    public
      property  Size : Integer read FSize write FSize;
      property  BorderSize : Integer read FBorderSize write FBorderSize;
      property  RangeStart : Single read FRangeStart write FRangeStart;
      property  RangeEnd : Single read FRangeEnd write FRangeEnd;
      property  Background : TColor read FBackground write FBackground;
      property  GraphColor : TColor read FGraphColor write FGraphColor;
      property  BorderColor : TColor read FBorderColor write FBorderColor;

      property  OnGetSample : TUIScopeOnGetSample read FOnGetSample write FOnGetSample;

  end;

implementation

uses
  SysUtils;

constructor TUIScope.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FBackground := UI_COLOR_BACKGROUND_DARK;
  FGraphColor := UI_COLOR_FONT_DARK;
  FBorderColor := UI_COLOR_FONT_LIGHT;
  FSize := 0;
  FRangeStart := -1.0;
  FRangeEnd := 1.0;
  FBackbuffer := TBitmap.Create;
  FBackbuffer.PixelFormat := pf24bit;
end;

destructor TUIScope.Destroy;
begin
  FBackbuffer.Destroy;
  
  inherited Destroy;
end;

procedure TUIScope.Paint;
var
  Region : TRect;
begin
  DrawBackbuffer;
  Region.Left := 0;
  Region.Top := 0;
  Region.Right := ClientWidth;
  Region.Bottom := ClientHeight;
  Canvas.CopyRect(Region, FBackbuffer.Canvas, Region);
end;

procedure TUIScope.DrawBackbuffer;
var
  Index : Integer;
  X, Y : Integer;
  Range : Single;
  ScopeWidth : Integer;
  ScopeHeight : Integer;

  function GetY : Integer;
  begin
    Result := Round((1.0 - ((GetSample(FSize - Index - 1) - FRangeStart) / Range)) * ScopeHeight);
  end;

begin
  FBackbuffer.Width := ClientWidth;
  FBackbuffer.Height := ClientHeight;

  FBackbuffer.Canvas.Pen.Color := FBorderColor;
  FBackbuffer.Canvas.Pen.Style := psSolid;
  FBackbuffer.Canvas.Brush.Color := FBackground;
  FBackbuffer.Canvas.Brush.Style := bsSolid;
  FBackbuffer.Canvas.Rectangle(0, 0, ClientWidth, ClientHeight);

  if not Enabled then Exit;

  FBackbuffer.Canvas.Pen.Color := FGraphColor;

  Range := FRangeEnd - FRangeStart;
  ScopeWidth := ClientWidth - FBorderSize * 2;
  ScopeHeight := ClientHeight - FBorderSize * 2;

  Index := 0;
  FBackbuffer.Canvas.MoveTo(FBorderSize, FBorderSize + GetY);

  for Index := 1 to FSize - 1 do
  begin
    X := FBorderSize + Round((Index / (FSize - 1)) * ScopeWidth);
    Y := FBorderSize + GetY;
    FBackbuffer.Canvas.LineTo(X, Y);
  end;
end;

function  TUIScope.GetSample(Index : Integer) : Single;
begin
  if Assigned(FOnGetSample) then
    Result := FOnGetSample(Index)
  else
    Result := 0.0;
end;

end.
