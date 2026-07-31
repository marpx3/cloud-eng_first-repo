module "selbsttest-01" {
  source                        = "./modules/basis"
  location                      = var.location
  rg_name                       = "rg-st-${var.environment}"
  sa_name                       = "satf${var.environment}82712612"
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  public_network_access_enabled = false
} 