## Troubleshooting

| Symptom | Possible Cause | Resolution |
|---------|----------------|-----------|
| Authorization page repeats login | Missing/incorrect state handling (custom redirect) | Ensure state is preserved through round-trip |
| Access token expires & no silent refresh | Refresh token lost (new instance) | Re-run Authorization Code flow; design persistent layer if needed |
| invalid_client error | Secret/certificate mismatch or wrong tenant | Verify credential and tenant ID |
| invalid_scope error | Scope not consented / typo | Correct scope, ensure admin consent if required |
| redirect_uri_mismatch | Redirect URI differs from registration | Align configured URI with actual request |
| certificate signature error | Incorrect private key or key format | Confirm key XML & certificate correspond |
| admin consent required | Lacking permissions | Use Prompt Interaction::"Admin Consent" or grant in portal |

### Logs & Diagnostics
Leverage error messages raised via `ErrorInfo` from HTTP responses for detailed diagnostics.

### TODO
- Provide structured logging integration guidance
