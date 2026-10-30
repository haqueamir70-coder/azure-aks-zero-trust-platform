# Senior Azure AKS / Zero Trust interview preparation

## 1. What is the objective of this platform?

To build a private, identity-first Kubernetes platform on Azure. Access is explicitly authenticated and authorized, network paths are restricted, workloads receive scoped identities, and policy and telemetry provide continuous control and evidence.

## 2. What has actually been deployed in this lab?

An existing resource group is used. Terraform deployed a VNet (`10.20.0.0/16`), an AKS-reserved subnet (`10.20.1.0/24`), a private-endpoint subnet (`10.20.2.0/24`), two NSGs and their subnet associations. Private DNS, private endpoints and AKS are not deployed yet.

## 3. Why separate the AKS and private-endpoint subnets?

They represent different network roles and security boundaries. Separate subnets allow independent NSG association, address planning and future endpoint policies. Actual subnet sizing and AKS network mode must be designed before cluster deployment.

## 4. Does attaching an NSG automatically create Zero Trust?

No. NSGs are stateful network filters. In this lab they currently have no custom rules, so Azure default rules still apply. Zero Trust requires identity verification, least privilege, explicit network policy, workload isolation, secure egress, monitoring and continuous validation.

## 5. Why not add deny-all rules immediately?

AKS depends on documented control-plane, node, DNS, image-pull, identity and platform endpoint flows. A premature deny rule can break cluster provisioning or operations. Map and validate required traffic first, then implement least-privilege rules and a controlled egress design.

## 6. What is the difference between an NSG and Azure Firewall?

An NSG provides stateful L3/L4 filtering at subnet or NIC scope. Azure Firewall is a centralized managed network security service that supports network and application rules, threat intelligence and centralized logging. They solve different layers of the network security design.

## 7. What is a Private Endpoint?

A Private Endpoint maps a supported Azure service to a private IP address in a VNet through Azure Private Link. Private DNS is usually required so clients resolve the service's normal name to the private endpoint address.

## 8. What is Workload Identity in AKS?

It federates a Kubernetes service account identity with Microsoft Entra ID using the cluster OIDC issuer. A workload can obtain short-lived Entra tokens without storing a client secret in the pod.

## 9. How would a pod access Key Vault securely?

Enable AKS OIDC issuer and Workload Identity, create a dedicated managed identity and federated credential matching the namespace/service-account subject, assign the minimum Key Vault data-plane role, configure the supported CSI integration and private DNS path if private access is required, then test both allowed and denied access.

## 10. How do you prove the platform is secure?

Use evidence: role-assignment review, private API reachability tests, DNS resolution tests, positive and negative network-policy tests, workload token and Key Vault access tests, admission-policy tests, image scan/provenance results, audit logs and alert exercises. A diagram or successful Terraform apply alone is not proof.

## 11. How do you manage Terraform safely?

Pin provider constraints and commit the dependency lock file, keep state and tfvars out of Git, use remote state with locking and restricted access for team use, review saved plans, detect drift and protect production applies with approvals.

## 12. What would you implement next?

Complete network-flow requirements and private DNS design first, then private connectivity, private AKS, Entra integration, Workload Identity, Key Vault, workload policies, GitOps and observability. Each phase needs a test and retained evidence.
