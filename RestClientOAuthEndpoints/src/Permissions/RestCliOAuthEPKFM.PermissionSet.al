permissionset 50350 "RestCliOAuthEP KFM"
{
    Caption = 'REST Client OAuth Endpoints', Locked = true;
    Assignable = true;
    Permissions = table "Http Endpoint Basic Auth. KFM" = X,
tabledata "Http Endpoint Basic Auth. KFM" = RIMD,
        table "Http Endpoint KFM" = X,
        tabledata "Http Endpoint KFM" = RIMD,
        table "Http Endpoint OAuth 2.0 KFM" = X,
        tabledata "Http Endpoint OAuth 2.0 KFM" = RIMD,
        table "Http Endpoint OAuth Scope KFM" = X,
        tabledata "Http Endpoint OAuth Scope KFM" = RIMD,
        codeunit "Http Endpoint Anonymous KFM" = X,
        codeunit "Http Endpoint Basic Auth. KFM" = X,
        codeunit "Http Endpoint OAuth 2.0 KFM" = X,
        codeunit "Http Endpoint Rest Client KFM" = X,
        page HttpEndpointBasicAuthSubfrmKFM = X,
        page "Http Endpoint Card KFM" = X,
        page "Http Endpoint List KFM" = X,
        page HttpEndpointOAuthScopesKFM = X,
        page HttpEndpointOAuthSubformKFM = X;
}