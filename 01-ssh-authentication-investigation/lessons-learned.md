# Lessons learned

- Separate physical monitoring from host management before configuring PCI passthrough.
- Stabilize service and target addresses. scanme's agent was trying the manager's previous .106 address; correcting it to .101 restored agent connectivity.
- Verify the entire pipeline: packets on bond0, Zeek records, indexed Hunt results, and matching event details.
- Remove inherited Hunt filters before diagnosing missing data.
- Count password failures from host records; PAM summaries, rule counters and alert totals can overlap.
- Correlate endpoints and source ports, then time; source IP alone is insufficient behind translation.
- RSTO can appear on both failed-authentication and successful sessions. It is a transport outcome.
- Keep original exports privately and distinguish screenshots, transcripts and reformatted JSON.
- No enterprise SOC tenure, automatic sequence detection, actual compromise, or production containment is claimed.
