table 50301 "Http Endpoint KFM"
{
    Caption = 'HTTP(S)) Endpoint';
    DataClassification = CustomerContent;
    LookupPageId = "Http Endpoint List KFM";

    fields
    {
        field(1; Code; Code[50])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(3; "Base Url"; Text[2048])
        {
            Caption = 'Base Url';
        }
        field(4; Authentication; Enum "HTTP Authentication KFM")
        {
            Caption = 'Authentication';
            InitValue = Anonymous;

            trigger OnValidate()
            var
                HttpAuthenticationSettings: Interface "Http Authentication Settings KFM";
            begin
                HttpAuthenticationSettings := Rec.Authentication;
                HttpAuthenticationSettings.Create(Rec);
            end;
        }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    trigger OnDelete()
    var
        HttpEndpointBasicAuth: Record "Http Endpoint Basic Auth. KFM";
        HttpEndpointOAuth20: Record "Http Endpoint OAuth 2.0 KFM";
        HttpEndpointOAuthScope: Record "Http Endpoint OAuth Scope KFM";
    begin
        if HttpEndpointBasicAuth.Get(Code) then
            HttpEndpointBasicAuth.Delete();

        if HttpEndpointOAuth20.Get(Code) then
            HttpEndpointOAuth20.Delete(true);

        HttpEndpointOAuthScope.SetRange("Http Endpoint Code", Code);
        if not HttpEndpointOAuthScope.IsEmpty() then
            HttpEndpointOAuthScope.DeleteAll();
    end;

    procedure GetRestClient() RestClient: Codeunit "Rest Client"
    var
        HttpEndpointRestClient: Codeunit "Http Endpoint Rest Client KFM";
    begin
        RestClient := HttpEndpointRestClient.GetRestClient(Rec);
    end;

    procedure GetRestClient(HttpClientHandler: Interface "Http Client Handler") RestClient: Codeunit "Rest Client"
    var
        HttpEndpointRestClient: Codeunit "Http Endpoint Rest Client KFM";
    begin
        RestClient := HttpEndpointRestClient.GetRestClient(Rec, HttpClientHandler);
    end;

    procedure GetHttpAuthentication() HttpAuthentication: Interface "Http Authentication"
    var
        HttpAuthenticationSettings: Interface "Http Authentication Settings KFM";
    begin
        HttpAuthenticationSettings := Rec.Authentication;
        HttpAuthentication := HttpAuthenticationSettings.GetHttpAuthentication(Rec);
    end;
}