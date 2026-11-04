# Zero-to-Hero Project Guide — Azure AKS Zero-Trust Platform

## 1. Business scenario
An enterprise runs containerized workloads in Kubernetes. Public control-plane access, over-privileged service accounts, flat pod networking and static cloud secrets create unacceptable risk. The goal is to reduce implicit trust across administrators, workloads and cloud services.

## 2. Target outcome
Build a private AKS control plane, controlled admin connectivity, Entra-integrated authorization, workload identity, segmented node pools, pod network policies, private PaaS access and observability.

## 3. Architecture and request path
Engineer authenticates through Entra → approved private admin network/Bastion/VPN → private AKS API. Workload pods run on system/user pools, use service accounts federated to Entra for Azure access, and communicate only through approved NetworkPolicy paths. Private endpoints expose dependent PaaS services.

## 4. Tool-by-tool
| Tool/service | Role | Interview focus |
|---|---|---|
| AKS | Managed Kubernetes control plane | Responsibility split: Azure manages control plane; customer manages workloads/config |
| Azure VNet/subnets | Cluster network foundation | CIDR sizing, IP capacity and routing |
| NSG | Azure subnet/NIC traffic filtering | Network-layer control, not pod identity |
| Kubernetes NetworkPolicy | Pod ingress/egress segmentation | Requires a supporting network policy implementation |
| Entra ID / Azure RBAC | Human and Azure resource access | Separate Azure resource permissions from Kubernetes API authorization |
| Kubernetes RBAC | API permissions inside cluster | Namespace scope and least privilege |
| Workload Identity | Pod-to-Entra federation | Avoid static service principal secrets |
| Key Vault CSI / Secrets Store | Secret retrieval integration | Prefer identity-based retrieval and rotation |
| Private Endpoint / DNS | Private dependencies | DNS path from nodes and pods |
| Terraform / AzureRM | Repeatable infrastructure | Module/state/provider controls |
| kubectl / Helm | Cluster operations and packaging | Context safety, values and release lifecycle |
| Azure Monitor / Container Insights | Cluster telemetry | Node/pod health, logs, control-plane diagnostics |

## 5. Build and validation sequence
Plan CIDRs and identity → create VNet/subnets/NSGs → provision AKS with private API and Entra integration → configure node pools → configure workload identity → apply NetworkPolicy → integrate Key Vault → enable diagnostics → test admin, pod-to-pod and pod-to-service paths.

## 6. Commands
```bash
az aks show -g <rg> -n <cluster> -o table
az aks get-credentials -g <rg> -n <cluster>
kubectl get nodes -o wide
kubectl get pods -A
kubectl describe pod <pod> -n <namespace>
kubectl get networkpolicy -A
kubectl auth can-i get secrets -n <namespace>
```
Check current kubectl context before any write command.

## 7. Scenario-based Q&A
**Q1. Private AKS API works from Bastion but not from a developer laptop.**  
A: Verify VPN/ExpressRoute/private route, private DNS zone link/resolver, hostname resolution, NSG/Firewall and API server authorized network settings. Private cluster requires a valid private path.

**Q2. A pod can reach every other pod. How do you fix it?**  
A: Define default-deny ingress/egress NetworkPolicies, then explicitly allow required namespace/pod selectors and ports. Confirm the CNI supports enforcement and test denied paths.

**Q3. Why are NSGs not a replacement for NetworkPolicy?**  
A: NSGs filter Azure network interfaces/subnets; NetworkPolicy expresses pod-level communication. Pod identity and Kubernetes API authorization require separate controls.

**Q4. Pod cannot read Key Vault secret.**  
A: Verify workload identity enabled, service-account annotation/subject, federated credential issuer/audience, pod token projection, Azure RBAC data-plane role, vault network/DNS and CSI provider logs.

**Q5. How do you prove zero trust?**  
A: Demonstrate private API access boundaries, least-privilege RBAC, workload identity, default-deny pod network tests, private dependency access, audit logs and incident runbooks. A VNet alone is not zero trust.

## 8. Troubleshooting
Pending pods: node capacity/taints/quotas; ImagePullBackOff: registry auth/network; CrashLoopBackOff: logs/probes/config; DNS: CoreDNS/upstream/private zones; service timeout: endpoints, NetworkPolicy, NSG, routes; auth failure: token claims and role scope.

## 9. Security, reliability and cost
Separate system/user pools; use upgrade channels and disruption budgets; set resource requests/limits; scan/pin images; restrict API access; monitor node pressure; rightsize node pools and avoid idle GPU/oversized nodes.

## 10. Learning path
Containers → Kubernetes objects → services/ingress → RBAC → CNI/NetworkPolicy → AKS networking → Entra/workload identity → Key Vault CSI → Terraform → observability → cluster failure labs.

## 11. Scope honesty
The repo provides the network foundation and intended zero-trust pattern. Do not claim a private production AKS cluster, workload identity or enforced policies unless the cluster and tests actually exist.
