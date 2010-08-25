unit UIEdit;

interface

uses
  Classes,
  Graphics,
  Forms,
  Controls,
  StdCtrls,
  UIColors;

type
  TUIEdit = class(TEdit)
    public
      constructor Create(AOwner : TComponent); reintroduce;

    private

  end;

implementation

constructor TUIEdit.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  BorderStyle := bsNone;
  Color := UI_COLOR_BACKGROUND_DARK;
  Font.Color := UI_COLOR_FONT_LIGHT;
  Height := 14;
end;

end.
