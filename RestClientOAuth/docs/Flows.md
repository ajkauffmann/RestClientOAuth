## Flows

| Flow | Credentials | PKCE | Refresh Token | offline_access | Token Persistence |
|------|-------------|------|---------------|----------------|------------------|
| Authorization Code Grant | Secret or Certificate | Yes (S256) | Yes (in-memory) | Auto-added | In-memory only |
| Client Credentials | Secret or Certificate | N/A | No (re-acquire) | Not used | In-memory (access token) |

### Authorization Code Grant Flow
Interactive user delegation. Implements PKCE (S256) and state for CSRF mitigation. Automatically appends `offline_access` scope when first requesting an authorization code to obtain a refresh token. Refresh token & access token exist only in memory.

### Client Credentials Flow
Service-to-service. No refresh token. Access token re-acquired when expired.

### Secret vs Certificate
- Secret: simpler setup, rotate regularly.
- Certificate: stronger credential, JWT client assertion using RS256 signed with private key.

### Access and refresh Tokens
All tokens are stored as `SecretText` in memory only. When the Rest Client instance is disposed or reinitialized, a fresh authorization (Auth Code) or token acquisition (Client Credentials) occurs.
