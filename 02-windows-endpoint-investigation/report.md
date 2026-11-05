# Investigation report — LAB-WIN-002

## Scope and outcome

The objective was to validate Windows process and registry visibility, investigate an unexpected high-severity alert, and test detection of a benign Run-value modification. Work occurred on an authorized Windows 11 VM. The marker script appends UTC time and the current user to a text file. It has no download or network action.

The case demonstrated local process correlation, central detection of a `reg.exe` registry write, and verified removal of the test value. It also exposed a gap between raw event collection and visible alerts for the PowerShell writer. No manager rule was changed and no custom detection was deployed.

## Evidence handling

The case-start marker is **2026-11-05T18:15:31.3306397Z** and collection cutoff is **2026-11-05T19:47:21.0467345Z**. The transcript closed at local 14:55:10 after collection. The original uploaded ZIP contains 16 files. All 15 entries in its SHA-256 manifest match the extracted bytes, including the closed transcript. The manifest does not hash itself.

The selected XML contains 286 events: 10 process creations (1), 13 file creations (11), 248 registry object events (12), 14 value-set events (13), and one configuration change (16). These are a filtered subset, not the full Sysmon channel or an EVTX forensic image. The filter matches the case path, value name, or marker process GUID, so it also captures evidence collection and ancillary registry activity. Of the 248 Event 12 records, 246 are PowerShell CreateKey events, one is the test-value deletion, and one is a related RunNotification deletion. They are not 248 persistence deletions.

Original file bytes and screenshot pixels were preserved. Screenshot names were made descriptive. CSV timelines and JSON summaries are analyst derivatives. The Wazuh summaries were transcribed from JSON supplied in the conversation and corroborated with XML; they are not original downloaded dashboard JSON files.

## 1. Baseline and marker execution

The endpoint was online as agent 003. WazuhSvc and Sysmon64 were running, and the agent configuration included the Sysmon Operational channel. The initial Sysmon configuration used broad empty exclude filters for process, network, file, registry and DNS categories.

The marker script's SHA-256 is:

`D51C71D3F5D95847AFB8658F8FC2C8EC1FC593AB6088E49ECED8345154D431C7`

At **18:21:30.103 UTC**, interactive PowerShell PID 7272 spawned PowerShell PID 1640, GUID `{fe9444fb-c92a-6aec-d917-000000000a00}`, with the marker file in its command line. At **18:21:30.585**, that child spawned `whoami.exe` PID 10372. Exit code 0 and `run-marker.txt` corroborate script execution. A child process reused the existing console; opening a separate window was not required.

An initial script-name search also matched `whoami.exe` because the script path appeared in its ParentCommandLine. Matching the exact ProcessGuid isolated the intended PowerShell record. This illustrates why a text hit must be interpreted in its field context.

## 2. Level-15 file alert triage

At **18:21:30.240 UTC**, the same PowerShell process created:

`C:\Users\WinLab\AppData\Local\Temp\__PSScriptPolicyTest_0ybzq30o.m42.ps1`

Sysmon record **2705444**, Event 11, corresponds to Wazuh rule **92213**, level **15**, document `FObxrKEBRLpb20Tl4isC`. Its description refers to an executable dropped in a malware-associated folder and includes T1105 metadata.

The exact process GUID ties this file to the authorized marker invocation. Microsoft documents this filename pattern as a PowerShell application-control policy test. In this controlled context, the malicious interpretation is a false positive. The record does not establish a network transfer, malware execution, or that AppLocker enforcement was enabled. The script file created earlier in the case also generated a separate overview alert; a file-creation description does not itself prove subsequent execution.

Wazuh's alert timestamp is 18:21:30.191, approximately 49 ms before the event's UTC field. Treat this as a clock/timestamp limitation; do not infer negative transport latency. The timeline uses native event UTC.

## 3. PowerShell Run-value writes without a visible alert

The initial query found `SOC-Lab-WIN002` absent. At **18:41:16.301 UTC**, PowerShell PID 7272 created a REG_SZ value beneath:

`HKCU\Software\Microsoft\Windows\CurrentVersion\Run`

The value pointed to PowerShell running the benign marker. Sysmon **13**, record **2717692**, confirmed SetValue. The user hive appears as `HKU\S-1-5-21-2009194492-745510104-3443609972-1001` in the event. There was no sign-out, reboot, or demonstrated autorun activation.

The dashboard showed agent alerts but no matching Event 13 result in the tested window. Agent logs contained repeated buffer saturation warnings and occasional EvtFormatMessage errors. These observations identify possible collection reliability issues, but do not establish that the specific registry event was lost or that a formatting error affected it.

## 4. Collection tuning and retest

The original configuration and agent log were preserved before tuning. Sysmon accepted the narrower configuration at **19:08:21.174 UTC**, Event 16, record **2736694**. The recorded configuration hash is:

`DC712284EE586CCB9F8FC13DF67769D9C1538E43E376DD0FFF0978D53F53BFDD`

The new configuration retained process creation, selected case-file/policy-test file creation, and registry objects containing `\CurrentVersion\Run`. Empty include filters disabled network and DNS logging. The registry substring also matches RunOnce and RunNotification, so it is broader than one exact Run key. This was a focused lab configuration and trades away other telemetry.

At **19:13:14.433 UTC**, PowerShell changed the value to add `-NoLogo` (record **2736707**). The local event was present; the Event 13 dashboard query still returned no result. Tuning alone did not resolve that visible alert gap.

The after-tuning agent log contains no newer buffer warning after the pre-tuning 13:53:12 local warning and 13:53:41 recovery, through its last entry at 14:35:07 local. This limited interval is encouraging, but it is not a measured event-loss or throughput improvement, and does not prove an empty queue.

## 5. Installed rule conditions and successful reg.exe test

Read-only inspection of the installed rules found base rule **61615 at level 0** for Sysmon 13 and Run-key parent **92300 at level 0**. The displayed rule **92302** is level 6, inherits from 92300, and requires the writer's `win.eventdata.image` to match `reg\.exe`. The inspected sibling rules have separate extension or remote-access-tool conditions.

The PowerShell writer does not satisfy 92302's reg.exe condition. This explains why raw registry telemetry need not become that visible alert. The rule inspection supports a coverage explanation, but manager archives or logtest replay were not collected to prove the exact final rule match for the initial PowerShell writes. Buffer loss remains a separate, unquantified possibility. No-results in an alerts view is not proof of missing raw telemetry.

At **19:31:19.641 UTC**, `reg.exe` PID **11604**, GUID `{fe9444fb-d987-6aec-4318-000000000a00}`, launched the `add` command. At **19:31:19.652**, Sysmon **13**, record **2736761**, recorded the updated value containing `-NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -File` and the marker path.

Wazuh generated rule **92302**, level **6**, at **19:31:20.573 UTC**, document `YuYxraEBRLpb20TlxSvS`. The dashboard and supplied JSON match the writer, GUID, target, details, UTC and event record. This validates the tested reg.exe path, rather than universal Run-key coverage.

Rule metadata maps to **T1547.001 / Registry Run Keys / Startup Folder**. Registration is relevant to persistence behavior; the alert's Privilege Escalation tactic label does not demonstrate that privileges increased.

## 6. Cleanup and disposition

At **19:41:41.909 UTC**, reg.exe PID **7064** deleted `SOC-Lab-WIN002`; Sysmon **12 / DeleteValue**, record **2736819**, corroborates the successful delete command. A subsequent query returned not found with exit code 1. The deleted object is the exact lab value, not the entire Run key. Evidence files remain intact.

**Disposition:** Authorized benign simulation completed. One high-severity file alert was explained as a benign policy probe; one Run-value modification generated the expected built-in reg.exe alert. Local telemetry verified cleanup. No compromise, sign-in activation, actual privilege escalation, or malicious ingress transfer was demonstrated.

## Limitations and follow-up

- Alert screenshots are point-in-time views. The PowerShell writes were not replayed through manager logtest and manager archive receipt was not verified.
- The event subset includes collection artifacts and is not a complete endpoint activity record. No memory or disk image was acquired.
- Buffer warnings were documented, not converted into a quantified count of lost events.
- No custom rule was implemented. A future improvement would test a Run-value detection independent of the writer with benign/negative controls, preserving the current built-in behavior.
- The active tuned configuration is referenced under the case evidence folder. Retain that folder. Before moving or deleting it, copy the configuration to a stable tools path and apply/verify it there. Do not automatically restore the broad configuration that produced excessive volume.
- No cleanup alert in Wazuh is claimed; cleanup is supported locally.

## References

- [Microsoft Sysmon events](https://learn.microsoft.com/en-us/windows/security/operating-system-security/sysmon/sysmon-events).
- [Microsoft PowerShell application control](https://learn.microsoft.com/en-us/powershell/scripting/learn/application-control?view=powershell-7.4), policy-test filename behavior.
- [Microsoft Sysmon configuration](https://learn.microsoft.com/en-us/windows/security/operating-system-security/sysmon/sysmon-configuration-files).
- [Wazuh rule classification](https://documentation.wazuh.com/current/user-manual/ruleset/rules/rules-classification.html) and [alert management](https://documentation.wazuh.com/current/user-manual/manager/alert-management.html).

Installed manager output, preserved screenshots, and original exports take precedence for version-specific findings in this case.
