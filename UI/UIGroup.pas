unit UIGroup;

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
  UIImageLibrary,
  UIEdit,
  UILed,
  UISwitchButton,
  UIPopupButton,
  UIModule,
  Document,
  DocumentEvents;

type
  TUIGroup = class(TPanel)
    private
      FGroup : TGroup;
      FGroupObserver : TObserver;
      FDocumentObserver : TObserver;

      FScrollBox : TScrollBox;
      FModulePanel : TPanel;

      FModuleMenu : TPopupMenu;
      FRemoveModuleItem : TMenuItem;

      FModuleList : TList;

    public
      constructor Create(AOwner : TComponent); reintroduce;
      destructor Destroy; override;

      procedure Rearrange;
      procedure Render;

    private
      procedure UpdateModuleList;
      procedure UpdateSelectedModule;

      procedure CreatePopupMenus;

      procedure GroupObserverNotify(Sender : TObject; Event : TObserverEvent);
      procedure DocumentObserverNotify(Sender : TObject; Event : TObserverEvent);
      procedure ModuleRearrange(Sender : TObject);

      procedure SelfResize(Sender : TObject);
      procedure AddModuleItemClick(Sender : TObject);
      procedure RemoveModuleItemClick(Sender : TObject);

      procedure SetGroup(Group : TGroup);

    public
      property  Group : TGroup read FGroup write SetGroup;

  end;

implementation

uses
  ModuleFactory;

////////////////////////////////////////////////////////////////////////////////
// TUIGroup                                                                   //
////////////////////////////////////////////////////////////////////////////////

constructor TUIGroup.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FGroup := nil;
  FGroupObserver := TObserver.Create;
  FGroupObserver.OnNotify := GroupObserverNotify;

  FDocumentObserver := TObserver.Create;
  FDocumentObserver.OnNotify := DocumentObserverNotify;

  FScrollBox := TScrollBox.Create(Self);
  FScrollBox.Parent := Self;
  FScrollBox.Align := alClient;
  FScrollBox.BorderStyle := bsNone;
  FScrollBox.Color := clBlack;
  FScrollBox.HorzScrollBar.Tracking := true;
  FScrollBox.VertScrollBar.Tracking := true;

  FModulePanel := TPanel.Create(Self);
  FModulePanel.Parent := FScrollBox;
  FModulePanel.Align := alNone;
  FModulePanel.BevelOuter := bvNone;
  FModulePanel.Left := 0;
  FModulePanel.Top := 0;
  FModulePanel.Color := clBlack;

  CreatePopupMenus;

  FScrollBox.PopupMenu := FModuleMenu;

  FModuleList := TList.Create;

  Self.OnResize := SelfResize;
end;

destructor TUIGroup.Destroy;
begin
  FModuleList.Destroy;
  FGroupObserver.Destroy;
  FDocumentObserver.Destroy;

  inherited Destroy;
end;

procedure TUIGroup.Rearrange;
var
  Index : Integer;
  Module : TUIModule;
  Y : Integer;
  MaxWidth : Integer;
begin
  FModulePanel.Visible := false;

  for Index := 0 to FModuleList.Count - 1 do
  begin
    Module := FModuleList[Index];
    Module.Enabled := false;
    Module.Rearrange;
    Module.Enabled := true;
  end;

  Y := 0;
  MaxWidth := 0;
  for Index := 0 to FModuleList.Count - 1 do
  begin
    Module := FModuleList[Index];
    Module.Left := 0;
    Module.Top := Y;
    if Module.Width > MaxWidth then MaxWidth := Module.Width;
    inc(Y, Module.Height);
  end;

  FModulePanel.Width := MaxWidth;
  FModulePanel.Height := Y;

  FModulePanel.Visible := true;
end;

procedure TUIGroup.Render;
var
  Index : Integer;
begin
  for Index := 0 to FModuleList.Count - 1 do
    TUIModule(FModuleList[Index]).Render;
end;

procedure TUIGroup.UpdateModuleList;
var
  Index : Integer;
  Module : TUIModule;
begin
  FModulePanel.Visible := false;

  for Index := 0 to FModuleList.Count - 1 do
    TUIModule(FModuleList[Index]).Destroy;
  FModuleList.Clear;
  
  for Index := 0 to FGroup.ModuleCount - 1 do
  begin
    Module := TModuleFactory.GetInstance.CreateUIModule(FGroup.Module[Index], nil);
    if Assigned(Module) then
    begin
      Module.Parent := FModulePanel;
      Module.Module := FGroup.Module[Index];
      Module.OnRearrange := ModuleRearrange;
      FModuleList.Add(Module);
    end;
  end;

  FModulePanel.Visible := true;
end;

procedure TUIGroup.UpdateSelectedModule;
begin
//  FModuleList.ItemIndex := FModuleList.Items.IndexOfObject(FSelectedModule);
end;

procedure TUIGroup.CreatePopupMenus;
var
  Item : TMenuItem;
  Index : Integer;
  ModuleFactory : TModuleFactory;
  Module : TModuleFactoryItem;
begin
  FModuleMenu := TPopupMenu.Create(nil);

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

procedure TUIGroup.GroupObserverNotify(Sender : TObject; Event : TObserverEvent);
begin
  case Event of
    EVENT_GROUP_CLEAR,
    EVENT_GROUP_CREATE_MODULE,
    EVENT_GROUP_DESTROY_MODULE:
      begin
        UpdateModuleList;
        Rearrange;
      end;
  end;
end;

procedure TUIGroup.DocumentObserverNotify(Sender : TObject; Event : TObserverEvent);
begin
end;

procedure TUIGroup.ModuleRearrange(Sender : TObject);
begin
  Rearrange;
end;

procedure TUIGroup.SelfResize(Sender : TObject);
begin
end;

procedure TUIGroup.AddModuleItemClick(Sender : TObject);
var
  ModuleFactory : TModuleFactory;
  Item : TModuleFactoryItem;
  Module : TModule;
begin
  ModuleFactory := TModuleFactory.GetInstance;

  if Assigned(FGroup) then
  begin
    Item := ModuleFactory.Module[(Sender as TMenuItem).Tag];
    Module := FGroup.CreateModule(Item.ModuleClass.ClassName);
    FGroup.SelectModule(soSelectSingle, Module);
  end;
end;

procedure TUIGroup.RemoveModuleItemClick(Sender : TObject);
begin
  FGroup.RemoveSelectedModules;
end;

procedure TUIGroup.SetGroup(Group : TGroup);
begin
  FGroup := Group;
  FGroupObserver.Connect(FGroup.Observable);
  
  UpdateModuleList;
  Rearrange;
end;

end.
