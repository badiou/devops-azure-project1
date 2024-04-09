# Azure Infrastructure Operations Project: Deploying a Scalable IaaS Web Server in Azure

## Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

## Getting Started
1. Clone this repository
2. Create your infrastructure as code
3. Update this README to reflect how someone would use your code.

## Dependencies
- Create an [Azure Account](https://portal.azure.com) 
- Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- Install [Packer](https://www.packer.io/downloads)
- Install [Terraform](https://www.terraform.io/downloads.html)

## Instructions
1. Create the resource group named udacityResourceGroup using the following command:
   ```
   az group create -n udacityResourceGroup -l eastus
   ```
   ```{
  "id": "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacityResourceGroup",
  "location": "eastus",
  "managedBy": null,
  "name": "udacityResourceGroup",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}```

2. Use the command `az group list -o table` to ensure that your group is created successfully.

3. Create a role with the following command, replacing `<subsription_id>` with yours:
   ```
   az ad sp create-for-rbac --name "udacity-project-1" --role Contributor --scopes /subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2 --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"
   ```

4. This command will output a JSON in the following format:
```
  "client_id": "xxxxxx-xxxx-xxxx-dddd-xxxxxxxxxx",
  "client_secret": "xxxxx~xxxx.-.xxxxxxxxxxx",
  "tenant_id": "xxxxxxxxxxxxxx"
  ```

   Add these pieces of information as environment variables (on Windows, use `set`; on Linux or macOS, use `export`):
   ```
   export ARM_CLIENT_ID="your_client_id"
   export ARM_CLIENT_SECRET="your_secret_id"
   export ARM_TENANT_ID="your_tenant_id"
   ```

   You can use the command 
   ```
   az account show --query "{ subscription_id: id }"
   ``` 
   to retrieve your subscription ID.

1. Create the policy using the following command:
   ```
   az policy definition create --name tagging-policy --rules tagging_policy.json
   ```

2. Apply the policy using this command:
   ```
   az policy assignment create --name tagging-policy --scope "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacityResourceGroup" --policy tagging-policy
   ```

3. Execute the command `packer build server.json` to create an image. You can verify from your Azure console that the image has been successfully created.

4. Execute the command `terraform init` to initialize Terraform within your directory.

5. Run `terraform plan -out solution.plan` to generate a Terraform execution plan to update your infrastructure based on changes made to your configuration files, and save this plan to a file named solution.plan. This plan can then be reviewed before being applied to the actual infrastructure using the command `terraform apply`.

6.  Execute the command `terraform apply "solution.plan"` to apply the plan to your Azure infrastructure.

7.  To delete all the resources you have deployed, you can issue the command `terraform destroy`.

## Output
12. Below, you will find the list of results obtained after executing certain commands:


- Result of the command `az group create -n udacityResourceGroup -l eastus`
```
{
  "id": "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacityResourceGroup",
  "location": "eastus",
  "managedBy": null,
  "name": "udacityResourceGroup",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}
```
- result of the command 
`az policy definition create --name tagging-policy --rules tagging_policy.json`
````
{
  "description": null,
  "displayName": null,
  "id": "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/providers/Microsoft.Authorization/policyDefinitions/tagging-policy",
  "metadata": {
    "createdBy": "7d20d7ca-7f8a-425e-8954-f7365ad50d47",
    "createdOn": "2024-04-08T19:20:50.8707202Z",
    "updatedBy": "7d20d7ca-7f8a-425e-8954-f7365ad50d47",
    "updatedOn": "2024-04-09T20:36:47.3463281Z"
  },
  "mode": "Indexed",
  "name": "tagging-policy",
  "parameters": null,
  "policyRule": {
    "if": {
      "allOf": [
        {
          "equals": "true",
          "value": "[empty(field('tags'))]"
        }
      ]
    },
    "then": {
      "effect": "Deny"
    }
  },
  "policyType": "Custom",
  "systemData": {
    "createdAt": "2024-04-08T19:20:50.661931+00:00",
    "createdBy": "obbadiou@gmail.com",
    "createdByType": "User",
    "lastModifiedAt": "2024-04-09T20:36:47.320494+00:00",
    "lastModifiedBy": "obbadiou@gmail.com",
    "lastModifiedByType": "User"
  },
  "type": "Microsoft.Authorization/policyDefinitions"
}
```

- Result of the command `az group list -o table`
```
Name                  Location    Status
--------------------  ----------  ---------
udacityResourceGroup  eastus      Succeeded
NetworkWatcherRG      eastus      Succeeded
```

- Result of the command `packer build server.json` 
  
```
ourobadiou@MacBook-Air-de-Badiou devops-azure-project1 % packer build server.json                                         
azure-arm: output will be in this color.

==> azure-arm: Running builder ...
    azure-arm: Creating Azure Resource Manager (ARM) client ...
==> azure-arm: Getting source image id for the deployment ...
==> azure-arm:  -> SourceImageName: '/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/providers/Microsoft.Compute/locations/East US/publishers/canonical/ArtifactTypes/vmimage/offers/UbuntuServer/skus/18.04-LTS/versions/latest'
==> azure-arm: Creating resource group ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-sg0rprbh7v'
==> azure-arm:  -> Location          : 'East US'
==> azure-arm:  -> Tags              :
==> azure-arm:  ->> stage : Submission
==> azure-arm:  ->> project_name : udacity-project-1
==> azure-arm: Validating deployment template ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-sg0rprbh7v'
==> azure-arm:  -> DeploymentName    : 'pkrdpsg0rprbh7v'
==> azure-arm: Deploying deployment template ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-sg0rprbh7v'
==> azure-arm:  -> DeploymentName    : 'pkrdpsg0rprbh7v'
==> azure-arm: Getting the VM's IP address ...
==> azure-arm:  -> ResourceGroupName   : 'pkr-Resource-Group-sg0rprbh7v'
==> azure-arm:  -> PublicIPAddressName : 'pkripsg0rprbh7v'
==> azure-arm:  -> NicName             : 'pkrnisg0rprbh7v'
==> azure-arm:  -> Network Connection  : 'PublicEndpoint'
==> azure-arm:  -> IP Address          : '13.92.2.112'
==> azure-arm: Waiting for SSH to become available...
==> azure-arm: Connected to SSH!
==> azure-arm: Provisioning with shell script: /var/folders/y2/5f0v9c8s4cd38dr623w38k_r0000gn/T/packer-shell264617515
==> azure-arm: + echo Hello, World!
==> azure-arm: Querying the machine's properties ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-sg0rprbh7v'
==> azure-arm:  -> ComputeName       : 'pkrvmsg0rprbh7v'
==> azure-arm:  -> Managed OS Disk   : '/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/pkr-Resource-Group-sg0rprbh7v/providers/Microsoft.Compute/disks/pkrossg0rprbh7v'
==> azure-arm: Querying the machine's additional disks properties ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-sg0rprbh7v'
==> azure-arm:  -> ComputeName       : 'pkrvmsg0rprbh7v'
==> azure-arm: Powering off machine ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-sg0rprbh7v'
==> azure-arm:  -> ComputeName       : 'pkrvmsg0rprbh7v'
==> azure-arm:  -> Compute ResourceGroupName : 'pkr-Resource-Group-sg0rprbh7v'
==> azure-arm:  -> Compute Name              : 'pkrvmsg0rprbh7v'
==> azure-arm:  -> Compute Location          : 'East US'
==> azure-arm: Generalizing machine ...
==> azure-arm: Capturing image ...
==> azure-arm:  -> Image ResourceGroupName   : 'udacityResourceGroup'
==> azure-arm:  -> Image Name                : 'myPackerImage'
==> azure-arm:  -> Image Location            : 'East US'
==> azure-arm: 
==> azure-arm: Deleting Virtual Machine deployment and its attached resources...
==> azure-arm: Adding to deletion queue -> Microsoft.Compute/virtualMachines : 'pkrvmsg0rprbh7v'
==> azure-arm: Adding to deletion queue -> Microsoft.Network/networkInterfaces : 'pkrnisg0rprbh7v'
==> azure-arm: Adding to deletion queue -> Microsoft.Network/virtualNetworks : 'pkrvnsg0rprbh7v'
==> azure-arm: Adding to deletion queue -> Microsoft.Network/publicIPAddresses : 'pkripsg0rprbh7v'
==> azure-arm: Attempting deletion -> Microsoft.Compute/virtualMachines : 'pkrvmsg0rprbh7v'
==> azure-arm: Attempting deletion -> Microsoft.Network/networkInterfaces : 'pkrnisg0rprbh7v'
==> azure-arm: Attempting deletion -> Microsoft.Network/virtualNetworks : 'pkrvnsg0rprbh7v'
==> azure-arm: Attempting deletion -> Microsoft.Network/publicIPAddresses : 'pkripsg0rprbh7v'
==> azure-arm: Waiting for deletion of all resources...
==> azure-arm: Couldn't delete Microsoft.Network/publicIPAddresses resource. Will retry.
==> azure-arm: Name: pkripsg0rprbh7v
==> azure-arm: Couldn't delete Microsoft.Network/networkInterfaces resource. Will retry.
==> azure-arm: Name: pkrnisg0rprbh7v
==> azure-arm: Couldn't delete Microsoft.Network/virtualNetworks resource. Will retry.
==> azure-arm: Name: pkrvnsg0rprbh7v
==> azure-arm: Attempting deletion -> Microsoft.Network/publicIPAddresses : 'pkripsg0rprbh7v'
==> azure-arm: Attempting deletion -> Microsoft.Network/networkInterfaces : 'pkrnisg0rprbh7v'
==> azure-arm: Attempting deletion -> Microsoft.Network/virtualNetworks : 'pkrvnsg0rprbh7v'
==> azure-arm: Couldn't delete Microsoft.Network/publicIPAddresses resource. Will retry.
==> azure-arm: Name: pkripsg0rprbh7v
==> azure-arm: Couldn't delete Microsoft.Network/virtualNetworks resource. Will retry.
==> azure-arm: Name: pkrvnsg0rprbh7v
==> azure-arm: Attempting deletion -> Microsoft.Network/publicIPAddresses : 'pkripsg0rprbh7v'
==> azure-arm: Attempting deletion -> Microsoft.Network/virtualNetworks : 'pkrvnsg0rprbh7v'
==> azure-arm:  Deleting -> Microsoft.Compute/disks : '/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/pkr-Resource-Group-sg0rprbh7v/providers/Microsoft.Compute/disks/pkrossg0rprbh7v'
==> azure-arm: Removing the created Deployment object: 'pkrdpsg0rprbh7v'
==> azure-arm: 
==> azure-arm: Cleanup requested, deleting resource group ...
==> azure-arm: Resource group has been deleted.
Build 'azure-arm' finished after 3 minutes 26 seconds.

==> Wait completed after 3 minutes 26 seconds

==> Builds finished. The artifacts of successful builds are:
--> azure-arm: Azure.ResourceManagement.VMImage:

OSType: Linux
ManagedImageResourceGroupName: udacityResourceGroup
ManagedImageName: myPackerImage
ManagedImageId: /subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacityResourceGroup/providers/Microsoft.Compute/images/myPackerImage
ManagedImageLocation: East US
```


- Result of the command `terraform plan -out solution.plan`
  
```
ourobadiou@MacBook-Air-de-Badiou devops-azure-project1 % terraform plan -out solution.plan
var.admin_password
  The password for the VM being created.

  Enter a value: B@diou2015

var.admin_username
  The admin username for the VM being created.

  Enter a value: ourobadiou

var.counter
  The number of virtual machines you want to create..

  Enter a value: 2

var.prefix
  The prefix which should be used for all resources in this example

  Enter a value: udacity-project


Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_lb.main will be created
  + resource "azurerm_lb" "main" {
      + id                   = (known after apply)
      + location             = "eastus"
      + name                 = "udacity-project-lb"
      + private_ip_address   = (known after apply)
      + private_ip_addresses = (known after apply)
      + resource_group_name  = "udacity-project-resources"
      + sku                  = "Standard"
      + sku_tier             = "Regional"
      + tags                 = {
          + "project_name" = "udacity-project-1"
          + "stage"        = "Submission"
        }
    }

  # azurerm_linux_virtual_machine.main[0] will be created
  + resource "azurerm_linux_virtual_machine" "main" {
      + admin_password                                         = (sensitive value)
      + admin_username                                         = "ourobadiou"
      + allow_extension_operations                             = true
      + bypass_platform_safety_checks_on_user_schedule_enabled = false
      + computer_name                                          = (known after apply)
      + disable_password_authentication                        = false
      + disk_controller_type                                   = (known after apply)
      + extensions_time_budget                                 = "PT1H30M"
      + id                                                     = (known after apply)
      + location                                               = "eastus"
      + max_bid_price                                          = -1
      + name                                                   = "udacity-project-vm0"
      + network_interface_ids                                  = (known after apply)
      + patch_assessment_mode                                  = "ImageDefault"
      + patch_mode                                             = "ImageDefault"
      + platform_fault_domain                                  = -1
      + priority                                               = "Regular"
      + private_ip_address                                     = (known after apply)
      + private_ip_addresses                                   = (known after apply)
      + provision_vm_agent                                     = true
      + public_ip_address                                      = (known after apply)
      + public_ip_addresses                                    = (known after apply)
      + resource_group_name                                    = "udacity-project-resources"
      + size                                                   = "Standard_D2s_v3"
      + tags                                                   = {
          + "project_name" = "udacity-project-1"
          + "stage"        = "Submission"
        }
      + virtual_machine_id                                     = (known after apply)
      + vm_agent_platform_updates_enabled                      = false

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + name                      = (known after apply)
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + source_image_reference {
          + offer     = "UbuntuServer"
          + publisher = "canonical"
          + sku       = "18.04-LTS"
          + version   = "latest"
        }
    }

  # azurerm_linux_virtual_machine.main[1] will be created
  + resource "azurerm_linux_virtual_machine" "main" {
      + admin_password                                         = (sensitive value)
      + admin_username                                         = "ourobadiou"
      + allow_extension_operations                             = true
      + bypass_platform_safety_checks_on_user_schedule_enabled = false
      + computer_name                                          = (known after apply)
      + disable_password_authentication                        = false
      + disk_controller_type                                   = (known after apply)
      + extensions_time_budget                                 = "PT1H30M"
      + id                                                     = (known after apply)
      + location                                               = "eastus"
      + max_bid_price                                          = -1
      + name                                                   = "udacity-project-vm1"
      + network_interface_ids                                  = (known after apply)
      + patch_assessment_mode                                  = "ImageDefault"
      + patch_mode                                             = "ImageDefault"
      + platform_fault_domain                                  = -1
      + priority                                               = "Regular"
      + private_ip_address                                     = (known after apply)
      + private_ip_addresses                                   = (known after apply)
      + provision_vm_agent                                     = true
      + public_ip_address                                      = (known after apply)
      + public_ip_addresses                                    = (known after apply)
      + resource_group_name                                    = "udacity-project-resources"
      + size                                                   = "Standard_D2s_v3"
      + tags                                                   = {
          + "project_name" = "udacity-project-1"
          + "stage"        = "Submission"
        }
      + virtual_machine_id                                     = (known after apply)
      + vm_agent_platform_updates_enabled                      = false

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + name                      = (known after apply)
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + source_image_reference {
          + offer     = "UbuntuServer"
          + publisher = "canonical"
          + sku       = "18.04-LTS"
          + version   = "latest"
        }
    }

  # azurerm_managed_disk.main will be created
  + resource "azurerm_managed_disk" "main" {
      + create_option                     = "Empty"
      + disk_iops_read_only               = (known after apply)
      + disk_iops_read_write              = (known after apply)
      + disk_mbps_read_only               = (known after apply)
      + disk_mbps_read_write              = (known after apply)
      + disk_size_gb                      = 1
      + id                                = (known after apply)
      + location                          = "eastus"
      + logical_sector_size               = (known after apply)
      + max_shares                        = (known after apply)
      + name                              = "acctestmd"
      + optimized_frequent_attach_enabled = false
      + performance_plus_enabled          = false
      + public_network_access_enabled     = true
      + resource_group_name               = "udacity-project-resources"
      + source_uri                        = (known after apply)
      + storage_account_type              = "Standard_LRS"
      + tags                              = {
          + "project_name" = "udacity-project-1"
          + "stage"        = "Submission"
        }
      + tier                              = (known after apply)
    }

  # azurerm_network_interface.main[0] will be created
  + resource "azurerm_network_interface" "main" {
      + applied_dns_servers           = (known after apply)
      + dns_servers                   = (known after apply)
      + enable_accelerated_networking = false
      + enable_ip_forwarding          = false
      + id                            = (known after apply)
      + internal_dns_name_label       = (known after apply)
      + internal_domain_name_suffix   = (known after apply)
      + location                      = "eastus"
      + mac_address                   = (known after apply)
      + name                          = "udacity-project-nic-0"
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "udacity-project-resources"
      + tags                          = {
          + "project_name" = "udacity-project-1"
          + "stage"        = "Submission"
        }
      + virtual_machine_id            = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "internal"
          + primary                                            = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + subnet_id                                          = (known after apply)
        }
    }

  # azurerm_network_interface.main[1] will be created
  + resource "azurerm_network_interface" "main" {
      + applied_dns_servers           = (known after apply)
      + dns_servers                   = (known after apply)
      + enable_accelerated_networking = false
      + enable_ip_forwarding          = false
      + id                            = (known after apply)
      + internal_dns_name_label       = (known after apply)
      + internal_domain_name_suffix   = (known after apply)
      + location                      = "eastus"
      + mac_address                   = (known after apply)
      + name                          = "udacity-project-nic-1"
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "udacity-project-resources"
      + tags                          = {
          + "project_name" = "udacity-project-1"
          + "stage"        = "Submission"
        }
      + virtual_machine_id            = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "internal"
          + primary                                            = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + subnet_id                                          = (known after apply)
        }
    }

  # azurerm_public_ip.main will be created
  + resource "azurerm_public_ip" "main" {
      + allocation_method       = "Static"
      + ddos_protection_mode    = "VirtualNetworkInherited"
      + fqdn                    = (known after apply)
      + id                      = (known after apply)
      + idle_timeout_in_minutes = 4
      + ip_address              = (known after apply)
      + ip_version              = "IPv4"
      + location                = "eastus"
      + name                    = "udacity-project-public-ip"
      + resource_group_name     = "udacity-project-resources"
      + sku                     = "Basic"
      + sku_tier                = "Regional"
      + tags                    = {
          + "project_name" = "udacity-project-1"
          + "stage"        = "Submission"
        }
    }

  # azurerm_resource_group.main will be created
  + resource "azurerm_resource_group" "main" {
      + id       = (known after apply)
      + location = "eastus"
      + name     = "udacity-project-resources"
      + tags     = {
          + "project_name" = "udacity-project-1"
          + "stage"        = "Submission"
        }
    }

  # azurerm_subnet.internal will be created
  + resource "azurerm_subnet" "internal" {
      + address_prefixes                               = [
          + "10.0.2.0/24",
        ]
      + enforce_private_link_endpoint_network_policies = (known after apply)
      + enforce_private_link_service_network_policies  = (known after apply)
      + id                                             = (known after apply)
      + name                                           = "internal"
      + private_endpoint_network_policies_enabled      = (known after apply)
      + private_link_service_network_policies_enabled  = (known after apply)
      + resource_group_name                            = "udacity-project-resources"
      + virtual_network_name                           = "udacity-project-network"
    }

  # azurerm_virtual_network.main will be created
  + resource "azurerm_virtual_network" "main" {
      + address_space       = [
          + "10.0.0.0/16",
        ]
      + dns_servers         = (known after apply)
      + guid                = (known after apply)
      + id                  = (known after apply)
      + location            = "eastus"
      + name                = "udacity-project-network"
      + resource_group_name = "udacity-project-resources"
      + subnet              = (known after apply)
      + tags                = {
          + "project_name" = "udacity-project-1"
          + "stage"        = "Submission"
        }
    }

Plan: 10 to add, 0 to change, 0 to destroy.
```
- Result of command ` terraform apply "solution.plan" `
```
ourobadiou@MacBook-Air-de-Badiou devops-azure-project1 % terraform apply "solution.plan"  
azurerm_resource_group.main: Creating...
azurerm_resource_group.main: Creation complete after 1s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources]
azurerm_virtual_network.main: Creating...
azurerm_lb.main: Creating...
azurerm_public_ip.main: Creating...
azurerm_managed_disk.main: Creating...
azurerm_public_ip.main: Creation complete after 4s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/publicIPAddresses/udacity-project-public-ip]
azurerm_managed_disk.main: Creation complete after 5s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Compute/disks/acctestmd]
azurerm_virtual_network.main: Creation complete after 7s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/virtualNetworks/udacity-project-network]
azurerm_subnet.internal: Creating...
azurerm_lb.main: Still creating... [10s elapsed]
azurerm_subnet.internal: Creation complete after 6s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/virtualNetworks/udacity-project-network/subnets/internal]
azurerm_network_interface.main[1]: Creating...
azurerm_network_interface.main[0]: Creating...
azurerm_lb.main: Creation complete after 13s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/loadBalancers/udacity-project-lb]
azurerm_network_interface.main[0]: Still creating... [10s elapsed]
azurerm_network_interface.main[1]: Still creating... [10s elapsed]
azurerm_network_interface.main[1]: Creation complete after 13s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/networkInterfaces/udacity-project-nic-1]
azurerm_network_interface.main[0]: Still creating... [20s elapsed]
azurerm_network_interface.main[0]: Creation complete after 26s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/networkInterfaces/udacity-project-nic-0]
azurerm_linux_virtual_machine.main[0]: Creating...
azurerm_linux_virtual_machine.main[1]: Creating...
azurerm_linux_virtual_machine.main[1]: Still creating... [10s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [10s elapsed]
azurerm_linux_virtual_machine.main[0]: Creation complete after 14s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Compute/virtualMachines/udacity-project-vm0]
azurerm_linux_virtual_machine.main[1]: Still creating... [20s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [30s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [40s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [50s elapsed]
azurerm_linux_virtual_machine.main[1]: Creation complete after 50s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Compute/virtualMachines/udacity-project-vm1]

Apply complete! Resources: 10 added, 0 changed, 0 destroyed.
ourobadiou@MacBook-Air-de-Badiou devops-azure-project1 % 
```

- DO NOT FORGET TO RUN `terraform destroy` IF YOU WANT TO DELETE YOUR RESOURCES
```
ourobadiou@MacBook-Air-de-Badiou devops-azure-project1 % terraform destroy
var.admin_password
  The password for the VM being created.

  Enter a value: B@diou2015

var.admin_username
  The admin username for the VM being created.

  Enter a value: ourobadiou

var.counter
  The number of virtual machines you want to create..

  Enter a value: 2

var.prefix
  The prefix which should be used for all resources in this example

  Enter a value: udacity-project

azurerm_resource_group.main: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources]
azurerm_public_ip.main: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/publicIPAddresses/udacity-project-public-ip]
azurerm_virtual_network.main: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/virtualNetworks/udacity-project-network]
azurerm_lb.main: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/loadBalancers/udacity-project-lb]
azurerm_managed_disk.main: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Compute/disks/acctestmd]
azurerm_subnet.internal: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/virtualNetworks/udacity-project-network/subnets/internal]
azurerm_network_interface.main[1]: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/networkInterfaces/udacity-project-nic-1]
azurerm_network_interface.main[0]: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/networkInterfaces/udacity-project-nic-0]
azurerm_linux_virtual_machine.main[0]: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Compute/virtualMachines/udacity-project-vm0]
azurerm_linux_virtual_machine.main[1]: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Compute/virtualMachines/udacity-project-vm1]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # azurerm_lb.main will be destroyed
  - resource "azurerm_lb" "main" {
      - id                   = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/loadBalancers/udacity-project-lb" -> null
      - location             = "eastus" -> null
      - name                 = "udacity-project-lb" -> null
      - private_ip_addresses = [] -> null
      - resource_group_name  = "udacity-project-resources" -> null
      - sku                  = "Standard" -> null
      - sku_tier             = "Regional" -> null
      - tags                 = {
          - "project_name" = "udacity-project-1"
          - "stage"        = "Submission"
        } -> null
    }

  # azurerm_linux_virtual_machine.main[0] will be destroyed
  - resource "azurerm_linux_virtual_machine" "main" {
      - admin_password                                         = (sensitive value) -> null
      - admin_username                                         = "ourobadiou" -> null
      - allow_extension_operations                             = true -> null
      - bypass_platform_safety_checks_on_user_schedule_enabled = false -> null
      - computer_name                                          = "udacity-project-vm0" -> null
      - disable_password_authentication                        = false -> null
      - encryption_at_host_enabled                             = false -> null
      - extensions_time_budget                                 = "PT1H30M" -> null
      - id                                                     = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Compute/virtualMachines/udacity-project-vm0" -> null
      - location                                               = "eastus" -> null
      - max_bid_price                                          = -1 -> null
      - name                                                   = "udacity-project-vm0" -> null
      - network_interface_ids                                  = [
          - "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/networkInterfaces/udacity-project-nic-0",
        ] -> null
      - patch_assessment_mode                                  = "ImageDefault" -> null
      - patch_mode                                             = "ImageDefault" -> null
      - platform_fault_domain                                  = -1 -> null
      - priority                                               = "Regular" -> null
      - private_ip_address                                     = "10.0.2.5" -> null
      - private_ip_addresses                                   = [
          - "10.0.2.5",
        ] -> null
      - provision_vm_agent                                     = true -> null
      - public_ip_addresses                                    = [] -> null
      - resource_group_name                                    = "udacity-project-resources" -> null
      - secure_boot_enabled                                    = false -> null
      - size                                                   = "Standard_D2s_v3" -> null
      - tags                                                   = {
          - "project_name" = "udacity-project-1"
          - "stage"        = "Submission"
        } -> null
      - virtual_machine_id                                     = "4d779327-c010-4fc6-84b5-9f9a401e983b" -> null
      - vm_agent_platform_updates_enabled                      = false -> null
      - vtpm_enabled                                           = false -> null

      - os_disk {
          - caching                   = "ReadWrite" -> null
          - disk_size_gb              = 30 -> null
          - name                      = "udacity-project-vm0_disk1_493b9e6d6bcb4624957beac4016debee" -> null
          - storage_account_type      = "Standard_LRS" -> null
          - write_accelerator_enabled = false -> null
        }

      - source_image_reference {
          - offer     = "UbuntuServer" -> null
          - publisher = "canonical" -> null
          - sku       = "18.04-LTS" -> null
          - version   = "latest" -> null
        }
    }

  # azurerm_linux_virtual_machine.main[1] will be destroyed
  - resource "azurerm_linux_virtual_machine" "main" {
      - admin_password                                         = (sensitive value) -> null
      - admin_username                                         = "ourobadiou" -> null
      - allow_extension_operations                             = true -> null
      - bypass_platform_safety_checks_on_user_schedule_enabled = false -> null
      - computer_name                                          = "udacity-project-vm1" -> null
      - disable_password_authentication                        = false -> null
      - encryption_at_host_enabled                             = false -> null
      - extensions_time_budget                                 = "PT1H30M" -> null
      - id                                                     = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Compute/virtualMachines/udacity-project-vm1" -> null
      - location                                               = "eastus" -> null
      - max_bid_price                                          = -1 -> null
      - name                                                   = "udacity-project-vm1" -> null
      - network_interface_ids                                  = [
          - "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/networkInterfaces/udacity-project-nic-1",
        ] -> null
      - patch_assessment_mode                                  = "ImageDefault" -> null
      - patch_mode                                             = "ImageDefault" -> null
      - platform_fault_domain                                  = -1 -> null
      - priority                                               = "Regular" -> null
      - private_ip_address                                     = "10.0.2.4" -> null
      - private_ip_addresses                                   = [
          - "10.0.2.4",
        ] -> null
      - provision_vm_agent                                     = true -> null
      - public_ip_addresses                                    = [] -> null
      - resource_group_name                                    = "udacity-project-resources" -> null
      - secure_boot_enabled                                    = false -> null
      - size                                                   = "Standard_D2s_v3" -> null
      - tags                                                   = {
          - "project_name" = "udacity-project-1"
          - "stage"        = "Submission"
        } -> null
      - virtual_machine_id                                     = "c8c21068-288b-4c68-8a86-92deb888a4bc" -> null
      - vm_agent_platform_updates_enabled                      = false -> null
      - vtpm_enabled                                           = false -> null

      - os_disk {
          - caching                   = "ReadWrite" -> null
          - disk_size_gb              = 30 -> null
          - name                      = "udacity-project-vm1_OsDisk_1_5d371cb112fa43ba8210dd586cc4b2fe" -> null
          - storage_account_type      = "Standard_LRS" -> null
          - write_accelerator_enabled = false -> null
        }

      - source_image_reference {
          - offer     = "UbuntuServer" -> null
          - publisher = "canonical" -> null
          - sku       = "18.04-LTS" -> null
          - version   = "latest" -> null
        }
    }

  # azurerm_managed_disk.main will be destroyed
  - resource "azurerm_managed_disk" "main" {
      - create_option                     = "Empty" -> null
      - disk_iops_read_only               = 0 -> null
      - disk_iops_read_write              = 500 -> null
      - disk_mbps_read_only               = 0 -> null
      - disk_mbps_read_write              = 60 -> null
      - disk_size_gb                      = 1 -> null
      - id                                = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Compute/disks/acctestmd" -> null
      - location                          = "eastus" -> null
      - max_shares                        = 0 -> null
      - name                              = "acctestmd" -> null
      - on_demand_bursting_enabled        = false -> null
      - optimized_frequent_attach_enabled = false -> null
      - performance_plus_enabled          = false -> null
      - public_network_access_enabled     = true -> null
      - resource_group_name               = "udacity-project-resources" -> null
      - storage_account_type              = "Standard_LRS" -> null
      - tags                              = {
          - "project_name" = "udacity-project-1"
          - "stage"        = "Submission"
        } -> null
      - trusted_launch_enabled            = false -> null
      - upload_size_bytes                 = 0 -> null
    }

  # azurerm_network_interface.main[0] will be destroyed
  - resource "azurerm_network_interface" "main" {
      - applied_dns_servers           = [] -> null
      - dns_servers                   = [] -> null
      - enable_accelerated_networking = false -> null
      - enable_ip_forwarding          = false -> null
      - id                            = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/networkInterfaces/udacity-project-nic-0" -> null
      - internal_domain_name_suffix   = "2gappwrgezoexfltekyh1r0pod.bx.internal.cloudapp.net" -> null
      - location                      = "eastus" -> null
      - mac_address                   = "7C-1E-52-00-96-E5" -> null
      - name                          = "udacity-project-nic-0" -> null
      - private_ip_address            = "10.0.2.5" -> null
      - private_ip_addresses          = [
          - "10.0.2.5",
        ] -> null
      - resource_group_name           = "udacity-project-resources" -> null
      - tags                          = {
          - "project_name" = "udacity-project-1"
          - "stage"        = "Submission"
        } -> null
      - virtual_machine_id            = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Compute/virtualMachines/udacity-project-vm0" -> null

      - ip_configuration {
          - name                          = "internal" -> null
          - primary                       = true -> null
          - private_ip_address            = "10.0.2.5" -> null
          - private_ip_address_allocation = "Dynamic" -> null
          - private_ip_address_version    = "IPv4" -> null
          - subnet_id                     = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/virtualNetworks/udacity-project-network/subnets/internal" -> null
        }
    }

  # azurerm_network_interface.main[1] will be destroyed
  - resource "azurerm_network_interface" "main" {
      - applied_dns_servers           = [] -> null
      - dns_servers                   = [] -> null
      - enable_accelerated_networking = false -> null
      - enable_ip_forwarding          = false -> null
      - id                            = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/networkInterfaces/udacity-project-nic-1" -> null
      - internal_domain_name_suffix   = "2gappwrgezoexfltekyh1r0pod.bx.internal.cloudapp.net" -> null
      - location                      = "eastus" -> null
      - mac_address                   = "00-22-48-1F-43-B9" -> null
      - name                          = "udacity-project-nic-1" -> null
      - private_ip_address            = "10.0.2.4" -> null
      - private_ip_addresses          = [
          - "10.0.2.4",
        ] -> null
      - resource_group_name           = "udacity-project-resources" -> null
      - tags                          = {
          - "project_name" = "udacity-project-1"
          - "stage"        = "Submission"
        } -> null
      - virtual_machine_id            = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Compute/virtualMachines/udacity-project-vm1" -> null

      - ip_configuration {
          - name                          = "internal" -> null
          - primary                       = true -> null
          - private_ip_address            = "10.0.2.4" -> null
          - private_ip_address_allocation = "Dynamic" -> null
          - private_ip_address_version    = "IPv4" -> null
          - subnet_id                     = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/virtualNetworks/udacity-project-network/subnets/internal" -> null
        }
    }

  # azurerm_public_ip.main will be destroyed
  - resource "azurerm_public_ip" "main" {
      - allocation_method       = "Static" -> null
      - ddos_protection_mode    = "VirtualNetworkInherited" -> null
      - id                      = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/publicIPAddresses/udacity-project-public-ip" -> null
      - idle_timeout_in_minutes = 4 -> null
      - ip_address              = "13.82.98.174" -> null
      - ip_tags                 = {} -> null
      - ip_version              = "IPv4" -> null
      - location                = "eastus" -> null
      - name                    = "udacity-project-public-ip" -> null
      - resource_group_name     = "udacity-project-resources" -> null
      - sku                     = "Basic" -> null
      - sku_tier                = "Regional" -> null
      - tags                    = {
          - "project_name" = "udacity-project-1"
          - "stage"        = "Submission"
        } -> null
      - zones                   = [] -> null
    }

  # azurerm_resource_group.main will be destroyed
  - resource "azurerm_resource_group" "main" {
      - id       = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources" -> null
      - location = "eastus" -> null
      - name     = "udacity-project-resources" -> null
      - tags     = {
          - "project_name" = "udacity-project-1"
          - "stage"        = "Submission"
        } -> null
    }

  # azurerm_subnet.internal will be destroyed
  - resource "azurerm_subnet" "internal" {
      - address_prefixes                               = [
          - "10.0.2.0/24",
        ] -> null
      - enforce_private_link_endpoint_network_policies = false -> null
      - enforce_private_link_service_network_policies  = false -> null
      - id                                             = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/virtualNetworks/udacity-project-network/subnets/internal" -> null
      - name                                           = "internal" -> null
      - private_endpoint_network_policies_enabled      = true -> null
      - private_link_service_network_policies_enabled  = true -> null
      - resource_group_name                            = "udacity-project-resources" -> null
      - service_endpoint_policy_ids                    = [] -> null
      - service_endpoints                              = [] -> null
      - virtual_network_name                           = "udacity-project-network" -> null
    }

  # azurerm_virtual_network.main will be destroyed
  - resource "azurerm_virtual_network" "main" {
      - address_space           = [
          - "10.0.0.0/16",
        ] -> null
      - dns_servers             = [] -> null
      - flow_timeout_in_minutes = 0 -> null
      - guid                    = "daf780e1-2626-4b5c-9573-22b07dc74f73" -> null
      - id                      = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/virtualNetworks/udacity-project-network" -> null
      - location                = "eastus" -> null
      - name                    = "udacity-project-network" -> null
      - resource_group_name     = "udacity-project-resources" -> null
      - subnet                  = [
          - {
              - address_prefix = "10.0.2.0/24"
              - id             = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/virtualNetworks/udacity-project-network/subnets/internal"
              - name           = "internal"
              - security_group = ""
            },
        ] -> null
      - tags                    = {
          - "project_name" = "udacity-project-1"
          - "stage"        = "Submission"
        } -> null
    }

Plan: 0 to add, 0 to change, 10 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

azurerm_managed_disk.main: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Compute/disks/acctestmd]
azurerm_linux_virtual_machine.main[1]: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Compute/virtualMachines/udacity-project-vm1]
azurerm_public_ip.main: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/publicIPAddresses/udacity-project-public-ip]
azurerm_lb.main: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/loadBalancers/udacity-project-lb]
azurerm_linux_virtual_machine.main[0]: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Compute/virtualMachines/udacity-project-vm0]
azurerm_managed_disk.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ders/Microsoft.Compute/disks/acctestmd, 10s elapsed]
azurerm_public_ip.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...cIPAddresses/udacity-project-public-ip, 10s elapsed]
azurerm_linux_virtual_machine.main[1]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...te/virtualMachines/udacity-project-vm1, 10s elapsed]
azurerm_linux_virtual_machine.main[0]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...te/virtualMachines/udacity-project-vm0, 10s elapsed]
azurerm_lb.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...twork/loadBalancers/udacity-project-lb, 10s elapsed]
azurerm_lb.main: Destruction complete after 11s
azurerm_public_ip.main: Destruction complete after 11s
azurerm_managed_disk.main: Destruction complete after 11s
azurerm_linux_virtual_machine.main[1]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...te/virtualMachines/udacity-project-vm1, 20s elapsed]
azurerm_linux_virtual_machine.main[0]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...te/virtualMachines/udacity-project-vm0, 20s elapsed]
azurerm_linux_virtual_machine.main[1]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...te/virtualMachines/udacity-project-vm1, 30s elapsed]
azurerm_linux_virtual_machine.main[0]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...te/virtualMachines/udacity-project-vm0, 30s elapsed]
azurerm_linux_virtual_machine.main[1]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...te/virtualMachines/udacity-project-vm1, 40s elapsed]
azurerm_linux_virtual_machine.main[0]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...te/virtualMachines/udacity-project-vm0, 40s elapsed]
azurerm_linux_virtual_machine.main[0]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...te/virtualMachines/udacity-project-vm0, 50s elapsed]
azurerm_linux_virtual_machine.main[1]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...te/virtualMachines/udacity-project-vm1, 50s elapsed]
azurerm_linux_virtual_machine.main[0]: Destruction complete after 59s
azurerm_linux_virtual_machine.main[1]: Destruction complete after 59s
azurerm_network_interface.main[0]: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/networkInterfaces/udacity-project-nic-0]
azurerm_network_interface.main[1]: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/networkInterfaces/udacity-project-nic-1]
azurerm_network_interface.main[0]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...etworkInterfaces/udacity-project-nic-0, 10s elapsed]
azurerm_network_interface.main[1]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...etworkInterfaces/udacity-project-nic-1, 10s elapsed]
azurerm_network_interface.main[1]: Destruction complete after 12s
azurerm_network_interface.main[0]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...etworkInterfaces/udacity-project-nic-0, 20s elapsed]
azurerm_network_interface.main[0]: Destruction complete after 23s
azurerm_subnet.internal: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/virtualNetworks/udacity-project-network/subnets/internal]
azurerm_subnet.internal: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...acity-project-network/subnets/internal, 10s elapsed]
azurerm_subnet.internal: Destruction complete after 10s
azurerm_virtual_network.main: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources/providers/Microsoft.Network/virtualNetworks/udacity-project-network]
azurerm_virtual_network.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...irtualNetworks/udacity-project-network, 10s elapsed]
azurerm_virtual_network.main: Destruction complete after 11s
azurerm_resource_group.main: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-project-resources]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...sourceGroups/udacity-project-resources, 10s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...sourceGroups/udacity-project-resources, 20s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...sourceGroups/udacity-project-resources, 30s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...sourceGroups/udacity-project-resources, 40s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...sourceGroups/udacity-project-resources, 50s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...sourceGroups/udacity-project-resources, 1m0s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...sourceGroups/udacity-project-resources, 1m10s elapsed]
azurerm_resource_group.main: Destruction complete after 1m19s

Destroy complete! Resources: 10 destroyed.
```