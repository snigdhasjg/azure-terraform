variable "owner" {
  description = "Owner of the resource"
  type        = string
}

variable "name_prefix" {
  description = "Resource tag prefix"
  type        = string
}

variable "public_subnets" {
  description = "Public subnet details"
  type = map(object({
    id = string
  }))
}