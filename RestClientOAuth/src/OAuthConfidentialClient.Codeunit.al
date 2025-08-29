codeunit 50302 "OAuth Confidential Client KFM"
{
    var
        OAuthConfidentialClientImpl: Codeunit OAuthConfidentialClientImplKFM;

    procedure AcquireTokenByAuthorizationCode(AuthorizationCode: SecretText; OAuthAuthority: Interface "OAuth Authority KFM"; OAuthClientApplication: Codeunit "OAuth Client Application KFM") AuthenticationResult: Codeunit "OAuth AuthenticationResult KFM"
    begin
        AuthenticationResult := OAuthConfidentialClientImpl.AcquireTokenByAuthorizationCode(AuthorizationCode, OAuthAuthority, OAuthClientApplication);
    end;

    procedure AcquireTokenByAuthorizationCode(AuthorizationCode: SecretText; VerifierCode: SecretText; OAuthAuthority: Interface "OAuth Authority KFM"; OAuthClientApplication: Codeunit "OAuth Client Application KFM") AuthenticationResult: Codeunit "OAuth AuthenticationResult KFM"
    begin
        AuthenticationResult := OAuthConfidentialClientImpl.AcquireTokenByAuthorizationCode(AuthorizationCode, VerifierCode, OAuthAuthority, OAuthClientApplication);
    end;

    procedure AcquireTokenByRefreshToken(RefreshToken: SecretText; OAuthAuthority: Interface "OAuth Authority KFM"; OAuthClientApplication: Codeunit "OAuth Client Application KFM") AuthenticationResult: Codeunit "OAuth AuthenticationResult KFM"
    begin
        AuthenticationResult := OAuthConfidentialClientImpl.AcquireTokenByRefreshToken(RefreshToken, OAuthAuthority, OAuthClientApplication);
    end;

    procedure AcquireTokenForClient(OAuthAuthority: Interface "OAuth Authority KFM"; OAuthClientApplication: Codeunit "OAuth Client Application KFM") AuthenticationResult: Codeunit "OAuth AuthenticationResult KFM"
    begin
        AuthenticationResult := OAuthConfidentialClientImpl.AcquireTokenForClient(OAuthAuthority, OAuthClientApplication);
    end;
}