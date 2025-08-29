page 50306 "Entra App Registr. List KFM"
{
    PageType = List;
    Caption = 'Microsoft Entra App Registrations';
    SourceTable = "Entra App Registration KFM";
    CardPageId = "Entra App Registr. Card KFM";
    ApplicationArea = All;
    UsageCategory = Administration;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(records)
            {
                field(Code; Rec.Code) { }
                field(AppId; Rec."App ID") { }
                field(DisplayName; Rec."Display Name") { }
                field(PublisherDomain; Rec."Publisher Tenant Id") { }
                field(SupportedAccountTypes; Rec."Supported Account Types") { }
            }
        }
    }
}