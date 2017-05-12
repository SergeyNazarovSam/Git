unit UnitTestDUnitX;

{Delphi DUnitX Test Case
  ----------------------
  This test case test login and getmessagecount functions for
  Username = admin@felix.info password = adminfelix
  remember that you need first login to test getmessage count

}

interface
uses
  DUnitX.TestFramework, hsapi, unitLogin, System.SysUtils, DUnitX.Loggers.GUIX, System.Rtti, FMX.Forms;

type
  {$RTTI EXPLICIT METHODS([vcPrivate..vcPublished])}
  [TestFixture]
  TMyTestObject = class(TObject)
  strict private
    Fhotelserverapi: Thotelserverapi;
    FfmLogin: TfmLogin;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    [TestCase('TestGoodLogin','http://cloud2.gms.info:3000,admin@felix.info,adminfelix,true')]
    [TestCase('TestWrongLogin','http://cloud2.gms.info:3000,admin@felix.info,xxx,false')]
    procedure TestLoginAndGetMessagesCount(pURL, pUserName, pPassword:string; pResult:Boolean);
    //[Test]
    //[TestCase('Test ListBoxFilling in login ','adm,2')]
    //[TestCase('Test ListBoxFilling in login ','gm,1')]
    //procedure ListBoxFilling(pUserNamePart:string; pExpectedCount:integer);
  end;

implementation

procedure TMyTestObject.Setup;
begin
  Fhotelserverapi := Thotelserverapi.Create(nil);
  FfmLogin := TfmLogin.Create(nil);
  //Fhotelserverapi.URL := 'http://cloud2.gms.info:3000';
  //Fhotelserverapi.Username := 'admin@felix.info';
  //Fhotelserverapi.Password := 'adminfelix';
end;

procedure TMyTestObject.TearDown;
begin
  Fhotelserverapi.Free;
  Fhotelserverapi := nil;
  FfmLogin.Free;
  FfmLogin := nil;
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

  ReturnValueLogin := Fhotelserverapi.Login;

  Assert.AreEqual(pResult, ReturnValueLogin,' login test fail');

  if ReturnValueLogin then
  begin
    pToken := Fhotelserverapi.Token;
    pCreatedUser := IntToStr(Fhotelserverapi.UserID);
    ReturnValueCount := Fhotelserverapi.getmessagecount(pCreatedUser, pToken);
    if StrToInt(ReturnValueCount) < 0 then
      Assert.Fail('Function return ' + ReturnValueCount);
  end;

end;

{procedure TMyTestObject.ListBoxFilling(pUserNamePart:string; pExpectedCount:integer);
var
  rttiContext: TRttiContext;
begin
  // first fill display list
  FfmLogin.EditUserName.Lookup.DisplayList.Clear;
  FfmLogin.EditUserName.Lookup.DisplayList.Add('admin');
  FfmLogin.EditUserName.Lookup.DisplayList.Add('admin@felix.info');
  FfmLogin.EditUserName.Lookup.DisplayList.Add('gms');
  rttiContext := TRttiContext.Create;
  rttiContext.GetType(TfmLogin).GetMethod('ShowUserNameList').Invoke(FfmLogin, [pUserNamePart]);
  Assert.AreEqual(pExpectedCount, FfmLogin.ListBoxLogin.Count,'Count is wrong, TfmLogin.ShowUserNameList works wrong ');

end;    }

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);
end.
