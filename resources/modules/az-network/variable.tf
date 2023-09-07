variable "owner" {
  description = "Owner of the resource"
  type        = string
}

variable "name_prefix" {
  description = "Resource tag prefix"
  type        = string
}

variable "create_nat_gateway" {
  description = "Flag to create nat_gateway for private subnet"
  type        = bool
}

variable "virtual_network_cidr_block" {
  description = "CIDR block of Virtual Network"
  type        = string
  validation {
    condition     = can(cidrhost(var.virtual_network_cidr_block, 32))
    error_message = "Must be valid IPv4 CIDR."
  }
}

variable "no_of_public_subnet" {
  description = "No of public subnet to create"
  type        = number
  validation {
    condition     = var.no_of_public_subnet >= 1
    error_message = "Need at-least one"
  }
}

variable "no_of_private_subnet" {
  description = "No of private subnet to create"
  type        = number
  validation {
    condition     = var.no_of_private_subnet >= 1
    error_message = "Need at-least one"
  }
}

locals {
  private_subnets_allocated_cidr = cidrsubnet(var.virtual_network_cidr_block, 1, 0)
  public_subnets_allocated_cidr  = cidrsubnet(var.virtual_network_cidr_block, 1, 1)
}