# create a public ip address
resource "azurerm_public_ip" "web" {
  name                = "web"
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    Environment = "Dev"
    CreatedBy   = "Terraform"
  }
  depends_on = [azurerm_resource_group.group]
}

# Create network security group
resource "azurerm_network_security_group" "web" {
  name                = "webnsg"
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location
  tags = {
    Environment = "Dev"
    CreatedBy   = "Terraform"
  }

  depends_on = [azurerm_resource_group.group]
}


# resource "azurerm_network_security_rule" "web" {
#   count                       = length(var.web_nsg_rules)
#   name                        = var.web_nsg_rules[count.index].name
#   resource_group_name         = azurerm_resource_group.group.name
#   network_security_group_name = azurerm_network_security_group.web.name
#   description                 = var.web_nsg_rules[count.index].description
#   protocol                    = var.web_nsg_rules[count.index].protocol
#   source_port_range           = var.web_nsg_rules[count.index].source_port_range
#   destination_port_range      = var.web_nsg_rules[count.index].destination_port_range
#   source_address_prefix       = var.web_nsg_rules[count.index].source_address_prefix
#   destination_address_prefix  = var.web_nsg_rules[count.index].destination_address_prefix
#   access                      = var.web_nsg_rules[count.index].access
#   priority                    = var.web_nsg_rules[count.index].priority
#   direction                   = "Inbound"
#   depends_on = [
#     azurerm_resource_group.group,
#     azurerm_network_security_group.web
#   ]

# }

resource "azurerm_network_security_rule" "web" {
  # We have created key ==> value pair 
  # openhttp = { name = "openhttp" , description = "this opens 80 port"} ...


  for_each = tomap({ for nsg in var.web_nsg_rules : nsg.name => nsg })

  name                        = each.value.name
  resource_group_name         = azurerm_resource_group.group.name
  network_security_group_name = azurerm_network_security_group.web.name
  description                 = each.value.description
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  access                      = each.value.access
  priority                    = each.value.priority
  direction                   = "Inbound"
  depends_on = [
    azurerm_resource_group.group,
    azurerm_network_security_group.web
  ]

}

resource "azurerm_network_interface_security_group_association" "web" {
  network_interface_id      = azurerm_network_interface.web.id
  network_security_group_id = azurerm_network_security_group.web.id
  depends_on                = [azurerm_network_interface.web, azurerm_network_security_group.web]
}

resource "azurerm_network_interface" "web" {
  name                = "webnic01"
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web.id
  }
  depends_on = [azurerm_public_ip.web, azurerm_subnet.subnets]

}

resource "azurerm_linux_virtual_machine" "web" {
  name                = "webvm"
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location
  size                = "Standard_B1s"
  admin_username      = "Dell"
  network_interface_ids = [
    azurerm_network_interface.web.id,
  ]

  admin_ssh_key {
    username   = "Dell"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # urn is unique id number
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"

  }
  # custom_data = base64encode("./install.sh")

}
