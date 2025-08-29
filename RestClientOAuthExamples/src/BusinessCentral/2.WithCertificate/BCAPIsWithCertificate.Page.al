page 50502 "BC APIs With Certificate"
{
    PageType = Card;
    Caption = 'BC APIs with certificate';
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            group(BusinessCentral)
            {
                Caption = 'Business Central';
                field(BCEnvironmentName; BCEnvironmentName)
                {
                    Caption = 'BC Environment';
                    TableRelation = "BC Environment";

                    trigger OnAssistEdit()
                    var
                        BCEnvironment: Record "BC Environment";
                    begin
                        BCEnvironment.DeleteAll();
                        Commit();

                        BCConnectorwithCertificate.GetEnvironments();
                    end;

                    trigger OnValidate()
                    begin
                        BCConnectorwithCertificate.SetBCEnvironmentName(BCEnvironmentName);
                    end;
                }
                field(BCCompanyName; BCCompanyName)
                {
                    Caption = 'BC Company';
                    TableRelation = "BC Company";

                    trigger OnAssistEdit()
                    var
                        BCCompany: Record "BC Company";
                    begin
                        BCCompany.DeleteAll();
                        Commit();

                        BCConnectorwithCertificate.GetCompanies();
                    end;

                    trigger OnValidate()
                    var
                        BCCompany: Record "BC Company";
                    begin
                        BCCompany.Get(BCCompanyName);
                        BCCompanyId := BCCompany.Id;
                    end;
                }
                field(BCCustomerNo; BCCustomerNo)
                {
                    Caption = 'Customer';
                    TableRelation = "BC Customer";

                    trigger OnAssistEdit()
                    var
                        BCCustomer: Record "BC Customer";
                    begin
                        BCCustomer.DeleteAll();
                        Commit();

                        BCConnectorwithCertificate.GetCustomers(BCCompanyId);
                    end;
                }

            }
        }
    }

    var
        Certificate: Text;
        PrivateKey: Text;
        BCEnvironmentName: Text;
        BCCompanyName: Text;
        BCCompanyId: Text;
        BCCustomerNo: Code[20];
        BCConnectorwithCertificate: Codeunit "BC Connector with Certificate";
}
