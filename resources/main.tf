locals {
  owner      = "Snigdhajyoti Ghosh"
  name_prefix = "joe"
}

module "az-network" {
  source = "./modules/az-network"

  owner                      = local.owner
  name_prefix                 = local.name_prefix
  create_nat_gateway         = false
  virtual_network_cidr_block = "10.2.0.0/20"
  no_of_private_subnet       = 3
  no_of_public_subnet        = 2
}