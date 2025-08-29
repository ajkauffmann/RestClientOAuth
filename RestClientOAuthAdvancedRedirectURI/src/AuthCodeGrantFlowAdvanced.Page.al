page 50400 AuthCodeGrantFlowAdvancedKFM
{
    PageType = NavigatePage;
    Extensible = false;
    Caption = 'Waiting for a response. Do not close this page.';
    ApplicationArea = All;
    UsageCategory = None;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    LinksAllowed = false;
    InherentEntitlements = X;
    InherentPermissions = X;

    layout
    {
        area(Content)
        {
            group(BodyGroup)
            {
                Caption = 'Authentication';
                InstructionalText = 'A sign in window is open. To continue, pick the account you want to use and accept the conditions. This message will close when you are done.';
            }

            usercontrol(OAuthCtrl; "OAuth Authorization Control KFM")
            {
                ApplicationArea = All;

                trigger ControlAddinReady()
                begin
                    ControlAddinReady := true;
                    StartAuthCodeGrantFlow();
                end;

                trigger AuthorizationCodeRetrieved(Value: Text)
                begin
                    AuthCode := Value;
                    CurrPage.Close();
                end;

                trigger AuthorizationErrorOccurred(ErrorCode: Text; ErrorDescription: Text)
                begin
                    AuthErr := StrSubstNo(AuthCodeErrorLbl, ErrorCode, ErrorDescription);
                    CurrPage.Close();
                end;

                trigger AuthorizationCanceledByUser()
                begin
                    CanceledByUser := true;
                    CurrPage.Close();
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
        Params: Text;
        TenantId, AccountDescription : Text;
        AuthCode: Text;
        AuthErr: Text;
        CanceledByUser: Boolean;
        ControlAddinReady: Boolean;
        AuthCodeErrorLbl: Label 'Error: %1\%2';

    internal procedure GetAuthorizationCode(AuthorizationParams: Text): Text
    begin
        Params := AuthorizationParams;
        CurrPage.RunModal();
        exit(AuthCode);
    end;

    internal procedure GetAuthorizationError() ReturnValue: Text
    begin
        ReturnValue := AuthErr;
    end;

    internal procedure IsCanceledByUser() ReturnValue: Boolean
    begin
        ReturnValue := CanceledByUser;
    end;

    local procedure StartAuthCodeGrantFlow()
    begin
        CurrPage.OAuthCtrl.StartAuthorization(Params);
    end;
}