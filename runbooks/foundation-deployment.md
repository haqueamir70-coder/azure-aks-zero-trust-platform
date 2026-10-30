# Foundation deployment and validation

## Current deployed baseline

The lab uses an existing resource group named `ravi` in East US. Terraform provisions a VNet, two subnets, two NSGs and subnet-to-NSG associations.

## Verify Azure resources

Run these commands after authenticating to the intended subscription:

```powershell
az account show
az network vnet show -g ravi -n vnet-aks-zero-trust --query "{name:name,addressSpace:addressSpace.addressPrefixes,location:location}" -o json
az network nsg list -g ravi --query "[].{Name:name,Location:location}" -o table
az network vnet subnet list -g ravi --vnet-name vnet-aks-zero-trust --query "[].{Name:name,NSG:networkSecurityGroup.id,Prefixes:addressPrefixes}" -o json
terraform state list
```

Expected subnet-to-NSG mapping:

| Subnet | NSG |
|---|---|
| `snet-aks` | `nsg-aks-zero-trust` |
| `snet-private-endpoints` | `nsg-private-endpoints` |

## Current limitations

- The NSGs currently have no custom rules. Azure default rules remain effective.
- No Private DNS zones, private endpoints, firewall routes or AKS cluster are deployed.
- This lab currently uses local Terraform state. Protect the workstation and do not share state files.
- A successful CLI listing confirms resource configuration, not end-to-end packet flow or security effectiveness.

## Change control

1. Run `terraform fmt -recursive` and `terraform validate`.
2. Generate a saved plan with `terraform plan -out=tfplan`.
3. Inspect it with `terraform show -no-color tfplan`.
4. Confirm no unexpected replacements or destroys.
5. Apply only after explicit review.
6. Re-run Azure verification commands and retain the output as evidence.

## Troubleshooting

- Confirm `az account show` points to the intended subscription.
- Confirm the resource group exists and the signed-in identity can manage Network resources.
- If Terraform and Azure disagree, do not manually edit resources; inspect `terraform plan` and reconcile drift deliberately.
