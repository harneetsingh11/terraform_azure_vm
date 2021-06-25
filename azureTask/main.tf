resource "azurerm_resource_group" "rg1" {
    name = "${var.rg1}"
    location = "${var.location}"
}

resource "azurerm_virtual_machine" "os1"{
    resource_group_name = azurerm_resource_group.rg1.name
    name = "${var.vm_name}"
    location = azurerm_resource_group.rg1.location
    network_interface_ids = [azurerm_network_interface.net-interface.id]
os_profile_linux_config {
    disable_password_authentication = false
}
    storage_image_reference {
        publisher = "RedHat"
        offer     = "RHEL"
        sku       = "8.1"
        version   = "latest"
    }
    vm_size = "Standard_DS1_v2"
    os_profile {
        computer_name  = var.computername
        admin_username = var.adminuser
        admin_password = var.adminpasswd
    }
     storage_os_disk {
        name              = "d1"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
        disk_size_gb = "70"
  }
  tags = {
    "Env" = "conf"
  }

}


resource "azurerm_virtual_network" "vn" {
  name = "${var.vn_name}"
  address_space = ["${var.range}"]
  location = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_subnet" "sn1" {
  name = "${var.subnet_name}"
  resource_group_name = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes = ["${var.subnet_range}"]
}
resource "azurerm_public_ip" "public-ip" {
  name = "public-ip"
  location = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  allocation_method = "Dynamic"
  tags = {
    use = "auth"
  }
}

data "azurerm_public_ip" "example" {
  name                = azurerm_public_ip.public-ip.name
  resource_group_name = azurerm_virtual_machine.os1.resource_group_name
}


resource "azurerm_network_interface" "net-interface" {
  name = "nic-1"
  resource_group_name = azurerm_resource_group.rg1.name
  location = azurerm_resource_group.rg1.location
  ip_configuration {
    name                          = "nic-1"
    subnet_id                     = azurerm_subnet.sn1.id
    private_ip_address_allocation = "Dynamic"
    private_ip_address            = "10.0.2.5"
    public_ip_address_id          = azurerm_public_ip.public-ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "ansg" {
    network_interface_id      = azurerm_network_interface.net-interface.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet_network_security_group_association" "asnsga" {
  subnet_id                 = azurerm_subnet.sn1.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_group" "nsg" {
  name = "nsg-1"
  location = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  security_rule  {
    name                       = "req"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    source_port_range = "*"
  } 
  security_rule  {
    name                       = "req1"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    source_port_range = "*"
  } 
}

