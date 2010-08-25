object UIPreferencesDlg: TUIPreferencesDlg
  Left = 342
  Top = 200
  BorderStyle = bsToolWindow
  Caption = 'Preferences'
  ClientHeight = 361
  ClientWidth = 451
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 451
    Height = 325
    ActivePage = tbMidiOutputs
    Align = alTop
    MultiLine = True
    TabOrder = 0
    object tbMidiOutputs: TTabSheet
      Caption = 'MIDI Outputs'
      object lvOutputList: TListView
        Left = 4
        Top = 4
        Width = 433
        Height = 217
        Columns = <
          item
            Caption = 'Name'
            Width = 200
          end
          item
            Caption = 'Port'
            Width = 150
          end
          item
            Caption = 'Channel'
            Width = 60
          end>
        ReadOnly = True
        RowSelect = True
        PopupMenu = pmConnectionList
        TabOrder = 0
        ViewStyle = vsReport
        OnSelectItem = lvOutputListSelectItem
      end
      object pOutputDetails: TPanel
        Left = 4
        Top = 228
        Width = 433
        Height = 61
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 1
        object Label1: TLabel
          Left = 8
          Top = 12
          Width = 28
          Height = 13
          Caption = 'Name'
        end
        object Label2: TLabel
          Left = 8
          Top = 36
          Width = 19
          Height = 13
          Caption = 'Port'
        end
        object Label3: TLabel
          Left = 324
          Top = 36
          Width = 39
          Height = 13
          Caption = 'Channel'
        end
        object eOutputName: TEdit
          Left = 44
          Top = 8
          Width = 381
          Height = 21
          TabOrder = 0
          Text = 'eOutputName'
          OnChange = eOutputNameChange
        end
        object cbOutputPort: TComboBox
          Left = 44
          Top = 32
          Width = 273
          Height = 21
          ItemHeight = 13
          TabOrder = 1
          Text = 'cbOutputPort'
          OnChange = cbOutputPortChange
        end
        object cbOutputChannel: TComboBox
          Left = 368
          Top = 32
          Width = 57
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 2
          Text = '1'
          OnChange = cbOutputChannelChange
          Items.Strings = (
            '1'
            '2'
            '3'
            '4'
            '5'
            '6'
            '7'
            '8'
            '9'
            '10'
            '11'
            '12'
            '13'
            '14'
            '15'
            '16')
        end
      end
    end
  end
  object bSave: TButton
    Left = 372
    Top = 332
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object pmConnectionList: TPopupMenu
    Left = 48
    Top = 116
    object mAddDevice: TMenuItem
      Caption = '&Add Device'
      OnClick = mAddDeviceClick
    end
    object mRemoveDevice: TMenuItem
      Caption = '&Remove Device'
      OnClick = mRemoveDeviceClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mRemoveAllDevices: TMenuItem
      Caption = '&Remove All Devices'
      OnClick = mRemoveAllDevicesClick
    end
  end
end
