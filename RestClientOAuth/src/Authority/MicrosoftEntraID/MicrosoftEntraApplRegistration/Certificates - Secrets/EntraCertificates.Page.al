page 50304 "Entra Certificates KFM"
{
    PageType = List;
    Caption = 'Entra Certificates';
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Entra Certificate KFM";

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(Code; Rec.Code) { }
                field(Name; Rec.Name) { }
                field("Expiry Date"; Rec."Expiry Date") { }
                field(HasValue; Rec.HasValue)
                {
                    Caption = 'Certificate exists';
                }
            }
        }
    }

    actions
    {
        area(Promoted)
        {
            actionref(CreateCertificateActionRef; CreateCertificateAction) { }
            actionref(DownloadCertificateActionRef; DownloadCertificateAction) { }
        }
        area(Processing)
        {
            action(CreateCertificateAction)
            {
                Caption = 'Create Certificate';
                Image = NewResource;

                trigger OnAction()
                begin
                    CurrPage.SaveRecord();
                    Rec.CreateCertificate();
                end;
            }
            action(DownloadCertificateAction)
            {
                Caption = 'Download Certificate';
                Image = Download;

                trigger OnAction()
                begin
                    Rec.DownloadCertificate();
                end;
            }
        }
    }
}