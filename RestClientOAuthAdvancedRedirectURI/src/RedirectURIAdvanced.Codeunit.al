codeunit 50400 "Redirect URI Advanced KFM" implements "Redirect URI KFM"
{
    procedure RedirectURIEditable(): Boolean
    begin
        exit(false);
    end;

    procedure GetDefaultRedirectURI() ReturnValue: Text
    var
        DefaultRedirectURITxt: Label 'https://msdyn365bc.z6.web.core.windows.net/oauthlanding.html', Locked = true;
    begin
        ReturnValue := DefaultRedirectURITxt;
    end;

    procedure GetAuthorizationCode(OAuthClientApplication: Codeunit "OAuth Client Application KFM"; OAuthAuthority: Interface "OAuth Authority KFM"; PromptInteraction: Enum "Prompt Interaction"; PKCECodeChallenge: Text) AuthorizationCode: Text
    var
        AuthCodeGrantFlowAdvanced: Page AuthCodeGrantFlowAdvancedKFM;
        AuthorizationCanceledMsg: Label 'The authorization was canceled.';
    begin
        OAuthClientApplication.SetRedirectUri(GetDefaultRedirectURI());
        AuthorizationCode := AuthCodeGrantFlowAdvanced.GetAuthorizationCode(GetAuthorizationParams(OAuthClientApplication, OAuthAuthority, PromptInteraction, PKCECodeChallenge));
        if AuthCodeGrantFlowAdvanced.IsCanceledByUser() then
            Error(AuthorizationCanceledMsg);

        if AuthorizationCode = '' then
            Error(AuthCodeGrantFlowAdvanced.GetAuthorizationError());
    end;

    local procedure GetAuthorizationParams(OAuthClientApplication: Codeunit "OAuth Client Application KFM"; OAuthAuthority: Interface "OAuth Authority KFM"; PromptInteraction: Enum "Prompt Interaction"; PKCECodeChallenge: Text) Params: Text
    var
        JObj: JsonObject;
    begin
        JObj.Add('authorization_endpoint', OAuthAuthority.GetAuthorizationEndpoint(OAuthClientApplication));
        JObj.Add('redirect_uri', OAuthClientApplication.GetRedirectUri());
        JObj.Add('code_challenge', PKCECodeChallenge);
        JObj.Add('code_challenge_method', 'S256');
        case PromptInteraction of
            "Prompt Interaction"::Login:
                JObj.Add('prompt', 'login');
            "Prompt Interaction"::Consent:
                JObj.Add('prompt', 'consent');
            "Prompt Interaction"::"Select Account":
                JObj.Add('prompt', 'select_account');
            "Prompt Interaction"::"Admin Consent":
                JObj.Add('prompt', 'admin_consent');
        end;
        JObj.WriteTo(Params);
    end;

}