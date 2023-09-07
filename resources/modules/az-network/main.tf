resource "azurerm_resource_group" "this" {
  name     = "${var.name_prefix}-sandbox-central-india-network-ng"
  location = "Central India"

  tags = {
    component   = "az-network"
    environment = "sandbox"
    owner       = var.owner
  }
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = "${var.name_prefix}-virtual-network"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [var.virtual_network_cidr_block]
}

resource "azurerm_subnet" "public_subnet" {
  for_each = {
    for idx in range(var.no_of_public_subnet) : idx => {
      cidr_block = cidrsubnet(local.public_subnets_allocated_cidr, ceil(pow(var.no_of_public_subnet, 1/2)), idx)
    }
  }

  name                 = "${var.name_prefix}-public-subnet-${each.key}"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [each.value.cidr_block]
}

resource "azurerm_subnet" "private_subnet" {
  for_each = {
    for idx in range(var.no_of_private_subnet) : idx => {
      cidr_block = cidrsubnet(local.private_subnets_allocated_cidr, ceil(pow(var.no_of_private_subnet, 1/2)), idx)
    }
  }

  name                 = "${var.name_prefix}-private-subnet-${each.key}"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [each.value.cidr_block]
}

resource "azurerm_public_ip" "nat_public_ip" {
  count = var.create_nat_gateway ? 1 : 0

  name                = "${var.name_prefix}-nat-gateway-public-ip"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}

resource "azurerm_nat_gateway" "nat_gateway" {
  count = var.create_nat_gateway ? 1 : 0

  name                    = "${var.name_prefix}-nat-gateway"
  location                = azurerm_resource_group.this.location
  resource_group_name     = azurerm_resource_group.this.name
  idle_timeout_in_minutes = 10
  sku_name                = azurerm_public_ip.nat_public_ip[0].sku
  zones                   = azurerm_public_ip.nat_public_ip[0].zones
}

resource "azurerm_nat_gateway_public_ip_association" "nat_public_ip_association" {
  count = var.create_nat_gateway ? 1 : 0

  nat_gateway_id       = azurerm_nat_gateway.nat_gateway[0].id
  public_ip_address_id = azurerm_public_ip.nat_public_ip[0].id
}

resource "azurerm_subnet_nat_gateway_association" "nat_gateway_to_subnet_association" {
  for_each = var.create_nat_gateway ? azurerm_subnet.private_subnet : {}

  nat_gateway_id = azurerm_nat_gateway.nat_gateway[0].id
  subnet_id      = each.value.id
}