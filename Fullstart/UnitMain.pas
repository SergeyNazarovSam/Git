unit UnitMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts, FMX.Gestures,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Calendar, FMX.ListBox,
  FMX.Objects, FMX.Effects, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,unitLogin,hsapi, windows,Generics.Collections,FMX.TMSTileList,
  FMX.Menus,  FMX.TabControl, System.Rtti, FMX.Grid,fmx.graphics,
  UnitMenu,  ChromiumVCLUnit, UnitVCL, FMX.WebBrowser, FMX.ExtCtrls, FMX.Edit,  IPPeerClient, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, ceffmx, ceflib, System.Math.Vectors, FMX.Controls3D,
  FMX.Layers3D, mmsystem, FMX.TMSCustomEdit, FMX.TMSEdit, ShellAPI, Messages, FMX.Platform.Win, CommCtrl, vcl.Forms,
  cefvcl, System.ImageList, FMX.ImgList, FrameChromium
  ;


type TApplicationTile = class(TPanel)
       ImageControl : TImageControl;
       Label_AppName: TLabel;
       Button : TButton;
       Constructor Create(AOwner:TComponent; Layout:TGridLayout); overload;
end;


type TApplication = Record
       name : string;
       location : string;
       param : string;
       processid : integer;
       runonce : boolean;
End;

type
  TMainform = class(FMX.Forms.TForm)
    ToolbarHolder: TLayout;
    ToolbarPopup: TPopup;
    ToolbarPopupAnimation: TFloatAnimation;
    ToolBar1: TToolBar;
    ToolbarApplyButton: TButton;
    ToolbarCloseButton: TButton;
    ToolbarAddButton: TButton;
    ToolBarStartmenu: TToolBar;
    Popup_settings: TPopup;
    Rectangle_settings: TRectangle;
    ButtonShutdown: TButton;
    Image1: TImage;
    ButtonLogout: TButton;
    ImageLogout: TImage;
    Label_user: TLabel;
    Image2: TImage;
    GlowEffect2: TGlowEffect;
    query_applications: TFDQuery;
    PopupMenu1: TPopupMenu;
    query_app: TFDQuery;
    TabControl1: TTabControl;
    StyleBook1: TStyleBook;
    TabItem1: TTabItem;
    pnBrowser: TPanel;
    ImageControl_logo: TImageControl;
    Panel2: TPanel;
    Button_newmessages: TButton;
    Button_sent: TButton;
    Button_inbox: TButton;
    Button_trash: TButton;
    CalloutPanel_newmessagescount: TCalloutPanel;
    Label_newmessagecount: TLabel;
    Timer_Checknewmessages: TTimer;
    GridLayout1: TGridLayout;
    Timer_hideScrol: TTimer;
    ImageControl_Client: TImageControl;
    AniIndicator_Loading: TAniIndicator;
    Label_Loading: TLabel;
    button_minimize: TButton;
    Label_UserName: TLabel;
    Label1: TLabel;
    SpeedButton_HideBrowser: TSpeedButton;
    FloatAnimation1: TFloatAnimation;
    FloatAnimation2: TFloatAnimation;
    procedure ToolbarCloseButtonClick(Sender: TObject);
    procedure FormGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure StartbuttonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonTileClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button_newmessagesClick(Sender: TObject);
    procedure Timer_ChecknewmessagesTimer(Sender: TObject);
    procedure WebBrowserStandartDidFinishLoad(ASender: TObject);
    procedure Timer_hideScrolTimer(Sender: TObject);
    procedure ButtonShowDesktopClick(Sender: TObject);
    procedure ConfigButtonClick(Sender: TObject);
    procedure Image_Click(Sender: TObject);
    procedure button_minimizeClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure webBrowserLoadEnd(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; httpStatusCode: Integer);
    procedure SpeedButton_HideBrowserClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure FloatAnimation1Finish(Sender: TObject);
    procedure onRestoreApplication(sender: TObject);
  private
    WebBrowserStandart : TWebBrowser;
    FGestureOrigin: TPointF;
    FGestureInProgress: Boolean;
    zAppName: array[0..512] of Char;
    zCurDir: array[0..255] of Char;
    WorkDir: string;
    StartupInfo: TStartupInfo;
    ProcessInfo: TProcessInformation;
    TrayWnd: HWND;
    TrayIconData: TNotifyIconData;
    TrayIconAdded: Boolean;
    { Private-Deklarationen }
    procedure ShowToolbar(AShow: Boolean);
    function Exec(const FileName: string;
        const CmdShow: Integer): Longword;
    function isprocessvorhanden(prozessID : integer): THandle;
    procedure TrayWndProc(var Message: TMessage);
  protected

  public
    FLoginWithoutServer : boolean;
    FUrlnewmessages : string;
    FUrlinbox : string;
    FUrlsent : string;
    FUrltrash : string;
    FLogoImgPath : string;
    FClientImgPath : string;
    FTileSideSize : integer;
    FSoundPath : string;
    FHeight : integer;
    FWidth : Integer;
    FAutoLogin : string; // for login
    FUsernumber: string;
    FNeedShowBalloon : boolean;
    FNeedSendLogin : boolean;
    FUseAutocomplete : boolean; // for username atocomplete
    LOGINSCREEN : TfmLogin;
    VCLForm : TVclForm;
    FBrowserHeight: integer;
    procedure AppException(Sender: TObject; E: Exception);
    procedure ladeApplications(aRuleid : integer);
    function starteprogramm (aApplicationID : integer) : TApplication;
    procedure ShowWebwithparams(wb:TChromium; FUrl:string; Sending:boolean = false);
    procedure SendLogin(pMitarbeiterID: Integer);
    procedure SendLogOut(sender:TObject);
    Procedure DoLogOut;
    Procedure DoLogIn(usernumber:string);
    { Public-Deklarationen }
  end;


var
  Mainform: TMainform;
  wLogout, wLogIn: Cardinal;

implementation
uses DMbase, ConfigUnit;

{$R *.fmx}

constructor TApplicationTile.Create(AOwner:TComponent; Layout:TGridLayout);
var aButtonWidth : integer;
begin
  inherited Create(AOwner);
  self.Parent := Layout;

  ImageControl := TImageControl.Create(AOwner);
  Label_AppName := TLabel.Create(AOwner);
  Button := TButton.Create(AOwner);

  self.Margins.Left := round(self.Height * 0.05);
  self.Margins.Right := round(self.Height * 0.05);
  self.Margins.Top := round(self.Height * 0.05);
  self.Margins.Bottom := round(self.Height * 0.05);
  self.StyleLookup := 'Panel1Style1';

  self.ImageControl.Parent := self;
  self.ImageControl.Align := TAlignLayout.Top;
  self.ImageControl.EnableOpenDialog := false;
  self.ImageControl.Height := round(self.Height * 0.8);
  self.ImageControl.StyleLookup := 'ImageControl1Style1';
  self.ImageControl.OnClick := MainForm.Image_Click;

  self.Label_AppName.Parent := self;
  self.Label_AppName.Align := TAlignLayout.Bottom;
  self.Label_AppName.Height := round(self.Height * 0.2);
  self.Label_AppName.TextAlign := TTextAlign.Center;
  self.Label_AppName.Font.Size := round(self.Height * 0.07);
  self.Label_AppName.StyledSettings := self.Label_AppName.StyledSettings - [TStyledSetting.Size];
  self.Label_AppName.StyleLookup := 'Label_UserNameStyle1';

  self.Button.Parent :=  self;
  self.Button.Align := TAlignLayout.None;
  aButtonWidth := round(self.Width * 0.2);
  self.Button.Position.X := round(self.Width * 0.4);
  self.Button.Position.Y := round(self.Height * 0.8) - round(aButtonWidth * 0.8);
  self.Button.Width := aButtonWidth;
  self.Button.Height := aButtonWidth;
  self.Button.TextSettings.Font.Size := round(aButtonWidth*0.4);
  self.Button.StyledSettings := self.Button.StyledSettings - [TStyledSetting.Size];
  self.Button.OnClick := MainForm.buttonTileClick;
  self.Button.Visible := false;
end;

procedure TMainForm.onRestoreApplication(sender: TObject);
begin
  ShowMessage('OnRestore');
end;

procedure TMainForm.ShowWebwithparams(wb:TChromium; FUrl:string; Sending:boolean = false);
begin
  if Sending then
  begin
    wb.Visible := false;
    WebBrowserStandart.Visible := true;
    WebBrowserStandart.Navigate(FUrl + '?' + 'user_token='+hotelserverapi.Token+'&' + 'lookup_company_id=1'+'&'+'disable_header=true');
  end
  else
  begin
    WebBrowserStandart.Visible := false;
    wb.Visible := true;
    FormChromium.Show;
    FormChromium.Left := round(ToolBarStartmenu.Position.X) + 5;
    FormChromium.Top := round(TabControl1.Height) + round(Panel2.Height);
    FormChromium.Height := round(pnBrowser.Height) - 2;
    FormChromium.Width := round(pnBrowser.Width) - 10;
    wb.Load(FUrl + '?' + 'user_token='+hotelserverapi.Token+'&' + 'lookup_company_id=1'+'&'+'disable_header=true');
  end;
end;

procedure TMainform.SpeedButton_HideBrowserClick(Sender: TObject);
begin
  if FBrowserHeight = 0 then
    FBrowserHeight := Round(pnBrowser.Height);
  if Round(pnBrowser.Height) = 0 then
  begin
    pnBrowser.Height := pnBrowser.Height + FBrowserHeight;
    ToolBarStartmenu.Height := ToolBarStartmenu.Height + FBrowserHeight;
    //Panel2.Position.Y := Panel2.Position.Y - FBrowserHeight;
    //CalloutPanel_newmessagescount.Position.Y := CalloutPanel_newmessagescount.Position.Y - FBrowserHeight;
    //SpeedButton_HideBrowser.ImageIndex := 0;
    SpeedButton_HideBrowser.StyleLookup := 'arrowdowntoolbuttonborderedright';
    // here we will make webBrowser visiable only on Finish of the FloatAnimation1
    //FormChromium.Visible := true;
    FloatAnimation1.Inverse := false;
    FloatAnimation2.Inverse := false;
    //FloatAnimation3.Inverse := false;
  end
  else
  begin
    pnBrowser.Height := pnBrowser.Height - FBrowserHeight;
    ToolBarStartmenu.Height := ToolBarStartmenu.Height - FBrowserHeight;
    //Panel2.Position.Y := Panel2.Position.Y + FBrowserHeight;
    //CalloutPanel_newmessagescount.Position.Y := CalloutPanel_newmessagescount.Position.Y + FBrowserHeight;
    //SpeedButton_HideBrowser.ImageIndex := 1;
    SpeedButton_HideBrowser.StyleLookup := 'arrowuptoolbuttonborderedleft';
    FormChromium.Visible := false;
    FloatAnimation1.Inverse := true;
    FloatAnimation2.Inverse := true;
    //FloatAnimation3.Inverse := true;
  end;
  FloatAnimation1.Start;
  FloatAnimation2.Start;
  //FloatAnimation3.Start;
end;

function TMainform.isprocessvorhanden(prozessID : integer): THandle;
 type
   PSearch = ^TSearch;
   TSearch = record
     PID: DWORD;
     Wnd: THandle;
   end;
 var
   SearchRec: TSearch;

  function EnumWindowsProc(Wnd: THandle; Res: PSearch): Boolean; stdcall;
   var
     WindowPid: DWORD;
   begin
     WindowPid := 0;
     GetWindowThreadProcessId(Wnd, @WindowPid);
     if (WindowPid = Res^.PID) then //and IsMainAppWindow(Wnd) then // <--- <--- <---
     begin
       Res^.Wnd := Wnd;
       Result := False;
     end
     else
       Result := True;
   end;

begin
   SearchRec.PID := prozessID;
   SearchRec.Wnd := 0;
   EnumWindows(@EnumWindowsProc, Integer(@SearchRec));
   result := SearchRec.Wnd;
end;

procedure TMainform.ConfigButtonClick(Sender: TObject);
begin
  menuRight.button_minClick(nil);
  ConfigForm.ShowModal;
end;

procedure TMainform.button_minimizeClick(Sender: TObject);
begin
  self.WindowState := TWindowState.wsMinimized;
  FormChromium.Hide;
end;

procedure TMainform.ButtonShowDesktopClick(Sender: TObject);
begin
  MainForm.Show;
end;

procedure TMainform.ButtonTileClick(Sender: TObject);
var //Programmstart : string;
  //I: Integer;
  popupapps : Tpopup;
  popbutton : TButton;
  app : TApplication;
  handle : THandle;
  button : Tbutton;
  key : string;
  runonce : boolean;
begin
  //self.visible := false;

  button := Sender as Tbutton;
  runonce := false;
  if TDictionary<string,TApplication>(button.TagObject).Count > 0 then
  begin
    popupAPPs := Tpopup.Create(nil);
    popupapps.Parent := button;
    popupapps.Width := button.Width;
    popupapps.Height := 200;

  //  popupapps.PlacementTarget := Tilepage;
    for key in TDictionary<string,TApplication>(button.TagObject).Keys do
    begin
      handle := isprocessvorhanden(strtoint (key));
      if handle <> 0 then
      begin
        if TDictionary<string,TApplication>(button.TagObject).Items[key].runonce = true then
        begin
           //menuRight.button_minClick(nil);
           runonce := true;
           SetForegroundWindow(handle);
           ShowWindow(handle, SW_SHOW);
        end else
        begin
          popbutton := TButton.Create(nil);
          popbutton.Margins.top := 10;
          popbutton.Margins.Left := 10;
          popbutton.Margins.Right := 10;
          popbutton.Height := 50;

          popbutton.Parent := popupapps;
    //    popbutton.StyledSettings := [TStyledSetting.ssFamily, TStyledSetting.ssSize, TStyledSetting.ssStyle];
          popbutton.Align := TAlignLayout.MostTop;
          popbutton.Text := TDictionary<string,TApplication>(button.TagObject).Items[key].name;
        end;
      end else
      begin
        TDictionary<string,TApplication>(button.TagObject).Remove(key);
      end;
    end;
    if ((TDictionary<string,TApplication>(button.TagObject).Count = 0)) then
    begin
      //menuRight.button_minClick(nil);
      app := starteprogramm (button.Tag);
      if app.processid > 0 then
      begin
        TDictionary<string,TApplication>(button.TagObject).Add (inttostr(app.processid),app);
      end;
    end else
    if runonce = false then
    begin
      popbutton := TButton.Create(nil);
  //    popbutton.StyledSettings := [TStyledSetting.ssFamily, TStyledSetting.ssSize, TStyledSetting.ssStyle];
      popbutton.Margins.top := 10;
      popbutton.Margins.Left := 10;
      popbutton.Margins.Right := 10;
      popbutton.Parent := popupapps;
      popbutton.Height := 50;
      popbutton.Align := TAlignLayout.Top;
      popbutton.Text := 'Programm neu öffnen';
      popupApps.Popup;
    end;
  end else
  begin
    //menuRight.button_minClick(nil);
    app := starteprogramm (button.Tag);
    if app.processid > 0 then
    begin
      TDictionary<string,TApplication>(button.TagObject).Add (inttostr(app.processid),app);
    end;
  end;
end;



procedure TMainform.Button_newmessagesClick(Sender: TObject);
Var ButtonPressed : TFMXObject;
begin
  // Change style of button for show the pressed button
  for ButtonPressed in Panel2.Children do
    if ButtonPressed.ClassName = 'TButton' then
      if (ButtonPressed as TButton).Text = Label_Loading.Text then
        (ButtonPressed as TButton).StyleLookup := 'Button_sentStyle1';
  (sender as Tbutton).StyleLookup := 'Button_inboxStyle1';
  Label_Loading.Text := (sender as TButton).Text;
  AniIndicator_Loading.Enabled := true;

  Case (sender as TButton).Tag of
   1: showWebwithParams(FormChromium.webBrowser,FurlNewMessages);
   2: showWebwithParams(FormChromium.webBrowser,Furlinbox);
   3: showWebwithParams(FormChromium.webBrowser,Furlsent);
   4: showWebwithParams(FormChromium.webBrowser,Furltrash);
  End;
end;

function TMainform.Exec(const FileName: string;
  const CmdShow: Integer): Longword;
begin
  StrPCopy(zAppName, FileName);
  GetDir(0, WorkDir);
  StrPCopy(zCurDir, WorkDir);
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb          := SizeOf(StartupInfo);
  StartupInfo.dwFlags     := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := CmdShow;
  CreateProcess(nil,
    zAppName, // pointer to command line string
    nil, // pointer to process security attributes
    nil, // pointer to thread security attributes
    False, // handle inheritance flag
    CREATE_NEW_CONSOLE or // creation flags
    NORMAL_PRIORITY_CLASS,
    nil, //pointer to new environment block
    PChar(ExtractFilePath(Filename)), // nil, // pointer to current directory name
    StartupInfo, // pointer to STARTUPINFO
    ProcessInfo);
    result := ProcessInfo.dwProcessId;
end;


procedure TMainform.AppException(Sender: TObject; E: Exception);
begin

  if Sender is TComponent then
    dbase.WriteToLog(Format('Es ist folgender Fehler aufgetreten:%s%s%s'+
    'Fehlertyp:%s%s%sSender:%s%s [%s]', [#10#13, E.Message,
    #13#10#13#10, #10#13, E.ClassName, #10#13#10#13, #13#10,
    TComponent(Sender).Name, Sender.ClassName]),true)
  else
    dbase.WriteToLog(Format('Es ist folgender Fehler aufgetreten:%s%s%s'+
    'Fehlertyp:%s%s%sSender:%s%s', [#10#13, E.Message, #13#10#13#10,
    #10#13, E.ClassName, #10#13#10#13, #13#10, Sender.ClassName]),
    true);
end;

procedure TMainform.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
 { if Key = vkEscape then
    ShowToolbar(not ToolbarPopup.IsOpen); }
  if key = vkF6 then
    Menuright.Button_LogoffClick(nil);
end;


procedure TMainform.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
  if (X = 0) and (Menuright.Width < 35) then
    Menuright.button_minClick(nil);
  // here we try to find when we need show webbrowser
  if (X > 0) and( not FormChromium.Visible) and (round(pnBrowser.Height) > 0) and (not FloatAnimation1.Running) then
    FormChromium.Visible := true;
end;

procedure TMainform.FormShow(Sender: TObject);
var aNeedBuildApplicationList : boolean;
    aqDml : TFDQuery;
begin
  menuright.show;
  self.SendToBack;
  aNeedBuildApplicationList := false;
  self.Timer_Checknewmessages.Enabled := false;
  self.WebBrowserStandart.Parent := pnBrowser;
  self.WebBrowserStandart.Align := TAlignLayout.Client;
  self.WebBrowserStandart.OnDidFinishLoad := self.WebBrowserStandartDidFinishLoad;
  if fileexists(FLogoImgPath) then
  begin
    imageControl_logo.LoadFromFile(FLogoImgPath);
    LOGINSCREEN.imageControl_logo.LoadFromFile(FLogoImgPath);
  end;
  if fileexists(FClientImgPath) then
    imageControl_Client.LoadFromFile(FClientImgPath);
  //hotelserverapi.URL :='http://cloud2.gms.info:3000';

  FUrlnewmessages :=  hotelserverapi.URL + '/setting/announcements';
  FUrlinbox       :=  hotelserverapi.URL + '/setting/announcements/inbox';
  FUrlsent        :=  hotelserverapi.URL + '/setting/announcements/sent';
  FUrltrash       :=  hotelserverapi.URL + '/setting/announcements/trash';

  // Trying to login
  //hotelserverapi.Username := 'admin@felix.info';
  //hotelserverapi.Password := 'adminfelix';

  if (not hotelserverapi.isLogin) and (not FLoginWithoutServer) then
    if LOGINSCREEN.ShowModal = mrOk then
    begin
      try
        hotelserverapi.Login;
      except

      end;
      aNeedBuildApplicationList := true;
    end
    else
    begin
      self.Close;
      exit;
    end;

  if not hotelserverapi.isLogin then
  begin
    if (hotelserverapi.Username = 'admin@felix.info') and (hotelserverapi.Password = 'adminfelix') then
      FLoginWithoutServer := true
    else
    begin
      ShowMessage('Falsche Anmeldedaten');
      formShow(self);
    end;
  end;

  LOGINSCREEN.edit_username.Lookup.DisplayList.Add(hotelserverapi.Username);
  menuright.Label_Username.Text := hotelserverapi.Username;
  Label_Username.Text := hotelserverapi.Username;
  if not FLoginWithoutServer then
  begin
    self.Timer_Checknewmessages.Enabled := true;
    Label_Loading.Text := Button_NewMessages.Text;
    AniIndicator_Loading.Enabled := true;
    ShowWebwithparams(FormChromium.webBrowser, FUrlNewMessages);
  end;
  // Get user_number from table
  aqDml := TFDQuery.Create(self);
  aqDml.Connection := DBase.IB_ConnectionFelix;
  aqDml.SQL.Text := 'select user_number from user_users where username ='''+hotelserverapi.Username+'''';
  aqDml.Open();
  if aqDml.RecordCount > 0 then
  begin
    aqDml.First;
    FUsernumber := aqDml.Fields.Fields[0].AsString;
  end
  else
    FUsernumber := '0';
  aqDml.Free;

  // here we send SendLogin
  if FNeedSendLogin then
    SendLogin(strtoint(FUserNumber));

  if aNeedBuildApplicationList then
  begin
    query_applications.Close;
    query_applications.Params.ParamByName('Username').AsString := hotelserverapi.Username;
    query_applications.Open();
    // Build application list
    ladeApplications(0);
  end;

end;

procedure TMainform.Image_Click(Sender: TObject);
var aTile : TPanel;
    aButton : TFmxObject;
begin
  // There we will Launch the program when user click on Image of tile
  aTile := ((sender as TImageControl).Parent as TPanel);
  for aButton in aTile.Children do
    if aButton.ClassName = 'TButton' then
    begin
      ButtonTileClick(aButton);
      break;
    end;
end;

procedure TMainform.ladeApplications(aRuleid: integer);
var
  appbutton,appbuttonmenu : Tbutton;
  aTile : TApplicationTile;
  //maxfelder,aktfelder : integer;
  list : TDictionary<string,TApplication>;
  I: Integer;
  rect : TRectangle;
  textOben : TText;
begin
//  maxfelder := Tilepage.Rows * Tilepage.Columns;
//  aktfelder := 0;
//  Tilepage.BeginUpdate;
//  Tilepage.Tiles.Clear;
 // gridlayout.
  //Programmlist.Tiles.Clear;
 // Listapps.Tiles.Clear;
  GridLayout1.Free;
  GridLayout1 := TGridLayout.Create(self);
  GridLayout1.Parent := TabControl1.Tabs[0];
  GridLayout1.Align := TAlignLayout.Client;
  GridLayout1.ItemHeight := FTileSideSize;
  GridLayout1.ItemWidth  := FTileSideSize;

  menuRight.clearProgramm;
  menuRight.addLine;
  // if user is admin then make access
  if hotelserverapi.Username = 'admin@felix.info' then
  begin
    appbuttonmenu := Tbutton.Create(nil);
    appbuttonmenu.Text := 'Konfigurieren';
    appbuttonmenu.OnClick := ConfigButtonClick;
    appbuttonmenu.StyleLookup := 'Button_ProgramMenuStyle1';
    appbuttonmenu.TextSettings.HorzAlign := TTextAlign.Leading;
    menuRight.addprogramm(appbuttonmenu);
    menuRight.addLine;
  end;

  appbuttonmenu := Tbutton.Create(nil);
  appbuttonmenu.Text := 'Desktop anzeigen';
  appbuttonmenu.OnClick := ButtonShowDesktopClick;
  appbuttonmenu.StyleLookup := 'Button_ProgramMenuStyle1';
  appbuttonmenu.TextSettings.HorzAlign := TTextAlign.Leading;
  menuRight.addprogramm(appbuttonmenu);
  menuRight.addLine;

  menuRight.addListName('Programmliste');

  with query_applications do
  begin
    close;
    open;
    First;
    I := 1;
    while not eof do
    begin
      if FileExists(fieldbyname ('Path').AsString) then
      begin

        //it := Programmlist.Tiles.Add;
        rect := TRectangle.Create(nil);
        rect.XRadius := 10;
        rect.YRadius := 10;
        rect.Fill.Kind := TBrushKind.None;
        rect.Stroke.Kind := Tbrushkind.none;

        appbutton := Tbutton.Create(nil);
        list := TDictionary<string,TApplication>.Create;
        appbutton.TagObject := list;
        appbutton.HitTest := true;
        appbutton.Margins.Left := 5;
        appbutton.Margins.Right := 5;
        appbutton.Margins.Top := 5;
        appbutton.Margins.Bottom := 5;
        appbutton.Align := TAlignLayout.None;
        appbutton.OnClick := ButtonTileClick;
        appbutton.Tag := fieldbyname ('id').AsInteger;
        appbutton.Parent := rect;


        appbuttonmenu := Tbutton.Create(nil);
        appbuttonmenu.Tag := fieldbyname ('id').AsInteger;
        appbuttonmenu.TagObject := appbutton.TagObject;
        appbuttonmenu.Text := '     '+fieldbyname ('Name').AsString;
        appbuttonmenu.TabOrder := I;
        appbuttonmenu.OnClick := buttonTileClick;
        appbuttonmenu.StyleLookup := 'Button_ProgramMenuStyle1';
        appbuttonmenu.TextSettings.HorzAlign := TTextAlign.Leading;
        menuRight.addprogramm(appbuttonmenu);
        menuRight.addLine;

        textOben := TText.Create(nil);
        textOben.Text := fieldbyname ('Name').AsString;
        textOben.Align := TAlignLayout.Top;
        textOben.Font.Size := 30;
        textoben.HitTest := false;
        textOben.Parent := appbutton;

        //it.Caption := fieldbyname ('Name').AsString;
        //it.Badge := fieldbyname ('id').AsString;
        //it.Shape.Fill.Kind := TBrushKind.None;
        //it.Bitmap.Assign(TBLOBField(fieldbyname('IMG')));
        //it.Bitmap.

       // it.DataObject := appbuttonmenu;

        aTile := TApplicationTile.Create(self,self.GridLayout1);
        aTile.Label_AppName.Text := fieldbyname ('Name').AsString;
        aTile.ImageControl.Bitmap.Assign(TBLOBField(fieldbyname('ICON')));
        aTile.Button.Text := fieldbyname ('Name_Short').AsString;
        aTile.Button.TagObject := list;
        aTile.Button.Tag := fieldbyname ('id').AsInteger;

        I := I + 1;
      end;
      next;
    end;
  end;
end;

function TMainform.starteprogramm(aApplicationID: integer): TApplication;
begin
  with query_app do
  begin
    close;
    ParamByName('id').AsInteger := aApplicationID;
    open;
    result.name := fieldbyname ('NAME').AsString;
    result.location := fieldbyname ('Path').AsString;
    result.param := fieldbyname ('PARAMS').AsString;
    // analyze login type and make param string
    if (fieldbyname ('Login_Type').AsInteger and co_EasyLogin) = co_EasyLogin then
    begin
      result.param := result.param + ' ' + 'x ' +FUsernumber;
      result.param := trim(result.param);
    end;
    if (fieldbyname ('Login_Type').AsInteger and co_KeyLogin) = co_KeyLogin then
      result.param := result.param + '?' + 'user_token='+hotelserverapi.Token+ '&lookup_company_id=1';

    if fieldbyname ('RUNCEONE').AsInteger = 0 then
      result.runonce := false
    else
      result.runonce := true;

    result.processid := Exec(result.location+' '+result.param,SW_SHOW);
  end;
end;

procedure TMainform.Timer_ChecknewmessagesTimer(Sender: TObject);
var aCount : string;
    Msg : TMessage;
begin
  aCount := hotelserverapi.getmessagecount(inttostr(hotelserverapi.UserID), hotelserverapi.Token);
  if (strtoint(aCount) > strtoint(Label_Newmessagecount.Text)) and fileexists(FSoundPath) then
  begin
    // Play sound
    sndPlaySound(PChar(FSoundPath), SND_ASYNC);
    FNeedShowBalloon := true;
  end;
  // show the notification
  if FneedShowBalloon then
  begin
    with TrayIconData do
    begin
      StrLCopy(szInfo, PChar(aCount+' ungelesene Nachrichten'), High(szInfo));
      StrLCopy(szInfoTitle, PChar('Nachrichten'), High(szInfoTitle));
      uFlags := NIF_INFO;
      dwInfoFlags := 0;
    end;
    Shell_NotifyIcon(NIM_MODIFY, @TrayIconData);
  end;
  Timer_Checknewmessages.Interval := 30000;
  Label_Newmessagecount.Text := aCount;
end;

procedure TMainform.Timer_hideScrolTimer(Sender: TObject);
var ajscript : string;
begin
  Timer_hideScrol.Enabled := false;

  ajscript := 'document.documentElement.style.overflowX = ''hidden'';';
  WebBrowserStandart.EvaluateJavaScript(ajscript);

  ajscript := 'var attempts = 0;';
  WebBrowserStandart.EvaluateJavaScript(ajscript);

  ajscript := '$(document).keydown(function(e) { ' +
              ' if ((e.which == 8) || ((e.which >= 37) && (e.which <= 40)) || (e.which == 86) ) ' +
              ' { ' +
              '   if(attempts < 2) { ' +
              '     attempts = attempts + 1;   ' +
              '     e.preventDefault(); ' +
              ' } else attempts = 0; }  ' +
              '});';
  WebBrowserStandart.EvaluateJavaScript(ajscript);

  aniIndicator_Loading.Enabled := false;
end;

procedure TMainform.ToolbarCloseButtonClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMainform.WebBrowserStandartDidFinishLoad(ASender: TObject);
begin
 Timer_hideScrol.Enabled := true;
end;



procedure TMainform.FloatAnimation1Finish(Sender: TObject);
begin
  // if the direction is not-inverse then make it visiable
  if not FloatAnimation1.Inverse then
    FormChromium.Visible := true;
end;

procedure TMainform.FormCreate(Sender: TObject);
begin
{  Application.OnException := AppException;
  hotelserverapi.URL := 'https://salzburg.gms.info:8080/api/v1';
  while not hotelserverapi.isLogin = true do
  begin
    LoginScreen := TFMLOGIN.Create(nil);
    LOGINSCREEN.TextError.Text := hotelserverapi.LASTERROR;
    LOGINSCREEN.Image_error.Visible := length (hotelserverapi.LASTERROR) > 1;
    LoginScreen.ShowModal;
    if LOGINSCREEN.FABBRUCH = false then
    begin
      hotelserverapi.Login;
    end else
    begin
      application.Terminate;
      exit;
    end;
    LOGINSCREEN.Free;
  end;
  user.Text := hotelserverapi.Username;   }


  hotelserverapi := Thotelserverapi.Create(self);
  LOGINSCREEN := TfmLogin.Create(self);

  WebBrowserStandart := TWebBrowser.Create(self);
  FLoginWithoutServer := false;

  // use tray icon here
  TrayWnd := AllocateHWnd(TrayWndProc);
  with TrayIconData do
  begin
    cbSize := System.SizeOf(TrayIconData);
    Wnd := TrayWnd;
    uID := 1;
    uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
    uCallbackMessage := WM_USER+1;
    hIcon := GetClassLong(FmxHandleToHWND(self.Handle), GCL_HICONSM);
    StrPCopy(szTip, Application.Title);
  end;

  if not TrayIconAdded then
    TrayIconAdded := Shell_NotifyIcon(NIM_ADD, @TrayIconData);

  // setup the form size
  self.Height := Screen.WorkAreaHeight;
  self.Width := Screen.WorkAreaWidth;

  // login and logout
  wLogout := RegisterWindowMessage(szLogout);
  wLogin := RegisterWindowMessage(szLogin);

  // for balloon
  FNeedShowBalloon := false;
  // for login to prevent double login
  MainForm.FNeedSendLogin := false;
  // save the height of a browser for hide function
  FBrowserHeight := 0;
  // set the restore event

end;

Procedure TMainForm.DoLogOut;
begin
  Button_newmessagesClick(Mainform.Button_newmessages);
  hotelserverapi.logout;
  FLoginWithoutServer := false;
  menuRight.Hide;
  FormShow(nil);
end;

Procedure TMainForm.DoLogIn(usernumber:string);
var aUserNum : integer;
    aToken : string;
    aqDml : TFDQuery;
begin
  // skip do login if this application initiate send login
  if FNeedSendLogin then
  begin
    FNeedSendLogin := false;
    exit;
  end;

  aqDml := TFDQuery.Create(self);
  aqDml.Connection := DBase.IB_ConnectionFelix;
  aqDml.SQL.Text := 'select ID, USERNAME, AUTHENTICATION_TOKEN from user_users where user_number = '+usernumber;
  aqDml.Open();
  if aqDML.RecordCount > 0 then
  begin
    aqDml.First;
    hotelserverapi.Token := aqDml.FieldByName('AUTHENTICATION_TOKEN').AsString;
    hotelserverapi.Username := aqDml.FieldByName('USERNAME').AsString;
    //hotelserverapi.UserID := strtoint(usernumber);
    hotelserverapi.UserID := aqDml.FieldByName('ID').AsInteger;
  end;
  aqDml.Free;
  LOGINSCREEN.ModalResult := mrOk;
  //LOGINSCREEN.Button_loginClick(nil);
  LOGINSCREEN.CloseModal;
end;

procedure TMainForm.SendLogin(pMitarbeiterID: Integer);
var dwRecipient: DWord;
    wMsgValue: WPARAM;
begin
  wMsgValue := pMitarbeiterID;
  dwRecipient := BSM_APPLICATIONS;
  BroadCastSystemMessage(BSF_POSTMESSAGE, @dwRecipient, wLogIn, wMsgVAlue, 0);
end;

procedure TMainForm.SendLogOut(sender:TObject);
var dwRecipient: DWord;
wMsgValue: WPARAM;
begin
  //SendLogout to Application, wenn nicht von jemand anderen kommt
// if Sender <> nil then
  begin
    wMsgValue := 0;
    dwRecipient := BSM_APPLICATIONS;
    BroadCastSystemMessage(BSF_POSTMESSAGE, @dwRecipient, wLogout, wMsgVAlue, 0);
  end;
end;


procedure TMainform.FormDestroy(Sender: TObject);
begin
 if TrayIconAdded then
   Shell_NotifyIcon(NIM_DELETE, @TrayIconData);
 DeallocateHWnd(TrayWnd);
end;

procedure TMainform.TrayWndProc(var Message: TMessage);
begin
  if Message.Msg = WM_ACTIVATEAPP then // Message.Msg = 28 the action of clossing balloon message
  begin
    FNeedShowBalloon := false;
    if (Message.WParam = 1) and (Round(pnBrowser.Height) > 0) then FormChromium.Show;
    if (Message.WParam = 0) then FormChromium.Hide;
  end
  else
    Message.Result := DefWindowProc(TrayWnd, Message.Msg, Message.WParam, Message.LParam);
end;


procedure TMainform.webBrowserLoadEnd(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer);
var ajscript : string;
begin
  ajscript := 'document.documentElement.style.overflowX = ''hidden'';';
  Browser.MainFrame.ExecuteJavaScript(ajscript,'about:blank',0);
  // here we save the atempts
  ajscript := 'var attempts = 0;';
  Browser.MainFrame.ExecuteJavaScript(ajscript,'about:blank',0);
  // the make new line doesn't work, so use javascript to make it
  ajscript := '$("#setting_announcement_message").keyup(function(e) { ' +
                ' if(e.which == 13) ' +
                ' { ' +
                '   var txt = $("#setting_announcement_message").val(); ' +
                '   $("#setting_announcement_message").val(txt + ''\n''); ' +
                ' } ' +
                '});';
  browser.MainFrame.ExecuteJavaScript(ajscript,'about:blank',0);
  // this is the javascript for backspase arrow keys and Ctrl+v it prevent triple execute
  // lock triple execute in comboboxs
  ajscript := '$(document).keydown(function(e) { ' +
         //     ' alert("e.which == "+String(e.which)); ' +
         //     ' alert("e.which == "+String(e.type)); ' +
         //     '     e.preventDefault(); ' +
              ' if ((e.which == 8) || ((e.which >= 37) && (e.which <= 40)) || (e.which == 86) ) ' +
              ' { ' +
              '   if(attempts < 2) { ' +
              '     attempts = attempts + 1;   ' +
              '     e.preventDefault(); ' +
              ' } else attempts = 0; }  ' +
     //         '   var txt = $("#setting_announcement_message").val(); ' +
     //         '   $("#setting_announcement_message").val(txt + String(attempts)); ' +
              '});';
  browser.MainFrame.ExecuteJavaScript(ajscript,'about:blank',0);


  aniIndicator_Loading.Enabled := false;
end;

procedure TMainform.FormGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var
  DX, DY : Single;
begin
  if EventInfo.GestureID = igiPan then
  begin
    if (TInteractiveGestureFlag.gfBegin in EventInfo.Flags)
      and ((Sender = ToolbarPopup)
        or (EventInfo.Location.Y > (ClientHeight - 70))) then
    begin
      FGestureOrigin := EventInfo.Location;
      FGestureInProgress := True;
    end;

    if FGestureInProgress and (TInteractiveGestureFlag.gfEnd in EventInfo.Flags) then
    begin
      FGestureInProgress := False;
      DX := EventInfo.Location.X - FGestureOrigin.X;
      DY := EventInfo.Location.Y - FGestureOrigin.Y;
      if (Abs(DY) > Abs(DX)) then
        ShowToolbar(DY < 0);
    end;
  end
end;

procedure TMainform.ShowToolbar(AShow: Boolean);
begin
  ToolbarPopup.Width := ClientWidth;
  ToolbarPopup.PlacementRectangle.Rect := TRectF.Create(0, ClientHeight-ToolbarPopup.Height, ClientWidth-1, ClientHeight-1);
  ToolbarPopupAnimation.StartValue := ToolbarPopup.Height;
  ToolbarPopupAnimation.StopValue := 0;

  ToolbarPopup.IsOpen := AShow;
end;

procedure TMainform.StartbuttonClick(Sender: TObject);
begin
  Popup_settings.Parent := ToolBarStartmenu;
  Popup_settings.Popup();
end;

end.
