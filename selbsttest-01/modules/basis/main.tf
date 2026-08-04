resource "azurerm_resource_group" "this" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_storage_account" "this" {

  #checkov:skip=CKV_AZURE_33:Lab - not cost efficent for Lab
  #checkov:skip=CKV_AZURE_206:Lab - false positiv LRS is enabled via variable
  #checkov:skip=CKV2_AZURE_1:Lab - not cost efficent for Lab
  #checkov:skip=CKV2_AZURE_41:Lab - not cost efficent for Lab
  #checkov:skip=CKV2_AZURE_40:Lab - not cost efficent for Lab
  #checkov:skip=CKV2_AZURE_33:Lab - not cost efficent for Lab


  name                            = var.sa_name
  resource_group_name             = azurerm_resource_group.this.name
  location                        = azurerm_resource_group.this.location
  account_tier                    = var.account_tier
  account_replication_type        = var.account_replication_type
  public_network_access_enabled   = var.public_network_access_enabled
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
}