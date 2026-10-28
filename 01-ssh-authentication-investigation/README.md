# SSH Authentication Investigation with Wazuh and Zeek

**Author:** Edilberto Rodriguez  
**Case:** LAB-SSH-001  
**Status:** Investigation documented; ready for author review before publication  
**Environment:** Authorized personal homelab simulation, not production SOC experience

Three failed SSH passwords were followed by a successful login to the same account. I correlated Linux authentication logs, Wazuh alerts and Zeek network records to reconstruct the sequence and assess whether escalation was warranted.

## Key findings
- Target: `scanme` (`10.10.60.60`), account `blueteam`.
- Observed source: `10.10.30.60`; remote Windows traffic traversed a Tailscale subnet path.
- Three password failures shared source port `50644`; the successful login used `50677`.
- Authentication succeeded **21.072 seconds after the final failure**.
- Wazuh raised failure rule `5760` and success rule `5715`.
- Zeek recorded both SSH connections. Both ended with `RSTO`; TCP termination state does not determine authentication outcome.
- Known authorized test activity: no actual compromise or production containment is claimed.

## Read the investigation
- [Incident report](reports/incident-report.md)
- [UTC timeline](reports/timeline.csv)
- [Network architecture](architecture/network.md)
- [Queries and reproduction](detection/queries-and-procedure.md)
- [Evidence provenance and hashes](evidence/PROVENANCE.md)
- [Lessons learned](lessons-learned.md)
- [Publication checklist](PUBLICATION_CHECKLIST.md)

## Skills demonstrated
Authentication triage; host/SIEM/network correlation; precise UTC timelines; evidence provenance and hashing; interpretation of NAT limitations; documented escalation decisions; troubleshooting capture and log-delivery paths.

## Limits
This project demonstrates manual investigation. No automatic failures-followed-by-success correlation rule was deployed. The three failures are established by host logs and the Wazuh event-list screenshot; one full failure JSON and one full success JSON are supplied. Zeek details are screenshot evidence, not original JSON exports. Post-login commands were operator-reported and were not audited through command-execution telemetry.

All addresses are private lab addresses retained consistently for technical correlation. Screenshots and JSON contain local identifiers. Review the publication checklist before pushing.
