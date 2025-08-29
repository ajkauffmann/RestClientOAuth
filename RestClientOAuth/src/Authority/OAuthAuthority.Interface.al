interface "OAuth Authority KFM"
{
    procedure Initialize(HttpEndpointOAuth20: Record "Http Endpoint OAuth 2.0 KFM")
    procedure GetClientApplication(HttpEndpointOAuth20: Record "Http Endpoint OAuth 2.0 KFM") OAuthClientApplication: Codeunit "OAuth Client Application KFM"
    procedure GetAuthorizationEndpoint(OAuthClientApplication: Codeunit "OAuth Client Application KFM"): Text
    procedure GetTokenEndpoint(): Text
}