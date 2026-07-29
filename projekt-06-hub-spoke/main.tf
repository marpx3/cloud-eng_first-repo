resource "azurerm_resource_group" "hubspoke" {
  name     = "rg-hubspoke-${var.environment}"
  location = var.location
}

module "hub" {
  source              = "./modules/network"
  vnet_name           = "vnet-hub-${var.environment}"
  address_space       = ["10.0.0.0/16"]
  subnet_name         = "snet-hub-${var.environment}"
  subnet_prefix       = "10.0.1.0/24"
  resource_group_name = azurerm_resource_group.hubspoke.name
  location            = azurerm_resource_group.hubspoke.location
}

module "spoke1" {
  source              = "./modules/network"
  vnet_name           = "vnet-spoke1-${var.environment}"
  address_space       = ["10.1.0.0/16"]
  subnet_name         = "snet-spoke1-${var.environment}"
  subnet_prefix       = "10.1.1.0/24"
  resource_group_name = azurerm_resource_group.hubspoke.name
  location            = azurerm_resource_group.hubspoke.location
}

module "spoke2" {
  source              = "./modules/network"
  vnet_name           = "vnet-spoke2-${var.environment}"
  address_space       = ["10.2.0.0/16"]
  subnet_name         = "snet-spoke2-${var.environment}"
  subnet_prefix       = "10.2.1.0/24"
  resource_group_name = azurerm_resource_group.hubspoke.name
  location            = azurerm_resource_group.hubspoke.location
}

resource "azurerm_virtual_network_peering" "peer-hub-to-spoke1" {
  name                      = "peer-hub-to-spoke1-${var.environment}"
  resource_group_name       = azurerm_resource_group.hubspoke.name
  virtual_network_name      = module.hub.vnet_name
  remote_virtual_network_id = module.spoke1.vnet_id
}

resource "azurerm_virtual_network_peering" "peer-hub-to-spoke2" {
  name                      = "peer-hub-to-spoke2-${var.environment}"
  resource_group_name       = azurerm_resource_group.hubspoke.name
  virtual_network_name      = module.hub.vnet_name
  remote_virtual_network_id = module.spoke2.vnet_id
}

resource "azurerm_virtual_network_peering" "peer-spoke1-to-hub" {
  name                      = "peer-spoke1-to-hub-${var.environment}"
  resource_group_name       = azurerm_resource_group.hubspoke.name
  virtual_network_name      = module.spoke1.vnet_name
  remote_virtual_network_id = module.hub.vnet_id
}

resource "azurerm_virtual_network_peering" "peer-spoke2-to-hub" {
  name                      = "peer-spoke2-to-hub-${var.environment}"
  resource_group_name       = azurerm_resource_group.hubspoke.name
  virtual_network_name      = module.spoke2.vnet_name
  remote_virtual_network_id = module.hub.vnet_id
}