page 50310 "Http Endpoint List KFM"
{
    PageType = List;
    Caption = 'Http Endpoints';
    SourceTable = "Http Endpoint KFM";
    ApplicationArea = All;
    Editable = false;
    UsageCategory = Administration;
    CardPageId = "Http Endpoint Card KFM";

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(Code; Rec.Code) { }
                field(Description; Rec.Description) { }
                field(Url; Rec."Base Url") { }
                field(Authentication; Rec.Authentication) { }
            }
        }
    }
}