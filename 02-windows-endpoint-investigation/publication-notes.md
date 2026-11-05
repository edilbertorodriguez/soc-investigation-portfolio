# Publication and use

Extract `02-windows-endpoint-investigation` beside the existing `01-ssh-authentication-investigation` folder in the SOC portfolio repository. Upload or commit that folder; do not place only the ZIP inside the repository. The relative screenshot links are ready for GitHub Markdown.

The package includes lab-only hostnames, private IP addresses, a Windows SID, user name, local paths and diagnostic logs. These identify this lab and are retained for evidence correlation. No credential was identified in the reviewed transcript/logs. Review the included originals before public publication according to your own disclosure preference. This package does not publish anything automatically.

Original evidence bytes are unchanged. Derivative timelines and alert summaries are clearly separated. The uploaded source ZIP is retained separately from this publication package; its SHA-256 appears in validation.md. Do not claim forensic acquisition or a complete audit trail before the export: hashes establish the supplied files' consistency at packaging time, not independent authenticity of the source system.

The tuned Sysmon configuration remains active under the Windows case folder. Keep the folder or relocate/apply the config to a stable tools path before removing that folder. The registry test value has already been removed. Running the marker script alone does not re-create persistence.
