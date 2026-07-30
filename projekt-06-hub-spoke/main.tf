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

resource "azurerm_network_security_group" "nsg-public-ssh" {
  name                = "nsg-public-ssh${var.environment}"
  resource_group_name = azurerm_resource_group.hubspoke.name
  location            = azurerm_resource_group.hubspoke.location
}

resource "azurerm_network_security_rule" "allow-ssh-public" {
  name                       = "allow-ssh-from-public"
  priority                   = "900"
  destination_port_range     = "22"
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  source_address_prefix      = "79.205.212.194"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.hubspoke.name
  network_security_group_name = azurerm_network_security_group.nsg-public-ssh.name
}

resource "azurerm_subnet_network_security_group_association" "assoc-hub-public" {
  subnet_id                 = module.hub.subnet_id
  network_security_group_id = azurerm_network_security_group.nsg-public-ssh.id
}

resource "azurerm_network_security_group" "nsg-spokes" {
  name                = "nsg-spoke-${var.environment}"
  resource_group_name = azurerm_resource_group.hubspoke.name
  location            = azurerm_resource_group.hubspoke.location
}

resource "azurerm_network_security_rule" "allow-ssh" {
  name                       = "allow-ssh-from-hub"
  priority                   = "1000"
  destination_port_range     = "22"
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  source_address_prefix      = one(module.hub.address_space)
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.hubspoke.name
  network_security_group_name = azurerm_network_security_group.nsg-spokes.name
}

resource "azurerm_subnet_network_security_group_association" "assoc-spoke1" {
  subnet_id                 = module.spoke1.subnet_id
  network_security_group_id = azurerm_network_security_group.nsg-spokes.id
}

resource "azurerm_subnet_network_security_group_association" "assoc-spoke2" {
  subnet_id                 = module.spoke2.subnet_id
  network_security_group_id = azurerm_network_security_group.nsg-spokes.id
}

resource "azurerm_storage_account" "private" {
  name                          = "satf${var.environment}8272612"
  resource_group_name           = azurerm_resource_group.hubspoke.name
  location                      = azurerm_resource_group.hubspoke.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  public_network_access_enabled = false
}

resource "azurerm_private_dns_zone" "private" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.hubspoke.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private" {
  name                  = "private-link-sa${var.environment}"
  private_dns_zone_name = azurerm_private_dns_zone.private.name
  virtual_network_id    = module.spoke1.vnet_id
  resource_group_name   = azurerm_resource_group.hubspoke.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private-hub" {
  name                  = "private-link-hub${var.environment}"
  private_dns_zone_name = azurerm_private_dns_zone.private.name
  virtual_network_id    = module.hub.vnet_id
  resource_group_name   = azurerm_resource_group.hubspoke.name
}

resource "azurerm_private_endpoint" "blob" {
  name                = "pa-blob-${var.environment}"
  location            = azurerm_resource_group.hubspoke.location
  resource_group_name = azurerm_resource_group.hubspoke.name
  subnet_id           = module.spoke1.subnet_id

  private_service_connection {
    name                           = "pac-blob-${var.environment}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.private.id
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "dns-blob-${var.environment}"
    private_dns_zone_ids = [azurerm_private_dns_zone.private.id]
  }
}

resource "azurerm_public_ip" "pip-jumper" {
  name                = "pip-jumper${var.environment}"
  allocation_method   = "Static"
  resource_group_name = azurerm_resource_group.hubspoke.name
  location            = azurerm_resource_group.hubspoke.location
}

resource "azurerm_network_interface" "nic-jumper" {
  name                = "nic-jumper-${var.environment}"
  resource_group_name = azurerm_resource_group.hubspoke.name
  location            = azurerm_resource_group.hubspoke.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.hub.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-jumper.id
  }
}

resource "azurerm_linux_virtual_machine" "hubspoke-jump" {
  name                = "vm-${var.environment}-hubspoke-jumper"
  resource_group_name = azurerm_resource_group.hubspoke.name
  location            = azurerm_resource_group.hubspoke.location
  size                = "Standard_D2s_v6"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic-jumper.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}