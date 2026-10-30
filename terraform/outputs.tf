output "resource_group_name" {
  description = "Existing resource group name."
  value       = data.azurerm_resource_group.existing.name
}

output "virtual_network_name" {
  description = "Zero Trust virtual network name."
  value       = azurerm_virtual_network.aks.name
}

output "virtual_network_id" {
  description = "Virtual network resource ID."
  value       = azurerm_virtual_network.aks.id
}

output "aks_subnet_id" {
  description = "AKS subnet resource ID."
  value       = azurerm_subnet.aks.id
}

output "private_endpoint_subnet_id" {
  description = "Private endpoint subnet resource ID."
  value       = azurerm_subnet.private_endpoints.id
}

output "aks_nsg_id" {
  description = "AKS Network Security Group ID."
  value       = azurerm_network_security_group.aks.id
}

output "private_endpoint_nsg_id" {
  description = "Private Endpoint Network Security Group ID."
  value       = azurerm_network_security_group.private_endpoints.id
}
