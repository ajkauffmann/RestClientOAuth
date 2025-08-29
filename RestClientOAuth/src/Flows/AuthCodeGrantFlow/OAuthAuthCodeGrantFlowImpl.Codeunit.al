codeunit 50314 AuthCodeGrantFlowImplKFM
{
    Access = Internal;

    var
        OAuthAuthenticationResult: Codeunit "OAuth AuthenticationResult KFM";
        OAuthAuthority: Interface "OAuth Authority KFM";
        AuthorizationCanceledMsg: Label 'The authorization was canceled.';
        PKCECodeVerifier: Text[128];
        PromptInteraction: Enum "Prompt Interaction";

    procedure SetPromptInteraction(Value: Enum "Prompt Interaction")
    begin
        PromptInteraction := Value;
    end;

    procedure GetPromptInteraction() Value: Enum "Prompt Interaction"
    begin
        Value := PromptInteraction;
    end;

    procedure SetAuthority(Value: Interface "OAuth Authority KFM")
    begin
        OAuthAuthority := Value;
    end;

    procedure GetAuthority() Value: Interface "OAuth Authority KFM"
    begin
        Value := OAuthAuthority;
    end;

    procedure Initialize(HttpEndpointOAuth20: Record "Http Endpoint OAuth 2.0 KFM");
    begin
        OAuthAuthority := HttpEndpointOAuth20.GetAuthority();
        PromptInteraction := HttpEndpointOAuth20."Prompt Interaction";
    end;

    procedure GetAuthorizationHeader(OAuthClientApplication: Codeunit "OAuth Client Application KFM"): SecretText
    begin
        if OAuthAuthenticationResult.IsValid() then
            exit(OAuthAuthenticationResult.GetAuthorizationHeader());

        if TryAcquireTokenByRefreshToken(OAuthClientApplication) then
            exit(OAuthAuthenticationResult.GetAuthorizationHeader());

        AcquireTokenByAuthorizationCode(OAuthClientApplication);
        exit(OAuthAuthenticationResult.GetAuthorizationHeader());
    end;

    local procedure AcquireTokenByAuthorizationCode(OAuthClientApplication: Codeunit "OAuth Client Application KFM")
    var
        OAuthConfidentialClient: Codeunit "OAuth Confidential Client KFM";
        AuthorizationCode: Text;
        AuthCodeErr: Text;
        ErrorText: Text;
        RedirectURIType: Enum "Redirect URI Type KFM";
        RedirectURI: Interface "Redirect URI KFM";
    begin
        if not OAuthClientApplication.GetScopes().Contains('offline_access') then
            OAuthClientApplication.AddScope('offline_access');

        RedirectURIType := OAuthClientApplication.GetRedirectUriType();
        if RedirectURIType = RedirectURIType::None then
            RedirectURIType := RedirectURIType::"Built-in";

        RedirectURI := RedirectURIType;
        AuthorizationCode := RedirectURI.GetAuthorizationCode(OAuthClientApplication, OAuthAuthority, PromptInteraction, GetPKCECodeChallenge());
        OAuthAuthenticationResult := OAuthConfidentialClient.AcquireTokenByAuthorizationCode(AuthorizationCode, PKCECodeVerifier, OAuthAuthority, OAuthClientApplication);
    end;

    [TryFunction]
    local procedure TryAcquireTokenByRefreshToken(OAuthClientApplication: Codeunit "OAuth Client Application KFM")
    var
        OAuthConfidentialClient: Codeunit "OAuth Confidential Client KFM";
    begin
        if OAuthAuthenticationResult.RefreshToken().IsEmpty() then
            Error('');

        OAuthAuthenticationResult := OAuthConfidentialClient.AcquireTokenByRefreshToken(OAuthAuthenticationResult.RefreshToken(), OAuthAuthority, OAuthClientApplication);
    end;

    procedure GetPKCECodeChallenge() ReturnValue: Text
    var
        CryptographyMgt: codeunit "Cryptography Management";
        HashAlgorithmType: Option MD5,SHA1,SHA256,SHA384,SHA512;
        AllowedChars: Text[66];
        AllowedCharsTxt: Label 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~', Locked = true;
        i: Integer;
    begin
        AllowedChars := AllowedCharsTxt;
        Randomize();

        PKCECodeVerifier := '';
        for i := 1 to MaxStrLen(PKCECodeVerifier) do
            PKCECodeVerifier += AllowedChars[Random(StrLen(AllowedChars))];

        ReturnValue := CryptographyMgt.GenerateHashAsBase64String(PKCECodeVerifier, HashAlgorithmType::SHA256).Replace('+', '-').Replace('/', '_').Replace('=', '');
    end;
}