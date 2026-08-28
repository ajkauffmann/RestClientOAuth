codeunit 50316 "Microsoft Entra ID Impl. KFM"
{
    Access = Internal;

    var
        TenantId: Text;
        AuthorizationEndpointTxt: Label 'https://login.microsoftonline.com/%1/oauth2/v2.0/authorize', Locked = true;
        DeviceAuthorizationEndpointTxt: Label 'https://login.microsoftonline.com/%1/oauth2/v2.0/devicecode', Locked = true;
        TokenEndpointTxt: Label 'https://login.microsoftonline.com/%1/oauth2/v2.0/token', Locked = true;
        OrganizationsTxt: Label 'organizations', Locked = true;


    procedure Initialize(OAuthApplicationCode: Code[20]; TargetTenantId: Text)
    var
        EntraAppRegistration: Record "Entra App Registration KFM";
    begin
        TenantId := '';

        if OAuthApplicationCode <> '' then begin
            EntraAppRegistration.Get(OAuthApplicationCode);
            if EntraAppRegistration."Supported Account Types" = EntraAppRegistration."Supported Account Types"::MyOrg then begin
                TenantId := EntraAppRegistration."Publisher Tenant Id";
                exit;
            end;
        end;

        if TargetTenantId <> '' then
            TenantId := TargetTenantId
        else
            TenantId := OrganizationsTxt;
    end;

    procedure GetApplicationConfig(OAuthApplicationCode: Code[20]; ScopesList: List of [Text]) OAuthApplicationConfig: Codeunit "OAuth Application Config KFM"
    var
        EntraAppRegistration: Record "Entra App Registration KFM";
    begin
        OAuthApplicationConfig := EntraAppRegistration.GetOAuthApplicationConfig(OAuthApplicationCode);
        OAuthApplicationConfig.SetScopes(ScopesList);
    end;

    procedure SetTenantId(Value: Text)
    begin
        TenantId := Value;
    end;

    procedure GetAuthorizationEndpoint(OAuthClientApplication: Codeunit "OAuth Application Config KFM") Url: Text;
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
        if TenantId = '' then
            TenantId := OrganizationsTxt;

        Url := StrSubstNo(TokenEndpointTxt, TenantId);
    end;

    procedure GetDeviceAuthorizationEndpoint() Url: Text;
    begin
        if TenantId = '' then
            TenantId := OrganizationsTxt;

        Url := StrSubstNo(DeviceAuthorizationEndpointTxt, TenantId);
    end;
}