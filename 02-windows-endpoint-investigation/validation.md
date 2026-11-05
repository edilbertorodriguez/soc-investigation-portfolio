# Validation

- Source ZIP: `LAB-WIN-002-20261105-131452.zip`; 16 files; archive CRC test passed.
- Source ZIP SHA-256: `5513edd6189f7485d585659b20cf93e1f90504f89e1f9bcbf6df53db146e9aa4`.
- All **15 of 15** manifest entries verified against original bytes. Original manifest retained at `evidence/original/evidence/sha256-manifest.csv`; Windows paths identify the source locations.
- Marker script SHA-256 matches screenshot 06: `D51C71D3F5D95847AFB8658F8FC2C8EC1FC593AB6088E49ECED8345154D431C7`.
- Original selected event XML parses; counts: Event 1 = 10, 11 = 13, 12 = 248, 13 = 14, 16 = 1; total **286**.
- Original pre-tuning XML and both Sysmon configurations parse.
- Normalized Wazuh summaries correlate to event records **2705444** and **2736761**.
- **30** screenshots included; no pixel changes. Relative Markdown file links checked.
- `SHA256SUMS` covers all package files except itself. It is an additional packaging manifest, distinct from the Windows collection manifest.

Scope: these checks establish internal consistency of the supplied evidence and package. They do not establish complete event collection, absence of loss, manager receipt of the initial PowerShell writes, or independent system authenticity.
