# Queries and detection reasoning

Use **Lucene**, as shown in the screenshots. Set an absolute time window covering **November 5, 2026, 18:15–19:48 UTC** (13:15–14:48 in the displayed UTC-5 local time). Relative windows used during the exercise will not find historical events later.

Agent alerts:
```text
agent.id:"003"
```
Sysmon alerts:
```text
agent.id:"003" AND data.win.system.channel:"Microsoft-Windows-Sysmon/Operational"
```
Successful Run-value detection:
```text
agent.id:"003" AND rule.id:"92302"
```
Registry value-set alerts:
```text
agent.id:"003" AND data.win.system.eventID:"13"
```
Marker process correlation, where matching alerts exist:
```text
agent.id:"003" AND data.win.eventdata.processGuid:"{fe9444fb-c92a-6aec-d917-000000000a00}"
```

These queries search indexed alerts. Sysmon Event 1 or 13 existing locally does not guarantee a record in `wazuh-alerts-*`. Separate local collection, agent transport, manager decoding/rules, alert severity and indexing when troubleshooting. Do not lower global thresholds simply to make this screenshot appear.

## Read-only manager inspection used

```bash
sudo sed -n '/<rule id="61615"/,+10p' /var/ossec/ruleset/rules/0595-win-sysmon_rules.xml
sudo sh -c 'grep -n -i -B 5 -A 12 "currentversion.*run" /var/ossec/ruleset/rules/*sysmon*'
sudo sed -n '1,110p' /var/ossec/ruleset/rules/0860-sysmon_id_13.xml
```

The wildcard expansion was moved inside the privileged shell because the ordinary shell could not expand the protected directory. No ruleset file was edited.

| Installed rule | Level | Relevant condition | Evidence |
| --- | --- | --- | --- |
| 61615 | 0 | Sysmon Event 13 base classification | Screenshot 23 |
| 92300 | 0 | Run-related targetObject and sysmon_event_13 group | User-supplied manager text |
| 92301 | 12 | Child of 92300; details match lnk/vbs/vba | User-supplied manager text |
| 92302 | 6 | Child of 92300; writer image matches reg.exe | Manager text and observed alert |
| 92303 | 12 | Child of 92300; details match VNC/tvnserver.exe | User-supplied manager text |

These are the inspected relevant rules, not a claim to have audited the complete ruleset. No full manager rules file was uploaded. The final detection used reg.exe; changing the writer was a deliberate test of the installed condition, not a fix to PowerShell coverage.

## Detection improvement proposed, not deployed

Test a scoped rule for Event 13 on an exact Run/RunOnce value path that records writer, user and value details without requiring reg.exe. Validate PowerShell and reg.exe positive controls, unrelated-key negative controls, and authorized software changes before enabling it. Assess ingestion independently with raw receipt evidence. Preserve the existing level-0 parent rules rather than modifying vendor files.
