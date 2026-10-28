# Network architecture

| Role | Configuration |
|---|---|
| Proxmox management / LAB uplink | 10.10.60.3 → vmbr1 → nic1 (PCI ac:00.0) → Netgear g3 |
| Mirror | g3 TX and RX copied to g2 |
| Security Onion monitoring | g2 → nic0 (PCI ab:00.0), passed through to VM 101 → ens16 → bond0; no monitor IP |
| Security Onion management | VM net0 → vmbr1; guest ens18 at 10.10.60.70 |
| Target | VM 103 scanme, 10.10.60.60, Wazuh agent 001 |
| Wazuh manager | User-confirmed address 10.10.60.101 |
| Test source as observed | 10.10.30.60; Windows Tailscale address was 100.110.244.101 |

The switch showed local VLAN 1. LAB VLAN 60 is the upstream network designation; the upstream untagged/access mapping was not independently exported.

## Visibility and attribution
Traffic switched entirely within vmbr1 may bypass the physical mirror. Source translation on the remote path is a working explanation for the observed source; do not treat it as the original endpoint identity without subnet-router evidence.

## Preparation history — separate from the final incident
Initial SSH rehearsal used scanme at .102 while Security Onion was stopped. Subsequent capture validation used .106. The target was reserved at .60 for the documented final test. Preserve those distinctions if discussing earlier screenshots.

Incorrect passthrough of ac:00.0 took the Proxmox LAB uplink offline. It was recovered through GLKVM, the obsolete vmbr0 bridge retired, and monitoring assigned to ab:00.0. An old snapshot retains conflicting network assignments; do not restore it blindly.
