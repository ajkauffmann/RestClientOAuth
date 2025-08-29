page 50501 "BC APIs with Endpoint"
{
    PageType = Card;
    Caption = 'BC APIs with endpoint';
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            group(Connection)
            {
                field(HttpEndpointCode; HttpEndpointCode)
                {
                    Caption = 'Http Endpoint';
                    TableRelation = "Http Endpoint KFM";

                    trigger OnValidate()
                    begin
                        BCConnectorWithEndpoint.SetHttpEndpointCode(HttpEndpointCode);
                    end;
                }
            }
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

                        BCConnectorWithEndpoint.GetEnvironments();
                    end;

                    trigger OnValidate()
                    begin
                        BCConnectorWithEndpoint.SetBCEnvironmentName(BCEnvironmentName);
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

                        BCConnectorWithEndpoint.GetCompanies();
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

                        BCConnectorWithEndpoint.GetCustomers(BCCompanyId);
                    end;
                }

            }
        }
    }

    var
        HttpEndpointCode: Code[20];
        BCEnvironmentName: Text;
        BCCompanyName: Text;
        BCCompanyId: Text;
        BCCustomerNo: Code[20];
        BCConnectorWithEndpoint: Codeunit "BC Connector with Endpoint";
}
