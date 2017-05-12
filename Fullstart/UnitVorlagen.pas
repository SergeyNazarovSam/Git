unit UnitVorlagen;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts,
  FMX.Gestures,
  FMX.StdCtrls, FMX.Objects, FMX.Controls.Presentation;

type
  TfmVorlagen = class(TForm)
    StyleBook: TStyleBook;
    ToolbarHolder: TLayout;
    ToolbarPopup: TPopup;
    ToolbarPopupAnimation: TFloatAnimation;
    ToolBar1: TToolBar;
    ToolbarApplyButton: TButton;
    ToolbarCloseButton: TButton;
    ToolbarAddButton: TButton;
    procedure ToolbarCloseButtonClick(Sender: TObject);
    procedure FormGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo;var Handled: Boolean);
    procedure FormKeyDown(Sender: TObject;var Key: Word;var KeyChar: Char;
      Shift: TShiftState);
  private
    FGestureOrigin: TPointF;
    FGestureInProgress: Boolean;
    { Private-Deklarationen }
    procedure ShowToolbar(AShow: Boolean);
  public
    { Public-Deklarationen }
  end;

var
  FmVorlagen: TfmVorlagen;

implementation

{$R *.fmx}


procedure TfmVorlagen.FormKeyDown(Sender: TObject;var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = VkEscape then
    ShowToolbar(not ToolbarPopup.IsOpen);
end;

procedure TfmVorlagen.ToolbarCloseButtonClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfmVorlagen.FormGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo;var Handled: Boolean);
var
  DX, DY: Single;
begin
  if EventInfo.GestureID = IgiPan then
  begin
    if(TInteractiveGestureFlag.GfBegin in EventInfo.Flags)
      and((Sender = ToolbarPopup)
      or(EventInfo.Location.Y >(ClientHeight - 70)))then
    begin
      FGestureOrigin := EventInfo.Location;
      FGestureInProgress := True;
    end;

    if FGestureInProgress and(TInteractiveGestureFlag.GfEnd in EventInfo.Flags)
    then
    begin
      FGestureInProgress := False;
      DX := EventInfo.Location.X - FGestureOrigin.X;
      DY := EventInfo.Location.Y - FGestureOrigin.Y;
      if(Abs(DY)> Abs(DX))then
        ShowToolbar(DY < 0);
    end;
  end
end;

procedure TfmVorlagen.ShowToolbar(AShow: Boolean);
begin
  ToolbarPopup.Width := ClientWidth;
  ToolbarPopup.PlacementRectangle.Rect :=
    TRectF.Create(0, ClientHeight - ToolbarPopup.Height, ClientWidth - 1,
    ClientHeight - 1);
  ToolbarPopupAnimation.StartValue := ToolbarPopup.Height;
  ToolbarPopupAnimation.StopValue := 0;

  ToolbarPopup.IsOpen := AShow;
end;

end.
