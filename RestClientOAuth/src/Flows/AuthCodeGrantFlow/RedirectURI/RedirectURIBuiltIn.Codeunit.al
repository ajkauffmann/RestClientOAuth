codeunit 50325 "Redirect URI Built-in KFM" implements "Redirect URI KFM"
{
    procedure RedirectURIEditable(): Boolean
    begin
        exit(false);
    end;

    procedure GetDefaultRedirectURI() ReturnValue: Text
    var
        OAuth2: Codeunit OAuth2;
    begin
        OAuth2.GetDefaultRedirectURL(ReturnValue);
    end;

    procedure GetAuthorizationCode(OAuthClientApplication: Codeunit "OAuth Client Application KFM"; OAuthAuthority: Interface "OAuth Authority KFM"; PromptInteraction: Enum "Prompt Interaction"; PKCECodeChallenge: Text) AuthorizationCode: Text
    var
        AuthCodeGrantFlowBuiltin: Page AuthCodeGrantFlowBuiltinKFM;
        Url: Text;
        State: Text;
        AuthorizationCanceledMsg: Label 'The authorization was canceled.';
    begin
        State := Format(CreateGuid(), 0, 4);
        OAuthClientApplication.SetRedirectUri(GetDefaultRedirectURI());  // Important because the token request needs the redirect uri used for getting the authorization code
        Url := GetAuthorizationUrl(OAuthClientApplication, OAuthAuthority, PromptInteraction, PKCECodeChallenge, State);
        AuthorizationCode := AuthCodeGrantFlowBuiltin.GetAuthorizationCode(Url, State);

        if AuthCodeGrantFlowBuiltin.IsCanceledByUser() then
            Error(AuthorizationCanceledMsg);

        if AuthorizationCode = '' then
            Error(AuthCodeGrantFlowBuiltin.GetAuthError());
    end;

    local procedure GetAuthorizationUrl(OAuthClientApplication: Codeunit "OAuth Client Application KFM"; OAuthAuthority: Interface "OAuth Authority KFM"; PromptInteraction: Enum "Prompt Interaction"; PKCECodeChallenge: Text; State: Text) Url: Text
    var
        UrlBuilder: TextBuilder;
    begin
        UrlBuilder.Append(OAuthAuthority.GetAuthorizationEndpoint(OAuthClientApplication));
        UrlBuilder.Append('&redirect_uri=');
        UrlBuilder.Append(OAuthClientApplication.GetRedirectUri());
        if PKCECodeChallenge <> '' then begin
            UrlBuilder.Append('&code_challenge=');
            UrlBuilder.Append(PKCECodeChallenge);
        end;
        UrlBuilder.Append('&code_challenge_method=S256');
        UrlBuilder.Append('&state=');
        UrlBuilder.Append(State);
        case PromptInteraction of
            "Prompt Interaction"::Login:
                UrlBuilder.Append('&prompt=login');
            "Prompt Interaction"::Consent:
                UrlBuilder.Append('&prompt=consent');
            "Prompt Interaction"::"Select Account":
                UrlBuilder.Append('&prompt=select_account');
            "Prompt Interaction"::"Admin Consent":
                UrlBuilder.Append('&prompt=admin_consent');
        end;

        Url := UrlBuilder.ToText();
    end;

}