codeunit 50312 OAuthAuthenticationRsltImplKFM
{
    Access = Internal;

    var
        TokenType: Text;
        AccessToken: SecretText;
        RefreshToken: SecretText;
        ExpiresAt: DateTime;

    // [NonDebuggable]
    procedure SetResponse(AuthenticationResponse: JsonObject)
    begin
        TokenType := GetJsonToken('token_type', AuthenticationResponse).AsValue().AsText();
        AccessToken := GetJsonToken('access_token', AuthenticationResponse).AsValue().AsText();
        RefreshToken := GetJsonToken('refresh_token', AuthenticationResponse).AsValue().AsText();
        if AuthenticationResponse.Contains('expires_in') then
            ExpiresAt := CurrentDateTime + (GetJsonToken('expires_in', AuthenticationResponse).AsValue().AsInteger() * 1000)
        else
            ExpiresAt := 0DT;
    end;

    procedure GetTokenType(): Text
    begin
        exit(TokenType);
    end;

    procedure GetAuthorizationHeader(): SecretText
    begin
        exit(SecretStrSubstNo('%1 %2', TokenType, AccessToken));
    end;

    procedure GetRefreshToken(): SecretText
    begin
        exit(RefreshToken);
    end;

    procedure IsValid() ReturnValue: Boolean
    begin
        if AccessToken.IsEmpty() then
            exit(false);

        exit(ExpiresAt > CurrentDateTime);
    end;

    [NonDebuggable]
    local procedure GetJsonToken(Path: Text; JsonObject: JsonObject) Result: JsonToken
    var
        DummyJsonValue: JsonValue;
    begin
        if not JsonObject.SelectToken(Path, Result) then begin
            DummyJsonValue.SetValue('');
            Result := DummyJsonValue.AsToken();
        end;
    end;
}