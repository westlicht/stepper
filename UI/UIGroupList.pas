unit UIGroupList;

interface

uses
  Classes,
  Graphics,
  Controls,
  ExtCtrls,
  Types,
  Forms,
  Menus,
  Observer,
  UITypes,
  UIImageLibrary,
  UIEdit,
  UILed,
  UISwitchButton,
  UIPopupButton,
  Document,
  DocumentEvents;

type
  TUIGroupList = class;

  TUIGroupListItem = class(TPanel)
    private
      FGroupList : TUIGroupList;
      FGroup : TGroup;
      FName : TUIEdit;

    public
      constructor Create(GroupList : TUIGroupList; Group : TGroup; AOwner : TComponent); reintroduce;
      destructor Destroy; override;

      procedure UpdateItem;

    private
      procedure MouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);

  end;

  TUIGroupList = class(TPanel)
    private
      FDocument : TDocument;
      FDocumentObserver : TObserver;
      FOptionsPanel : TPanel;
      FListPanel : TPanel;
      FGroupList : TList;
      FSelectedGroup : TGroup;

      FPopupMenu : TPopupMenu;
      FPopupAddGroup : TMenuItem;
      FPopupRemoveGroup : TMenuItem;

      FOnSelect : TNotifyEvent;

    public
      constructor Create(AOwner : TComponent); reintroduce;
      destructor Destroy; override;

      procedure Rearrange;

      procedure UpdateGroupList;

    private
      procedure UpdateFromModel;

      procedure ResizeGroupList(Size : Integer);

      procedure CreatePopupMenu;

      procedure DocumentObserverNotify(Sender : TObject; Event : TObserverEvent);

      procedure PopupAddGroupClick(Sender : TObject);
      procedure PopupRemoveGroupClick(Sender : TObject);

      procedure FireOnSelect;

      procedure SetDocument(Document : TDocument);
      procedure SetSelectedGroup(SelectedGroup : TGroup);

    public
      property  Document : TDocument read FDocument write SetDocument;
      property  SelectedGroup : TGroup read FSelectedGroup write SetSelectedGroup;

      property  OnSelect : TNotifyEvent read FOnSelect write FOnSelect;

  end;

implementation

////////////////////////////////////////////////////////////////////////////////
// TUIGroupListItem                                                           //
////////////////////////////////////////////////////////////////////////////////

constructor TUIGroupListItem.Create(GroupList : TUIGroupList; Group : TGroup; AOwner : TComponent);
begin
  inherited Create(AOwner);

  FGroupList := GroupList;
  FGroup := Group;
  
  Height := 50;
  Align := alTop;
  Color := clBlack;

  FName := TUIEdit.Create(Self);
  FName.Parent := Self;
  FName.Left := 4;
  FName.Top := 4;
  FName.Width := 100;
  FName.Text := FGroup.Name;

  Self.OnMouseDown := MouseDown;
end;

destructor TUIGroupListItem.Destroy;
begin
  inherited Destroy;
end;

procedure TUIGroupListItem.UpdateItem;
begin
  if FGroup = FGroupList.FSelectedGroup then
  begin
    Color := $301010;
  end else
  begin
    Color := clBlack;
  end;
end;

procedure TUIGroupListItem.MouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  FGroupList.FSelectedGroup := FGroup;
  FGroupList.UpdateGroupList;
  FGroupList.SetSelectedGroup(FGroup);
end;

////////////////////////////////////////////////////////////////////////////////
// TUIGroupList                                                               //
////////////////////////////////////////////////////////////////////////////////

constructor TUIGroupList.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FDocument := nil;
  FDocumentObserver := TObserver.Create;
  FDocumentObserver.OnNotify := DocumentObserverNotify;

  FGroupList := TList.Create;
  FSelectedGroup := nil;

  FOptionsPanel := TPanel.Create(nil);
  FOptionsPanel.Parent := Self;
  FOptionsPanel.Color := clBlack;
  FOptionsPanel.BevelOuter := bvNone;
  FOptionsPanel.Align := alTop;

  FListPanel := TPanel.Create(nil);
  FListPanel.Parent := Self;
  FListPanel.Color := clBlack;
  FListPanel.BevelOuter := bvNone;
  FListPanel.Align := alClient;

  CreatePopupMenu;
  Self.PopupMenu := FPopupMenu;
end;

destructor TUIGroupList.Destroy;
begin
  ResizeGroupList(0);

  FGroupList.Destroy;

  FOptionsPanel.Destroy;
  FListPanel.Destroy;

  FPopupMenu.Destroy;

  FDocumentObserver.Destroy;

  inherited Destroy;
end;

procedure TUIGroupList.Rearrange;
var
  Index : Integer;
  Y : Integer;
  Item : TUIGroupListItem;
begin
  FOptionsPanel.Left := 0;
  FOptionsPanel.Top := 0;
  FOptionsPanel.Width := ClientWidth;
  FOptionsPanel.Height := 20;

  Y := 0;

  for Index := 0 to FGroupList.Count - 1 do
  begin
    Item := FGroupList[Index];
    Item.Enabled := false;
//    Item.Sequence := FGroup.Sequence[Index];
//    Item.Rearrange;
    Item.Left := 0;
    Item.Top := Y;
    Item.Enabled := true;
    inc(Y, Item.Height);
  end;
end;

procedure TUIGroupList.UpdateGroupList;
var
  Index : Integer;
begin
  for Index := 0 to FGroupList.Count - 1 do
    TUIGroupListItem(FGroupList[Index]).UpdateItem;
end;

procedure TUIGroupList.UpdateFromModel;
var
  Index : Integer;
//  Sequence : TUISequence;
begin
//  for Index := 0 to FSequenceList.Count - 1 do
//  begin
//    Sequence := FSequenceList[Index];
//  end;
end;

procedure TUIGroupList.ResizeGroupList(Size : Integer);
var
  Index : Integer;
  Item : TUIGroupListItem;
begin
  if Size < 0 then Exit;
  if Size <> FGroupList.Count then
  begin
    if Size >= FGroupList.Count then
    begin
      for Index := FGroupList.Count to Size - 1 do
      begin
        Item := TUIGroupListItem.Create(Self, FDocument.Group[Index], nil);
        Item.Parent := FListPanel;
//        Item.OnRearrange := SequenceRearrange;
        FGroupList.Add(Item);
      end;
    end else
    begin
      for Index := FGroupList.Count - 1 downto Size do
      begin
        Item := FGroupList[Index];
        Item.Destroy;
        FGroupList.Delete(Index);
      end;
    end;
  end;

  for Index := 0 to FGroupList.Count - 1 do
  begin
    Item := FGroupList[Index];
    Item.FGroup := FDocument.Group[Index];
  end;
end;

procedure TUIGroupList.CreatePopupMenu;
begin
  FPopupMenu := TPopupMenu.Create(nil);

  FPopupAddGroup := TMenuItem.Create(FPopupMenu);
  FPopupAddGroup.Caption := '&Add Group';
  FPopupAddGroup.OnClick := PopupAddGroupClick;
  FPopupMenu.Items.Add(FPopupAddGroup);

  FPopupRemoveGroup := TMenuItem.Create(FPopupMenu);
  FPopupRemoveGroup.Caption := '&Remove Group';
  FPopupRemoveGroup.OnClick := PopupRemoveGroupClick;
  FPopupMenu.Items.Add(FPopupRemoveGroup);
end;

procedure TUIGroupList.DocumentObserverNotify(Sender : TObject; Event : TObserverEvent);
begin
  case Event of
    EVENT_NEW, EVENT_CREATE_Group, EVENT_DESTROY_Group :
      begin
        ResizeGroupList(FDocument.GroupCount);
        Rearrange;
        UpdateFromModel;
        UpdateGroupList;
      end;
  end;
end;

procedure TUIGroupList.PopupAddGroupClick(Sender : TObject);
begin
  FSelectedGroup := FDocument.CreateGroup;
  SetSelectedGroup(FSelectedGroup);
end;

procedure TUIGroupList.PopupRemoveGroupClick(Sender : TObject);
begin
  if Assigned(FSelectedGroup) then
  begin
    FDocument.DestroyGroup(FSelectedGroup);
    SetSelectedGroup(nil);
  end;
end;

procedure TUIGroupList.FireOnSelect;
begin
  if Assigned(FOnSelect) and Enabled then
    FOnSelect(Self);
end;

procedure TUIGroupList.SetDocument(Document : TDocument);
begin
  FDocument := Document;
  FDocumentObserver.Connect(FDocument.Observable);
  
  ResizeGroupList(FDocument.GroupCount);
  Rearrange;
  UpdateFromModel;
  UpdateGroupList;
end;

procedure TUIGroupList.SetSelectedGroup(SelectedGroup : TGroup);
begin
  FSelectedGroup := SelectedGroup;
  UpdateGroupList;
  FireOnSelect;
end;

end.
