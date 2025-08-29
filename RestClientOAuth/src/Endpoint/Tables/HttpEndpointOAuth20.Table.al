table 50306 "Http Endpoint OAuth 2.0 KFM"
{
    Caption = 'Http Endpoint OAuth';

    fields
    {
        field(1; "Http Endpoint Code"; Code[50])
        {
            Caption = 'Http Endpoint Code';
            DataClassification = CustomerContent;
            TableRelation = "Http Endpoint KFM";
        }
        field(2; "OAuth Authority"; Enum "OAuth Authority KFM")
        {
            Caption = 'OAuth Authority';
            DataClassification = CustomerContent;
        }
        field(3; "OAuth Application Code"; Code[20])
        {
            Caption = 'OAuth Application';
            TableRelation = if ("OAuth Authority" = const(MicrosoftEntraID)) "Entra App Registration KFM";

            trigger OnValidate()
            var
                EntraAppRegistration: Record "Entra App Registration KFM";
            begin
                if "OAuth Application Code" <> '' then begin
                    if "OAuth Authority" = "OAuth Authority"::MicrosoftEntraID then begin
                        Rec."Target Entra Tenant Id" := '';
                        if EntraAppRegistration.Get(Rec."OAuth Application Code") then
                            if EntraAppRegistration."Supported Account Types" = EntraAppRegistration."Supported Account Types"::MyOrg then
                                Rec."Target Entra Tenant Id" := EntraAppRegistration."Publisher Tenant Id";
                    end;
                end else begin
                    Rec."Target Entra Tenant Id" := '';
                end;
            end;
        }
        field(4; "OAuth Flow Type"; Enum "OAuthAuthorizationFlowType KFM")
        {
            Caption = 'OAuth Flow Type';
            InitValue = AuthorizationCode;

            trigger OnValidate()
            begin
                if Rec."OAuth Flow Type" = Rec."OAuth Flow Type"::ClientCredentials then begin
                    Rec.TestField("Target Entra Tenant Id");
                    Rec."Prompt Interaction" := Rec."Prompt Interaction"::None;
                end;
            end;
        }
        field(5; "Prompt Interaction"; Enum "Prompt Interaction")
        {
            Caption = 'Prompt Interaction';
            InitValue = None;
            ValuesAllowed = None, Login, "Select Account";

            trigger OnValidate()
            begin
                Rec.TestField("OAuth Flow Type", Rec."OAuth Flow Type"::AuthorizationCode);
            end;
        }
        field(100; "Entra Supported Account Types"; Enum EntraSupportedAccountTypesKFM)
        {
            Caption = 'Entra Supported account types';
            FieldClass = FlowField;
            CalcFormula = lookup("Entra App Registration KFM"."Supported Account Types" where(Code = field("OAuth Application Code")));
            Editable = false;
        }
        field(101; "Target Entra Tenant Id"; Text[250])
        {
            Caption = 'Target Entra Tenant Id';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Target Entra Tenant Id" = '' then
                    Rec.TestField("OAuth Flow Type", Rec."OAuth Flow Type"::AuthorizationCode);
                Rec.CalcFields("Entra Supported Account Types");
                Rec.TestField("Entra Supported Account Types", Rec."Entra Supported Account Types"::MultipleOrgs);
            end;
        }
    }

    keys
    {
        key(PK; "Http Endpoint Code") { Clustered = true; }
    }

    procedure GetHttpAuthentication(): Interface "Http Authentication"
    var
        HttpAuthenticationOAuth2: Codeunit "Http Authentication OAuth2 KFM";
    begin
        HttpAuthenticationOAuth2.Initialize(Rec);
        exit(HttpAuthenticationOAuth2);
    end;

    procedure GetClientApplication() OAuthClientApplication: Codeunit "OAuth Client Application KFM"
    var
        OAuthAuthorityImpl: Interface "OAuth Authority KFM";
    begin
        OAuthAuthorityImpl := Rec."OAuth Authority";
        OAuthClientApplication := OAuthAuthorityImpl.GetClientApplication(Rec);
    end;

    procedure GetAuthorizationFlow() OAuthAuthorizationFlow: Interface "OAuth Authorization Flow KFM"
    begin
        OAuthAuthorizationFlow := Rec."OAuth Flow Type";
        OAuthAuthorizationFlow.Initialize(Rec);
    end;

    procedure GetAuthority() OAuthAuthority: Interface "OAuth Authority KFM"
    begin
        OAuthAuthority := Rec."OAuth Authority";
        OAuthAuthority.Initialize(Rec);
    end;

    internal procedure GetScopes() ScopesList: List of [Text]
    var
        HttpEndpointOAuthScope: Record "Http Endpoint OAuth Scope KFM";
    begin
        HttpEndpointOAuthScope.SetRange("Http Endpoint Code", Rec."Http Endpoint Code");
        if HttpEndpointOAuthScope.FindSet() then
            repeat
                ScopesList.Add(HttpEndpointOAuthScope.Scope);
            until HttpEndpointOAuthScope.Next() = 0;
    end;
}