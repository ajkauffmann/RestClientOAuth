## Advanced Redirect URI

The advanced redirect sample demonstrates implementing a custom redirect landing page via a control add-in to streamline user interaction and enable SSO-like behavior: if the browser session is already authenticated, the flow can complete without an additional popup.

### Built-in vs Advanced
- Built-in: Opens an embedded page that constructs the authorization URL and handles state/PKCE.
- Advanced: Uses control add-in `OAuth Authorization Control` and page `AuthCodeGrantFlowAdvanced` to pass structured parameters (JSON) and start the flow inside existing user context.

### Parameters JSON (excerpt from advanced implementation)
```al
JObj.Add('authorization_endpoint', OAuthAuthority.GetAuthorizationEndpoint(OAuthClientApplication));
JObj.Add('redirect_uri', OAuthClientApplication.GetRedirectUri());
JObj.Add('code_challenge', PKCECodeChallenge);
JObj.Add('code_challenge_method', 'S256');
```

### Benefits
- Potential single sign-on experience (no extra popup if user already recognized).
- Centralized error & cancellation events (AuthorizationErrorOccurred, AuthorizationCanceledByUser).
- Extensible: additional parameters (like prompt) are added to JSON structure.

### When to Use
Adopt the advanced redirect for improved UX or when integrating with external identity policies requiring a specific hosted landing page.

### TODO
Add example of hosting the landing HTML and recommended CSP headers.
