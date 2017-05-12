object hotelserverapi: Thotelserverapi
  OldCreateOrder = False
  Height = 197
  Width = 401
  object curl: TIdHTTP
    AllowCookies = True
    ProtocolVersion = pv1_0
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 40
    Top = 76
  end
  object RESTClient1: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    BaseURL = 'http://cloud2.gms.info:3000'
    ContentType = 'application/x-www-form-urlencoded'
    Params = <>
    HandleRedirects = True
    BindSource.AutoActivate = False
    BindSource.AutoEdit = False
    BindSource.AutoPost = False
    Left = 176
    Top = 80
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Method = rmPOST
    Params = <>
    Resource = 
      'api/v1/user/users/sign_in?user_email=admin@felix.info&user_passw' +
      'ord=adminfelix'
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 256
    Top = 80
  end
  object RESTResponse1: TRESTResponse
    BindSource.AutoActivate = False
    BindSource.AutoEdit = False
    BindSource.AutoPost = False
    Left = 176
    Top = 136
  end
end
