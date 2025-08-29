codeunit 50304 "Client Credentials Flow KFM" implements "OAuth Authorization Flow KFM"
{
    var
        ClientCredentialsFlowImpl: Codeunit ClientCredentialsFlowImplKFM;

    procedure SetAuthority(Value: Interface "OAuth Authority KFM")
    begin
        ClientCredentialsFlowImpl.SetAuthority(Value);
    end;

    procedure Initialize(HttpEndpointOAuth20: Record "Http Endpoint OAuth 2.0 KFM");
    begin
        ClientCredentialsFlowImpl.Initialize(HttpEndpointOAuth20);
    end;

    procedure GetAuthorizationHeader(OAuthClientApplication: Codeunit "OAuth Client Application KFM") ReturnValue: SecretText;
    begin
        ReturnValue := ClientCredentialsFlowImpl.GetAuthorizationHeader(OAuthClientApplication);
    end;
}