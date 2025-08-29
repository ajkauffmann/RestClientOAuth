## Architecture

High-level overview of how the module composes OAuth 2.0 functionality for outbound REST calls in Business Central.

### Component Summary
- OAuth Client Application: Stores client id, secret or certificate, redirect URI type, scopes.
- OAuth Confidential Client: Performs token / refresh HTTP requests (with secret or signed client assertion).
- Authorization Flows: Authorization Code Grant and Client Credentials orchestrate token lifecycle.
- Redirect URI Implementations: Built‑in page redirect or custom control add-in.
- Authority (e.g. Microsoft Entra ID): Supplies discovery metadata (authorization, token endpoints).
- Http Authentication OAuth2: Facade consumed by the Rest Client; delegates to chosen flow to obtain bearer header.
- Rest Client: Issues outbound HTTP calls injecting the Authorization header provided by Http Authentication OAuth2.

---
### Component Diagrams

#### Part 1: Injection into Rest Client & Outbound Call Path
A minimalist structural view focused on how the Rest Client obtains an Authorization header and calls the external API.

```mermaid
flowchart LR
    RC[Rest Client] --> HA[Http Authentication OAuth2]
    HA --> Flow[Selected Flow]
    Flow --> OCC[Confidential Client]
    OCC --> AUTHY[Authority]
    RC --> API[(External API)]
```

Notes:
- Configuration objects and redirect handling are omitted here (details follow in Parts 1a/1b).
- Only one concrete flow instance backs `Selected Flow` at runtime (Auth Code or Client Credentials).
- Confidential Client is the only component performing HTTP token/refresh requests to the Authority.
- Rest Client proceeds to call the external API after `HA` returns a bearer token.

#### Part 1a: Detail – Composition (Authorization Code Grant Flow)
```mermaid
flowchart LR
    subgraph Config
        OCA[OAuth Client Application]
        AUTHY[Authority / Entra ID]
        RURI[Redirect URI Impl]
    end
    ACF[Auth Code Grant Flow]
    OCC[OAuth Confidential Client]
    HA[Http Authentication OAuth2]

    OCA --> ACF
    RURI --> ACF
    AUTHY -.-> ACF
    ACF --> OCC
    HA --> OCA
    HA --> ACF
```

#### Part 1b: Detail – Composition (Client Credentials Flow)
```mermaid
flowchart LR
    subgraph Config
        OCA[OAuth Client Application]
        AUTHY[Authority / Entra ID]
    end
    CCF[Client Credentials Flow]
    OCC[OAuth Confidential Client]
    HA[Http Authentication OAuth2]

    OCA --> CCF
    AUTHY -.-> CCF
    CCF --> OCC
    HA --> OCA
    HA --> CCF
```

Notes (for 1a/1b details):
- Dotted links from Authority indicate metadata (token endpoints) used by the flow; only the Confidential Client performs HTTP requests later to the authority endpoints.
- Redirect URI implementation (built-in or custom control add-in) is only part of Authorization Code flow.
- Confidential Client manages token and refresh exchanges for both flows.

#### Part 2: Runtime Usage & Token Retrieval
Illustrates how a REST call triggers token retrieval or refresh.

```mermaid
sequenceDiagram
    participant RC as Rest Client
    participant HA as Http Authentication OAuth2
    participant Flow as Selected Flow (Auth Code | Client Creds)
    participant OCC as OAuth Confidential Client
    participant AUTHY as Authority (Microsoft Entra ID)
    participant API as External API

    RC->>HA: Need Authorization header
    HA->>Flow: GetAuthorizationHeader()
    alt Token cached & valid
        Flow-->>HA: Bearer token
    else Missing / Expired
        alt Auth Code & refresh token available
            Flow->>OCC: AcquireTokenByRefreshToken()
            OCC->>AUTHY: POST /token (refresh_token)
            AUTHY-->>OCC: New access (± refresh)
        else Full acquisition
            Flow->>OCC: Acquire (auth_code | client_credentials)
            OCC->>AUTHY: POST /token (grant-specific)
            AUTHY-->>OCC: access_token (+ refresh_token if auth code)
        end
        OCC-->>Flow: AuthenticationResult
        Flow-->>HA: Bearer token
    end
    HA-->>RC: Authorization header
    RC->>API: HTTPS request with Bearer token
    API-->>RC: Response
```

Notes:
- Only the Confidential Client sends HTTP calls to the Authority.
- Authorization Code flow prefers refresh over initiating a new browser/device interaction.
- Client Credentials flow never has a refresh token; it reacquires a new token on expiry.

---
### Sequence: Authorization Code Grant (High-Level)

```mermaid
sequenceDiagram
    participant User as User
    participant BC as BC Page / Redirect Handler
    participant Flow as Auth Code Flow
    participant OCC as Confidential Client
    participant AUTHY as Entra ID

    User->>BC: Initiate sign-in
    BC->>Flow: StartAuthorization()
    Flow->>BC: Build auth URL (PKCE,state)
    BC->>AUTHY: Open authorization URL
    AUTHY-->>BC: Redirect with code (+ state)
    BC->>Flow: Provide code + original verifier
    Flow->>OCC: AcquireTokenByAuthorizationCode(code, verifier)
    OCC->>AUTHY: POST /token (authorization_code + PKCE)
    AUTHY-->>OCC: access_token + refresh_token
    OCC-->>Flow: AuthenticationResult
    Flow-->>BC: Bearer token (stored in memory only)
```

### Sequence: Client Credentials Flow

```mermaid
sequenceDiagram
    participant Caller as Calling Code
    participant Flow as Client Credentials Flow
    participant OCC as Confidential Client
    participant AUTHY as Entra ID

    Caller->>Flow: GetAuthorizationHeader()
    alt Cached valid token
        Flow-->>Caller: Bearer token
    else Expired / None
        Flow->>OCC: AcquireTokenForClient()
        OCC->>AUTHY: POST /token (client_credentials)
        AUTHY-->>OCC: access_token (no refresh)
        OCC-->>Flow: AuthenticationResult
        Flow-->>Caller: Bearer token
    end
```

### Sequence: Refresh (Authorization Code Flow)

```mermaid
sequenceDiagram
    participant Flow as Auth Code Flow
    participant OCC as Confidential Client
    participant AUTHY as Entra ID

    Flow->>Flow: Access token expired?
    alt Yes
        Flow->>Flow: Refresh token present?
        alt Yes
            Flow->>OCC: AcquireTokenByRefreshToken()
            OCC->>AUTHY: POST /token (refresh_token)
            AUTHY-->>OCC: new access_token (+ optional new refresh_token)
            OCC-->>Flow: Updated AuthenticationResult
        else No
            Flow->>Flow: Trigger full authorization flow
        end
    end
```

### Advanced Redirect URI
The advanced redirect implementation uses a control add-in to encapsulate browser interaction and can enable an SSO-like experience (reuse existing session, possibly suppressing interactive prompts). See [Advanced Redirect URI](AdvancedRedirectURI.md).

---
### Key Design Choices
- In-memory token storage: tokens tied to object lifetime; no persistent cache.
- PKCE + state enforced for Authorization Code flow for prevent CSRF attacks.
- Scope offline_access auto-added for Authorization Code flow to enable refresh token issuance.
- Certificate support allows JWT client assertions (reduces secret distribution) in both flows.

### Extensibility Notes
- Additional authorities can implement the authority interface to supply endpoints and additional properties.
- New flows could plug in provided they delegate final token exchange to the Confidential Client.

For implementation details see: `Flows.md`, `Extensibility.md`, and `SecurityConsiderations.md`.
