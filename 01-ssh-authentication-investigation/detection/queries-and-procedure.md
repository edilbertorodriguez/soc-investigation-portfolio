# Queries and reproduction

## Authorized procedure
Use only an owned/authorized lab account. Keep the VM console available. Record UTC time and confirm hostname, target address, Wazuh connectivity and network visibility before testing.

On Windows, record UTC start time:
```powershell
(Get-Date).ToUniversalTime().ToString("o")
```
Run the command below, deliberately enter a wrong password three times, then invoke it again and enter the correct password once. Stop on lockout or an unexpected host-key warning.
```powershell
ssh -o PubkeyAuthentication=no -o PreferredAuthentications=password -o NumberOfPasswordPrompts=3 blueteam@10.10.60.60
```
Inside the successful session, run date -u -Is and whoami, then exit. Export target journal logs for the exact UTC window and hash the saved original. Do not record passwords.

## Wazuh filter
```text
agent.id:"001" AND data.dstuser:"blueteam"
```
Final case window: 2026-10-28 04:11:30–04:14:00 UTC. If browser timezone is UTC-04:00, select 00:11:30–00:14:00 on that date.

## Security Onion Hunt
```text
event.dataset:zeek.conn AND source.ip:10.10.30.60 AND destination.ip:10.10.60.60 AND destination.port:22
```
Correlate source ports 50644 and 50677, timestamps and connection UIDs. Inspect endpoints rather than assuming a stable source identity across NAT.

## Interpretation
Filters are investigation queries, not deployed sequence detection rules. An optional future enhancement is a tested failures-then-success rule keyed by target, account and observed source, evaluated for legitimate user mistakes and shared NAT addresses.
