codeunit 50318 "Environment Cleanup KFM"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Environment Cleanup", OnClearCompanyConfig, '', false, false)]
    internal procedure OnClearCompanyConfig(CompanyName: Text; SourceEnv: Enum "Environment Type"; DestinationEnv: Enum "Environment Type")
    begin
        if (SourceEnv = SourceEnv::Production) and (DestinationEnv = DestinationEnv::Sandbox) then
            CleanupEnvironment();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Environment Cleanup", OnClearDatabaseConfig, '', false, false)]
    internal procedure OnClearDatabaseConfig(SourceEnv: Enum "Environment Type"; DestinationEnv: Enum "Environment Type")
    begin
    end;

    local procedure CleanupEnvironment()
    var
        EntraCertificate: Record "Entra Certificate KFM";
        EntraSecret: Record "Entra Secret KFM";
    begin
        if EntraCertificate.FindSet() then
            repeat
                EntraCertificate.SetCertificate('');
                EntraCertificate.SetPrivateKey('');
                EntraCertificate.Modify();
            until EntraCertificate.Next() = 0;
            
        if EntraSecret.FindSet() then
            repeat
                EntraSecret.SetSecretText('');
                EntraSecret.Modify();
            until EntraSecret.Next() = 0;
    end;
}