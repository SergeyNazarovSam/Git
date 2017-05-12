unit ConfigUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts,
  FMX.Gestures,
  FMX.StdCtrls, FMX.Controls.Presentation, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  System.Rtti, FMX.Grid, FMX.TabControl, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.ScrollBox, FMX.Memo, FMX.ListBox, FMX.Edit,
  System.IniFiles, Mmsystem,
  FMX.Menus, FMX.Grid.Style;

type
  TConfigForm = class(TForm)
    StyleBookConfig: TStyleBook;
    ToolbarHolder: TLayout;
    ToolbarPopup: TPopup;
    ToolbarPopupAnimation: TFloatAnimation;
    ToolBar1: TToolBar;
    ToolbarApplyButton: TButton;
    ToolbarCloseButton: TButton;
    ToolbarAddButton: TButton;
    FDQueryApplicationList: TFDQuery;
    FDQueryRoleList: TFDQuery;
    TabControlConfig: TTabControl;
    TabItemApplications: TTabItem;
    TabItemRoles: TTabItem;
    StringGridApplicationList: TStringGrid;
    StringColumnApplicationListID: TStringColumn;
    StringColumnApplicationListName: TStringColumn;
    StringColumnApplicationListPath: TStringColumn;
    StringColumnApplicationListParams: TStringColumn;
    StringColumnApplicationListRunceone: TStringColumn;
    StringColumnApplicationListIcon: TStringColumn;
    StringColumnApplicationListNameShort: TStringColumn;
    ImageControlBlob: TImageControl;
    ButtonAdd: TButton;
    ButtonDelete: TButton;
    ButtonSetupLocation: TButton;
    OpenDialogLocation: TOpenDialog;
    StringGridRoleList: TStringGrid;
    StringColumnRoleListID: TStringColumn;
    StringColumnRoleListName: TStringColumn;
    StringColumnRoleListPath: TStringColumn;
    StringColumnRoleListParams: TStringColumn;
    StringColumnRoleListRunceone: TStringColumn;
    StringColumnRoleListIcon: TStringColumn;
    StringColumnRoleListNameShort: TStringColumn;
    ComboBoxUserRole: TComboBox;
    ComboBoxApplications: TComboBox;
    LabelUserRole: TLabel;
    LabelApplications: TLabel;
    ButtonAddForRole: TButton;
    ButtonDeleteForRole: TButton;
    TabItemOptions: TTabItem;
    LabelTileSize: TLabel;
    EditTileSize: TEdit;
    LabelMainLogo: TLabel;
    EditMainLogo: TEdit;
    LabelClientLogo: TLabel;
    EditClientLogo: TEdit;
    LabelSound: TLabel;
    EditSound: TEdit;
    ButtonLocationMainLogo: TButton;
    ButtonLocationClientLogo: TButton;
    ButtonLocationSound: TButton;
    ButtonAcceptSettings: TButton;
    ImageControlMainLogo: TImageControl;
    ImageControlClientLogo: TImageControl;
    ButtonTestSound: TButton;
    PopupMenuYesNo: TPopupMenu;
    MenuItemYes: TMenuItem;
    MenuItemNo: TMenuItem;
    StringColumnApplicationListEasyLogin: TStringColumn;
    StringColumnApplicationListKeyLogin: TStringColumn;
    StringColumnRoleListEasyLogin: TStringColumn;
    StringColumnRoleListKeyLogin: TStringColumn;
    ButtonAddAllForRole: TButton;
    ButtonDeleteAllForRole: TButton;
    CheckBoxAutoComplete: TCheckBox;
    StringColumnApplicationListAutoUpdate: TStringColumn;
    StringColumnApplicationListDoAutoUpdate: TStringColumn;
    StringColumnApplicationListServerPath: TStringColumn;
    StringColumnApplicationListSubFolders: TStringColumn;
    StringColumnRoleListAutoUpdate: TStringColumn;
    StringColumnRoleListDoAutoUpdate: TStringColumn;
    StringColumnRoleListServerPath: TStringColumn;
    StringColumnRoleListSubFolders: TStringColumn;
    procedure ToolbarCloseButtonClick(Sender: TObject);
    procedure FormGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo;var Handled: Boolean);
    procedure FormKeyDown(Sender: TObject;var Key: Word;var KeyChar: Char;
      Shift: TShiftState);
    procedure StringGridApplicationListSelectCell(Sender: TObject;const ACol,
      ARow: Integer;var CanSelect: Boolean);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonEditClick(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);
    procedure ButtonSetupLocationClick(Sender: TObject);
    procedure ButtonAddForRoleClick(Sender: TObject);
    procedure ButtonDeleteForRoleClick(Sender: TObject);
    procedure StringGridRoleListSelectCell(Sender: TObject;const ACol,
      ARow: Integer;var CanSelect: Boolean);
    procedure FormShow(Sender: TObject);
    procedure ButtonAcceptSettingsClick(Sender: TObject);
    procedure ButtonLocationMainLogoClick(Sender: TObject);
    procedure ButtonTestSoundClick(Sender: TObject);
    procedure TabItemRolesClick(Sender: TObject);
    procedure MenuItemYesClick(Sender: TObject);
    procedure PopupMenuYesNoPopup(Sender: TObject);
    procedure FormClose(Sender: TObject;var Action: TCloseAction);
    procedure ComboBoxUserRoleChange(Sender: TObject);
    procedure ButtonAddAllForRoleClick(Sender: TObject);
    procedure ButtonDeleteAllForRoleClick(Sender: TObject);
  private
    FGestureInProgress: Boolean;
    FGestureOrigin: TPointF;
    { Private declarations }
    procedure ShowToolbar(AShow: Boolean);
  public
    FCurRowApplicationList: Integer;
    FCurColApplicationList: Integer;
    FCurRowRoleList: Integer;
    procedure ShowApplicationList;
    procedure ShowRoleList;
    procedure FillCombos;
    procedure ShowOptions;
    procedure AddProgram_to_Role(RoleId, ProgId: Integer);
    { Public declarations }
  end;

const
  CEasyLogin = 1; // 01   // Constants for bit map
  CKeyLogin = 2; // 10

var
  ConfigForm: TConfigForm;

implementation

uses
  DMBase, UnitMain;

{$R *.fmx}


procedure TConfigForm.FormKeyDown(Sender: TObject;var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = VkEscape then
    ShowToolbar(not ToolbarPopup.IsOpen);
end;

procedure TConfigForm.FormShow(Sender: TObject);
var
  ACanSelect: Boolean;
begin
  ShowApplicationList;
  ShowOptions;
  StringGridApplicationListSelectCell(Sender, 0, 0, ACanSelect);
end;

procedure TConfigForm.MenuItemYesClick(Sender: TObject);
begin
  if FCurColApplicationList in[4, 5, 7, 8, 9, 10] then
    StringGridApplicationList.Cells[FCurColApplicationList,
      FCurRowApplicationList]:=(Sender as TMenuItem).Text;
  if FCurColApplicationList = 5 then
    if(Sender as TMenuItem).Text = 'No' then
      ImageControlBlob.Bitmap.Assign(nil)
    else
      ImageControlBlob.ShowOpenDialog;
end;

procedure TConfigForm.PopupMenuYesNoPopup(Sender: TObject);
begin
  if FCurColApplicationList in[4, 5, 7, 8, 9, 10] then
  begin
    PopupMenuYesNo.Items[0].Visible := True;
    PopupMenuYesNo.Items[1].Visible := True;
  end
  else
  begin
    PopupMenuYesNo.Items[0].Visible := False;
    PopupMenuYesNo.Items[1].Visible := False;
  end;
end;

procedure TConfigForm.ShowApplicationList;
var
  I, J: Integer;
begin
  // i - for field count in table j - for stringgrid column count
  Self.FDQueryApplicationList.Close;
  Self.FDQueryApplicationList.Open();
  Self.FDQueryApplicationList.First;

  // Filling the stringGrid
  Self.StringGridApplicationList.BeginUpdate;
  Self.StringGridApplicationList.RowCount :=
    Self.FDQueryApplicationList.RecordCount + 1;
  while not Self.FDQueryApplicationList.Eof do
  begin
    J := 0;
    for I := 0 to Self.FDQueryApplicationList.FieldCount - 1 do
    begin
      if not Self.FDQueryApplicationList.Fields[I].IsBlob then
        Self.StringGridApplicationList.Cells
          [J, Self.FDQueryApplicationList.RecNo - 1]:=
          Self.FDQueryApplicationList.Fields[I].AsString
      else
        if Self.FDQueryApplicationList.Fields[I].IsNull then
          Self.StringGridApplicationList.Cells
            [J, Self.FDQueryApplicationList.RecNo - 1]:= 'No'
        else
          Self.StringGridApplicationList.Cells
            [J, Self.FDQueryApplicationList.RecNo - 1]:= 'Yes';
      // RunceOne
      if I in[4, 8, 9] then
        if Self.FDQueryApplicationList.Fields[I].AsString = '0' then
          Self.StringGridApplicationList.Cells
            [J, Self.FDQueryApplicationList.RecNo - 1]:= 'No'
        else
          Self.StringGridApplicationList.Cells
            [J, Self.FDQueryApplicationList.RecNo - 1]:= 'Yes';
      // EasyLogin and KeyLogin
      if I = 7 then
      begin
        // EasyLogin filling
        if(Self.FDQueryApplicationList.Fields[I].AsInteger and CEasyLogin)= CEasyLogin
        then
          Self.StringGridApplicationList.Cells
            [J, Self.FDQueryApplicationList.RecNo - 1]:= 'Yes'
        else
          Self.StringGridApplicationList.Cells
            [J, Self.FDQueryApplicationList.RecNo - 1]:= 'No';
        J := J + 1;
        // Keylogin Filling
        if(Self.FDQueryApplicationList.Fields[I].AsInteger and CKeyLogin)= CKeyLogin
        then
          Self.StringGridApplicationList.Cells
            [J, Self.FDQueryApplicationList.RecNo - 1]:= 'Yes'
        else
          Self.StringGridApplicationList.Cells
            [J, Self.FDQueryApplicationList.RecNo - 1]:= 'No';
      end;
      J := J + 1;
    end;
    Self.FDQueryApplicationList.Next;
  end;
  for I := 0 to Self.FDQueryApplicationList.FieldCount - 1 do
    Self.StringGridApplicationList.Cells
      [I, Self.StringGridApplicationList.RowCount - 1]:= '';
  StringGridApplicationList.EndUpdate;
  StringGridApplicationList.Repaint;
end;

procedure TConfigForm.ShowRoleList;
var
  I, J: Integer;
begin
  // i - for field count in table j - for stringgrid column count
  Self.FDQueryRoleList.Close;
  Self.FDQueryRoleList.Params.ParamByName('ID').Value :=
    Self.ComboBoxUserRole.ListItems[Self.ComboBoxUserRole.ItemIndex].Tag;
  Self.FDQueryRoleList.Open();
  Self.FDQueryRoleList.First;
  // Filling the stringGrid
  Self.StringGridRoleList.BeginUpdate;
  Self.StringGridRoleList.RowCount := Self.FDQueryRoleList.RecordCount;
  while not Self.FDQueryRoleList.Eof do
  begin
    J := 0;
    for I := 0 to Self.FDQueryRoleList.FieldCount - 1 do
    begin
      if not Self.FDQueryRoleList.Fields[I].IsBlob then
        Self.StringGridRoleList.Cells[J, Self.FDQueryRoleList.RecNo - 1]:=
          Self.FDQueryRoleList.Fields[I].AsString
      else
        if Self.FDQueryRoleList.Fields[I].IsNull then
          Self.StringGridRoleList.Cells[J, Self.FDQueryRoleList.RecNo -
            1]:= 'No'
        else
          Self.StringGridRoleList.Cells[J, Self.FDQueryRoleList.RecNo -
            1]:= 'Yes';
      if I in[4, 8, 9] then
        if Self.FDQueryRoleList.Fields[I].AsString = '0' then
          Self.StringGridRoleList.Cells[J, Self.FDQueryRoleList.RecNo -
            1]:= 'No'
        else
          Self.StringGridRoleList.Cells[J, Self.FDQueryRoleList.RecNo -
            1]:= 'Yes';
      if I = 7 then
      begin
        // EasyLogin filling
        if(Self.FDQueryRoleList.Fields[I].AsInteger and CEasyLogin)= CEasyLogin
        then
          Self.StringGridRoleList.Cells[J, Self.FDQueryRoleList.RecNo -
            1]:= 'Yes'
        else
          Self.StringGridRoleList.Cells[J, Self.FDQueryRoleList.RecNo -
            1]:= 'No';
        J := J + 1;
        // Keylogin Filling
        if(Self.FDQueryRoleList.Fields[I].AsInteger and CKeyLogin)= CKeyLogin
        then
          Self.StringGridRoleList.Cells[J, Self.FDQueryRoleList.RecNo -
            1]:= 'Yes'
        else
          Self.StringGridRoleList.Cells[J, Self.FDQueryRoleList.RecNo -
            1]:= 'No';
      end;
      J := J + 1;
    end;
    Self.FDQueryRoleList.Next;
  end;
  StringGridRoleList.EndUpdate;
end;

procedure TConfigForm.FillCombos;
var
  AQueryCombo: TFDQuery;
  I: Integer;
begin
  // Filling combos
  AQueryCombo := TFDQuery.Create(Self);
  AQueryCombo.Connection := DataModuleBase.FDConnectionFelix;
  AQueryCombo.SQL.Add('SELECT ID, NAME FROM USER_ROLES;');
  AQueryCombo.Open();
  AQueryCombo.First;
  I := 0;
  Self.ComboBoxUserRole.Clear;
  while not AQueryCombo.Eof do
  begin
    Self.ComboBoxUserRole.Items.Add(AQueryCombo.FieldByName('NAME').AsString);
    Self.ComboBoxUserRole.ListItems[I].Tag := AQueryCombo.FieldByName('ID')
      .AsInteger;
    I := I + 1;
    AQueryCombo.Next;
  end;
  AQueryCombo.Close;
  AQueryCombo.SQL.Clear;
  AQueryCombo.SQL.Add('SELECT ID, NAME FROM USER_PROGRAMS;');
  AQueryCombo.Open();
  AQueryCombo.First;
  I := 0;
  Self.ComboBoxApplications.Clear;
  while not AQueryCombo.Eof do
  begin
    Self.ComboBoxApplications.Items.Add(AQueryCombo.FieldByName('NAME')
      .AsString);
    Self.ComboBoxApplications.ListItems[I].Tag := AQueryCombo.FieldByName('ID')
      .AsInteger;
    I := I + 1;
    AQueryCombo.Next;
  end;
  AQueryCombo.Close;
  AQueryCombo.Free;
  Self.ComboBoxUserRole.ItemIndex := 0;
  Self.ComboBoxApplications.ItemIndex := 0;
end;

procedure TConfigForm.ShowOptions;
var
  AIni: TIniFile;
begin
  AIni := TIniFile.Create(ExtractFileDir(ParamStr(0))+ '\felixmain.ini');
  MainForm.FTileSideSize :=
    StrToInt(AIni.ReadString('Common', 'TileSideSize', '300'));
  MainForm.FLogoImgPath := AIni.ReadString('Common', 'LogoImgPath',
    ExtractFilePath(ParamStr(0))+ 'img\gms-info.png');
  MainForm.FClientImgPath := AIni.ReadString('Common', 'ClientImgPath',
    ExtractFilePath(ParamStr(0))+ 'img\gms-info.png');
  MainForm.FSoundPath := AIni.ReadString('Common', 'SoundPath',
    ExtractFilePath(ParamStr(0))+ 'snd\newmessage.wav');
  MainForm.FUseAutoComplete :=
    StrToBool(AIni.ReadString('Common', 'UseAutoComplete', 'false'));
  Self.EditTileSize.Text := IntToStr(MainForm.FTileSideSize);
  Self.EditMainLogo.Text := MainForm.FLogoImgPath;
  Self.EditClientLogo.Text := MainForm.FClientImgPath;
  Self.EditSound.Text := MainForm.FSoundPath;
  Self.CheckBoxAutoComplete.IsChecked := MainForm.FUseAutocomplete;
  if FileExists(MainForm.FLogoImgPath)then
    Self.ImageControlMainLogo.LoadFromFile(MainForm.FLogoImgPath);
  if FileExists(MainForm.FClientImgPath)then
    Self.ImageControlClientLogo.LoadFromFile(MainForm.FClientImgPath);
  AIni.Free;
end;

procedure TConfigForm.TabItemRolesClick(Sender: TObject);
begin
  FillCombos;
  ShowRoleList;
end;

procedure TConfigForm.ToolbarCloseButtonClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TConfigForm.ButtonAcceptSettingsClick(Sender: TObject);
var
  AIni: TIniFile;
begin
  MainForm.FTileSideSize := StrToInt(Self.EditTileSize.Text);
  MainForm.FLogoImgPath := Self.EditMainLogo.Text;
  MainForm.FClientImgPath := Self.EditClientLogo.Text;
  MainForm.FSoundPath := Self.EditSound.Text;
  MainForm.FUseAutocomplete := Self.CheckBoxAutoComplete.IsChecked;
  AIni := TIniFile.Create(ExtractFileDir(ParamStr(0))+ '\felixmain.ini');
  AIni.WriteString('Common', 'TileSideSize', IntToStr(MainForm.FTileSideSize));
  AIni.WriteString('Common', 'LogoImgPath', MainForm.FLogoImgPath);
  AIni.WriteString('Common', 'ClientImgPath', MainForm.FClientImgPath);
  AIni.WriteString('Common', 'SoundPath', MainForm.FSoundPath);
  AIni.WriteString('Common', 'UseAutocomplete',
    Booltostr(MainForm.FUseAutocomplete, True));
  AIni.Free;
end;

procedure TConfigForm.ButtonAddAllForRoleClick(Sender: TObject);
var
  ARole_Id, AProg_ID, I: Integer;
begin
  ARole_ID := Self.ComboBoxUserRole.ListItems
    [Self.ComboBoxUserRole.ItemIndex].Tag;
  for I := 0 to ComboBoxApplications.Items.Count - 1 do
  begin
    AProg_ID := Self.ComboBoxApplications.ListItems[I].Tag;
    AddProgram_to_Role(ARole_ID, AProg_ID);
  end;
  ShowRoleList;
end;

procedure TConfigForm.ButtonAddClick(Sender: TObject);
var
  AMaxID, ALastRow, I, K, J: Integer;
  AQueryDml: TFDQuery;
begin
  ALastRow := Self.StringGridApplicationList.RowCount - 1;
  AQueryDml := TFDQuery.Create(Self);
  AQueryDml.Connection := DataModuleBase.FDConnectionFelix;
  AQueryDml.SQL.Add
    ('INSERT INTO USER_PROGRAMS(ID, Name, Path, Params, Runceone, Icon, Name_Short, Login_Type, AutoUpdate, DoAutoUpdateNow, ServerPath, SubFolders)');
  AQueryDml.SQL.Add
    ('VALUES (:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12)');
  J := 0;
  for I := 1 to 12 do
  begin
    if I = 1 then
      if Length(Self.StringGridApplicationList.Cells[J, ALastRow])> 0 then
        AQueryDml.Params.ParamByName(Inttostr(I)).Value :=
          StrToInt(Self.StringGridApplicationList.Cells[J, ALastRow])
      else
      begin
        AMaxID := 0;
        // find the max id if id does not set
        for K := 0 to ALastRow - 1 do
          if AMaxID < StrToInt(Self.StringGridApplicationList.Cells[0, K])then
            AMaxID := StrToInt(Self.StringGridApplicationList.Cells[0, K]);
        AQueryDml.Params.ParamByName(IntToStr(I)).Value := AMaxID + 1;
      end
    else
      if I = 6 then // Blob
        if not Self.ImageControlBlob.Bitmap.IsEmpty then
          AQueryDml.Params.ParamByName(IntToStr(I))
            .Assign(TBlobField(Self.ImageControlBlob.Bitmap))
        else
          AQueryDml.Params.ParamByName(IntToStr(I)).Value := Null
      else
        if I in[5, 9, 10] then // RunceOne
          if Self.StringGridApplicationList.Cells[J, ALastRow]= 'Yes' then
            AQueryDml.Params.ParamByName(IntToStr(I)).Value := '1'
          else
            AQueryDml.Params.ParamByName(IntToStr(I)).Value := '0'
        else
          if I = 8 then // EasyLogin + KeyLogin
          begin
            AQueryDml.Params.ParamByName(IntToStr(I)).Value := 0;
            if Self.StringGridApplicationList.Cells[J, ALastRow]= 'Yes' then
              AQueryDml.Params.ParamByName(IntToStr(I)).Value :=
                AQueryDml.Params.ParamByName(IntToStr(I)).Value or CEasyLogin;
            J := J + 1;
            if Self.StringGridApplicationList.Cells[J, ALastRow]= 'Yes' then
              AQueryDml.Params.ParamByName(IntToStr(I)).Value :=
                AQueryDml.Params.ParamByName(IntToStr(I)).Value or CKeyLogin;
          end
          else
            AQueryDml.Params.ParamByName(IntToStr(I)).Value :=
              Self.StringGridApplicationList.Cells[J, ALastRow];
    J := J + 1;
  end;
  AQueryDml.ExecSQL;
  AQueryDml.Free;
  ShowApplicationList;
end;

procedure TConfigForm.AddProgram_to_Role(RoleId: Integer; ProgId: Integer);
var
  AMaxID: Integer;
  AQueryDml: TFDQuery;
begin
  AQueryDml := TFDQuery.Create(Self);
  AQueryDml.Connection := DataModuleBase.FDConnectionFelix;
  AQueryDml.SQL.Add('SELECT MAX(ID) AS MaxID FROM User_Role_Programs');
  AQueryDml.Open();
  if AQueryDml.FieldByName('MaxID').IsNull then
    AMaxID := 1
  else
    AMaxID := AQueryDml.FieldByName('MaxID').AsInteger + 1;

  AQueryDml.Close;
  AQueryDml.SQL.Clear;
  AQueryDml.SQL.Add
    ('INSERT INTO User_Role_Programs(ID, USER_PROGRAM_ID, USER_ROLE_ID)');
  AQueryDml.SQL.Add('VALUES(' + IntToStr(AMaxID)+ ', ' + IntToStr(ProgID)+ ',' +
    IntToStr(RoleID)+ ')');
  AQueryDml.ExecSQL;
  AQueryDml.Free;
end;

procedure TConfigForm.ButtonAddForRoleClick(Sender: TObject);
var
  ARole_Id, AProg_ID: Integer;
begin
  AProg_ID := Self.ComboBoxApplications.ListItems
    [Self.ComboBoxApplications.ItemIndex].Tag;
  ARole_ID := Self.ComboBoxUserRole.ListItems
    [Self.ComboBoxUserRole.ItemIndex].Tag;
  AddProgram_to_Role(ARole_ID, AProg_ID);
  ShowRoleList;
end;

procedure TConfigForm.ButtonDeleteAllForRoleClick(Sender: TObject);
var
  ACurRow: Integer;
  AQueryDml: TFDQuery;
begin
  ACurRow := FCurRowRoleList;
  AQueryDml := TFDQuery.Create(Self);
  AQueryDml.Connection := DataModuleBase.FDConnectionFelix;
  AQueryDml.SQL.Add('DELETE FROM User_Role_Programs u');
  AQueryDml.SQL.Add('WHERE u.User_Role_Id = :2');
  AQueryDml.Params.ParamByName('2').Value := Self.ComboBoxUserRole.ListItems
    [Self.ComboBoxUserRole.ItemIndex].Tag;
  AQueryDml.ExecSQL;
  AQueryDml.Free;
  ShowRoleList;
end;

procedure TConfigForm.ButtonDeleteClick(Sender: TObject);
var
  ACurRow: Integer;
  AQueryDml: TFDQuery;
begin
  ACurRow := FCurRowApplicationList;
  AQueryDml := TFDQuery.Create(Self);
  AQueryDml.Connection := DataModuleBase.FDConnectionFelix;
  AQueryDml.SQL.Add('DELETE FROM User_Programs');
  AQueryDml.SQL.Add('WHERE ID = :1');
  AQueryDml.Params.ParamByName('1').Value :=
    StrToInt(Self.StringGridApplicationList.Cells[0, ACurRow]);
  AQueryDml.ExecSQL;
  AQueryDml.Free;
  ShowApplicationList;
end;

procedure TConfigForm.ButtonDeleteForRoleClick(Sender: TObject);
var
  ACurRow: Integer;
  AQueryDml: TFDQuery;
begin
  ACurRow := FCurRowRoleList;
  AQueryDml := TFDQuery.Create(Self);
  AQueryDml.Connection := DataModuleBase.FDConnectionFelix;
  AQueryDml.SQL.Add('DELETE FROM User_Role_Programs u');
  AQueryDml.SQL.Add('WHERE u.User_Program_ID = :1 AND u.User_Role_Id = :2');
  AQueryDml.Params.ParamByName('1').Value :=
    StrToInt(Self.StringGridRoleList.Cells[0, ACurRow]);
  AQueryDml.Params.ParamByName('2').Value := Self.ComboBoxUserRole.ListItems
    [Self.ComboBoxUserRole.ItemIndex].Tag;
  AQueryDml.ExecSQL;
  AQueryDml.Free;
  ShowRoleList;
end;

procedure TConfigForm.ButtonEditClick(Sender: TObject);
var
  ACurRow, I, J: Integer;
  QQueryDml: TFDQuery;
begin
  ACurRow := FCurRowApplicationList;
  QQueryDml := TFDQuery.Create(Self);
  QQueryDml.Connection := DataModuleBase.FDConnectionFelix;
  QQueryDml.SQL.Add('UPDATE User_Programs');
  QQueryDml.SQL.Add
    ('SET Name = :2, Path = :3, Params = :4, Runceone = :5, ICON = :6, Name_Short = :7, '
    +
    'Login_Type = :8, AUTOUPDATE = :9, DOAUTOUPDATENOW = :10, ServerPath = :11, SubFolders = :12 ');
  QQueryDml.SQL.Add('WHERE ID = :1');
  J := 0;
  for I := 1 to 12 do
  begin
    if I = 1 then
      QQueryDml.Params.ParamByName(IntToStr(I)).Value :=
        StrToInt(Self.StringGridApplicationList.Cells[J, ACurRow])
    else
      if I = 6 then
        if not Self.ImageControlBlob.Bitmap.IsEmpty then
          QQueryDml.Params.ParamByName(IntToStr(I))
            .Assign(TBlobField(Self.ImageControlBlob.Bitmap))
        else
          QQueryDml.Params.ParamByName(IntToStr(I)).Value := Null
      else
        if I in[5, 9, 10] then
          if StringGridApplicationList.Cells[J, ACurRow]= 'Yes' then
            QQueryDml.Params.ParamByName(IntToStr(I)).Value := '1'
          else
            QQueryDml.Params.ParamByName(IntToStr(I)).Value := '0'
        else
          if I = 8 then // EasyLogin + KeyLogin
          begin
            QQueryDml.Params.ParamByName(IntToStr(I)).Value := 0;
            if Self.StringGridApplicationList.Cells[J, ACurRow]= 'Yes' then
              QQueryDml.Params.ParamByName(IntToStr(I)).Value :=
                QQueryDml.Params.ParamByName(IntToStr(I)).Value or CEasyLogin;
            J := J + 1;
            if Self.StringGridApplicationList.Cells[J, ACurRow]= 'Yes' then
              QQueryDml.Params.ParamByName(IntToStr(I)).Value :=
                QQueryDml.Params.ParamByName(IntToStr(I)).Value or CKeyLogin;
          end
          else
            QQueryDml.Params.ParamByName(IntToStr(I)).Value :=
              Self.StringGridApplicationList.Cells[J, ACurRow];
    J := J + 1;
  end;
  QQueryDml.ExecSQL;
  QQueryDml.Free;
  ShowApplicationList;
end;

procedure TConfigForm.ButtonLocationMainLogoClick(Sender: TObject);
var
  AEdit: TEdit;
  AImageControl: TImageControl;
begin
  case(Sender as TButton).Tag of
  1:
    begin
      AEdit := Self.EditMainLogo;
      AImageControl := Self.ImageControlMainLogo;
    end;
  2:
    begin
      AEdit := Self.EditClientLogo;
      AImageControl := Self.ImageControlClientLogo;
    end;
  3:
    begin
      AEdit := Self.EditSound;
      AImageControl := nil;
    end;
  end;
  if Length(AEdit.Text)> 0 then
  begin
    // if theris no absolute path make it
    if Length(Trim(ExtractFileDrive(AEdit.Text)))> 0 then
      Self.OpenDialogLocation.InitialDir := ExtractFilePath(AEdit.Text)
    else
      Self.OpenDialogLocation.InitialDir := ExtractFilePath(ParamStr(0))+
        ExtractFilePath(AEdit.Text);
  end
  else
    Self.OpenDialogLocation.InitialDir := ExtractFilePath(ParamStr(0));
  if Self.OpenDialogLocation.Execute then
  begin
    AEdit.Text := Self.OpenDialogLocation.FileName;
    if AImageControl <> nil then
      AImageControl.LoadFromFile(AEdit.Text);
  end;
end;

procedure TConfigForm.ButtonSetupLocationClick(Sender: TObject);
begin
  if Length(Self.StringGridApplicationList.Cells[2, FCurRowApplicationList])> 0
  then
    Self.OpenDialogLocation.InitialDir :=
      ExtractFilePath(Self.StringGridApplicationList.Cells[2,
      FCurRowApplicationList])
  else
    Self.OpenDialogLocation.InitialDir := ExtractFilePath(ParamStr(0));
  if Self.OpenDialogLocation.Execute then
    Self.StringGridApplicationList.Cells[2, FCurRowApplicationList]:=
      Self.OpenDialogLocation.FileName;
end;

procedure TConfigForm.ButtonTestSoundClick(Sender: TObject);
begin
  if FileExists(Self.EditSound.Text)then
    SndPlaySound(PChar(Self.EditSound.Text), SND_ASYNC);
end;

procedure TConfigForm.ComboBoxUserRoleChange(Sender: TObject);
begin
  ShowRoleList;
end;

procedure TConfigForm.FormClose(Sender: TObject;var Action: TCloseAction);
begin
  if StringGridApplicationList.RowCount > FCurRowApplicationList + 1 then
    Self.ButtonEditClick(Sender);
end;

procedure TConfigForm.FormGesture(Sender: TObject;
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

procedure TConfigForm.ShowToolbar(AShow: Boolean);
begin
  ToolbarPopup.Width := ClientWidth;
  ToolbarPopup.PlacementRectangle.Rect :=
    TRectF.Create(0, ClientHeight - ToolbarPopup.Height, ClientWidth - 1,
    ClientHeight - 1);
  ToolbarPopupAnimation.StartValue := ToolbarPopup.Height;
  ToolbarPopupAnimation.StopValue := 0;
  ToolbarPopup.IsOpen := AShow;
end;

procedure TConfigForm.StringGridApplicationListSelectCell(Sender: TObject;
  const ACol, ARow: Integer;var CanSelect: Boolean);
begin
  if ARow > Self.StringGridApplicationList.RowCount then
    Exit;
  if(FCurRowApplicationList <> ARow)and
    (Self.StringGridApplicationList.RowCount > FCurRowApplicationList + 1)then
    Self.ButtonEditClick(Sender);
  FCurRowApplicationList := ARow;
  FCurColApplicationList := ACol;
  if Self.StringGridApplicationList.RowCount > ARow + 1 then
  begin
    Self.FDQueryApplicationList.Locate('ID',
      StrToInt(StringGridApplicationList.Cells[0, ARow]),[]);
    if Self.FDQueryApplicationList.FieldByName('ICON').IsNull then
      Self.ImageControlBlob.Bitmap.Assign(nil)
    else
      Self.ImageControlBlob.Bitmap.Assign
        (TBLOBField(Self.FDQueryApplicationList.FieldByName('ICON')));
  end;
end;

procedure TConfigForm.StringGridRoleListSelectCell(Sender: TObject;const ACol,
  ARow: Integer;var CanSelect: Boolean);
begin
  if ARow > Self.StringGridRoleList.RowCount then
    Exit;
  FCurRowRoleList := ARow;
end;

end.
