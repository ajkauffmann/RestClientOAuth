codeunit 50502 "BC Connector with Endpoint"
{
    var
        RestClient: Codeunit "Rest Client";
        RestClientInitialized: Boolean;
        HttpEndpoint: Record "Http Endpoint KFM";

    procedure GetEnvironments()
    var
        BCEnvironment: Record "BC Environment";
        Response: JsonObject;
        JsonToken: JsonToken;
    begin
        InitializeRestClient();

        Response := RestClient.GetAsJson('https://api.businesscentral.dynamics.com/environments/v1.1').AsObject();

        BCEnvironment.DeleteAll();
        foreach JsonToken in Response.GetArray('value') do begin
            BCEnvironment.Name := JsonToken.AsObject().GetText('name');
            BCEnvironment.Insert();
        end;
    end;

    procedure SetBCEnvironmentName(EnvironmentName: Text)
    begin
        RestClientInitialized := false;
        InitializeRestClient();
        RestClient.SetBaseAddress(StrSubstNo('https://api.businesscentral.dynamics.com/v2.0/%1/api/', EnvironmentName));
    end;

    procedure GetCompanies()
    var
        BCCompany: Record "BC Company";
        Response: JsonObject;
        JsonToken: JsonToken;
        JsonObject: JsonObject;
    begin
        InitializeRestClient();

        Response := RestClient.GetAsJson('v2.0/companies').AsObject();
        BCCompany.DeleteAll();

        foreach JsonToken in Response.GetArray('value') do begin
            JsonObject := JsonToken.AsObject();
            BCCompany.Init();
            BCCompany.Name := JsonObject.GetText('name');
            BCCompany."Display Name" := JsonObject.GetText('displayName');
            BCCompany.Id := JsonObject.GetText('id');
            BCCompany.Insert();
        end;
    end;

    procedure GetCustomers(CompanyId: Text)
    var
        BCCustomer: Record "BC Customer";
        Response: JsonObject;
        JsonToken: JsonToken;
        JsonObject: JsonObject;
    begin
        InitializeRestClient();

        Response := RestClient.GetAsJson('v2.0/customers?company=' + CompanyId).AsObject();

        BCCustomer.DeleteAll();
        foreach JsonToken in Response.GetArray('value') do begin
            JsonObject := JsonToken.AsObject();
            BCCustomer.Init();
            BCCustomer.SystemId := JsonObject.GetText('id');
            BCCustomer."No." := JsonObject.GetText('number');
            BCCustomer.Name := JsonObject.GetText('displayName');
            BCCustomer.Insert(false, true);
        end;
    end;

    procedure SetHttpEndpointCode(Value: Code[20])
    begin
        HttpEndpoint.Get(Value);
    end;

    local procedure InitializeRestClient()
    var
        HttpClientHandlerExamples: Codeunit "Http Client Handler Examples";
    begin
        if RestClientInitialized then
            exit;

        RestClient := HttpEndpoint.GetRestClient(HttpClientHandlerExamples);

        RestClientInitialized := true;
    end;
}