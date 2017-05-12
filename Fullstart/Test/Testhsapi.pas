unit Testhsapi;
{

  Delphi DUnit Test Case
  ----------------------
  This test case test login and getmessagecount functions for
  Username = admin@felix.info password = adminfelix
  remember that you need first login to test getmessage count

}

interface

uses
  TestFramework, IdSSLOpenSSL, REST.Client, SysUtils, hsapi, IdHTTP,
  Data.Bind.ObjectScope, superobject, IdIOHandlerStack, IdTCPConnection, IdTCPClient,
  REST.Authenticator.OAuth, Data.Bind.Components, Classes, IdIOHandlerSocket,
  IdComponent, IdBaseComponent, IdSSL, IdIOHandler, IPPeerClient;

type
  // Test methods for class Thotelserverapi

  TestThotelserverapi = class(TTestCase)
  strict private
    Fhotelserverapi: Thotelserverapi;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestLoginAndGetMessageCount;
  end;

implementation

procedure TestThotelserverapi.SetUp;
begin
  Fhotelserverapi := Thotelserverapi.Create(nil);
  Fhotelserverapi.URL := 'http://cloud2.gms.info:3000';
  Fhotelserverapi.Username := 'admin@felix.info';
  Fhotelserverapi.Password := 'adminfelix';
end;

procedure TestThotelserverapi.TearDown;
begin
  Fhotelserverapi.Free;
  Fhotelserverapi := nil;
end;

procedure TestThotelserverapi.TestLoginAndGetMessageCount;
var
  ReturnValueLogin: Boolean;
  ReturnValueCount: string;
  pToken: string;
  pCreatedUser: string;
begin

  ReturnValueLogin := Fhotelserverapi.Login;
  if not ReturnValueLogin  then
    Fail('Login have fallen with username = '+Fhotelserverapi.Username+
         ' and passwort = '+Fhotelserverapi.Password);
  if Length(Fhotelserverapi.Token) = 0 then
    Fail('Token is Empty');

  pToken := Fhotelserverapi.Token;
  pCreatedUser := IntToStr(Fhotelserverapi.UserID);

  ReturnValueCount := Fhotelserverapi.getmessagecount(pCreatedUser, pToken);

  if StrToInt(ReturnValueCount) < 0 then
    Fail('Function return ' + ReturnValueCount);

end;


initialization
  // Register any test cases with the test runner
  RegisterTest(TestThotelserverapi.Suite);
end.

