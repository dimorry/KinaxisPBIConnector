// This file contains your Data Connector logic
[Version = "1.0.0"]
section KinaxisPBIConnector;

client_id = Text.FromBinary(Extension.Contents("client_id"));
client_secret = Text.FromBinary(Extension.Contents("client_secret"));
client_url = Text.FromBinary(Extension.Contents("client_url"));
credentials = Text.Combine({client_id, ":", client_secret});
encodedCredentials = Binary.ToText(Text.ToBinary(credentials), BinaryEncoding.Base64);
redirect_uri = "https://oauth.powerbi.com/views/oauthredirect.html";

[DataSource.Kind="KinaxisPBIConnector", Publish="KinaxisPBIConnector.Publish"]
//shared KinaxisPBIConnector.Contents = Value.ReplaceType(KinaxisPBIConnectorImpl, type function (rapid_url as Uri.Type, company_id as text, workbook as text, worksheet as text, l_client_id as text, l_client_secret as text) as any);
shared KinaxisPBIConnector.Contents = Value.ReplaceType(KinaxisPBIConnectorImpl, type function (rapid_url as Uri.Type) as any);

OAuthRequestHeaders = [
    #"Content-Type" = "application/x-www-form-urlencoded",
    #"Authorization" = Text.Combine({"Basic ", encodedCredentials})
];

DefaultRequestHeaders = [
    #"Content-Type" = "application/json",
    #"Authorization" = Text.Combine({"Bearer ", GetToken()})
];

//KinaxisPBIConnectorImpl = (rapid_url as text, company_id as text, workbook as text, worksheet as text, l_client_id as text, l_client_secret as text) =>
KinaxisPBIConnectorImpl = (rapid_url as text) =>
    let
        source = Web.Contents(rapid_url, [ Headers = DefaultRequestHeaders ]),
        json = Json.Document(source)
    in
        json;

// Data Source Kind description
KinaxisPBIConnector = [
    Authentication = [
        // Key = [],
        // UsernamePassword = [],
        // Windows = [],
        // Anonymous = []
        OAuth = [
            StartLogin = StartLogin,
            FinishLogin = FinishLogin
        ]
    ],
    Label = Extension.LoadString("DataSourceLabel"),
    redirect_uri = "https://oauth.powerbi.com/views/oauthredirect.html"
];

// Data Source UI publishing description
KinaxisPBIConnector.Publish = [
    Beta = true,
    Category = "Other",
    //ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    ButtonText = { "Kinaxis OData", "Kinaxis OData" },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = KinaxisPBIConnector.Icons,
    SourceTypeImage = KinaxisPBIConnector.Icons
];

KinaxisPBIConnector.Icons = [
    Icon16 = { Extension.Contents("KinaxisPBIConnector16.png"), Extension.Contents("KinaxisPBIConnector20.png"), Extension.Contents("KinaxisPBIConnector24.png"), Extension.Contents("KinaxisPBIConnector32.png") },
    Icon32 = { Extension.Contents("KinaxisPBIConnector32.png"), Extension.Contents("KinaxisPBIConnector40.png"), Extension.Contents("KinaxisPBIConnector48.png"), Extension.Contents("KinaxisPBIConnector64.png") }
];

StartLogin = (resourceUrl, state, display) =>
    let
        Parts = Uri.Parts(resourceUrl)[Query]
    in
        TokenMethod("client_credentials");

FinishLogin = (context, callbackUri, state) =>
    "Other";
    // let
    //     Parts = Uri.Parts(callbackUri)[Query]
    // in
    //     TokenMethod(Parts[code]);

TokenMethod = (grant_type) =>
    let
        Response = Web.Contents(client_url + "/oauth2/token", [
            Content = Text.ToBinary(Uri.BuildQueryString([
                client_id = client_id,
                client_secret = client_secret,
                grant_type = grant_type
                ])),
            Headers=[#"Content-type" = "application/x-www-form-urlencoded",#"Accept" = "application/json"]]),
        Parts = Json.Document(Response)
    in
        Parts;

GetToken = () =>
let
    url = client_url + "/oauth2/token",
    headers = OAuthRequestHeaders,
    body = Text.ToBinary("grant_type=client_credentials"),
    response = Web.Contents(url, [
        Headers = headers,
        Content = body
    ]),
    
    Data = Json.Document(response),
    access_token=Data[access_token]
in
    access_token;