codeunit 50307 OAuthClientApplicationImplKFM
{
    Access = Internal;

    #region ClientId
    var
        ClientId: Text;

    procedure SetClientId(Value: Text)
    begin
        ClientId := Value;
    end;

    procedure GetClientId() Value: Text
    begin
        Value := ClientId;
    end;
    #endregion

    #region ClientSecret
    var
        ClientSecret: SecretText;

    procedure SetClientSecret(Value: SecretText)
    begin
        ClientSecret := Value;
    end;

    procedure GetClientSecret() Value: SecretText
    begin
        Value := ClientSecret;
    end;
    #endregion

    #region Certificate
    var
        Certificate: Codeunit "OAuth Certificate KFM";

    procedure SetCertificate(Value: Codeunit "OAuth Certificate KFM")
    begin
        Certificate := Value;
    end;

    procedure GetCertificate() Value: Codeunit "OAuth Certificate KFM"
    begin
        Value := Certificate;
    end;

    #endregion

    #region RedirectUri
    var
        RedirectUri: Text;
        RedirectURIType: Enum "Redirect URI Type KFM";

    procedure SetRedirectUri(Value: Text)
    begin
        RedirectUri := Value;
    end;

    procedure GetRedirectUri() Value: Text
    begin
        Value := RedirectUri;
    end;

    procedure SetRedirectUriType(Value: Enum "Redirect URI Type KFM")
    begin
        RedirectURIType := Value;
    end;

    procedure GetRedirectUriType() Value: Enum "Redirect URI Type KFM"
    begin
        Value := RedirectURIType;
    end;
    #endregion

    #region Scopes
    var
        Scopes: List of [Text];

    procedure AddScope(Scope: Text)
    begin
        Scopes.Add(Scope);
    end;

    procedure SetScopes(ScopesList: List of [Text])
    var
        Scope: Text;
    begin
        foreach Scope in ScopesList do
            Scopes.Add(Scope);
    end;

    procedure GetScopes() ReturnValue: List of [Text]
    begin
        ReturnValue := Scopes;
    end;

    procedure GetUrlEncodedScopes() UrlEncodedScopes: Text
    var
        TextBuilder: TextBuilder;
        Scope: Text;
    begin
        foreach Scope in Scopes do begin
            TextBuilder.Append(Scope);
            TextBuilder.Append(' ')
        end;
        UrlEncodedScopes := TextBuilder.ToText().Trim();
    end;
    #endregion
}