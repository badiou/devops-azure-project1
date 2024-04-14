# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default="udacity"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "East US"
}

variable "admin_username" {
  description = "The admin username for the VM being created."
  default= "ourobadiou"
}

variable "admin_password" {
  description = "The password for the VM being created."
  default="B@diou2023"
}

variable "counter" {
  description = "The number of virtual machines you want to create.."
  default=2
  
}