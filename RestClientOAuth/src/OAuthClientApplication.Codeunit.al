codeunit 50306 "OAuth Client Application KFM"
{
    var
        OAuthClientApplicationImpl: Codeunit OAuthClientApplicationImplKFM;

    #region ClientId
    procedure SetClientId(Value: Text)
    begin
        OAuthClientApplicationImpl.SetClientId(Value);
    end;

    procedure GetClientId() Value: Text
    begin
        Value := OAuthClientApplicationImpl.GetClientId();
    end;
    #endregion

    #region ClientSecret
    procedure SetClientSecret(Value: SecretText)
    begin
        OAuthClientApplicationImpl.SetClientSecret(Value);
    end;

    procedure GetClientSecret() Value: SecretText
    begin
        Value := OAuthClientApplicationImpl.GetClientSecret();
    end;
    #endregion

    #region Certificate
    procedure SetCertificate(Value: Codeunit "OAuth Certificate KFM")
    begin
        OAuthClientApplicationImpl.SetCertificate(Value);
    end;

    procedure GetCertificate() Value: Codeunit "OAuth Certificate KFM"
    begin
        Value := OAuthClientApplicationImpl.GetCertificate();
    end;
    #endregion

    #region RedirectUri
    procedure SetRedirectUri(Value: Text)
    begin
        OAuthClientApplicationImpl.SetRedirectUri(Value);
    end;

    procedure GetRedirectUri() Value: Text
    begin
        Value := OAuthClientApplicationImpl.GetRedirectUri();
    end;

    procedure SetRedirectUriType(Value: Enum "Redirect URI Type KFM")
    begin
        OAuthClientApplicationImpl.SetRedirectUriType(Value);
    end;

    procedure GetRedirectUriType() Value: Enum "Redirect URI Type KFM"
    begin
        Value := OAuthClientApplicationImpl.GetRedirectUriType();
    end;
    #endregion

    #region Scopes
    procedure AddScope(Scope: Text)
    begin
        OAuthClientApplicationImpl.AddScope(Scope);
    end;

    procedure SetScopes(ScopesList: List of [Text])
    begin
        OAuthClientApplicationImpl.SetScopes(ScopesList);
    end;

    procedure GetScopes() ReturnValue: List of [Text]
    begin
        ReturnValue := OAuthClientApplicationImpl.GetScopes();
    end;

    procedure GetUrlEncodedScopes() UrlEncodedScopes: Text
    begin
        UrlEncodedScopes := OAuthClientApplicationImpl.GetUrlEncodedScopes();
    end;
    #endregion
}