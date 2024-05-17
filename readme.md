# Workflow

## To create virtual machine in azure, we will follow below steps

* first we create resource group
* now we will create virtual network
* virtual network will multiple subnets, so create multiple subnets, web, app, db with cidrs
* next step to assign public ip to vm, please create public_ip , it depends on resource group
* next step to require network_security_group, depend on source group
also it contain network_security_group_rule, please create it, it depends on resource group and network_security_group
* next step to create network_interface and it depend on resource group