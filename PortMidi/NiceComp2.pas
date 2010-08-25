unit NiceComp2;

interface

uses
  Windows, Messages,  Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,StdCtrls,MMSystem;

type TTextHAlign = (haLeft, haRight, haCenter, haNone);
type TTextVAlign = (vaTop, vaBottom, vaCenter, vaNone);
type TShapeType  = (stRect, stRoundRect);
type TFocusStyle = (fsNone, fsBackground, fsBorder);
type TButtonMode = (bmButton, bmSwitch);
type TBlockScreen= (bsView, bsNotes, bsControl);
type TSpaceType  = (stLinear);
type TArrangerScreen = (asArranger, asTracker);

type TPressed = class (TPersistent)
private
    FPressed: Boolean;
    FFont: TFont;
    FPen: TPen;
    FBrush: TBrush;
  public
    constructor Create(AOwner: TComponent);
  published
    property Pressed: Boolean read FPressed write FPressed;
    property Font: TFont read FFont write FFont;
    property Pen: TPen read FPen write FPen;
    property Brush: TBrush read FBrush write FBrush;
end;

type TSelectedItem = class (TPersistent)
  private
    FSelected: Integer;
    FFont: TFont;
    FPen: TPen;
    FBrush: TBrush;
  public
    constructor Create(AOwner: TComponent);
  published
    property Index: Integer read FSelected write FSelected;
    property Font: TFont read FFont write FFont;
    property Pen: TPen read FPen write FPen;
    property Brush: TBrush read FBrush write FBrush;
end;


type
  TNiceShape = class(TCustomControl)
  private
    buffBitmap: TBitmap;
    MouseDownX: integer;
    MouseDownY: integer;
    MouseMoveX: integer;
    MouseMoveY: integer;
    FShadow: Boolean;
    FBgColor: TColor;
    FHasFocus: boolean;
    FFont: TFont;
    FPen: TPen;
    FBrush: TBrush;
    FShape: TShapeType;
    FText: String;
    FTextHAlign: TTextHAlign;
    FTextVAlign: TTextVAlign;
    FTextTop: Word;
    FTextLeft: Word;
    FOnChange: TNotifyEvent;
    FFocusStyle: TFocusStyle;
    FFocusColor: TColor;
    procedure SetShadow(Value: Boolean);
    procedure DrawFocus;
    procedure SetFont(Value: TFont);
    procedure SetPen(Value: TPen);
    procedure SetBrush(Value: TBrush);
    procedure SetText(Value: String);
    procedure SetTextTop(Value: word);
    procedure SetTextLeft(Value: word);
    procedure SetTextHAlign(Value: TTextHAlign);
    procedure SetTextVAlign(Value: TTextVAlign);
    procedure SetShape(Value: TShapeType);
    procedure SetFocusStyle(Value: TFocusStyle);
    procedure SetFocusColor(Value: TColor);
    procedure SetBgColor(Value: TColor);
    procedure Redraw(doCopyRect: Byte); dynamic;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
//    procedure CMChanged(var Message: TMessage); message CM_CHANGED;
    procedure WMEraseBkgnd(var m: TWMEraseBkgnd); message WM_ERASEBKGND;
  protected
    procedure Paint; override;
    procedure Change; dynamic;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Shadow: Boolean read FShadow write SetShadow;
    property BackgroundColor: TColor read FBgColor write SetBgColor;
    property FocusStyle: TFocusStyle read FFocusStyle write SetFocusStyle;
    property FocusColor: TColor read FFocusColor write SetFocusColor;
    property Shape: TShapeType read FShape write SetShape;
    property Pen: TPen read FPen write SetPen;
    property Brush: TBrush read FBrush write SetBrush;
    property Font: TFont read FFont write SetFont;
    property Text: String read FText write SetText;
    property TextTop: word read FTextTop write SetTextTop default 10;
    property TextLeft: word read FTextLeft write SetTextLeft default 10;
    property TextHAlign: TTextHAlign read FTextHAlign write SetTextHAlign;
    property TextVAlign: TTextVAlign read FTextVAlign write SetTextVAlign;
    property Align;
    property Anchors;
    property Constraints;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;

  end;

//-----------------------------------------------------------------------------
type
  TNiceEdit2 = class(TNiceShape)
  private
    Edit: TEdit;
  protected
      procedure WMSize(var Message: TWMSize); message WM_SIZE;
  public
      constructor Create(AOwner: TComponent); override;
  published
end;

type
  TNiceEdit = class(TNiceShape)
  private
    FCurPos: byte;
    FHasFocus: boolean;
    procedure DrawFocus;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
  protected
      procedure Redraw(doCopyRect: Byte); override;
      procedure KeyPress(var Key: Char); override;
      procedure KeyUp(var Key: Word; Shift: TShiftState); override;
      procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Shape;
    property Font;
    property Pen;
    property Brush;
    property Text;
    property TextTop;
    property TextLeft;
    property TextHAlign;
    property TextVAlign;
    property Anchors;
    property Constraints;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;

  end;

//-----------------------------------------------------------------------------
// Nice Splitter
//-----------------------------------------------------------------------------

type
  TNiceSplitter = class(TCustomControl)
  private
    FFont: TFont;
    FPen: TPen;
    FBrush: TBrush;
    FPressed: TPressed;
    MouseDownX: Integer;
    MouseDownY:Integer;
    FOnMove: TNotifyEvent;
    procedure SetFont(Value: TFont);
    procedure SetPen(Value: TPen);
    procedure SetBrush(Value: TBrush);
  protected
    procedure Redraw;
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure WMEraseBkgnd(var m: TWMEraseBkgnd); message WM_ERASEBKGND;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Visible;
    property Pressed: TPressed read FPressed write FPressed;
    property Pen: TPen read FPen write SetPen;
    property Brush: TBrush read FBrush write SetBrush;
    property Font: TFont read FFont write SetFont;
    property Align;
    property Anchors;
    property Constraints;
    property ShowHint;
    property OnMove: TNotifyEvent read FOnMove write FOnMove;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;

  end;
//-----------------------------------------------------------------------------

type
  TNiceBtn = class(TNiceShape)
  private
    FDown: Boolean;
    FMode: TButtonMode;
    FPressedBtn: TPressed;
    FCurPos: byte;
    procedure SetMode(Value: TButtonMode);
    procedure SetDown(Value: Boolean);
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure CMExit(var Message: TWMNoParams); message CM_EXIT;
  protected
      procedure KeyPress(var Key: Char); override;
      procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
        X, Y: Integer); override;
      procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
        X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Redraw(doCopyRect: Byte); override;
  published
    property Down: Boolean read FDown write SetDown;
    property Mode: TButtonMode read FMode write SetMode;
    property PressedBtn: TPressed read FPressedBtn write FPressedBtn;
    property Align;
    property Shape;
    property Font;
    property Pen;
    property Brush;
    property Text;
    property TextTop;
    property TextLeft;
    property TextHAlign;
    property TextVAlign;
    property Anchors;
    property Constraints;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;

  end;
//-----------------------------------------------------------------------------
// Nice Menu
//-----------------------------------------------------------------------------

type
  TNiceMenu = class(TNiceShape)
  private
    FFirstItem: Word;
    FHideLastItems: Word;
    FItems: TStrings;
    FSelectedItem: TSelectedItem;
    FItemHeight: Byte;
    FOnChange: TNotifyEvent;
    FOnSelect: TNotifyEvent;
    procedure SetItemHeight(Value: Byte);
    procedure SetHideLastItems(Value: Word);
    procedure SetItems(Value: TStrings);
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    procedure Redraw(doCopyRect: Byte); override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ItemHeight: Byte read FItemHeight write SetItemHeight;
    property HideLastItems: Word read FHideLastItems write SetHideLastItems;
    property Items: TStrings read FItems write SetItems;
    property SelectedItem: TSelectedItem read FSelectedItem write FSelectedItem;
    property Align;
    property Shape;
    property Font;
    property Pen;
    property Brush;
    property TextTop;
    property TextLeft;
    property TextHAlign;
    property TextVAlign;
    property Anchors;
    property Constraints;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnSelect: TNotifyEvent read FOnSelect write FOnSelect;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;


//-----------------------------------------------------------------------------
// Nice Log
//-----------------------------------------------------------------------------

type
  TNiceLog = class(TMemo)
  private
    FMaxLines: Word;
    FOnAdd: TNotifyEvent;
  protected
  public
    procedure Add(Line: String);
  published
    property Lines;
    property MaxLines: Word read FMaxLines write FMaxLines;
    property OnAdd: TNotifyEvent read FOnAdd write FOnAdd;
  end;

//-----------------------------------------------------------------------------
//  Seq Note
//-----------------------------------------------------------------------------

type
  TSeqNote = class(TNiceShape)
  private
    MDWidth: Word;
    MDLength: Word;
    MDVelocity: Byte;
    MDSelected: Boolean;
    MUDeselect: Boolean;
  protected
    procedure Redraw(doCopyRect: Byte); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;

  public
    Deleted: Boolean;
    Selected: Boolean;
    Position: Integer;
    Length: Integer;
    Pitch: ShortInt;
    Velocity: Byte;
    CanEdit: Boolean;
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Shape;
    property Font;
    property Pen;
    property Brush;
    property TextTop;
    property TextLeft;
    property TextHAlign;
    property TextVAlign;
    property Anchors;
    property Constraints;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

//-----------------------------------------------------------------------------
//  Seq Change
//-----------------------------------------------------------------------------

type
  TSeqChange = class
  MDPosition: Integer;
  MDValue: Integer;
  MDSelected: Boolean;
  MUDeselect: Boolean;
  Position: Integer;
  Value: Integer;
end;

//-----------------------------------------------------------------------------
//  Seq Control
//-----------------------------------------------------------------------------

type
  TSeqControl = class
  Name: String;
  Id: String;
  MinValue: Integer;
  MaxValue: Integer;
  ZeroValue: Integer;
  Changes: TList;
  constructor Create;
end;

//-----------------------------------------------------------------------------
//  Seq Block
//-----------------------------------------------------------------------------

const EditorOffset=30;

type
  TSeqBlock = class(TNiceShape)
  private
    Note: TSeqNote;
    Control: TSeqControl;
    Change: TSeqChange;
    MDEditControl: Boolean;
    MDWidth: Word;
    MDLength: Word;
    MDSelected: Boolean;
    MUDeselect: Boolean;
    Deleted: Boolean;
    HSpace: Real;
    VSpace: Real;
    NoteHeight: Integer;
    FOnEditorLoad: TNotifyEvent;
  protected
    procedure CalculateSizes;

    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

    procedure bsViewReDraw(doCopyRect: Byte);

    procedure bsNotesReDraw(doCopyRect: Byte);
    procedure bsNotesMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure bsNotesMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure bsNotesMouseMove(Shift: TShiftState; X, Y: Integer);
    procedure bsNotesKeyDown(var Key: Word; Shift: TShiftState);
    procedure bsNotesDrawGrid;
    procedure bsNotesDrawGridLinear;
    function bsNotesPosToScreen(Pos,Pitch: Integer):TPoint;
    function bsNotesPosToScreenLinear(Pos,Pitch: Integer):TPoint;
    function bsNotesScreenToPos(X,Y: Integer):TPoint;
    function bsNotesScreenToPosLinear(X,Y: Integer):TPoint;

    procedure bsControlMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure bsControlMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure bsControlMouseMove(Shift: TShiftState; X, Y: Integer);
    function bsControlPosToScreen(Pos,Value: Integer):TPoint;
    function bsControlPosToScreenLinear(Pos,Value: Integer):TPoint;
    function bsControlScreenToPos(X,Y: Integer):TPoint;
    function bsControlScreenToPosLinear(X,Y: Integer):TPoint;
    procedure bsControlRedraw(doCopyRect: Byte);
    procedure bsControlDrawGrid;
    procedure bsControlDrawGridLinear;

    procedure NotePosToScreen(Sender: TObject; doCopyRect: byte);
    procedure NoteScreenToPos(Sender: TObject; X,Y: Integer; doRedraw: byte);
    procedure OnNoteMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OnNoteMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OnNoteMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure OnNoteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;

    procedure CopyNotes();
    procedure PasteNotes();

  public
    Log: TNiceLog;
    Name: String;
    Position: Integer;
    Length: Integer;
    Track: Integer;
    Speed: ShortInt;
    MDHSpace: Integer;
    MDVSpace: Integer;
    SpaceType: TSpaceType;
    Scale: Byte;
    ScaleMultiplier: Word;
    HZoom: ShortInt;
    VZoom: ShortInt;
    HOffset: Integer;
    VOffset: Integer;
    Notes: TList;
    NotesClipboard: TList;
    Controls: TList;
    SelectedControl: Integer;
    Screen: TBlockScreen;
    Selected: Boolean;
    ArrangerBlock: TSeqBlock;
    CopyBack: Boolean;
    Color: Integer;
//    CanEdit: Boolean;
    constructor Create(AOwner: TComponent); override;
    procedure ReDraw(doCopyRect: Byte); override;
    procedure GetData(Block: TSeqBlock);
  published
    property Align;
    property Shape;
    property Font;
    property Pen;
    property Brush;
    property TextTop;
    property TextLeft;
    property TextHAlign;
    property TextVAlign;
    property Anchors;
    property Constraints;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property OnEditorLoad: TNotifyEvent read FOnEditorLoad write FOnEditorLoad;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;

  end;

//-----------------------------------------------------------------------------
//  Seq Track
//-----------------------------------------------------------------------------

type TSeqTrack = class
    Name: String;
    Device: ShortInt;
    Channel: ShortInt;
    Prog: ShortInt;
    Bank: ShortInt;
    Mute: Boolean;
    Solo: Boolean;
    Rec: Boolean;
    Volume: ShortInt;
    Pan: ShortInt;
    Color: TColor;
    BlockScreen: TBlockScreen;
end;

//-----------------------------------------------------------------------------
//  Seq Arranger
//-----------------------------------------------------------------------------

const ArrangerOffset=30;

type
  TSeqArranger = class(TNiceShape)
  private
    HSpace: Real;
    VSpace: Real;
    Note: TSeqNote;
    Block: TSeqBlock;
    MUDeselect: Boolean;
    BlocksClipboard: TList;
  protected
    procedure CalculateSizes;

    function MouseDownSample(x: Integer):Integer;

    function PosToScreen(Pos,Track: Integer):TPoint;
    function ScreenToPos(x,y: Integer):TPoint;

    procedure BlockPosToScreen(Block: TSeqBlock);
    procedure BlockScreenToPos(Block: TSeqBlock; X,Y: Integer; doRedraw: byte);

    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

    procedure asArrangerMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure asArrangerMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure asArrangerMouseMove(Shift: TShiftState; X, Y: Integer);
    procedure asArrangerKeyDown(var Key: Word; Shift: TShiftState);

    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;

    procedure CopyBlocks(Link: integer);
    procedure PasteBlocks(Link: integer);

  public
    Length: Longint;
    DisplayPos: Longint;
    PlayPos: Longint;
    LoopStart: LongInt;
    LoopEnd: LongInt;
    Blocks: TList;
    Tracks: TList;
    PosBarHeight: Integer;
    TrackHeight: Integer;
    Scale: Integer;
    HZoom: ShortInt;
    VZoom: ShortInt;
    HOffset: LongInt;
    VOffset: LongInt;
    Screen: TArrangerScreen;
    BlockEditor: TSeqBlock;
    Log: TNiceLog;
    constructor Create(AOwner: TComponent); override;
    procedure ReDraw(doCopyRect: Byte); override;
    procedure OnBlockMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OnBlockMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OnBlockMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure OnBlockKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  published
    property Align;
    property Shape;
    property Font;
    property Pen;
    property Brush;
    property TextTop;
    property TextLeft;
    property TextHAlign;
    property TextVAlign;
    property Anchors;
    property Constraints;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;

  end;

//-----------------------------------------------------------------------------
// Midi Device
//-----------------------------------------------------------------------------

type TMidiDeviceStatus=(dsClose, dsOpen);

type
  TMidiDevice = class (TObject)
    Id: word;
    Name: String;
    Handle: HMidiStrm;
    Status: TMidiDeviceStatus;
  end;

type sMIDIEVENT= record
     dwDeltaTime: DWORD;
     dwStreamID: DWORD;
     dwEvent: DWORD;
end;

type event=record
     DeviceId: word;
     Start:DWORD;
     Data:DWORD;
end;


//-----------------------------------------------------------------------------
// Midi Out
//-----------------------------------------------------------------------------

type TMidiStreamStatus=(ssStop,ssPlay);

const HeaderCount=4;

var HeaderId: array [0..30] of Integer;
    mhdr: array [0..30,0..HeaderCount-1] of MIDIHDR;


type
  TMidiOut = class(TComponent)
  private

    HeaderSize: Integer;

    Device: TMidiDevice;
    Note: TSeqNote;
    Block: TSeqBlock;
    Track: TSeqTrack;
    mmr: MMResult;
    CbDevice: integer;
  protected
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    Tempo: Longint;
    TimeDiv: Longint;
    Arranger: TSeqArranger;
    Log: TNiceLog;
    Devices: TList;
    Status: TMidiStreamStatus;
    FillSize: Integer;
    function OpenDevices():Boolean;
    function CloseDevices():Boolean;
    function ShortEvent(Data: DWORD; Start: DWord):sMIDIEVENT;
    function AddData(Data:PChar; var DataBuf:PChar; var BufSize:Integer; DataSize:Integer):bool;
    procedure AddShortEvent(sEvent:sMIDIEVENT; var DataBuf:PChar; var BufSize:Integer);
    function PlayData(Data:TList; Device: TMidiDevice):bool;
    procedure DescribeMidiError(err: integer);
//    xxxx
    procedure FillStream;
    function IncrementPlayPos(PlayPos: Integer):Integer;
    procedure PlayCallBack1(h: HMIDIOUT; msg: UINT; dwUser: Integer; dw1: Integer; dw2: Integer);
    procedure PlayCallBack2(h: HMIDIOUT; msg: UINT; dwUser: Integer; dw1: Integer; dw2: Integer);
    procedure Play;
    procedure Stop;
    procedure SetTempo(BPM: Byte);
    function GetDevices():TList;
  published
  end;

//-----------------------------------------------------------------------------
// Global Functions
//-----------------------------------------------------------------------------

function PitchToNote(Pitch: Byte):String;

//-----------------------------------------------------------------------------


procedure Register;

implementation

uses SysUtils, Consts;

//-----------------------------------------------------------------------------

constructor TPressed.Create(AOwner: TComponent);
begin
  inherited Create;
  FBrush:=TBrush.Create;
  FFont:=TFont.Create;
  FPen:=TPen.Create;
end;

//-----------------------------------------------------------------------------

constructor TSelectedItem.Create(AOwner: TComponent);
begin
  inherited Create;
  FBrush:=TBrush.Create;
  FFont:=TFont.Create;
  FPen:=TPen.Create;
  FSelected:=0;
end;


//-----------------------------------------------------------------------------
// Nice Shape
//-----------------------------------------------------------------------------

constructor TNiceShape.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  buffBitmap:=TBitmap.Create;
  SetBounds(0, 0, 75, 25);
  FBgColor:=clBtnFace;
  FPen:=TPen.Create;
  FBrush:=TBrush.Create;
  FFont:=TFont.Create;
  FTextLeft:=10;
  FTextTop:=10;
  FTextHAlign:=haLeft;
  FTextVAlign:=vaCenter;
//  FText:='Text';
  FFocusStyle:=fsBackground;
  FFocusColor:=$00E9E9E9;
end;

procedure TNiceShape.DrawFocus;
begin
 with buffBitmap do
 begin
  if (FFocusStyle=fsBorder) then
  begin
    if (FHasFocus) then
      Canvas.Pen.Color:=FFocusColor
    else
      Canvas.Pen.Color:=FBrush.Color;

    Canvas.Polyline([Point(2,2),Point(2,height-3),
      Point(Width-3,height-3),Point(Width-3,2),Point(2,2)]);
  end;
 end;
end;

procedure TNiceShape.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  FHasFocus:=true;
  ReDraw(1);
end;

procedure TNiceShape.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
  FHasFocus:=False;
  ReDraw(1);
end;


procedure TNiceShape.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS + DLGC_WANTCHARS;
end;

procedure TNiceShape.WMSize(var Message: TWMSize);
begin
  DisableAlign;
  try
    inherited;
    Update;
  finally
    EnableAlign;
  end;
end;

{procedure TNiceShape.CMChanged(var Message: TMessage);
begin
  Update;
  inherited;
  Invalidate;
end;
}
procedure TNiceShape.WMEraseBkgnd(var m: TWMEraseBkgnd);
begin
    //
end;

procedure TNiceShape.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  MouseMoveX:=X;
  MouseMoveY:=Y;
end;


procedure TNiceShape.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  MouseDownX:=X;
  MouseDownY:=Y;
  if TabStop then SetFocus;
  SetCapture(WindowHandle);
end;

procedure TNiceShape.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  ReleaseCapture;
end;


procedure TNiceShape.ReDraw;
var th,tw,thp,tvp: integer;
begin
 buffBitmap.Width:=Width;
 buffBitmap.Height:=Height;
 with buffBitmap do
 begin
  BoundsRect := Bounds(Left, Top, Width, Height);
  if (FShape<>stRect) then
  begin
    Canvas.Brush.Color:=FBgColor;
    Canvas.Pen.Color:=FBgColor;
    Canvas.Rectangle(0,0,Width,Height);
  end;

  Canvas.Font.Assign(FFont);
  Canvas.Brush.Assign(FBrush);
  Canvas.Pen.Assign(FPen);

  if ((FHasFocus) and (FFocusStyle=fsBackground)) then
    Canvas.Brush.Color:=FFocusColor;

  if (FShape=stRect) then
  begin
    Canvas.Rectangle(0,0,Width,Height);
    if (FShadow) then Canvas.Rectangle(0,0,Width-1,Height-1);
  end;
  if (FShape=stRoundRect) then
  begin
    Canvas.RoundRect(0,0,Width,Height,Height div 4, Height div 4);
    if (FShadow) then Canvas.RoundRect(0,0,Width-1,Height-1,(Height-1) div 4, (Height-1) div 4);
  end;

  th:=Canvas.TextHeight(FText);
  tw:=Canvas.TextWidth(FText);
  thp:=0;
  tvp:=0;
  if ((FTextHAlign=haLeft) or (FTextHAlign=haNone)) then thp:=FTextLeft;
  if (FTextHAlign=haRight) then thp:=Width-tw-FTextLeft;
  if (FTextHAlign=haCenter) then thp:=(Width-tw) div 2;

  if ((FTextVAlign=vaTop) or (FTextVAlign=vaNone)) then tvp:=FTextTop;
  if (FTextVAlign=vaBottom) then tvp:=Height-th-FTextTop;
  if (FTextVAlign=vaCenter) then tvp:=(Height-th) div 2;

  Canvas.TextOut(thp,tvp,FText);
  if (FHasFocus) then DrawFocus;
 end;
 if (doCopyRect>0) then
   Canvas.CopyRect(Rect(0,0,Width,Height),buffBitmap.Canvas,Rect(0,0,Width,Height));
end;

procedure TNiceShape.Paint;
begin
  inherited;
  ReDraw(1);
end;

procedure TNiceShape.Change;
begin
  Changed;
  ReDraw(1);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TNiceShape.SetText(Value: String);
begin
  FText:=Value;
  ReDraw(1);
end;

procedure TNiceShape.SetTextTop(Value: word);
begin
  FTextTop:=Value;
  ReDraw(1);
end;

procedure TNiceShape.SetTextLeft(Value: word);
begin
  FTextLeft:=Value;
  ReDraw(1);
end;

procedure TNiceShape.SetTextHAlign(Value: TTextHAlign);
begin
  FTextHAlign:=Value;
  ReDraw(1);
end;

procedure TNiceShape.SetTextVAlign(Value: TTextVAlign);
begin
  FTextVAlign:=Value;
  ReDraw(1);
end;

procedure TNiceShape.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
  Update;
end;

procedure TNiceShape.SetPen(Value: TPen);
begin
  FPen.Assign(Value);
  Update;
end;

procedure TNiceShape.SetBrush(Value: TBrush);
begin
  FBrush.Assign(Value);
  Update;
end;


procedure TNiceShape.SetShape(Value: TShapeType);
begin
  FShape:=Value;
  ReDraw(1);
end;

procedure TNiceShape.SetFocusStyle(Value: TFocusStyle);
begin
  FFocusStyle:=Value;
  ReDraw(1);
end;

procedure TNiceShape.SetFocusColor(Value: TColor);
begin
  FFocusColor:=Value;
  ReDraw(1);
end;

procedure TNiceShape.SetBgColor(Value: TColor);
begin
  FBgColor:=Value;
  ReDraw(1);
end;

procedure TNiceShape.SetShadow(Value: Boolean);
begin
  FShadow:=Value;
  ReDraw(1);
end;

//-----------------------------------------------------------------------------
// Nice Splitter
//-----------------------------------------------------------------------------

constructor TNiceSplitter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetBounds(0, 0, 400, 8);
  FPen:=TPen.Create;
  FBrush:=TBrush.Create;
  FFont:=TFont.Create;
  FPressed:=TPressed.Create(AOwner);
end;

procedure TNiceSplitter.Redraw;
begin
  if (FPressed.Pressed) then
  begin
    Canvas.Font.Assign(FPressed.Font);
    Canvas.Pen.Assign(FPressed.Pen);
    Canvas.Brush.Assign(FPressed.Brush);
  end else
  begin
    Canvas.Font.Assign(FFont);
    Canvas.Pen.Assign(FPen);
    Canvas.Brush.Assign(FBrush);
  end;
  Canvas.Rectangle(0,0,Width,Height);
end;

procedure TNiceSplitter.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  BringToFront;
  MouseDownX:=X;
  MouseDownY:=Y;
  FPressed.Pressed:=True;
  ReDraw;
end;

procedure TNiceSplitter.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  FPressed.Pressed:=False;
  ReDraw;
  if Assigned(FOnMove) then FOnMove(Self);
end;

procedure TNiceSplitter.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if (ssLeft in Shift) then
  begin
    if (Width>Height) then
    begin
      Top:=Top-(MouseDownY-Y);
    end else
    begin
      Left:=Left-(MouseDownX-X);
    end;
  end;
end;

procedure TNiceSplitter.Paint;
begin
  ReDraw;
end;

procedure TNiceSplitter.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
  ReDraw;
end;

procedure TNiceSplitter.SetPen(Value: TPen);
begin
  FPen.Assign(Value);
  ReDraw;
end;

procedure TNiceSplitter.SetBrush(Value: TBrush);
begin
  FBrush.Assign(Value);
  ReDraw;
end;

procedure TNiceSplitter.WMEraseBkgnd(var m: TWMEraseBkgnd);
begin
//
end;

//-----------------------------------------------------------------------------
// Nice Edit 2
//-----------------------------------------------------------------------------

constructor TNiceEdit2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetBounds(0, 0, 130, 25);
  FTextLeft:=10;
  FTextTop:=10;
  FTextHAlign:=haLeft;
  FTextVAlign:=vaCenter;
  FText:='Text';
  Edit:=TEdit.Create(Self);
  Edit.Parent:=Self;
  Edit.BorderStyle:=bsNone;
  Edit.Left:=1;
  Edit.Top:=4;
  Edit.Width:=Self.Width-2;
  Edit.Height:=Self.Height-5;
  Edit.Visible:=True;
end;

procedure TNiceEdit2.WMSize(var Message: TWMSize);
begin
  inherited;
  Edit.Width:=Self.Width-2;
  Edit.Height:=Self.Height-5;
end;


//-----------------------------------------------------------------------------
// Nice Edit
//-----------------------------------------------------------------------------

constructor TNiceEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetBounds(0, 0, 130, 25);
  FTextLeft:=10;
  FTextTop:=10;
  FTextHAlign:=haLeft;
  FTextVAlign:=vaCenter;
  FText:='Text';
  FCurPos:=Length(FText);
end;

procedure TNiceEdit.DrawFocus;
var CurLeft: word;
begin
  if (FHasFocus) then
  begin
    CurLeft:=0+FTextLeft+Canvas.TextWidth(Copy(FText,0,FCurPos));
    buffBitmap.Canvas.Rectangle(CurLeft,7,CurLeft+2,20);
  end else begin
    ReDraw(1);
  end;
end;


procedure TNiceEdit.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  FHasFocus:=true;
  Redraw(1);
end;

procedure TNiceEdit.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
  FHasFocus:=False;
  DrawFocus;
end;

procedure TNiceEdit.ReDraw;
begin
  inherited ReDraw(0);
  if (FHasFocus) then DrawFocus;

  if (doCopyRect>0) then
    Canvas.CopyRect(Rect(0,0,Width,Height),buffBitmap.Canvas,Rect(0,0,Width,Height));
end;

procedure TNiceEdit.KeyPress(var Key: Char);
begin
  if ((Ord(Key)>=47) or (Ord(Key)=32)) then
  begin
    Inc(FCurPos);
    Insert(key,FText,FCurPos);
  end;
  if ((Ord(Key)=8) and (FCurPos>0)) then //backspace
  begin
    Delete(FText,FCurPos,1);
    Dec(FCurPos);
  end;
  if (FCurPos>Length(FText)) then FCurPos:=Length(FText);
  ReDraw(1);
  inherited KeyPress(Key);
end;

procedure TNiceEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (Key<50) then
  begin
    if ((Key=37) and (FCurPos>0)) then Dec(FCurPos);
    if (Key=39) then Inc(FCurPos);
    if (Key=36) then FCurPos:=0;
    if (Key=35) then FCurPos:=Length(FText);
    ReDraw(1);
    if (FCurPos>Length(FText)) then FCurPos:=Length(FText);
  end;
  inherited KeyDown(Key, Shift);
end;

procedure TNiceEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if (Key<60) then
  begin
    if (Key=46) then Delete(FText,FCurPos+1,1);
    ReDraw(1);
    if (FCurPos>Length(FText)) then FCurPos:=Length(FText);
  end;
  inherited KeyDown(Key, Shift);
end;


//-----------------------------------------------------------------------------

constructor TNiceBtn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetBounds(0, 0, 75, 25);
  FTextLeft:=10;
  FTextTop:=10;
  FTextHAlign:=haLeft;
  FTextVAlign:=vaCenter;
  FText:='Text';
  FCurPos:=Length(FText);
  FPressedBtn:=TPressed.Create(AOwner);
  FMode:=bmButton;
  FDown:=False;
end;

procedure TNiceBtn.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
//  FHasFocus:=true;
//  ReDraw;
end;

procedure TNiceBtn.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
//  FHasFocus:=False;
//  ReDraw;
end;

procedure TNiceBtn.CMExit(var Message: TWMNoParams);
begin
  inherited;
  ReDraw(1);
end;

procedure TNiceBtn.ReDraw;
var tmpBrush: TBrush;
    tmpPen: TPen;
    tmpFont: TFont;
    tmpFocusColor: TColor;
    tmpDown: Boolean;
begin

  with buffBitmap do
  begin

  tmpBrush:=TBrush.Create;
  tmpPen:=TPen.Create;
  tmpFont:=TFont.Create;

  tmpDown:=False;
  if ((FDown and (FMode=bmSwitch)) or (FPressedBtn.Pressed)) then tmpDown:=True;

  if ((FHasFocus) and tmpDown) then
  begin
    tmpFocusColor:=FFocusColor;
    FFocusColor:=FPressedBtn.Brush.Color;
  end;

  if (tmpDown) then
  begin
    tmpBrush.Assign(Brush);
    tmpPen.Assign(Pen);
    tmpFont.Assign(Font);
    Brush.Assign(PressedBtn.Brush);
    Pen.Assign(PressedBtn.Pen);
    Font.Assign(PressedBtn.Font);
    inherited ReDraw(0);
    Brush.Assign(tmpBrush);
    Pen.Assign(tmpPen);
    Font.Assign(tmpFont);
  end else
    inherited ReDraw(0);

  if ((FHasFocus) and tmpDown) then
  begin
    FFocusColor:=tmpFocusColor;
  end;

  end;

  if (doCopyRect>0) then
    Canvas.CopyRect(Rect(0,0,Width,Height),buffBitmap.Canvas,Rect(0,0,Width,Height));
end;

procedure TNiceBtn.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
end;

procedure TNiceBtn.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if (ssLeft in Shift) or (ssDouble in Shift) then
  begin
    if TabStop then SetFocus;
    FHasFocus:=True;
    PressedBtn.Pressed:=True;
    ReDraw(1);
  end;
end;

procedure TNiceBtn.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  PressedBtn.Pressed:=False;
  if ((X>=0) and (Y>=0) and (Y<=Height) and (X<=Width) and (FMode=bmSwitch)) then
  begin
    if (FDown) then FDown:=False else FDown:=True;
  end else FDown:=False;
  ReDraw(1);
end;

procedure TNiceBtn.MouseMove(Shift: TShiftState; X, Y: Integer);
var MBtnDown: Boolean;
begin
  inherited;
  MBtnDown:=False;
  if (ssLeft in Shift) or (ssRight in Shift) or (ssDouble in Shift)
  or (ssMiddle in Shift) then MBtnDown:=True;
  if ((X<0) or (Y<0) or (Y>Height) or (X>Width))
  and (FPressedBtn.Pressed) and (MBtnDown)then
  begin
    FPressedBtn.Pressed:=False;
    ReDraw(1);
  end else
  if ((X>=0) and (Y>=0) and (Y<=Height) and (X<=Width))
  and (FPressedBtn.Pressed=False) and (MBtnDown) then
  begin
    FPressedBtn.Pressed:=True;
    ReDraw(1);
  end;
end;

procedure TNiceBtn.SetDown(Value: Boolean);
begin
  if (FDown<>Value) then
  begin
    FDown:=Value;
    ReDraw(1);
  end;
end;

procedure TNiceBtn.SetMode(Value: TButtonMode);
begin
  if (FMode<>Value) then
  begin
    FMode:=Value;
    ReDraw(1);
  end;
end;

//-----------------------------------------------------------------------------
//  Nice Menu
//-----------------------------------------------------------------------------

constructor TNiceMenu.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetBounds(0, 0, 75, 150);
  FTextLeft:=10;
  FTextTop:=10;
  FTextHAlign:=haLeft;
  FTextVAlign:=vaCenter;
  FSelectedItem:=TSelectedItem.Create(AOwner);
  FSelectedItem.Index:=0;
  FSelectedItem.Brush.Color:=$00ffddaa;
  FItems:=TStringList.Create;
  FText:='';
  FItemHeight:=15;
  FHideLastItems:=0;
  FFirstItem:=0;
end;


procedure TNiceMenu.ReDraw;
var i,siTop,LastItem: word;
    th: byte;
begin
  inherited ReDraw(0);

 with buffBitmap do
 begin

  if (FItems.Count>0) then
  begin
    LastItem:=((Height-(FItemHeight*FHideLastItems)) div FItemHeight)-1;
    if (LastItem>FItems.Count-1-FFirstItem) then LastItem:=FItems.Count-1-FFirstItem;
    th:=Canvas.TextHeight('Xy');
    for i:=0 to LastItem do
    begin
      if (FFirstItem+i=FSelectedItem.Index) then continue;
      Canvas.TextOut(FTextLeft,FTextTop+i*FItemHeight+((FItemHeight-th) div 2),FItems.Strings[FFirstItem+i]);
    end;
    if (FSelectedItem.Index >= 0)
      and (FSelectedItem.Index>=FFirstItem)
      and (FSelectedItem.Index<= FFirstItem+LastItem) then
    begin
      Canvas.Font.Assign(FSelectedItem.Font);
      Canvas.Pen.Assign(FSelectedItem.Pen);
      Canvas.Brush.Assign(FSelectedItem.Brush);
      siTop:=FTextTop+(FSelectedItem.Index-FFirstItem)*FItemHeight;
      Canvas.Rectangle(0,siTop,Width,siTop+FItemHeight+1);
      Canvas.TextOut(FTextLeft,siTop+((FItemHeight-th) div 2), FItems.Strings[FSelectedItem.Index]);
{      Canvas.Pen.Color:=$00eedddd;
      Canvas.MoveTo(1,siTop+FItemHeight);
      Canvas.LineTo(width-1,siTop+FItemHeight);
}
    end;
  end;

  end;
//  if (doCopyRect>0) then
    Canvas.CopyRect(Rect(0,0,Width,Height),buffBitmap.Canvas,Rect(0,0,Width,Height));
end;

procedure TNiceMenu.MouseMove(Shift: TShiftState; X, Y: Integer);
var tmpIndex: Integer;
    LastItem: Integer;
    Changed: Boolean;
begin
  inherited;
  if (ssLeft in Shift) then
  begin
    Changed:=False;
    LastItem:=((Height-(FItemHeight*FHideLastItems)) div FItemHeight);
//  if (LastItem>FItems.Count-1-FFirstItem) then LastItem:=FItems.Count-1-FFirstItem;
  tmpIndex:=FFirstItem+(Y-FTextTop) div FItemHeight;
  if (tmpIndex<FItems.Count) and (tmpIndex>=0)
   and (tmpIndex<>FSelectedItem.Index)
   and (tmpIndex>=FFirstItem)
   and (tmpIndex<FFirstItem+LastItem)
   and ((ssLeft in Shift) or (ssDouble in Shift)) then
  begin
    FSelectedItem.Index:=tmpIndex;
    Changed:=True;
  end;
  if (tmpIndex<FFirstItem) and (FFirstItem>0) then
  begin
    Dec(FFirstItem);
    Changed:=True;
  end;
  if (tmpIndex>FFirstItem+LastItem) and (FItems.Count>FFirstItem+LastItem) then
  begin
    Inc(FFirstItem);
    Changed:=True;
  end;
  if (Changed) then
  begin
    Redraw(1);
    if Assigned(FOnChange) then FOnChange(Self);
  end;

  end;
end;

procedure TNiceMenu.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  SetFocus;
  MouseMove(Shift,X,Y);
  if (ssDouble in Shift) then
    if Assigned(FOnSelect) then FOnSelect(Self);
end;


procedure TNiceMenu.SetItemHeight(Value: Byte);
begin
  FItemHeight:=Value;
  ReDraw(1);
end;

procedure TNiceMenu.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
  ReDraw(1);
end;

procedure TNiceMenu.SetHideLastItems(Value: Word);
begin
  FHideLastItems:=Value;
  ReDraw(1);
end;

procedure TNiceMenu.KeyDown(var Key: Word; Shift: TShiftState);
var LastItem: Word;
    oldSelected: Integer;
begin
  inherited;

  oldSelected:=FSelectedItem.Index;

  LastItem:=((Height-(FItemHeight*FHideLastItems)) div FItemHeight)-1;
  if (LastItem>FItems.Count-1-FFirstItem) then LastItem:=FItems.Count-1-FFirstItem;

//  ShowMessage(IntToStr(LastItem));

  if (Key=VK_UP) then FSelectedItem.Index:=FSelectedItem.Index-1;
  if (Key=VK_DOWN) then FSelectedItem.Index:=FSelectedItem.Index+1;
  if (Key=VK_HOME) then FSelectedItem.Index:=0;
  if (Key=VK_END) then FSelectedItem.Index:=FItems.Count-1;

  if (Key=VK_Prior) then FSelectedItem.Index:=FSelectedItem.Index-LastItem;
  if (Key=VK_NEXT) then FSelectedItem.Index:=FSelectedItem.Index+LastItem;

  if (FSelectedItem.Index<0) then FSelectedItem.Index:=0;
  if (FSelectedItem.Index>FItems.Count-1) then FSelectedItem.Index:=FItems.Count-1;

  if (FSelectedItem.Index<FFirstItem) then FFirstItem:=FSelectedItem.Index;
  if (FSelectedItem.Index>FFirstItem+LastItem) then FFirstItem:=FSelectedItem.Index-LastItem;

  if (oldSelected<>FSelectedItem.Index) then
  begin
    ReDraw(1);
    if Assigned(FOnChange) then FOnChange(Self);
  end;

  if (Key=VK_RETURN) then
    if Assigned(FOnSelect) then FOnSelect(Self);

end;


destructor TNiceMenu.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;


//-----------------------------------------------------------------------------
// NiceLog
//-----------------------------------------------------------------------------

procedure TNiceLog.Add(Line: String);
var i: integer;
begin
  if (Lines.Count>FMaxLines) then
  begin
    for i:=0 to 10 do Lines.Delete(0);
  end;
  Lines.Add('['+TimeToStr(Time)+'] '+Line);
  if Assigned(FOnAdd) then FOnAdd(Self);
end;


//-----------------------------------------------------------------------------
// SeqNote
//-----------------------------------------------------------------------------


constructor TSeqNote.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Selected:=False;
//  Visible:=False;
  FShape:=stRoundRect;
  FText:='Note';
  TabStop:=True;
  MDSelected:=False;
  Selected:=False;
//  ShowHint:=True;
  Deleted:=False;
  Velocity:=100;

  FBrush.Color:=$00cceeff;
  FFocusColor:=Brush.Color;
  FBgColor:=clWhite;
  FShadow:=True;
end;


procedure TSeqNote.ReDraw;
var tmpPen: TPen;
begin
  if (Deleted) then exit; // to check

  if (Canvas.TextHeight('X')>Height-2) then
  begin
    FFont.Name:='Small Fonts';
    FFont.Size:=6;
  end else
  begin
    FFont.Name:='MS Sans Serif';
    FFont.Size:=8;
  end;

  inherited ReDraw(0);

  with buffBitmap do
  begin
    if Selected then
    begin
      tmpPen:=TPen.Create;
      tmpPen.Assign(Canvas.Pen);
      Canvas.Pen.Mode:=pmXOR;
      Canvas.Brush.Color:=$00404040;
      Canvas.Rectangle(0,0,Width,Height);
      Canvas.Pen.Assign(tmpPen);
    end;
    tmpPen:=TPen.Create;
    tmpPen.Assign(Canvas.Pen);
    Canvas.Pen.Mode:=pmXOR;
    Canvas.Brush.Color:=$00444400;
    Canvas.Rectangle(1,1,Round(Width / 127*Velocity),Height-2);
    Canvas.Pen.Assign(tmpPen);
  end;

  if (doCopyRect>0) then
    Canvas.CopyRect(Rect(0,0,Width,Height),buffBitmap.Canvas,Rect(0,0,Width,Height));
end;


procedure TSeqNote.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if (Parent is TSeqBlock) then
    (Parent as TSeqBlock).OnNoteMouseMove(Self,Shift,x,y);
end;

procedure TSeqNote.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  visible:=True;
  enabled:=true;
  SetFocus;
  MDLength:=Length;
  MDWidth:=Width;
  MDVelocity:=Velocity;
  if (Parent is TSeqBlock) then
    (Parent as TSeqBlock).OnNoteMouseDown(Self,Button,Shift,x,y);
end;

procedure TSeqNote.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  MDLength:=Length;
  if (Parent is TSeqBlock) then
    (Parent as TSeqBlock).OnNoteMouseUp(Self,Button,Shift,x,y);
end;

procedure TSeqNote.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Parent is TSeqBlock) then
    (Parent as TSeqBlock).OnNoteKeyDown(Self,Key,Shift);
end;

procedure TSeqNote.WMSetFocus(var Message: TWMSetFocus);
begin
{  if (Parent is TSeqBlock) then
    (Parent as TSeqBlock).WMSetFocus(Message);
}end;

procedure TSeqNote.WMKillFocus(var Message: TWMKillFocus);
begin
{  if (Parent is TSeqBlock) then
    (Parent as TSeqBlock).WMKillFocus(Message);
}end;


//-----------------------------------------------------------------------------
// Seq Control
//-----------------------------------------------------------------------------

constructor TSeqControl.Create;
begin
  inherited Create;
  Changes:=TList.Create;
  Changes.Clear;
end;


//-----------------------------------------------------------------------------
// SeqBlock
//-----------------------------------------------------------------------------

constructor TSeqBlock.Create(AOwner: TComponent);
var i: Word;
begin
  inherited Create(AOwner);
  Name:='Block';
  FTextVAlign:=vaTop;
  Scale:=16;
  ScaleMultiplier:=4;
  HZoom:=0;
  VZoom:=3;
  Speed:=0;
  HOffset:=0;
  VOffset:=-3;
  Position:=0;
  Length:=64;
  Notes:=TList.Create;
  Notes.Clear;
  NotesClipboard:=TList.Create;
  Controls:=TList.Create;
  Controls.Clear;
  NotesClipboard.Clear;
  Color:=$00ffffff;
  FBrush.Color:=Color;
  FFocusColor:=Color;
  Deleted:=False;
  Visible:=False;
//  Brush.Color:=$00f0fff8;
//  BackgroundColor:=Color;
end;


procedure TSeqBlock.ReDraw;
begin
  Self.Brush.Color:=Self.Color;

  inherited ReDraw(0);

  if (Screen=bsNotes) then bsNotesRedraw(doCopyRect);
  if (Screen=bsView) then bsViewRedraw(doCopyRect);
  if (Screen=bsControl) then bsControlRedraw(doCopyRect);

  if (doCopyRect>0) then
  begin
//    Canvas.CopyRect(Rect(0,0,Width,Height),buffBitmap.Canvas,Rect(0,0,Width,Height));
//    with buffBitmap do
//    begin
      Canvas.Pen.Style:=psSolid;
      Canvas.Pen.Color:=$00000000;
      Canvas.Pen.Mode:=pmCopy;
      Canvas.MoveTo(0,0);
      Canvas.LineTo(width-1,0);
      Canvas.MoveTo(width-1,0);
      Canvas.LineTo(width-1,height);
      Canvas.MoveTo(width-1,height);
      Canvas.LineTo(0,height);
      Canvas.MoveTo(0,height);
      Canvas.LineTo(0,0);
//    end;
    if (ArrangerBlock <> nil) then ArrangerBlock.ReDraw(1);
  end;
end;


procedure TSeqBlock.bsNotesReDraw;
var i,s,x,y,vspace,vscale,vbottom,vtop,hright: integer;
    tmpPenColor: TColor;
    point: TPoint;
begin
  inherited ReDraw(0);
  bsNotesDrawGrid;
  with buffBitmap.Canvas do
  begin
    Font.Color:=clBlack;
    Pen.Style:=psSolid;
    TextOut(10,10,Name);
  end;
  for i:=0 to Notes.Count-1 do
  begin
    Note:=Notes.Items[i];
    if not Note.Deleted then
    begin
      Note.Visible:=True;
      Note.Parent:=Self;
      NotePosToScreen(Note,doCopyRect);
      buffBitmap.Canvas.CopyRect(Rect(Note.Left,Note.Top,Note.Left+Note.Width,Note.Top+Note.Height),Note.buffBitmap.Canvas,Rect(0,0,Note.Width,Note.Height));
    end;
  end;

  if (doCopyRect>0) then
    Canvas.CopyRect(Rect(0,0,Width,Height),buffBitmap.Canvas,Rect(0,0,Width,Height));
end;

procedure TSeqBlock.bsViewReDraw;
var i, s, minY, maxY,y1,x1,x2: integer;
    tmpvspace: Real;
    tmpPenColor: TColor;
    tmpPen: TPen;
    point1,point2: TPoint;
begin
  minY:=120;
  maxY:=0;
  for i:=0 to Notes.Count-1 do
  begin
    Note:=Notes.Items[i];
    if (minY > Note.Pitch) and (Note.Pitch>=0) then
      if ((Note.Position>=0) and (Note.Position<sqr(Scale)*ScaleMultiplier)) then
        minY:=Note.Pitch;
    if (maxY < Note.Pitch) and (Note.Pitch<120) then
      if ((Note.Position>=0) and (Note.Position<sqr(Scale)*ScaleMultiplier)) then
        maxY:=Note.Pitch;
  end;
  maxY:=maxY+2;
  minY:=minY-3;

  if (maxY=minY) then Inc(maxY);

  CalculateSizes;
  tmpvspace:=(height-4) / (maxY-minY);

  for i:=0 to Notes.Count-1 do
  begin
    Note:=Notes.Items[i];
    if not Note.Deleted then
    begin
      if (Note.Position<0) or (Note.Position>=sqr(Scale)*ScaleMultiplier) then Continue;
      point1:=bsNotesPosToScreen(Note.Position,0);
      point2:=bsNotesPosToScreen(Note.Position+Note.Length,0);
      y1:=height-Round((Note.Pitch-miny)*tmpvspace)-2;
      x1:=point1.x;
      x2:=point2.x;
      buffBitmap.Canvas.Pen.Mode:=pmMaskPenNot;
      buffBitmap.Canvas.Pen.Color:=$00999999;
      buffBitmap.Canvas.Brush.Color:=$00ffffff;
      buffBitmap.Canvas.Rectangle(x1+1,y1,x2,y1+2);
    end;
  end;

  if Selected then
  with buffBitmap do
  begin
    tmpPen:=TPen.Create;
    tmpPen.Assign(Canvas.Pen);
    Canvas.Pen.Mode:=pmXOR;
    Canvas.Brush.Color:=$00334422;
    Canvas.Rectangle(0,0,Width,Height);
    Canvas.Pen.Assign(tmpPen);
  end;

  if (doCopyRect>0) then
  begin
    Canvas.CopyRect(Rect(0,0,Width,Height),buffBitmap.Canvas,Rect(0,0,Width,Height));
  end;

end;

// Mouse

procedure TSeqBlock.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if (Screen=bsNotes) then bsNotesMouseUp(Button,Shift,X,Y);
  if (Screen=bsControl) then bsControlMouseUp(Button,Shift,X,Y);
  if (Screen=bsView) and (Parent is TSeqArranger) then
    (Parent as TSeqArranger).OnBlockMouseUp(Self,Button,Shift,X,Y);
end;

procedure TSeqBlock.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  SetFocus;
  MDLength:=Length;
  MDWidth:=Width;
  if (Screen=bsNotes) then bsNotesMouseDown(Button,Shift,X,Y);
  if (Screen=bsControl) then bsControlMouseDown(Button,Shift,X,Y);
  if (Screen=bsView) and (Parent is TSeqArranger) then
    (Parent as TSeqArranger).OnBlockMouseDown(Self,Button,Shift,X,Y);
end;

procedure TSeqBlock.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if (Screen=bsNotes) then bsNotesMouseMove(Shift,X,Y);
  if (Screen=bsControl) then bsControlMouseMove(Shift,X,Y);
  if (Screen=bsView) and (Parent is TSeqArranger) then
    (Parent as TSeqArranger).OnBlockMouseMove(Self,Shift,X,Y);

end;

// Keys

procedure TSeqBlock.KeyDown(var Key: Word; Shift: TShiftState);
var i,s: integer;
begin
  inherited;
  if (Screen=bsNotes) then bsNotesKeyDown(Key,Shift);
  if (Screen=bsView) and (Parent is TSeqArranger) then
    (Parent as TSeqArranger).OnBlockKeyDown(Self,Key,Shift);

end;

// bsNotes

procedure TSeqBlock.bsNotesMouseMove(Shift: TShiftState; X, Y: Integer);
var i,tmpVOffset,tmpHOffset,tmpHZoom, tmpVZoom: Integer;
    doRedraw: Boolean;
    tmpBrush: TBrush;
    tmpPen: TPen;
    x1,x2,y1,y2,xn1,xn2,yn1,yn2,ytop: integer;
    tmpStr: string;
    deleted: TStringList;
    point,point1,point2,point3,point4: TPoint;
begin

//  point:=ScreenToPos(x,y);
//  Canvas.TextOut(0,0,IntToStr(point.x)+' '+IntToStr(point.y));
//  ShowMessage(IntToStr(point.x)+' '+IntToStr(point.y));


//----------------------------------

  Deleted:=TStringList.Create;
  Deleted.Clear;
  for i:=0 to Notes.Count-1 do
  begin
    Note:=Notes.Items[i];
    if (Note.Deleted) then
    begin
      Deleted.Add(IntToStr(i));
    end;
  end;
//  Deleted.Sort;
  for i:=Deleted.Count-1 downto 0 do
  begin
    Log.Add('Delteting note: '+Deleted.Strings[i]);
    Note:=Notes.Items[StrToInt(Deleted.Strings[i])];
    Notes.Delete(StrToInt(Deleted.Strings[i]));
    Note.Free;
  end;
  Deleted.Free;

// --------------

  CalculateSizes;

  if (ssShift in Shift) then
  begin
    if (ssLeft in Shift) or (ssRight in Shift) then
    with buffBitmap do
    begin
      point1:=bsNotesScreenToPos(MouseDownX,MouseDownY);
      point2:=bsNotesScreenToPos(x,y);
      if (point1.x>point2.x) then
      begin
        x1:=point2.x;
        point2.x:=point1.x;
        point1.x:=x1;
      end;
      if (point1.y<point2.y) then
      begin
        y1:=point2.y;
        point2.y:=point1.y;
        point1.y:=y1;
      end;
      point3:=bsNotesPosToScreen(point1.x,point1.y);
      point4:=bsNotesPosToScreen(point2.x,point2.y);
      if (point4.x=point3.x) then inc(point4.x,2);
      for i:=0 to Notes.Count-1 do
      begin
        Note:=Notes[i];
        if ((ssLeft in Shift) and (Note.Position>=point1.x) and (Note.Position+Note.Length<=point2.x)
          and (Note.Pitch<=point1.y-1) and (Note.Pitch>=point2.y)) or
          ((ssRight in Shift) and (Note.Position>point1.x) and (Note.Position<point2.x)
          and (Note.Pitch<=point1.y-1) and (Note.Pitch>=point2.y-1)) or
          ((ssRight in Shift) and (Note.Position+Note.Length>point1.x) and (Note.Position+Note.Length<=point2.x)
          and (Note.Pitch<=point1.y-1) and (Note.Pitch>=point2.y-1)) or
          ((ssRight in Shift) and (Note.Position<=point1.x) and (Note.Position+Note.Length>=point2.x)
          and (Note.Pitch<=point1.y-1) and (Note.Pitch>=point2.y-1)) then
          begin
            if (Note.MDSelected) then
              Note.Selected:=False
            else
              Note.Selected:=True;
          end else
          begin
            if (Note.MDSelected) then
              Note.Selected:=True
            else
              Note.Selected:=False;
          end;
      end;
      if (ssLeft in Shift) then
        tmpStr:='Slow select'
      else
        tmpStr:='Fast select';

      Redraw(0);
      Canvas.Pen.Color:=$00224488;
      Canvas.Pen.Style:=psSolid;
      Canvas.Pen.Width:=1;
      Canvas.Pen.Mode:=pmXOR;
      Canvas.Brush.Color:=$00000822;
      Canvas.Rectangle(point3.x,point3.y,point4.x,point4.y);
//      Canvas.Pen.Mode:=pmCopy;
//      Canvas.Pen.Color:=$00ffffff-Canvas.Pen.Color;
      Canvas.Font.Color:=$00ffffff-Canvas.Pen.Color;
      Canvas.Brush.Color:=$00ffffff-Canvas.Brush.Color;
      Canvas.TextOut(point3.x+10,point3.y+10,tmpStr);
      Self.Canvas.CopyRect(Rect(0,0,width,height),Canvas,Rect(0,0,width,height));
    end;
  end else
  begin  // not ssShift

  if (ssRight in Shift) then
  begin
    doRedraw:=False;
    tmpHZoom:=HZoom+((X-MouseDownX) div 40);
//    if (tmpHZoom<-1) then tmpHZoom:=-1;
    if (tmpHZoom<>HZoom) then
    begin
      MouseDownX:=X;
      HZoom:=tmpHZoom;
      doRedraw:=True;
    end;
    tmpVZoom:=VZoom-((Y-MouseDownY) div 30);
    if (tmpVZoom<0) then tmpVZoom:=0;
    if (tmpVZoom<>VZoom) then
    begin
      MouseDownY:=Y;
      VZoom:=tmpVZoom;
      doRedraw:=True;
    end;
    if doRedraw then ReDraw(1);
//    Text:='HZoom '+IntToStr(HZoom);
  end;

  if (ssLeft in Shift) then
  begin
    doRedraw:=False;
    point1:=bsNotesScreenToPos(MouseDownX,MouseDownY);
    point2:=bsNotesScreenToPos(x,y);
    tmpHOffset:=HOffset+(point1.x-point2.x);
    tmpVOffset:=VOffset+(point1.y-point2.y);
    if (tmpHOffset<>HOffset) then
    begin
      MouseDownX:=X;
      HOffset:=tmpHOffset;
      doRedraw:=True;
    end;
    if (tmpVOffset<>VOffset) then
    begin
      MouseDownY:=Y;
      VOffset:=tmpVOffset;
      doRedraw:=True;
    end;
//    Text:=IntToStr(vOffset);
    if (doRedraw) then ReDraw(1);
  end;

  end; //not ssShif

end;

procedure TSeqBlock.bsNotesMouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var hspace,i: Integer;
begin

  if (ssShift in Shift) then
  begin
    for i:=0 to Notes.Count-1 do
    begin
      Note:=Notes.Items[i];
      Note.MDSelected:=Note.Selected;
    end;

  end;

  hspace:=(Width div Round(Scale) div Round(Sqrt(Scale)));
  if (HZoom>0) then hspace:=hspace*(HZoom+1);
  if (HZoom<0) then hspace:=abs(Round(hspace*(1/-3*2)));

  MDHSpace:=hspace;

end;

procedure TSeqBlock.bsNotesMouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
//  if (ssShift in Shift) then
  ReDraw(1);
end;


procedure TSeqBlock.OnNoteMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i: integer;
    dontDeselect:Boolean;
begin
  dontDeselect:=False;
  for i:=0 to Notes.Count-1 do
  begin
    Note:=Notes.Items[i];
    Note.MDLength:=Note.Length;
    Note.MDWidth:=Note.Width;
    Note.MDVelocity:=Note.Velocity;
    if not (ssShift in Shift) then
    begin
      if (Note<>(Sender as TSeqNote)) and (Note.Selected) then
      begin
        dontDeselect:=True;
        Note.Selected:=False;
        Note.Redraw(1);
      end;
    end;
  end;

  Note:=(Sender as TSeqNote);
  if Note.Selected then
  begin
    if not (dontDeselect) then
      Note.MUDeselect:=True;
  end else
  begin
    Note.MUDeselect:=False;
    Note.Selected:=True;
  end;

  Note.ReDraw(1);
end;

procedure TSeqBlock.OnNoteMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i: Integer;
begin
  Note:=(Sender as TSeqNote);
  for i:=0 to Notes.Count-1 do
  begin
    Note:=Notes.Items[i];
    if (Note.MUDeselect) then
    begin
      Note.Selected:=False;
      Note.ReDraw(1);
    end;
  end;
end;

procedure TSeqBlock.OnNoteMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var tmpLength,diffLength,i,nx,ny,tmpPos,tmpPitch,diffPos,diffPitch,
    diffVel, newVel: Integer;
    point: TPoint;
begin
  (Sender as TSeqNote).MUDeselect:=False;

  if (ssCtrl in Shift) and ((ssLeft in Shift) or (ssRight in Shift)) then
  begin
    Note:=(Sender as TSeqNote);
    diffVel:=(X-Note.MouseDownX) div 2;
    for i:=0 to Notes.Count-1 do
    begin
      Note:=Notes.Items[i];
      if (Note.Selected) then
      begin
        NewVel:=Note.MDVelocity+diffVel;
        if (newVel>127) then NewVel:=127;
        if (NewVel<0) then NewVel:=0;
        Note.Velocity:=NewVel;
        Note.Redraw(1);
      end;
    end;
    exit;
  end;

  if (ssLeft in Shift) then
  begin
    if (ssShift in Shift) then
    begin
      Note:=(Sender as TSeqNote);
      nx:=Note.Left-Note.MouseDownX+X;
      ny:=Note.Top+Note.Height-(Note.MouseDownY-y);
      tmpPos:=Note.Position;
      tmpPitch:=Note.Pitch;
      point:=bsNotesScreenToPos(nx,ny);
      diffPos:=point.x-tmpPos;
      diffPitch:=point.y-tmpPitch;
      for i:=0 to Notes.Count-1 do
      begin
        Note:=Notes.Items[i];
        if (Note.Selected) then
        begin
          Note.Position:=Note.Position+diffPos;
          Note.Pitch:=Note.Pitch+diffPitch;
        end;
      end;
    end else
    begin
      Note:=(Sender as TSeqNote);
      x:=Note.Left-Note.MouseDownX+X;
      y:=Note.Top+Note.Height-(Note.MouseDownY-y);
      NoteScreenToPos(Sender,x,y,1);
    end;
//    ReDraw(1);
  end;

  if (ssRight in Shift) then
  begin
    if (ssShift in Shift) then
    begin
      Note:=(Sender as TSeqNote);
      tmpLength:=Note.MDLength;
      point:=bsNotesScreenToPos(Note.Left+Note.MDWidth+(x-Note.MouseDownX),0);
      diffLength:=point.x-Note.Position-tmpLength;
      for i:=0 to Notes.Count-1 do
      begin
        Note:=Notes.Items[i];
        if (Note.Selected) then
        begin
          Note.Length:=Note.MDLength+diffLength;
          if Note.Length<1 then Note.Length:=1;
          if (ArrangerBlock <> nil) then ArrangerBlock.ReDraw(1);
        end;
      end; // end for
    end else begin
      Note:=(Sender as TSeqNote);
      tmpLength:=Note.Length;
      point:=bsNotesScreenToPos(Note.Left+Note.MDWidth+(x-Note.MouseDownX),0);
      Note.Length:=point.x-Note.Position;
      if Note.Length<1 then Note.Length:=1;
      if (Note.Length <> tmpLength) then
      begin
        NotePosToScreen(Note,1);
        if (ArrangerBlock <> nil) then ArrangerBlock.ReDraw(1);
      end;
    end;
  end;

end;

procedure TSeqBlock.NoteScreenToPos(Sender: TObject; X,Y: Integer; doRedraw: byte);
var tmpPos,tmpPitch: Integer;
    point: TPoint;
begin
  Note:=(Sender as TSeqNote);
  tmpPos:=Note.Position;
  tmpPitch:=Note.Pitch;
  point:=bsNotesScreenToPos(x,y);
  Note.Position:=point.x;
  Note.Pitch:=point.y;
  if (doRedraw>0) and ((tmpPos<>Note.Position)
    or (tmpPitch<>Note.Pitch)) then Redraw(1);
end;

procedure TSeqBlock.NotePosToScreen(Sender: TObject; doCopyRect: byte);
var point: TPoint;
begin
  Note:=(Sender as TSeqNote);
  if (Note.Deleted) then exit; // to check

  CalculateSizes;
  Note.Height:=NoteHeight;
  Note.Width:=Round(Note.Length*hspace);
  point:=bsNotesPosToScreen(Note.Position,Note.Pitch);
  Note.Left:=point.x;
  Note.Top:=point.y-NoteHeight+1;
  if (Note.Pitch>=0) and (Note.Pitch<120)
   and (Note.Position>=0) and (Note.Position<sqr(scale)*ScaleMultiplier) then
    Note.FText:=PitchToNote(Note.Pitch)
  else
    Note.FText:='Ignored';

  Note.Hint:='Position: '+IntToStr(Note.Position)+chr(13)
               +'Length:  '+IntToStr(Note.Length)+chr(13)
               +'Velocity  '+IntToStr(Note.Velocity);
  Note.Redraw(doCopyRect);

end;

// *** bs Notes *** //

procedure TSeqBlock.CalculateSizes;
var tmpEO,tmpHZoom,tmpVZoom: Integer;
    hzmp: real;
begin
  tmpEO:=2;
  tmpHZoom:=1;
  tmpVZoom:=0;
  if (Screen=bsNotes) or (Screen=bsControl) then
  begin
    tmpEO:=EditorOffset;
    tmpHZoom:=HZoom;
    tmpVZoom:=VZoom;
  end;
  if (tmpHZoom>=0) then
  begin
    if (Screen=bsView) then tmpHZoom:=0;
    hspace:=(Width-(tmpEO*2))*(tmpHZoom+1)/(sqr(Scale)*ScaleMultiplier);
  end else
  begin
    hzmp:=0.60;
    if (tmpHZoom=-1) then hzmp:=1;
    hspace:=(Width-(tmpEO*2))*abs(1/(tmpHZoom*hzmp))/(sqr(Scale)*ScaleMultiplier);
  end;
  vspace:=(Height-(tmpEO*2))*(tmpVZoom+1)/120;
  NoteHeight:=Round(vspace*120/70);
end;

function TSeqBlock.bsNotesPosToScreen(Pos,Pitch: Integer):TPoint;
begin
  if (SpaceType=stLinear) then result:=bsNotesPosToScreenLinear(Pos,Pitch);
end;

function TSeqBlock.bsNotesScreenToPos(X,Y: Integer):TPoint;
begin
  if (SpaceType=stLinear) then result:=bsNotesScreenToPosLinear(X,Y);
end;

procedure TSeqBlock.bsNotesDrawGrid;
begin
  if (SpaceType=stLinear) then bsNotesDrawGridLinear;
end;

function TSeqBlock.bsNotesPosToScreenLinear(Pos,Pitch: Integer):TPoint;
var x,y,tmpEO, tmpHOffset: integer;
begin
  CalculateSizes;
  tmpEO:=0;
  tmpHOffset:=0;
  if (Screen=bsNotes) or (Screen=bsControl) then
  begin
    tmpEO:=EditorOffset;
    tmpHOffset:=HOffset;
  end;
  x:=tmpEO+Round(((Pos)-tmpHOffset)*hspace);
  y:=Height-tmpEO-Round((Pitch-VOffset)*vspace);
  result:=Point(x,y);
end;

function TSeqBlock.bsNotesScreenToPosLinear(X,Y: Integer):TPoint;
var pos,pitch: Integer;
begin
  CalculateSizes;
  pos:=Round((x-EditorOffset)/hspace)+HOffset;
  pitch:=Round((height-y-EditorOffset)/vspace)+VOffset;
  result:=Point(pos,pitch);
end;

procedure TSeqBlock.bsNotesDrawGridLinear;
var i,s,x,y,x1,y1,hsteps,vsteps: integer;
    point,min,max: TPoint;
    tmpStr: String;
begin
  hsteps:=sqr(Scale)*ScaleMultiplier;
  vsteps:=120;

  min:=bsNotesPosToScreen(0,0);
  max:=bsNotesPosToScreen(hsteps,120);

  with buffBitmap do
  begin
    for i:=0 to hsteps do
    begin
      s:=i;
      if (s>sqr(scale)*scalemultiplier) then break;
      point:=bsNotesPosToScreen(s,0);
      x:=point.x;
      Canvas.MoveTo(x,max.y);
      Canvas.Pen.Style:=psDot;
      if (s=0) then
        Canvas.Pen.Color:=clGreen
      else if (s=hsteps) then
        Canvas.Pen.Color:=clRed
      else if (s mod sqr(Scale)=0) then
        Canvas.Pen.Color:=clGray
      else
      begin
        Canvas.Pen.Color:=$00f0f0f0;
        Canvas.Pen.Style:=psSolid;
      end;
      if (s mod scale=0) then
      begin
        Canvas.LineTo(x,min.y);
        tmpStr:=IntToStr(i div scale);
        x1:=x+5;
        y1:=10;
        if (max.y-5>10) then y1:=max.y-Canvas.TextHeight(tmpStr)-5;
        if (s mod sqr(scale)=0) then Canvas.TextOut(x1,y1,tmpStr);
      end;
    end;

    Canvas.Pen.Style:=psDot;
    for i:=0 to vsteps do
    begin
      s:=i;
      point:=bsNotesPosToScreen(0,s);
      y:=point.y;
      if (y<1) then continue;
      Canvas.MoveTo(min.x,y);
      if (i=0) then
        Canvas.Pen.Color:=clGreen
      else if (i=vsteps) then
        Canvas.Pen.Color:=clRed
      else
        Canvas.Pen.Color:=clGray;
      if (i mod 12=0) then
      begin
        Canvas.LineTo(max.x,y);
        tmpStr:=PitchToNote(i);
        x1:=10;
        if (min.x-8>10) then x1:=min.x-Canvas.TextWidth(tmpStr)-8;
        y1:=y-Canvas.TextHeight(tmpStr) div 2;
        Canvas.Pen.Color:=clBlack;
        Canvas.TextOut(x1,y1,tmpStr);
      end;
    end;

  end;

end;


// *** bs Control *** //

function TSeqBlock.bsControlPosToScreen(Pos,Value: Integer):TPoint;
begin
  if (SpaceType=stLinear) then result:=bsControlPosToScreenLinear(Pos,Value);
end;

function TSeqBlock.bsControlScreenToPos(X,Y: Integer):TPoint;
begin
  if (SpaceType=stLinear) then result:=bsControlScreenToPosLinear(X,Y);
end;

procedure TSeqBlock.bsControlDrawGrid;
begin
  if (SpaceType=stLinear) then bsControlDrawGridLinear;
end;

function TSeqBlock.bsControlPosToScreenLinear(Pos,Value: Integer):TPoint;
var x,y,tmpEO, tmpHOffset: integer;
    point1: TPoint;
begin
  Control:=Controls.Items[SelectedControl];
  CalculateSizes;
  tmpEO:=EditorOffset;
  point1:=bsNotesPosToScreen(Pos,0);
  x:=point1.x;
  y:=Height-(EditorOffset+Round((Height-3*EditorOffset)*Value/(Control.MaxValue-Control.MinValue)));
  result:=Point(x,y);
end;

function TSeqBlock.bsControlScreenToPosLinear(X,Y: Integer):TPoint;
var pos,value: Integer;
    point1: TPoint;
    vspace: Real;
begin
  CalculateSizes;
  point1:=bsNotesScreenToPos(x,0);
  pos:=point1.x;
  vspace:=(Height-3*EditorOffset)/(Control.MaxValue-Control.MinValue);
  value:=Round((Control.MaxValue-Control.MinValue)-(Y/vspace)+2*EditorOffset/vspace);
  result:=Point(pos,value);
end;

procedure TSeqBlock.bsControlDrawGridLinear;
var i,s,x,y,x1,y1,hsteps,vsteps: integer;
    point,point1,point2,min,max: TPoint;
    tmpStr: String;
begin
  Control:=Controls.Items[SelectedControl];

  hsteps:=sqr(Scale)*ScaleMultiplier;
  vsteps:=Control.MaxValue-Control.MinValue;

  min:=bsControlPosToScreen(0,Control.MinValue);
  max:=bsControlPosToScreen(hsteps,Control.MaxValue);

  with buffBitmap do
  begin
    for i:=0 to hsteps do
    begin
      s:=i;
      if (s>hsteps) then break;
      point:=bsControlPosToScreen(s,Control.MaxValue);
      x:=point.x;
      Canvas.MoveTo(x,max.y);
      Canvas.Pen.Style:=psDot;
      if (s=0) then
        Canvas.Pen.Color:=clGreen
      else if (s=hsteps) then
        Canvas.Pen.Color:=clRed
      else if (s mod sqr(Scale)=0) then
        Canvas.Pen.Color:=clGray
      else
      begin
        Canvas.Pen.Color:=$00f0f0f0;
        Canvas.Pen.Style:=psSolid;
      end;
      if (s mod scale=0) then
      begin
        Canvas.LineTo(x,min.y);
        tmpStr:=IntToStr(i div scale);
        x1:=x+5;
        y1:=10;
        if (max.y-5>10) then y1:=max.y-Canvas.TextHeight(tmpStr)-5;
        if (s mod sqr(scale)=0) then Canvas.TextOut(x1,y1,tmpStr);
      end;
    end;

    Canvas.Pen.Style:=psDot;
    Canvas.Pen.Color:=clGray;
    y:=Control.ZeroValue;
    tmpStr:=IntToStr(y);
    point1:=bsControlPosToScreen(0,y);
    point2:=bsControlPosToScreen(hsteps,Control.ZeroValue);
    Canvas.MoveTo(point1.x,point1.y);
    Canvas.LineTo(point2.x,point2.y);
    Canvas.TextOut(point1.x-10-Canvas.TextWidth(tmpStr),point1.y-Canvas.TextHeight(tmpStr) div 2,tmpStr);

    y:=Round(Control.ZeroValue+(Control.MaxValue-Control.ZeroValue)/2);
    tmpStr:=IntToStr(y);
    point1:=bsControlPosToScreen(0,y);
    point2:=bsControlPosToScreen(hsteps,y);
    Canvas.MoveTo(point1.x,point1.y);
    Canvas.LineTo(point2.x,point2.y);
    Canvas.TextOut(point1.x-10-Canvas.TextWidth(tmpStr),point1.y-Canvas.TextHeight(tmpStr) div 2,tmpStr);

    y:=Round((Control.ZeroValue-Control.MinValue)/2);
    tmpStr:=IntToStr(y);
    point1:=bsControlPosToScreen(0,y);
    point2:=bsControlPosToScreen(hsteps,y);
    Canvas.MoveTo(point1.x,point1.y);
    Canvas.LineTo(point2.x,point2.y);
    Canvas.TextOut(point1.x-10-Canvas.TextWidth(tmpStr),point1.y-Canvas.TextHeight(tmpStr) div 2,tmpStr);

    tmpStr:=IntToStr(Control.MaxValue);
    Canvas.Pen.Color:=clRed;
    point1:=bsControlPosToScreen(0,Control.MaxValue);
    point2:=bsControlPosToScreen(hsteps,Control.MaxValue);
    Canvas.MoveTo(point1.x,point1.y);
    Canvas.LineTo(point2.x,point2.y);
    Canvas.TextOut(point1.x-10-Canvas.TextWidth(tmpStr),point1.y-Canvas.TextHeight(tmpStr) div 2,tmpStr);

    tmpStr:=IntToStr(Control.MinValue);
    Canvas.Pen.Color:=clGreen;
    point1:=bsControlPosToScreen(0,Control.MinValue);
    point2:=bsControlPosToScreen(hsteps,Control.MinValue);
    Canvas.MoveTo(point1.x,point1.y);
    Canvas.LineTo(point2.x,point2.y);
    Canvas.TextOut(point1.x-10-Canvas.TextWidth(tmpStr),point1.y-Canvas.TextHeight(tmpStr) div 2,tmpStr);

  end;
end;


procedure TSeqBlock.bsControlRedraw(doCopyRect: Byte);
var i,cwidth: integer;
    point1,point2: TPoint;
begin
  if (Controls.Count<=0) then exit;

  bsControlDrawGrid;

  point1:=bsControlPosToScreen(0,0);
  point2:=bsControlPosToScreen(1,0);
  cwidth:=point2.x-point1.x+1;

  Control:=Controls.Items[SelectedControl];

  with buffBitmap.Canvas do
  begin
    for i:=0 to Control.Changes.Count-1 do
    begin
      Change:=Control.Changes.Items[i];
      point1:=bsControlPosToScreen(Change.Position,Control.ZeroValue);
      point2:=bsControlPosToScreen(Change.Position,Change.Value);
      if (point2.y<point1.y) then Inc(point1.y);
      Pen.Style:=psSolid;
      Pen.Color:=$004444ff;
      Brush.Color:=Pen.Color;
      Rectangle(point1.x,point1.y,point1.x+cwidth,point2.y+1);
      Font.Color:=$00ffffff;
//      TextOut(point2.x,point2.y,IntToStr(Change.Value));
    end;

    Font.Color:=clBlack;
    Pen.Style:=psSolid;
    Brush.Color:=Color;
    TextOut(10,10,Name);
  end;

  for i:=0 to Notes.Count-1 do
  begin
    Note:=Notes.Items[i];
    if not Note.Deleted then
    begin
      Note.Visible:=False;
      Note.Parent:=Self;
      NotePosToScreen(Note,0);
      Note.buffBitmap.Canvas.Pen.Mode:=pmMergeNotPen;
      Note.buffBitmap.Canvas.Brush.Color:=$00868686;
      Note.buffBitmap.Canvas.Rectangle(0,0,Note.Width,Note.Height);
      Note.buffBitmap.Canvas.Pen.Mode:=pmCopy;
      buffBitmap.Canvas.CopyMode:=cmSrcAnd;
      buffBitmap.Canvas.CopyRect(Rect(Note.Left,Note.Top,Note.Left+Note.Width,Note.Top+Note.Height),Note.buffBitmap.Canvas,Rect(0,0,Note.Width,Note.Height));
      buffBitmap.Canvas.CopyMode:=cmSrcCopy;
    end;
  end;

  if (doCopyRect>0) then
  begin
    Canvas.CopyRect(Rect(0,0,Width,Height),buffBitmap.Canvas,Rect(0,0,Width,Height));
  end;
end;

procedure TSeqBlock.bsControlMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var point1: TPoint;
begin
  Control:=Controls[SelectedControl];
  MDEditControl:=False;
  point1:=bsControlScreenToPos(x,y);
  if (point1.y>=Control.MinValue) and (point1.y<=Control.MaxValue)
    and (point1.x<=0) and (point1.x>=sqr(Scale)*ScaleMultiplier) then
  begin
    MDEditControl:=True;
  end;
  bsControlMouseMove(Shift,X,Y);
end;

procedure TSeqBlock.bsControlMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Redraw(1);
end;

procedure TSeqBlock.bsControlMouseMove(Shift: TShiftState; X, Y: Integer);
var doRedraw: Boolean;
    point1, point2: TPoint;
    i,n,s,tmpHOffset, tmpVOffset, tmpHZoom, tmpVZoom: integer;
begin
  point2:=bsControlScreenToPos(MouseDownX,MouseDownY);
  Control:=Controls[SelectedControl];

  // Move

  if (ssLeft in Shift) and (not (MDEditControl))
    and ((point2.x<0) or (point2.x>sqr(scale)*ScaleMultiplier)
    or (point2.y<Control.MinValue) or (point2.y>Control.MaxValue))then
  begin
    doRedraw:=False;
    point1:=bsControlScreenToPos(MouseDownX,MouseDownY);
    point2:=bsControlScreenToPos(x,y);
    tmpHOffset:=HOffset+(point1.x-point2.x);
    tmpVOffset:=VOffset+Round((point1.y-point2.y)/vspace);
    if (tmpHOffset<>HOffset) then
    begin
      MouseDownX:=X;
      HOffset:=tmpHOffset;
      doRedraw:=True;
    end;
    if (tmpVOffset<>VOffset) then
    begin
      MouseDownY:=Y;
      VOffset:=tmpVOffset;
      doRedraw:=True;
    end;
    if (doRedraw) then ReDraw(1);
  end;

  // Zoom

  if (ssRight in Shift) and (not (MDEditControl))
    and ((point2.x<0) or (point2.x>sqr(scale)*ScaleMultiplier)
    or (point2.y<Control.MinValue) or (point2.y>Control.MaxValue))then
  begin
    doRedraw:=False;
    tmpHZoom:=HZoom+((X-MouseDownX) div 40);
//    if (tmpHZoom<-1) then tmpHZoom:=-1;
    if (tmpHZoom<>HZoom) then
    begin
      MouseDownX:=X;
      HZoom:=tmpHZoom;
      doRedraw:=True;
    end;
    tmpVZoom:=VZoom-((Y-MouseDownY) div 30);
    if (tmpVZoom<0) then tmpVZoom:=0;
    if (tmpVZoom<>VZoom) then
    begin
      MouseDownY:=Y;
      VZoom:=tmpVZoom;
      doRedraw:=True;
    end;
    if doRedraw then ReDraw(1);
  end;

  // Edit

  if (ssLeft in Shift) and (not (MDEditControl))
    and (point2.x>=0) and (point2.x<=sqr(scale)*ScaleMultiplier-1)
    and (point2.y>=Control.MinValue) and (point2.y<=Control.MaxValue) then
  begin
    point1:=bsControlScreenToPos(MouseDownX,MouseDownY);
    point2:=bsControlScreenToPos(x,y);
    if (point2.x<0) or (point2.x>sqr(scale)*ScaleMultiplier-1) then exit;
    s:=-1;
    for i:=0 to Control.Changes.Count-1 do
    begin
      Change:=Control.Changes[i];
      if (Change.Position=point2.x) then s:=i;
    end;
    if (s=-1) then
    begin
      Change:=TSeqChange.Create;
      Change.Position:=point2.x;
      Change.Value:=point2.y;
      Control.Changes.Add(Change);
      s:=Control.Changes.Count-1;
      Log.Add('Adding change');
    end;
    Change:=Control.Changes[s];
    if (point2.y>Control.MaxValue) then point2.y:=Control.MaxValue;
    if (point2.y<Control.MinValue) then point2.y:=Control.MinValue;
    Change.Value:=point2.y;
    Redraw(1);
  end;

  // Delete

  if (ssRight in Shift) and (not (MDEditControl))
    and (point2.x>=0) and (point2.x<=sqr(scale)*ScaleMultiplier-1)
    and (point2.y>=Control.MinValue) and (point2.y<=Control.MaxValue) then
  begin
    point1:=bsControlScreenToPos(MouseDownX,MouseDownY);
    point2:=bsControlScreenToPos(x,y);
    s:=-1;
    for i:=0 to Control.Changes.Count-1 do
    begin
      Change:=Control.Changes[i];
      if (Change.Position=point2.x) then s:=i;
    end;
    if (s>-1) and (s<Control.Changes.Count) then Control.Changes.Delete(s);
    Redraw(1);
  end;
//  Log.Add('Selected control: '+IntToStr(SelectedControl));

end;


// *** Keyboard *** //

procedure TSeqBlock.OnNoteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var i,s: integer;
begin
  bsNotesKeyDown(Key,Shift);
end;

procedure TSeqBlock.bsNotesKeyDown(var Key: Word; Shift: TShiftState);
var i,s: integer;
begin
//  ShowMessage(IntToStr(Key));
  for i:=0 to Notes.Count-1 do
  begin
    Note:=Notes.Items[i];
    if (Note.Selected) then
    begin
      if Key=VK_LEFT then Note.Position:=Note.Position-1;
      if Key=VK_RIGHT then Note.Position:=Note.Position+1;
      if Key=VK_HOME then Note.Position:=Note.Position-Scale;
      if Key=VK_END then Note.Position:=Note.Position+Scale;
      if Key=VK_UP then Note.Pitch:=Note.Pitch+1;
      if Key=VK_DOWN then Note.Pitch:=Note.Pitch-1;
      if Key=VK_PRIOR then Note.Pitch:=Note.Pitch+12;
      if Key=VK_NEXT then Note.Pitch:=Note.Pitch-12;
      if Key=VK_ESCAPE then Note.Selected:=False;
      NotePosToScreen(Note,1);
      if Key=VK_DELETE then Note.Deleted:=True;
    end;
  end; // end for

  if Key=VK_INSERT then
  begin
    Note:=TSeqNote.Create(Self);
    Note.Visible:=False;
    Note.Position:=hoffset+2;
    Note.Pitch:=voffset+2;
    Note.Length:=8;
    Note.Parent:=Self;
    Notes.Add(Note);
    NotePosToScreen(Note,1);
    Note.Visible:=True;
  end;

  if (Key=67) and (ssCtrl in Shift) then CopyNotes();
  if (Key=86) and (ssCtrl in Shift) then PasteNotes();

  if (Key=VK_LEFT) or (Key=VK_Right) or (Key=VK_UP) or (Key=VK_DOWN)
    or (Key=VK_ESCAPE) or (Key=VK_DELETE) or (Key=VK_INSERT)then
      Redraw(1);
end;

procedure TSeqBlock.GetData(Block: TSeqBlock);
var i,s: integer;
begin
  Name:=Block.Name;
//  Length:=Block.Length;
//  Position:=Block.Position;
  Scale:=Block.Scale;
  ScaleMultiplier:=Block.ScaleMultiplier;
  HZoom:=Block.HZoom;
  VZoom:=Block.VZoom;
  Speed:=Block.Speed;
  HOffset:=Block.HOffset;
  VOffset:=Block.VOffset;
  SpaceType:=Block.SpaceType;
  Notes:=Block.Notes;
//  Screen:=Block.Screen;
//  SelectedControl:=Block.SelectedControl;
  for i:=0 to Notes.Count-1 do
  begin
    Note:=Notes[i];
 //   Note.Parent:=Self;
  end;
  Controls:=Block.Controls;
{
  for i:=0 to Controls.Count-1 do
  begin
    Control:=Controls[i];
  end;
}
end;

procedure TSeqBlock.WMSetFocus(var Message: TWMSetFocus);
begin
  CopyBack:=True;
  if (ArrangerBlock<>nil) then
  begin
    GetData(ArrangerBlock);
  end;
end;

procedure TSeqBlock.WMKillFocus(var Message: TWMKillFocus);
var i: integer;
begin
  if (ArrangerBlock<>nil) then
  begin
    ArrangerBlock.GetData(Self);
  end;
end;


procedure TSeqBlock.CopyNotes();
var i: integer;
    NewNote: TSeqNote;
begin
  Log.Add('CopyNotes');
  NotesClipBoard.Clear;
  for i:=0 to Notes.Count-1 do
  begin
    Note:=Notes.Items[i];
    if (Note.Selected) then
    begin
      Log.Add('Note copied: '+IntToStr(i));
      NewNote:=TSeqNote.Create(Self);
      NewNote.Visible:=False;
      NewNote.Pitch:=Note.Pitch;
      NewNote.Position:=Note.Position;
      NewNote.Length:=Note.Length;
      NewNote.Velocity:=Note.Velocity;
      NotesClipboard.Add(NewNote);
    end;
  end;
end;

procedure TSeqBlock.PasteNotes();
var i,maxPitch,minPos,diffPitch,diffPos: integer;
    NewNote: TSeqNote;
    point: TPoint;
begin
  maxPitch:=0;
  minPos:=30000;
  Log.Add('Paste Notes');
  for i:=0 to NotesClipboard.Count-1 do
  begin
    Note:=NotesClipboard.Items[i];
    if (Note.Pitch>maxPitch) then maxPitch:=Note.Pitch;
    if (Note.Position<minPos) then minPos:=Note.Position;
  end;
  point:=bsNotesScreenToPos(MouseMoveX,MouseMoveY);
  diffPitch:=point.y-maxPitch;
  diffPos:=point.x-minPos;
  for i:=0 to Notes.Count-1 do
  begin
    Note:=Notes.Items[i];
    Note.Selected:=False;
  end;
  for i:=0 to NotesClipboard.Count-1 do
  begin
    Note:=NotesClipboard.Items[i];
    NewNote:=TSeqNote.Create(Self);
    NewNote.Visible:=False;
    NewNote.Pitch:=Note.Pitch+diffPitch;
    NewNote.Position:=Note.Position+diffPos;
    NewNote.Length:=Note.Length;
    NewNote.Velocity:=Note.Velocity;
    NewNote.Selected:=True;
    Notes.Add(NewNote);
  end;
  ReDraw(1);
end;


//-----------------------------------------------------------------------------
// Seq Arranger
//-----------------------------------------------------------------------------

constructor TSeqArranger.Create(AOwner: TComponent);
var i: Word;
begin
  inherited Create(AOwner);
  Blocks:=TList.Create;
  Block:=TSeqBlock.Create(AOwner);
  Block.Visible:=False;
  Tracks:=TList.Create;
  PosBarHeight:=24;
  TrackHeight:=32;
  Length:=1875;
  Scale:=4;
  HZoom:=0;
  VZoom:=0;
  HOffset:=0;
  VOffset:=0;
  LoopStart:=0;
  LoopEnd:=16;
  PlayPos:=0;
  DisplayPos:=0;
  FText:='';
  FShadow:=True;
  Color:=$00ffffff;
  FBrush.Color:=Color;
  FFocusColor:=Color;

  BlocksClipboard:=TList.Create;

end;

procedure TSeqArranger.CalculateSizes;
begin
  if (HZoom>=0) then
    hspace:=(width-(2*ArrangerOffset))*(HZoom+1)/Length
  else
    hspace:=(width-(2*ArrangerOffset))*abs(1/HZoom)/Length;
end;

function TSeqArranger.PosToScreen(Pos,Track: Integer):TPoint;
var x,y: integer;
begin
  CalculateSizes;
  x:=ArrangerOffset+Round((Pos-HOffset)*hspace);
  y:=PosBarHeight+Round((Track+VOffset)*TrackHeight);
  result:=Point(x,y);
end;

function TSeqArranger.ScreenToPos(x,y: Integer):TPoint;
var pos,track,divider: Integer;
begin
  CalculateSizes;
  pos:=Round((x-ArrangerOffset)/hspace)+hoffset;
  divider:=Round(hspace/sqr(hspace)*10);
  if (divider mod 4 <>0) then Inc(divider,4-divider mod 4);
  if (divider>0) then
  begin
    pos:=(pos div divider)*divider;
  end;
  track:=Round((y-(2*PosBarHeight))/TrackHeight-voffset);
  result:=Point(pos,track);
end;

procedure TSeqArranger.ReDraw(doCopyRect: Byte);
var i,s,x,y,vspace,hspace: Integer;
    point1,point2: TPoint;
    tmpTrack: TSeqTrack;
begin
  inherited Redraw(0);

  with buffBitmap do
  begin
    for i:=0 to Length do
    begin
      s:=i;
      if (s mod sqr(Scale) <>0) then continue;
      Canvas.Pen.Style:=psDot;
      if (s=0) then
        Canvas.Pen.Color:=clGreen
      else if (s=Length) then
        Canvas.Pen.Color:=clRed
      else if (s mod (sqr(scale)*scale)=0) then
        Canvas.Pen.Color:=clGray
      else
      begin
        Canvas.Pen.Style:=psSolid;
        Canvas.Pen.Color:=$00f0f0f0;
      end;

      point1:=PosToScreen(s,0);
      Canvas.MoveTo(point1.x,0);
      Canvas.LineTo(point1.x,PosBarHeight);
//      Canvas.TextOut(point1.x,5,IntToStr(s));

//      point1:=PosToScreen(s,0);
//      point2:=PosToScreen(s+1,0);
      Canvas.TextOut(point1.x,point1.y-PosBarHeight+5,IntToStr(s));
      Canvas.MoveTo(point1.x,point1.y);
      point1:=PosToScreen(s,Tracks.Count);
      Canvas.LineTo(point1.x,point1.y);
    end;

    for i:=0 to Tracks.Count do
    begin
      Canvas.Pen.Style:=psDot;
      if (i=0) then
        Canvas.Pen.Color:=clGreen
      else if (i=Tracks.Count) then
        Canvas.Pen.Color:=clRed
      else
      begin
        Canvas.Pen.Style:=psSolid;
        Canvas.Pen.Color:=$00f0f0f0;
      end;
      point1:=PosToScreen(0,i);
      if (i<Tracks.Count) then
      begin
        tmpTrack:=Tracks.Items[i];
        Canvas.TextOut(point1.x-Canvas.TextWidth(tmpTrack.Name)-10,point1.y+10,tmpTrack.Name);
      end;
      Canvas.MoveTo(point1.x,point1.y);
      point1:=PosToScreen(Length,i);
      Canvas.LineTo(point1.x,point1.y);
    end;

    Canvas.Pen.Style:=psSolid;
    Canvas.Pen.Color:=clBlack;
    Canvas.MoveTo(0,PosBarHeight);
    Canvas.LineTo(width,PosBarHeight);

    point1:=ScreenToPos(0,0);
    point2:=ScreenToPos(width,height);

    for i:=0 to Blocks.Count-1 do
    begin
      Block:=Blocks.Items[i];
      if (Block.Track>=0) and (Block.Track<=Tracks.Count-1) then
      begin
        tmpTrack:=Tracks[Block.Track];
        Block.Color:=tmpTrack.Color;
      end else
        Block.Color:=clWhite;

      if not Block.Deleted then
      begin
      if (Block.Position>=point1.x) and (Block.Position<=point2.x)
//      and(Block.Track>=point1.y) and (Block.Track<=point2.y)
      then
      begin
        Block.Parent:=Self;
//        Block.BringToFront;
//      Block.Visible:=False;
        BlockPosToScreen(Block);
      end
      else Log.Add('Skip block: '+Block.Name);
      end;
    end;

    if (LoopStart-LoopEnd<>0) then
    begin
      point1:=PosToScreen(LoopStart,0);
      point2:=PosToScreen(LoopEnd,0);
      Canvas.Pen.Mode:=pmXOR;
//      Canvas.Pen.Mode:=pmMaskNotPen;
      Canvas.Brush.Color:=$00660033;
      Canvas.Rectangle(point1.x,0,point2.x,PosBarHeight);
      Canvas.Pen.Color:=Canvas.Brush.Color;
//      Canvas.Pen.Mode:=pmCopy;
      Canvas.MoveTo(point1.x,0);
      Canvas.LineTo(point1.x,height);
      Canvas.MoveTo(point2.x,0);
      Canvas.LineTo(point2.x,height);
    end;

    Canvas.Pen.Style:=psSolid;
    Canvas.Pen.Color:=$002222ff;
    Canvas.Pen.Mode:=pmCopy;
    point1:=PosToScreen(DisplayPos,0);
    Canvas.MoveTo(point1.x,0);
    Canvas.LineTo(point1.x,height);

    Canvas.Pen.Style:=psSolid;
    Canvas.Pen.Color:=$00000000;
    Canvas.Pen.Mode:=pmCopy;
    point1:=PosToScreen(0,0);
    Canvas.MoveTo(0,0);
    Canvas.LineTo(width-1,0);
    Canvas.MoveTo(width-1,0);
    Canvas.LineTo(width-1,height);
    Canvas.MoveTo(width-1,height);
    Canvas.LineTo(0,height);
    Canvas.MoveTo(0,height);
    Canvas.LineTo(0,0);
  end; //end with buffBitmap do

  if (doCopyRect>0) then
    Canvas.CopyRect(Rect(0,0,Width,Height),buffBitmap.Canvas,Rect(0,0,width,height));

end;


procedure TSeqArranger.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  SetFocus;
  if (Screen=asArranger) then asArrangerMouseDown(Button,Shift,X,Y);
end;

procedure TSeqArranger.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if (Screen=asArranger) then asArrangerMouseUp(Button,Shift,X,Y);
end;

procedure TSeqArranger.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if (Screen=asArranger) then asArrangerMouseMove(Shift,X,Y);
end;

procedure TSeqArranger.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Screen=asArranger) then asArrangerKeyDown(Key,Shift);
end;

function TSeqArranger.MouseDownSample(x: Integer):Integer;
begin
  result:=x;
end;

procedure TSeqArranger.asArrangerMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i: integer;
begin
  if (LoopStart>LoopEnd) then
  begin
    i:=LoopEnd;
    LoopEnd:=LoopStart;
    LoopStart:=i;
  end;
  ReDraw(1);
end;

procedure TSeqArranger.asArrangerMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var point1: TPoint;
    diff: integer;
begin
  diff:=PlayPos-DisplayPos;
  point1:=ScreenToPos(X,0);
  if (Y<PosBarHeight) and (ssLeft in Shift) then
    PlayPos:=point1.x;

  if (Y<PosBarHeight) and (ssRight in Shift) then
  begin
    LoopStart:=point1.x;
    LoopEnd:=point1.x;
  end;
  DisplayPos:=PlayPos;
  Log.Add('PP: '+IntToStr(PlayPos)+' DP: '+IntToStr(DisplayPos));
  ReDraw(1);
end;

procedure TSeqArranger.asArrangerMouseMove(Shift: TShiftState; X, Y: Integer);
var i,s,vspace,hspace,x1,y1: Integer;
    tmpHoffset, tmpVoffset, tmpHZoom, tmpVZoom: Integer;
    doReDraw: boolean;
    Deleted: TStringList;
    point1,point2,point3,point4: TPoint;
    tmpStr: String;
begin

//----------------------------------

  Deleted:=TStringList.Create;
  Deleted.Clear;
  for i:=0 to Blocks.Count-1 do
  begin
    Block:=Blocks.Items[i];
    if (Block.Deleted) then
      Deleted.Add(IntToStr(i));
  end;
  for i:=Deleted.Count-1 downto 0 do
  begin
    Block:=Blocks.Items[StrToInt(Deleted.Strings[i])];
    Blocks.Delete(StrToInt(Deleted.Strings[i]));
    Block.Free;
  end;
  Deleted.Free;

// --------------

  if (MouseDownY<PosBarHeight) and (ssLeft in Shift) then
  begin
    point1:=ScreenToPos(X,0);
    PlayPos:=point1.x;
    Redraw(1);
    exit;
  end;
  if (MouseDownY<PosBarHeight) and (ssRight in Shift) then
  begin
    point1:=ScreenToPos(X,0);
    LoopEnd:=point1.x;
    Redraw(1);
    exit;
  end;


  if (ssShift in Shift) then
  begin
    if (ssLeft in Shift) or (ssRight in Shift) then
    with buffBitmap do
    begin
      point1:=ScreenToPos(MouseDownX,MouseDownY);
      point2:=ScreenToPos(x,y);
      if (point1.x>point2.x) then
      begin
        x1:=point2.x;
        point2.x:=point1.x;
        point1.x:=x1;
      end;
      if (point1.y<point2.y) then
      begin
        y1:=point2.y;
        point2.y:=point1.y;
        point1.y:=y1;
      end;
      point3:=PosToScreen(point1.x,point1.y);
      point4:=PosToScreen(point2.x,point2.y);
      if (point4.x=point3.x) then inc(point4.x,2);
      for i:=0 to Blocks.Count-1 do
      begin
        Block:=Blocks[i];
        if ((ssLeft in Shift) and (Block.Position>=point1.x) and (Block.Position+Block.Length<=point2.x)
          and (Block.Track<=point1.y-1) and (Block.Track>=point2.y)) or
          ((ssRight in Shift) and (Block.Position>point1.x) and (Block.Position<point2.x)
          and (Block.Track<=point1.y-1) and (Block.Track>=point2.y)) or
          ((ssRight in Shift) and (Block.Position+Block.Length>point1.x) and (Block.Position+Block.Length<=point2.x)
          and (Block.Track<=point1.y-1) and (Block.Track>=point2.y)) or
          ((ssRight in Shift) and (Block.Position<=point1.x) and (Block.Position+Block.Length>=point2.x)
          and (Block.Track<=point1.y-1) and (Block.Track>=point2.y)) then
          begin
            if (Block.MDSelected) then
              Block.Selected:=False
            else
              Block.Selected:=True;
          end else
          begin
            if (Block.MDSelected) then
              Block.Selected:=True
            else
              Block.Selected:=False;
          end;
      end;
      if (ssLeft in Shift) then
        tmpStr:='Slow select'
      else
        tmpStr:='Fast select';

      Redraw(0);
      Canvas.Pen.Color:=$00224488;
      Canvas.Pen.Style:=psSolid;
      Canvas.Pen.Width:=1;
      Canvas.Pen.Mode:=pmXOR;
      Canvas.Brush.Color:=$00000822;
      Canvas.Rectangle(point3.x,point3.y,point4.x,point4.y);
//      Canvas.Pen.Mode:=pmCopy;
//      Canvas.Pen.Color:=$00ffffff-Canvas.Pen.Color;
      Canvas.Font.Color:=$00ffffff-Canvas.Pen.Color;
      Canvas.Brush.Color:=$00ffffff-Canvas.Brush.Color;
      Canvas.TextOut(point3.x+10,point4.y+10,tmpStr);
      Self.Canvas.CopyRect(Rect(0,0,width,height),Canvas,Rect(0,0,width,height));
      exit;
    end;
  end;


  if (hzoom>=0) then
    hspace:=Round(Int(Width * (hzoom+1) * scale / Length))
  else
    hspace:=Round(Abs(Int(Width * scale / Length * (1/hzoom) )));
  vspace:=TrackHeight;

  if (ssLeft in Shift) then
  begin
    doRedraw:=false;
    tmpHoffset:=hoffset-((X-MouseDownX) div hspace * scale);
    if (tmpHOffset<>hoffset) then
    begin
      Hoffset:=tmpHoffset;
      MouseDownX:=X;
      doRedraw:=True;
    end;
    tmpVoffset:=voffset+((Y-MouseDownY) div vspace);
    if (tmpvOffset<>voffset) then
    begin
      Voffset:=tmpVoffset;
      MouseDownY:=Y;
      doRedraw:=True;
    end;
    if (doRedraw) then ReDraw(1);
  end;

  if (ssRight in Shift) then
  begin
    doRedraw:=False;
    tmpHZoom:=HZoom+((X-MouseDownX) div 40);
//    if (tmpHZoom=0) then tmpHZoom:=tmpHZoom-1;
    if (tmpHZoom<>HZoom) then
    begin
      MouseDownX:=X;
      HZoom:=tmpHZoom;
      doRedraw:=True;
    end;
    tmpVZoom:=VZoom+((Y-MouseDownY) div 30);
    if (tmpVZoom<0) then tmpVZoom:=0;
    if (tmpVZoom<>VZoom) then
    begin
      MouseDownY:=Y;
      VZoom:=tmpVZoom;
//      TrackHeight:=TrackHeight*VZoom;
      doRedraw:=True;
    end;
    if doRedraw then ReDraw(1);
  end;

end;

procedure TSeqArranger.asArrangerKeyDown(var Key: Word; Shift: TShiftState);
var i: integer;
begin
  if Key=VK_DELETE then
  begin
    for i:=0 to Blocks.Count-1 do
    begin
      Block:=Blocks[i];
      if (Block.Selected) then
      begin
        Block.Visible:=False;
        Block.Deleted:=True;
      end;
    end;
  end;
  if Key=VK_INSERT then
  begin
    Block:=TSeqBlock.Create(Self);
    Block.Position:=16;
    Block.Track:=2;
    Block.Length:=16;
    Block.Scale:=4;
    Block.Parent:=Self;
    Block.Visible:=True;
    Block.Screen:=bsView;
    Block.Brush.Color:=$00fff0f0;
    Block.FocusColor:=$00fff0f0;
    BlockPosToScreen(Block);
    Self.Blocks.Add(Block);
  end;

  if (Key=67) and (ssCtrl in Shift) then CopyBlocks(0);
  if (Key=86) and (ssCtrl in Shift) then PasteBlocks(0);

end;


procedure TSeqArranger.BlockPosToScreen(Block: TSeqBlock);
var point1,point2: TPoint;
begin
    point1:=PosToScreen(Block.Position,Block.Track);
    point2:=PosToScreen(Block.Position+Block.Length,Block.Track+1);
    Block.Left:=point1.x;
    Block.Top:=point1.y;
    Block.Width:=point2.x-point1.x+1;
    Block.Height:=Point2.y-point1.y+1;
    Block.ReDraw(0);
    buffBitmap.Canvas.CopyRect(Rect(Block.Left,Block.Top,Block.Left+Block.Width,Block.Top+Block.Height),Block.buffBitmap.Canvas,Rect(0,0,Block.Width,Block.Height));
end;

procedure TSeqArranger.BlockScreenToPos(Block: TSeqBlock; X,Y: Integer; doRedraw: byte);
var point1: TPoint;
begin
  point1:=ScreenToPos(x,y);
  Block.Position:=point1.x;
  Block.Track:=point1.y;
  ReDraw(1);
end;

procedure TSeqArranger.OnBlockMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i: integer;
    dontDeselect:Boolean;
begin
  if (ssDouble in Shift) then
  begin
    for i:=0 to BlockEditor.Notes.Count-1 do
    begin
      Note:=BlockEditor.Notes[i];
      Note.Visible:=False;
    end;
    if (BlockEditor.CopyBack) then
      BlockEditor.ArrangerBlock.GetData(BlockEditor);
    BlockEditor.GetData(Sender as TSeqBlock);
    BlockEditor.Copyback:=False;
    for i:=0 to BlockEditor.Notes.Count-1 do
    begin
      Note:=BlockEditor.Notes[i];
      Note.Visible:=True;
    end;
    BlockEditor.ArrangerBlock:=(Sender as TSeqBlock);
    if BlockEditor.SelectedControl>BlockEditor.Controls.Count-1 then
    begin
      BlockEditor.Screen:=bsNotes;
    end;
    BlockEditor.Redraw(1);
    if Assigned(BlockEditor.FOnEditorLoad) then BlockEditor.FOnEditorLoad(Self);
    exit;
  end;

  dontDeselect:=False;
  for i:=0 to Blocks.Count-1 do
  begin
    Block:=Blocks.Items[i];
    Block.MDLength:=Block.Length;
    Block.MDWidth:=Block.Width;
    if not (ssShift in Shift) then
    begin
      if (Block<>(Sender as TSeqBlock)) and (Block.Selected) then
      begin
        dontDeselect:=True;
        Block.Selected:=False;
//        Block.Redraw(1);
      end;
    end;
  end;

  Block:=(Sender as TSeqBlock);
  if Block.Selected then
  begin
    if not (dontDeselect) then
    begin
      Block.MUDeselect:=True;
    end;
  end else
  begin
    Block.MUDeselect:=False;
    Block.Selected:=True;
  end;

  ReDraw(1);

end;

procedure TSeqArranger.OnBlockMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i: Integer;
begin
  Block:=(Sender as TSeqBlock);
  for i:=0 to Blocks.Count-1 do
  begin
    Block:=Blocks.Items[i];
    if (Block.MUDeselect) then
    begin
      Block.Selected:=False;
      Block.ReDraw(1);
    end;
  end;
  ReDraw(1);
end;

procedure TSeqArranger.OnBlockKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  KeyDown(Key,Shift);
end;

procedure TSeqArranger.OnBlockMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var diffLength,i,diffPos,diffTrack: Integer;
    point: TPoint;
begin
  Block:=(Sender as TSeqBlock);
  if (ssLeft in Shift) then
  begin
    point:=ScreenToPos(Block.Left+X-Block.MouseDownX,Block.Top+Block.Height+Y-Block.MouseDownY);
    diffPos:=point.x-Block.Position;
    diffTrack:=Point.y-Block.Track;
    for i:=0 to Blocks.Count-1 do
    begin
      Block:=Blocks.Items[i];
      if Block.Selected then
      begin
        Block.Position:=Block.Position+diffPos;
        Block.Track:=Block.Track+diffTrack;
        BlockPosToScreen(Block);
      end;
    end;
  end;

  if (ssRight in Shift) then
  begin
    point:=ScreenToPos(Block.Left+Block.MDWidth+(x-Block.MouseDownX),0);
    diffLength:=point.x-Block.Position-Block.MDLength;
    if (diffLength<>0) then
    for i:=0 to Blocks.Count-1 do
    begin
      Block:=Blocks.Items[i];
      if (Block.Selected) then
      begin
        Block.Length:=Block.MDLength+diffLength;
        if Block.Length<1 then Block.Length:=1;
        ReDraw(1);
      end;
    end; // end for
  end;
end;

procedure TSeqArranger.WMSetFocus(var Message: TWMSetFocus);
begin
  if (BlockEditor<>nil) and (BlockEditor.ArrangerBlock<>nil) then
  begin
//    Canvas.TextOut(20,200,'Arranger get');
//    BlockEditor.ArrangerBlock.GetData(BlockEditor);
  end;
end;

procedure TSeqArranger.WMKillFocus(var Message: TWMKillFocus);
begin
  if (BlockEditor<>nil) and (BlockEditor.ArrangerBlock<>nil) then
  begin
//    Canvas.TextOut(20,200,'Editor get');
//    BlockEditor.GetData(BlockEditor.ArrangerBlock);
  end;
end;

procedure TSeqArranger.CopyBlocks(Link: integer);
var i,n,c: integer;
    NewBlock: TSeqBlock;
    NewNote: TSeqNote;
    Control, NewControl: TSeqControl;
    Change,NewChange: TSeqChange;
begin
//  Log.Add('CopyNotes');
  BlocksClipBoard.Clear;
  for i:=0 to Blocks.Count-1 do
  begin
    Block:=Blocks.Items[i];
    if (Block.Selected) then
    begin
//      Log.Add('Note copied: '+IntToStr(i));
      NewBlock:=TSeqBlock.Create(Self);
      NewBlock.Visible:=False;
      NewBlock.Name:=Block.Name;
      NewBlock.Position:=Block.Position;
      NewBlock.Track:=Block.Track;
      NewBlock.Length:=Block.Length;
      NewBlock.SpaceType:=Block.SpaceType;
      NewBlock.Scale:=Block.Scale;
      NewBlock.ScaleMultiplier:=Block.ScaleMultiplier;
      NewBlock.Hoffset:=Block.HOffset;
      NewBlock.VOffset:=Block.VOffset;
      NewBlock.HZoom:=Block.HZoom;
      NewBlock.VZoom:=Block.VZoom;
      NewBlock.SelectedControl:=Block.SelectedControl;
      NewBlock.Screen:=Block.Screen;
      NewBlock.Color:=Block.Color;
      for n:=0 to Block.Notes.Count-1 do
      begin
        Note:=Block.Notes[n];
        NewNote:=TSeqNote.Create(Self);
        NewNote.Visible:=True;
        NewNote.Pitch:=Note.Pitch;
        NewNote.Position:=Note.Position;
        NewNote.Length:=Note.Length;
        NewNote.Velocity:=Note.Velocity;
        NewBlock.Notes.Add(NewNote);
      end;
      for n:=0 to Block.Controls.Count-1 do
      begin
        Control:=Block.Controls[n];
        NewControl:=TSeqControl.Create;
        NewControl.Name:=Control.Name;
        NewControl.Id:=Control.Id;
        NewControl.MinValue:=Control.MinValue;
        NewControl.MaxValue:=Control.MaxValue;
        NewControl.ZeroValue:=Control.ZeroValue;
        for c:=0 to Control.Changes.Count-1 do
        begin
          Change:=Control.Changes[c];
          NewChange:=TSeqChange.Create;
          NewChange.Position:=Change.Position;
          NewChange.Value:=Change.Value;
          NewControl.Changes.Add(NewChange);
        end;
        NewBlock.Controls.Add(NewControl);
      end;
      BlocksClipboard.Add(NewBlock);
    end;
  end;
end;

procedure TSeqArranger.PasteBlocks(Link: integer);
var i,n,c,minTrack,minPos,diffTrack,diffPos: integer;
    NewBlock: TSeqBlock;
    NewNote:TSeqNote;
    NewControl,Control: TSeqControl;
    NewChange,Change: TSeqChange;
    point: TPoint;
begin
  minTrack:=30000;
  minPos:=30000;
//  Log.Add('Paste Notes');
  for i:=0 to BlocksClipboard.Count-1 do
  begin
    Block:=BlocksClipboard.Items[i];
    if (Block.Track<minTrack) then minTrack:=Block.Track;
    if (Block.Position<minPos) then minPos:=Block.Position;
  end;
  point:=ScreenToPos(MouseMoveX,MouseMoveY);
  diffTrack:=point.y-minTrack;
  diffPos:=point.x-minPos;
  for i:=0 to Blocks.Count-1 do
  begin
    Block:=Blocks.Items[i];
    Block.Selected:=False;
  end;
  for i:=0 to BlocksClipboard.Count-1 do
  begin
    Block:=BlocksClipboard.Items[i];
    NewBlock:=TSeqBlock.Create(Self);
    NewBlock.Name:=Block.Name;
    NewBlock.Position:=Block.Position+diffPos;
    NewBlock.Track:=Block.Track+diffTrack;
    NewBlock.Length:=Block.Length;
    NewBlock.SpaceType:=Block.SpaceType;
    NewBlock.Scale:=Block.Scale;
    NewBlock.ScaleMultiplier:=Block.ScaleMultiplier;
    NewBlock.Hoffset:=Block.HOffset;
    NewBlock.VOffset:=Block.VOffset;
    NewBlock.HZoom:=Block.HZoom;
    NewBlock.VZoom:=Block.VZoom;
    NewBlock.SelectedControl:=Block.SelectedControl;
    NewBlock.Screen:=Block.Screen;
    NewBlock.Color:=Block.Color;
    for n:=0 to Block.Notes.Count-1 do
    begin
      Note:=Block.Notes[n];
      NewNote:=TSeqNote.Create(Self);
      NewNote.Visible:=True;
      NewNote.Pitch:=Note.Pitch;
      NewNote.Position:=Note.Position;
      NewNote.Length:=Note.Length;
      NewNote.Velocity:=Note.Velocity;
      NewBlock.Notes.Add(NewNote);
    end;
      for n:=0 to Block.Controls.Count-1 do
      begin
        Control:=Block.Controls[n];
        NewControl:=TSeqControl.Create;
        NewControl.Name:=Control.Name;
        NewControl.Id:=Control.Id;
        NewControl.MinValue:=Control.MinValue;
        NewControl.MaxValue:=Control.MaxValue;
        NewControl.ZeroValue:=Control.ZeroValue;
        for c:=0 to Control.Changes.Count-1 do
        begin
          Change:=Control.Changes[c];
          NewChange:=TSeqChange.Create;
          NewChange.Position:=Change.Position;
          NewChange.Value:=Change.Value;
          NewControl.Changes.Add(NewChange);
        end;
        NewBlock.Controls.Add(NewControl);
      end;
    NewBlock.Visible:=True;
    Blocks.Add(NewBlock);
  end;
  ReDraw(1);
end;


//-----------------------------------------------------------------------------
//  Global functions
//-----------------------------------------------------------------------------

function PitchToNote(Pitch: Byte):String;
var octave,note,notelist: String;
begin
  notelist:='C C#D D#E F F#G G#A A#B ';
  octave:=IntToStr((Pitch div 12)-2);
  note:=copy(notelist,(Pitch mod 12)*2+1,2);
  Result:=Note+' '+Octave
end;

//-----------------------------------------------------------------------------
// Midi Out
//-----------------------------------------------------------------------------

procedure PlayCb1(h: HMIDIOUT; uMsg: UINT; dwUser: Integer; dw1: Integer; dw2: Integer); stdcall;
begin
  TMidiOut(dwUser).PlayCallBack1(h, uMsg, dwUser, dw1, dw2);
end;

procedure PlayCb2(h: HMIDIOUT; uMsg: UINT; dwUser: Integer; dw1: Integer; dw2: Integer); stdcall;
begin
  TMidiOut(dwUser).PlayCallBack2(h, uMsg, dwUser, dw1, dw2);
end;

constructor TMidiOut.Create(AOwner: TComponent);
var i: integer;
begin
  inherited Create(AOwner);
  Track:=TSeqTrack.Create();
  Status:=ssStop;
  Device:=TMidiDevice.Create();
  Devices:=nil;
  Devices:=GetDevices;

  Tempo:=500000;
  
  HeaderSize:=sizeof(MIDIHDR);

  FillSize:=1;
end;

destructor TMidiOut.Destroy;
begin
  CloseDevices;
  inherited Destroy;
end;

function TMidiOut.GetDevices():TList;
var NumDev,ThisDev: Word;
    MidioutCaps: TMidioutCaps;
    MidiDevice: TMidiDevice;
    List: TList;
begin
  if Devices=nil then
  begin
    List:=TList.Create();
    NumDev:= MidioutGetNumDevs;
    for ThisDev:= 0 To NumDev - 1 do
    begin
      MidiOutGetDevCaps(ThisDev,@MidiOutCaps, sizeof(TMidiOutCaps));
      MidiDevice:=TMidiDevice.Create();
      MidiDevice.Id:=ThisDev;
      MidiDevice.Name:=StrPas(midiOutCaps.szPname);
      List.Add(MidiDevice);
    end;
    Result:=List;
  end else
  begin
    Result:=Devices;
  end;
end;

function TMidiOut.OpenDevices():Boolean;
var i: integer;
    mptd : TMIDIPROPTIMEDIV;
    mpt  : TMIDIPROPTEMPO;

begin
  Result:=True;
  CbDevice:=-1;
  for i:=0 to Arranger.Tracks.Count-1 do
  begin
    Track:=Arranger.Tracks[i];
    Device:=Devices[Track.Device];
//    Log.Add('Opening midi out device '+IntToStr(Device.Id)+' ('+Device.Name+')');
    if (Device.Status=dsClose) then
    begin
      if (CbDevice<0) then
      begin
        mmr:=MidiStreamOpen(@Device.Handle, @Device.Id, 1, DWORD(@PlayCB1), cardinal(self), CALLBACK_FUNCTION);
        CbDevice:=Device.Id;
        Log.Add('Opening CB device '+IntToStr(Device.Id));
      end else
      begin
        mmr:=MidiStreamOpen(@Device.Handle, @Device.Id, 1, DWORD(@PlayCB2), cardinal(self), CALLBACK_FUNCTION);
        Log.Add('Opening device '+IntToStr(Device.Id));
      end;
      if (mmr<>MMSYSERR_NOERROR) then
      begin
        Log.Add('Cant open midi out device: '+IntToStr(Device.Id));
        Result:=False;
        Device.Status:=dsClose;;
      end else
      begin
        Device.Status:=dsOpen;
      end;

      mptd.cbStruct:= SizeOf(mptd);
      mptd.dwTimeDiv:= 50;
      mmr:=midiStreamProperty(Device.Handle,PByte(@mptd),MIDIPROP_SET or MIDIPROP_TIMEDIV);
      if (mmr<>MMSYSERR_NOERROR) then Log.Add('Cant set timediv property');

      mpt.cbStruct:= SizeOf(mpt);
      mpt.dwTempo:= Tempo;
      mmr:= midiStreamProperty(Device.Handle,PByte(@mpt),MIDIPROP_SET or MIDIPROP_TEMPO);
      if (mmr<>MMSYSERR_NOERROR) then Log.Add('Cant set tempo');
{
      mmr:= midiStreamRestart(Device.Handle);
      if (mmr<>MMSYSERR_NOERROR) then Log.Add('Cant restart stream');
}
    end else
    begin
      CbDevice:=Device.Id;
      Log.Add('Midi out device '+IntToStr(Device.Id)+' ('+Device.Name+') already opened');
    end;
  end;
end;

function TMidiOut.CloseDevices():Boolean;
var i: integer;
begin
  for i:=0 to Devices.Count-1 do
  begin
    Device:=Devices[i];
    if (Device.Status<>dsClose) then
    begin
      Log.Add('Closing device '+IntToStr(i));
      mmr:=MidiStreamStop(Device.Handle);

      mmr:=midiOutUnPrepareHeader(Device.Handle,@mhdr,HeaderSize);
      if mmr<>MMSYSERR_NOERROR then Log.Add('cant unprepare header');
      DescribeMidiError(mmr);

      mmr:=MidiStreamClose(Device.Handle);
      if (mmr<>MMSYSERR_NOERROR) then
      begin
        Log.Add('Cant close device: '+Device.Name);
        DescribeMidiError(mmr);
      end else
      begin
        Device.Status:=dsClose;
      end;
    end;
  end;

end;

function TMidiOut.AddData(Data:PChar; var DataBuf:PChar; var BufSize:Integer; DataSize:Integer):bool;
var TempBuf: PChar;
begin
  result:=false;
  if BufSize+DataSize>$ffff then
  begin
    Log.Add('Add data: error1');
    Result:=false;
    Exit;
  end;

  TempBuf:=PChar(GlobalAlloc(GMEM_FIXED,BufSize+DataSize));

  if TempBuf=nil then
  begin
    Log.Add('Add data: error2');
    Result:=false;
    Exit;
  end;

  if (DataBuf<>nil) and (BufSize>0) then
  begin
    CopyMemory(TempBuf,DataBuf,BufSize);
  end;

  CopyMemory(TempBuf+BufSize,Data,DataSize);

  if DataBuf<>nil then
  begin
    GlobalFree(HGLOBAL(DataBuf));
    DataBuf:=nil;
  end;

  DataBuf:=TempBuf;
  BufSize:=BufSize+DataSize;
  Result:=true;
end;


procedure TMidiOut.AddShortEvent(sEvent:sMIDIEVENT; var DataBuf:PChar; var BufSize:Integer);
begin
  if not AddData(@sEvent,DataBuf,BufSize,sizeof(sMIDIEVENT)) then Log.Add('Cant add short event');
end;

function TMidiOut.ShortEvent(Data: DWord; Start: DWord):sMIDIEVENT;
var ShortEvent:sMIDIEVENT;
begin
  ShortEvent.dwStreamID:=0;
  ShortEvent.dwDeltaTime:=Start;
  ShortEvent.dwEvent:=Data;
  Result:=ShortEvent;
end;

procedure TMidiOut.DescribeMidiError(err: integer);
var do_stop: boolean;
begin
  do_stop:=false;
  if (err=MIDIERR_STILLPLAYING) then
  begin
    Log.Add('MIDIERR_STILLPLAYING');
    do_stop:=true;
  end;
  if (err=MIDIERR_UNPREPARED) then
  begin
    Log.Add('MIDIERR_UNPREPARED');
    do_stop:=true;
  end;
  if (err=MMSYSERR_INVALHANDLE) then
  begin
    Log.Add('MMSYSERR_INVALHANDLE');
    do_stop:=true;
  end;
  if (err=MMSYSERR_INVALPARAM	) then
  begin
    Log.Add('MMSYSERR_INVALPARAM	');
    do_stop:=true;
  end;
  if (err=MMSYSERR_BADDEVICEID	) then
  begin
    Log.Add('MMSYSERR_BADDEVICEID	');
    do_stop:=true;
  end;
  if (err=MMSYSERR_INVALPARAM	) then
  begin
    Log.Add('MMSYSERR_INVALPARAM	');
    do_stop:=true;
  end;
  if (err=MMSYSERR_NOMEM	) then
  begin
    Log.Add('MMSYSERR_NOMEM	');
    do_stop:=true;
  end;
  if (do_stop) then Self.Stop;
end;


function TMidiOut.PlayData(Data:TList; Device: TMidiDevice):bool;
var prop: MIDIPROPTIMEDIV;
   MEvent:^event;
   err: Integer;
   i: Integer;
   dopb:bool;
   firstnoteoff:bool;
   EventStart,DeltaTime: word;
   DataBuffer: PChar;
   BufferSize: Integer;
   cb: byte;
begin
  Result:=false;
  BufferSize:=0;

//  Log.Add('--');
  DeltaTime:=0;
  for i:=0 to Data.Count-1 do
  begin
    MEvent:=Data.Items[i];
    if MEvent.DeviceId<>Device.Id then
    begin
      continue;
    end;
    EventStart:=MEvent.Start-DeltaTime;
//    Log.Add('Event start: '+IntToStr(EventStart)+' '+IntToHex(MEvent.Data,6)+ '         '+IntToStr(DeltaTime));
    AddShortEvent(ShortEvent(MEvent.Data,EventStart),DataBuffer,BufferSize);
    DeltaTime:=MEvent.Start;
    Dispose(MEvent);
  end;
{
  cb:=1;
  if (Device.Id=CbDevice) then cb:=0;
}
  cb:=Device.Id;

  FillMemory(@(mhdr[cb][HeaderId[cb]]),HeaderSize,0);
  mhdr[cb][HeaderId[cb]].lpData:=DataBuffer;
  mhdr[cb][HeaderId[cb]].dwBufferLength:=BufferSize;
  mhdr[cb][HeaderId[cb]].dwBytesRecorded:=BufferSize;

  err:=midiOutPrepareHeader(Device.Handle,@(mhdr[cb][HeaderId[cb]]),HeaderSize);
  if err<>MMSYSERR_NOERROR then Log.Add('cant prepare header '+' ['+IntToStr(cb)+'] '+IntToStr(HeaderId[cb])+'  device id: '+IntToStr(Device.Id));
  DescribeMidiError(err);

  err:=midiStreamOut(Device.Handle,@(mhdr[cb][HeaderId[cb]]),HeaderSize);
  if err<>MMSYSERR_NOERROR then Log.Add('cant output stream ');
  DescribeMidiError(err);

//  Log.Add('HeaderId: '+IntToStr(HeaderId));

  Result:=true;
end;


function EventSort(Item1, Item2: Pointer): Integer;
var info1,info2:^event;
begin
  info1:=Item1;
  info2:=Item2;
  Result:=info1.Start-info2.Start;
end;

procedure TMidiOut.FillStream;
var i,n,c,DeltaTime,tmp,ccValue: integer;
    Ratio: real;
    NoteOnPos,NoteOffPos,ChangePos: real;
    Control:TSeqControl;
    Change: TSeqChange;
    tmpFillSize,cid: integer;

    MHdr: PMidiHdr;
    BytesRecorded: DWord;
    p: pbyte;
    strmbuf: pchar;
    FpMidiEvent: PMIDIEVENT;
    info: ^event;
    Data: TList;

begin

  tmpFillSize:=FillSize;
  if (Arranger.PlayPos<Arranger.LoopEnd) and (Arranger.PlayPos+FillSize>Arranger.LoopEnd) then
  begin
    FillSize:=1;
  end;

//  Log.Add('Fill size: '+IntToStr(FillSize)+' LoopEnd: '+IntToStr(Arranger.LoopEnd));

  Data:=TList.Create;
//  MsgList.Clear;

  for i:=0 to Arranger.Blocks.Count-1 do
  begin
    Block:=Arranger.Blocks[i];
    if (Block.Track<0) or (Block.Track>Arranger.Tracks.Count-1) then continue;
    Track:=Arranger.Tracks[Block.Track];
    Device:=Devices.Items[Track.Device];

    if not (Device.Status=dsOpen) then continue;

    if (Block.Position<=Arranger.PlayPos)
    and (Block.Position+Block.Length>=Arranger.PlayPos+FillSize-1) then
    begin
      Ratio:=(Block.Length/(sqr(Block.Scale)*Block.ScaleMultiplier));

      for c:=0 to Block.Controls.Count-1 do
      begin
        Control:=Block.Controls[c];
        for n:=0 to Control.Changes.Count-1 do
        begin
          Change:=Control.Changes[n];
          ChangePos:=Block.Position+Change.Position*Ratio;
          if (Arranger.PlayPos<=ChangePos)
          and (Arranger.PlayPos+FillSize>ChangePos) then
          begin
            ChangePos:=ChangePos-Arranger.PlayPos;
            try
              ccValue:=StrToInt(Control.Id);
//              ccValue:=StrToInt(copy(Control.Id,0,pos(' ',Control.Id)));
            except
              Log.Add('cant convert str to int; CC: '+Control.Id);
              continue;
            end;
            new(info);
//            Log.Add('Control chnage');
            info.DeviceId:=Device.Id;
            info.Start:=Round(16*ChangePos);
            info.Data:=$0000B0 or (Change.Value*256*256) or (ccValue * 256) or (Track.Channel);
            Data.Add(info);
          end;
        end;
      end; // end for cc's

      for n:=0 to Block.Notes.Count-1 do
      begin
        Note:=Block.Notes[n];
        if (Note.Pitch<0) or (Note.Pitch>127) then continue;
        NoteOnPos:=Block.Position+Note.Position*Ratio;
        if (Arranger.PlayPos<=NoteOnPos)
        and (Arranger.PlayPos+FillSize>NoteOnPos) then
        begin
          NoteOnPos:=NoteOnPos-Arranger.PlayPos;
          new(info);
          info.DeviceId:=Device.Id;
          info.Start:=Round((16)*NoteOnPos);
          info.Data:=$000090 or (Note.Velocity*256*256) or ((Note.Pitch+12) * 256) or (Track.Channel);
          Data.Add(info);
//          Log.Add('Note On '+PitchToNote(Note.Pitch)+ ' start '+FloatToStr(NoteOnPos) );
        end;
        NoteOffPos:=Block.Position+((Note.Position+Note.Length)*Ratio)-0.01;
        tmp:=Arranger.PlayPos;
{        if (tmp=Arranger.LoopStart) then tmp:=Arranger.LoopEnd;
}        if (tmp<=NoteOffPos)
        and (tmp+FillSize>NoteOffPos) then
        begin
          NoteOffPos:=NoteOffPos-tmp;
          new(info);
          info.DeviceId:=Device.Id;
          info.Start:=Round(15*NoteOffPos);
          info.Data:=$000080 or ((Note.Pitch+12) * 256) or (Track.Channel);
          Data.Add(info);
//          Log.Add('Note Off '+PitchToNote(Note.Pitch)+ ' start '+FloatToStr(NoteOffPos) );
        end;

      end;  // end for notes
    end;  //end if block pos
  end; // end for blocks

//  Device:=Devices[CbDevice];

//  Log.Add('Callback start '+IntToStr(info.start) );

  Data.Sort(EventSort);
  for i:=0 to 1 do
  begin
  end;

  for i:=0 to Devices.Count-1 do
  begin
    Device:=Devices[i];
    if (Device.Status<>dsOpen) then continue;

    inc(HeaderId[i]);
    if (HeaderId[i]>HeaderCount-1) then HeaderId[i]:=0;

    // callback

    new(info);
    info.DeviceId:=Device.Id;
    info.Start:=FillSize*16;
    info.Data:=$02000001 or MEVT_F_CALLBACK;
    Data.Add(info);

    PlayData(Data,Device);
  end;
  Data.Free;

  FillSize:=tmpFillSize;

end;

function TMidiOut.IncrementPlayPos(PlayPos: Integer):Integer;
var tmpFillSize: integer;
begin
  tmpFillSize:=FillSize;
  if (PlayPos<Arranger.LoopEnd) and (PlayPos+FillSize>Arranger.LoopEnd) then
  begin
    FillSize:=1;
  end;
  if (PlayPos+FillSize=Arranger.LoopEnd) then
  begin
    PlayPos:=Arranger.LoopStart;
  end else
  begin
    Inc(PlayPos,FillSize);
  end;
  FillSize:=tmpFillSize;
  result:=PlayPos;
end;

procedure TMidiOut.PlayCallBack1 (h: HMIDIOUT; msg: UINT; dwUser: Integer; dw1: Integer; dw2: Integer);
var OrigId,cb: integer;
    err,i: DWord;
    Device: TMidiDevice;
begin

  if (msg=MOM_DONE) then
  begin
    for i:=0 to Devices.Count-1 do
    begin
      Device:=Devices[i];
      if (Device.Handle=h) then
      begin
//        Log.Add('Handle found '+Device.Name);
        cb:=i;
      end;
    end;
    OrigId:=HeaderId[cb]-2;
    if (OrigId<0) then OrigId:=HeaderCount+OrigId;
    err:=midiOutUnprepareHeader(h,PMidiHdr(dw1),HeaderSize);
//    err:=midiOutUnprepareHeader(h,@(mhdr[cb][OrigId]),HeaderSize);
    if err<>MMSYSERR_NOERROR then Log.Add('cant unprepare header '+'     '+IntToStr(cb)+'      '+IntToStr(OrigId));
    DescribeMidiError(err);
  end;

  if (Status<>ssStop) then
  begin
    if msg = MM_MOM_POSITIONCB then
    begin
      FillStream;
      Arranger.PlayPos:=IncrementPlayPos(Arranger.PlayPos);
      if (abs(Arranger.PlayPos-Arranger.DisplayPos)>2*FillSize) then
      Arranger.DisplayPos:=IncrementPlayPos(Arranger.DisplayPos);
//      Arranger.DisplayPos:=IncrementPlayPos(Arranger.DisplayPos);
      Arranger.ReDraw(1);
    end;
  end;
end;

procedure TMidiOut.PlayCallBack2 (h: HMIDIOUT; msg: UINT; dwUser: Integer; dw1: Integer; dw2: Integer);
var OrigId,cb: integer;
    err,i: DWord;
begin
  if (msg=MOM_DONE) then
  begin
    for i:=0 to Devices.Count-1 do
    begin
      Device:=Devices[i];
      if (Device.Handle=h) then
      begin
//        Log.Add('Handle found '+Device.Name);
        cb:=i;
      end;
    end;

    OrigId:=HeaderId[cb]-2;
    if (OrigId<0) then OrigId:=HeaderCount+OrigId;

//    @(mhdr[cb][OrigId])
    err:=midiOutUnprepareHeader(h,PMidiHdr(dw1),HeaderSize);
    if err<>MMSYSERR_NOERROR then Log.Add('cant unprepare header '+'     '+IntToStr(cb)+'      '+IntToStr(OrigId));
    DescribeMidiError(err);
  end;
end;


procedure TMidiOut.Play;
var i: integer;
begin
  Arranger.DisplayPos:=Arranger.PlayPos;
  if (Status=ssPlay) then
  begin
    Log.Add('Alreay playing..');
    Exit;
  end;

  if not OpenDevices then
  begin
    Log.Add('Cant open all devices');
    exit;
  end;
  for i:=0 to Devices.Count-1 do
  begin
    Device:=Devices[i];
     if (Device.Status=dsOpen) then
     begin
        mmr:= midiStreamRestart(Device.Handle);
        if (mmr<>MMSYSERR_NOERROR) then
        begin
          Log.Add('Cant restart stream');
          DescribeMidiError(mmr);
        end;
     end;
  end;
  Status:=ssPlay;
  Log.Add('Play > Arranger.PlayPos: '+IntToStr(Arranger.PlayPos));
  FillStream;
  Arranger.PlayPos:=IncrementPlayPos(Arranger.PlayPos);
  FillStream;
  Arranger.PlayPos:=IncrementPlayPos(Arranger.PlayPos);
//  Arranger.Redraw(1);
end;

procedure TMidiOut.Stop;
var i: integer;
    err: integer;
begin

  Status:=ssStop;
  for i:=0 to Devices.Count-1 do
  begin
    Device:=Devices[i];
    if (Device.Status<>dsClose) then
    begin
      MidiStreamStop(Device.Handle);
    end;
  end;
  CloseDevices;
  Arranger.PlayPos:=Arranger.DisplayPos;
end;

procedure TMidiOut.SetTempo(BPM: Byte);
var divider: real;
    i: integer;
    mpt  : TMIDIPROPTEMPO;
begin
//  Tempo:=;
    divider:=(1000000-500000) div 120;
    Tempo:=Round(1000000-divider*BPM);
    Log.Add('Tempo: '+IntToStr(Tempo));
    if (Status=ssPlay) then
    begin
      for i:=0 to Devices.Count-1 do
      begin
        Device:=Devices[i];
        if (Device.Status<>dsOpen) then continue;
        mpt.cbStruct:=SizeOf(mpt);
        mpt.dwTempo:=Tempo;
        mmr:= midiStreamProperty(Device.Handle,PByte(@mpt),MIDIPROP_SET or MIDIPROP_TEMPO);
        if (mmr<>MMSYSERR_NOERROR) then Log.Add('Cant set tempo');
        DescribeMidiError(mmr);
      end;
    end;
end;

//-----------------------------------------------------------------------------

procedure Register;
begin
  RegisterComponents('Grapefruit', [TNiceShape,TNiceEdit,TNiceEdit2,TNiceBtn,TNiceMenu,
    TNiceSplitter,TNiceLog,TSeqNote,TSeqBlock,TSeqArranger,TMidiOut]);
end;

end.
