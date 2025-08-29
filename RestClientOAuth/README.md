# RestClientOAuth Module

High-level OAuth 2.0 helper module for Microsoft Dynamics 365 Business Central (v26+) focused on Microsoft Entra ID integration. It provides structured abstractions for the Authorization Code Grant and Client Credentials flows using either a client secret or an X.509 certificate (JWT client assertion). Tokens (access & refresh) are stored only in memory (SecretText) for the lifetime of the Rest Client instance.

## Features
- Authorization Code Grant Flow (PKCE + state) with secret or certificate
- Client Credentials Flow with secret or certificate
- Automatic offline_access scope injection to enable refresh tokens
- In-memory ephemeral token & refresh handling (no persistence)
- Pluggable authority design (optimized for Microsoft Entra ID)
- Built-in vs. custom redirect URI (advanced SSO-friendly control add-in)

## Supported OAuth Flows
- Authorization Code Grant (interactive, PKCE, refresh token support)
- Client Credentials (service-to-service, no refresh token, auto re-acquire)

## Quick Start
1. Create an OAuth Client Application (set client id, secret or certificate, redirect URI type, scopes).
2. Create a Microsoft Entra ID authority and set the Tenant ID.
3. Instantiate the desired flow (Authorization Code or Client Credentials) and assign the authority.
4. Initialize `Http Authentication OAuth2` with the client app + flow.
5. Initialize `Rest Client` with a handler plus the authentication interface.

See `docs/GettingStarted.md` for detailed steps and `docs/Examples.md` for snippets.

## Documentation
- [Getting Started](docs/GettingStarted.md)
- [Architecture](docs/Architecture.md)
- [Flows](docs/Flows.md)
- [Examples](docs/Examples.md)
- [Advanced Redirect URI](docs/AdvancedRedirectURI.md)
- [Extensibility](docs/Extensibility.md)
- [Security Considerations](docs/SecurityConsiderations.md)
- [Configuration](docs/Configuration.md)
- [Troubleshooting](docs/Troubleshooting.md)
- [FAQ](docs/FAQ.md)
- [Changelog](docs/CHANGELOG.md)
- [Future Improvements](docs/FutureImprovements.md)
