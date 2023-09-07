output "public_subnets" {
  value = azurerm_subnet.public_subnet
}

output "private_subnets" {
  value = azurerm_subnet.private_subnet
}