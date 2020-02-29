# create the rez group

  resource "azurerm_resource_group" "SWKHECMS001" {
  name     = "usnc-rg-poc-tspoc1"
  location = "northcentralus"
}

# create AV Set for fake HA

 resource "azurerm_availability_set" "SWKHECMS001" {
  name                = "AZ_POC1"
  location            = "${azurerm_resource_group.SWKHECMS001.location}"
  resource_group_name = "${azurerm_resource_group.SWKHECMS001.name}"
  managed             = "true"
}


# this is the network interface to create/attach to the new vm
resource "azurerm_network_interface" "SWKHECMS001" {
  name                = "SWKHECMS001"
  location            = "northcentralus"
  resource_group_name = "usnc-rg-poc-tspoc1"
   ip_configuration {
    name                          = "SWKHECMS001"
     subnet_id                    = "/subscriptions/0bc81480-3ae2-48c0-8b57-07391ab8d81f/resourceGroups/usnc-rg-poc-tspoc1/providers/Microsoft.Network/virtualNetworks/usnc-vnet-pocnonprd03/subnets/vnet-pocnonprd03-snet-dev-db01"
    private_ip_address_allocation = "dynamic"
  }
}


# create ur VM 

resource "azurerm_virtual_machine" "SWKHECMS001" {
  name                  = "SWKHECMS001"
  location              = "northcentralus"
  resource_group_name   = "usnc-rg-poc-tspoc1"
  network_interface_ids = ["${azurerm_network_interface.SWKHECMS001.id}"]
  vm_size               = "Standard_DS3_v2"
  availability_set_id   = "${azurerm_availability_set.SWKHECMS001.id}"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = false
os_profile_windows_config {

  }


# OS disk 

  storage_os_disk {
    name              = "${azurerm_network_interface.SWKHECMS001.name}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

# data/app  drive here: 

    storage_data_disk {
    name              = "${azurerm_network_interface.SWKHECMS001.name}appdisk01"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 1
    disk_size_gb      = "60"
  }

# image settings 

  storage_image_reference {
    publisher = "MicrosoftSQLServer"
    offer     = "SQL2017-WS2016"
    sku       = "SQLDEV"
    version   = "latest"
  }
  os_profile {
    computer_name  = "${azurerm_network_interface.SWKHECMS001.name}"
    admin_username = "kapadmin"
    admin_password = "1$uc3s@atym!"
  }
  tags {
    environment = "dev"
    APPLICATION = "stu"
    DIVISION = "khe"
  }
}

# this is the network interface to create/attach to the new vm
resource "azurerm_network_interface" "SWKHECMS002" {
  name                = "SWKHECMS002"
  location            = "northcentralus"
  resource_group_name = "usnc-rg-poc-tspoc1"
   ip_configuration {
    name                          = "SWKHECMS002"
    subnet_id                     = "/subscriptions/0bc81480-3ae2-48c0-8b57-07391ab8d81f/resourceGroups/usnc-rg-poc-tspoc1/providers/Microsoft.Network/virtualNetworks/usnc-vnet-pocnonprd03/subnets/vnet-pocnonprd03-snet-dev-db01"
    private_ip_address_allocation = "dynamic"
  }
}

# create ur VM 


 resource "azurerm_availability_set" "SWKHECMS002" {
  name                = "AZ_POC2"
  location            = "${azurerm_resource_group.SWKHECMS001.location}"
  resource_group_name = "${azurerm_resource_group.SWKHECMS001.name}"
  managed             = "true"
}

resource "azurerm_virtual_machine" "SWKHECMS002" {
  name                  = "SWKHECMS002"
  location              = "northcentralus"
  resource_group_name   = "usnc-rg-poc-tspoc1"
  network_interface_ids = ["${azurerm_network_interface.SWKHECMS002.id}"]
  vm_size               = "Standard_DS3_v2"
  availability_set_id   = "${azurerm_availability_set.SWKHECMS002.id}"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = false
os_profile_windows_config {

  }


# OS disk 

  storage_os_disk {
    name              = "${azurerm_network_interface.SWKHECMS002.name}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

# data/app  drive here: 

    storage_data_disk {
    name              = "${azurerm_network_interface.SWKHECMS002.name}appdisk01"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 1
    disk_size_gb      = "60"
  }

# image settings 

  storage_image_reference {
    publisher = "MicrosoftSQLServer"
    offer     = "SQL2017-WS2016"
    sku       = "SQLDEV"
    version   = "latest"
  }
  os_profile {
    computer_name  = "${azurerm_network_interface.SWKHECMS002.name}"
    admin_username = "kapadmin"
    admin_password = "1$uc3s@atym!"
  }
  tags {
    environment = "dev"
    APPLICATION = "stu"
    DIVISION = "khe"
  }
}