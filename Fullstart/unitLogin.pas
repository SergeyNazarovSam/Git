unit unitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Objects, FMX.Controls.Presentation, FMX.ComboEdit,
  FMX.TMSCustomEdit, FMX.TMSEdit, FMX.Layouts, FMX.ListBox;

type
  TfmLogin = class(TForm)
    Rectangle_login: TRectangle;
    Rectangle_passwort: TRectangle;
    Text_passwort: TText;
    Edit_passwort: TEdit;
    Rectangle_username: TRectangle;
    Text_username: TText;
    Rectangle_button: TRectangle;
    Button_login: TButton;
    Button_cancel: TButton;
    edit_username: TTMSFMXEdit;
    ImageControl_logo: TImageControl;
    Rectangle_FormCaptions: TRectangle;
    Text_FormCaption: TText;
    Button_Loginclose: TButton;
    ListBox_Login: TListBox;
    procedure Button_cancelClick(Sender: TObject);
    procedure Button_loginClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit_passwortKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure Edit_usernameKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure edit_usernameKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Edit_passwortKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure Button_loginKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure Button_cancelKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure edit_usernameTyping(Sender: TObject);
    procedure ListBox_LoginClick(Sender: TObject);
    procedure ListBox_LoginKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
  private
    { Private-Deklarationen }
    procedure ShowUserNameList(UsernamePart:String);
  public
    FABBRUCH : BOOLEAN;
    { Public-Deklarationen }
  end;

var
  fmLogin: TfmLogin;

implementation
uses unitmain,hsapi;

{$R *.fmx}

procedure TfmLogin.ShowUserNameList(UsernamePart:String);
var aUsernameList, aUsernameLokup : TStringList;
    i : integer;
begin
  aUserNameList := TStringList.Create;
  aUsernameList.Clear;
  for i := 0 to Edit_username.Lookup.DisplayList.Count-1  do
    if UsernamePart = copy(Edit_username.Lookup.DisplayList.Strings[i] ,1,length(UsernamePart)) then
       aUsernameList.Add(Edit_username.Lookup.DisplayList.Strings[i]);
  ListBox_Login.Items := aUserNameList;
  if ListBox_Login.Items.Count > 0 then
  begin
    ListBox_Login.Height := ListBox_Login.Items.Count * 20+5;
    ListBox_Login.ItemIndex := 0;
    ListBox_Login.Visible := true;
  end
  else
    ListBox_Login.Visible := false;

  aUsernameList.Free;
end;

procedure TfmLogin.Button_cancelClick(Sender: TObject);
begin
  FABBRUCH := true;
  close;
end;

procedure TfmLogin.Button_cancelKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (key = 9) and (ssShift in Shift) then
    Button_Login.SetFocus
  else
    if key = 9 then
      Edit_username.SetFocus;
end;

procedure TfmLogin.Button_loginClick(Sender: TObject);
begin
  if hotelserverapi.Token = '' then
  begin
    hotelserverapi.Username := Edit_username.Text;
    hotelserverapi.Password := Edit_passwort.Text;
  end;
  MainForm.FNeedSendLogin := true;
  FABBRUCH := false;
  self.CloseModal;
end;

procedure TfmLogin.Button_loginKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (key = 9) and (ssShift in Shift) then
    Edit_passwort.SetFocus
  else
    if key = 9 then
      Button_cancel.SetFocus;
end;

procedure TfmLogin.Edit_passwortKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = 13 then
  begin
    self.ModalResult := mrOk;
    Button_loginclick(Sender);
  end;
end;

procedure TfmLogin.Edit_passwortKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (key = 9) and (ssShift in Shift) then
    Edit_username.SetFocus
  else
    if key = 9 then
      Button_Login.SetFocus;
end;

procedure TfmLogin.Edit_usernameKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = 13) then
  begin
    Edit_passwort.SetFocus;
  end;
end;

procedure TfmLogin.edit_usernameKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (key = 9) and (ssShift in Shift) then
    Button_cancel.SetFocus
  else
    if (Key = 9) then
      Edit_passwort.SetFocus;

  if key = 40 then  // Down arrow
  begin
    ListBox_Login.SetFocus;
  end;
end;

procedure TfmLogin.edit_usernameTyping(Sender: TObject);
begin
  if MainForm.FUseAutocomplete then
    ShowUserNameList(Edit_username.Text);
end;

procedure TfmLogin.FormCreate(Sender: TObject);
begin
  if FileExists(Extractfilepath(ParamStr(0))+'UserList.txt') then
    edit_Username.Lookup.DisplayList.LoadFromFile(Extractfilepath(ParamStr(0))+'UserList.txt');
  ListBox_Login.Visible := false;
  edit_username.AutoComplete := MainForm.FUseAutoComplete;
end;

procedure TfmLogin.FormDestroy(Sender: TObject);
begin
  edit_Username.Lookup.DisplayList.SaveToFile(Extractfilepath(ParamStr(0))+'UserList.txt');
end;

procedure TfmLogin.FormShow(Sender: TObject);
begin
  edit_username.Text := '';
  Edit_passwort.Text := '';
  Edit_username.SetFocus;
end;

procedure TfmLogin.ListBox_LoginClick(Sender: TObject);
begin
  edit_username.Text := ListBox_Login.Items[ListBox_Login.ItemIndex];
  ListBox_Login.Visible := false;
  Edit_passwort.SetFocus;
end;

procedure TfmLogin.ListBox_LoginKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = 9) or (Key = 13) then
  begin
    ListBox_LoginClick(sender);
  end;
  if key = 27 then
  begin
    ListBox_Login.Visible := false;
    Edit_username.SetFocus;
  end;
end;

end.
