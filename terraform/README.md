# Terraform foundation — deployed baseline

## Current implementation

The Terraform root uses an **existing** resource group and currently manages these resources in Azure:

- Virtual network: `vnet-aks-zero-trust` — `10.20.0.0/16`
- AKS-reserved subnet: `snet-aks` — `10.20.1.0/24`
- Private-endpoint subnet: `snet-private-endpoints` — `10.20.2.0/24`
- NSG: `nsg-aks-zero-trust`, associated with `snet-aks`
- NSG: `nsg-private-endpoints`, associated with `snet-private-endpoints`

The current NSGs have no custom security rules yet. Azure default NSG rules still apply. This is a network-security baseline, **not** a completed Zero Trust policy and not an AKS deployment.

## Prerequisites

- Terraform CLI >= 1.5.
- Azure CLI authenticated to the intended non-production subscription.
- Permission to read the existing resource group and create/manage Network resources.
- Existing resource group in the same subscription and region as the deployment.

## Configure

Copy `terraform.tfvars.example` to `terraform.tfvars` and set your own subscription ID. Do not commit the real tfvars file.

## Validate, plan and apply

Run from this directory:

```powershell
az account show
terraform fmt -recursive
terraform init
terraform validate
terraform plan -out=tfplan
terraform show -no-color tfplan
```

Review every planned action. Apply only after confirming the plan is expected:

```powershell
terraform apply tfplan
```

## Verify

```powershell
az network nsg list -g ravi -o table
az network vnet subnet list -g ravi --vnet-name vnet-aks-zero-trust --query "[].{Name:name,NSG:networkSecurityGroup.id,Prefixes:addressPrefixes}" -o json
terraform state list
```

## State and security hygiene

- Never commit `terraform.tfstate*`, plan files, real tfvars, credentials or secrets.
- The current lab uses local Terraform state. Before team/production use, configure a secured remote backend with locking, versioning, restricted access and recovery.
- Do not add deny-all rules or disable outbound access until AKS-required traffic, DNS and a controlled egress path have been designed and tested.
- NSG rules must be validated against the selected AKS networking mode and current AKS network requirements.

## Not implemented yet

Private DNS zones/links, Private Endpoints, Azure Firewall, routes, AKS cluster, Entra integration, Workload Identity, Key Vault CSI, ACR, GitOps and monitoring are future phases. Do not represent them as deployed.
