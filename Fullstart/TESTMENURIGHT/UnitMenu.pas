unit UnitMenu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.StdCtrls;

type
  TmenuRight = class(TForm)
    StyleBook1: TStyleBook;
    Layoutbutton: TScaledLayout;
    button_min: TSpeedButton;
    Layout_oben: TLayout;
    procedure FormShow(Sender: TObject);
    procedure button_minClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    procedure addprogramm(Astring : string);
    { Public-Deklarationen }
  end;

var
  menuRight: TmenuRight;

implementation

{$R *.fmx}

procedure TmenuRight.addprogramm(Astring: string);
var abutton : Tbutton;
begin
  abutton := Tbutton.Create(nil);
  abutton.StyleLookup := 'Button1Style1';
  abutton.Height := 80;
  abutton.Parent := Layoutbutton;
  abutton.Text := astring;
  abutton.Align := TAlignLayout.Top;
end;

procedure TmenuRight.button_minClick(Sender: TObject);
begin
  if self.Height <> Screen.Height then
  begin
    self.Height := Screen.Height;
    Layoutbutton.Visible := true;
    self.Width := 300;
  end else
  begin
    Layoutbutton.Visible := false;
    self.Width := 35;
    self.Height := 35;
  end;
end;

procedure TmenuRight.FormShow(Sender: TObject);
begin
  self.Left := Screen.Width;
  self.Top := 0;
  self.Height := Screen.Height;
  self.Width := 300;
  addprogramm ('GMS EventPlaner');
  addprogramm ('GMS KASSE TOUCH');
  addprogramm ('GMS KASSE Tagesabschluss');
end;

end.
