resource "azurerm_network_security_rule" "devrg1-nsg1-allow-all" {
  name                        = "allow-all"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg1.name
  network_security_group_name = azurerm_network_security_group.devrg1-nsg1.name
}

# Security Rules for Specific Ports (Uses a List)
resource "azurerm_network_security_rule" "devrg1-nsg1-allow-all-functions" {
  count                       = length(local.inbound_ports)
  name                        = "allow-all-functions-${element(local.inbound_ports, count.index)}"
  priority                    = 110 + count.index # Adjusted priority to avoid conflict
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = element(local.inbound_ports, count.index)
  destination_port_range      = element(local.inbound_ports, count.index)
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg1.name
  network_security_group_name = azurerm_network_security_group.devrg1-nsg1.name
}
