resource "azurerm_resource_group" "this" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_storage_account" "this" {
  name                            = var.sa_name
  resource_group_name             = azurerm_resource_group.this.name
  location                        = azurerm_resource_group.this.location
  account_tier                    = var.account_tier
  account_replication_type        = var.account_replication_type
  public_network_access_enabled   = var.public_network_access_enabled
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
}