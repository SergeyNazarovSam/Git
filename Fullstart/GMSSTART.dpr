program GMSSTART;

uses
  FMX.Forms,
  UnitMain in 'UnitMain.pas' {Mainform},
  UnitVorlagen in 'UnitVorlagen.pas' {fmVorlagen},
  UnitLogin in 'unitLogin.pas' {fmLogin},
  UnitMenu in 'UnitMenu.pas' {menuRight},
  DMBase in 'DMBase.pas' {DBase: TDataModule},
  Hsapi in 'hsapi.pas' {hotelserverapi: TDataModule},
  ConfigUnit in 'ConfigUnit.pas' {ConfigForm},
  UnitVCL in 'UnitVCL.pas' {Form1},
  ChromiumVCLUnit in 'ChromiumVCLUnit.pas' {FormChromium};

{$R *.res}


begin
  Application.Initialize;
  Application.CreateForm(TMainform, Mainform);
  Application.CreateForm(TmenuRight, MenuRight);
  Application.CreateForm(TDataModuleBase, DataModuleBase);
  Application.CreateForm(TfmVorlagen, FmVorlagen);
  Application.CreateForm(TConfigForm, ConfigForm);
  Application.CreateForm(TVCLForm, VCLForm);
  Application.CreateForm(TFormChromium, FormChromium);
  Application.Run;

end.
