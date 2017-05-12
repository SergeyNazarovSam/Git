unit DMBase;

interface

uses
  SysUtils,
  Classes,
  DB,
  ADODB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.IBBase,
  FireDAC.Comp.Client, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  Vcl.ExtCtrls, FMX.Forms, FMX.Dialogs, FireDAC.Phys.FBDef;

type
  TDataModuleBase = class(TDataModule)
    TimerConnect: TTimer;
    FDConnectionFelix: TFDConnection;
    FDPhysFBDriverLinkFireBird: TFDPhysFBDriverLink;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    FDQueryGetNextID: TFDQuery;
    FDManager: TFDManager;
    FDQuery: TFDQuery;
    FDTransactionFelix: TFDTransaction;
    procedure TimerConnectTimer(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    FFirm: Integer;
    FDebugMode: Integer;
    FLogPath:string;
    FLogClientName:string;
    FLogProgramUser:string;
    FLogSystemUser:string;
    procedure SetFirm(const Value: Integer);
    procedure SetDebugMode(const Value: Integer);
    procedure SetODBCPath(PServer:string);
    procedure SetLogPath(const Value:string);
    procedure SetLogClientName(const Value:string);
    procedure SetLogProgramUser(const Value:string);
    { Private-Deklarationen }
  public
    function GetMaxID(ATableName, AField:string): Integer;
    procedure WriteToLog(PLogStr:string; PWrite: Boolean);
    function GetNextID(ATableName:string; ADataSet: TDataSet): Integer;
    function SetMaxID(ATableName:string; ADataSet: TDataSet): Integer;
    function GetNextNumber(ATableName, AField:string): Integer;
    function SQLExecute(PSQL:string): Boolean;
    function CheckTablesFields(PTableName, PFieldName,
      PFieldType:string): Boolean;
    property Firm: Integer read FFirm write SetFirm;
    property DebugMode: Integer read FDebugMode write SetDebugMode;
    property LogPath:string read FLogPath write SetLogPath;
    property LogClientName:string read FLogClientName write SetLogClientName;
    property LogProgramUser:string read FLogProgramUser write SetLogProgramUser;
  end;

var
  DataModuleBase: TDataModuleBase;

implementation

uses IniFiles, Registry, Windows, Variants, Hsapi, UnitMain;

{$R *.dfm}


resourcestring
  RStrDieVerbindung =
    'Die Verbindung zur Datenbank konnte nicht hergestellt werden, bitte überprüfen Sie den Pfad in der Felixmain.ini';
  RStrFehler = 'Fehler: ';
  RStrVerbindungZurDaten =
    'Verbindung zur Datenbank verloren. Kontrollieren Sie Ihr Netzwerk';
  RStrVersucheVerbindung = 'Versuche Verbindung neu aufzubauen';
  RStrKassenjournal = '129: Fehler in WriteToKassenjournal';

procedure TDataModuleBase.SetODBCPath(PServer:string);
var
  ARegistry: TRegistry;
begin
  ARegistry := TRegistry.Create;
  ARegistry.RootKey := HKey_Current_USer;
  ARegistry.OpenKey('\Software\ODBC\ODBC.INI\ODBC Data Sources', True);
  ARegistry.WriteString('FelixODBC', 'Firebird/InterBase(r) driver');
  ARegistry.OpenKey('\Software\ODBC\ODBC.INI\FelixODBC', True);
  ARegistry.WriteString('DbName', PServer);
  ARegistry.WriteString('AutoQuotedIdentifier', 'N');
  ARegistry.WriteString('CharacterSet', 'NONE');
  ARegistry.WriteString('Client', '');
  ARegistry.WriteString('Dialect', '3');
  ARegistry.WriteString('Driver', 'Odbcfb.dll');
  ARegistry.WriteString('JdbcDriver', 'IscDbc');
  ARegistry.WriteString('NoWait', 'Y');
  ARegistry.WriteString('Password',
    'ALIKAKIJAJIIAIIHAHIGAGIFAFIEAEIDADICACIBABIAAAIPAPIOAOINANIMAMILALIKAKIJAJIIAIIHIF');
  ARegistry.WriteString('QuotedIdentifier', 'Y');
  ARegistry.WriteString('ReadOnly', 'Y');
  ARegistry.WriteString('Role', '');
  ARegistry.WriteString('SensitiveIdentifier', 'N');
  ARegistry.WriteString('User', 'SYSDBA');
  ARegistry.CloseKey;
  ARegistry.Free;
end;

function TDataModuleBase.GetNextID(ATableName:string;
  ADataSet: TDataSet): Integer;
var
  AID: Integer;
begin
  Result := 0;
  with FDQueryGetNextID do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT GEN_ID(GEN_' + ATableName + '_ID, 1) FROM RDB$DATABASE');
    Open;
    AID := FieldByName('Gen_ID').AsInteger;
    Close;
  end;
  with ADataSet do
  begin
    FieldByName('Firma').AsInteger := FFirm;
    FieldByName('ID').AsInteger := AID;
    try
      Post;
    except
      FieldByName('ID').AsInteger := SetMaxID(ATablename, ADataSet);
      Post;
    end;
    Edit;
  end;
end;

function TDataModuleBase.SetMaxID(ATableName:string;
  ADataSet: TDataSet): Integer;
var
  AID: Integer;
begin
  with FDQueryGetNextID do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT MAX(ID) AS MAXID FROM ' + ATableName + '');
    Open;
    AID := FieldByName('MAXID').AsInteger + 1;
    Close;
    SQL.Clear;
    SQL.Add('SET GENERATOR GEN_' + ATableName + '_ID TO ' + IntToStr(AID));
    ExecSQL;
    Result := AID;
  end;
end;

function TDataModuleBase.GetNextNumber(ATableName, AField:string): Integer;
var
  AID: Integer;
begin
  with FDQueryGetNextID do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select MAX(' + AField + ') AS ' + AField + ' FROM ' + ATableName);
    Open;
    Last;
    AID := FieldByName(AField).AsInteger + 1;
    Close;
  end;
  Result := AID;
end;

procedure TDataModuleBase.DataModuleCreate(Sender: TObject);
var
  AIni: TIniFile;
begin
  FFirm := 1;
  FLogClientName := '';
  FLogPath := Extractfilepath(ParamStr(0))+ '\logs\desktop\';
  AIni := TIniFile.Create(ExtractFileDir(ParamStr(0))+ '\felixmain.ini');
  FDebugMode := StrToInt(AIni.ReadString('Common', 'DebugModus', '0'));
  Hotelserverapi.URL := AIni.ReadString('Common', 'Hotelserver',
    'http://cloud2.gms.info:3000');
  MainForm.FLogoImgPath := AIni.ReadString('Common', 'LogoImgPath',
    ExtractFilePath(ParamStr(0))+ 'img\gms-info.png');
  MainForm.FClientImgPath := AIni.ReadString('Common', 'ClientImgPath',
    ExtractFilePath(ParamStr(0))+ 'img\gms-info.png');
  MainForm.FTileSideSize :=
    StrToInt(AIni.ReadString('Common', 'TileSideSize', '300'));
  MainForm.FSoundPath := AIni.ReadString('Common', 'SoundPath',
    ExtractFilePath(ParamStr(0))+ 'snd\newmessage.wav');
  MainForm.FUseAutocomplete :=
    StrToBool(AIni.ReadString('Common', 'UseAutocomplete', 'false'));
  try
    FDConnectionFelix.Params.Values['Database']:=
      AIni.ReadString('DataBase', 'Server', '');
    SetODBCPath(FDConnectionFelix.Params.Values['Database']);
    TimerConnect.Enabled := True;
  except
    on E: Exception do
    begin
      Showmessage(RStrDieVerbindung + #13 + RStrFehler + E.Message);
      Application.Terminate;
      Halt;
    end;
  end;
  AIni.Free;
end;

procedure TDataModuleBase.TimerConnectTimer(Sender: TObject);
var
  AFDQueryTemp: TFDQuery;
begin
  TimerConnect.Enabled := FALSE;
  FDConnectionFelix.Connected := False;
  FDConnectionFelix.Connected := True;
  AFDQueryTemp := TFDQuery.Create(Self);
  AFDQueryTemp.Connection := FDConnectionFelix;
  AFDQueryTemp.Close;
  AFDQueryTemp.SQL.Clear;
  AFDQueryTemp.SQL.Add('SELECT COUNT(RDB$FIELD_NAME)');
  AFDQueryTemp.SQL.Add('FROM RDB$RELATION_FIELDS');
  AFDQueryTemp.SQL.Add('WHERE RDB$RELATION_NAME = ''USER_PROGRAMS''');
  AFDQueryTemp.SQL.Add('  AND RDB$FIELD_NAME = ''NAME_SHORT''');
  AFDQueryTemp.Open();
  if AFDQueryTemp.Fields.Fields[0].AsInteger = 0 then
  begin
    AFDQueryTemp.Close;
    AFDQueryTemp.SQL.Text :=
      'ALTER TABLE USER_PROGRAMS ADD NAME_SHORT VARCHAR(5) COLLATE UNICODE_CI_AI';
    AFDQueryTemp.ExecSQL;
    AFDQueryTemp.Close;
    AFDQueryTemp.SQL.Text :=
      'ALTER TABLE USER_PROGRAMS ADD LOGIN_TYPE SMALLINT';
    AFDQueryTemp.ExecSQL;
    AFDQueryTemp.Close;
    AFDQueryTemp.SQL.Clear;
    AFDQueryTemp.SQL.Add('UPDATE RDB$FIELDS SET');
    AFDQueryTemp.SQL.Add('RDB$FIELD_SUB_TYPE = 0');
    AFDQueryTemp.SQL.Add('WHERE RDB$FIELD_NAME = (SELECT rf.RDB$FIELD_SOURCE');
    AFDQueryTemp.SQL.Add('FROM RDB$RELATION_FIELDS rf');
    AFDQueryTemp.SQL.Add('WHERE (rf.RDB$FIELD_NAME = ''ICON'')');
    AFDQueryTemp.SQL.Add('  AND (rf.RDB$RELATION_NAME = ''USER_PROGRAMS''))');
    AFDQueryTemp.ExecSQL;
  end;
  AFDQueryTemp.Close;
  AFDQueryTemp.Free;
end;

procedure TDataModuleBase.SetFirm(const Value: Integer);
begin
  FFirm := Value;
end;

procedure TDataModuleBase.SetDebugMode(const Value: Integer);
begin
  FDebugMode := Value;
end;

function TDataModuleBase.SQLExecute(PSQL:string): Boolean;
resourcestring
  RSQLExecute = 'Fehler in SQLExecute:';
begin
  Result := True;
  with FDQuery do
  begin
    SQL.Clear;
    SQL.Text := PSQL;
    Prepare;
    begin
      try
        FDTransactionFelix.StartTransaction;
        ExecSQL;
        UnPrepare;
        FDTransactionFelix.CommitRetaining;
      except
        on E: Exception do
        begin
          FDTransactionFelix.Rollback;
          ShowMessage(IntToStr(E.HelpContext)+ RSQLExecute + ' ' + E.Message +
            #13 + #13 + PSQL);
          Result := False;
        end;
      end;
    end;
  end;
end;

function TDataModuleBase.CheckTablesFields(PTableName, PFieldName,
  PFieldType:string): Boolean;
begin
  Result := True;
  with FDQuery do
  begin
    try
      SQL.Clear;
      SQL.Add('ALTER TABLE ' + PTableName + ' ADD ' + PFieldName + ' ' +
        PFieldType);
      try
        ExecSQL;
      except
        Result := False;
      end;
    finally
    end;
  end;
end;

procedure TDataModuleBase.WriteToLog(PLogStr:string; PWrite: Boolean);
var
  AFileName:string;
  AHandle: TextFile;
begin
  try
    if((FDebugMode > 0)or PWrite)and(FLogPath <> '')then
    begin
      ForceDirectories(FLogPath);
      AFileName := FLogPath + FormatDateTime('yymmdd_hh', Now)+ '00.log';
      AssignFile(AHandle, AFileName);
      if FileExists(AFileName)then
        Append(AHandle)
      else
        Rewrite(AHandle);
      PLogStr := '(' + TimeToStr(Sysutils.Time)+ ' Firma:' + IntToStr(Firm)+
        ' Benutzer:' + LogProgramUser + ') ' + PLogStr;
      if FLogClientName <> '' then
        PLogStr := PLogStr + ' (' + FLogClientName + ')';
      WriteLn(AHandle, PLogStr);
      CloseFile(AHandle);
    end;
  except
  end;
end;

procedure TDataModuleBase.SetLogPath(const Value:string);
var
  AYear, AMonth, ADay: Word;
  APath, AppPath:string;
begin
  DecodeDate(Date, AYear, AMonth, ADay);
  if Value <> '' then
    AppPath := Value
  else
    AppPath := ExtractFilePath(ParamStr(0));
  APath := AppPath + '\' + IntToStr(AYear)+ '\' + IntToStr(AMonth)+ '\';
  ForceDirectories(APath);
  if DirectoryExists(APath)then
    FLogPath := APath
  else
    FLogPath := Value;
end;

procedure TDataModuleBase.SetLogProgramUser(const Value:string);
begin
  FLogProgramUser := Value;
end;

procedure TDataModuleBase.SetLogClientName(const Value:string);
begin
  FLogClientName := Value;
end;

function TDataModuleBase.GetMaxID(ATableName, AField:string): Integer;
begin
  with FDQueryGetNextID do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT GEN_ID(GEN_' + ATableName + '_ID, 1) FROM RDB$DATABASE');
    Open;
    Result := FieldByName('Gen_ID').AsInteger;
    Close;
  end;
end;

end.
