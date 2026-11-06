# Investigation report

## Summary and disposition

On November 6, 2026, an authorized Windows lab test launched PowerShell with `-EncodedCommand`. A scheduled Splunk alert detected the fresh test process at 21:39:00 UTC. The saved alert result identifies `DESKTOP-P4H3Q32`, user `DESKTOP-P4H3Q32\WinLab`, and Process GUID `{fe9444fb-48c9-6aee-0429-000000000a00}`.

The activity was classified as **authorized benign execution**. Base64 decoding recovered a `Set-Content` command that wrote the string `SOC-WIN003-ENCODED` to a text file in the case directory. PowerShell 4104 independently recorded the same readable command. This is a successful detection of the configured behavior, not evidence of a malicious payload or compromise.

## Scope and environment

| Component | Observed configuration |
|---|---|
| Splunk server | `splunk-lab01`, Ubuntu Server 24.04.3, `10.10.60.71` |
| Server resources | 4 vCPU, 8 GB RAM, 60 GB virtual disk; root expanded to approximately 57 GB |
| Splunk / Universal Forwarder | Version 10.6.1.1 |
| Windows endpoint | `DESKTOP-P4H3Q32`, lab IP `10.10.60.61` |
| Index / receiver | `winlab`, TCP 9997 |
| Collection | Security, Sysmon Operational, Windows PowerShell Operational; XML rendering |
| Case directory | `C:\SOC-Lab\LAB-WIN-003-20261106-194438` |
| Case interval | 19:44:38.9958326–22:23:05.4307219 UTC |

This project reused the existing Windows endpoint. Setup and ingestion validation occurred before the formal case interval. The case resumed after a pause at 21:03:05 UTC; the pause is recorded in the transcript.

## Telemetry preparation

The forwarder initially collected Security events but failed to subscribe to Sysmon with error code 5. The virtual service account `NT SERVICE\SplunkForwarder` was added to the local Event Log Readers group, the service was restarted, and subsequent Splunk results confirmed Sysmon ingestion. This supports the permission diagnosis for that channel. Other startup warnings were not established as the cause.

PowerShell Operational startup events were verified locally and in Splunk. Both queried ScriptBlockLogging policy locations were initially absent. Machine-level `EnableScriptBlockLogging` was set to DWORD 1. A fresh process then generated Event 4104 containing a harmless test string, which was also received in Splunk. Some earlier 4104 events existed; the absent policy keys did not prove that no script blocks had ever been logged.

The initial searches did not populate `EventCode`, `EventID`, or `ScriptBlockText`. Explicit `rex` commands extracted the fields within each query. No persistent field-extraction installation or add-on deployment is claimed.

## Controlled activity and correlation

Three child processes were identified. Each had PowerShell parent PID 7272 and the same parent Process GUID `{fe9444fb-f838-6ae7-6801-000000000a00}`.

| Activity | Sysmon SystemTime UTC | PID | Process GUID suffix |
|---|---|---|---|
| Unencoded control | 21:09:01.1219017 | 5348 | `41ed-6aee-1f28-000000000a00` |
| First encoded execution | 21:19:23.7639589 | 4212 | `445b-6aee-6928-000000000a00` |
| Fresh scheduled-alert test | 21:38:17.9823568 | 8008 | `48c9-6aee-0429-000000000a00` |

All three GUIDs begin with `fe9444fb-`; the complete values are retained in the original XML and timeline.

The control used `-Command` to create `control-marker.txt` containing `SOC-WIN003-CONTROL`. The encoded command used UTF-16LE Base64 to create `encoded-marker.txt` containing `SOC-WIN003-ENCODED`. Both returned exit code 0. The saved Base64 decodes exactly to the preserved readable command, and both encoded process command lines contain that same Base64 value.

For the first encoded process, PowerShell 4104 recorded the decoded command at **21:19:23.9354018 UTC**, followed by Sysmon 11 for `encoded-marker.txt` at **21:19:23.9734295 UTC**. The file event shares the launch Process GUID. The nearby PowerShell script events are linked by host, PID, and tight timing; PowerShell 4104 does not supply a Sysmon Process GUID. PID reuse remains a general reason to constrain this correlation in time.

For the fresh test, PowerShell 4104 recorded the same command at **21:38:18.1308440 UTC** under PID 8008. The marker already existed. The exported Sysmon events do **not** include a second Event 11 for that marker. The report therefore does not assert a second marker creation event. Temporary `__PSScriptPolicyTest_` files appear for the test processes; their names and timing are consistent with PowerShell policy checks and do not alone establish malicious activity.

## Detection and scheduled alert

The exact saved SPL is in `searches/encoded-powershell-detection.spl`. It selects Sysmon Event 1, PowerShell image names, and whitespace-delimited `-enc` or `-encodedcommand` switches. It does not require the lab marker string, a particular PID, or a particular Process GUID.

| Setting | Verified exported value |
|---|---|
| Enabled / scheduled | `disabled=0`, `is_scheduled=1` |
| Cron | `* * * * *` |
| Search window | `-5m` to `now` |
| Condition | Number of events greater than 0 |
| Trigger mode | Per result (`alert.digest_mode=0`) |
| Throttling | Enabled, `host,ProcessGuid`, 10 minutes |
| Tracking / severity | `alert.track=1`, severity 3 (Medium) |

The retrospective detection search returned the first encoded launch while excluding the unencoded control. After saving the alert, a fresh launch was generated. Trigger History recorded **21:39:00 UTC**. Its saved result covers **21:34–21:39 UTC** and matches the fresh GUID. The approximately **42-second** interval is from process SystemTime to the displayed trigger time, not a complete end-to-end latency measurement.

The overlapping windows allow several opportunities to observe recently ingested events. Throttling was configured to suppress duplicate results for the same process. A screenshot showed one trigger, but repeated scheduler logs were not collected to prove every suppression decision.

## Evidence preservation and cleanup

The supplied archive contains 14 Sysmon events (IDs 1, 5, 11) selected by the three process GUIDs and 9 PowerShell 4104 events from the collection interval. XML exports preserve event XML representations, not native EVTX containers. The PowerShell export includes preparation activity as well as child-process script content.

Both marker files were copied into the evidence directory before their originals were removed. Presence checks returned False for both original paths. The transcript closed at 7,886 bytes. Input configuration, script block policy, command text, encoded text, timestamps, and marker copies were retained.

All **16 files** listed in the source SHA256 manifest matched their supplied hashes. The source ZIP SHA256 is `3f266bfa3aa4ff473041fb0b27c923c66984d3cf5adf2a8366b67342a4c72647`. The two Splunk CSV exports were supplied separately; their bytes are preserved with simplified filenames, removing only the duplicate `.csv` extension. Package checksums are separate from the original manifest.

## Limits and lessons

- `current_only=1` avoids historical backlog and may omit events generated while the forwarder is stopped. Continuous completeness is not established.
- Sysmon network/DNS coverage was not demonstrated for this case. No absence-of-network-activity conclusion is made.
- The detection is scoped to one host, uses the observed single-quoted XML layout, covers `powershell.exe` and two switch forms, and is not a comprehensive PowerShell abuse detector. Other abbreviations, quoting, renamed executables, and `pwsh.exe` require additional validation.
- Regex extracts XML text without general XML entity decoding. The controlled command contains no problematic entity characters.
- Base64 is encoding. Analyst disposition requires decoded content, context, and corroborating behavior.
- This was a controlled positive test with an unencoded negative control, not an independent blind investigation or a statistical assessment of detection quality.
- TCP connectivity and receipt of events were established. Custom TLS trust and server certificate verification were not validated; no secure-transport claim is made.
- The lab alert and logging configuration remained enabled. Cleanup removed only the two test marker originals; no persistence mechanism was created.

## References

- [Microsoft: Windows PowerShell logging](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_logging?view=powershell-5.1)
- [Splunk: rex](https://help.splunk.com/en/splunk-enterprise/spl-search-reference/10.0/search-commands/rex)
- [Splunk: saved search REST endpoints](https://help.splunk.com/en/splunk-enterprise/rest-api-reference/10.6/search-endpoints/search-endpoint-descriptions)
- [Splunk: alert throttling](https://help.splunk.com/en/splunk-enterprise/alert-and-respond/alerting-manual/9.3/manage-alert-trigger-conditions-and-throttling/throttle-alerts)
