# Splunk Alert Triage: Encoded PowerShell Execution

**Analyst:** Edilberto Rodriguez  
**Status:** Completed authorized lab investigation  
**Date:** November 6, 2026 (all investigation times in UTC)

Built and validated a scheduled Splunk alert for encoded Windows PowerShell execution, then correlated process creation, script block content, and file activity to explain a benign lab result.

## Outcome

- Confirmed Security, Sysmon, and PowerShell Operational ingestion into `winlab`.
- Resolved a Sysmon collection permission failure and validated search-time field extraction.
- Compared an unencoded control with encoded execution of a harmless marker-writing command.
- Linked Sysmon process creation to PowerShell 4104 and the first encoded marker creation.
- Verified a fresh encoded launch produced a scheduled alert at **21:39:00 UTC**.
- Preserved originals, verified 16 source manifest hashes, and documented cleanup.

**Disposition:** Authorized benign activity. The detection correctly identified encoded execution; encoding alone did not establish malicious intent.

## Review the evidence

- [Investigation report](investigation-report.md)
- [Event timeline](analysis/event-timeline.csv)
- [Detection SPL](searches/encoded-powershell-detection.spl)
- [Validation and limitations](analysis/validation-notes.md)
- [Original exports](evidence/originals/)
- [Screenshots](evidence/screenshots/)
- [Package checksums](SHA256SUMS.txt)

The supplied alert is scoped to this lab host and XML format. Review its documented limitations before adapting it elsewhere.
