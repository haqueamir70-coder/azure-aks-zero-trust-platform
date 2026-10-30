variable "location" {
  description = "Azure region for foundation resources."
  type        = string
  default     = "eastus"
  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "location must be a non-empty Azure region."
  }
}

variable "resource_group_name" {
  description = "Sandbox resource group name."
  type        = string
  default     = "rg-aks-zero-trust-dev"
}

variable "vnet_address_space" {
  description = "Non-overlapping IPv4 CIDR for the lab VNet."
  type        = list(string)
  default     = ["10.50.0.0/16"]
  validation {
    condition     = length(var.vnet_address_space) == 1
    error_message = "Provide exactly one IPv4 CIDR for this starter VNet."
  }
}

variable "aks_subnet_prefix" {
  description = "Subnet prefix reserved for future AKS nodes."
  type        = string
  default     = "10.50.1.0/24"
}
