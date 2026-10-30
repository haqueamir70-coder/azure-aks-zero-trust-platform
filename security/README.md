# Zero-trust security model

## Control catalogue

| Domain | Reference control | Verification evidence |
|---|---|---|
| Human identity | Entra ID, MFA, PIM, least privilege | Role assignments, sign-in/audit logs |
| API exposure | Private AKS API | Private FQDN resolution and connectivity test |
| Workload identity | OIDC issuer + federated credential | Token exchange and Azure access test |
| Secrets | Key Vault RBAC + CSI driver | Pod mount test and Key Vault audit logs |
| Network | Hub-spoke, controlled egress, NetworkPolicy | Firewall logs and allowed/denied flow tests |
| Admission | Pod Security Admission + Kyverno | Positive and negative admission tests |
| Images | Registry controls, scan, digest pinning | Scan report, signature/provenance |
| Operations | Diagnostics and alerts | Alert test and log query |

## Threat scenarios
- Stolen developer identity: MFA, PIM, scoped roles, short-lived sessions and audit.
- Compromised CI runner: OIDC, protected environments, pinned actions, minimal permissions and isolated runners.
- Malicious/vulnerable image: scan source and image, generate SBOM, verify provenance, deploy immutable digest.
- Pod privilege misuse: restricted pod security, non-root, dropped capabilities, seccomp and admission policies.
- Lateral movement: namespace boundaries and default-deny NetworkPolicies with explicit flows.
- Secret exfiltration: workload-specific identity, narrow Key Vault permissions, private endpoints and audit.
- DNS/egress abuse: controlled resolvers, firewall egress policy and logging.

## Key Vault integration checklist
1. Enable AKS OIDC issuer and Workload Identity.
2. Create a dedicated user-assigned managed identity.
3. Create a federated credential whose subject matches service account and namespace.
4. Assign only the required Key Vault data-plane role at the narrowest practical scope.
5. Configure Key Vault private endpoint and private DNS where private access is required.
6. Configure supported Secrets Store CSI Driver and Azure provider integration.
7. Test retrieval, denied access for unrelated identity, rotation and audit events.

Never put secret values in Git, Terraform outputs, pipeline logs or plain-text Kubernetes manifests.
