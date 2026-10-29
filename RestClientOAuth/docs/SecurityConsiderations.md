## Security Considerations

### PKCE and State
PKCE (S256) mitigates authorization code interception; state mitigates CSRF by binding response to the initiating context. Authorization Code flow uses PKCE for both public and confidential clients.

### Secrets vs Certificates
- Secrets should be rotated and never committed to source control.
- Certificates allow JWT client assertions; private key is used to sign a short-lived assertion (5 minute exp window) reducing replay risk.

### offline_access Scope
Automatically added for Authorization Code and Device Code flows to enable refresh tokens. Removing it disables silent refresh (a full user interaction would be required once token expires).

### Authorization Code Flow
Authorization Code with PKCE is the preferred interactive user-delegation flow when redirect-based browser interaction is available. Public-client token requests send the client id, authorization code, redirect URI, scopes, and PKCE verifier only. Confidential-client token requests additionally send the configured secret or certificate assertion.

### Device Code Flow
Device Code flow is implemented through `Codeunit 50329 "OAuth Public Client KFM"`. Public-client requests send the client id and flow data only; they do not send a client secret or certificate assertion. Stored Microsoft Entra app registration credentials may still exist for other flows, and any credentials present on the neutral `OAuth Application Config` are ignored by the public-client token exchange.

Only the `user_code`, `verification_uri`, and authority-provided message are shown to the user. The `device_code` is held as `SecretText` and is used only in the back-channel token request. Users should confirm they are authorizing the expected application and should not enter codes received from an unexpected source.

Device Code flow is supported as an advanced or fallback public-client flow, not as the preferred Business Central interactive flow. Business Central can handle redirect-based authorization through the built-in landing page or an advanced redirect URI implementation, so Authorization Code with PKCE should be used when browser redirect interaction is available.

### Setup Automation and App Registration Bootstrap
Automated Microsoft Entra app registration setup should use a dedicated setup application owned by this module or product, authenticated as a public client with Authorization Code and PKCE. The setup application can request delegated Microsoft Graph permissions and act on behalf of an appropriately privileged administrator to create endpoint app registrations, configure redirect URIs, upload public certificates, and assign required API permissions.

Do not use another product's public client id, such as the Azure CLI application id, to bootstrap setup. Although this can technically work with Device Code flow, it misrepresents the calling application in consent, sign-in logs, audit trails, and token acquisition. It also creates an unmanaged dependency on a first-party client that this module does not own. The Azure CLI identity should remain an Azure CLI identity, not a general-purpose bootstrap identity for Business Central setup.

The setup application and endpoint applications should remain separate identities. The setup application exists only to help administrators provision configuration; endpoint applications are the runtime identities used by endpoint integrations.

### Ephemeral In-Memory Tokens
Access & refresh tokens are held in `SecretText` variables only. Advantages: no at-rest exposure, reduced leakage risk. Trade-off: user must re-authorize after object disposal (e.g., after a restart or new session context).

### Prompt Interaction
`Prompt Interaction` enum supports forcing login/consent/admin consent—use minimally to avoid unnecessary user friction.

### Redirect URI Integrity
Ensure the exact redirect URI configured in Microsoft Entra ID matches the one used (built-in or advanced). Mismatch causes failed token exchange.

### Certificate Private Key Handling
Store private keys securely and inject them through a secure setup process. Avoid committing private-key XML or secret values to source control. When credentials must be stored by this module, use the Microsoft Entra app-registration storage in the core app, which keeps secrets and private keys behind `SecretText` and encryption patterns where applicable.

### Multi-Environment Secret Management
Use separate Microsoft Entra app registrations or credentials per environment when operational boundaries require it. Keep production secrets out of sample code and development settings, and rotate secrets or certificates according to your organization's policy.
