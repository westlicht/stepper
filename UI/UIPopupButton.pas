unit UIPopupButton;

interface

uses
  Graphics,
  Classes,
  Types,
  Controls,
  Menus,
  UIImageLibrary;

type
  TUIPopupButton = class(TGraphicControl)
    private
      FValueList : TStringList;
      FSelected : Integer;
      FPopupMenu : TPopupMenu;

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
      procedure UpdateMenu;
      procedure PopupMenuClick(Sender : TObject);

      procedure SetSelected(Selected : Integer);

    public
      property  ValueList : TStringList read FValueList;
      property  Selected : Integer read FSelected write SetSelected;
      property  OnChange : TNotifyEvent read FOnChange write FOnChange;

  end;

implementation

constructor TUIPopupButton.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FValueList := TStringList.Create;
  FSelected := 0;
  FPopupMenu := TPopupMenu.Create(Self);
end;

destructor TUIPopupButton.Destroy;
begin
  FValueList.Destroy;

  inherited Destroy;
end;

procedure TUIPopupButton.Click;
var
  P : TPoint;
begin
  UpdateMenu;
  P := ClientToScreen(Point(0, 0));
  FPopupMenu.Popup(P.X, P.Y);
end;

procedure TUIPopupButton.MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
end;

procedure TUIPopupButton.MouseUp(Button : TMouseButton; Shift : TShiftState; X, Y: Integer);
begin
end;

procedure TUIPopupButton.MouseMove(Shift : TShiftState; X, Y : Integer);
begin
end;

procedure TUIPopupButton.Paint;
var
  Dst : TRect;
begin
  Canvas.Pen.Color := clGray;
  Canvas.Pen.Style := psSolid;
  Canvas.Brush.Color := clBlack;
  Canvas.Brush.Style := bsSolid;
  Canvas.Rectangle(0, 0, ClientWidth, ClientHeight);

  if (FSelected >= 0) or (FSelected < FValueList.Count) then
    Text := FValueList[FSelected]
  else
    Text := '';

  Dst.Left := 0;
  Dst.Top := 0;
  Dst.Right := ClientWidth;
  Dst.Bottom := ClientHeight;
  Canvas.Font.Color := clWhite;
  Canvas.Brush.Style := bsClear;
  Canvas.Font.Height := 8;
  Canvas.TextRect(
    Dst,
    (ClientWidth - Canvas.TextWidth(Text)) div 2,
    (ClientHeight - Canvas.TextHeight(Text)) div 2,
    Text
  );
end;

procedure TUIPopupButton.UpdateMenu;
var
  Index : Integer;
  Item : TMenuItem;
begin
  FPopupMenu.Items.Clear;
  for Index := 0 to FValueList.Count - 1 do
  begin
    Item := TMenuItem.Create(nil);
    Item.Caption := FValueList[Index];
    Item.Tag := Index;
    Item.OnClick := PopupMenuClick;
    FPopupMenu.Items.Add(Item);
  end;
end;

procedure TUIPopupButton.PopupMenuClick(Sender : TObject);
begin
  FSelected := (Sender as TMenuItem).Tag;
  Paint;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TUIPopupButton.SetSelected(Selected : Integer);
begin
  if Selected <> FSelected then
  begin
    FSelected := Selected;
    if FSelected < 0 then
      FSelected := 0;
    if FSelected >= FValueList.Count then
      FSelected := FValueList.Count - 1;
  end;
end;

end.
