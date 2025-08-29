table 50305 "Http Endpoint Basic Auth. KFM"
{
    Caption = 'Http Endpoint Basic Auth.';
    Access = Internal;

    fields
    {
        field(1; "Http Endpoint Code"; Code[50])
        {
            Caption = 'Http Endpoint Code';
            DataClassification = CustomerContent;
            TableRelation = "Http Endpoint KFM";
        }
        field(2; Username; Text[100])
        {
            Caption = 'Username';
            DataClassification = EndUserPseudonymousIdentifiers;
        }
        field(3; Domain; Text[50])
        {
            Caption = 'Domain';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(4; "Password ID"; Guid)
        {
            Access = Local;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Http Endpoint Code") { Clustered = true; }
    }

    procedure GetPassword(): SecretText
    var
        [NonDebuggable]
        Password: Text;
    begin
        if IsolatedStorage.Contains("Password ID", DataScope::Module) then
            IsolatedStorage.Get("Password ID", DataScope::Module, Password);
        exit(Password);
    end;

    procedure SetPassword(Password: Text[215])
    begin
        RemovePassword();
        if Password <> '' then begin
            "Password ID" := CreateGuid();
            if EncryptionEnabled() then
                IsolatedStorage.SetEncrypted("Password ID", Password, DataScope::Module)
            else
                IsolatedStorage.Set("Password ID", Password, DataScope::Module);
            Modify();
        end;
    end;

    procedure HasPassword(): Boolean
    begin
        exit(IsolatedStorage.Contains("Password ID", DataScope::Module));
    end;

    procedure RemovePassword()
    begin
        if IsolatedStorage.Contains("Password ID", DataScope::Module) then
            IsolatedStorage.Delete("Password ID", DataScope::Module);
        Clear("Password ID");
        Modify();
    end;

    procedure GetHttpAuthentication(): Interface "Http Authentication"
    var
        HttpAuthenticationBasic: Codeunit "Http Authentication Basic";
    begin
        HttpAuthenticationBasic.Initialize(Rec.Username, Rec.Domain, Rec.GetPassword());
        exit(HttpAuthenticationBasic);
    end;
}