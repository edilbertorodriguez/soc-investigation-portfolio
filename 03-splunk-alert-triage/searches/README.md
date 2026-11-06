# Search usage

`encoded-powershell-detection.spl` is copied exactly from the saved-alert configuration CSV. Use SPL mode. For historical review, select a time interval covering November 6, 2026, 21:09–21:40 UTC. The scheduled alert uses its own relative window (`-5m` to `now`). Historical data will not fall into that window on a later date.

These are query-local extractions. No persistent field configuration is required or claimed. Do not execute Base64 payloads to decode them; the preserved readable text and 4104 evidence can be examined directly.

The configuration is intentionally preserved as tested rather than silently broadened into an unvalidated production rule.
