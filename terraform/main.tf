resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    project     = "azure-aks-zero-trust-platform"
    environment = "dev"
    managed_by  = "terraform"
  }
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-aks-zero-trust-dev"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.vnet_address_space
  tags = {
    project     = "azure-aks-zero-trust-platform"
    environment = "dev"
  }
}

resource "azurerm_subnet" "aks_nodes" {
  name                 = "snet-aks-nodes"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.aks_subnet_prefix]
}
