data "azurerm_resource_group" "existing" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "aks" {
  name                = var.vnet_name
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name
  address_space       = var.vnet_address_space

  tags = {
    Environment = var.environment
    Project     = "AKS-Zero-Trust"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_subnet" "aks" {
  name                 = "snet-aks"
  resource_group_name  = data.azurerm_resource_group.existing.name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = var.aks_subnet_prefix
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = "snet-private-endpoints"
  resource_group_name  = data.azurerm_resource_group.existing.name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = var.private_endpoint_subnet_prefix
}

resource "azurerm_network_security_group" "aks" {
  name                = "nsg-aks-zero-trust"
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name

  tags = {
    Environment = var.environment
    Project     = "AKS-Zero-Trust"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_network_security_group" "private_endpoints" {
  name                = "nsg-private-endpoints"
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name

  tags = {
    Environment = var.environment
    Project     = "AKS-Zero-Trust"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_subnet_network_security_group_association" "aks" {
  subnet_id                 = azurerm_subnet.aks.id
  network_security_group_id = azurerm_network_security_group.aks.id
}

resource "azurerm_subnet_network_security_group_association" "private_endpoints" {
  subnet_id                 = azurerm_subnet.private_endpoints.id
  network_security_group_id = azurerm_network_security_group.private_endpoints.id
}
