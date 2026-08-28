codeunit 50315 "Microsoft Entra ID KFM" implements "OAuth Authority KFM"
{
    var
        MicrosoftEntraIDImpl: Codeunit "Microsoft Entra ID Impl. KFM";

    procedure Initialize(OAuthApplicationCode: Code[20]; TargetTenantId: Text)
    begin
        MicrosoftEntraIDImpl.Initialize(OAuthApplicationCode, TargetTenantId);
    end;

    procedure GetApplicationConfig(OAuthApplicationCode: Code[20]; ScopesList: List of [Text]) OAuthApplicationConfig: Codeunit "OAuth Application Config KFM"
    begin
        OAuthApplicationConfig := MicrosoftEntraIDImpl.GetApplicationConfig(OAuthApplicationCode, ScopesList)
    end;

    procedure GetAuthorizationEndpoint(OAuthClientApplication: Codeunit "OAuth Application Config KFM"): Text;
    begin
        exit(MicrosoftEntraIDImpl.GetAuthorizationEndpoint(OAuthClientApplication));
    end;

    procedure GetDeviceAuthorizationEndpoint(): Text;
    begin
        exit(MicrosoftEntraIDImpl.GetDeviceAuthorizationEndpoint());
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