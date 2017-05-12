unit unitLogin;

// Embarcadero Delphi 10.1 Berlin
// This is Login unit which contain login diaolog form for authorization
// it also used for save the userlist

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Objects, FMX.Controls.Presentation, FMX.ComboEdit,
  FMX.TMSCustomEdit, FMX.TMSEdit, FMX.Layouts, FMX.ListBox;

type
  TfmLogin = class(TForm)
    Rectangle_login: TRectangle;
    RectanglePasswort: TRectangle;
    TextPasswort: TText;
    EditPasswort: TEdit;
    Rectangle_username: TRectangle;
    TextUserName: TText;
    RectangleButton: TRectangle;
    ButtonLogin: TButton;
    ButtonCancel: TButton;
    EditUserName: TTMSFMXEdit;
    ImageControlLogo: TImageControl;
    RectangleFormCaptions: TRectangle;
    TextFormCaption: TText;
    ButtonLoginClose: TButton;
    ListBoxLogin: TListBox;
    StyleBook: TStyleBook;
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonLoginClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EditPasswortKeyDown(Sender: TObject;var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure EditUserNameKeyDown(Sender: TObject;var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure EditUserNameKeyUp(Sender: TObject;var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EditPasswortKeyUp(Sender: TObject;var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure ButtonLoginKeyUp(Sender: TObject;var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure ButtonCancelKeyUp(Sender: TObject;var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure EditUserNameTyping(Sender: TObject);
    procedure ListBoxLoginClick(Sender: TObject);
    procedure ListBoxLoginKeyUp(Sender: TObject;var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
  private
    { Private-Deklarationen }
    procedure ShowUserNameList(UsernamePart:string);
  public
    FAbbrUch: BOOLEAN;
    { Public-Deklarationen }
  end;

var
  FmLogin: TfmLogin;

implementation

uses UnitMain, Hsapi;

{$R *.fmx}


procedure TfmLogin.ShowUserNameList(UsernamePart:string);
var
  AUsernameList, AUsernameLokup: TStringList;
  I: Integer;
begin
  AUserNameList := TStringList.Create;
  AUsernameList.Clear;
  for I := 0 to EditUserName.Lookup.DisplayList.Count - 1 do
    if UsernamePart = Copy(EditUserName.Lookup.DisplayList.Strings[I], 1,
      Length(UsernamePart))then
      AUsernameList.Add(EditUserName.Lookup.DisplayList.Strings[I]);
  ListBoxLogin.Items := AUserNameList;
  if ListBoxLogin.Items.Count > 0 then
  begin
    ListBoxLogin.Height := ListBoxLogin.Items.Count * 20 + 5;
    ListBoxLogin.ItemIndex := 0;
    ListBoxLogin.Visible := True;
  end
  else
    ListBoxLogin.Visible := False;

  AUsernameList.Free;
end;

procedure TfmLogin.ButtonCancelClick(Sender: TObject);
begin
  FAbbrUch := True;
  Close;
end;

procedure TfmLogin.ButtonCancelKeyUp(Sender: TObject;var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if(Key = 9)and(SsShift in Shift)then
    ButtonLogin.SetFocus
  else
    if Key = 9 then
      EditUserName.SetFocus;
end;

procedure TfmLogin.ButtonLoginClick(Sender: TObject);
begin
  if HotelServerApi.Token = '' then
  begin
    HotelServerApi.Username := EditUserName.Text;
    HotelServerApi.Password := EditPasswort.Text;
  end;
  MainForm.FNeedSendLogin := True;
  FAbbrUch := False;
  Self.CloseModal;
end;

procedure TfmLogin.ButtonLoginKeyUp(Sender: TObject;var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if(Key = 9)and(SsShift in Shift)then
    EditPasswort.SetFocus
  else
    if Key = 9 then
      ButtonCancel.SetFocus;
end;

procedure TfmLogin.EditPasswortKeyDown(Sender: TObject;var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = 13 then
  begin
    Self.ModalResult := MrOk;
    ButtonLoginClick(Sender);
  end;
end;

procedure TfmLogin.EditPasswortKeyUp(Sender: TObject;var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if(Key = 9)and(SsShift in Shift)then
    EditUserName.SetFocus
  else
    if Key = 9 then
      ButtonLogin.SetFocus;
end;

procedure TfmLogin.EditUserNameKeyDown(Sender: TObject;var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if(Key = 13)then
  begin
    EditPasswort.SetFocus;
  end;
end;

procedure TfmLogin.EditUserNameKeyUp(Sender: TObject;var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if(Key = 9)and(SsShift in Shift)then
    ButtonCancel.SetFocus
  else
    if(Key = 9)then
      EditPasswort.SetFocus;

  if Key = 40 then // Down arrow
  begin
    ListBoxLogin.SetFocus;
  end;
end;

procedure TfmLogin.EditUserNameTyping(Sender: TObject);
begin
  if MainForm.FUseAutocomplete then
    ShowUserNameList(EditUserName.Text);
end;

procedure TfmLogin.FormCreate(Sender: TObject);
begin
  if FileExists(Extractfilepath(ParamStr(0))+ 'UserList.txt')then
    EditUserName.Lookup.DisplayList.LoadFromFile(Extractfilepath(ParamStr(0))+
      'UserList.txt');
  ListBoxLogin.Visible := False;
  EditUserName.AutoComplete := MainForm.FUseAutoComplete;
end;

procedure TfmLogin.FormDestroy(Sender: TObject);
begin
  EditUserName.Lookup.DisplayList.SaveToFile(Extractfilepath(ParamStr(0))+
    'UserList.txt');
end;

procedure TfmLogin.FormShow(Sender: TObject);
begin
  EditUserName.Text := '';
  EditPasswort.Text := '';
  EditUserName.SetFocus;
end;

procedure TfmLogin.ListBoxLoginClick(Sender: TObject);
begin
  EditUserName.Text := ListBoxLogin.Items[ListBoxLogin.ItemIndex];
  ListBoxLogin.Visible := False;
  EditPasswort.SetFocus;
end;

procedure TfmLogin.ListBoxLoginKeyUp(Sender: TObject;var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if(Key = 9)or(Key = 13)then
  begin
    ListBoxLoginClick(Sender);
  end;
  if Key = 27 then
  begin
    ListBoxLogin.Visible := False;
    EditUserName.SetFocus;
  end;
end;

end.
