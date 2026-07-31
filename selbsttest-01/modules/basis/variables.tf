variable "rg_name" {
  type        = string
  description = "ressource gruppe"
}

variable "sa_name" {
  type        = string
  description = "Storage Account"
}

variable "account_tier" {
  type        = string
  description = "Accoutn Tier des SA"
}

variable "account_replication_type" {
  type        = string
  description = "account_replication_type"
}

variable "public_network_access_enabled" {
  type        = bool
  description = "public_network_access_enabled"
}

variable "location" {
  type        = string
  description = "location"
}