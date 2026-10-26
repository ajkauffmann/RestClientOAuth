codeunit 50313 ClientCredentialsFlowImplKFM
{
    Access = Internal;

    var
        OAuthAuthenticationResult: Codeunit "OAuth AuthenticationResult KFM";
        OAuthAuthority: Interface "OAuth Authority KFM";

    procedure SetAuthority(Value: Interface "OAuth Authority KFM")
    begin
        OAuthAuthority := Value;
    end;

    procedure Initialize(Value: Interface "OAuth Authority KFM");
    begin
        SetAuthority(Value);
    end;

    procedure GetAuthorizationHeader(OAuthClientApplication: Codeunit "OAuth Application Config KFM") ReturnValue: SecretText;
    var
        OAuthConfidentialClient: Codeunit "OAuth Confidential Client KFM";
    begin
        if OAuthAuthenticationResult.IsValid() then
            exit(OAuthAuthenticationResult.GetAuthorizationHeader);

        OAuthAuthenticationResult := OAuthConfidentialClient.AcquireTokenForClient(OAuthAuthority, OAuthClientApplication);
        ReturnValue := OAuthAuthenticationResult.GetAuthorizationHeader();
    end;
}