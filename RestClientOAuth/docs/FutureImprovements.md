## Future Improvements

Potential enhancements (not implemented yet):

- Persistent secure token cache (e.g., encrypted isolated storage) with opt-in configuration.
- Telemetry hooks (token acquisition duration, refresh counts, error taxonomy).
- Additional authority implementations (e.g., other OAuth-compliant IdPs) with validation test suites.
- Pluggable token persistence strategy interface.
- Enhanced secret management guidance & integration with secure storage providers.
- Automatic retry/backoff for transient HTTP failures.
- Structured logging / diagnostics events.

### TODO
- Design proposal for token persistence interface
- Add performance considerations section
