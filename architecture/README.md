# Architecture and trust boundaries

## Reference topology
- **Hub:** central egress inspection, approved operator access, shared DNS.
- **Spoke:** private AKS control-plane connectivity, node pools, ingress, private service endpoints.
- **Identity:** Microsoft Entra ID for human access, managed identities for Azure resource access, Workload ID for pods.
- **Delivery:** GitHub Actions federated to Azure, ACR for images, Argo CD for cluster reconciliation.
- **Operations:** platform telemetry, audit logs, security alerts, backup and recovery.

See the Mermaid architecture in the root README.

## Trust boundaries

| Boundary | Threat | Required controls |
|---|---|---|
| Engineer to Azure | Human identity compromise | Entra MFA, PIM, least privilege, conditional access |
| Pipeline to Azure | CI runner compromise | OIDC federation, scoped roles, environment approvals |
| Cluster API | Control-plane exposure | Private API, private DNS, approved network path |
| Pod to Azure service | Workload identity abuse | Dedicated identity per workload, narrow RBAC, audit |
| Pod to pod | Lateral movement | Namespace boundaries, NetworkPolicy, admission policy |
| Cluster to internet | Egress/exfiltration | Firewall/proxy, explicit destinations, DNS controls |
| Image to runtime | Artifact tampering | Scanning, provenance, immutable digest, registry controls |

## Network flow matrix

| Source | Destination | Port/protocol | Intent |
|---|---|---|---|
| Approved admin network | Private AKS API | TCP 443 | Cluster administration |
| Ingress tier | Application service | App-specific | Inbound application traffic |
| AKS nodes | Required Azure endpoints | HTTPS 443 | Platform operations and image pulls |
| Workload identity | Entra token endpoint | HTTPS 443 | Federated token exchange |
| Workload | Key Vault private endpoint | HTTPS 443 | Secret retrieval |
| Nodes/workloads | DNS resolver | UDP/TCP 53 | Name resolution |
| Workload namespace | Other namespace | Explicit only | East-west traffic |

This is not an exhaustive AKS network requirements list. Consult official AKS outbound network requirements for the chosen version/features before firewall allowlisting.

## Decisions required before deployment
1. Azure CNI Overlay, Azure CNI Pod Subnet, or another supported network mode.
2. Private cluster DNS mode and private DNS zone ownership.
3. Supported firewall egress architecture and routing.
4. Ingress option and its support lifecycle.
5. Key Vault private endpoint, DNS zone links and access model.
6. Single-region versus active/passive regional recovery.
7. Azure Policy and Kyverno ownership to avoid conflicting controls.

This is a reference design, not an audited zero-trust certification or a live deployment.
