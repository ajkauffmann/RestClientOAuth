## Examples

Short inline snippets adapted from the examples project (`RestClientOAuthExamples`). Replace IDs/secrets with your own.

### Auth Code Grant with Client Secret
```al
OAuthClientApplication.SetClientId('<client-id>');
OAuthClientApplication.SetClientSecret(SecretStrSubstNo('<client-secret>'));
OAuthClientApplication.AddScope('https://api.businesscentral.dynamics.com/user_impersonation');
```

### Auth Code Grant with Certificate
```al
OAuthClientApplication.SetClientId('<client-id>');
OAuthCertificate.SetPrivateKey(SecretStrSubstNo('<private-key-xml>'));
OAuthCertificate.SetCertificate('<base64-cert>');
OAuthClientApplication.SetCertificate(OAuthCertificate);
OAuthClientApplication.AddScope('https://api.businesscentral.dynamics.com/user_impersonation');
```

### Initialize Authorization Code Flow
```al
AuthCodeGrantFlow.SetAuthority(OAuthAuthority);
AuthCodeGrantFlow.SetPromptInteraction(Enum::"Prompt Interaction"::None);
HttpAuthenticationOAuth2.Initialize(OAuthClientApplication, AuthCodeGrantFlow);
RestClient.Initialize(HttpClientHandlerExamples, HttpAuthenticationOAuth2);
```

### Client Credentials Flow
```al
ClientCredentialsFlow.SetAuthority(OAuthAuthority);
HttpAuthenticationOAuth2.Initialize(OAuthClientApplication, ClientCredentialsFlow);
RestClient.Initialize(HttpClientHandlerExamples, HttpAuthenticationOAuth2);
```

### Calling Business Central Environments API
```al
Response := RestClient.GetAsJson('https://api.businesscentral.dynamics.com/v2.0/<environment>/api/v2.0/customers?company=<id>').AsObject();
foreach JsonToken in Response.GetArray('value') do
    // process environment
```

### Switching Base URL
```al
RestClient.SetBaseAddress(StrSubstNo('https://api.businesscentral.dynamics.com/v2.0/%1/api/', EnvironmentName));
```

### Notes
- Switching the base url causes the Rest Client to reinitialize, resulting in disposing previously retrieved access and refresh tokens.
- See also: `BC Connector With Secret`, `BC Connector with Certificate` codeunits for full examples.
