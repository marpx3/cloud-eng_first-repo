module "selbsttest-01" {
  source                        = "./modules/basis"
  location                      = var.location
  rg_name                       = "rg-st-${var.environment}"
  sa_name                       = "satf${var.environment}82712612"
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  public_network_access_enabled = false
}

resource "azurerm_container_registry" "acrtfmarco92771" {
  name                = "acrconterreg${var.environment}"
  resource_group_name = module.selbsttest-01.rg-name
  location            = module.selbsttest-01.location
  admin_enabled       = false

  sku = "Basic"
}