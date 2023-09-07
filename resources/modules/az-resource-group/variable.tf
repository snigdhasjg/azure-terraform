variable "location" {
  description = "Azure resource group location"
  type        = string
}

variable "name_prefix" {
  description = "Resource tag prefix"
  type        = string
}

variable "module_name" {
  description = "Module name for which this resource group is created for"
  type        = string
}

variable "common_tags" {
  description = "Common tag to apply to all resources"
  type        = map(string)
}