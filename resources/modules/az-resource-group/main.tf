resource "azurerm_resource_group" "this" {
  name     = "${var.name_prefix}-${var.module_name}-rg"
  location = var.location

  tags = merge(var.common_tags, {
    component = var.module_name
  })
}

resource "azurerm_resource_group_policy_assignment" "add_or_replace_resource_tag" {
  for_each = azurerm_resource_group.this.tags

  name                 = "Add or replace ${each.key} tag"
  resource_group_id    = azurerm_resource_group.this.id
  policy_definition_id = data.azurerm_policy_definition_built_in.add_or_replace_resource_tag_policy.id
  location             = azurerm_resource_group.this.location
  enforce              = true

  identity {
    type = "SystemAssigned"
  }

  parameters = <<-PARAMS
    {
      "tagName": {
        "value": "${each.key}"
      },
      "tagValue": {
        "value": "${each.value}"
      }
    }
  PARAMS
}