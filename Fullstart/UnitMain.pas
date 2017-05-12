unit UnitMain;

// Embarcadero Delphi 10.1 Berlin
// This is main unit which contain main visual form and
// application Tiles and space for message system

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts,
  FMX.Gestures,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Calendar, FMX.ListBox,
  FMX.Objects, FMX.Effects, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, UnitLogin, Hsapi, Windows, Generics.Collections,
  FMX.TMSTileList,
  FMX.Menus, FMX.TabControl, System.Rtti, FMX.Grid, Fmx.Graphics,
  UnitMenu, ChromiumVCLUnit, UnitVCL, FMX.WebBrowser, FMX.ExtCtrls, FMX.Edit,
  IPPeerClient, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, Ceffmx, Ceflib, System.Math.Vectors, FMX.Controls3D,
  FMX.Layers3D, Mmsystem, FMX.TMSCustomEdit, FMX.TMSEdit, ShellAPI, Messages,
  FMX.Platform.Win, CommCtrl, Vcl.Forms,
  Cefvcl, System.ImageList, FMX.ImgList
    ;

type
  TApplicationTile = class(TPanel)
    ImageControl: TImageControl;
    LabelAppName: TLabel;
    Button: TButton;
    constructor Create(AOwner: TComponent; Layout: TGridLayout); overload;
  end;

type
  TApplication = record
    Name:string;
    Location:string;
    Param:string;
    Processid: Integer;
    Runonce: Boolean;
  end;

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
    RectangleSettings: TRectangle;
    ButtonShutdown: TButton;
    Image1: TImage;
    ButtonLogout: TButton;
    ImageLogout: TImage;
    LabelUser: TLabel;
    ImageUser: TImage;
    GlowEffectPopup: TGlowEffect;
    FDQueryApplicationList: TFDQuery;
    FDQueryApplication: TFDQuery;
    TabControlTile: TTabControl;
    StyleBook: TStyleBook;
    TabItemTile: TTabItem;
    PanelBrowser: TPanel;
    ImageControlLogo: TImageControl;
    PanelMessageButtons: TPanel;
    ButtonNewMessages: TButton;
    ButtonSent: TButton;
    ButtonInbox: TButton;
    ButtonTrash: TButton;
    CalloutPanelNewMessagesCount: TCalloutPanel;
    LabelNewMessagesCount: TLabel;
    TimerCheckNewMessages: TTimer;
    GridLayoutTile: TGridLayout;
    TimerHideScrol: TTimer;
    ImageControlClient: TImageControl;
    AniIndicatorLoading: TAniIndicator;
    LabelLoading: TLabel;
    ButtonMinimize: TButton;
    LabelUserName: TLabel;
    LabelTextLogin: TLabel;
    SpeedButtonHideBrowser: TSpeedButton;
    FloatAnimationHideBrowser: TFloatAnimation;
    FloatAnimationBrowser: TFloatAnimation;
    PanelTile: TPanel;
    PanelBottom: TPanel;
    PanelLeft: TPanel;
    PanelRight: TPanel;
    AniIndicatorUpdate: TAniIndicator;
    LabelUpdate: TLabel;
    TimerDoAutoUpdate: TTimer;
    ButtonManualUpdate: TButton;
    procedure ToolbarCloseButtonClick(Sender: TObject);
    procedure FormGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo;var Handled: Boolean);
    procedure FormKeyDown(Sender: TObject;var Key: Word;var KeyChar: Char;
      Shift: TShiftState);
    procedure StartbuttonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonTileClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonNewMessagesClick(Sender: TObject);
    procedure TimerCheckNewMessagesTimer(Sender: TObject);
    procedure WebBrowserStandartDidFinishLoad(ASender: TObject);
    procedure TimerHideScrolTimer(Sender: TObject);
    procedure ButtonShowDesktopClick(Sender: TObject);
    procedure ConfigButtonClick(Sender: TObject);
    procedure ImageClick(Sender: TObject);
    procedure ButtonMinimizeClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure WebBrowserLoadEnd(Sender: TObject;const Browser: ICefBrowser;
      const Frame: ICefFrame; HttpStatusCode: Integer);
    procedure SpeedButtonHideBrowserClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure FloatAnimationHideBrowserFinish(Sender: TObject);
    procedure FormClose(Sender: TObject;var Action: TCloseAction);
    procedure TimerDoAutoUpdateTimer(Sender: TObject);
    procedure ButtonManualUpdateClick(Sender: TObject);
  private
    WebBrowserStandart: TWebBrowser;
    FGestureOrigin: TPointF;
    FGestureInProgress: Boolean;
    FAppName: array[0 .. 512] of Char;
    FCurDir: array[0 .. 255] of Char;
    WorkDir:string;
    StartupInfo: TStartupInfo;
    ProcessInfo: TProcessInformation;
    TrayWnd: HWND;
    TrayIconData: TNotifyIconData;
    TrayIconAdded: Boolean;
    procedure ShowToolbar(AShow: Boolean);
    function Exec(const FileName:string;
      const CmdShow: Integer): Longword;
    function IsProcessVorhanden(ProzessID: Integer): THandle;
    procedure TrayWndProc(var Message: TMessage);
  protected

  public
    FLoginWithoutServer: Boolean;
    FUrlNewMessages:string;
    FUrlInbox:string;
    FUrlSent:string;
    FUrlTrash:string;
    FLogoImgPath:string;
    FClientImgPath:string;
    FTileSideSize: Integer;
    FSoundPath:string;
    FHeight: Integer;
    FWidth: Integer;
    FAutoLogin:string; // for login
    FUserNumber:string;
    FNeedShowBalloon: Boolean;
    FNeedSendLogin: Boolean;
    FUseAutoComplete: Boolean; // for username atocomplete
    LoginScreen: TfmLogin;
    VCLForm: TVclForm;
    FBrowserHeight: Integer;
    FUpdatewithError: Boolean;
    FFirstLaunch: Boolean;
    procedure AppException(Sender: TObject; E: Exception);
    procedure LadeApplications(ARuleid: Integer);
    function StarteProgramm(AApplicationID: Integer): TApplication;
    procedure ShowWebWithParams(WebBrowser: TChromium; Url:string;
      Sending: Boolean = False);
    procedure SendLogin(PMitarbeiterID: Integer);
    procedure SendLogOut(Sender: TObject);
    procedure DoLogOut;
    procedure DoLogIn(UserNumber:string);
    procedure DoUpdate(ServerDir, LocalDir:string);
    // Make an update for application list
  end;

var
  Mainform: TMainform;
  VLogout, VLogIn: Cardinal;

implementation

uses DMBase, ConfigUnit;

{$R *.fmx}


constructor TApplicationTile.Create(AOwner: TComponent; Layout: TGridLayout);
var AButtonWidth: Integer;
begin
  inherited Create(AOwner);
  Self.Parent := Layout;

  ImageControl := TImageControl.Create(AOwner);
  LabelAppName := TLabel.Create(AOwner);
  Button := TButton.Create(AOwner);

  Self.Margins.Left := Round(Self.Height * 0.05);
  Self.Margins.Right := Round(Self.Height * 0.05);
  Self.Margins.Top := Round(Self.Height * 0.05);
  Self.Margins.Bottom := Round(Self.Height * 0.05);
  Self.StyleLookup := 'Panel1Style1';

  Self.ImageControl.Parent := Self;
  Self.ImageControl.Align := TAlignLayout.Top;
  Self.ImageControl.EnableOpenDialog := False;
  Self.ImageControl.Height := Round(Self.Height * 0.8);
  Self.ImageControl.StyleLookup := 'ImageControl1Style1';
  Self.ImageControl.OnClick := MainForm.ImageClick;

  Self.LabelAppName.Parent := Self;
  Self.LabelAppName.Align := TAlignLayout.Bottom;
  Self.LabelAppName.Height := Round(Self.Height * 0.2);
  Self.LabelAppName.TextAlign := TTextAlign.Center;
  Self.LabelAppName.Font.Size := Round(Self.Height * 0.07);
  Self.LabelAppName.StyledSettings := Self.LabelAppName.StyledSettings -
    [TStyledSetting.Size];
  Self.LabelAppName.StyleLookup := 'Label_UserNameStyle1';

  Self.Button.Parent := Self;
  Self.Button.Align := TAlignLayout.None;
  AButtonWidth := Round(Self.Width * 0.2);
  Self.Button.Position.X := Round(Self.Width * 0.4);
  Self.Button.Position.Y := Round(Self.Height * 0.8)-
    Round(AButtonWidth * 0.8);
  Self.Button.Width := AButtonWidth;
  Self.Button.Height := AButtonWidth;
  Self.Button.TextSettings.Font.Size := Round(AButtonWidth * 0.4);
  Self.Button.StyledSettings := Self.Button.StyledSettings -
    [TStyledSetting.Size];
  Self.Button.OnClick := MainForm.ButtonTileClick;
  Self.Button.Visible := False;
end;

procedure TMainForm.ShowWebWithParams(WebBrowser: TChromium; Url:string;
  Sending: Boolean = False);
begin
  if Sending then
  begin
    WebBrowser.Visible := False;
    WebBrowserStandart.Visible := True;
    WebBrowserStandart.Navigate(Url + '?' + 'user_token=' + Hotelserverapi.Token
      + '&' + 'lookup_company_id=1' + '&' + 'disable_header=true');
  end
  else
  begin
    WebBrowserStandart.Visible := False;
    WebBrowser.Visible := True;
    FormChromium.Left := Round(ToolBarStartmenu.Position.X)+
      Round(PanelLeft.Width)+ 4;
    FormChromium.Top := Round(TabControlTile.Height)+
      Round(PanelMessageButtons.Height);
    FormChromium.Height := Round(PanelBrowser.Height)- 2;
    FormChromium.Width := Round(PanelBrowser.Width)- 8;
    FormChromium.Show;
    WebBrowser.Load(Url + '?' + 'user_token=' + Hotelserverapi.Token + '&' +
      'lookup_company_id=1' + '&' + 'disable_header=true');
  end;
end;

procedure TMainform.SpeedButtonHideBrowserClick(Sender: TObject);
begin
  if FBrowserHeight = 0 then
    FBrowserHeight := Round(PanelBrowser.Height);
  if Round(PanelBrowser.Height)= 0 then
  begin
    PanelBrowser.Height := PanelBrowser.Height + FBrowserHeight;
    ToolBarStartmenu.Height := ToolBarStartmenu.Height + FBrowserHeight;
    PanelTile.Height := PanelTile.Height - FBrowserHeight;
    SpeedButtonHideBrowser.StyleLookup := 'arrowdowntoolbuttonborderedright';
    // here we will make webBrowser visiable only on Finish of the FloatAnimation1
    FloatAnimationHideBrowser.Inverse := False;
    FloatAnimationBrowser.Inverse := False;
  end
  else
  begin
    PanelBrowser.Height := PanelBrowser.Height - FBrowserHeight;
    ToolBarStartmenu.Height := ToolBarStartmenu.Height - FBrowserHeight;
    PanelTile.Height := PanelTile.Height + FBrowserHeight;
    SpeedButtonHideBrowser.StyleLookup := 'arrowuptoolbuttonborderedleft';
    PanelBrowser.StyleLookup := 'pnBrowserStyle2';
    FormChromium.Hide;
    FloatAnimationHideBrowser.Inverse := True;
    FloatAnimationBrowser.Inverse := True;
  end;
  FloatAnimationHideBrowser.Start;
  FloatAnimationBrowser.Start;
end;

function TMainform.IsProcessVorhanden(ProzessID: Integer): THandle;
type
  PSearch =^TSearch;

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
    GetWindowThreadProcessId(Wnd,@WindowPid);
    if(WindowPid = Res^.PID)then
    // and IsMainAppWindow(Wnd) then // <--- <--- <---
    begin
      Res^.Wnd := Wnd;
      Result := False;
    end
    else
      Result := True;
  end;

begin
  SearchRec.PID := ProzessID;
  SearchRec.Wnd := 0;
  EnumWindows(@EnumWindowsProc, Integer(@SearchRec));
  Result := SearchRec.Wnd;
end;

procedure TMainform.ConfigButtonClick(Sender: TObject);
begin
  MenuRight.ButtonMinClick(nil);
  ConfigForm.ShowModal;
end;

procedure TMainform.ButtonMinimizeClick(Sender: TObject);
begin
  Self.WindowState := TWindowState.WsMinimized;
  FormChromium.Hide;
end;

procedure TMainform.ButtonShowDesktopClick(Sender: TObject);
begin
  MainForm.Show;
end;

procedure TMainform.ButtonTileClick(Sender: TObject);
var
  PopupApps: Tpopup;
  PopButton: TButton;
  App: TApplication;
  Handle: THandle;
  Button: Tbutton;
  Key:string;
  Runonce: Boolean;
begin
  Button := Sender as Tbutton;
  Runonce := False;
  if TDictionary<string, TApplication>(Button.TagObject).Count > 0 then
  begin
    PopupApps := Tpopup.Create(nil);
    PopupApps.Parent := Button;
    PopupApps.Width := Button.Width;
    PopupApps.Height := 200;

    for Key in TDictionary<string, TApplication>(Button.TagObject).Keys do
    begin
      Handle := IsProcessVorhanden(StrToInt(Key));
      if Handle <> 0 then
      begin
        if TDictionary<string, TApplication>(Button.TagObject).Items[Key]
          .Runonce = True then
        begin
          Runonce := True;
          SetForegroundWindow(Handle);
          ShowWindow(Handle, SW_SHOW);
        end
        else
        begin
          PopButton := TButton.Create(nil);
          PopButton.Margins.Top := 10;
          PopButton.Margins.Left := 10;
          PopButton.Margins.Right := 10;
          PopButton.Height := 50;
          PopButton.Parent := PopupApps;
          PopButton.Align := TAlignLayout.MostTop;
          PopButton.Text := TDictionary<string, TApplication>(Button.TagObject)
            .Items[Key].Name;
        end;
      end
      else
      begin
        TDictionary<string, TApplication>(Button.TagObject).Remove(Key);
      end;
    end;
    if((TDictionary<string, TApplication>(Button.TagObject).Count = 0))then
    begin
      App := StarteProgramm(Button.Tag);
      if App.Processid > 0 then
      begin
        TDictionary<string, TApplication>(Button.TagObject)
          .Add(IntToStr(App.Processid), App);
      end;
    end
    else
      if Runonce = False then
      begin
        PopButton := TButton.Create(nil);
        PopButton.Margins.Top := 10;
        PopButton.Margins.Left := 10;
        PopButton.Margins.Right := 10;
        PopButton.Parent := PopupApps;
        PopButton.Height := 50;
        PopButton.Align := TAlignLayout.Top;
        PopButton.Text := 'Programm neu öffnen';
        PopupApps.Popup;
      end;
  end
  else
  begin
    App := StarteProgramm(Button.Tag);
    if App.Processid > 0 then
    begin
      TDictionary<string, TApplication>(Button.TagObject)
        .Add(IntToStr(App.Processid), App);
    end;
  end;
end;

procedure TMainform.ButtonManualUpdateClick(Sender: TObject);
begin
  if TimerDoAutoUpdate.Enabled then
  begin
    TimerDoAutoUpdate.Enabled := False;
    TimerDoAutoUpdate.Interval := 1000;
    TimerDoAutoUpdate.Enabled := True;
  end;
end;

procedure TMainform.ButtonNewMessagesClick(Sender: TObject);
var
  ButtonPressed: TFMXObject;
begin
  // Change style of button for show the pressed button
  for ButtonPressed in PanelMessageButtons.Children do
    if ButtonPressed.ClassName = 'TButton' then
      if(ButtonPressed as TButton).Text = LabelLoading.Text then
        (ButtonPressed as TButton).StyleLookup := 'Button_sentStyle1';
  (Sender as Tbutton).StyleLookup := 'Button_inboxStyle1';
  LabelLoading.Text :=(Sender as TButton).Text;
  AniIndicatorLoading.Enabled := True;

  case(Sender as TButton).Tag of
  1:
    ShowWebwithParams(FormChromium.WebBrowser, FurlNewMessages);
  2:
    ShowWebwithParams(FormChromium.WebBrowser, Furlinbox);
  3:
    ShowWebwithParams(FormChromium.WebBrowser, Furlsent);
  4:
    ShowWebwithParams(FormChromium.WebBrowser, Furltrash);
  end;
end;

function TMainform.Exec(const FileName:string;
  const CmdShow: Integer): Longword;
begin
  StrPCopy(FAppName, FileName);
  GetDir(0, WorkDir);
  StrPCopy(FCurDir, WorkDir);
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.Cb := SizeOf(StartupInfo);
  StartupInfo.DwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.WShowWindow := CmdShow;
  CreateProcess(nil,
    FAppName, // pointer to command line string
    nil, // pointer to process security attributes
    nil, // pointer to thread security attributes
    False, // handle inheritance flag
    CREATE_NEW_CONSOLE or // creation flags
    NORMAL_PRIORITY_CLASS,
    nil, // pointer to new environment block
    PChar(ExtractFilePath(Filename)),
    // nil, // pointer to current directory name
    StartupInfo, // pointer to STARTUPINFO
    ProcessInfo);
  Result := ProcessInfo.DwProcessId;
  DataModuleBase.WriteToLog('Run application ' + FileName, True);
end;

procedure TMainform.AppException(Sender: TObject; E: Exception);
begin
  if Sender is TComponent then
    DataModuleBase.WriteToLog
      (Format('Es ist folgender Fehler aufgetreten:%s%s%s' +
      'Fehlertyp:%s%s%sSender:%s%s [%s]',[#10#13, E.Message,
      #13#10#13#10, #10#13, E.ClassName, #10#13#10#13, #13#10,
      TComponent(Sender).Name, Sender.ClassName]), True)
  else
    DataModuleBase.WriteToLog
      (Format('Es ist folgender Fehler aufgetreten:%s%s%s' +
      'Fehlertyp:%s%s%sSender:%s%s',[#10#13, E.Message, #13#10#13#10,
      #10#13, E.ClassName, #10#13#10#13, #13#10, Sender.ClassName]),
      True);
end;

procedure TMainform.FormKeyDown(Sender: TObject;var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = VkF6 then
    MenuRight.ButtonLogoffClick(nil);
end;

procedure TMainform.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
  if(X = 0)and(MenuRight.Width < 35)then
    MenuRight.ButtonMinClick(nil);
  // here we try to find when we need show webbrowser
  if(X > 0)
    and(not FormChromium.Visible)
    and(Round(PanelBrowser.Height)> 0)
    and(not FloatAnimationHideBrowser.Running)then
    FormChromium.Visible := True;
end;

procedure TMainform.FormShow(Sender: TObject);
var ANeedBuildApplicationList: Boolean;
  AFDQueryDml: TFDQuery;
begin
  DataModuleBase.WriteToLog('Start of GMSStart', True);
  MenuRight.Show;
  PanelBrowser.StyleLookup := 'pnBrowserStyle2';
  ANeedBuildApplicationList := False;
  Self.TimerChecknewMessages.Enabled := False;
  Self.WebBrowserStandart.Parent := PanelBrowser;
  Self.WebBrowserStandart.Align := TAlignLayout.Client;
  Self.WebBrowserStandart.OnDidFinishLoad :=
    Self.WebBrowserStandartDidFinishLoad;
  if FileExists(FLogoImgPath)then
  begin
    ImageControlLogo.LoadFromFile(FLogoImgPath);
    LoginScreen.ImageControlLogo.LoadFromFile(FLogoImgPath);
  end;
  if FileExists(FClientImgPath)then
    ImageControlClient.LoadFromFile(FClientImgPath);

  FUrlNewMessages := HotelServerApi.URL + '/setting/announcements';
  FUrlInbox := HotelServerApi.URL + '/setting/announcements/inbox';
  FUrlSent := HotelServerApi.URL + '/setting/announcements/sent';
  FUrlTrash := HotelServerApi.URL + '/setting/announcements/trash';

  // Trying to login
  DataModuleBase.WriteToLog('Showing Login diaolog', True);
  if(not HotelServerApi.IsLogin)and(not FLoginWithoutServer)then
    if LoginScreen.ShowModal = MrOk then
    begin
      try
        HotelServerApi.Login;
      except

      end;
      ANeedBuildApplicationList := True;
    end
    else
    begin
      Self.Close;
      Exit;
    end;

  if not HotelServerApi.IsLogin then
  begin
    if(HotelServerApi.UserName = 'admin@felix.info')and
      (HotelServerApi.Password = 'adminfelix')then
    begin
      FLoginWithoutServer := True;
      DataModuleBase.WriteToLog
        ('Login without messages as admin@felix.info', True);
    end
    else
    begin
      DataModuleBase.WriteToLog('Falsche Anmeldedaten', True);
      ShowMessage('Falsche Anmeldedaten');
      FormShow(Self);
    end;
  end;

  DataModuleBase.WriteToLog('Succefully login as ' +
    HotelServerApi.UserName, True);
  LoginScreen.EditUserName.Lookup.DisplayList.Add(HotelServerApi.UserName);
  MenuRight.LabelUserName.Text := HotelServerApi.UserName;
  LabelUserName.Text := HotelServerApi.UserName;
  if not FLoginWithoutServer then
  begin
    Self.TimerCheckNewMessages.Enabled := True;
    LabelLoading.Text := ButtonNewMessages.Text;
    AniIndicatorLoading.Enabled := True;
    ShowWebWithParams(FormChromium.WebBrowser, FUrlNewMessages);
  end;
  // Get user_number from table
  AFDQueryDml := TFDQuery.Create(Self);
  AFDQueryDml.Connection := DataModuleBase.FDConnectionFelix;
  AFDQueryDml.SQL.Text := 'select user_number ' + #13#10 +
    '  from USER_USERS  ' + #13#10 +
    ' where username =''' + HotelServerApi.UserName + '''';
  AFDQueryDml.Open();
  if AFDQueryDml.RecordCount > 0 then
  begin
    AFDQueryDml.First;
    FUserNumber := AFDQueryDml.Fields.Fields[0].AsString;
  end
  else
    FUsernumber := '0';
  AFDQueryDml.Free;

  // here we send SendLogin
  if FNeedSendLogin then
    SendLogin(Strtoint(FUserNumber));

  if ANeedBuildApplicationList then
  begin
    FDQueryApplicationList.Close;
    FDQueryApplicationList.Params.ParamByName('Username').AsString :=
      HotelServerApi.UserName;
    FDQueryApplicationList.Open();
    // Build application list
    LadeApplications(0);
  end;

end;

procedure TMainform.ImageClick(Sender: TObject);
var
  ATile: TPanel;
  AButton: TFmxObject;
begin
  // There we will Launch the program when user click on Image of tile
  ATile :=((Sender as TImageControl).Parent as TPanel);
  for AButton in ATile.Children do
    if AButton.ClassName = 'TButton' then
    begin
      ButtonTileClick(AButton);
      Break;
    end;
end;

procedure TMainform.LadeApplications(ARuleid: Integer);
var
  AppButton, AppButtonMenu: TButton;
  ATile: TApplicationTile;
  List: TDictionary<string, TApplication>;
  I: Integer;
  Rect: TRectangle;
  TextOben: TText;
begin
  DataModuleBase.WriteToLog('Start build Application list ', True);
  GridLayoutTile.Free;
  GridLayoutTile := TGridLayout.Create(Self);
  GridLayoutTile.Parent := TabControlTile.Tabs[0];
  GridLayoutTile.Align := TAlignLayout.Client;
  GridLayoutTile.ItemHeight := FTileSideSize;
  GridLayoutTile.ItemWidth := FTileSideSize;

  MenuRight.ClearProgramm;
  MenuRight.AddLine;
  // if user is admin then make access
  if HotelServerApi.UserName = 'admin@felix.info' then
  begin
    AppButtonMenu := Tbutton.Create(nil);
    AppButtonMenu.Text := 'Konfigurieren';
    AppButtonMenu.OnClick := ConfigButtonClick;
    AppButtonMenu.StyleLookup := 'Button_ProgramMenuStyle1';
    AppButtonMenu.TextSettings.HorzAlign := TTextAlign.Leading;
    MenuRight.AddProgramm(AppButtonMenu);
    MenuRight.AddLine;
  end;

  AppButtonMenu := Tbutton.Create(nil);
  AppButtonMenu.Text := 'Desktop anzeigen';
  AppButtonMenu.OnClick := ButtonShowDesktopClick;
  AppButtonMenu.StyleLookup := 'Button_ProgramMenuStyle1';
  AppButtonMenu.TextSettings.HorzAlign := TTextAlign.Leading;
  MenuRight.AddProgramm(AppButtonMenu);
  MenuRight.AddLine;

  MenuRight.AddListName('Programmliste');

  with FDQueryApplicationList do
  begin
    Close;
    Open;
    First;
    I := 1;
    while not Eof do
    begin
      if FileExists(FieldByName('Path').AsString)then
      begin
        Rect := TRectangle.Create(nil);
        Rect.XRadius := 10;
        Rect.YRadius := 10;
        Rect.Fill.Kind := TBrushKind.None;
        Rect.Stroke.Kind := Tbrushkind.None;

        AppButton := Tbutton.Create(nil);
        List := TDictionary<string, TApplication>.Create;
        AppButton.TagObject := List;
        AppButton.HitTest := True;
        AppButton.Margins.Left := 5;
        AppButton.Margins.Right := 5;
        AppButton.Margins.Top := 5;
        AppButton.Margins.Bottom := 5;
        AppButton.Align := TAlignLayout.None;
        AppButton.OnClick := ButtonTileClick;
        AppButton.Tag := FieldByName('id').AsInteger;
        AppButton.Parent := Rect;

        AppButtonMenu := Tbutton.Create(nil);
        AppButtonMenu.Tag := FieldByName('id').AsInteger;
        AppButtonMenu.TagObject := AppButton.TagObject;
        AppButtonMenu.Text := '     ' + FieldByName('Name').AsString;
        AppButtonMenu.TabOrder := I;
        AppButtonMenu.OnClick := ButtonTileClick;
        AppButtonMenu.StyleLookup := 'Button_ProgramMenuStyle1';
        AppButtonMenu.TextSettings.HorzAlign := TTextAlign.Leading;
        MenuRight.AddProgramm(AppButtonMenu);
        MenuRight.AddLine;

        TextOben := TText.Create(nil);
        TextOben.Text := FieldByName('Name').AsString;
        TextOben.Align := TAlignLayout.Top;
        TextOben.Font.Size := 30;
        TextOben.HitTest := False;
        TextOben.Parent := AppButton;

        ATile := TApplicationTile.Create(Self, Self.GridLayoutTile);
        ATile.LabelAppName.Text := FieldByName('Name').AsString;
        ATile.ImageControl.Bitmap.Assign(TBLOBField(FieldByName('Icon')));
        ATile.Button.Text := FieldByName('Name_Short').AsString;
        ATile.Button.TagObject := List;
        ATile.Button.Tag := FieldByName('id').AsInteger;

        I := I + 1;
      end;
      Next;
    end;
  end;
end;

function TMainform.StarteProgramm(AApplicationID: Integer): TApplication;
begin
  with FDQueryApplication do
  begin
    Close;
    ParamByName('id').AsInteger := AApplicationID;
    Open;
    Result.Name := FieldByName('Name').AsString;
    Result.Location := FieldByName('Path').AsString;
    Result.Param := FieldByName('Params').AsString;
    // analyze login type and make param string
    if(FieldByName('Login_Type').AsInteger and CEasyLogin)= CEasyLogin then
    begin
      Result.Param := Result.Param + ' ' + 'x ' + FUsernumber;
      Result.Param := Trim(Result.Param);
    end;
    if(FieldByName('Login_Type').AsInteger and CKeyLogin)= CKeyLogin then
      Result.Param := Result.Param + '?' + 'user_token=' + HotelServerApi.Token
        + '&lookup_company_id=1';

    if FieldByName('Runceone').AsInteger = 0 then
      Result.Runonce := False
    else
      Result.Runonce := True;

    Result.Processid := Exec(Result.Location + ' ' + Result.Param, SW_SHOW);
  end;
end;

procedure TMainform.TimerCheckNewMessagesTimer(Sender: TObject);
var
  ACount:string;
begin
  ACount := HotelServerApi.GetMessageCount(IntToStr(HotelServerApi.UserID),
    HotelServerApi.Token);
  if(StrToInt(ACount)> StrToInt(LabelNewMessagesCount.Text))and
    FileExists(FSoundPath)then
  begin
    // Play sound
    SndPlaySound(PChar(FSoundPath), SND_ASYNC);
    FNeedShowBalloon := True;
  end;
  // show the notification
  if FneedShowBalloon then
  begin
    with TrayIconData do
    begin
      StrLCopy(SzInfo, PChar(ACount + ' ungelesene Nachrichten'), high(SzInfo));
      StrLCopy(SzInfoTitle, PChar('Nachrichten'), high(SzInfoTitle));
      UFlags := NIF_INFO;
      DwInfoFlags := 0;
    end;
    Shell_NotifyIcon(NIM_MODIFY,@TrayIconData);
  end;
  TimerCheckNewMessages.Interval := 30000;
  LabelNewMessagesCount.Text := ACount;
end;

procedure TMainform.TimerDoAutoUpdateTimer(Sender: TObject);
// here we will make fullupdate
var AFDQueryList: TFDQuery;
  I: Integer;
  ASubFolderList, ASubFolderName:string;
  AFoldersList: TStringList;
  AServerPath, ALocalPath:string;

  // building the list of directories in subfolders
  procedure BuildSubDirList(DirectoryName, SubFolder:string;
    ResultList: TstringList);
  var
    ATsr: TSearchRec;
    I, APrevSubFolderListCount, ANewSubFolderListCount: Integer;
  begin
    APrevSubFolderListCount := ResultList.Count;
    if APrevSubFolderListCount = 0 then
      APrevSubFolderListCount := 1;
    // try to find directories in the subfolder
    if FindFirst(DirectoryName + '\' + SubFolder + '\' + '*.*', FaDirectory,
      Atsr)= 0 then
      repeat
        if(ATsr.Name = '')or(ATsr.Name = '.')or(ATsr.Name = '..')then
          Continue;
        if((ATsr.Attr and FaDirectory)= 0)then
          Continue;
        ResultList.Add(SubFolder + '\' + ATsr.Name);
      until FindNext(ATsr)<> 0;
    System.SysUtils.FindClose(ATsr);
    // if we found the directories here we make recursion for folders
    ANewSubFolderListCount := ResultList.Count;
    while APrevSubFolderListCount < ANewSubFolderListCount do
    begin
      for I := APrevSubFolderListCount to ANewSubFolderListCount - 1 do
      begin
        if FindFirst(DirectoryName + '\' + ResultList.Strings[I]+ '\' + '*.*',
          FaDirectory, Atsr)= 0 then
          repeat
            if(ATsr.Name = '')or(ATsr.Name = '.')or(ATsr.Name = '..')then
              Continue;
            if((ATsr.Attr and FaDirectory)= 0)then
              Continue;
            ResultList.Add(ResultList.Strings[I]+ '\' + ATsr.Name);
          until FindNext(ATsr)<> 0;
        System.SysUtils.FindClose(ATsr);
      end;
      APrevSubFolderListCount := ANewSubFolderListCount;
      ANewSubFolderListCount := ResultList.Count;
    end;

  end;

begin
  TimerDoAutoUpdate.Enabled := False;
  AniIndicatorUpdate.Enabled := True;
  FUpdatewithError := False;
  TimerDoAutoUpdate.Interval := 600000;
  LabelUpdate.Text := 'Check for Updates';
  AFDQueryList := TFDQuery.Create(nil);
  AFDQueryList.Connection := DataModuleBase.FDConnectionFelix;
  if FFirstLaunch then
  begin
    AFDQueryList.SQL.Text :=
      'select *              ' + #13#10 +
      '  from User_Programs  ' + #13#10 +
      ' where AutoUpdate = ''1''';
    FFirstLaunch := False;
  end
  else
    AFDQueryList.SQL.Text :=
      'select *                   ' + #13#10 +
      '  from User_Programs       ' + #13#10 +
      ' where AutoUpdate = ''1''  ' + #13#10 +
      '   and DoAutoUpdateNow = ''1'' ';
  AFDQueryList.Open();
  if AFDQueryList.RecordCount > 0 then
    while not AFDQueryList.Eof do
    begin
      // Make an update for application
      LabelUpdate.Text := 'Update main folder for ' + AFDQueryList.FieldByName
        ('Name').AsString;
      // kill additional "\" symbol
      AServerPath := AFDQueryList.FieldByName('ServerPath').AsString;
      ALocalPath := ExtractFilePath(AFDQueryList.FieldByName('Path').AsString);
      // update main folder
      DoUpdate(AServerPath, ALocalPath);
      // now lets get the list of subfolders wich should be updated
      AFoldersList := TStringList.Create;
      I := 1;
      ASubFolderList := AFDQueryList.FieldByName('Subfolders').AsString;
      while(Length(ASubFolderList)> 0)or(I > 0)do
      begin
        I := Pos(';', ASubFolderList);
        if(I = 0)and(Length(ASubFolderList)> 0)then
        begin
          ASubFolderName := ASubFolderList;
          ASubFolderList := '';
        end
        else
          if I > 0 then
            ASubFolderName := Copy(ASubFolderList, 1, I - 1)
          else
            Continue;
        if Length(ASubFolderList)> 0 then
          ASubFolderList := Copy(ASubFolderList, I + 1);
        LabelUpdate.Text := 'Build subfolders list for ' +
          AFDQueryList.FieldByName('Name').AsString;
        AFoldersList.Add(ASubFolderName);
        BuildSubDirList(AServerPath, ASubFolderName, AFoldersList);
      end;

      for I := 0 to AFoldersList.Count - 1 do
      begin
        // create new folders if it is nessasary
        if not DirectoryExists(ALocalPath + '\' + AFoldersList.Strings[I])then
          ForceDirectories(ALocalPath + '\' + AFoldersList.Strings[I]);
        // update all file in directory
        LabelUpdate.Text := 'Update ' + AFoldersList.Strings[I]+ ' files for '
          + AFDQueryList.FieldByName('Name').AsString;
        DoUpdate(AServerPath + '\' + AFoldersList.Strings[I],
          ALocalPath + '\' + AFoldersList.Strings[I]);
      end;
      AFoldersList.Free;
      AFDQueryList.Next;
    end;

  if FUpdatewithError then
  begin
    LabelUpdate.Text :=
      'Update complete with Errors, Please close all programm and start the update manualy';
    ButtonManualUpdate.Visible := True;
  end
  else
  begin
    LabelUpdate.Text := 'Update succefully complete';
    ButtonManualUpdate.Visible := False;
  end;
  AFDQueryList.Free;
  AniIndicatorUpdate.Enabled := False;
  TimerDoAutoUpdate.Enabled := True;
end;

procedure TMainform.TimerHideScrolTimer(Sender: TObject);
var Ajscript:string;
begin
  TimerHideScrol.Enabled := False;

  Ajscript := 'document.documentElement.style.overflowX = ''hidden'';';
  WebBrowserStandart.EvaluateJavaScript(Ajscript);

  Ajscript := 'var attempts = 0;';
  WebBrowserStandart.EvaluateJavaScript(Ajscript);

  Ajscript := '$(document).keydown(function(e) { ' +
    ' if ((e.which == 8) || ((e.which >= 37) && (e.which <= 40)) || (e.which == 86) ) '
    +
    ' { ' +
    '   if(attempts < 2) { ' +
    '     attempts = attempts + 1;   ' +
    '     e.preventDefault(); ' +
    ' } else attempts = 0; }  ' +
    '});';
  WebBrowserStandart.EvaluateJavaScript(Ajscript);

  AniIndicatorLoading.Enabled := False;
end;

procedure TMainform.ToolbarCloseButtonClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMainform.WebBrowserStandartDidFinishLoad(ASender: TObject);
begin
  TimerHideScrol.Enabled := True;
end;

procedure TMainform.FloatAnimationHideBrowserFinish(Sender: TObject);
begin
  // if the direction is not-inverse then make it visiable
  if not FloatAnimationHideBrowser.Inverse then
  begin
    MainForm.PanelBrowser.StyleLookup := 'pnBrowserStyle1';
    FormChromium.Visible := True;
  end;
end;

procedure TMainform.FormClose(Sender: TObject;var Action: TCloseAction);
begin
  DataModuleBase.WriteToLog('Close GMSStart', True);
end;

procedure TMainform.FormCreate(Sender: TObject);
begin
  HotelServerApi := THotelServerApi.Create(Self);
  LoginScreen := TfmLogin.Create(Self);

  WebBrowserStandart := TWebBrowser.Create(Self);
  FLoginWithoutServer := False;

  // use tray icon here
  TrayWnd := AllocateHWnd(TrayWndProc);
  with TrayIconData do
  begin
    CbSize := System.SizeOf(TrayIconData);
    Wnd := TrayWnd;
    UID := 1;
    UFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
    UCallbackMessage := WM_USER + 1;
    HIcon := GetClassLong(FmxHandleToHWND(Self.Handle), GCL_HICONSM);
    StrPCopy(SzTip, Application.Title);
  end;

  if not TrayIconAdded then
    TrayIconAdded := Shell_NotifyIcon(NIM_ADD,@TrayIconData);

  // setup the form size
  Self.Height := Screen.WorkAreaHeight;
  Self.Width := Screen.WorkAreaWidth;

  // login and logout
  VLogout := RegisterWindowMessage(CLogout);
  VLogIn := RegisterWindowMessage(CLogin);

  // for balloon
  FNeedShowBalloon := False;
  // for login to prevent double login
  MainForm.FNeedSendLogin := False;
  // save the height of a browser for hide function
  FBrowserHeight := 0;
  FFirstLaunch := True;
end;

procedure TMainForm.DoLogOut;
begin
  ButtonNewMessagesClick(MainForm.ButtonNewMessages);
  HotelServerApi.Logout;
  FLoginWithoutServer := False;
  MenuRight.Hide;
  FormShow(nil);
end;

procedure TMainForm.DoLogIn(Usernumber:string);
var
  AUserNum: Integer;
  AToken:string;
  AFDQueryDml: TFDQuery;
begin
  // skip do login if this application initiate send login
  if FNeedSendLogin then
  begin
    FNeedSendLogin := False;
    Exit;
  end;

  AFDQueryDml := TFDQuery.Create(Self);
  AFDQueryDml.Connection := DataModuleBase.FDConnectionFelix;
  AFDQueryDml.SQL.Text := 'select ID, UserName, Authentication_Token ' + #13#10 +
    '  from User_Users                         ' + #13#10 +
    ' where User_Number = ' + UserNumber;
  AFDQueryDml.Open();
  if AFDQueryDml.RecordCount > 0 then
  begin
    AFDQueryDml.First;
    HotelServerApi.Token := AFDQueryDml.FieldByName
      ('Authentication_Token').AsString;
    HotelServerApi.Username := AFDQueryDml.FieldByName('UserName').AsString;
    HotelServerApi.UserID := AFDQueryDml.FieldByName('ID').AsInteger;
  end;
  AFDQueryDml.Free;
  LoginScreen.ModalResult := MrOk;
  LoginScreen.CloseModal;
end;

procedure TMainForm.DoUpdate(ServerDir, LocalDir:string);
// Make an update for application list
var I, J: Integer;
  IsNewFile: Boolean;
  AFileListLocal, AFileListServer, AFileListResult: TStringList;
  // Filling the list
  procedure FillList(DirectoryName:string; FilesList: TStringList);
  var ATsr: TSearchRec;
  begin
    if FindFirst(DirectoryName + '\' + '*.*', FaAnyFile, ATsr)= 0 then
      repeat
        if((ATsr.Attr and FaDirectory)<> 0)or(Trim(ATsr.Name)= '')
        then
          Continue;
        FilesList.Add(ATsr.Name);
      until FindNext(ATsr)<> 0;
    System.SysUtils.FindClose(ATsr);
  end;

begin
  // Make 2 lists for application files native and on server
  try
    AFileListLocal := TStringList.Create;
    FillList(LocalDir, AFileListLocal);
    AFileListServer := TStringList.Create;
    FillList(ServerDir, AFileListServer);
    // compare each other and make only one result list
    AFileListResult := TStringList.Create;
    for I := 0 to AFileListServer.Count - 1 do
    begin
      IsNewFile := True;
      for J := 0 to AFileListLocal.Count - 1 do
        if AFileListServer.Strings[I]= AFileListLocal.Strings[J] then
        begin
          IsNewFile := False;
          if FileAge(ServerDir + '\' + AFileListServer.Strings[I])>
            FileAge(LocalDir + '\' + AFileListServer.Strings[I])then
            AFileListResult.Add(AFileListServer.Strings[I]);
          AFileListLocal.Delete(J);
          Break;
        end;
      if IsNewFile then
        AFileListResult.Add(AFileListServer.Strings[I]);
    end;

    // proceed the list copy all with the replace
    if AFileListResult.Count > 0 then
      for I := 0 to AFileListResult.Count - 1 do
      begin
        try
          // copying with the replace
          DataModuleBase.WriteToLog('Update file: ' + LocalDir + '\' +
            AFileListResult.Strings[I], True);
          if not CopyFile(PChar(ServerDir + '\' + AFileListResult.Strings[I]),
            Pchar(LocalDir + '\' + AFileListResult.Strings[I]), False)then
          begin
            FUpdatewithError := True;
            DataModuleBase.WriteToLog('Fail the update of file: ' + LocalDir +
              '\' + AFileListResult.Strings[I], True);
          end;

        except
          on E: Exception do
          begin
            DataModuleBase.WriteToLog('Error in DoUpdate procedure: ' +
              E.Message, True);
            FUpdatewithError := True;
          end;
        end;

      end;

  finally
    AFileListLocal.Free;
    AFileListServer.Free;
    AFileListResult.Free;
  end;
end;

procedure TMainForm.SendLogin(PMitarbeiterID: Integer);
var
  DwRecipient: DWord;
  WMsgValue: WPARAM;
begin
  WMsgValue := PMitarbeiterID;
  DwRecipient := BSM_APPLICATIONS;
  BroadCastSystemMessage(BSF_POSTMESSAGE,@DwRecipient, VLogIn, WMsgVAlue, 0);
end;

procedure TMainForm.SendLogOut(Sender: TObject);
var
  DwRecipient: DWord;
  WMsgValue: WPARAM;
begin
  // SendLogout to Application, wenn nicht von jemand anderen kommt
  WMsgValue := 0;
  DwRecipient := BSM_APPLICATIONS;
  BroadCastSystemMessage(BSF_POSTMESSAGE,@DwRecipient, VLogout, WMsgVAlue, 0);
end;

procedure TMainform.FormDestroy(Sender: TObject);
begin
  if TrayIconAdded then
    Shell_NotifyIcon(NIM_DELETE,@TrayIconData);
  DeallocateHWnd(TrayWnd);
end;

procedure TMainform.TrayWndProc(var Message: TMessage);
begin
  if message.Msg = WM_ACTIVATEAPP then
  // Message.Msg = 28 the action of clossing balloon message
  begin
    FNeedShowBalloon := False;
    if(message.WParam = 0)then
      FormChromium.Hide;
  end
  else
    message.Result := DefWindowProc(TrayWnd, message.Msg, message.WParam,
      message.LParam);
end;

procedure TMainform.WebBrowserLoadEnd(Sender: TObject;
  const Browser: ICefBrowser;const Frame: ICefFrame; HttpStatusCode: Integer);
var
  Ajscript:string;
begin
  Ajscript := 'document.documentElement.style.overflowX = ''hidden'';';
  Browser.MainFrame.ExecuteJavaScript(Ajscript, 'about:blank', 0);
  // here we save the atempts
  Ajscript := 'var attempts = 0;';
  Browser.MainFrame.ExecuteJavaScript(Ajscript, 'about:blank', 0);
  // the make new line doesn't work, so use javascript to make it
  Ajscript := '$("#setting_announcement_message").keyup(function(e) { ' +
    ' if(e.which == 13) ' +
    ' { ' +
    '   var txt = $("#setting_announcement_message").val(); ' +
    '   $("#setting_announcement_message").val(txt + ''\n''); ' +
    ' } ' +
    '});';
  Browser.MainFrame.ExecuteJavaScript(Ajscript, 'about:blank', 0);
  // this is the javascript for backspase arrow keys and Ctrl+v it prevent triple execute
  // lock triple execute in comboboxs
  Ajscript := '$(document).keydown(function(e) { ' +
    ' if ((e.which == 8) || ((e.which >= 37) && (e.which <= 40)) || (e.which == 86) ) '
    +
    ' { ' +
    '   if(attempts < 2) { ' +
    '     attempts = attempts + 1;   ' +
    '     e.preventDefault(); ' +
    ' } else attempts = 0; }  ' +
    '});';
  Browser.MainFrame.ExecuteJavaScript(Ajscript, 'about:blank', 0);

  AniIndicatorLoading.Enabled := False;
end;

procedure TMainform.FormGesture(Sender: TObject;
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

procedure TMainform.ShowToolbar(AShow: Boolean);
begin
  ToolbarPopup.Width := ClientWidth;
  ToolbarPopup.PlacementRectangle.Rect :=
    TRectF.Create(0, ClientHeight - ToolbarPopup.Height, ClientWidth - 1,
    ClientHeight - 1);
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
