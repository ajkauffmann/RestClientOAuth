interface "Http Authentication Settings KFM"
{
    procedure Create(HttpEndpoint: Record "Http Endpoint KFM")
    procedure GetHttpAuthentication(HttpEndpoint: Record "Http Endpoint KFM"): Interface "Http Authentication"
}