table 50304 "Entra App Registration KFM"
{
    Caption = 'Microsoft Entra App Registation';
    DataPerCompany = false;
    ReplicateData = false;
    LookupPageId = "Entra App Registr. List KFM";

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = SystemMetadata;
            NotBlank = true;
        }
        field(2; "Display Name"; Text[100])
        {
            Caption = 'Display name';
            DataClassification = CustomerContent;
        }
        field(3; "App ID"; Text[36])
        {
            Caption = 'Application (client) ID';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                Guid: Guid;
            begin
                if Rec."App ID" = '' then
                    exit;
                Evaluate(Guid, Rec."App ID");
                Rec."App ID" := Format(Guid, 0, 4).ToLower();
            end;
        }
        field(4; "Publisher Tenant Id"; Text[100])
        {
            Caption = 'Publisher tenant ID';
            DataClassification = CustomerContent;
            ToolTip = 'The full qualified domain name or the id of the Azure Active Directory where this app has been registered.';

            trigger OnValidate()
            var
                Guid: Guid;
            begin
                if Evaluate(Guid, Rec."Publisher Tenant Id") then
                    Rec."Publisher Tenant Id" := Format(Guid, 0, 4).ToLower();
            end;
        }
        field(5; "Supported Account Types"; Enum EntraSupportedAccountTypesKFM)
        {
            Caption = 'Supported account types';
            DataClassification = CustomerContent;
        }
        field(6; "Certificate Code"; Code[20])
        {
            Caption = 'Certificate code';
            TableRelation = "Entra Certificate KFM";
            DataClassification = CustomerContent;
        }
        field(7; "Redirect Uri Type"; Enum "Redirect URI Type KFM")
        {
            Caption = 'Use built-in redirect uri';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                RedirectURI: Interface "Redirect URI KFM";
            begin
                RedirectURI := "Redirect Uri Type";
                "Redirect Uri" := RedirectURI.GetDefaultRedirectURI();
            end;
        }
        field(8; "Redirect Uri"; Text[250])
        {
            Caption = 'Redirect uri';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    var
        RequiredResourceAccessCollection: Dictionary of [Text, Dictionary of [Text, Text]];
        PublicClientRedirectUris: List of [Text];
        ConfidentialClientRedirectUris: List of [Text];
        AzAppCodeTxt: Label 'AZAPP', Locked = true;

    trigger OnInsert()
    begin
        if Code = '' then
            Code := GetNextCode();
    end;

    local procedure GetNextCode() ReturnValue: Code[10]
    begin
        ReturnValue := AzAppCodeTxt;
        ReturnValue := ReturnValue + Format(GetNextNumber()).PadLeft(MaxStrLen(ReturnValue) - StrLen(ReturnValue), '0');
    end;

    local procedure GetNextNumber() NextNumber: BigInteger
    begin
        if not NumberSequence.Exists(AzAppCodeTxt, false) then
            NumberSequence.Insert(AzAppCodeTxt, 0, 1, false);

        NextNumber := NumberSequence.Next(AzAppCodeTxt, false);
    end;

    internal procedure GetAppSecret() EntraAppSecret: Record "Entra Secret KFM"
    begin
        EntraAppSecret.SetRange("Application Code", Code);
        EntraAppSecret.SetFilter("Start Date/Time", '..%1', CurrentDateTime);
        EntraAppSecret.SetFilter("End Date/Time", '%1|%2..', 0DT, CurrentDateTime + 60000);
        EntraAppSecret.FindFirst();
    end;

    internal procedure GetCertificate() OAuthCertificate: Codeunit "OAuth Certificate KFM"
    var
        EntraCertificate: Record "Entra Certificate KFM";
    begin
        EntraCertificate.Get("Certificate Code");
        OAuthCertificate.SetCertificate(EntraCertificate.GetCertificate());
        OAuthCertificate.SetPrivateKey(EntraCertificate.GetPrivateKey());
    end;

    procedure GetOAuth2ClientApplication(EntraAppRegistrationCode: Code[10]) OAuth2ClientApplication: Codeunit "OAuth Client Application KFM"
    begin
        Rec.Get(EntraAppRegistrationCode);

        Rec.TestField("App ID");
        OAuth2ClientApplication.SetClientId(Rec."App ID");
        OAuth2ClientApplication.SetRedirectUriType(Rec."Redirect Uri Type");
        OAuth2ClientApplication.SetRedirectUri(Rec."Redirect Uri");
        if Rec."Certificate Code" <> '' then
            OAuth2ClientApplication.SetCertificate(Rec.GetCertificate())
        else
            OAuth2ClientApplication.SetClientSecret(Rec.GetAppSecret().GetSecretText());
    end;
}