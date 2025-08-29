codeunit 50303 HttpAuthenticationOAuth2ImpKFM
{
    Access = Internal;

    var
        OAuthClientApplication: Codeunit "OAuth Client Application KFM";
        OAuthAuthorizationFlow: Interface "OAuth Authorization Flow KFM";

    procedure Initialize(HttpEndpointOAuth20: Record "Http Endpoint OAuth 2.0 KFM")
    begin
        OAuthClientApplication := HttpEndpointOAuth20.GetClientApplication();
        OAuthAuthorizationFlow := HttpEndpointOAuth20.GetAuthorizationFlow();
    end;

    procedure Initialize(ClientApplication: Codeunit "OAuth Client Application KFM"; AuthorizationFlow: Interface "OAuth Authorization Flow KFM")
    begin
        OAuthClientApplication := ClientApplication;
        OAuthAuthorizationFlow := AuthorizationFlow;
    end;

    procedure IsAuthenticationRequired(): Boolean;
    begin
        exit(true);
    end;

    procedure GetAuthorizationHeaders() Headers: Dictionary of [Text, SecretText];
    begin
        Headers.Add('Authorization', OAuthAuthorizationFlow.GetAuthorizationHeader(OAuthClientApplication));
    end;
}