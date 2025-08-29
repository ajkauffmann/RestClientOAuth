## Extensibility

The design allows (future) plugging of other authorities or redirect behaviors.

### Interfaces & Enums
- `OAuth Authority` (interface)
- `OAuth Authorization Flow` (interface)
- `Redirect URI` (interface)
- `OAuth Authorization Flow Type` (enum)
- `Redirect URI Type` (enum)
- `Prompt Interaction` (enum) – user interaction hints

### Adding a New Authority (Conceptual Steps)
1. Implement `OAuth Authority` returning authorization & token endpoints.
2. Provide tenant / instance configuration setters.
3. (Optional) Add pages/tables for storing registration metadata similar to existing Microsoft Entra ID artifacts.
4. Reference your authority in flows via `SetAuthority` before initiation.

### Adding a New Redirect URI Strategy
1. Implement `Redirect URI` with custom logic to obtain the authorization code.
2. Handle state & PKCE parameters; ensure redirect URI is set on the client application before requesting token.
3. Emit clear errors or cancellation events.

### Custom Authorization Flow
If adding a distinct OAuth grant, implement `OAuth Authorization Flow` and mimic the pattern in `Auth. Code Grant Flow` / `Client Credentials Flow`. (Currently only those two are supported.)

### TODO
- Document authority implementation template
- Provide sample test harness for new authority
