program menu;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitMenu in 'UnitMenu.pas' {menuRight};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TmenuRight, menuRight);
  Application.Run;
end.
