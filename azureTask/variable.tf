variable "rg1" {
    type = string
    default = "avi"
    description = "enter resource group name"
}

variable "location" {
    type = string
    default = "East Asia"
    description = "enter region from list Southeast Asia,East US, East Asia, South India, West India"
}
variable "vm_name" {
    type = string
    default = "vm1"
    description = "enter virtual machine name"
}
variable "vn_name" {
  type = string
  default = "vn1"
  description = "enter virtual network name"
}
variable "range" {
    type = string
    default = "10.20.0.0/16"
    description = "provide cidr range ex- 10.20.0.0/16"
}
variable "subnet_name" {
  type = string
  default = "sn1"
  description = "enter subnet network name"
} 
variable "subnet_range" {
    type = string
    default = "10.20.1.0/24"
    description = "provide subnet range ex- 10.20.1.0/24"
} 
variable "computername" {
  
}
variable "adminuser" {
  
}
variable "adminpasswd" {
  
}