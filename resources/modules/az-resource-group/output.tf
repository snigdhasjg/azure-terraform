output "resource_group_name" {
  depends_on = [
    azurerm_resource_group_policy_assignment.add_or_replace_resource_tag
  ]
  value = azurerm_resource_group.this.name
}

output "resource_group_location" {
  depends_on = [
    azurerm_resource_group_policy_assignment.add_or_replace_resource_tag
  ]
  value = azurerm_resource_group.this.location
}