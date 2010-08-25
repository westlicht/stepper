unit UIModule;

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
  TUIModule = class(TPanel)
    private
      FModule : TModule;

    protected
      FModuleObserver : TObserver;

      FStatusPanel : TPanel;
      FModulePanel : TPanel;
      FMinimizeButton : TUISwitchButton;
      FClassLabel : TLabel;
      FNameEdit : TUIEdit;

      FModuleMenu : TPopupMenu;
      FRemoveModuleItem : TMenuItem;

      FOnRearrange : TNotifyEvent;

    public
      constructor Create(AOwner : TComponent); override;
      destructor Destroy; override;

      procedure Rearrange; virtual;
      procedure Render; virtual;

    protected
      procedure UpdateModule; virtual;

      procedure CreatePopupMenus;

      procedure ModuleObserverNotify(Sender : TObject; Event : TObserverEvent);

      procedure SelfResize(Sender : TObject);
      procedure StatusPanelClick(Sender : TObject);
      procedure MinimizedButtonChange(Sender : TObject);
      procedure NameEditChange(Sender : TObject);
      procedure RemoveModuleItemClick(Sender : TObject);

      procedure FireOnRearrange;

      procedure SetModule(Module : TModule); virtual;

    public
      property  Module : TModule read FModule write SetModule;

      property  OnRearrange : TNotifyEvent read FOnRearrange write FOnRearrange;

  end;

implementation

uses
  ModuleFactory;
  
////////////////////////////////////////////////////////////////////////////////
// TUIModule                                                                   //
////////////////////////////////////////////////////////////////////////////////

constructor TUIModule.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FModule := nil;
  FModuleObserver := TObserver.Create;
  FModuleObserver.OnNotify := ModuleObserverNotify;

  FStatusPanel := TPanel.Create(Self);
  FStatusPanel.Parent := Self;
  FStatusPanel.Left := 0;
  FStatusPanel.Top := 0;
  FStatusPanel.Height := 20;
  FStatusPanel.Color := UI_COLOR_BACKGROUND_LIGHT;
  FStatusPanel.BevelOuter := bvNone;
  FStatusPanel.OnClick := StatusPanelClick;

  FMinimizeButton := TUISwitchButton.Create(nil);
  FMinimizeButton.Parent := FStatusPanel;
  FMinimizeButton.Left := 2;
  FMinimizeButton.Top := 2;
  FMinimizeButton.Width := 16;
  FMinimizeButton.Height := 16;
  FMinimizeButton.StateCount := 2;
  FMinimizeButton.ImageCollection := TUIImageLibrary.GetInstance.GetImageCollection('module_minimize');
  FMinimizeButton.State := 0;
  FMinimizeButton.OnChange := MinimizedButtonChange;

  FClassLabel := TLabel.Create(nil);
  FClassLabel.Parent := FStatusPanel;
  FClassLabel.Top := 3;
  FClassLabel.AutoSize := true;
  FClassLabel.Transparent := true;
  FClassLabel.Font.Color := UI_COLOR_FONT_LIGHT;
  FClassLabel.OnClick := StatusPanelClick;

  FNameEdit := TUIEdit.Create(nil);
  FNameEdit.Parent := FStatusPanel;
  FNameEdit.Top := 3;
  FNameEdit.Left := 20;
  FNameEdit.Width := 150;
  FNameEdit.OnChange := NameEditChange;
  FNameEdit.OnClick := StatusPanelClick;
  FNameEdit.ParentColor := true;

  FModulePanel := TPanel.Create(Self);
  FModulePanel.Parent := Self;
  FModulePanel.Align := alNone;
  FModulePanel.BevelOuter := bvNone;
  FModulePanel.Left := 0;
  FModulePanel.Top := FStatusPanel.Height + 1;
  FModulePanel.Width := 800;
  FModulePanel.Height := 100;
  FModulePanel.Color := $303030;

  CreatePopupMenus;

  FStatusPanel.PopupMenu := FModuleMenu;

  Self.PopupMenu := nil;
  Self.OnResize := SelfResize;
end;

destructor TUIModule.Destroy;
begin
  FModuleObserver.Destroy;

  inherited Destroy;
end;

procedure TUIModule.Rearrange;
begin
  FStatusPanel.Width := FModulePanel.Width;
  FClassLabel.Left := FStatusPanel.Width - FClassLabel.Width - 4;
  Self.ClientWidth := FModulePanel.Width;
  if FModule.Minimized then
    Self.ClientHeight := FStatusPanel.Height
  else
    Self.ClientHeight := FStatusPanel.Height + FModulePanel.Height + 1;

  FireOnRearrange;
end;

procedure TUIModule.Render;
begin
end;

procedure TUIModule.UpdateModule;
begin
  FNameEdit.Enabled := false;
  FNameEdit.Text := FModule.Name;
  FNameEdit.Enabled := true;

  FMinimizeButton.Enabled := false;
  FMinimizeButton.State := Integer(FModule.Minimized);
  FMinimizeButton.Enabled := true;
end;

procedure TUIModule.CreatePopupMenus;
begin
  FModuleMenu := TPopupMenu.Create(nil);

  FRemoveModuleItem := TMenuItem.Create(FModuleMenu);
  FRemoveModuleItem.Caption := '&Remove Module';
  FRemoveModuleItem.OnClick := RemoveModuleItemClick;
  FModuleMenu.Items.Add(FRemoveModuleItem);
end;

procedure TUIModule.ModuleObserverNotify(Sender : TObject; Event : TObserverEvent);
begin
  case Event of
    EVENT_MODULE_SELECTED_CHANGED:
      begin
        if FModule.Selected then
          FStatusPanel.Color := UI_COLOR_BACKGROUND_LIGHT_SELECTED
        else
          FStatusPanel.Color := UI_COLOR_BACKGROUND_LIGHT;
      end;
  end;
end;

procedure TUIModule.SelfResize(Sender : TObject);
begin
end;

procedure TUIModule.StatusPanelClick(Sender : TObject);
begin
  FModule.Group.SelectModule(soSelectSingle, FModule);
end;

procedure TUIModule.MinimizedButtonChange(Sender : TObject);
begin
  if not Enabled then Exit;
  FModule.Minimized := not FModule.Minimized;
  Rearrange;
end;

procedure TUIModule.NameEditChange(Sender : TObject);
begin
  if not Enabled then Exit;
  FModule.Name := FNameEdit.Text;
end;

procedure TUIModule.RemoveModuleItemClick(Sender : TObject);
begin
  FModule.Group.RemoveSelectedModules;
end;

procedure TUIModule.FireOnRearrange;
begin
  if Assigned(FOnRearrange) and Enabled then
    FOnRearrange(Self);
end;

procedure TUIModule.SetModule(Module : TModule);
begin
  FModule := Module;
  FModuleObserver.Connect(FModule.Observable);
  FClassLabel.Caption := TModuleFactory.GetInstance.NameByClassName[FModule.ClassName];

  UpdateModule;

  ModuleObserverNotify(Self, EVENT_MODULE_SELECTED_CHANGED);
end;

end.
