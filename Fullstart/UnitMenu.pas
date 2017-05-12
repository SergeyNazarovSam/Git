unit UnitMenu;

// Embarcadero Delphi 10.1 Berlin
// This is unit which contain visual elements of Left menu with
// applications list, configuration access and Logoff and exit

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.StdCtrls, Generics.Collections, FMX.Controls.Presentation, FMX.Objects;

type
  TmenuRight = class(TForm)
    StyleBook: TStyleBook;
    LayoutButton: TScaledLayout;
    ButtonMin: TSpeedButton;
    LayoutOben: TLayout;
    PanelLogout: TPanel;
    LabelUserName: TLabel;
    ButtonLogoff: TButton;
    ButtonExit: TButton;
    LabelTextLogin: TLabel;
    TimerHideMenu: TTimer;
    procedure FormShow(Sender: TObject);
    procedure ButtonMinClick(Sender: TObject);
    procedure FormClose(Sender: TObject;var Action: TCloseAction);
    procedure ButtonLogoffClick(Sender: TObject);
    procedure ButtonExitClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure TimerHideMenuTimer(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    procedure Addprogramm(Button: Tbutton);
    procedure ClearProgramm;
    procedure AddLine;
    procedure AddListName(Title:string);
    { Public-Deklarationen }
  end;

var
  MenuRight: TmenuRight;

implementation

uses UnitMain, Hsapi, UnitLogin;

{$R *.fmx}


procedure TmenuRight.Addprogramm(Button: Tbutton);
begin
  // Hier nur die Styles für den button anpassen
  Button.Parent := Layoutbutton;
  Button.Position.Y := 2000;
  Button.Align := TAlignLayout.Top;
  Button.Margins.Top := 1;
  Button.Height := 40;
end;

procedure TmenuRight.AddLine;
var ALine: Tline;
begin
  ALine := TLine.Create(Self);
  ALine.Parent := Layoutbutton;
  ALine.Position.Y := 2000;
  ALine.Align := TAlignLayout.Top;
  ALine.Margins.Top := 0;
  ALine.Height := 1;
end;

procedure TmenuRight.AddListName(Title:string);
var ALabel: TLabel;
begin
  ALabel := TLabel.Create(Self);
  ALabel.Parent := Layoutbutton;
  ALabel.Position.Y := 2000;
  ALabel.Align := TAlignLayout.Top;
  ALabel.Margins.Top := 1;
  ALabel.Height := 40;
  ALabel.Text := Title;
  ALabel.StyleLookup := 'Label_UserNameStyle1';
  // aLabel.FontColor := TAlphaColorRec.Black;
  ALabel.StyledSettings := ALabel.StyledSettings -[TStyledSetting.FontColor];
end;

procedure TmenuRight.ClearProgramm;
begin
  while Layoutbutton.ChildrenCount > 0 do
    Layoutbutton.Children[0].Destroy;
end;

procedure TmenuRight.ButtonMinClick(Sender: TObject);
begin
  if Self.Height < 40 then
  begin
    Self.Height := Screen.Height - 40;
    Layoutbutton.Visible := True;
    PanelLogout.Visible := True;
    Self.Width := 300;
    Self.BringToFront;
  end
  else
  begin
    Layoutbutton.Visible := False;
    PanelLogout.Visible := False;
    Self.Width := 0;
    Self.Height := 35;
  end;
end;

procedure TmenuRight.FormClose(Sender: TObject;var Action: TCloseAction);
begin
  Mainform.Close;
end;

procedure TmenuRight.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
  if(Self.Width > 100)and(X < 0)then
    TimerHideMenu.Enabled := True;
end;

procedure TmenuRight.FormShow(Sender: TObject);
begin
  Self.Left := 0;
  Self.Top := 0;
  Self.Height := Screen.Height;
  Self.Width := 300;
  ButtonMinClick(nil);
end;

procedure TmenuRight.TimerHideMenuTimer(Sender: TObject);
begin
  ButtonMinClick(nil);
  TimerHideMenu.Enabled := False;
end;

procedure TmenuRight.ButtonExitClick(Sender: TObject);
begin
  Hotelserverapi.Logout;
  Self.Close;
end;

procedure TmenuRight.ButtonLogoffClick(Sender: TObject);
begin
  MainForm.SendLogOut(Sender);
end;

end.
