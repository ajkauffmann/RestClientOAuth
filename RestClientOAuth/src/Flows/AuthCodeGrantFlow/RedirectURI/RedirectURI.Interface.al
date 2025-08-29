interface "Redirect URI KFM"
{
    procedure RedirectURIEditable(): Boolean;
    procedure GetDefaultRedirectURI(): Text;
    procedure GetAuthorizationCode(OAuthClientApplication: Codeunit "OAuth Client Application KFM"; OAuthAuthority: Interface "OAuth Authority KFM"; PromptInteraction: Enum "Prompt Interaction"; PKCECodeChallenge: Text): Text;
}