page 50308 HttpEndpointBasicAuthSubfrmKFM
{
    PageType = CardPart;
    Caption = 'Basic Authentication';
    SourceTable = "Http Endpoint Basic Auth. KFM";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            field(Username; Rec.Username) { }
            field(Domain; Rec.Domain) { }
            field(Password; PasswordTxt)
            {
                Caption = 'Password';
                ExtendedDatatype = Masked;

                trigger OnValidate()
                begin
                    Rec.SetPassword(PasswordTxt);
                end;
            }

        }
    }
    var
        PasswordTxt: Text;

    trigger OnAfterGetRecord()
    begin
        if Rec.HasPassword() then
            PasswordTxt := '************';
    end;
}