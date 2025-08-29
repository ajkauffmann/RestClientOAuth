codeunit 50305 "Auth. Code Grant Flow KFM" implements "OAuth Authorization Flow KFM"
{
    var
        AuthCodeGrantFlowImpl: Codeunit AuthCodeGrantFlowImplKFM;

    procedure SetPromptInteraction(Value: Enum "Prompt Interaction")
    begin
        AuthCodeGrantFlowImpl.SetPromptInteraction(Value);
    end;

    procedure GetPromptInteraction() ReturnValue: Enum "Prompt Interaction"
    begin
        ReturnValue := AuthCodeGrantFlowImpl.GetPromptInteraction();
    end;

    procedure SetAuthority(Value: Interface "OAuth Authority KFM")
    begin
        AuthCodeGrantFlowImpl.SetAuthority(Value);
    end;

    procedure GetAuthority() Value: Interface "OAuth Authority KFM"
    begin
        Value := AuthCodeGrantFlowImpl.GetAuthority();
    end;

    procedure Initialize(HttpEndpointOAuth20: Record "Http Endpoint OAuth 2.0 KFM");
    begin
        AuthCodeGrantFlowImpl.Initialize(HttpEndpointOAuth20);
    end;

    procedure GetAuthorizationHeader(OAuthClientApplication: Codeunit "OAuth Client Application KFM") ReturnValue: SecretText
    begin
        ReturnValue := AuthCodeGrantFlowImpl.GetAuthorizationHeader(OAuthClientApplication);
    end;

    procedure GetPKCECodeChallenge() ReturnValue : Text
    begin
        ReturnValue := AuthCodeGrantFlowImpl.GetPKCECodeChallenge();
    end;
}
