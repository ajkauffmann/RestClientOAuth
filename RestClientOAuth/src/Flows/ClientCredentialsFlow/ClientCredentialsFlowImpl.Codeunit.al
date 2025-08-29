codeunit 50313 ClientCredentialsFlowImplKFM
{
    Access = Internal;

    var
        OAuthAuthority: Interface "OAuth Authority KFM";
        OAuthAuthenticationResult: Codeunit "OAuth AuthenticationResult KFM";

    procedure SetAuthority(Value: Interface "OAuth Authority KFM")
    begin
        OAuthAuthority := Value;
    end;

    procedure Initialize(HttpEndpointOAuth20: Record "Http Endpoint OAuth 2.0 KFM");
    begin
        OAuthAuthority := HttpEndpointOAuth20.GetAuthority();
    end;

    procedure GetAuthorizationHeader(OAuthClientApplication: Codeunit "OAuth Client Application KFM") ReturnValue: SecretText;
    var
        OAuthConfidentialClient: Codeunit "OAuth Confidential Client KFM";
    begin
        if OAuthAuthenticationResult.IsValid() then
            exit(OAuthAuthenticationResult.GetAuthorizationHeader);

        OAuthAuthenticationResult := OAuthConfidentialClient.AcquireTokenForClient(OAuthAuthority, OAuthClientApplication);
        ReturnValue := OAuthAuthenticationResult.GetAuthorizationHeader();
    end;
}