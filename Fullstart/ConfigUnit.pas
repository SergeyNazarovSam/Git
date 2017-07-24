unit ConfigUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts, FMX.Gestures,
  FMX.StdCtrls, FMX.Controls.Presentation, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  System.Rtti, FMX.Grid, FMX.TabControl, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.ScrollBox, FMX.Memo, FMX.ListBox, FMX.Edit, System.IniFiles,  mmsystem,
  FMX.Menus;

type
  TConfigForm = class(TForm)
    StyleBook1: TStyleBook;
    ToolbarHolder: TLayout;
    ToolbarPopup: TPopup;
    ToolbarPopupAnimation: TFloatAnimation;
    ToolBar1: TToolBar;
    ToolbarApplyButton: TButton;
    ToolbarCloseButton: TButton;
    ToolbarAddButton: TButton;
    Query_ApplicationList: TFDQuery;
    Query_RoleList: TFDQuery;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    StringGrid_ApplicationList: TStringGrid;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    StringColumn3: TStringColumn;
    StringColumn4: TStringColumn;
    StringColumn5: TStringColumn;
    StringColumn6: TStringColumn;
    StringColumn7: TStringColumn;
    ImageControl_Blob: TImageControl;
    Button_Add: TButton;
    Button_Delete: TButton;
    Button_setup_location: TButton;
    OpenDialog_Location: TOpenDialog;
    StringGrid_RoleList: TStringGrid;
    StringColumn8: TStringColumn;
    StringColumn9: TStringColumn;
    StringColumn10: TStringColumn;
    StringColumn11: TStringColumn;
    StringColumn12: TStringColumn;
    StringColumn13: TStringColumn;
    StringColumn14: TStringColumn;
    ComboBox_UserRole: TComboBox;
    ComboBox_Applications: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Button_AddForRole: TButton;
    Button_DeleteforRole: TButton;
    TabItem3: TTabItem;
    Label3: TLabel;
    Edit_TileSize: TEdit;
    Label4: TLabel;
    Edit_MainLogo: TEdit;
    Label5: TLabel;
    Edit_ClientLogo: TEdit;
    Label6: TLabel;
    Edit_Sound: TEdit;
    Button_LocationMainLogo: TButton;
    Button_LocationClientLogo: TButton;
    Button_LocationSound: TButton;
    Button_AcceptSettings: TButton;
    ImageControl_MainLogo: TImageControl;
    ImageControl_ClientLogo: TImageControl;
    Button_TestSound: TButton;
    PopupMenu_YesNo: TPopupMenu;
    MenuItem_Yes: TMenuItem;
    MenuItem_No: TMenuItem;
    StringColumn15: TStringColumn;
    StringColumn16: TStringColumn;
    StringColumn17: TStringColumn;
    StringColumn18: TStringColumn;
    Button_AddAllForRole: TButton;
    Button_DeleteAllForRole: TButton;
    CheckBox_autocomplite: TCheckBox;
    procedure ToolbarCloseButtonClick(Sender: TObject);
    procedure FormGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure StringGrid_ApplicationListSelectCell(Sender: TObject; const ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure Button_AddClick(Sender: TObject);
    procedure Button_EditClick(Sender: TObject);
    procedure Button_DeleteClick(Sender: TObject);
    procedure Button_setup_locationClick(Sender: TObject);
    procedure Button_AddForRoleClick(Sender: TObject);
    procedure Button_DeleteforRoleClick(Sender: TObject);
    procedure StringGrid_RoleListSelectCell(Sender: TObject; const ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure FormShow(Sender: TObject);
    procedure Button_AcceptSettingsClick(Sender: TObject);
    procedure Button_LocationMainLogoClick(Sender: TObject);
    procedure Button_TestSoundClick(Sender: TObject);
    procedure TabItem2Click(Sender: TObject);
    procedure MenuItem_YesClick(Sender: TObject);
    procedure PopupMenu_YesNoPopup(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComboBox_UserRoleChange(Sender: TObject);
    procedure Button_AddAllForRoleClick(Sender: TObject);
    procedure Button_DeleteAllForRoleClick(Sender: TObject);
  private
    FGestureOrigin: TPointF;
    FGestureInProgress: Boolean;
    { Private declarations }
    procedure ShowToolbar(AShow: Boolean);
  public
    FCurRowApplicationList : integer;
    FCurColApplicationList : integer;
    FCurRowRoleList : integer;
    Procedure ShowApplicationList;
    Procedure ShowRoleList;
    Procedure FillCombos;
    Procedure ShowOptions;
    Procedure AddProgram_to_Role( RoleId,ProgId : integer);
    { Public declarations }
  end;

const co_EasyLogin = 1; // 01   // Constants for bit map
      co_KeyLogin  = 2; // 10

var
  ConfigForm: TConfigForm;

implementation

uses DMBase, UnitMain;

{$R *.fmx}

procedure TConfigForm.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkEscape then
    ShowToolbar(not ToolbarPopup.IsOpen);
end;

procedure TConfigForm.FormShow(Sender: TObject);
var aCanSelect : boolean;
begin
  ShowApplicationList;
  ShowOptions;
  StringGrid_ApplicationListSelectCell(sender,0,0,aCanSelect);
end;

procedure TConfigForm.MenuItem_YesClick(Sender: TObject);
begin
  if FCurColApplicationList in [4,5,7,8] then
    StringGrid_ApplicationList.Cells[FCurColApplicationList,FCurRowApplicationList] := (sender as TMenuItem).Text;
  if FCurColApplicationList = 5 then
    if (sender as TMenuItem).Text = 'No' then
      ImageControl_Blob.Bitmap.Assign(nil)
    else
      ImageControl_Blob.ShowOpenDialog;
end;

procedure TConfigForm.PopupMenu_YesNoPopup(Sender: TObject);
begin
  if FCurColApplicationList in [4,5,7,8] then
  begin
    PopupMenu_YesNo.Items[0].Visible := true;
    PopupMenu_YesNo.Items[1].Visible := true;
  end
  else
  begin
    PopupMenu_YesNo.Items[0].Visible := false;
    PopupMenu_YesNo.Items[1].Visible := false;
  end;
end;

Procedure TConfigForm.ShowApplicationList;
var i : integer;
begin
  self.Query_ApplicationList.Close;
  self.Query_ApplicationList.Open();
  self.Query_ApplicationList.First;

  // Filling the stringGrid
  self.StringGrid_ApplicationList.BeginUpdate;
  self.StringGrid_ApplicationList.RowCount := self.Query_ApplicationList.RecordCount+1;
  while not self.Query_ApplicationList.Eof do
  begin
    for i := 0 to self.Query_ApplicationList.FieldCount-1 do
    begin
      if not self.Query_ApplicationList.Fields[i].IsBlob then
        self.StringGrid_ApplicationList.Cells[i, self.Query_ApplicationList.RecNo-1]:= self.Query_ApplicationList.Fields[i].AsString
      else
        if self.Query_ApplicationList.Fields[i].IsNull then
          self.StringGrid_ApplicationList.Cells[i, self.Query_ApplicationList.RecNo-1] := 'No'
        else
          self.StringGrid_ApplicationList.Cells[i, self.Query_ApplicationList.RecNo-1] := 'Yes';
      // RunceOne
      if i = 4 then
        if self.Query_ApplicationList.Fields[i].AsString = '0' then
          self.StringGrid_ApplicationList.Cells[i, self.Query_ApplicationList.RecNo-1] := 'No'
        else
          self.StringGrid_ApplicationList.Cells[i, self.Query_ApplicationList.RecNo-1] := 'Yes';
      // EasyLogin and KeyLogin
      if i = 7 then
      begin
        // EasyLogin filling
        if (self.Query_ApplicationList.Fields[i].AsInteger and co_EasyLogin) = co_EasyLogin  then
          self.StringGrid_ApplicationList.Cells[i, self.Query_ApplicationList.RecNo-1] := 'Yes'
        else
          self.StringGrid_ApplicationList.Cells[i, self.Query_ApplicationList.RecNo-1] := 'No';
        // Keylogin Filling
        if (self.Query_ApplicationList.Fields[i].AsInteger and co_KeyLogin) = co_KeyLogin  then
          self.StringGrid_ApplicationList.Cells[i+1, self.Query_ApplicationList.RecNo-1] := 'Yes'
        else
          self.StringGrid_ApplicationList.Cells[i+1, self.Query_ApplicationList.RecNo-1] := 'No';
      end;

    end;
    self.Query_ApplicationList.Next;
  end;
  for i := 0 to self.Query_ApplicationList.FieldCount-1 do
    self.StringGrid_ApplicationList.Cells[i, self.StringGrid_ApplicationList.RowCount-1] := '';
  StringGrid_ApplicationList.EndUpdate;
  StringGrid_ApplicationList.Repaint;
end;

Procedure TConfigForm.ShowRoleList;
var i: integer;
begin
  self.Query_RoleList.Close;
  self.Query_RoleList.Params.ParamByName('ID').Value := self.ComboBox_UserRole.ListItems[self.ComboBox_UserRole.ItemIndex].Tag;
  self.Query_RoleList.Open();
  self.Query_RoleList.First;
  // Filling the stringGrid
  self.StringGrid_RoleList.BeginUpdate;
  self.StringGrid_RoleList.RowCount := self.Query_RoleList.RecordCount;
  while not self.Query_RoleList.Eof do
  begin
    for i := 0 to self.Query_RoleList.FieldCount-1 do
    begin
      if not self.Query_RoleList.Fields[i].IsBlob then
        self.StringGrid_RoleList.Cells[i, self.Query_RoleList.RecNo-1]:= self.Query_RoleList.Fields[i].AsString
      else
        if self.Query_RoleList.Fields[i].IsNull then
          self.StringGrid_RoleList.Cells[i, self.Query_RoleList.RecNo-1] := 'No'
        else
          self.StringGrid_RoleList.Cells[i, self.Query_RoleList.RecNo-1] := 'Yes';
      if i = 4 then
        if self.Query_RoleList.Fields[i].AsString = '0' then
          self.StringGrid_RoleList.Cells[i, self.Query_RoleList.RecNo-1] := 'No'
        else
          self.StringGrid_RoleList.Cells[i, self.Query_RoleList.RecNo-1] := 'Yes';
      if i = 7 then
      begin
        // EasyLogin filling
        if (self.Query_RoleList.Fields[i].AsInteger and co_EasyLogin) = co_EasyLogin  then
          self.StringGrid_RoleList.Cells[i, self.Query_RoleList.RecNo-1] := 'Yes'
        else
          self.StringGrid_RoleList.Cells[i, self.Query_RoleList.RecNo-1] := 'No';
        // Keylogin Filling
        if (self.Query_RoleList.Fields[i].AsInteger and co_KeyLogin) = co_KeyLogin  then
          self.StringGrid_RoleList.Cells[i+1, self.Query_RoleList.RecNo-1] := 'Yes'
        else
          self.StringGrid_RoleList.Cells[i+1, self.Query_RoleList.RecNo-1] := 'No';
      end;

    end;
    self.Query_RoleList.Next;
  end;
  StringGrid_RoleList.EndUpdate;
end;


Procedure TConfigForm.FillCombos;
var aqCombo : TFDQuery;
    i : integer;
begin
  // Filling combos
  aqCombo := TFDQuery.Create(self);
  aqCombo.Connection := DBase.IB_ConnectionFelix;
  aqCombo.SQL.Add('Select * from User_Roles');
  aqCombo.Open();
  aqCombo.First;
  i := 0;
  self.ComboBox_UserRole.Clear;
  while not aqCombo.Eof do
  begin
    self.ComboBox_UserRole.Items.Add(aqCombo.FieldByName('Name').AsString);
    self.ComboBox_UserRole.ListItems[i].Tag := aqCombo.FieldByName('ID').AsInteger;
    i := i + 1;
    aqCombo.Next;
  end;
  aqCombo.Close;
  aqCombo.SQL.Clear;
  aqCombo.SQL.Add('Select * from User_Programs');
  aqCombo.Open();
  aqCombo.First;
  i := 0;
  self.ComboBox_Applications.Clear;
  while not aqCombo.Eof do
  begin
    self.ComboBox_Applications.Items.Add(aqCombo.FieldByName('Name').AsString);
    self.ComboBox_Applications.ListItems[i].Tag := aqCombo.FieldByName('ID').AsInteger;
    i := i + 1;
    aqCombo.Next;
  end;
  aqCombo.Close;
  aqCombo.Free;
  self.ComboBox_UserRole.ItemIndex := 0;
  self.ComboBox_Applications.ItemIndex := 0;
end;

Procedure TConfigForm.ShowOptions;
var aIni:TIniFile;
begin
  aIni := TIniFile.Create(ExtractFileDir(ParamStr(0))+'\felixmain.ini');
  MainForm.FTileSideSize := StrToInt(aIni.ReadString('Common', 'TileSideSize', '300'));
  MainForm.FLogoImgPath := aIni.ReadString('Common', 'LogoImgPath', Extractfilepath(ParamStr(0))+'img\gms-info.png');
  MainForm.FClientImgPath := aIni.ReadString('Common', 'ClientImgPath', Extractfilepath(ParamStr(0))+'img\gms-info.png');
  MainForm.FSoundPath := aIni.ReadString('Common', 'SoundPath',Extractfilepath(ParamStr(0))+'snd\newmessage.wav');
  MainForm.FUseAutoComplete := strtobool(aIni.ReadString('Common', 'UseAutoComplete','false'));
  self.Edit_TileSize.Text := inttostr(MainForm.FTileSideSize);
  self.Edit_MainLogo.Text := MainForm.FLogoImgPath;
  self.Edit_ClientLogo.Text := MainForm.FClientImgPath;
  self.Edit_Sound.Text := MainForm.FSoundPath;
  self.CheckBox_autocomplite.IsChecked := MainForm.FUseAutocomplete;
  if FileExists(MainForm.FLogoImgPath) then
    self.ImageControl_MainLogo.LoadFromFile(MainForm.FLogoImgPath);
  if FileExists(MainForm.FClientImgPath) then
    self.ImageControl_ClientLogo.LoadFromFile(MainForm.FClientImgPath);
  aIni.Free;
end;

procedure TConfigForm.TabItem2Click(Sender: TObject);
begin
  FillCombos;
  ShowRoleList;
end;

procedure TConfigForm.ToolbarCloseButtonClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TConfigForm.Button_AcceptSettingsClick(Sender: TObject);
var aIni:TIniFile;
begin
  MainForm.FTileSideSize := strtoint(self.Edit_TileSize.Text);
  MainForm.FLogoImgPath := self.Edit_MainLogo.Text;
  MainForm.FClientImgPath := self.Edit_ClientLogo.Text;
  MainForm.FSoundPath := self.Edit_Sound.Text;
  MainForm.FUseAutocomplete := Self.CheckBox_autocomplite.IsChecked;
  aIni := TIniFile.Create(ExtractFileDir(ParamStr(0))+'\felixmain.ini');
  aIni.WriteString('Common', 'TileSideSize', inttostr(MainForm.FTileSideSize));
  aIni.WriteString('Common', 'LogoImgPath', MainForm.FLogoImgPath);
  aIni.WriteString('Common', 'ClientImgPath', MainForm.FClientImgPath);
  aIni.WriteString('Common', 'SoundPath', MainForm.FSoundPath);
  aIni.WriteString('Common', 'UseAutocomplete', booltostr(MainForm.FUseAutocomplete,true));
  aIni.Free;
end;

procedure TConfigForm.Button_AddAllForRoleClick(Sender: TObject);
var aRole_Id, aProg_ID, i : integer;
begin
  aRole_ID := self.ComboBox_UserRole.ListItems[self.ComboBox_UserRole.ItemIndex].Tag;
  for I := 0 to ComboBox_Applications.Items.Count - 1 do
  begin
    aProg_ID := self.ComboBox_Applications.ListItems[i].Tag;
    AddProgram_to_Role(aRole_ID, aProg_ID);
  end;
  ShowRoleList;
end;

procedure TConfigForm.Button_AddClick(Sender: TObject);
 var aMaxID, aLastRow, i, j : integer;
     aqDml : TFDQuery;
begin
  aLastRow := self.StringGrid_ApplicationList.RowCount - 1;
  aqDml := TFDQuery.Create(self);
  aqDml.Connection := DBase.IB_ConnectionFelix;
  aqDml.SQL.Add('Insert into User_Programs (ID, Name, Path, Params, Runceone, ICON, Name_Short, Login_Type)');
  aqDml.SQL.Add('Values (:1, :2, :3, :4, :5, :6, :7, :8)');
  for i := 1 to 8 do
  begin
    if i = 1 then
      if Length(self.StringGrid_ApplicationList.Cells[i-1,aLastRow]) > 0 then
        aqDml.Params.ParamByName(inttostr(i)).Value := strtoint(self.StringGrid_ApplicationList.Cells[i-1,aLastRow])
      else
      begin
        aMaxID := 0;
        // find the max id if id does not set
        for j := 0 to aLastRow-1 do
          if aMaxID < strtoint(self.StringGrid_ApplicationList.Cells[0,j]) then
            aMaxID := strtoint(self.StringGrid_ApplicationList.Cells[0,j]);
        aqDml.Params.ParamByName(inttostr(i)).Value := aMaxID + 1;
      end
    else
      if i = 6 then  // Blob
        if not self.ImageControl_Blob.Bitmap.IsEmpty then
          aqDml.Params.ParamByName(inttostr(i)).Assign(TBlobField(self.ImageControl_Blob.Bitmap))
        else
          aqDml.Params.ParamByName(inttostr(i)).Value := null
      else
        if i = 5 then  // RunceOne
          if self.StringGrid_ApplicationList.Cells[i-1,aLastRow] = 'Yes' then
            aqDml.Params.ParamByName(inttostr(i)).Value := '1'
          else
            aqDml.Params.ParamByName(inttostr(i)).Value := '0'
        else
          if i = 8 then  // EasyLogin + KeyLogin
          begin
            aqDml.Params.ParamByName(inttostr(i)).Value := 0;
            if self.StringGrid_ApplicationList.Cells[i-1,aLastRow] = 'Yes' then
              aqDml.Params.ParamByName(inttostr(i)).Value := aqDml.Params.ParamByName(inttostr(i)).Value or co_EasyLogin;
            if self.StringGrid_ApplicationList.Cells[i,aLastRow] = 'Yes' then
              aqDml.Params.ParamByName(inttostr(i)).Value := aqDml.Params.ParamByName(inttostr(i)).Value or co_KeyLogin;
          end
          else
            aqDml.Params.ParamByName(inttostr(i)).Value := self.StringGrid_ApplicationList.Cells[i-1,aLastRow];
  end;
  aqDml.ExecSQL;
  aqDml.Free;
  ShowApplicationList;
end;

procedure TConfigForm.AddProgram_to_Role(RoleId: Integer; ProgId: Integer);
var aMaxID : integer;
     aqDml : TFDQuery;
begin
  aqDml := TFDQuery.Create(self);
  aqDml.Connection := DBase.IB_ConnectionFelix;
  aqDml.SQL.Add('Select Max(ID) as MaxID from User_role_Programs');
  aqDml.Open();
  if aqDml.FieldByName('MaxID').IsNull then
    aMaxID := 1
  else
    aMaxID := aqDml.FieldByName('MaxID').AsInteger+1;

  aqDml.Close;
  aqDml.SQL.Clear;
  aqDml.SQL.Add('Insert into User_Role_Programs (ID, USER_PROGRAM_ID, USER_ROLE_ID)');
  aqDml.SQL.Add('Values ('+inttostr(aMaxID)+', '+inttostr(ProgID)+','+inttostr(RoleID)+')');
  aqDml.ExecSQL;
  aqDml.Free;
end;


procedure TConfigForm.Button_AddForRoleClick(Sender: TObject);
var aRole_Id, aProg_ID : integer;
begin
  aProg_ID := self.ComboBox_Applications.ListItems[self.ComboBox_Applications.ItemIndex].Tag;
  aRole_ID := self.ComboBox_UserRole.ListItems[self.ComboBox_UserRole.ItemIndex].Tag;
  AddProgram_to_Role(aRole_ID, aProg_ID);
  ShowRoleList;
end;

procedure TConfigForm.Button_DeleteAllForRoleClick(Sender: TObject);
var aCurRow : integer;
    aqDml : TFDQuery;
begin
  aCurRow := FCurRowRoleList;
  aqDml := TFDQuery.Create(self);
  aqDml.Connection := DBase.IB_ConnectionFelix;
  aqDml.SQL.Add('Delete from User_Role_Programs u');
  aqDml.SQL.Add('Where u.User_Role_Id = :2');
  aqDml.Params.ParamByName('2').Value := self.ComboBox_UserRole.ListItems[self.ComboBox_UserRole.ItemIndex].Tag;
  aqDml.ExecSQL;
  aqDml.Free;
  ShowRoleList;
end;

procedure TConfigForm.Button_DeleteClick(Sender: TObject);
var aCurRow : integer;
    aqDml : TFDQuery;
begin
  aCurRow := FCurRowApplicationList;
  aqDml := TFDQuery.Create(self);
  aqDml.Connection := DBase.IB_ConnectionFelix;
  aqDml.SQL.Add('Delete from User_Programs');
  aqDml.SQL.Add('Where ID = :1');
  aqDml.Params.ParamByName('1').Value := strtoint(self.StringGrid_ApplicationList.Cells[0,aCurRow]);
  aqDml.ExecSQL;
  aqDml.Free;
  ShowApplicationList;
end;

procedure TConfigForm.Button_DeleteforRoleClick(Sender: TObject);
var aCurRow : integer;
    aqDml : TFDQuery;
begin
  aCurRow := FCurRowRoleList;
  aqDml := TFDQuery.Create(self);
  aqDml.Connection := DBase.IB_ConnectionFelix;
  aqDml.SQL.Add('Delete from User_Role_Programs u');
  aqDml.SQL.Add('Where u.User_Program_ID = :1 and u.User_Role_Id = :2');
  aqDml.Params.ParamByName('1').Value := strtoint(self.StringGrid_RoleList.Cells[0,aCurRow]);
  aqDml.Params.ParamByName('2').Value := self.ComboBox_UserRole.ListItems[self.ComboBox_UserRole.ItemIndex].Tag;
  aqDml.ExecSQL;
  aqDml.Free;
  ShowRoleList;
end;

procedure TConfigForm.Button_EditClick(Sender: TObject);
var aCurRow, i : integer;
     aqDml : TFDQuery;
begin
  aCurRow := FCurRowApplicationList;
  aqDml := TFDQuery.Create(self);
  aqDml.Connection := DBase.IB_ConnectionFelix;
  aqDml.SQL.Add('Update USER_PROGRAMS');
  aqDml.SQL.Add('SET Name = :2, Path = :3, Params = :4, Runceone = :5, ICON = :6, Name_Short = :7, Login_Type = :8');
  aqDml.SQL.Add('Where ID = :1');
  for I := 1 to 8 do
  begin
    if i = 1 then
      aqDml.Params.ParamByName(inttostr(i)).Value := strtoint(self.StringGrid_ApplicationList.Cells[i-1,aCurRow])
    else
      if i = 6 then
        if not self.ImageControl_Blob.Bitmap.IsEmpty then
          aqDml.Params.ParamByName(inttostr(i)).Assign(TBlobField(self.ImageControl_Blob.Bitmap))
        else
          aqDml.Params.ParamByName(inttostr(i)).Value := null
      else
        if i = 5 then
          if StringGrid_ApplicationList.Cells[i-1,aCurRow] = 'Yes' then
            aqDml.Params.ParamByName(inttostr(i)).Value := '1'
          else
            aqDml.Params.ParamByName(inttostr(i)).Value := '0'
        else
          if i = 8 then  // EasyLogin + KeyLogin
          begin
            aqDml.Params.ParamByName(inttostr(i)).Value := 0;
            if self.StringGrid_ApplicationList.Cells[i-1,aCurRow] = 'Yes' then
              aqDml.Params.ParamByName(inttostr(i)).Value := aqDml.Params.ParamByName(inttostr(i)).Value or co_EasyLogin;
            if self.StringGrid_ApplicationList.Cells[i,aCurRow] = 'Yes' then
              aqDml.Params.ParamByName(inttostr(i)).Value := aqDml.Params.ParamByName(inttostr(i)).Value or co_KeyLogin;
          end
          else
            aqDml.Params.ParamByName(inttostr(i)).Value := self.StringGrid_ApplicationList.Cells[i-1,aCurRow];
  end;
  aqDml.ExecSQL;
  aqDml.Free;
  ShowApplicationList;
end;

procedure TConfigForm.Button_LocationMainLogoClick(Sender: TObject);
var aEdit : TEdit;
    aImageControl : TImageControl;
begin
  case (sender as TButton).Tag of
  1: Begin aEdit := self.Edit_MainLogo;   aImageControl := self.ImageControl_MainLogo;   end;
  2: Begin aEdit := self.Edit_ClientLogo; aImageControl := self.ImageControl_ClientLogo; end;
  3: Begin aEdit := self.Edit_Sound;      aImageControl := nil;                          end;
  end;

  if Length(aEdit.Text) > 0  then
  begin
    // if theris no absolute path make it
    if Length(trim(ExtractFileDrive(aEdit.Text))) > 0 then
      self.OpenDialog_Location.InitialDir := ExtractFilePath(aEdit.Text)
    else
      self.OpenDialog_Location.InitialDir := ExtractFilePath(ParamStr(0)) + ExtractFilePath(aEdit.Text);
  end
  else
    self.OpenDialog_Location.InitialDir := ExtractFilePath(ParamStr(0));

  if self.OpenDialog_Location.Execute then
  begin
    aEdit.Text := self.OpenDialog_Location.FileName;
    if aImageControl <> nil then
      aImageControl.LoadFromFile(aEdit.Text);
  end;
end;

procedure TConfigForm.Button_setup_locationClick(Sender: TObject);
begin
  if Length(self.StringGrid_ApplicationList.Cells[2,FCurRowApplicationList]) > 0  then
    self.OpenDialog_Location.InitialDir := ExtractFilePath(self.StringGrid_ApplicationList.Cells[2,FCurRowApplicationList])
  else
    self.OpenDialog_Location.InitialDir := ExtractFilePath(ParamStr(0));
  if self.OpenDialog_Location.Execute then
    self.StringGrid_ApplicationList.Cells[2,FCurRowApplicationList] := self.OpenDialog_Location.FileName;
end;

procedure TConfigForm.Button_TestSoundClick(Sender: TObject);
begin
  if FileExists(self.Edit_Sound.Text) then
    sndPlaySound(PChar(self.Edit_Sound.Text), SND_ASYNC);
end;

procedure TConfigForm.ComboBox_UserRoleChange(Sender: TObject);
begin
  ShowRoleList;
end;

procedure TConfigForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if StringGrid_ApplicationList.RowCount > FCurRowApplicationList+1 then
    self.Button_EditClick(sender);
end;

procedure TConfigForm.FormGesture(Sender: TObject;
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

procedure TConfigForm.ShowToolbar(AShow: Boolean);
begin
  ToolbarPopup.Width := ClientWidth;
  ToolbarPopup.PlacementRectangle.Rect := TRectF.Create(0, ClientHeight-ToolbarPopup.Height, ClientWidth-1, ClientHeight-1);
  ToolbarPopupAnimation.StartValue := ToolbarPopup.Height;
  ToolbarPopupAnimation.StopValue := 0;

  ToolbarPopup.IsOpen := AShow;
end;

procedure TConfigForm.StringGrid_ApplicationListSelectCell(Sender: TObject;
  const ACol, ARow: Integer; var CanSelect: Boolean);
begin
  if ARow > self.StringGrid_ApplicationList.RowCount  then exit;
  if (FCurRowApplicationList <> ARow) and (self.StringGrid_ApplicationList.RowCount > FCurRowApplicationList+1) then
    self.Button_EditClick(sender);
  FCurRowApplicationList := ARow;
  FCurColApplicationList := ACol;
  if self.StringGrid_ApplicationList.RowCount > ARow+1 then
  begin
    self.Query_ApplicationList.Locate('ID',strtoint(StringGrid_ApplicationList.Cells[0,ARow]),[]);
    if self.Query_ApplicationList.fieldbyname('ICON').IsNull then
      self.ImageControl_Blob.Bitmap.Assign(nil)
    else
      self.ImageControl_Blob.Bitmap.Assign(TBLOBField(self.Query_ApplicationList.fieldbyname('ICON')));
  end;

end;

procedure TConfigForm.StringGrid_RoleListSelectCell(Sender: TObject; const ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if ARow > self.StringGrid_RoleList.RowCount  then exit;
  FCurRowRoleList := ARow;
end;

end.
