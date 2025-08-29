page 50311 HttpEndpointOAuthScopesKFM
{
    PageType = ListPart;
    Caption = 'Http Endpoint OAuth Scopes';
    SourceTable = "Http Endpoint OAuth Scope KFM";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(Scope; Rec.Scope) { }
            }
        }
    }
}