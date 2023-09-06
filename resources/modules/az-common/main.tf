resource "azurerm_resource_group" "this" {
  name     = "${var.tag_prefix}-sandbox-central-india"
  location = "Central India"

  tags = {
    component   = "az-common"
    environment = "sandbox"
    owner = var.owner
  }
}