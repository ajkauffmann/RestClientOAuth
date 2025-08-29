page 50303 AuthCodeGrantFlowBuiltinKFM
{
    PageType = NavigatePage;
    Extensible = false;
    Caption = 'Waiting for a response. Do not close this page.';
    ApplicationArea = All;
    UsageCategory = None;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    InherentEntitlements = X;
    InherentPermissions = X;


    layout
    {
        area(Content)
        {
            group(BodyGroup)
            {
                InstructionalText = 'A sign in window is open. To continue, pick the account you want to use and accept the conditions. This message will close when you are done.';
                ShowCaption = false;
            }
            usercontrol(OAuthIntegration; OAuthControlAddIn)
            {
                trigger AuthorizationCodeRetrieved(code: Text)
                var
                    StateOut: Text;
                    AdminConsentTxt: Text;
                begin
                    GetOAuthProperties(code, AuthCode, StateOut, AdminConsentTxt);

                    if UpperCase(AdminConsentTxt) = 'TRUE' then
                        HasAdminConsentSucceded := true
                    else
                        HasAdminConsentSucceded := false;

                    if State = '' then
                        AuthError := AuthError + NoStateErr
                    else
                        if StateOut <> State then
                            AuthError := AuthError + NotMatchingStateErr;

                    CurrPage.Close();
                end;

                trigger AuthorizationErrorOccurred(error: Text; desc: Text);
                begin
                    AuthError := StrSubstNo(AuthCodeErrorLbl, error, desc);
                    CurrPage.Close();
                end;

                trigger ControlAddInReady();
                begin
                    CurrPage.OAuthIntegration.StartAuthorization(OAuthRequestUrl);
                end;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Cancel)
            {
                Caption = 'Cancel';
                InFooterBar = true;

                trigger OnAction()
                begin
                    CanceledByUser := true;
                    CurrPage.Close();
                end;
            }
        }
    }

    var
        OAuthRequestUrl: Text;
        State: Text;
        AuthCode: Text;
        AuthError: Text;
        CanceledByUser: Boolean;
        HasAdminConsentSucceded: Boolean;
        NoStateErr: Label 'No state has been returned';
        NotMatchingStateErr: Label 'The state parameter value does not match.';
        AuthCodeErrorLbl: Label 'Error: %1, description: %2', Comment = '%1 = The authorization error message, %2 = The authorization error description';


    internal procedure GetAuthorizationCode(AuthRequestUrl: Text; AuthInitialState: Text): Text
    begin
        OAuthRequestUrl := AuthRequestUrl;
        State := AuthInitialState;
        CurrPage.RunModal();
        exit(AuthCode);
    end;

    procedure GetAuthCode(): Text
    begin
        exit(AuthCode);
    end;

    procedure GetAuthError(): Text
    begin
        exit(AuthError);
    end;

    internal procedure IsCanceledByUser() ReturnValue: Boolean
    begin
        ReturnValue := CanceledByUser;
    end;

    procedure GetGrantConsentSuccess(): Boolean
    begin
        exit(HasAdminConsentSucceded);
    end;

    local procedure GetOAuthProperties(Parameters: Text; var AuthCodeOut: Text; var StateOut: Text; var AdminConsent: Text)
    begin
        if Parameters.EndsWith('#') then
            Parameters := CopyStr(Parameters, 1, StrLen(Parameters) - 1);

        AuthCodeOut := GetPropertyFromCode(Parameters, 'code');
        StateOut := GetPropertyFromCode(Parameters, 'state');
        AdminConsent := GetPropertyFromCode(Parameters, 'admin_consent');
    end;

    local procedure GetPropertyFromCode(Parameters: Text; Property: Text) Value: Text
    var
        Parameter: Text;
        ParameterList: List of [Text];
    begin
        if not Parameters.Contains(Property) then
            exit;

        ParameterList := Parameters.Split('&');
        foreach Parameter in ParameterList do begin
            if Parameter.StartsWith(Property) then begin
                Value := Parameter.Split('=').Get(2);
                exit;
            end;
        end;
    end;
}