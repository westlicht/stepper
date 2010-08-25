object MainDlg: TMainDlg
  Left = 457
  Top = 354
  Width = 807
  Height = 629
  Caption = 'Stepper'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mMainMenu
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel2: TBevel
    Left = 0
    Top = 35
    Width = 799
    Height = 2
    Align = alTop
    Shape = bsTopLine
    Style = bsRaised
  end
  object spMain: TSplitter
    Left = 201
    Top = 37
    Height = 546
    Beveled = True
    Color = clBackground
    ParentColor = False
    ResizeStyle = rsUpdate
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 799
    Height = 35
    Align = alTop
    BevelOuter = bvNone
    Color = clBlack
    TabOrder = 0
    object bStart: TButton
      Left = 4
      Top = 4
      Width = 75
      Height = 25
      Action = aStart
      TabOrder = 0
    end
    object bStop: TButton
      Left = 84
      Top = 4
      Width = 75
      Height = 25
      Action = aStop
      TabOrder = 1
    end
  end
  object pBrowser: TPanel
    Left = 0
    Top = 37
    Width = 201
    Height = 546
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
  end
  object pGroup: TPanel
    Left = 204
    Top = 37
    Width = 595
    Height = 546
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
  end
  object mMainMenu: TMainMenu
    Left = 528
    Top = 4
    object mFile: TMenuItem
      Caption = '&File'
      ShortCut = 16460
      object mNewProject: TMenuItem
        Action = aNewProject
      end
      object mLoadProject: TMenuItem
        Action = aLoadProject
      end
      object mSaveProject: TMenuItem
        Action = aSaveProject
      end
      object mFileBreak1: TMenuItem
        Caption = '-'
      end
      object mRecentProjects: TMenuItem
        Caption = '&Recent Projects'
      end
      object mFileBreak2: TMenuItem
        Caption = '-'
      end
      object Preferences1: TMenuItem
        Action = aPreferences
      end
      object mFileBreak3: TMenuItem
        Caption = '-'
      end
      object mExit: TMenuItem
        Action = aExit
      end
    end
    object mHelp: TMenuItem
      Caption = '&Help'
      object mAbout: TMenuItem
        Caption = '&About'
      end
    end
  end
  object aActionList: TActionList
    Left = 560
    Top = 4
    object aNewProject: TAction
      Category = 'File'
      Caption = '&New Project'
      ShortCut = 16462
    end
    object aLoadProject: TAction
      Category = 'File'
      Caption = '&Load Project'
      ShortCut = 16460
    end
    object aSaveProject: TAction
      Category = 'File'
      Caption = '&Save Project'
      ShortCut = 16467
    end
    object aExit: TAction
      Category = 'File'
      Caption = '&Exit'
    end
    object aStart: TAction
      Category = 'Transport'
      Caption = 'Start'
    end
    object aStop: TAction
      Category = 'Transport'
      Caption = 'Stop'
    end
    object aPreferences: TAction
      Category = 'File'
      Caption = '&Preferences'
    end
  end
end
