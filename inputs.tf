### Defined variables

variable "primary_network_cidr" {
  type        = list(string)
  description = "This is primary networks cidr range"
  default     = ["192.168.0.0/16"]
}

variable "subnet_names" {
  type        = list(string)
  default     = ["web", "app", "db"]
  description = "subnet names"

}

variable "subnet_cidrs" {
  type        = list(string)
  default     = ["192.168.0.0/24", "192.168.1.0/24", "192.168.2.0/24"]
  description = "subnet cidrs"
}


# variable "web_nsg_rules" {
#   type = list(object({
#     name                       = string
#     description                = string
#     protocol                   = string
#     source_port_range          = string
#     destination_port_range     = string
#     source_address_prefix      = string
#     destination_address_prefix = string
#     access                     = string
#     priority                   = number
#   }))
#   description = "web nsg rules"
#   default = [{
#     name                       = "openhttp"
#     description                = "this opens 80 port"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "80"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#     access                     = "Allow"
#     priority                   = 1000
#   }]

# }

# example refer here
# -- start here
# variable "user_profiles" {
#   type = map(object({
#     name    = string
#     age     = number
#     is_admin = bool
#   }))
#   default = {
#     alice = { name = "Alice", age = 30, is_admin = true }
#     bob   = { name = "Bob", age = 25, is_admin = false }
#   }
# }
# -- end here

# variable "virtual_machines" {
#   type = list(object({
#     ip_address = string
#     name       = string
#   }))
#   default = [
#     { ip_address = "10.0.0.1", name = "vm-1" },
#     { ip_address = "10.0.0.2", name = "vm-2" }
#   ]
# }

# resource "example" "example" {
#   for_each   = tomap({ for vm in var.virtual_machines : vm.name => vm })
#   ip_address = each.value.ip_address
#   # Other attributes...
# }


variable "web_nsg_rules" {
  type = list(object({
    name                       = string
    description                = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
    access                     = string
    priority                   = number
  }))
  description = "web nsg rules"
  default = [{
    name                       = "openhttp"
    description                = "this opens 80 port"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    access                     = "Allow"
    priority                   = 1000
  }]

}