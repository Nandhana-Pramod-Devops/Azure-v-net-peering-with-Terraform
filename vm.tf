resource "azurerm_network_interface" "nic-1" {
  name                          = "nic-terraform-peering-1"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.subnet-1.id
    private_ip_address_allocation = "Dyamic"
  }
}

resource "azurerm_virtual_machine" "vm-1" {
  name = "vm-terraform-peering-1"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  vm_size = "Standard_B1s"
  network_interface_ids = [azurerm_network_interface.nic-1.id]
  storage_os_disk {
    caching = "ReadWrite"
    create_option = "FromImage"
    os_type = "Linux"
    disk_size_gb = 30
    name = "myosdisk1"
  }
  storage_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
  }
  os_profile {
    computer_name = "vm-terraform-peering-1"
    admin_username = "adminuser"
    admin_password = "Password123!"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/adminuser/.ssh/authorized_keys"
      key_data = file("~/.ssh/id_rsa.pub")
    }
  }
}

resource "azurerm_network_interface" "nic-2" {
  name                          = "nic-terraform-peering-2"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.subnet-2-1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm-2" {
  name                  = "vm-terraform-peering-2"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  vm_size               = "Standard_B1s"
  network_interface_ids = [azurerm_network_interface.nic-2.id]
  storage_os_disk {
    caching       = "ReadWrite"
    create_option = "FromImage"
    os_type       = "Linux"
    disk_size_gb  = 30
    name          = "myosdisk2"
  }
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  os_profile {
    computer_name  = "vm-terraform-peering-2"
    admin_username = "adminuser"
    admin_password = "Password123!"
  }

}