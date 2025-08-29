codeunit 50318 "Http Endpoint Rest Client KFM"
{
    InherentEntitlements = X;
    InherentPermissions = X;

    procedure GetRestClient(HttpEndpoint: Record "Http Endpoint KFM") RestClient: Codeunit "Rest Client"
    var
        HttpClientHandler: Codeunit "Http Client Handler KFM";
    begin
        RestClient := GetRestClient(HttpEndpoint, HttpClientHandler);
    end;

    procedure GetRestClient(HttpEndpoint: Record "Http Endpoint KFM"; HttpClientHandler: Interface "Http Client Handler") RestClient: Codeunit "Rest Client"
    begin
        RestClient.Initialize(HttpClientHandler, HttpEndpoint.GetHttpAuthentication());

        if HttpEndpoint."Base Url" <> '' then
            RestClient.SetBaseAddress(HttpEndpoint."Base Url");
    end;
}