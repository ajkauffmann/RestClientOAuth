page 50305 "Entra App Registr. Card KFM"
{
    Caption = 'Microsoft Entra App Registration';
    ApplicationArea = All;
    SourceTable = "Entra App Registration KFM";
    PageType = Card;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(Code; Rec.Code) { }
                field("Display Name"; Rec."Display Name") { }
                field("App ID"; Rec."App ID") { }
                field("Supported Account Types"; Rec."Supported Account Types") { }
                field("Publisher Tenant Id"; Rec."Publisher Tenant Id") { }
                field("Redirect Uri Type"; Rec."Redirect Uri Type") { }
                field("Redirect Uri"; Rec."Redirect Uri")
                {
                    Editable = RedirectURIEditable;
                    MultiLine = true;
                }
                field("Certificate Code"; Rec."Certificate Code") { }
            }
            part(Secrets; "Entra Secret Subform KFM")
            {
                SubPageLink = "Application Code" = field(Code);
            }
        }
    }

    var
        RedirectURIEditable: Boolean;

    trigger OnAfterGetRecord()
    var
        RedirectURI: Interface "Redirect URI KFM";
    begin
        RedirectURI := Rec."Redirect Uri Type";
        RedirectURIEditable := RedirectURI.RedirectURIEditable();
    end;
}