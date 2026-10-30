output "resource_group_name" {
  description = "Created resource group name."
  value       = azurerm_resource_group.this.name
}
output "virtual_network_id" {
  description = "Created VNet resource ID."
  value       = azurerm_virtual_network.this.id
}
output "aks_subnet_id" {
  description = "Subnet reserved for future AKS node pools; no cluster is created yet."
  value       = azurerm_subnet.aks_nodes.id
}
