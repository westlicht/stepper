unit AppMain;

interface

uses
  Classes,
  ExtCtrls,
  Observer,
  Document,
  Engine,
  Device,
  AppConfig;

type
  TAppMain = class(TObject)
    private
      FAppPath : String;
      FConfig : TAppConfig;
      FDeviceManager : TDeviceManager;
      FDocument : TDocument;
      FEngine : TEngine;
      FUpdateTimer : TTimer;

    public
      constructor Create;
      destructor Destroy; override;

      procedure Init;
      procedure Shutdown;

    private
      procedure UpdateRecentProjectList;

    private
      procedure aNewProjectExecute(Sender : TObject);
      procedure aLoadProjectExecute(Sender : TObject);
      procedure aSaveProjectExecute(Sender : TObject);
      procedure mRecentProjectsClick(Sender : TObject);
      procedure aPreferencesExecute(Sender : TObject);
      procedure aExitExecute(Sender : TObject);

      procedure aStartExecute(Sender : TObject);
      procedure aStopExecute(Sender : TObject);

      procedure UpdateTimerTimer(Sender : TObject);

    public
      property  AppPath : String read FAppPath;
      property  Config : TAppConfig read FConfig;
      property  DeviceManager : TDeviceManager read FDeviceManager;

  end;

var
  App : TAppMain;

implementation

uses
  Menus,
  Dialogs,
  Forms,
  Controls,
  SysUtils,
  UIPreferences,
  Main;

constructor TAppMain.Create;
begin
  inherited Create;

  App := Self;

  FAppPath := IncludeTrailingPathDelimiter(ExtractFileDir(Application.ExeName));
  FConfig := TAppConfig.Create(FAppPath + 'config.xml');

  FDeviceManager := TDeviceManager.GetInstance;

  FConfig.Load;
  FConfig.Save;

  UpdateRecentProjectList;

  FDeviceManager.Connect;

  FDocument := TDocument.Create;

  FEngine := TEngine.GetInstance;
  FEngine.Document := FDocument;

  FUpdateTimer := TTimer.Create(nil);
  FUpdateTimer.Enabled := false;
  FUpdateTimer.Interval := 50;
  FUpdateTimer.OnTimer := UpdateTimerTimer;

  MainDlg.aNewProject.OnExecute := aNewProjectExecute;
  MainDlg.aLoadProject.OnExecute := aLoadProjectExecute;
  MainDlg.aSaveProject.OnExecute := aSaveProjectExecute;
  MainDlg.aPreferences.OnExecute := aPreferencesExecute;
  MainDlg.aExit.OnExecute := aExitExecute;
  MainDlg.aStart.OnExecute := aStartExecute;
  MainDlg.aStop.OnExecute := aStopExecute;
end;

destructor TAppMain.Destroy;
begin
  FUpdateTimer.Destroy;
  
  FDocument.Destroy;

  FEngine.Destroy;

  FDeviceManager.Destroy;
  
  FConfig.Destroy;

  inherited Destroy;
end;

procedure TAppMain.Init;
begin
  FDocument.New;

  MainDlg.UIBrowser.Document := FDocument;
//  MainDlg.UITrack.Track := nil;
end;

procedure TAppMain.Shutdown;
begin
  FEngine.Stop;
end;

procedure TAppMain.UpdateRecentProjectList;
var
  Index : Integer;
  Item : TMenuItem;
begin
  MainDlg.mRecentProjects.Clear;
  for Index := 0 to FConfig.RecentProjectList.Count - 1 do
  begin
    Item := TMenuItem.Create(nil);
    Item.Caption := ExtractFileName(FConfig.RecentProjectList[Index]);
    Item.Tag := Index;
    Item.OnClick := mRecentProjectsClick;
    MainDlg.mRecentProjects.Add(Item);
  end;
end;

procedure TAppMain.aNewProjectExecute(Sender : TObject);
begin
  FDocument.New;
//  MainDlg.UIGroupList.Document := FDocument;
//  MainDlg.UITrack.Track := nil;
end;

procedure TAppMain.aLoadProjectExecute(Sender : TObject);
var
  Dlg : TOpenDialog;
begin
  Dlg := TOpenDialog.Create(nil);
  Dlg.Title := 'Load Project';
  Dlg.FileName := '*.stp';
  Dlg.DefaultExt := 'stp';
  Dlg.Filter := 'Stepper Project|stp';
  if Dlg.Execute then
  begin
    FDocument.LoadFromFile(Dlg.FileName);
    FConfig.AddRecentProject(Dlg.FileName);
    FConfig.Save;
    UpdateRecentProjectList;

//    MainDlg.UIGroupList.Document := FDocument;
//    MainDlg.UITrack.Track := nil;
  end;
  Dlg.Destroy;
end;

procedure TAppMain.aSaveProjectExecute(Sender : TObject);
var
  Dlg : TSaveDialog;
begin
  Dlg := TSaveDialog.Create(nil);
  Dlg.Title := 'Save Project';
  Dlg.FileName := '*.*';
  Dlg.DefaultExt := 'stp';
  Dlg.Filter := 'Stepper Project|stp';
  if Dlg.Execute then
  begin
    FDocument.SaveToFile(Dlg.FileName);
    FConfig.AddRecentProject(Dlg.FileName);
    FConfig.Save;
    UpdateRecentProjectList;
  end;
  Dlg.Destroy;
end;

procedure TAppMain.mRecentProjectsClick(Sender : TObject);
begin
  FDocument.LoadFromFile(FConfig.RecentProjectList[(Sender as TMenuItem).Tag]);
//  MainDlg.UIGroupList.Document := FDocument;
//  MainDlg.UITrack.Track := nil;
end;

procedure TAppMain.aPreferencesExecute(Sender : TObject);
var
  Dlg : TUIPreferencesDlg;
begin
  Dlg := TUIPreferencesDlg.Create(nil);
  Dlg.Execute;
  Dlg.Destroy;
  FConfig.Save;
  FDeviceManager.Connect;
end;

procedure TAppMain.aExitExecute(Sender : TObject);
begin
  FConfig.Save;
  MainDlg.Close;
end;

procedure TAppMain.aStartExecute(Sender : TObject);
begin
  FEngine.Reset;
  FEngine.Start;
  FUpdateTimer.Enabled := true;
end;

procedure TAppMain.aStopExecute(Sender : TObject);
begin
  FEngine.Stop;
  FUpdateTimer.Enabled := false;
end;

procedure TAppMain.UpdateTimerTimer(Sender : TObject);
begin
  MainDlg.UIGroup.Render;
end;

end.

