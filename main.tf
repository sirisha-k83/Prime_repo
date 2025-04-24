# Virtual Network
resource "azurerm_virtual_network" "vnet1" {
  name                = "${var.environment}-vnet1"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = [var.vnet1_address_space]
}

# Subnets
resource "azurerm_subnet" "vnet1-subnet-1" {
  name                 = "vnet1-subnet-1"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = [var.vnet1_subnet1_cidr]
}

resource "azurerm_subnet_network_security_group_association" "subnet1" {
  subnet_id                 = azurerm_subnet.vnet1-subnet-1.id
  network_security_group_id = azurerm_network_security_group.devrg1-nsg1.id
}