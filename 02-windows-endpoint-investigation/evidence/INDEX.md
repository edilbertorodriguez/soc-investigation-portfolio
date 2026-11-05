# Evidence index

## Screenshots

All screenshots are supplied by the lab operator, renamed descriptively, and copied without pixel edits.

| No. | Screenshot | Purpose |
| --- | --- | --- |
| 01 | [01-wazuh-agent-online.png](screenshots/01-wazuh-agent-online.png) | wazuh agent online |
| 02 | [02-windows-endpoint-baseline.png](screenshots/02-windows-endpoint-baseline.png) | windows endpoint baseline |
| 03 | [03-sysmon-wazuh-configuration.png](screenshots/03-sysmon-wazuh-configuration.png) | sysmon wazuh configuration |
| 04 | [04-sysmon-active-configuration.png](screenshots/04-sysmon-active-configuration.png) | sysmon active configuration |
| 05 | [05-evidence-session-start.png](screenshots/05-evidence-session-start.png) | evidence session start |
| 06 | [06-marker-script-and-sha256.png](screenshots/06-marker-script-and-sha256.png) | marker script and sha256 |
| 07 | [07-marker-script-execution.png](screenshots/07-marker-script-execution.png) | marker script execution |
| 08 | [08-sysmon-whoami-child-process.png](screenshots/08-sysmon-whoami-child-process.png) | sysmon whoami child process |
| 09 | [09-sysmon-powershell-process.png](screenshots/09-sysmon-powershell-process.png) | sysmon powershell process |
| 10 | [10-wazuh-sysmon-alert-overview.png](screenshots/10-wazuh-sysmon-alert-overview.png) | wazuh sysmon alert overview |
| 11 | [11-wazuh-policy-test-event.png](screenshots/11-wazuh-policy-test-event.png) | wazuh policy test event |
| 12 | [12-wazuh-policy-test-rule.png](screenshots/12-wazuh-policy-test-rule.png) | wazuh policy test rule |
| 13 | [13-run-value-absent-before-test.png](screenshots/13-run-value-absent-before-test.png) | run value absent before test |
| 14 | [14-lab-run-value-created.png](screenshots/14-lab-run-value-created.png) | lab run value created |
| 15 | [15-sysmon-run-value-set.png](screenshots/15-sysmon-run-value-set.png) | sysmon run value set |
| 16 | [16-wazuh-agent-alerts-registry-search-followup.png](screenshots/16-wazuh-agent-alerts-registry-search-followup.png) | wazuh agent alerts registry search followup |
| 17 | [17-wazuh-agent-buffer-warnings.png](screenshots/17-wazuh-agent-buffer-warnings.png) | wazuh agent buffer warnings |
| 18 | [18-sysmon-tuned-configuration-applied.png](screenshots/18-sysmon-tuned-configuration-applied.png) | sysmon tuned configuration applied |
| 19 | [19-wazuh-agent-status-after-tuning.png](screenshots/19-wazuh-agent-status-after-tuning.png) | wazuh agent status after tuning |
| 20 | [20-run-value-retest-after-tuning.png](screenshots/20-run-value-retest-after-tuning.png) | run value retest after tuning |
| 21 | [21-sysmon-registry-retest.png](screenshots/21-sysmon-registry-retest.png) | sysmon registry retest |
| 22 | [22-wazuh-registry-retest-search.png](screenshots/22-wazuh-registry-retest-search.png) | wazuh registry retest search |
| 23 | [23-wazuh-sysmon13-base-rule.png](screenshots/23-wazuh-sysmon13-base-rule.png) | wazuh sysmon13 base rule |
| 24 | [24-reg-exe-run-value-test.png](screenshots/24-reg-exe-run-value-test.png) | reg exe run value test |
| 25 | [25-wazuh-reg-exe-detection-results.png](screenshots/25-wazuh-reg-exe-detection-results.png) | wazuh reg exe detection results |
| 26 | [26-wazuh-run-value-event.png](screenshots/26-wazuh-run-value-event.png) | wazuh run value event |
| 27 | [27-wazuh-run-value-rule.png](screenshots/27-wazuh-run-value-rule.png) | wazuh run value rule |
| 28 | [28-run-value-cleanup-verification.png](screenshots/28-run-value-cleanup-verification.png) | run value cleanup verification |
| 29 | [29-sysmon-run-value-deleted.png](screenshots/29-sysmon-run-value-deleted.png) | sysmon run value deleted |
| 30 | [30-sysmon-evidence-export-counts.png](screenshots/30-sysmon-evidence-export-counts.png) | sysmon evidence export counts |

## Original Windows files

The 16 files under `original/` preserve the uploaded contents. Windows ZIP separators were normalized to directories during extraction; file bytes were not changed.

| File | Bytes |
| --- | --- |
| [evidence/case-end-utc.txt](original/evidence/case-end-utc.txt) | 30 |
| [evidence/case-start-utc.txt](original/evidence/case-start-utc.txt) | 30 |
| [evidence/cleanup-start-utc.txt](original/evidence/cleanup-start-utc.txt) | 30 |
| [evidence/execution-transcript.txt](original/evidence/execution-transcript.txt) | 22575 |
| [evidence/reg-exe-test-start-utc.txt](original/evidence/reg-exe-test-start-utc.txt) | 30 |
| [evidence/registry-retest-start-utc.txt](original/evidence/registry-retest-start-utc.txt) | 30 |
| [evidence/run-value-set-events.xml](original/evidence/run-value-set-events.xml) | 1316 |
| [evidence/sha256-manifest.csv](original/evidence/sha256-manifest.csv) | 2256 |
| [evidence/sysmon-before-tuning.xml](original/evidence/sysmon-before-tuning.xml) | 318 |
| [evidence/sysmon-case-events.txt](original/evidence/sysmon-case-events.txt) | 173261 |
| [evidence/sysmon-case-events.xml](original/evidence/sysmon-case-events.xml) | 319116 |
| [evidence/sysmon-tuned.xml](original/evidence/sysmon-tuned.xml) | 585 |
| [evidence/wazuh-agent-after-tuning.log](original/evidence/wazuh-agent-after-tuning.log) | 10410 |
| [evidence/wazuh-agent-before-tuning.log](original/evidence/wazuh-agent-before-tuning.log) | 10258 |
| [lab-marker.ps1](original/lab-marker.ps1) | 185 |
| [run-marker.txt](original/run-marker.txt) | 77 |

## Derived data

[Wazuh alert summaries](derived/wazuh-alert-summaries.json) are normalized from two user-pasted JSON alerts and correlated against the original Sysmon XML. They are not original dashboard export files. The two CSV timelines at the project root are generated from the original XML.
