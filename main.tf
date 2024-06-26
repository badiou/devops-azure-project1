provider "azurerm" {
  features {}
}
data "azurerm_image" "main" {
  name                = "myPackerImage"
  resource_group_name = "udacityResourceGroup"
}
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location
  tags = {
    project_name = "udacity-project",
    stage        = "Submission"
  }
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags = {
    project_name = "udacity-project",
    stage        = "Submission"
  }
}

resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-public-ip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
  tags = {
    project_name = "udacity-project",
    stage        = "Submission"
  }
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  count               = var.counter
  name                = "${var.prefix}-nic-${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    project_name = "udacity-project",
    stage        = "Submission"
  }
}

resource "azurerm_managed_disk" "main" {
  name                 = "acctestmd"
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"
  tags = {
    project_name = "udacity-project",
    stage        = "Submission"
  }
}

resource "azurerm_lb" "main" {
  name                = "${var.prefix}-lb"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Standard"
  tags = {
    project_name = "udacity-project",
    stage        = "Submission"
  }
}

resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-NSG"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  security_rule {
    name                       = "Inbound-DeniedAll"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    project_name = "udacity-project",
    stage        = "Submission"
  }
}

resource "azurerm_network_security_rule" "main" {
  name                        = "${var.prefix}-NSRule"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
}

resource "azurerm_linux_virtual_machine" "main" {
  count                          = var.counter
  name                           = "${var.prefix}-vm${count.index}"
  resource_group_name            = azurerm_resource_group.main.name
  location                       = azurerm_resource_group.main.location
  size                           = "Standard_D2s_v3"
  admin_username                 = var.admin_username
  admin_password                 = var.admin_password
  disable_password_authentication = false
  network_interface_ids          = [azurerm_network_interface.main[count.index].id]
  source_image_id = data.azurerm_image.main.id
  tags = {
    project_name = "udacity-project",
    stage        = "Submission"
  }

  /*source_image_reference {
    publisher = "Canonical"
    offer     = "myPackerImage" 
    sku       = "18.04-LTS"
    version   = "latest"
  }*/


  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}