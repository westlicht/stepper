unit UIImageLibrary;

interface

uses
  Classes,
  Graphics;

type
  TUIImage = class(TObject)
    private
      FName : String;
      FBitmap : TBitmap;

    public
      constructor Create(Name, FileName : String);
      destructor Destroy; override;

    public
      property  Name : String read FName;
      property  Bitmap : TBitmap read FBitmap;

  end;

  TUIImageCollection = class(TObject)
    private
      FName : String;
      FBitmapList : TList;

    public
      constructor Create(Name, BaseFileName, Extension : String; Digits : Integer); overload;
      constructor Create(Name : String; FileNames : Array of String); overload;
      destructor Destroy; override;

    public
      property  Name : String read FName;
      property  BitmapList : TList read FBitmapList;

  end;

  TUIImageLibrary = class(TObject)
    private
      FImageList : TList;
      FImageCollectionList : TList;

    public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;

      procedure LoadLibrary(FileName, Dir : String);

      procedure AddImage(Name, FileName : String);
      procedure AddImageCollection(Name, BaseFileName, Extension : String; Digits : Integer); overload;
      procedure AddImageCollection(Name : String; FileNames : Array of String); overload;

      function  GetImage(Name : String) : TUIImage;
      function  GetImageCollection(Name : String) : TUIImageCollection;

      class function GetInstance : TUIImageLibrary;

  end;

implementation

uses
  SysUtils;

var
  _Instance : TUIImageLibrary;

////////////////////////////////////////////////////////////////////////////////
// TUIImage                                                                   //
////////////////////////////////////////////////////////////////////////////////

constructor TUIImage.Create(Name, FileName : String);
begin
  inherited Create;

  FName := Name;
  FBitmap := TBitmap.Create;
  FBitmap.LoadFromFile(FileName);
end;

destructor TUIImage.Destroy;
begin
  FBitmap.Destroy;

  inherited Destroy;
end;

////////////////////////////////////////////////////////////////////////////////
// TUIImageCollection                                                         //
////////////////////////////////////////////////////////////////////////////////

constructor TUIImageCollection.Create(Name, BaseFileName, Extension : String; Digits : Integer);
var
  Index : Integer;
  FileName : String;
  Bitmap : TBitmap;
begin
  inherited Create;

  FName := Name;
  FBitmapList := TList.Create;

  Index := 0;
  while true do
  begin
    FileName := IntToStr(Index);
    while Length(FileName) > Digits do
      FileName := '0' + FileName;
    FileName := BaseFileName + FileName + Extension;
    if not FileExists(FileName) then
      Exit;
    Bitmap := TBitmap.Create;
    Bitmap.LoadFromFile(FileName);
    FBitmapList.Add(Bitmap);
  end;
end;

constructor TUIImageCollection.Create(Name : String; FileNames : Array of String);
var
  Index : Integer;
  Bitmap : TBitmap;
begin
  FName := Name;
  FBitmapList := TList.Create;

  for Index := 0 to High(FileNames) do
  begin
    Bitmap := TBitmap.Create;
    Bitmap.LoadFromFile(FileNames[Index]);
    FBitmapList.Add(Bitmap);
  end;
end;

destructor TUIImageCollection.Destroy;
var
  Index : Integer;
begin
  for Index := 0 to FBitmapList.Count - 1 do
    TBitmap(FBitmapList[Index]).Destroy;
  FBitmapList.Destroy;

  inherited Destroy;
end;

////////////////////////////////////////////////////////////////////////////////
// TUIImageLibrary                                                            //
////////////////////////////////////////////////////////////////////////////////

constructor TUIImageLibrary.Create;
begin
  inherited Create;

  FImageList := TList.Create;
  FImageCollectionList := TList.Create;
end;

destructor TUIImageLibrary.Destroy;
begin
  Clear;

  FImageList.Destroy;
  FImageCollectionList.Destroy;

  inherited Destroy;
end;

procedure TUIImageLibrary.Clear;
var
  Index : Integer;
begin
  for Index := 0 to FImageList.Count - 1 do
    TUIImage(FImageList[Index]).Destroy;
  FImageList.Clear;

  for Index := 0 to FImageCollectionList.Count - 1 do
    TUIImageCollection(FImageCollectionList[Index]).Destroy;
  FImageCollectionList.Clear;
end;

procedure TUIImageLibrary.LoadLibrary(FileName, Dir : String);
var
  Text : TStringList;
  Values : TStringList;
  LineIndex : Integer;
  Line : String;
  Index : Integer;
  FileNames : Array of String;
begin
  Clear;

  Dir := IncludeTrailingPathDelimiter(Dir);

  Text := TStringList.Create;
  Values := TStringList.Create;
  Text.LoadFromFile(FileName);

  for LineIndex := 0 to Text.Count - 1 do
  begin
    Line := Trim(Text[LineIndex]);
    Values.Clear;

    // Skip whitespace and comments
    if (Line = '') or (CompareStr(Copy(Line, 1, 2), '//') = 0) then
      Continue;

    // Split up line into comma seperated values
    while Length(Line) > 0 do
    begin
      Index := Pos(',', Line);
      if Index > 0 then
      begin
        Values.Add(Trim(Copy(Line, 1, Index - 1)));
        Line := Trim(Copy(Line, Index + 1, Length(Line)));
      end else
      begin
        Values.Add(Line);
        Line := '';
      end;
    end;

    // Check syntax
    if Values[0] = 'img' then
    begin
      if Values.Count = 3 then
        AddImage(Values[1], Dir + Values[2]);
    end else
    if Values[0] = 'col' then
    begin
      if Values.Count < 3 then
        Continue;

      if Values[1] = 'list' then
      begin
        if Values.Count < 4 then
          Continue;

        SetLength(FileNames, Values.Count - 3);
        for Index := 0 to Values.Count - 4 do
          FileNames[Index] := Dir + Values[Index + 3];

        AddImageCollection(Values[2], FileNames);
      end else
      if Values[1] = 'seq' then
      begin
        if Values.Count <> 6 then
          Continue;

        AddImageCollection(Values[2], Dir + Values[3], Values[4], StrToInt(Values[5]));
      end;
    end;
  end;

  Text.Destroy;
  Values.Destroy;
end;

procedure TUIImageLibrary.AddImage(Name : String; FileName : String);
begin
  FImageList.Add(TUIImage.Create(Name, FileName));
end;

procedure TUIImageLibrary.AddImageCollection(Name : String; BaseFileName, Extension : String; Digits : Integer);
begin
  FImageCollectionList.Add(TUIImageCollection.Create(Name, BaseFileName, Extension, Digits));
end;

procedure TUIImageLibrary.AddImageCollection(Name : String; FileNames : Array of String);
begin
  FImageCollectionList.Add(TUIImageCollection.Create(Name, FileNames));
end;

function  TUIImageLibrary.GetImage(Name : String) : TUIImage;
var
  Index : Integer;
begin
  Result := nil;

  for Index := 0 to FImageList.Count - 1 do
    if TUIImage(FImageList[Index]).Name = Name then
    begin
      Result := FImageList[Index];
      Exit;
    end;
end;

function  TUIImageLibrary.GetImageCollection(Name : String) : TUIImageCollection;
var
  Index : Integer;
begin
  Result := nil;
  
  for Index := 0 to FImageCollectionList.Count - 1 do
    if TUIImageCollection(FImageCollectionList[Index]).Name = Name then
    begin
      Result := FImageCollectionList[Index];
      Exit;
    end;
end;

class function TUIImageLibrary.GetInstance : TUIImageLibrary;
begin
  if not Assigned(_Instance) then
    _Instance := TUIImageLibrary.Create;
  Result := _Instance;
end;

end.
