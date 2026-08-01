output "sa-name" {
  value = azurerm_storage_account.this.name
}

output "rg-name" {
  value = azurerm_resource_group.this.name
}

output "location" {
  value = azurerm_resource_group.this.location
}