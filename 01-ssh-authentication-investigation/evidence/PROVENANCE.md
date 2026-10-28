# Evidence provenance

Case date: 2026-10-28. This package uses supplied screenshots and pasted text. No direct access to the lab or original manager/endpoint files was performed by the assistant.

- Screenshots are copies of the user's supplied image attachments, renamed for navigation; no image edits applied.
- 01-target-baseline-transcript.txt is a compact labeled transcription.
- 05-ssh-host-transcript.log reconstructs the eight journal lines supplied as text. The reported original export was collected using journalctl over 04:11:30–04:14:00 UTC.
- Original export SHA-256 reported by operator: `0c09e3c6646083b08396b1e4463ec1bd9b3f18b8a8eaf96369d4ec66f59b09b1`.
- Reconstructed transcript SHA-256 computed locally: `0c09e3c6646083b08396b1e4463ec1bd9b3f18b8a8eaf96369d4ec66f59b09b1`.
- Byte-hash match: **True**. Matching bytes support faithful reconstruction; they do not independently authenticate the source host or collection process.
- 06-wazuh-failure.json and 07-wazuh-success.json preserve the supplied field values, reformatted as JSON; whitespace/order may differ from the source export.
- Wazuh event-list screenshot documents three rule-5760 alerts; only the final failure is included as full JSON.
- Zeek evidence is screenshot-based. UID is visible in log.id.uid and message; consult screenshots for authoritative casing rather than a manual transcription. Normalized duration is left uninterpreted in the machine-readable timeline.
- Case conclusion is a known authorized simulation. No post-login command audit or original PCAP is included.

SHA256SUMS.txt hashes the delivered evidence files as packaged, separate from any source-export hashes. The manifest itself is excluded from its own list.
