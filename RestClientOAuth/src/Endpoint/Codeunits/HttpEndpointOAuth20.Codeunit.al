codeunit 50322 "Http Endpoint OAuth 2.0 KFM" implements "Http Authentication Settings KFM"
{
    procedure Create(HttpEndpoint: Record "Http Endpoint KFM")
    var
        HttpEndpointOAuth20: Record "Http Endpoint OAuth 2.0 KFM";
    begin
        if not HttpEndpointOAuth20.Get(HttpEndpoint.Code) then begin
            HttpEndpointOAuth20.Init();
            HttpEndpointOAuth20."Http Endpoint Code" := HttpEndpoint.Code;
            HttpEndpointOAuth20.Insert();
        end;
    end;

    procedure GetHttpAuthentication(HttpEndpoint: Record "Http Endpoint KFM") HttpAuthentication: Interface "Http Authentication"
    var
        HttpEndpointOAuth20: Record "Http Endpoint OAuth 2.0 KFM";
    begin
        HttpEndpointOAuth20.Get(HttpEndpoint.Code);
        HttpAuthentication := HttpEndpointOAuth20.GetHttpAuthentication();
    end;
}