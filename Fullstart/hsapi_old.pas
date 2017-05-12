
unit hsapi;

interface

uses
  SysUtils, Classes, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP,superobject, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL;

type
  TUserlogin = Record
    Status : string;
    ErrorMessage : string;
    Token : string;
  End;

  Thotelserverapi = class(TDataModule)
    curl: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
  protected
    FToken : string;
    FUserID : integer;
    Fislogin : boolean;
    FUsername : string;
    Fpasswort : string;
    FLastError : string;
    Fstatus : string;
    FURL : string;
  private
    { Private-Deklarationen }
  public

    function Login: boolean;
    function sendmessage (PMessage, pToUserId, pToRuleID : string): string;
    function getmessagecount (pCreatedUser,pToken : string) : string;
    function getmessages (pToken : string) : string;
    procedure logout;

    property Token: string read FToken write FToken;
    property Username: string read FUsername write FUsername;
    property Password: string read Fpasswort write Fpasswort;
    property Status: string read Fstatus write Fstatus;
    property URL: string read FURL write FURL;
    property LASTERROR: string read FLastError write FLastError;
    property UserID: integer read FUserid write FUserid default 0;
    property isLogin: boolean read Fislogin default false;
//    function GetJSONData(ptable : TFDMemTable) : TFDJSONDataSets;
    { Public-Deklarationen }
  end;

var
  hotelserverapi: Thotelserverapi;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TDataModule1 }



function Thotelserverapi.getmessagecount(pCreatedUser, pToken: string): string;
var aparam : Tstringlist;
    aresponse : string;
    astream : TMemoryStream;

begin
  result := '';
  curl.Request.CustomHeaders.Clear;
  curl.Request.CustomHeaders.Add('Authorization: Token token="'+FToken+'"');
//  astream := TMemoryStream.Create;
  aparam := TSTringlist.Create;
//  aparam := Tstringlist.Create;
  aparam.Add('user_user_id='+pCreatedUser+'');
//  curl.get('http://cloud2.gms.info:3001/api/v1/article/articles',astream);
  aresponse := curl.post(FURL+'/setting/announcements/get_new_announcements_count',aparam);
  result := aresponse;
//  curl.get('http://cloud2.gms.info:3001/api/v1/article/articles',response2);

end;

function Thotelserverapi.getmessages(pToken: string): string;
var aparam : Tstringlist;
    aresponse : string;
    response2 : TFileStream;

begin
  result := '';
  curl.Request.CustomHeaders.Clear;
  curl.Request.CustomHeaders.Add('Authorization: Token token="'+FToken+'"');
  response2 := TFileStream.Create('c:\response.txt',fmCreate);
  aparam := Tstringlist.Create;
  curl.get(FURL+'/setting/announcements',response2);
 // aresponse := curl.post('http://cloud2.gms.info:3001/api/v1/setting/announcements',aparam);
 // result := aresponse;
 Response2.Free;
//  curl.get('http://cloud2.gms.info:3001/api/v1/article/articles',response2);

end;

function Thotelserverapi.Login: boolean;
var
    jresult : ISuperObject;
  //  JsonResultPair : TJSONPair;
  //  jcontentpair : TJSONPair;
    jcontent : ISuperObject;
    aparam : Tstringlist;
    aresponse : string;
    response2 : Tfilestream;
    test,test2 : string;
    I: Integer;
  U: Integer;
begin
  if Fislogin = false then
  begin
    curl.Request.CustomHeaders.Clear;
  //  curl.Request.CustomHeaders.Add('Authorization: Token token="'+FToken+'"');


    aparam := Tstringlist.Create;
    aparam.Add('user_email='+FUsername+'');
    aparam.Add('user_password='+FPasswort+'');

    aresponse := curl.post(FURL+'/api/v1/user/users/sign_in',aparam);
    //aresponse := curl.post('http://cloud2.gms.info:5000/api/v1/user/users/sign_in',aparam);
    jresult := SO(aresponse);
    if jresult <> nil then
    begin
      Fstatus := jresult.O['status'].AsString;
      if Fstatus = '0' then
      begin
        jcontent := jresult.O['content'];
        if jcontent <> nil then
        begin
          FToken := jcontent.S['authentication_token'];
          Fislogin := true;
          FUserID := strtoint (jcontent.S['id']);
        end;
      end else
      begin
        jcontent := jresult.O['content'];
        if jcontent <> nil then
        begin
          FLastError := jcontent.S['error_msg'];
        end;
      end;
    end;
  end else
  begin
    result := true;
  end;
end;

procedure Thotelserverapi.logout;
begin
  FToken := '';
  FUserID := 0;
  Fislogin := false;
end;

function Thotelserverapi.sendmessage(PMessage, pToUserId,
  pToRuleID : string): string;
var aparam : Tstringlist;
    aresponse : string;
  U: Integer;

begin
  if Fislogin = true then
  begin
  result := '';
  curl.Request.CustomHeaders.Clear;
  curl.Request.CustomHeaders.Add('Authorization: Token token="'+FToken+'"');

//  for U := 1 to 50 do
//  begin
    aparam := Tstringlist.Create;
    aparam.Add('setting_announcement[message]='+PMessage+'');
    aparam.Add('setting_announcement[created_user_id]='+inttostr (FUserID)+'');
    if pToUserId <> '' then
    begin
      aparam.Add('setting_announcement[user_user_id]='+pToUserId+'');
    end;
    if pToRuleID <> '' then
    begin
      aparam.Add('setting_announcement[user_role_id]='+pToRuleID+'');
    end;
    aresponse := curl.post(FURL+'/setting/announcements',aparam);
    result := aresponse;
  end else
  begin
    result := 'no login';
  end;
//  end;

//  curl.get('http://cloud2.gms.info:3001/api/v1/article/articles',response2);
 //   <15:46:04> "florian.w": curl -X POST 'http://localhost:3000/api/v1/setting/announcements' -d 'setting_announcement[message]=Heil am Seil&setting_announcement[created_user_id]=1&setting_announcement[user_user_id]=2' -H 'Authorization: Token token="51a8a936e8b2098c096c082c8098c417"'
end;

end.
