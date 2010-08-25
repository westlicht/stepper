unit UIPreferences;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Menus,
  Device;

type
  TUIPreferencesDlg = class(TForm)
    PageControl1: TPageControl;
    tbMidiOutputs: TTabSheet;
    bSave: TButton;
    lvOutputList: TListView;
    pmConnectionList: TPopupMenu;
    mAddDevice: TMenuItem;
    mRemoveDevice: TMenuItem;
    N1: TMenuItem;
    mRemoveAllDevices: TMenuItem;
    pOutputDetails: TPanel;
    Label1: TLabel;
    eOutputName: TEdit;
    cbOutputPort: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    cbOutputChannel: TComboBox;
    procedure mAddDeviceClick(Sender: TObject);
    procedure mRemoveDeviceClick(Sender: TObject);
    procedure mRemoveAllDevicesClick(Sender: TObject);
    procedure lvOutputListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure eOutputNameChange(Sender: TObject);
    procedure cbOutputPortChange(Sender: TObject);
    procedure cbOutputChannelChange(Sender: TObject);
  private
    FDeviceManager : TDeviceManager;
    FSelectedOutput : TOutputDevice;
  public
    procedure Execute;
  private
    procedure UpdateOutputList;
    procedure UpdateOutputListSelectedItem;
    procedure UpdateOutputDetails;
  end;

var
  UIPreferencesDlg: TUIPreferencesDlg;

implementation

{$R *.dfm}

procedure TUIPreferencesDlg.Execute;
var
  Index : Integer;
begin
  FDeviceManager := TDeviceManager.GetInstance;
  
  cbOutputPort.Clear;
  for Index := 0 to FDeviceManager.MidiManager.OutDeviceCount - 1 do
    cbOutputPort.Items.Add(FDeviceManager.MidiManager.OutDevice[Index].Name);

  FSelectedOutput := nil;

  UpdateOutputList;
  UpdateOutputDetails;

  ShowModal;
end;

procedure TUIPreferencesDlg.UpdateOutputList;
var
  Index : Integer;
  OutputDevice : TOutputDevice;
begin
  lvOutputList.Clear;
  for Index := 0 to FDeviceManager.OutputCount - 1 do
  begin
    OutputDevice := FDeviceManager.Output[Index];
    with lvOutputList.Items.Add do
    begin
      Caption := OutputDevice.Name;
      SubItems.Add(OutputDevice.Port);
      SubItems.Add(IntToStr(OutputDevice.Channel + 1));
      Data := OutputDevice;
    end;
  end;
end;

procedure TUIPreferencesDlg.UpdateOutputListSelectedItem;
var
  Item : TListItem;
begin
  Item := lvOutputList.Selected;
  Item.Caption := FSelectedOutput.Name;
  Item.SubItems[0] := FSelectedOutput.Port;
  Item.SubItems[1] := IntToStr(FSelectedOutput.Channel + 1);
end;

procedure TUIPreferencesDlg.UpdateOutputDetails;
begin
  if Assigned(FSelectedOutput) then
  begin
    eOutputName.Text := FSelectedOutput.Name;
    cbOutputPort.Text := FSelectedOutput.Port;
    cbOutputChannel.ItemIndex := FSelectedOutput.Channel;
    pOutputDetails.Enabled := true;
  end else
  begin
    pOutputDetails.Enabled := false;
    eOutputName.Text := '';
    cbOutputPort.Text := '';
    cbOutputChannel.ItemIndex := 0;
  end;
end;

procedure TUIPreferencesDlg.mAddDeviceClick(Sender: TObject);
begin
  FSelectedOutput := FDeviceManager.AddOutputDevice;
  UpdateOutputList;
  UpdateOutputDetails;
end;

procedure TUIPreferencesDlg.mRemoveDeviceClick(Sender: TObject);
begin
  if Assigned(FSelectedOutput) then
  begin
    FDeviceManager.RemoveOutputDevice(FSelectedOutput);
    FSelectedOutput := nil;
    UpdateOutputList;
    UpdateOutputDetails;
  end;
end;

procedure TUIPreferencesDlg.mRemoveAllDevicesClick(Sender: TObject);
begin
  FDeviceManager.ClearOutputDevices;
  FSelectedOutput := nil;
  UpdateOutputList;
  UpdateOutputDetails;
end;

procedure TUIPreferencesDlg.lvOutputListSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  if Selected then
  begin
    FSelectedOutput := Item.Data;
  end else
  begin
    FSelectedOutput := nil;
  end;
  UpdateOutputDetails;
end;

procedure TUIPreferencesDlg.eOutputNameChange(Sender: TObject);
begin
  if pOutputDetails.Enabled then
  begin
    FSelectedOutput.Name := eOutputName.Text;
    UpdateOutputListSelectedItem;
  end;
end;

procedure TUIPreferencesDlg.cbOutputPortChange(Sender: TObject);
begin
  if pOutputDetails.Enabled then
  begin
    FSelectedOutput.Port := cbOutputPort.Text;
    UpdateOutputListSelectedItem;
  end;
end;

procedure TUIPreferencesDlg.cbOutputChannelChange(Sender: TObject);
begin
  if pOutputDetails.Enabled then
  begin
    FSelectedOutput.Channel := cbOutputChannel.ItemIndex;
    UpdateOutputListSelectedItem;
  end;
end;

end.
