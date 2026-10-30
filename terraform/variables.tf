variable "subscription_id" {
  description = "Azure subscription ID used by the AzureRM provider."
  type        = string
  sensitive   = true
}

variable "resource_group_name" {
  description = "Existing resource group used for this lab."
  type        = string
  default     = "ravi"
}

variable "vnet_name" {
  description = "Name of the Zero Trust virtual network."
  type        = string
  default     = "vnet-aks-zero-trust"
}

variable "vnet_address_space" {
  description = "Virtual network address space."
  type        = list(string)
  default     = ["10.20.0.0/16"]
}

variable "aks_subnet_prefix" {
  description = "AKS node subnet CIDR."
  type        = list(string)
  default     = ["10.20.1.0/24"]
}

variable "private_endpoint_subnet_prefix" {
  description = "Private endpoint subnet CIDR."
  type        = list(string)
  default     = ["10.20.2.0/24"]
}

variable "environment" {
  description = "Environment tag."
  type        = string
  default     = "lab"
}
