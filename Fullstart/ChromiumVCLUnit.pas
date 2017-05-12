unit ChromiumVCLUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Cefvcl, Ceflib;

type
  TTBButton = record
    IBitmap: Integer;
    IdCommand: Integer;
    FsState: Byte;
    FsStyle: Byte;
{$IFDEF WIN64}
    HReserved: array[0 .. 5] of Byte;
{$ELSE}
{$IFDEF WIN32}
    HReserved: array[0 .. 1] of Byte;
{$ENDIF}
{$ENDIF}
    DwData: Pointer;
    IString: PChar;
  end;

type
  TFormChromium = class(TForm)
    WebBrowser: TChromium;
    procedure WebBrowserLoadEnd(Sender: TObject;const Browser: ICefBrowser;
      const Frame: ICefFrame; HttpStatusCode: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private

  public

  end;

var
  FormChromium: TFormChromium;

implementation

uses UnitMain;

{$R *.dfm}


procedure TFormChromium.FormCreate(Sender: TObject);
var
  AHandle: HWND;
begin
  // here we hide the chromium window from taskbar
  AHandle := FindWindow(nil, PChar('Gmsstart'));
  ShowWindow(AHandle, SW_HIDE);
  SetWindowLong(AHandle, GWL_EXSTYLE, GetWindowLong(AHandle, GWL_EXSTYLE)or
    WS_EX_TOOLWINDOW);
  ShowWindow(AHandle, SW_SHOW);
end;

procedure TFormChromium.FormHide(Sender: TObject);
begin
  // set up non-transparent style
  MainForm.PanelBrowser.StyleLookup := 'pnBrowserStyle2';
end;

procedure TFormChromium.FormShow(Sender: TObject);
begin
  // set up transparent style
  MainForm.PanelBrowser.StyleLookup := 'pnBrowserStyle1';
end;

procedure TFormChromium.WebBrowserLoadEnd(Sender: TObject;
  const Browser: ICefBrowser;const Frame: ICefFrame; HttpStatusCode: Integer);
var Ajscript:string;
begin
  // hide the horizontal scrollbar
  Ajscript := 'document.documentElement.style.overflowX = ''hidden'';';
  Browser.MainFrame.ExecuteJavaScript(Ajscript, 'about:blank', 0);
  MainForm.AniIndicatorLoading.Enabled := False;
end;

end.
