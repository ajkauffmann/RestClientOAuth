page 50500 "BC APIs with Secret"
{
    PageType = Card;
    Caption = 'BC APIs with secret';
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

                        BusinessCentralConnector1.GetEnvironments();
                    end;

                    trigger OnValidate()
                    begin
                        BusinessCentralConnector1.SetBCEnvironmentName(BCEnvironmentName);
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

                        BusinessCentralConnector1.GetCompanies();
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

                        BusinessCentralConnector1.GetCustomers(BCCompanyId);
                    end;
                }

            }
        }
    }

    var
        BCEnvironmentName: Text;
        BCCompanyName: Text;
        BCCompanyId: Text;
        BCCustomerNo: Code[20];
        BusinessCentralConnector1: Codeunit "BC Connector With Secret";
}
