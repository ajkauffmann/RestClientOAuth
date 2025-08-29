codeunit 50321 "Http Endpoint Anonymous KFM" implements "Http Authentication Settings KFM"
{
    procedure Create(HttpEndpoint: Record "Http Endpoint KFM")
    begin
    end;

    procedure GetHttpAuthentication(HttpEndpoint: Record "Http Endpoint KFM") HttpAuthentication: Interface "Http Authentication"
    var
        HttpAuthenticationAnonymous: Codeunit "Http Authentication Anonymous";
    begin
        HttpAuthentication := HttpAuthenticationAnonymous;
    end;
}