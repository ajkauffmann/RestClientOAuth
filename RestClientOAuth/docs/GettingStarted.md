## Getting Started

Minimum Business Central version: v26.

This guide shows how to authenticate against Microsoft Entra ID using either Authorization Code Grant (with PKCE) or Client Credentials, and how to plug the result into `Rest Client`.

### 1. Get the code
Clone the repository and add it to your own apps. Feel free to change the suffix and object range to anything you prefer.

### 2. Create the OAuth Client Application
```al
var
    OAuthClientApplication: Codeunit "OAuth Client Application";
begin
    OAuthClientApplication.SetClientId('<client-id>');
    OAuthClientApplication.SetClientSecret(SecretStrSubstNo('<client-secret>'));
    OAuthClientApplication.AddScope('https://api.businesscentral.dynamics.com/user_impersonation');
    // offline_access will be auto-added for Authorization Code flow.
end;
```

To use a certificate instead of a secret:
```al
var
    OAuthClientApplication: Codeunit "OAuth Client Application";
    OAuthCertificate: Codeunit "OAuth Certificate";
begin
    OAuthClientApplication.SetClientId('<client-id>');
    OAuthCertificate.SetPrivateKey(SecretStrSubstNo('<private-key-xml>'));
    OAuthCertificate.SetCertificate('<base64-cert>');
    OAuthClientApplication.SetCertificate(OAuthCertificate);
    OAuthClientApplication.AddScope('https://api.businesscentral.dynamics.com/user_impersonation');
end;
```

### 3. Create the Microsoft Entra ID Authority
```al
var
    MicrosoftEntraID: Codeunit "Microsoft Entra ID";
    OAuthAuthority: Interface "OAuth Authority";
begin
    MicrosoftEntraID.SetTenantID('<tenant-id>');
    OAuthAuthority := MicrosoftEntraID;
end;
```

### 4. Instantiate the Desired Flow
Authorization Code Grant (interactive):
```al
var
    AuthCodeGrantFlow: Codeunit "Auth. Code Grant Flow";
    OAuthAuthorizationFlow: Interface "OAuth Authorization Flow";
begin
    AuthCodeGrantFlow.SetAuthority(OAuthAuthority);
    AuthCodeGrantFlow.SetPromptInteraction(Enum::"Prompt Interaction"::None);
    OAuthAuthorizationFlow := AuthCodeGrantFlow;
end;
```

Client Credentials:
```al
var
    ClientCredentialsFlow: Codeunit "Client Credentials Flow";
    OAuthAuthorizationFlow: Interface "OAuth Authorization Flow";
begin
    ClientCredentialsFlow.SetAuthority(OAuthAuthority);
    OAuthAuthorizationFlow := ClientCredentialsFlow;
end;
```

### 5. Initialize Http Authentication & Rest Client
```al
var
    HttpAuthenticationOAuth2: Codeunit "Http Authentication OAuth2";
    HttpAuthentication: Interface "Http Authentication";
    RestClient: Codeunit "Rest Client";
    HttpClientHandlerExamples: Codeunit "Http Client Handler Examples";
begin
    HttpAuthenticationOAuth2.Initialize(OAuthClientApplication, OAuthAuthorizationFlow);
    HttpAuthentication := HttpAuthenticationOAuth2;
    RestClient.Initialize(HttpClientHandlerExamples, HttpAuthentication);
end;
```

### 6. Execute Calls
```al
var
    Response: JsonObject;
begin
    Response := RestClient.GetAsJson('<url>').AsObject();
end;
```

### Notes
- The Authorization Code flow adds `offline_access` automatically to acquire a refresh token.
- Tokens (including refresh) are in-memory only; you must re-authorize after object lifecycle resets.
- If no redirect type is specified, the built-in redirect page will be used.