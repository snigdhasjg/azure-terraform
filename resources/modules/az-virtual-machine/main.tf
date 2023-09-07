module "resource_group" {
  source = "../az-resource-group"

  location    = "Central India"
  module_name = "vm"
  name_prefix = "${var.name_prefix}-sandbox-central-india"
  common_tags = {
    environment = "sandbox"
    owner       = var.owner
  }
}

resource "azurerm_public_ip" "vm_public_ip" {
  name                = "${var.name_prefix}-vm-public-ip"
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
  domain_name_label   = "${var.name_prefix}-vm-public"
}

resource "azurerm_network_interface" "vm_network_interface" {
  name                    = "${var.name_prefix}-virtual-machine-nic"
  location                = module.resource_group.resource_group_location
  resource_group_name     = module.resource_group.resource_group_name
  internal_dns_name_label = "${var.name_prefix}-vm-internal"

  ip_configuration {
    primary                       = true
    name                          = "internal"
    private_ip_address_version    = "IPv4"
    subnet_id                     = var.public_subnets[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }
}

resource "tls_private_key" "rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key_file" {
  filename        = "${path.module}/key/vm-private-key.pem"
  content         = tls_private_key.rsa_key.private_key_pem
  file_permission = "0400"
}

resource "azurerm_linux_virtual_machine" "this" {
  name                = "${var.name_prefix}-virtual-machine"
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  admin_username      = "vm-user"
  size                = "Standard_B1s"

  network_interface_ids = [
    azurerm_network_interface.vm_network_interface.id
  ]

  admin_ssh_key {
    username   = "vm-user"
    public_key = tls_private_key.rsa_key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 64
  }

  source_image_reference {
    offer     = "0001-com-ubuntu-server-jammy"
    publisher = "canonical"
    sku       = "22_04-lts"
    version   = "latest"
  }
}