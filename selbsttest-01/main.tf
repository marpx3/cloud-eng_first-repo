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

resource "azurerm_container_app_environment" "acaenvmarco91283" {
  name                = "acaenvmarco${var.environment}"
  resource_group_name = module.selbsttest-01.rg-name
  location            = module.selbsttest-01.location
}

resource "azurerm_container_app" "acamarco91283" {
  name                         = "acamarco${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.acaenvmarco91283.id
  resource_group_name          = module.selbsttest-01.rg-name
  revision_mode                = "Single"

  template {
    container {
      name   = "aconmarco912183"
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  ingress {
    external_enabled = true
    target_port      = 80
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

/* resource "azurerm_role_assignment" "aca_acrpull" {
  scope                = azurerm_container_registry.acrtfmarco92771.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_container_app.acamarco91283.identity[0].principal_id
} */