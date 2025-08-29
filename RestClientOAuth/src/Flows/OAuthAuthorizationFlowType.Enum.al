enum 50301 "OAuthAuthorizationFlowType KFM" implements "OAuth Authorization Flow KFM"
{
    value(0; AuthorizationCode)
    {
        Caption = 'Authorization Code';
        Implementation = "OAuth Authorization Flow KFM" = "Auth. Code Grant Flow KFM";
    }
    value(1; ClientCredentials)
    {
        Caption = 'Client Credentials';
        Implementation = "OAuth Authorization Flow KFM" = "Client Credentials Flow KFM";
    }
}