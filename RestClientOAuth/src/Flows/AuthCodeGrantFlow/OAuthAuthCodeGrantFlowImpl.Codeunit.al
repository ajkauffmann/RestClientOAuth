codeunit 50314 AuthCodeGrantFlowImplKFM
{
    Access = Internal;

    var
        OAuthAuthenticationResult: Codeunit "OAuth AuthenticationResult KFM";
        OAuthAuthority: Interface "OAuth Authority KFM";
        PKCECodeVerifier: Text[128];
        OAuthClientType: Enum "OAuth Client Type KFM";
        PromptInteraction: Enum "Prompt Interaction";

    procedure SetPromptInteraction(Value: Enum "Prompt Interaction")
    begin
        PromptInteraction := Value;
    end;

    procedure GetPromptInteraction() Value: Enum "Prompt Interaction"
    begin
        Value := PromptInteraction;
    end;

    procedure SetOAuthClientType(Value: Enum "OAuth Client Type KFM")
    begin
        OAuthClientType := Value;
    end;

    procedure GetOAuthClientType() Value: Enum "OAuth Client Type KFM"
    begin
        Value := OAuthClientType;
    end;

    procedure SetAuthority(Value: Interface "OAuth Authority KFM")
    begin
        OAuthAuthority := Value;
    end;

    procedure GetAuthority() Value: Interface "OAuth Authority KFM"
    begin
        Value := OAuthAuthority;
    end;

    procedure Initialize(OAuthAuthorityValue: Interface "OAuth Authority KFM"; OAuthClientTypeValue: Enum "OAuth Client Type KFM"; PromptInteractionValue: Enum "Prompt Interaction");
    begin
        OAuthAuthority := OAuthAuthorityValue;
        OAuthClientType := OAuthClientTypeValue;
        PromptInteraction := PromptInteractionValue;
    end;

    procedure GetAuthorizationHeader(OAuthClientApplication: Codeunit "OAuth Application Config KFM"): SecretText
    begin
        if OAuthAuthenticationResult.IsValid() then
            exit(OAuthAuthenticationResult.GetAuthorizationHeader());

        if TryAcquireTokenByRefreshToken(OAuthClientApplication) then
            exit(OAuthAuthenticationResult.GetAuthorizationHeader());

        AcquireTokenByAuthorizationCode(OAuthClientApplication);
        exit(OAuthAuthenticationResult.GetAuthorizationHeader());
    end;

    local procedure AcquireTokenByAuthorizationCode(OAuthClientApplication: Codeunit "OAuth Application Config KFM")
    var
        OAuthClient: Interface "OAuth Client KFM";
        AuthorizationCode: Text;
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
        OAuthClient := OAuthClientType;
        OAuthAuthenticationResult := OAuthClient.AcquireTokenByAuthorizationCode(AuthorizationCode, PKCECodeVerifier, OAuthAuthority, OAuthClientApplication);
    end;

    [TryFunction]
    local procedure TryAcquireTokenByRefreshToken(OAuthClientApplication: Codeunit "OAuth Application Config KFM")
    var
        OAuthClient: Interface "OAuth Client KFM";
    begin
        if OAuthAuthenticationResult.RefreshToken().IsEmpty() then
            Error('');

        OAuthClient := OAuthClientType;
        OAuthAuthenticationResult := OAuthClient.AcquireTokenByRefreshToken(OAuthAuthenticationResult.RefreshToken(), OAuthAuthority, OAuthClientApplication);
    end;

    procedure GetPKCECodeChallenge() ReturnValue: Text
    var
        CryptographyMgt: Codeunit "Cryptography Management";
        HashAlgorithmType: Option MD5,SHA1,SHA256,SHA384,SHA512;
    begin
        // Verifier = BASE64URL(SHA256(two random GUIDs)).
        // Produces a 43-char string using the full Base64Url alphabet (A-Z / a-z / 0-9 / - / _),
        // all of which are RFC 7636 unreserved characters, with ~244 bits of input entropy.
        PKCECodeVerifier := CopyStr(
            CryptographyMgt.GenerateHashAsBase64String(
                Format(CreateGuid(), 0, 3) + Format(CreateGuid(), 0, 3),
                HashAlgorithmType::SHA256)
            .Replace('+', '-').Replace('/', '_').Replace('=', ''),
            1, MaxStrLen(PKCECodeVerifier));
        ReturnValue := CryptographyMgt.GenerateHashAsBase64String(PKCECodeVerifier, HashAlgorithmType::SHA256).Replace('+', '-').Replace('/', '_').Replace('=', '');
    end;
}