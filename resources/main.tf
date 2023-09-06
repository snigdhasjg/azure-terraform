locals {
  owner      = "Snigdhajyoti Ghosh"
  tag_prefix = "joe"
}

module "az-common" {
  source = "./modules/az-common"

  owner      = local.owner
  tag_prefix = local.tag_prefix
}

module "az-network" {
  source = "./modules/az-network"

  owner                      = local.owner
  tag_prefix                 = local.tag_prefix
  resource_group             = module.az-common.resource_group
  create_nat_gateway         = false
  virtual_network_cidr_block = "10.2.0.0/20"
  no_of_private_subnet       = 3
  no_of_public_subnet        = 2
}