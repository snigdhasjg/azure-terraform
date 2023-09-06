output "resource_group" {
  value = {
    name = azurerm_resource_group.this.name
    location = azurerm_resource_group.this.location
  }
}