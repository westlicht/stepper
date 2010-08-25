program Stepper;

uses
  Forms,
  Main in 'Main.pas' {MainDlg},
  XML_Document in 'XML\XML_Document.pas',
  XML_Node in 'XML\XML_Node.pas',
  XML_Tokenizer in 'XML\XML_Tokenizer.pas',
  MidiPort in 'MIDI\MidiPort.pas',
  UIFirstLastIndicator in 'UI\UIFirstLastIndicator.pas',
  UIImageLibrary in 'UI\UIImageLibrary.pas',
  UILed in 'UI\UILed.pas',
  UIPopupButton in 'UI\UIPopupButton.pas',
  UIRotary in 'UI\UIRotary.pas',
  UISimpleSlider in 'UI\UISimpleSlider.pas',
  UISpinEdit in 'UI\UISpinEdit.pas',
  UISwitchButton in 'UI\UISwitchButton.pas',
  UITypes in 'UI\UITypes.pas',
  AppConfig in 'App\AppConfig.pas',
  AppMain in 'App\AppMain.pas',
  StopWatch in 'Common\StopWatch.pas',
  Document in 'Model\Document.pas',
  SequenceEvent in 'Model\SequenceEvent.pas',
  UIPreferences in 'UI\UIPreferences.pas' {UIPreferencesDlg},
  Observer in 'Common\Observer.pas',
  DocumentEvents in 'Model\DocumentEvents.pas',
  UIEdit in 'UI\UIEdit.pas',
  ModuleFactory in 'Model\ModuleFactory.pas',
  ModuleSequencer in 'Model\ModuleSequencer.pas',
  UIBrowser in 'UI\UIBrowser.pas',
  UIGroup in 'UI\UIGroup.pas',
  UIModule in 'UI\UIModule.pas',
  UIModuleSequencer in 'UI\UIModuleSequencer.pas',
  UIColors in 'UI\UIColors.pas',
  ModuleClock in 'Model\ModuleClock.pas',
  UIModuleClock in 'UI\UIModuleClock.pas',
  UIModuleScope in 'UI\UIModuleScope.pas',
  ModuleScope in 'Model\ModuleScope.pas',
  UIScope in 'UI\UIScope.pas',
  Engine in 'Engine\Engine.pas',
  EngineConsts in 'Engine\EngineConsts.pas',
  EngineTypes in 'Engine\EngineTypes.pas',
  UIInput in 'UI\UIInput.pas',
  ValueTypes in 'Model\ValueTypes.pas',
  ModuleMIDINote in 'Model\ModuleMIDINote.pas',
  UIModuleMIDINote in 'UI\UIModuleMIDINote.pas',
  Device in 'Engine\Device.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainDlg, MainDlg);
  Application.CreateForm(TUIPreferencesDlg, UIPreferencesDlg);
  Application.Run;
end.
