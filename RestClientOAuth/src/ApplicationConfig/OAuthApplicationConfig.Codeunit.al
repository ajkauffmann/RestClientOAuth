codeunit 50306 "OAuth Application Config KFM"
{
    var
        OAuthApplicationConfigImpl: Codeunit OAuthApplicationConfigImplKFM;

    #region ClientId
    procedure SetClientId(Value: Text)
    begin
        OAuthApplicationConfigImpl.SetClientId(Value);
    end;

    procedure GetClientId() Value: Text
    begin
        Value := OAuthApplicationConfigImpl.GetClientId();
    end;
    #endregion

    #region ClientSecret
    procedure SetClientSecret(Value: Text)
    begin
        OAuthApplicationConfigImpl.SetClientSecret(Value);
    end;

    procedure GetClientSecret() Value: Text
    begin
        Value := OAuthApplicationConfigImpl.GetClientSecret();
    end;
    #endregion

    #region Certificate
    procedure SetCertificate(Value: Codeunit "OAuth Certificate KFM")
    begin
        OAuthApplicationConfigImpl.SetCertificate(Value);
    end;

    procedure GetCertificate() Value: Codeunit "OAuth Certificate KFM"
    begin
        Value := OAuthApplicationConfigImpl.GetCertificate();
    end;
    #endregion

    #region RedirectUri
    procedure SetRedirectUri(Value: Text)
    begin
        OAuthApplicationConfigImpl.SetRedirectUri(Value);
    end;

    procedure GetRedirectUri() Value: Text
    begin
        Value := OAuthApplicationConfigImpl.GetRedirectUri();
    end;

    procedure SetRedirectUriType(Value: Enum "Redirect URI Type KFM")
    begin
        OAuthApplicationConfigImpl.SetRedirectUriType(Value);
    end;

    procedure GetRedirectUriType() Value: Enum "Redirect URI Type KFM"
    begin
        Value := OAuthApplicationConfigImpl.GetRedirectUriType();
    end;
    #endregion

    #region Scopes
    procedure AddScope(Scope: Text)
    begin
        OAuthApplicationConfigImpl.AddScope(Scope);
    end;

    procedure SetScopes(ScopesList: List of [Text])
    begin
        OAuthApplicationConfigImpl.SetScopes(ScopesList);
    end;

    procedure GetScopes() ReturnValue: List of [Text]
    begin
        ReturnValue := OAuthApplicationConfigImpl.GetScopes();
    end;

    procedure GetUrlEncodedScopes() UrlEncodedScopes: Text
    begin
        UrlEncodedScopes := OAuthApplicationConfigImpl.GetUrlEncodedScopes();
    end;
    #endregion
}