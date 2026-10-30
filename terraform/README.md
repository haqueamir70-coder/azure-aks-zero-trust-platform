# Terraform foundation

## Scope
The initial root creates one resource group, one virtual network and one workload subnet. It does **not** provision private AKS, hub networking, Azure Firewall, Private DNS, ACR, Key Vault or multi-region failover.

## Prerequisites
- Terraform CLI compatible with `versions.tf`.
- Azure CLI authenticated to a non-production subscription.
- Contributor permissions scoped to a sandbox; use least privilege in shared environments.
- Unique resource-group name and approved CIDR plan.

## Validate
```bash
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```

## Plan and apply
Copy `terraform.tfvars.example` to local `terraform.tfvars`, review all values, then:
```bash
az account show
terraform init
terraform plan -out=tfplan
terraform show tfplan
# Only after review in a disposable subscription:
terraform apply tfplan
```

Never commit `terraform.tfvars`, state files, plan files, credentials or backend secrets. Configure remote state with restricted access and locking before team use.

Choose non-overlapping CIDRs with the network team. Validate sizing for node pools, pods, services, ingress, private endpoints and future growth.

## Future modules
- `modules/hub-network`: hub VNet, firewall, routes and DNS.
- `modules/aks`: private AKS, identities, node pools, Azure Policy.
- `modules/identity`: managed identities and federated credentials.
- `modules/private-endpoints`: Key Vault and ACR private connectivity.
- `modules/monitoring`: diagnostics and Azure Monitor integration.
