unit UIBrowser;

interface

uses
  Classes,
  Graphics,
  Controls,
  StdCtrls,
  ExtCtrls,
  Types,
  Forms,
  Menus,
  Observer,
  UITypes,
  UIColors,
  UIImageLibrary,
  UIEdit,
  UILed,
  UISwitchButton,
  UIPopupButton,
  Document,
  DocumentEvents;

type
  TUIBrowser = class(TPanel)
    private
      FDocument : TDocument;
      FDocumentObserver : TObserver;
      FGroupObserver : TObserver;
      FModuleObserver : TObserver;
      FSelectedGroup : TGroup;

      FGroupPanel : TPanel;
      FGroupLabel : TLabel;
      FGroupList : TListbox;
      FModulePanel : TPanel;
      FModuleLabel : TLabel;
      FModuleList : TListbox;

      FGroupMenu : TPopupMenu;
      FAddGroupItem : TMenuItem;
      FRemoveGroupItem : TMenuItem;

      FModuleMenu : TPopupMenu;
      FRemoveModuleItem : TMenuItem;

      FOnSelectGroup : TNotifyEvent;

    public
      constructor Create(AOwner : TComponent); reintroduce;
      destructor Destroy; override;

    private
      procedure UpdateGroupList;
      procedure UpdateModuleList;
      procedure UpdateSelectedGroup;
      procedure UpdateSelectedModule;

      procedure CreatePopupMenus;

      procedure DocumentObserverNotify(Sender : TObject; Event : TObserverEvent);
      procedure GroupObserverNotify(Sender : TObject; Event : TObserverEvent);
      procedure ModuleObserverNotify(Sender : TObject; Event : TObserverEvent);

      procedure SelfResize(Sender : TObject);
      procedure GroupListClick(Sender : TObject);
      procedure ModuleListClick(Sender : TObject);
      procedure AddGroupItemClick(Sender : TObject);
      procedure RemoveGroupItemClick(Sender : TObject);
      procedure AddModuleItemClick(Sender : TObject);
      procedure RemoveModuleItemClick(Sender : TObject);

      procedure ChangeSelectedGroup;

      procedure FireOnSelectGroup;

      procedure SetDocument(Document : TDocument);
      procedure SetSelectedGroup(Group : TGroup);

    public
      property  Document : TDocument read FDocument write SetDocument;
      property  SelectedGroup : TGroup read FSelectedGroup write SetSelectedGroup;

      property  OnSelectGroup : TNotifyEvent read FOnSelectGroup write FOnSelectGroup;

  end;

implementation

uses
  ModuleFactory;

////////////////////////////////////////////////////////////////////////////////
// TUIBrowser                                                                 //
////////////////////////////////////////////////////////////////////////////////

constructor TUIBrowser.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FDocument := nil;
  FDocumentObserver := TObserver.Create;
  FDocumentObserver.OnNotify := DocumentObserverNotify;
  FGroupObserver := TObserver.Create;
  FGroupObserver.OnNotify := GroupObserverNotify;
  FModuleObserver := TObserver.Create;
  FModuleObserver.OnNotify := ModuleObserverNotify;
  FSelectedGroup := nil;

  FGroupPanel := TPanel.Create(Self);
  FGroupPanel.Parent := Self;
  FGroupPanel.Color := UI_COLOR_BACKGROUND_LIGHT;
  FGroupPanel.BevelOuter := bvNone;
  FGroupPanel.Align := alLeft;

  FGroupLabel := TLabel.Create(Self);
  FGroupLabel.Parent := FGroupPanel;
  FGroupLabel.Left := 2;
  FGroupLabel.Top := 2;
  FGroupLabel.Caption := 'Groups';
  FGroupLabel.Font.Color := UI_COLOR_FONT_LIGHT;
  FGroupLabel.Transparent := true;

  FGroupList := TListbox.Create(Self);
  FGroupList.Parent := FGroupPanel;
  FGroupList.Color := UI_COLOR_BACKGROUND_DARK;
  FGroupList.BorderStyle := bsNone;
  FGroupList.Align := alBottom;
  FGroupList.Font.Color := UI_COLOR_FONT_LIGHT;
  FGroupList.OnClick := GroupListClick;

  FModulePanel := TPanel.Create(Self);
  FModulePanel.Parent := Self;
  FModulePanel.Color := UI_COLOR_BACKGROUND_LIGHT;
  FModulePanel.BevelOuter := bvNone;
  FModulePanel.Align := alClient;

  FModuleLabel := TLabel.Create(Self);
  FModuleLabel.Parent := FModulePanel;
  FModuleLabel.Left := 2;
  FModuleLabel.Top := 2;
  FModuleLabel.Caption := 'Modules';
  FModuleLabel.Font.Color := UI_COLOR_FONT_LIGHT;
  FModuleLabel.Transparent := true;

  FModuleList := TListbox.Create(Self);
  FModuleList.Parent := FModulePanel;
  FModuleList.Color := UI_COLOR_BACKGROUND_DARK;
  FModuleList.BorderStyle := bsNone;
  FModuleList.Align := alBottom;
  FModuleList.Font.Color := UI_COLOR_FONT_LIGHT;
  FModuleList.OnClick := ModuleListClick;
  FModuleList.MultiSelect := true;

  CreatePopupMenus;

  FGroupList.PopupMenu := FGroupMenu;
  FModuleList.PopupMenu := FModuleMenu;

  Self.OnResize := SelfResize;

  FSelectedGroup := nil;
end;

destructor TUIBrowser.Destroy;
begin
  FDocumentObserver.Destroy;
  FGroupObserver.Destroy;
  FModuleObserver.Destroy;

  inherited Destroy;
end;

procedure TUIBrowser.UpdateGroupList;
var
  Index : Integer;
begin
  FGroupList.Clear;
  for Index := 0 to FDocument.GroupCount - 1 do
    FGroupList.Items.AddObject(FDocument.Group[Index].Name, FDocument.Group[Index]);
end;

procedure TUIBrowser.UpdateModuleList;
var
  Index : Integer;
begin
  FModuleList.Clear;
  if Assigned(FSelectedGroup) then
  begin
    for Index := 0 to FSelectedGroup.ModuleCount - 1 do
      FModuleList.Items.AddObject(FSelectedGroup.Module[Index].Name, FSelectedGroup.Module[Index]);
  end;
end;

procedure TUIBrowser.UpdateSelectedGroup;
begin
  FGroupList.ItemIndex := FGroupList.Items.IndexOfObject(FSelectedGroup);
end;

procedure TUIBrowser.UpdateSelectedModule;
var
  Index : Integer;
begin
  for Index := 0 to FSelectedGroup.ModuleCount - 1 do
    FModuleList.Selected[Index] := FSelectedGroup.Module[Index].Selected;
end;

procedure TUIBrowser.CreatePopupMenus;
var
  Item : TMenuItem;
  Index : Integer;
  ModuleFactory : TModuleFactory;
  Module : TModuleFactoryItem;  
begin
  FGroupMenu := TPopupMenu.Create(Self);

  FAddGroupItem := TMenuItem.Create(FGroupMenu);
  FAddGroupItem.Caption := '&Add Group';
  FAddGroupItem.OnClick := AddGroupItemClick;
  FGroupMenu.Items.Add(FAddGroupItem);

  FRemoveGroupItem := TMenuItem.Create(FGroupMenu);
  FRemoveGroupItem.Caption := '&Remove Group';
  FRemoveGroupItem.OnClick := RemoveGroupItemClick;
  FGroupMenu.Items.Add(FRemoveGroupItem);

  FModuleMenu := TPopupMenu.Create(Self);

  ModuleFactory := TModuleFactory.GetInstance;
  for Index := 0 to ModuleFactory.ModuleCount - 1 do
  begin
    Module := ModuleFactory.Module[Index];
    Item := TMenuItem.Create(Self);
    Item.Caption := 'Add "&' + Module.Name + '"';
    Item.Tag := Index;
    Item.OnClick := AddModuleItemClick;
    FModuleMenu.Items.Add(Item);
  end;

  FRemoveModuleItem := TMenuItem.Create(FModuleMenu);
  FRemoveModuleItem.Caption := '&Remove Module';
  FRemoveModuleItem.OnClick := RemoveModuleItemClick;
  FModuleMenu.Items.Add(FRemoveModuleItem);
end;

procedure TUIBrowser.DocumentObserverNotify(Sender : TObject; Event : TObserverEvent);
begin
  case Event of
    EVENT_DOCUMENT_CLEAR,
    EVENT_DOCUMENT_CREATE_GROUP,
    EVENT_DOCUMENT_DESTROY_GROUP:
      begin
        UpdateGroupList;
      end;
    EVENT_DOCUMENT_SELECT_GROUP:
      begin
        ChangeSelectedGroup;
      end;
  end;
end;

procedure TUIBrowser.GroupObserverNotify(Sender : TObject; Event : TObserverEvent);
begin
  case Event of
    EVENT_GROUP_CLEAR,
    EVENT_GROUP_CREATE_MODULE,
    EVENT_GROUP_DESTROY_MODULE:
      begin
        UpdateModuleList;
      end;
    EVENT_GROUP_SELECT_MODULE:
      begin
        UpdateSelectedModule;
      end;
  end;
end;

procedure TUIBrowser.ModuleObserverNotify(Sender : TObject; Event : TObserverEvent);
begin
  case Event of
    EVENT_MODULE_CLEAR,
    EVENT_MODULE_NAME_CHANGED:
      begin
        UpdateModuleList;
        UpdateSelectedModule;
      end;
  end;
end;

procedure TUIBrowser.SelfResize(Sender : TObject);
begin
  FGroupPanel.Width := Self.ClientWidth div 2;
  FGroupList.Height := Self.ClientHeight - 20;
  FModuleList.Height := Self.ClientHeight - 20;
end;

procedure TUIBrowser.GroupListClick(Sender : TObject);
begin
  if FGroupList.ItemIndex >= 0 then
    FDocument.SelectGroup(soSelectSingle, FGroupList.Items.Objects[FGroupList.ItemIndex] as TGroup);
end;

procedure TUIBrowser.ModuleListClick(Sender : TObject);
begin
  if FModuleList.ItemIndex >= 0 then
    FSelectedGroup.SelectModule(soSelectSingle, FModuleList.Items.Objects[FModuleList.ItemIndex] as TModule);
end;

procedure TUIBrowser.AddGroupItemClick(Sender : TObject);
begin
  FDocument.SelectGroup(soSelectSingle, FDocument.CreateGroup);
end;

procedure TUIBrowser.RemoveGroupItemClick(Sender : TObject);
begin
  if Assigned(FSelectedGroup) then
  begin
    FDocument.DestroyGroup(FSelectedGroup);
  end;
end;

procedure TUIBrowser.AddModuleItemClick(Sender : TObject);
var
  ModuleFactory : TModuleFactory;
  Item : TModuleFactoryItem;
  Module : TModule;
begin
  ModuleFactory := TModuleFactory.GetInstance;

  if Assigned(FSelectedGroup) then
  begin
    Item := ModuleFactory.Module[(Sender as TMenuItem).Tag];
    Module :=FSelectedGroup.CreateModule(Item.ModuleClass.ClassName);
    FModuleObserver.Connect(Module.Observable);
    FSelectedGroup.SelectModule(soSelectSingle, Module);
  end;
end;

procedure TUIBrowser.RemoveModuleItemClick(Sender : TObject);
begin
  FSelectedGroup.RemoveSelectedModules;
end;

procedure TUIBrowser.ChangeSelectedGroup;
var
  Index : Integer;
begin
  FSelectedGroup := FDocument.GetFirstSelectedGroup;
  if not Assigned(FSelectedGroup) then Exit;

  FGroupObserver.DisconnectAll;
  FGroupObserver.Connect(FSelectedGroup.Observable);
  FModuleObserver.DisconnectAll;
  for Index := 0 to FSelectedGroup.ModuleCount - 1 do
    FModuleObserver.Connect(FSelectedGroup.Module[Index].Observable);
  UpdateSelectedGroup;
  UpdateModuleList;

  FireOnSelectGroup;
end;

procedure TUIBrowser.FireOnSelectGroup;
begin
  if Assigned(FOnSelectGroup) then
    FOnSelectGroup(Self);
end;

procedure TUIBrowser.SetDocument(Document : TDocument);
begin
  FDocument := Document;
  FDocumentObserver.Connect(FDocument.Observable);
  FSelectedGroup := FDocument.GetFirstSelectedGroup;

  UpdateGroupList;
  UpdateModuleList;
end;

procedure TUIBrowser.SetSelectedGroup(Group : TGroup);
begin
  
end;

end.
