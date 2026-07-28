output "public_ip" {
  value = azurerm_public_ip.lab.ip_address
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}