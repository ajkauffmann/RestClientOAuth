codeunit 50301 "Http Authentication OAuth2 KFM" implements "Http Authentication"
{
    var
        HttpAuthenticationOAuth2Imp: Codeunit HttpAuthenticationOAuth2ImpKFM;

    procedure Initialize(HttpEndpointOAuth20: Record "Http Endpoint OAuth 2.0 KFM")
    begin
        HttpAuthenticationOAuth2Imp.Initialize(HttpEndpointOAuth20);
    end;

    procedure Initialize(ClientApplication: Codeunit "OAuth Client Application KFM"; AuthorizationFlow: Interface "OAuth Authorization Flow KFM")
    begin
        HttpAuthenticationOAuth2Imp.Initialize(ClientApplication, AuthorizationFlow);
    end;

    procedure IsAuthenticationRequired(): Boolean;
    begin
        exit(HttpAuthenticationOAuth2Imp.IsAuthenticationRequired());
    end;

    procedure GetAuthorizationHeaders() Headers: Dictionary of [Text, SecretText];
    begin
        Headers := HttpAuthenticationOAuth2Imp.GetAuthorizationHeaders()
    end;
}