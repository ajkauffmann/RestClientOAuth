page 50307 "Http Endpoint Card KFM"
{
    PageType = Card;
    Caption = 'HTTP Endpoint';
    SourceTable = "Http Endpoint KFM";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(Code; Rec.Code) { }
                field(Description; Rec.Description) { }
                field(Url; Rec."Base Url")
                {
                    MultiLine = true;
                }
            }
            group(AuthenticationGroup)
            {
                Caption = 'Authentication';
                field(Authentication; Rec.Authentication) { }
            }
            part(BasicAuth; HttpEndpointBasicAuthSubfrmKFM)
            {
                Visible = Rec.Authentication = Rec.Authentication::Basic;
                Caption = 'Basic Authentication';
                SubPageLink = "Http Endpoint Code" = field(Code);
            }
            part(OAuth; HttpEndpointOAuthSubformKFM)
            {
                Visible = Rec.Authentication = Rec.Authentication::OAuth20;
                Caption = 'OAuth 2.0';
                SubPageLink = "Http Endpoint Code" = field(Code);
            }
            part(Scopes; HttpEndpointOAuthScopesKFM)
            {
                Visible = Rec.Authentication = Rec.Authentication::OAuth20;
                Caption = 'Scopes';
                SubPageLink = "Http Endpoint Code" = field(Code);
            }
        }
    }
}