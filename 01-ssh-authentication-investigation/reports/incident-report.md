# Incident investigation report

Case LAB-SSH-001 · Analyst Edilberto Rodriguez · 2026-10-28 · Authorized lab simulation

## Executive finding
The account `blueteam` on `scanme` (`10.10.60.60`) experienced three failed SSH password submissions from observed source `10.10.30.60`, followed by a successful login on a new connection. Host journald records, Wazuh alerts and Zeek connection metadata agree on the endpoints, source ports and sequence.

The operator deliberately generated both failures and success. The lab disposition is **authorized test activity; no confirmed compromise**. This is an accurate detection of authentication activity, not a false positive solely because testing was authorized.

## Scope
Test start reported by operator: 2026-10-28T04:11:51.4379041Z. Successful-session clock output: 04:12:59 UTC; this is not the authentication time. Journal acquisition window: 04:11:30–04:14:00 UTC. Target account: blueteam. Wazuh agent: 001. Sensor: securityonion.

## Evidence correlation
| Observation | Host / Wazuh | Zeek |
|---|---|---|
| Failed-password connection | sshd PID 2089; source port 50644; failures at 04:12:05.918308, 04:12:13.968497, 04:12:23.806790 UTC | Start 04:11:57.821 UTC; 16 client and 15 server packets; RSTO |
| Successful-login connection | PID 2091; source port 50677; accepted password at 04:12:44.878751 UTC | Start 04:12:39.637 UTC; 72 client and 49 server packets; RSTO |
| Last failed-password alert | Wazuh rule 5760, level 5, timestamp 04:12:25.755 UTC; full_log 04:12:23 | Same source and destination tuple as failed connection |
| Successful-password alert | Wazuh rule 5715, level 3, timestamp 04:12:45.757 UTC; full_log 04:12:44 | Same tuple as successful connection |

Target for both connections: 10.10.60.60:22. Observed source: 10.10.30.60. Last-failure-to-success interval: 21.071961 seconds. Wazuh timestamps follow the precise host events by 1.948210 and 0.878249 seconds respectively; these differences are observed timestamp offsets, not measured end-to-end ingestion benchmarks.

Both screenshots report zero missed bytes. This does not certify perfect capture across the environment. Both show RSTO (originator reset), including the successful session: do not classify authentication from TCP state or traffic volume. The screenshots display duration values around 28.35 and 26.20, also visible in raw message excerpts; avoid treating the normalized event.duration field as validated ECS units without checking the ingest mapping.

PAM failure summaries and session events overlap the underlying authentication sequence. Nine Wazuh hits are not nine login attempts. Rule firedtimes is not used as the primary count.

## Analyst assessment and escalation
In an unexplained production case, a success after repeated failures merits checking account-owner authorization, expected access time, source identity, target sensitivity and surrounding activity. An aggregated source behind a subnet router cannot identify a unique original endpoint on its own.

Escalate according to the organization’s severity matrix if the account owner denies the login, the source is unexpected, or follow-on evidence suggests abuse. Preserve logs and obtain endpoint/session context before recommending account disablement, session termination or isolation. No containment action was performed for this known test.

## MITRE ATT&CK
The repeated intentional failures simulate password guessing (T1110.001); SSH is associated with T1021.004. Wazuh’s success rule carries T1078/T1021 associations. These are context and rule mappings, not proof of malicious valid-account use, lateral movement, persistence or privilege escalation.

## Limitations and evidence quality
- Host log is reconstructed from pasted console text; its byte hash matches the operator-reported original export if noted in provenance.
- JSON records were supplied as text and reformatted; they are not direct API acquisitions.
- Zeek metadata is supported by screenshots; a full original export/PCAP is not included.
- No post-login process execution or file-change evidence was collected; absence of compromise cannot be concluded from this narrow window alone.
- Authentication outcomes rely on endpoint records; SSH contents are encrypted on the network.
- Automatic sequence correlation was not implemented; the analyst joined evidence manually.

## Closure
Lab objective achieved: corroborated repeated failures followed by success across host, SIEM and network telemetry. Publish as an authorized investigation exercise after reviewing the supplied artifacts and provenance.
