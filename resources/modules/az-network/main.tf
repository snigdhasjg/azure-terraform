resource "azurerm_virtual_network" "virtual_network" {
  name                = "${var.tag_prefix}-virtual-network"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  address_space       = [var.virtual_network_cidr_block]

  tags = {
    component   = "az-network"
    environment = "sandbox"
    owner       = var.owner
  }
}

resource "azurerm_subnet" "public_subnet" {
  for_each = {
    for idx in range(var.no_of_public_subnet) : idx => {
      cidr_block = cidrsubnet(local.public_subnets_allocated_cidr, ceil(pow(var.no_of_public_subnet, 1/2)), idx)
    }
  }

  name                 = "${var.tag_prefix}-public-subnet-${each.key}"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [each.value.cidr_block]
}

resource "azurerm_subnet" "private_subnet" {
  for_each = {
    for idx in range(var.no_of_private_subnet) : idx => {
      cidr_block = cidrsubnet(local.private_subnets_allocated_cidr, ceil(pow(var.no_of_private_subnet, 1/2)), idx)
    }
  }

  name                 = "${var.tag_prefix}-private-subnet-${each.key}"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [each.value.cidr_block]
}