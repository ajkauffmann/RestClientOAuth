table 50302 "Entra Secret KFM"
{
    Caption = 'Secret';
    DataPerCompany = false;
    ReplicateData = false;
    Access = Internal;

    fields
    {
        field(1; "Application Code"; Code[20])
        {
            Caption = 'Application Code';
            DataClassification = SystemMetadata;
            TableRelation = "Entra App Registration KFM".Code;
        }
        field(2; Id; Text[36])
        {
            Caption = 'Id';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                Guid: Guid;
            begin
                if Rec.Id = '' then
                    exit;
                Evaluate(Guid, Rec.Id);
                Rec.Id := Format(Guid, 0, 4).ToLower();
            end;
        }
        field(3; "Isolated Storage Id"; Guid)
        {
            Access = Local;
            DataClassification = SystemMetadata;
        }
        field(4; "Encrypted Secret"; Text[89])
        {
            Caption = 'Encrypted Secret';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(11; "Start Date/Time"; DateTime)
        {
            Caption = 'Start Date/Time';
            DataClassification = CustomerContent;
        }
        field(12; "End Date/Time"; DateTime)
        {
            Caption = 'End Date/Time';
            DataClassification = CustomerContent;
        }
        field(13; Hint; Text[3])
        {
            Caption = 'Hint';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Application Code", Id) { Clustered = true; }
    }

    var
        DataEncryptionHelper: Codeunit "Data Encryption Helper KFM";

    procedure SetSecretText(SecretText: Text[215])
    begin
        Rec."Encrypted Secret" := DataEncryptionHelper.Encrypt(SecretText);
        Rec.Modify();
    end;
}