namespace Microsoft.Identity.Client;

using System.Reflection;
codeunit 50316 "Microsoft Entra ID Impl. KFM"
{
    Access = Internal;

    var
        TenantId: Text;
        AuthorizationEndpointTxt: Label 'https://login.microsoftonline.com/%1/oauth2/v2.0/authorize', Locked = true;
        TokenEndpointTxt: Label 'https://login.microsoftonline.com/%1/oauth2/v2.0/token', Locked = true;
        OrganizationsTxt: Label 'organizations', Locked = true;


    procedure Initialize(HttpEndpointOAuth20: Record "Http Endpoint OAuth 2.0 KFM")
    var
        EntraAppRegistration: Record "Entra App Registration KFM";
    begin
        EntraAppRegistration.Get(HttpEndpointOAuth20."OAuth Application Code");
        if EntraAppRegistration."Supported Account Types" = EntraAppRegistration."Supported Account Types"::MyOrg then
            TenantId := EntraAppRegistration."Publisher Tenant Id"
        else
            if HttpEndpointOAuth20."Target Entra Tenant Id" <> '' then
                TenantId := HttpEndpointOAuth20."Target Entra Tenant Id"
            else
                TenantId := OrganizationsTxt;
    end;

    procedure GetClientApplication(HttpEndpointOAuth20: Record "Http Endpoint OAuth 2.0 KFM") OAuthClientApplication: Codeunit "OAuth Client Application KFM"
    var
        EntraAppRegistration: Record "Entra App Registration KFM";
    begin
        OAuthClientApplication := EntraAppRegistration.GetOAuth2ClientApplication(HttpEndpointOAuth20."OAuth Application Code");
        OAuthClientApplication.SetScopes(HttpEndpointOAuth20.GetScopes());
    end;

    procedure SetTenantId(Value: Text)
    begin
        TenantId := Value;
    end;

    procedure GetAuthorizationEndpoint(OAuthClientApplication: Codeunit "OAuth Client Application KFM") Url: Text;
    var
        QueryString: TextBuilder;
    begin
        if TenantId = '' then
            TenantId := OrganizationsTxt;

        Url := StrSubstNo(AuthorizationEndpointTxt, TenantId);

        QueryString.Append('client_id=');
        QueryString.Append(OAuthClientApplication.GetClientId());
        QueryString.Append('&response_type=code');
        QueryString.Append('&response_mode=query');
        QueryString.Append('&scope=');
        QueryString.Append(OAuthClientApplication.GetUrlEncodedScopes());

        Url := Url + '?' + QueryString.ToText();
    end;

    procedure GetTokenEndpoint() Url: Text;
    begin
        Url := StrSubstNo(TokenEndpointTxt, TenantId);
    end;
}