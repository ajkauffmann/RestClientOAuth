codeunit 50301 "Http Authentication OAuth2 KFM" implements "Http Authentication"
{
    var
        HttpAuthenticationOAuth2Imp: Codeunit HttpAuthenticationOAuth2ImpKFM;

    procedure Initialize(ClientApplication: Codeunit "OAuth Application Config KFM"; AuthorizationFlow: Interface "OAuth Authorization Flow KFM")
    begin
        HttpAuthenticationOAuth2Imp.Initialize(ClientApplication, AuthorizationFlow);
    end;

    procedure IsAuthenticationRequired(): Boolean;
    begin
        exit(HttpAuthenticationOAuth2Imp.IsAuthenticationRequired());
    end;

    procedure GetAuthorizationHeaders() Headers: Dictionary of [Text, SecretText];
    begin
        Headers := HttpAuthenticationOAuth2Imp.GetAuthorizationHeaders();
    end;
}