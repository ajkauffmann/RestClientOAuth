## Configuration

### Required Values
| Setting | Description |
|---------|-------------|
| Client ID | Application (client) ID from Microsoft Entra ID registration |
| Client Secret OR Certificate | Credential for confidential client. Use certificate for stronger security |
| Tenant ID | Directory tenant where app is registered |
| Redirect URI Type | Built-in or Advanced implementation |
| Scopes | Resource-specific scopes (e.g., user_impersonation) |

### Authorization Code Flow Specifics
- `offline_access` is auto-added if not present.
- `Prompt Interaction` may be set to None, Login, Consent, Select Account, Admin Consent.

### Client Credentials Flow Specifics
- Only scopes relevant to app roles / application permissions.
- No `offline_access` usage.

### Redirect URI Types
- Built-in (`Redirect URI Built-in`): uses default platform redirect.
- Advanced (`Redirect URI Advanced`): custom landing page + control add-in enabling SSO-like behavior.

### Switching Secret to Certificate
1. Remove stored client secret.
2. Create and assign `OAuth Certificate` with private key + base64 certificate.
3. Reinitialize flows if already constructed (tokens tied to credential method).

### TODO
- Document default built-in redirect URL resolution details
- Provide example multi-env scope configuration
