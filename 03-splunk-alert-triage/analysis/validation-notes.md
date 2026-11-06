# Validation notes

The original manifest verified 16/16 files. Both XML files parsed successfully: 14 Sysmon events and 9 PowerShell events. Three Sysmon process creation events were identified. Reapplying the saved switch predicate locally to these launches matched the two encoded executions and excluded the unencoded control. This local check complements the supplied Splunk screenshots; it is not a rerun of Splunk itself.

Base64 was decoded as UTF-16LE without executing it. It matched `encoded-command-decoded.txt` and the encoded argument in both Sysmon launches. The scheduled result GUID matched the fresh process creation GUID. The saved alert configuration confirms per-result triggering, minute scheduling, a five-minute window, and 10-minute suppression using `host,ProcessGuid`.

Timestamps in `event-timeline.csv` preserve both provider `SystemTime` and, where present, Sysmon `UtcTime`. These are distinct timestamps and can differ by milliseconds. Screenshots use Splunk's displayed event time; the timeline retains source precision. The 21:39 trigger is documented by the screenshot, not invented as a Windows event row.

The original XML text includes doubled backslashes in some Windows path fields. Original bytes are retained unchanged. The report uses conventional Windows path notation for readability. Screenshot upload filenames identify receipt times, not event occurrence times.

Original exports stop at the recorded collection endpoint, before final cleanup. Cleanup is evidenced by the transcript and screenshot. No cleanup event is fabricated in the exported-event timeline.

The full investigation report documents coverage, XML extraction, PID correlation, transport verification, and throttling validation limits.
