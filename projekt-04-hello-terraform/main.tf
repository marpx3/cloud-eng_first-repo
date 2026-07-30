resource "azurerm_resource_group" "lab" {
  name     = "rg-${local.prefix}"
  location = var.location
}

resource "azurerm_storage_account" "lab" {

  count = var.environment == "prod" ? 1 : 0

  name                     = "stmarcotf${var.environment}83271263"
  resource_group_name      = azurerm_resource_group.lab.name
  location                 = azurerm_resource_group.lab.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_virtual_network" "lab" {
  name                = "vnet-${local.prefix}"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "lab" {
  name                 = "snet-${local.prefix}"
  resource_group_name  = azurerm_resource_group.lab.name
  address_prefixes     = ["10.0.1.0/24"]
  virtual_network_name = azurerm_virtual_network.lab.name
}

resource "azurerm_public_ip" "lab" {
  name                = "pip-${local.prefix}"
  allocation_method   = "Static"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
}

resource "azurerm_network_interface" "lab" {
  name                = "nic-${local.prefix}"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lab.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lab.id
  }
}

resource "azurerm_network_security_group" "lab" {
  name                = "nsg-${local.prefix}"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location

}

resource "azurerm_network_security_rule" "rules" {
  for_each = local.nsg_rules

  name                   = "${each.key}-${local.prefix}"
  priority               = each.value.priority
  destination_port_range = each.value.port

  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  source_address_prefix      = "*"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.lab.name
  network_security_group_name = azurerm_network_security_group.lab.name
}


resource "azurerm_network_interface_security_group_association" "lab" {
  network_interface_id      = azurerm_network_interface.lab.id
  network_security_group_id = azurerm_network_security_group.lab.id
}

resource "azurerm_linux_virtual_machine" "lab" {
  name                = "vm-${local.prefix}-marcotf"
  resource_group_name = azurerm_resource_group.lab.name
  location                       = azurerm_resource_group.lab.location
  size                = "Standard_D2s_v6"
  admin_username      = "azureuser"

  custom_data = filebase64("cloud-init.yaml")

  network_interface_ids = [
    azurerm_network_interface.lab.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              =               "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
