## FAQ

**Q: All objects do have a suffix KFM. Why is that and should I change it?**
All extension objects for Business Central should have a prefix or suffix. Chances are that this module will be adopted in the system app of Business Central. Then the suffixes will be removed. To avoid possible conflicts when that happens, it is recommended to have a suffix on all objects. You may change KFM to any other suffix you prefer. 

**Q: The object number range is in the PTE range. Should I change this?**
Feel free to renumber the objects to a range that fits your apps.

**Q: Why do I need to re-authenticate after a restart?**  
Tokens are in-memory only; refresh token disappears when the Rest Client instance is disposed.

**Q: Why is offline_access automatically added?**  
To obtain a refresh token enabling silent refresh (within object lifetime) for the Authorization Code flow.

**Q: Why use PKCE with a confidential client?**  
Defense-in-depth: mitigates interception even if authorization code is leaked.

**Q: When should I choose a certificate over a secret?**  
When you want stronger credential assurance and easier rotation without secret string exposure.

**Q: Can I support another identity provider?**  
Design is pluggable via `OAuth Authority`, but only Microsoft Entra ID is tested. Additional providers would need a new authority implementation (see Extensibility).

**Q: How do I handle an expired token in Client Credentials flow?**  
The flow simply requests a fresh token—no refresh token concept exists.

**Q: Can I persist tokens?**  
Not currently; would require adding a persistence layer (see Future Improvements).

**Q: Why does the advanced redirect sometimes avoid a popup?**  
It leverages a control add-in within the existing browser session (SSO-like behavior) if the user is already authenticated.

**Q: How do I force re-consent?**  
Set `Prompt Interaction` to Consent or Admin Consent.

### TODO
- Add guidance for multi-tenant scenarios
- Add guidance to client-credentials flow
