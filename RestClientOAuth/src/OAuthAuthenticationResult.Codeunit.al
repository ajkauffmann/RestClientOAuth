codeunit 50309 "OAuth AuthenticationResult KFM"
{
    var
        OAuthAuthenticationRsltImpl: Codeunit OAuthAuthenticationRsltImplKFM;

    // [NonDebuggable]
    procedure SetResponse(NewAuthenticationResponse: JsonObject)
    begin
        OAuthAuthenticationRsltImpl.SetResponse(NewAuthenticationResponse);
    end;

    procedure TokenType() ReturnValue: Text
    begin
        ReturnValue := OAuthAuthenticationRsltImpl.GetTokenType();
    end;

    procedure GetAuthorizationHeader() ReturnValue: SecretText
    begin
        ReturnValue := OAuthAuthenticationRsltImpl.GetAuthorizationHeader();
    end;

    procedure RefreshToken() ReturnValue: SecretText
    begin
        ReturnValue := OAuthAuthenticationRsltImpl.GetRefreshToken();
    end;

    procedure IsValid() ReturnValue: Boolean
    begin
        ReturnValue := OAuthAuthenticationRsltImpl.IsValid();
    end;
}