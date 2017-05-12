unit hsapi;

interface

uses
  SysUtils, Classes, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, Superobject, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, IPPeerClient, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, REST.Authenticator.OAuth;

type
  TUserlogin = record
    Status:string;
    ErrorMessage:string;
    Token:string;
  end;

  THotelServerApi = class(TDataModule)
    HTTP: TIdHTTP;
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
  protected
    FToken:string;
    FUserID: Int64;
    FIsLogin: Boolean;
    FUsername:string;
    FPassword:string;
    FLastError:string;
    FStatus:string;
    FURL:string;
  private
  public
    function GetMessageCount(PCreatedUser, PToken:string):string;
    function GetMessages(PToken:string):string;
    function Login: Boolean;
    procedure Logout;
    function SendMessage(PMessage, PToUserId, PToRuleID:string):string;
    property IsLogin: Boolean read FIsLogin default False;
    property LastError:string read FLastError write FLastError;
    property Password:string read FPassword write FPassword;
    property Status:string read FStatus write FStatus;
    property Token:string read FToken write FToken;
    property URL:string read FURL write FURL;
    property UserID: Int64 read FUserid write FUserid default 0;
    property Username:string read FUsername write FUsername;
  end;

var
  HotelServerApi: THotelServerApi;

implementation

{$R *.dfm}


function THotelServerApi.GetMessageCount(PCreatedUser, PToken:string):string;
var
  AResult: ISuperObject;
  AResponse:string;
begin
  Result := '';
  HTTP.Request.CustomHeaders.Clear;
  HTTP.Request.CustomHeaders.Add('Authorization: Token token="' + FToken + '"');
  AResponse := HTTP.Get(FURL + '/api/v1/setting/announcements/get_recent_count/'
    + PCreatedUser + '/');
  AResult := SO(AResponse);
  if AResult <> nil then
    Result := AResult.O['content'].AsString;
end;

function THotelServerApi.GetMessages(PToken:string):string;
var
  AParam: TStringList;
  AResponse:string;
  AResponseStream: TFileStream;
begin
  Result := '';
  HTTP.Request.CustomHeaders.Clear;
  HTTP.Request.CustomHeaders.Add('Authorization: Token token="' + FToken + '"');
  AResponseStream := TFileStream.Create('c:\1\response.txt', FmCreate);
  Aparam := Tstringlist.Create;
  HTTP.Get(FURL + '/setting/announcements', AResponseStream);
  AResponseStream.Free;
end;

function THotelServerApi.Login: Boolean;
var
  AResult: ISuperObject;
  AContent: ISuperObject;
  AParam: TStringList;
  AResponse:string;
  AResponseStream: TFileStream;
begin
  Result := False;
  if(FIsLogin = False)and(FToken = '')then
  begin
    HTTP.Request.CustomHeaders.Clear;
    AParam := TStringList.Create;
    AParam.Add('user_email=' + FUsername + '');
    AParam.Add('user_password=' + FPassword + '');
    AResponse := HTTP.Post(FURL + '/api/v1/user/users/sign_in', AParam);
    AResult := SO(AResponse);
    if AResult <> nil then
    begin
      FStatus := AResult.O['status'].AsString;
      if FStatus = '0' then
      begin
        AContent := AResult.O['content'];
        if AContent <> nil then
        begin
          FToken := AContent.S['authentication_token'];
          FIsLogin := True;
          FUserID := StrToInt(AContent.S['id']);
          Result := True;
        end;
      end
      else
      begin
        AContent := AResult.O['content'];
        if AContent <> nil then
        begin
          FLastError := AContent.S['error_msg'];
        end;
      end;
    end;
  end
  else
  begin
    Result := True;
    if FToken <> '' then
      FIsLogin := True;
  end;
end;

procedure THotelServerApi.Logout;
begin
  FToken := '';
  FUserID := 0;
  FIsLogin := False;
end;

function THotelServerApi.SendMessage(PMessage, PToUserId,
  PToRuleID:string):string;
var
  AParam: TStringList;
  AResponse:string;
begin
  if FIsLogin = True then
  begin
    Result := '';
    HTTP.Request.CustomHeaders.Clear;
    HTTP.Request.CustomHeaders.Add('Authorization: Token token="' +
      FToken + '"');
    AParam := TStringList.Create;
    AParam.Add('setting_announcement[message]=' + PMessage + '');
    AParam.Add('setting_announcement[created_user_id]=' +
      IntToStr(FUserID)+ '');
    if PToUserId <> '' then
    begin
      AParam.Add('setting_announcement[user_user_id]=' + PToUserId + '');
    end;
    if PToRuleID <> '' then
    begin
      AParam.Add('setting_announcement[user_role_id]=' + PToRuleID + '');
    end;
    AResponse := HTTP.Post(FURL + '/setting/announcements', AParam);
    Result := AResponse;
  end
  else
  begin
    Result := 'no login';
  end;
end;

end.
