variable "vnet_name" {
  type        = string
  description = "Name des VNETs"
}

variable "address_space" {
  type        = list(string)
  description = "Adress Bereich"
}

variable "subnet_name" {
  type        = string
  description = "Name des SNETs"
}

variable "subnet_prefix" {
  type        = string
  description = "Prefix des Subnets"
}

variable "resource_group_name" {
  type        = string
  description = "In welcher RG anlegen?"
}

variable "location" {
  type        = string
  description = "Welche Location?"
}