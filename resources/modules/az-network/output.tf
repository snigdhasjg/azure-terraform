output "resource_group" {
  value = azurerm_resource_group.this
}

output "public_subnets" {
  value = azurerm_subnet.public_subnet
}

output "private_subnets" {
  value = azurerm_subnet.private_subnet
}