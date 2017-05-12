unit Unit1;

interface
uses
  DUnitX.TestFramework, FMX.FOrms;

type

  [TestFixture('THotelServerApi', 'Testing')]
  TMyTestObject = class(TObject)
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    [TestCase('CorrectLogin', 'admin@felix.info,adminfelix,True')]
    [TestCase('IncorrectLogin', 'admin@felix.info,password,False')]
    [TestCase('CorrectLogin for gms', 'gms,GMSv895094,True')]
    procedure Test1(const aLoginName : string; const aPassword : string; const aResult : boolean);

    [Test]
    [TestCase('MessageCount for admin', 'admin@felix.info,adminfelix,10')]
    [TestCase('MessageCount for somebody', 'admin@felix.info,adminfelix,1')]
    procedure Test2(const aLoginName : string; const aPassword : string; const aMessageCount : string);


  end;

implementation

uses hsapi, system.SysUtils;

procedure TMyTestObject.Setup;
begin
  HotelServerApi:=THotelServerApi.Create(Application.MainForm);
  hotelserverapi.URL := 'http://cloud2.gms.info:3000';
end;

procedure TMyTestObject.TearDown;
begin
  HotelServerApi.Free;
end;


procedure TMyTestObject.Test1(const aLoginName : string; const aPassword : string; const aResult : boolean);
begin
  hotelserverapi.Username := aLoginName;
  hotelserverapi.Password := aPassword;
  Assert.IsTrue(hotelserverapi.Login=aResult);
end;

procedure TMyTestObject.Test2(const aLoginName : string; const aPassword : string; const aMessageCount : string);
var
s: string;
begin
  hotelserverapi.Username := aLoginName;
  hotelserverapi.Password := aPassword;
  hotelserverapi.Login;
  s:=hotelserverapi.GetMessageCount(IntToStr(hotelserverapi.UserID), hotelserverapi.Token);
  Assert.IsTrue(s = aMessageCount);
end;

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);
end.
