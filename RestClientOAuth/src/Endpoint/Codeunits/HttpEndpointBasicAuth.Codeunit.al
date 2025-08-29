codeunit 50320 "Http Endpoint Basic Auth. KFM" implements "Http Authentication Settings KFM"
{
    procedure Create(HttpEndpoint: Record "Http Endpoint KFM")
    var
        HttpEndpointBasicAuth: Record "Http Endpoint Basic Auth. KFM";
    begin
        if not HttpEndpointBasicAuth.Get(HttpEndpoint.Code) then begin
            HttpEndpointBasicAuth.Init();
            HttpEndpointBasicAuth."Http Endpoint Code" := HttpEndpoint.Code;
            HttpEndpointBasicAuth.Insert();
        end;
    end;

    procedure GetHttpAuthentication(HttpEndpoint: Record "Http Endpoint KFM") HttpAuthentication: Interface "Http Authentication"
    var
        HttpEndpointBasicAuth: Record "Http Endpoint Basic Auth. KFM";
    begin
        HttpEndpointBasicAuth.Get(HttpEndpoint.Code);
        HttpAuthentication := HttpEndpointBasicAuth.GetHttpAuthentication();
    end;
}