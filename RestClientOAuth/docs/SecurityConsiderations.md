## Security Considerations

### PKCE and State
PKCE (S256) mitigates authorization code interception; state mitigates CSRF by binding response to the initiating context.

### Secrets vs Certificates
- Secrets should be rotated and never committed to source control.
- Certificates allow JWT client assertions; private key is used to sign a short-lived assertion (5 minute exp window) reducing replay risk.

### offline_access Scope
Automatically added for Authorization Code flow to enable refresh tokens. Removing it disables silent refresh (a full user interaction would be required once token expires).

### Ephemeral In-Memory Tokens
Access & refresh tokens are held in `SecretText` variables only. Advantages: no at-rest exposure, reduced leakage risk. Trade-off: user must re-authorize after object disposal (e.g., after a restart or new session context).

### Prompt Interaction
`Prompt Interaction` enum supports forcing login/consent/admin consent—use minimally to avoid unnecessary user friction.

### Redirect URI Integrity
Ensure the exact redirect URI configured in Microsoft Entra ID matches the one used (built-in or advanced). Mismatch causes failed token exchange.

### Certificate Private Key Handling
Store the private key securely (e.g., secure storage or environment variable injection). TODO: Provide recommended secure storage pattern in BC extensions.

### TODO
- Guidance on secure secret injection mechanism
- Recommendations for multi-environment secret management
