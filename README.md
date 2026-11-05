# SOC Investigation Portfolio

Hands-on security investigations by **Edilberto Rodriguez**, documenting alert triage, evidence correlation, UTC timelines, and analyst conclusions in authorized lab environments.

## Investigations

| Project | Tools | Status |
|---|---|---|
| [SSH Authentication Investigation](01-ssh-authentication-investigation/) | Wazuh, Security Onion, Zeek, Linux logs | Completed |
| [Windows Endpoint Investigation](02-windows-endpoint-investigation/) | Sysmon, Wazuh, PowerShell, Windows Registry | Completed |
| Splunk Alert Triage | Splunk, SPL, Windows event logs | Planned |

### 01 — SSH Authentication Investigation

Investigated SSH authentication activity by correlating Linux logs, Wazuh alerts, and network telemetry. Documented the timeline, findings, and escalation criteria.

### 02 — Windows Endpoint Investigation

Correlated PowerShell process creation with a benign file-creation alert, investigated registry Run-value changes, and validated a built-in Wazuh detection for modifications made through `reg.exe`. Preserved original evidence, documented collection and detection limitations, and verified cleanup.

## Demonstrated Skills

- Triaging alerts and distinguishing benign activity from suspicious behavior.
- Correlating process GUIDs, command lines, registry changes, and SIEM alerts.
- Reconstructing investigation timelines in UTC.
- Preserving original evidence and verifying SHA-256 hashes.
- Investigating collection issues and detection-rule conditions.
- Documenting findings, limitations, escalation criteria, and cleanup.

## Scope

These projects are authorized laboratory simulations. Each investigation distinguishes observed evidence from assumptions and documents collection limitations. ATT&CK mappings describe relevant behaviors and do not independently establish compromise.

## Author

**Edilberto Rodriguez**  
BTL1 certified · Systems, networking, and defensive cybersecurity

[GitHub](https://github.com/edilbertorodriguez)
