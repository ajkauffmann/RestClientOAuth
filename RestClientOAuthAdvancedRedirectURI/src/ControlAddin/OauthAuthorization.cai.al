controladdin "OAuth Authorization Control KFM"
{
    StartupScript = 'src/ControlAddin/startup.js';
    Scripts = 'src/ControlAddin/script.js';

    MinimumHeight = 1;
    MaximumHeight = 1;
    RequestedHeight = 1;
    MinimumWidth = 1;
    MaximumWidth = 1;
    RequestedWidth = 1;

    event ControlAddinReady();
    event AuthorizationCodeRetrieved(Value: Text);
    event AuthorizationErrorOccurred(ErrorCode: Text; ErrorDescription: Text);
    event AuthorizationCanceledByUser();
    event AdminConsentSucceeded(Tenant: Text; Scope: Text);
    procedure startAuthorization(params: Text);
}