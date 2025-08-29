table 50307 "Http Endpoint OAuth Scope KFM"
{
    Caption = 'Http Endpoint OAuth Scope';

    fields
    {
        field(1; "Http Endpoint Code"; Code[50])
        {
            Caption = 'Http Endpoint Code';
            DataClassification = CustomerContent;
            TableRelation = "Http Endpoint KFM";
        }
        field(2; Scope; Text[2048])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Scope = '' then
                    Rec.Delete();
            end;
        }
    }

    keys
    {
        key(PK; "Http Endpoint Code", Scope) { Clustered = true; }
    }
}