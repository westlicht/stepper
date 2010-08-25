unit UIInput;

interface

uses
  Graphics,
  Classes,
  Types,
  Controls,
  Forms,
  Menus,
  UITypes,
  UIImageLibrary,
  EngineTypes,
  ValueTypes,
  Document;

type
  TUIInput = class(TGraphicControl)
    private
      FBackground : TColor;
      FInput : TInput;

      FMinValue : TValue;
      FMaxValue : TValue;
      FStepSize : TValue;
      FStepSizeFine : TValue;

      FDragEnabled : Boolean;
      FDragOrigin : TPoint;
      FValueOrigin : TValue;

      FSelectMenu : TPopupMenu;
      FEnumMenu : TPopupMenu;

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
      procedure UpdateSelectMenu;
      procedure UpdateEnumMenu;
      procedure FireOnChange;

      procedure SelectMenuClick(Sender : TObject);
      procedure EnumMenuClick(Sender : TObject);

      procedure SetInput(Input : TInput);
      function  GetValue : TValue;
      procedure SetValue(Value : TValue);
      function  GetIntValue : Integer;

    public
      property  Input : TInput read FInput write SetInput;
      property  Value : TValue read GetValue write SetValue;
      property  IntValue : Integer read GetIntValue;
      property  Background : TColor read FBackground write FBackground;

      property  OnChange : TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

uses
  SysUtils;

constructor TUIInput.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FBackground := clBlack;
  FSelectMenu := TPopupMenu.Create(Self);
  FEnumMenu := TPopupMenu.Create(Self);
  Self.PopupMenu := FSelectMenu;
end;

destructor TUIInput.Destroy;
begin
  inherited Destroy;
end;

procedure TUIInput.Click;
begin
end;

procedure TUIInput.MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
var
  P : TPoint;
begin
  if Button = mbLeft then
  begin
    if FInput.ValueProperties.IsEnum then
    begin
      UpdateEnumMenu;
      P := ClientToScreen(Point(X, Y));
      FEnumMenu.Popup(P.X, P.Y);
    end else
    begin
      if ioCanEdit in FInput.Options then
      begin
        Screen.Cursor := crCross;
        Self.MouseCapture := true;
        FDragEnabled := true;
        FDragOrigin := Point(X, Y);
        FValueOrigin := FInput.Value;
      end;
    end;
  end;

  if Button = mbRight then
  begin
    UpdateSelectMenu;
  end;
end;

procedure TUIInput.MouseUp(Button : TMouseButton; Shift : TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if (not FInput.ValueProperties.IsEnum) and (ioCanEdit in FInput.Options) then
    begin
      Screen.Cursor := crDefault;
      Self.MouseCapture := false;
      FDragEnabled := false;
      Mouse.CursorPos := ClientToScreen(FDragOrigin);
    end;
  end;
end;

procedure TUIInput.MouseMove(Shift : TShiftState; X, Y : Integer);
begin
  if FDragEnabled then
  begin
    if ssShift in Shift then
      SetValue(FValueOrigin - (Y - FDragOrigin.Y) * FStepSizeFine)
    else
      SetValue(FValueOrigin - (Y - FDragOrigin.Y) * FStepSize);
  end;
end;

procedure TUIInput.Paint;
var
  Dst : TRect;
  Text : String;
begin
  Canvas.Pen.Color := clWhite;
  Canvas.Pen.Style := psSolid;
  Canvas.Brush.Color := FBackground;
  Canvas.Brush.Style := bsSolid;
  Canvas.Rectangle(0, 0, ClientWidth, ClientHeight);

  Text := FInput.Name + ': ';
  if FInput.IsConnected then
  begin
    Text := Text + FInput.Output.Module.Name + ' > ' + FInput.Output.Name;
  end else
  begin
    if ioCanEdit in FInput.Options then
      Text := Text + FInput.ValueProperties.ValueToStr(FInput.Value)
    else
      Text := Text + 'none';
  end;

//  Text := UIFormatValue(Value, FDisplayMode);

  Dst.Left := 1;
  Dst.Top := 1;
  Dst.Right := ClientWidth - 1;
  Dst.Bottom := ClientHeight - 1;
  Canvas.Font.Color := clWhite;
  Canvas.Font.Height := 8;
  Canvas.TextRect(
    Dst,
    (ClientWidth - Canvas.TextWidth(Text)) div 2,
    (ClientHeight - Canvas.TextHeight(Text)) div 2,
    Text
  );
end;

procedure TUIInput.UpdateSelectMenu;
var
  Item, GroupItem, ModuleItem : TMenuItem;
  GroupIndex, ModuleIndex, OutputIndex : Integer;
  Document : TDocument;
  Group : TGroup;
  Module : TModule;
  Output : TOutput;
begin
  FSelectMenu.Items.Clear;

  if ioCanConnect in FInput.Options then
  begin
    Item := TMenuItem.Create(nil);
    Item.Caption := 'Disconnect';
    if ioCanEdit in FInput.Options then
      Item.Caption := 'Manual';
    Item.Tag := 0;
    if not FInput.IsConnected then
      Item.Checked := true;
    Item.OnClick := SelectMenuClick;
    FSelectMenu.Items.Add(Item);
    FSelectMenu.Items.InsertNewLineAfter(Item);

    Document := FInput.Document;
    for GroupIndex := 0 to Document.GroupCount - 1 do
    begin
      Group := Document.Group[GroupIndex];

      GroupItem := TMenuItem.Create(nil);
      GroupItem.Caption := Group.Name;
      GroupItem.Tag := Integer(Pointer(Group));
      FSelectMenu.Items.Add(GroupItem);

      for ModuleIndex := 0 to Group.ModuleCount - 1 do
      begin
        Module := Group.Module[ModuleIndex];

        ModuleItem := TMenuItem.Create(nil);
        ModuleItem.Caption := Module.Name;
        ModuleItem.Tag := Integer(Pointer(Module));
        GroupItem.Add(ModuleItem);

        for OutputIndex := 0 to Module.OutputCount - 1 do
        begin
          Output := Module.Output[OutputIndex];

          Item := TMenuItem.Create(nil);
          Item.Caption := Output.Name;
          Item.Tag := Integer(Pointer(Output));
          if FInput.Output = Output then
          begin
            GroupItem.Checked := true;
            ModuleItem.Checked := true;
            Item.Checked := true;
          end;
          Item.OnClick := SelectMenuClick;
          ModuleItem.Add(Item);
        end;
      end;
    end;
  end;
end;

procedure TUIInput.UpdateEnumMenu;
var
  Index : Integer;
  Item : TMenuItem;
begin
  FEnumMenu.Items.Clear;

  for Index := 0 to FInput.ValueProperties.NameList.Count - 1 do
  begin
    Item := TMenuItem.Create(nil);
    Item.Caption := FInput.ValueProperties.NameList[Index];
    Item.Tag := Index;
    Item.OnClick := EnumMenuClick;
    FEnumMenu.Items.Add(Item);
  end;
end;

procedure TUIInput.FireOnChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TUIInput.SelectMenuClick(Sender : TObject);
var
  Output : TOutput;
begin
  Output := TOutput(Pointer((Sender as TMenuItem).Tag));
  if Assigned(Output) then
  begin
    FInput.Connect(Output);
  end else
  begin
    FInput.Disconnect;
  end;
  Repaint;
end;

procedure TUIInput.EnumMenuClick(Sender : TObject);
begin
  SetValue((Sender as TMenuItem).Tag);
end;

procedure TUIInput.SetInput(Input : TInput);
begin
  if Input <> FInput then
  begin
    FInput := Input;
    FMinValue := FInput.ValueProperties.MinValue;
    FMaxValue := FInput.ValueProperties.MaxValue;
    FStepSize := FInput.ValueProperties.StepSize;
    FStepSizeFine := FInput.ValueProperties.StepSizeFine;
    FireOnChange;
  end;
end;

function  TUIInput.GetValue : TValue;
begin
  Result := FInput.Value;
end;

procedure TUIInput.SetValue(Value : TValue);
begin
  if Value <> FInput.Value then
  begin
    if Value > FMaxValue then Value := FMaxValue;
    if Value < FMinValue then Value := FMinValue;
    FInput.Value := Value;
    Repaint;
    FireOnChange;
  end;
end;

function  TUIInput.GetIntValue : Integer;
begin
  Result := trunc(FInput.Value);
end;

end.
