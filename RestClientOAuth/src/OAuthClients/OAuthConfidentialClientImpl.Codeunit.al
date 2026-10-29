codeunit 50308 OAuthConfidentialClientImplKFM
{
    Access = Internal;

    var
        RestClient: Codeunit "Rest Client";
        Base64Convert: Codeunit "Base64 Convert";
        CryptographyManagement: Codeunit "Cryptography Management";
        TimeHelper: Codeunit TimeHelper;
        RestClientInitialized: Boolean;

    procedure AcquireTokenByAuthorizationCode(AuthorizationCode: SecretText; OAuthAuthority: Interface "OAuth Authority KFM"; OAuthClientApplication: Codeunit "OAuth Application Config KFM") AuthenticationResult: Codeunit "OAuth AuthenticationResult KFM"
    begin
        AuthenticationResult := AcquireTokenByAuthorizationCode(AuthorizationCode, SecretStrSubstNo(''), OAuthAuthority, OAuthClientApplication);
    end;

    procedure AcquireTokenByAuthorizationCode(AuthorizationCode: SecretText; VerifierCode: SecretText; OAuthAuthority: Interface "OAuth Authority KFM"; OAuthClientApplication: Codeunit "OAuth Application Config KFM") AuthenticationResult: Codeunit "OAuth AuthenticationResult KFM"
    var
        AccessTokenRequest: TextBuilder;
        AccessTokenRequestTxt: SecretText;
    begin
        AccessTokenRequest.Append('grant_type=authorization_code');
        AccessTokenRequest.Append('&client_id=');
        AccessTokenRequest.Append(OAuthClientApplication.GetClientId());
        AccessTokenRequest.Append('&scope=');
        AccessTokenRequest.Append(OAuthClientApplication.GetUrlEncodedScopes());
        AccessTokenRequest.Append('&code=%1');
        AccessTokenRequest.Append('&redirect_uri=');
        AccessTokenRequest.Append(OAuthClientApplication.GetRedirectUri());
        if not VerifierCode.IsEmpty() then
            AccessTokenRequest.Append('&code_verifier=%2');

        AccessTokenRequestTxt := SecretStrSubstNo(AccessTokenRequest.ToText(), AuthorizationCode, VerifierCode);
        AuthenticationResult := SendTokenRequest(AccessTokenRequestTxt, OAuthAuthority, OAuthClientApplication);
    end;

    procedure AcquireTokenByRefreshToken(RefreshToken: SecretText; OAuthAuthority: Interface "OAuth Authority KFM"; OAuthClientApplication: Codeunit "OAuth Application Config KFM") AuthenticationResult: Codeunit "OAuth AuthenticationResult KFM"
    var
        AccessTokenRequest: TextBuilder;
        AccessTokenRequestTxt: SecretText;
    begin
        AccessTokenRequest.Append('grant_type=refresh_token');
        AccessTokenRequest.Append('&client_id=');
        AccessTokenRequest.Append(OAuthClientApplication.GetClientId());
        AccessTokenRequest.Append('&scope=');
        AccessTokenRequest.Append(OAuthClientApplication.GetUrlEncodedScopes());
        AccessTokenRequest.Append('&refresh_token=%1');

        AccessTokenRequestTxt := SecretStrSubstNo(AccessTokenRequest.ToText(), RefreshToken);
        AuthenticationResult := SendTokenRequest(AccessTokenRequestTxt, OAuthAuthority, OAuthClientApplication);
    end;

    procedure AcquireTokenForClient(OAuthAuthority: Interface "OAuth Authority KFM"; OAuthClientApplication: Codeunit "OAuth Application Config KFM") AuthenticationResult: Codeunit "OAuth AuthenticationResult KFM"
    var
        AccessTokenRequest: TextBuilder;
    begin
        AccessTokenRequest.Append('grant_type=client_credentials');
        AccessTokenRequest.Append('&client_id=');
        AccessTokenRequest.Append(OAuthClientApplication.GetClientId());
        AccessTokenRequest.Append('&scope=');
        AccessTokenRequest.Append(OAuthClientApplication.GetUrlEncodedScopes());

        AuthenticationResult := SendTokenRequest(AccessTokenRequest.ToText(), OAuthAuthority, OAuthClientApplication);
    end;

    local procedure SendTokenRequest(AccessTokenRequest: SecretText; OAuthAuthority: Interface "OAuth Authority KFM"; OAuthClientApplication: Codeunit "OAuth Application Config KFM") AuthenticationResult: Codeunit "OAuth AuthenticationResult KFM"
    var
        HttpRequestMessage: Codeunit "Http Request Message";
        HttpResponseMessage: Codeunit "Http Response Message";
        HttpContent: Codeunit "Http Content";
        AccessTokenRequestTxt: SecretText;
        TokenRequestErr: Label 'The token request failed. Error: %1. Description: %2', Comment = '%1 = The OAuth error code, %2 = The OAuth error description';
        ErrorCode: Text;
        ErrorDescription: Text;
    begin
        AccessTokenRequestTxt := FinishTokenRequest(AccessTokenRequest, OAuthAuthority, OAuthClientApplication);
        HttpContent := HttpContent.Create(AccessTokenRequestTxt, 'application/x-www-form-urlencoded');

        InitializeRestClient();
        HttpResponseMessage := RestClient.Post(OAuthAuthority.GetTokenEndpoint(), HttpContent);

        if not HttpResponseMessage.GetIsSuccessStatusCode() then begin
            SetOAuthError(HttpResponseMessage, ErrorCode, ErrorDescription);
            if (ErrorCode <> '') or (ErrorDescription <> '') then
                Error(TokenRequestErr, ErrorCode, ErrorDescription)
            else
                Error(ErrorInfo.Create(HttpResponseMessage.GetErrorMessage(), true));
        end else
            AuthenticationResult.SetResponse(HttpResponseMessage.GetContent().AsJson().AsObject());
    end;

    local procedure SetOAuthError(HttpResponseMessage: Codeunit "Http Response Message"; var ErrorCode: Text; var ErrorDescription: Text)
    var
        AuthenticationResponse: JsonObject;
    begin
        AuthenticationResponse := HttpResponseMessage.GetContent().AsJson().AsObject();
        ErrorCode := GetJsonToken('error', AuthenticationResponse).AsValue().AsText();
        ErrorDescription := GetJsonToken('error_description', AuthenticationResponse).AsValue().AsText();
    end;

    local procedure GetJsonToken(Path: Text; JsonObject: JsonObject) Result: JsonToken
    var
        DummyJsonValue: JsonValue;
    begin
        if not JsonObject.SelectToken(Path, Result) then begin
            DummyJsonValue.SetValue('');
            Result := DummyJsonValue.AsToken();
        end;
    end;

    local procedure FinishTokenRequest(AccessTokenRequest: SecretText; OAuthAuthority: Interface "OAuth Authority KFM"; OAuthClientApplication: Codeunit "OAuth Application Config KFM") ReturnValue: SecretText
    var
        DataEncryptionHelper: Codeunit "Data Encryption Helper KFM";
        SignatureTextBuilder: TextBuilder;
    begin
        if OAuthClientApplication.GetCertificate().HasValue() then begin
            SignatureTextBuilder.Append('&client_assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer');
            SignatureTextBuilder.Append('&client_assertion=');
            SignatureTextBuilder.Append(SignTokenRequest(OAuthAuthority, OAuthClientApplication));
            ReturnValue := SecretStrSubstNo('%1%2', AccessTokenRequest, SignatureTextBuilder.ToText());
        end else
            ReturnValue := SecretStrSubstNo('%1&client_secret=%2', AccessTokenRequest, DataEncryptionHelper.Decrypt(OAuthClientApplication.GetClientSecret()));
    end;

    local procedure SignTokenRequest(OAuthAuthority: Interface "OAuth Authority KFM"; OAuthClientApplication: Codeunit "OAuth Application Config KFM") Jwt: Text;
    var
        Signature: Codeunit "Temp Blob";
        DataEncryptionHelper: Codeunit "Data Encryption Helper KFM";
        OutStream: OutStream;
        InStream: InStream;
        JsonHeader, JsonClaims : JsonObject;
        JsonText, Thumbprint, SignatureBase64 : Text;
        Now: DateTime;
    begin
        JsonHeader.Add('alg', 'RS256');
        JsonHeader.Add('typ', 'JWT');
        JsonHeader.Add('x5t', OAuthClientApplication.GetCertificate().ThumbprintBase64());
        JsonHeader.WriteTo(JsonText);
        Jwt := Base64UrlEncode(Base64Convert.ToBase64(JsonText));

        Now := CurrentDateTime();
        JsonClaims.Add('aud', OAuthAuthority.GetTokenEndpoint());
        JsonClaims.Add('exp', TimeHelper.GetEpochTimestamp(Now + (5 * 60000)));
        JsonClaims.Add('iss', OAuthClientApplication.GetClientId());
        JsonClaims.Add('jti', Format(CreateGuid(), 0, 4).ToLower());
        JsonClaims.Add('nbf', TimeHelper.GetEpochTimestamp(Now - 60000));
        JsonClaims.Add('sub', OAuthClientApplication.GetClientId());
        JsonClaims.Add('iat', TimeHelper.GetEpochTimestamp(Now));
        JsonClaims.WriteTo(JsonText);
        Jwt := Jwt + '.' + Base64UrlEncode(Base64Convert.ToBase64(JsonText));

        Signature.CreateOutStream(OutStream);
        CryptographyManagement.SignData(Jwt, DataEncryptionHelper.Decrypt(OAuthClientApplication.GetCertificate().GetPrivateKey()), Enum::"Hash Algorithm"::SHA256, OutStream);

        Signature.CreateInStream(InStream);
        SignatureBase64 := Base64UrlEncode(Base64Convert.ToBase64(InStream));
        Jwt := Jwt + '.' + SignatureBase64;
    end;

    local procedure Base64UrlEncode(Input: Text) Output: Text
    begin
        Output := Input.Replace('+', '-')
                       .Replace('/', '_')
                       .Replace('=', '');
    end;

    local procedure InitializeRestClient()
    var
        HttpClientHandler: Codeunit "Http Client Handler KFM";
    begin
        if RestClientInitialized then
            exit;

        RestClient.Initialize(HttpClientHandler);
        RestClientInitialized := true;
    end;
}