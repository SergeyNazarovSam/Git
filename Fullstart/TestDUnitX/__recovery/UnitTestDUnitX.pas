unit UnitTestDUnitX;

{Delphi DUnitX Test Case
  ----------------------
  This test case test login and getmessagecount functions for
  Username = admin@felix.info password = adminfelix
  remember that you need first login to test getmessage count

}

interface
uses
  DUnitX.TestFramework, hsapi, System.SysUtils, DUnitX.Loggers.GUIX;

type

  [TestFixture]
  TMyTestObject = class(TObject) 
  strict private
    Fhotelserverapi: Thotelserverapi;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Sample Methods
    // Simple single Test
    [Test]
    [TestCase('TestGoodLogin','http://cloud2.gms.info:3000, admin@felix.info, adminfelix, 0')]
  //  [TestCase('TestWrongLogin','3,4,-1')]
    procedure TestLoginAndGetMessagesCount(pURL, pUserName, pPassword:string; pResult:Boolean);
  end;

implementation

procedure TMyTestObject.Setup;
begin
  Fhotelserverapi := Thotelserverapi.Create(nil);
  //Fhotelserverapi.URL := 'http://cloud2.gms.info:3000';
  //Fhotelserverapi.Username := 'admin@felix.info';
  //Fhotelserverapi.Password := 'adminfelix';
end;

procedure TMyTestObject.TearDown;
begin
  Fhotelserverapi.Free;
  Fhotelserverapi := nil;
end;

procedure TMyTestObject.TestLoginAndGetMessagesCount(pURL, pUserName, pPassword:string; pResult:Boolean);
var
  ReturnValueLogin: Boolean;
  ReturnValueCount: string;
  pToken: string;
  pCreatedUser: string;
begin

  Fhotelserverapi.URL := pURL;
  Fhotelserverapi.Username := pUserName;
  Fhotelserverapi.Password := pPassword;

  {if pResult then
    Assert.Fail('true')
  else
    Assert.Fail('false');}


  //Assert.Fail(pURL+' '+pUserName+' '+pPassword);

  ReturnValueLogin := Fhotelserverapi.Login;
  Assert.AreEqual(ReturnValueLogin, true,'Good login test fail');


  {if not ReturnValueLogin  then
    Assert.Fail('Login have fallen with username = '+Fhotelserverapi.Username+
         ' and password = '+Fhotelserverapi.Password);
  if Length(Fhotelserverapi.Token) = 0 then
    Assert.Fail('Token is Empty');}

  pToken := Fhotelserverapi.Token;
  pCreatedUser := IntToStr(Fhotelserverapi.UserID);

  ReturnValueCount := Fhotelserverapi.getmessagecount(pCreatedUser, pToken);

  if StrToInt(ReturnValueCount) < 0 then
    Assert.Fail('Function return ' + ReturnValueCount);
end;

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);
end.
