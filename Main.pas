unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, ActnList,
  UIBrowser, UIGroup, XML_Document, XML_Node, AppMain;

type
  TMainDlg = class(TForm)
    mMainMenu: TMainMenu;
    mFile: TMenuItem;
    mExit: TMenuItem;
    mHelp: TMenuItem;
    mAbout: TMenuItem;
    mNewProject: TMenuItem;
    mFileBreak1: TMenuItem;
    mLoadProject: TMenuItem;
    mSaveProject: TMenuItem;
    aActionList: TActionList;
    aNewProject: TAction;
    aLoadProject: TAction;
    aSaveProject: TAction;
    aExit: TAction;
    mFileBreak2: TMenuItem;
    mRecentProjects: TMenuItem;
    Panel1: TPanel;
    Bevel2: TBevel;
    bStart: TButton;
    bStop: TButton;
    pBrowser: TPanel;
    spMain: TSplitter;
    pGroup: TPanel;
    aStart: TAction;
    aStop: TAction;
    mFileBreak3: TMenuItem;
    aPreferences: TAction;
    Preferences1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  public
    UIBrowser : TUIBrowser;
    UIGroup : TUIGroup;
  private
    procedure UIBrowserSelectGroup(Sender : TObject);

  end;

var
  MainDlg: TMainDlg;

implementation

{$R *.dfm}

uses
  UIImageLibrary,
  UILed,
  UISwitchButton;

procedure TMainDlg.FormCreate(Sender: TObject);
var
  Lib : TUIImageLibrary;
  Dir : String;
begin
  App := TAppMain.Create;

  // Load graphics
  Dir := App.AppPath + 'graphics/';
  Lib := TUIImageLibrary.GetInstance;
  Lib.LoadLibrary(Dir + 'graphics.txt', Dir);

  UIBrowser := TUIBrowser.Create(nil);
  UIBrowser.Parent := pBrowser;
  UIBrowser.Align := alClient;
  UIBrowser.OnSelectGroup := UIBrowserSelectGroup;

  UIGroup := TUIGroup.Create(nil);
  UIGroup.Parent := pGroup;
  UIGroup.Align := alClient;
end;

procedure TMainDlg.FormDestroy(Sender: TObject);
begin
  App.Shutdown;
  App.Destroy;
end;

procedure TMainDlg.FormActivate(Sender: TObject);
begin
  App.Init;
end;

procedure TMainDlg.UIBrowserSelectGroup(Sender : TObject);
begin
  UIGroup.Group := UIBrowser.SelectedGroup;
end;

end.

