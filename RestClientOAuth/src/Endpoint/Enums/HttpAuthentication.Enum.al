enum 50300 "HTTP Authentication KFM" implements "Http Authentication Settings KFM"
{
    Extensible = true;

    value(0; Anonymous)
    {
        Caption = 'Anonymous';
        Implementation = "Http Authentication Settings KFM" = "Http Endpoint Anonymous KFM";
    }
    value(1; Basic)
    {
        Caption = 'Basic';
        Implementation = "Http Authentication Settings KFM" = "Http Endpoint Basic Auth. KFM";
    }
    value(2; OAuth20)
    {
        Caption = 'OAuth 2.0';
        Implementation = "Http Authentication Settings KFM" = "Http Endpoint OAuth 2.0 KFM";
    }
}