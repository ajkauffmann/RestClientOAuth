namespace Microsoft.Identity.Client;
codeunit 50315 "Microsoft Entra ID KFM" implements "OAuth Authority KFM"
{
    var
        MicrosoftEntraIDImpl: Codeunit "Microsoft Entra ID Impl. KFM";

    procedure Initialize(HttpEndpointOAuth20: Record "Http Endpoint OAuth 2.0 KFM")
    begin
        MicrosoftEntraIDImpl.Initialize(HttpEndpointOAuth20);
    end;

    procedure GetClientApplication(HttpEndpointOAuth20: Record "Http Endpoint OAuth 2.0 KFM") OAuthClientApplication: Codeunit "OAuth Client Application KFM"
    begin
        OAuthClientApplication := MicrosoftEntraIDImpl.GetClientApplication(HttpEndpointOAuth20)
    end;

    procedure GetAuthorizationEndpoint(OAuthClientApplication: Codeunit "OAuth Client Application KFM"): Text;
    begin
        exit(MicrosoftEntraIDImpl.GetAuthorizationEndpoint(OAuthClientApplication));
    end;

    procedure GetTokenEndpoint(): Text;
    begin
        exit(MicrosoftEntraIDImpl.GetTokenEndpoint());
    end;

    procedure SetTenantID(Value: Text)
    begin
        MicrosoftEntraIDImpl.SetTenantId(Value);
    end;
}