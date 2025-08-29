codeunit 50501 "Http Client Handler Examples" implements "Http Client Handler"
{
    InherentEntitlements = X;
    InherentPermissions = X;

    procedure Send(
        HttpClient: HttpClient; 
        HttpRequestMessage: Codeunit "Http Request Message"; 
        var HttpResponseMessage: Codeunit "Http Response Message") Success: Boolean;
    var
        ResponseMessage: HttpResponseMessage;
    begin
        Success := HttpClient.Send(HttpRequestMessage.GetHttpRequestMessage(), ResponseMessage);
        HttpResponseMessage.SetResponseMessage(ResponseMessage);
    end;
}



