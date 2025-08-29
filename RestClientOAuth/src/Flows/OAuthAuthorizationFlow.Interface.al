interface "OAuth Authorization Flow KFM"
{
    procedure Initialize(HttpEndpointOAuth20: Record "Http Endpoint OAuth 2.0 KFM")
    procedure GetAuthorizationHeader(OAuthClientApplication: Codeunit "OAuth Client Application KFM"): SecretText
}