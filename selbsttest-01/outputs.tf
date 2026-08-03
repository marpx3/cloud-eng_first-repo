output "sa-name" {
  value = module.selbsttest-01.sa-name
}

output "rg-name" {
  value = module.selbsttest-01.rg-name
}

output "app_url" {
  value = "https://${azurerm_container_app.acamarco91283.ingress[0].fqdn}"
}