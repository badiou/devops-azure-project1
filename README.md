# Azure Infrastructure Operations Project: Deploying a Scalable IaaS Web Server in Azure

## Introduction
For this project, you will create a Packer template and a Terraform template to automate the deployment of a flexible and scalable web server infrastructure on Azure. The goal is to streamline the process of provisioning and configuring virtual machines, allowing for easy customization and efficient scaling of resources as needed."

## Getting Started
1. Clone this repository
2. Create your infrastructure as code

## Dependencies
- Create an [Azure Account](https://portal.azure.com) 
- Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- Install [Packer](https://www.packer.io/downloads)
- Install [Terraform](https://www.terraform.io/downloads.html)

## Instructions
1. Create the resource group named udacityResourceGroup using the following command:
   `az group create -n udacityResourceGroup -l eastus`

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

5. Create the policy using the following command:
   ```
   az policy definition create --name tagging-policy --rules tagging_policy.json
   ```

6. Apply the policy using this command:
   ```
   az policy assignment create --name tagging-policy --scope "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacityResourceGroup" --policy tagging-policy
   ```

7. Execute the command `packer build server.json` to create an image. You can verify from your Azure console that the image has been successfully created.

8. Execute the command `terraform init` to initialize Terraform within your directory.

9.  Run 
```
terraform apply \
    -var="prefix=my_prefix" \  # Replace "my_prefix" with your custom prefix, or use the default value "udacity"
    -var="location=East US" \   # Replace "East US" with your custom Azure region, or use the default value
    -var="admin_username=my_username" \  # Replace "my_username" with your custom admin username, or use the default value "ourobadiou"
    -var="admin_password=my_passwordSecret" \  # Replace "my_passwordSecret" with your custom password, or use the default value "B@diou2023"
    -var="counter=2" "solution.plan"  # Specify the number of virtual machines to create (in this example, 2)
```
to generate a Terraform execution plan to update your infrastructure based on changes made to your configuration files, and save this plan to a file named solution.plan. vars.tf file define all variables.

If you wish to use the default values for the variables, run `terraform apply "solution.plan"`


10.  Execute the command `terraform apply "solution.plan"` to apply the plan to your Azure infrastructure.

11. To delete all the resources you have deployed, you can issue the command `terraform destroy`.

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
- Result of the command 
`az policy definition create --name tagging-policy --rules tagging_policy.json`
`az policy assignment show --name tagging-policy --scope "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacityResourceGroup"`
```
ourobadiou@MacBook-Air-de-Badiou devops-azure-project1 %   az policy assignment show --name tagging-policy --scope "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacityResourceGroup"
{
  "description": null,
  "displayName": null,
  "enforcementMode": "Default",
  "id": "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacityResourceGroup/providers/Microsoft.Authorization/policyAssignments/tagging-policy",
  "identity": null,
  "location": null,
  "metadata": {
    "createdBy": "7d20d7ca-7f8a-425e-8954-f7365ad50d47",
    "createdOn": "2024-04-14T13:09:47.8438337Z",
    "updatedBy": null,
    "updatedOn": null
  },
  "name": "tagging-policy",
  "nonComplianceMessages": null,
  "notScopes": null,
  "parameters": null,
  "policyDefinitionId": "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/providers/Microsoft.Authorization/policyDefinitions/tagging-policy",
  "resourceGroup": "udacityResourceGroup",
  "scope": "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacityResourceGroup",
  "systemData": {
    "createdAt": "2024-04-14T13:09:47.801407+00:00",
    "createdBy": "obbadiou@gmail.com",
    "createdByType": "User",
    "lastModifiedAt": "2024-04-14T13:09:47.801407+00:00",
    "lastModifiedBy": "obbadiou@gmail.com",
    "lastModifiedByType": "User"
  },
  "type": "Microsoft.Authorization/policyAssignments"
}
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
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-se9nemh691'
==> azure-arm:  -> Location          : 'East US'
==> azure-arm:  -> Tags              :
==> azure-arm:  ->> project_name : udacity-project
==> azure-arm:  ->> stage : Submission
==> azure-arm: Validating deployment template ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-se9nemh691'
==> azure-arm:  -> DeploymentName    : 'pkrdpse9nemh691'
==> azure-arm: Deploying deployment template ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-se9nemh691'
==> azure-arm:  -> DeploymentName    : 'pkrdpse9nemh691'
==> azure-arm: Getting the VM's IP address ...
==> azure-arm:  -> ResourceGroupName   : 'pkr-Resource-Group-se9nemh691'
==> azure-arm:  -> PublicIPAddressName : 'pkripse9nemh691'
==> azure-arm:  -> NicName             : 'pkrnise9nemh691'
==> azure-arm:  -> Network Connection  : 'PublicEndpoint'
==> azure-arm:  -> IP Address          : '52.224.236.155'
==> azure-arm: Waiting for SSH to become available...
==> azure-arm: Connected to SSH!
==> azure-arm: Provisioning with shell script: /var/folders/y2/5f0v9c8s4cd38dr623w38k_r0000gn/T/packer-shell3501637285
==> azure-arm: + echo Hello, World!
==> azure-arm: Querying the machine's properties ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-se9nemh691'
==> azure-arm:  -> ComputeName       : 'pkrvmse9nemh691'
==> azure-arm:  -> Managed OS Disk   : '/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/pkr-Resource-Group-se9nemh691/providers/Microsoft.Compute/disks/pkrosse9nemh691'
==> azure-arm: Querying the machine's additional disks properties ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-se9nemh691'
==> azure-arm:  -> ComputeName       : 'pkrvmse9nemh691'
==> azure-arm: Powering off machine ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-se9nemh691'
==> azure-arm:  -> ComputeName       : 'pkrvmse9nemh691'
==> azure-arm:  -> Compute ResourceGroupName : 'pkr-Resource-Group-se9nemh691'
==> azure-arm:  -> Compute Name              : 'pkrvmse9nemh691'
==> azure-arm:  -> Compute Location          : 'East US'
==> azure-arm: Generalizing machine ...
==> azure-arm: Capturing image ...
==> azure-arm:  -> Image ResourceGroupName   : 'udacityResourceGroup'
==> azure-arm:  -> Image Name                : 'myPackerImage'
==> azure-arm:  -> Image Location            : 'East US'
==> azure-arm: 
==> azure-arm: Deleting Virtual Machine deployment and its attached resources...
==> azure-arm: Adding to deletion queue -> Microsoft.Compute/virtualMachines : 'pkrvmse9nemh691'
==> azure-arm: Adding to deletion queue -> Microsoft.Network/networkInterfaces : 'pkrnise9nemh691'
==> azure-arm: Adding to deletion queue -> Microsoft.Network/virtualNetworks : 'pkrvnse9nemh691'
==> azure-arm: Adding to deletion queue -> Microsoft.Network/publicIPAddresses : 'pkripse9nemh691'
==> azure-arm: Waiting for deletion of all resources...
==> azure-arm: Attempting deletion -> Microsoft.Network/publicIPAddresses : 'pkripse9nemh691'
==> azure-arm: Attempting deletion -> Microsoft.Network/virtualNetworks : 'pkrvnse9nemh691'
==> azure-arm: Attempting deletion -> Microsoft.Network/networkInterfaces : 'pkrnise9nemh691'
==> azure-arm: Attempting deletion -> Microsoft.Compute/virtualMachines : 'pkrvmse9nemh691'
==> azure-arm: Couldn't delete Microsoft.Network/publicIPAddresses resource. Will retry.
==> azure-arm: Name: pkripse9nemh691
==> azure-arm: Couldn't delete Microsoft.Network/virtualNetworks resource. Will retry.
==> azure-arm: Name: pkrvnse9nemh691
==> azure-arm: Attempting deletion -> Microsoft.Network/publicIPAddresses : 'pkripse9nemh691'
==> azure-arm: Attempting deletion -> Microsoft.Network/virtualNetworks : 'pkrvnse9nemh691'
==> azure-arm: Couldn't delete Microsoft.Network/publicIPAddresses resource. Will retry.
==> azure-arm: Name: pkripse9nemh691
==> azure-arm: Couldn't delete Microsoft.Network/virtualNetworks resource. Will retry.
==> azure-arm: Name: pkrvnse9nemh691
==> azure-arm: Attempting deletion -> Microsoft.Network/publicIPAddresses : 'pkripse9nemh691'
==> azure-arm: Attempting deletion -> Microsoft.Network/virtualNetworks : 'pkrvnse9nemh691'
==> azure-arm:  Deleting -> Microsoft.Compute/disks : '/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/pkr-Resource-Group-se9nemh691/providers/Microsoft.Compute/disks/pkrosse9nemh691'
==> azure-arm: Removing the created Deployment object: 'pkrdpse9nemh691'
==> azure-arm: 
==> azure-arm: Cleanup requested, deleting resource group ...
==> azure-arm: Resource group has been deleted.
Build 'azure-arm' finished after 3 minutes 56 seconds.

==> Wait completed after 3 minutes 56 seconds

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
data.azurerm_image.main: Reading...
data.azurerm_image.main: Read complete after 0s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacityResourceGroup/providers/Microsoft.Compute/images/myPackerImage]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_lb.main will be created
  + resource "azurerm_lb" "main" {
      + id                   = (known after apply)
      + location             = "eastus"
      + name                 = "udacity-lb"
      + private_ip_address   = (known after apply)
      + private_ip_addresses = (known after apply)
      + resource_group_name  = "udacity-resources"
      + sku                  = "Standard"
      + sku_tier             = "Regional"
      + tags                 = {
          + "project_name" = "udacity-project"
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
      + name                                                   = "udacity-vm0"
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
      + resource_group_name                                    = "udacity-resources"
      + size                                                   = "Standard_D2s_v3"
      + source_image_id                                        = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacityResourceGroup/providers/Microsoft.Compute/images/myPackerImage"
      + tags                                                   = {
          + "project_name" = "udacity-project"
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
      + name                                                   = "udacity-vm1"
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
      + resource_group_name                                    = "udacity-resources"
      + size                                                   = "Standard_D2s_v3"
      + source_image_id                                        = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacityResourceGroup/providers/Microsoft.Compute/images/myPackerImage"
      + tags                                                   = {
          + "project_name" = "udacity-project"
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
      + resource_group_name               = "udacity-resources"
      + source_uri                        = (known after apply)
      + storage_account_type              = "Standard_LRS"
      + tags                              = {
          + "project_name" = "udacity-project"
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
      + name                          = "udacity-nic-0"
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "udacity-resources"
      + tags                          = {
          + "project_name" = "udacity-project"
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
      + name                          = "udacity-nic-1"
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "udacity-resources"
      + tags                          = {
          + "project_name" = "udacity-project"
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

  # azurerm_network_security_group.main will be created
  + resource "azurerm_network_security_group" "main" {
      + id                  = (known after apply)
      + location            = "eastus"
      + name                = "udacity-NSG"
      + resource_group_name = "udacity-resources"
      + security_rule       = [
          + {
              + access                                     = "Deny"
              + description                                = ""
              + destination_address_prefix                 = "*"
              + destination_address_prefixes               = []
              + destination_application_security_group_ids = []
              + destination_port_range                     = "*"
              + destination_port_ranges                    = []
              + direction                                  = "Inbound"
              + name                                       = "Inbound-DeniedAll"
              + priority                                   = 100
              + protocol                                   = "*"
              + source_address_prefix                      = "*"
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
            },
        ]
      + tags                = {
          + "project_name" = "udacity-project"
          + "stage"        = "Submission"
        }
    }

  # azurerm_network_security_rule.main will be created
  + resource "azurerm_network_security_rule" "main" {
      + access                      = "Allow"
      + destination_address_prefix  = "*"
      + destination_port_range      = "*"
      + direction                   = "Outbound"
      + id                          = (known after apply)
      + name                        = "udacity-NSRule"
      + network_security_group_name = "udacity-NSG"
      + priority                    = 100
      + protocol                    = "Tcp"
      + resource_group_name         = "udacity-resources"
      + source_address_prefix       = "*"
      + source_port_range           = "*"
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
      + name                    = "udacity-public-ip"
      + resource_group_name     = "udacity-resources"
      + sku                     = "Basic"
      + sku_tier                = "Regional"
      + tags                    = {
          + "project_name" = "udacity-project"
          + "stage"        = "Submission"
        }
    }

  # azurerm_resource_group.main will be created
  + resource "azurerm_resource_group" "main" {
      + id       = (known after apply)
      + location = "eastus"
      + name     = "udacity-resources"
      + tags     = {
          + "project_name" = "udacity-project"
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
      + resource_group_name                            = "udacity-resources"
      + virtual_network_name                           = "udacity-network"
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
      + name                = "udacity-network"
      + resource_group_name = "udacity-resources"
      + subnet              = (known after apply)
      + tags                = {
          + "project_name" = "udacity-project"
          + "stage"        = "Submission"
        }
    }

Plan: 12 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: solution.plan

To perform exactly these actions, run the following command to apply:
    terraform apply "solution.plan"
```

- Result of the command `terraform apply "solution.plan"`
```
ourobadiou@MacBook-Air-de-Badiou devops-azure-project1 % terraform apply "solution.plan"                  
azurerm_resource_group.main: Creating...
azurerm_resource_group.main: Creation complete after 2s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources]
azurerm_public_ip.main: Creating...
azurerm_virtual_network.main: Creating...
azurerm_network_security_group.main: Creating...
azurerm_lb.main: Creating...
azurerm_managed_disk.main: Creating...
azurerm_network_security_group.main: Creation complete after 3s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/networkSecurityGroups/udacity-NSG]
azurerm_network_security_rule.main: Creating...
azurerm_public_ip.main: Creation complete after 3s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/publicIPAddresses/udacity-public-ip]
azurerm_managed_disk.main: Creation complete after 4s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Compute/disks/acctestmd]
azurerm_virtual_network.main: Creation complete after 6s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/virtualNetworks/udacity-network]
azurerm_subnet.internal: Creating...
azurerm_network_security_rule.main: Creation complete after 3s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/networkSecurityGroups/udacity-NSG/securityRules/udacity-NSRule]
azurerm_lb.main: Still creating... [10s elapsed]
azurerm_subnet.internal: Creation complete after 5s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/virtualNetworks/udacity-network/subnets/internal]
azurerm_network_interface.main[0]: Creating...
azurerm_network_interface.main[1]: Creating...
azurerm_lb.main: Creation complete after 13s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/loadBalancers/udacity-lb]
azurerm_network_interface.main[1]: Still creating... [10s elapsed]
azurerm_network_interface.main[0]: Still creating... [10s elapsed]
azurerm_network_interface.main[1]: Creation complete after 14s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/networkInterfaces/udacity-nic-1]
azurerm_network_interface.main[0]: Still creating... [20s elapsed]
azurerm_network_interface.main[0]: Creation complete after 27s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/networkInterfaces/udacity-nic-0]
azurerm_linux_virtual_machine.main[0]: Creating...
azurerm_linux_virtual_machine.main[1]: Creating...
azurerm_linux_virtual_machine.main[1]: Still creating... [10s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [10s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [20s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [20s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [30s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [30s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [40s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [40s elapsed]
azurerm_linux_virtual_machine.main[0]: Creation complete after 48s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Compute/virtualMachines/udacity-vm0]
azurerm_linux_virtual_machine.main[1]: Creation complete after 49s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Compute/virtualMachines/udacity-vm1]

Apply complete! Resources: 12 added, 0 changed, 0 destroyed.
```
- DO NOT FORGET TO RUN `terraform destroy` IF YOU WANT TO DELETE YOUR RESOURCES

````
ourobadiou@MacBook-Air-de-Badiou devops-azure-project1 % terraform destroy
azurerm_resource_group.main: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources]
data.azurerm_image.main: Reading...
azurerm_public_ip.main: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/publicIPAddresses/udacity-public-ip]
azurerm_virtual_network.main: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/virtualNetworks/udacity-network]
azurerm_network_security_group.main: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/networkSecurityGroups/udacity-NSG]
azurerm_lb.main: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/loadBalancers/udacity-lb]
azurerm_managed_disk.main: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Compute/disks/acctestmd]
azurerm_subnet.internal: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/virtualNetworks/udacity-network/subnets/internal]
data.azurerm_image.main: Read complete after 0s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacityResourceGroup/providers/Microsoft.Compute/images/myPackerImage]
azurerm_network_security_rule.main: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/networkSecurityGroups/udacity-NSG/securityRules/udacity-NSRule]
azurerm_network_interface.main[1]: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/networkInterfaces/udacity-nic-1]
azurerm_network_interface.main[0]: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/networkInterfaces/udacity-nic-0]
azurerm_linux_virtual_machine.main[1]: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Compute/virtualMachines/udacity-vm1]
azurerm_linux_virtual_machine.main[0]: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Compute/virtualMachines/udacity-vm0]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # azurerm_lb.main will be destroyed
  - resource "azurerm_lb" "main" {
      - id                   = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/loadBalancers/udacity-lb" -> null
      - location             = "eastus" -> null
      - name                 = "udacity-lb" -> null
      - private_ip_addresses = [] -> null
      - resource_group_name  = "udacity-resources" -> null
      - sku                  = "Standard" -> null
      - sku_tier             = "Regional" -> null
      - tags                 = {
          - "project_name" = "udacity-project"
          - "stage"        = "Submission"
        } -> null
    }

  # azurerm_linux_virtual_machine.main[0] will be destroyed
  - resource "azurerm_linux_virtual_machine" "main" {
      - admin_password                                         = (sensitive value) -> null
      - admin_username                                         = "ourobadiou" -> null
      - allow_extension_operations                             = true -> null
      - bypass_platform_safety_checks_on_user_schedule_enabled = false -> null
      - computer_name                                          = "udacity-vm0" -> null
      - disable_password_authentication                        = false -> null
      - encryption_at_host_enabled                             = false -> null
      - extensions_time_budget                                 = "PT1H30M" -> null
      - id                                                     = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Compute/virtualMachines/udacity-vm0" -> null
      - location                                               = "eastus" -> null
      - max_bid_price                                          = -1 -> null
      - name                                                   = "udacity-vm0" -> null
      - network_interface_ids                                  = [
          - "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/networkInterfaces/udacity-nic-0",
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
      - resource_group_name                                    = "udacity-resources" -> null
      - secure_boot_enabled                                    = false -> null
      - size                                                   = "Standard_D2s_v3" -> null
      - source_image_id                                        = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacityResourceGroup/providers/Microsoft.Compute/images/myPackerImage" -> null
      - tags                                                   = {
          - "project_name" = "udacity-project"
          - "stage"        = "Submission"
        } -> null
      - virtual_machine_id                                     = "51f4aa78-c1dc-4407-b06b-391ec06e36e6" -> null
      - vm_agent_platform_updates_enabled                      = false -> null
      - vtpm_enabled                                           = false -> null

      - os_disk {
          - caching                   = "ReadWrite" -> null
          - disk_size_gb              = 30 -> null
          - name                      = "udacity-vm0_disk1_4f8685c70e12466f80841f581cf13609" -> null
          - storage_account_type      = "Standard_LRS" -> null
          - write_accelerator_enabled = false -> null
        }
    }

  # azurerm_linux_virtual_machine.main[1] will be destroyed
  - resource "azurerm_linux_virtual_machine" "main" {
      - admin_password                                         = (sensitive value) -> null
      - admin_username                                         = "ourobadiou" -> null
      - allow_extension_operations                             = true -> null
      - bypass_platform_safety_checks_on_user_schedule_enabled = false -> null
      - computer_name                                          = "udacity-vm1" -> null
      - disable_password_authentication                        = false -> null
      - encryption_at_host_enabled                             = false -> null
      - extensions_time_budget                                 = "PT1H30M" -> null
      - id                                                     = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Compute/virtualMachines/udacity-vm1" -> null
      - location                                               = "eastus" -> null
      - max_bid_price                                          = -1 -> null
      - name                                                   = "udacity-vm1" -> null
      - network_interface_ids                                  = [
          - "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/networkInterfaces/udacity-nic-1",
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
      - resource_group_name                                    = "udacity-resources" -> null
      - secure_boot_enabled                                    = false -> null
      - size                                                   = "Standard_D2s_v3" -> null
      - source_image_id                                        = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacityResourceGroup/providers/Microsoft.Compute/images/myPackerImage" -> null
      - tags                                                   = {
          - "project_name" = "udacity-project"
          - "stage"        = "Submission"
        } -> null
      - virtual_machine_id                                     = "8358e363-144e-4558-a3cf-4983c4dc3f58" -> null
      - vm_agent_platform_updates_enabled                      = false -> null
      - vtpm_enabled                                           = false -> null

      - os_disk {
          - caching                   = "ReadWrite" -> null
          - disk_size_gb              = 30 -> null
          - name                      = "udacity-vm1_disk1_9a8b9a5740c94c6f9215a7898cde5766" -> null
          - storage_account_type      = "Standard_LRS" -> null
          - write_accelerator_enabled = false -> null
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
      - id                                = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Compute/disks/acctestmd" -> null
      - location                          = "eastus" -> null
      - max_shares                        = 0 -> null
      - name                              = "acctestmd" -> null
      - on_demand_bursting_enabled        = false -> null
      - optimized_frequent_attach_enabled = false -> null
      - performance_plus_enabled          = false -> null
      - public_network_access_enabled     = true -> null
      - resource_group_name               = "udacity-resources" -> null
      - storage_account_type              = "Standard_LRS" -> null
      - tags                              = {
          - "project_name" = "udacity-project"
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
      - id                            = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/networkInterfaces/udacity-nic-0" -> null
      - internal_domain_name_suffix   = "vhokaj1cz3oehcsscn5uggjlfa.bx.internal.cloudapp.net" -> null
      - location                      = "eastus" -> null
      - mac_address                   = "00-0D-3A-8B-C2-39" -> null
      - name                          = "udacity-nic-0" -> null
      - private_ip_address            = "10.0.2.5" -> null
      - private_ip_addresses          = [
          - "10.0.2.5",
        ] -> null
      - resource_group_name           = "udacity-resources" -> null
      - tags                          = {
          - "project_name" = "udacity-project"
          - "stage"        = "Submission"
        } -> null
      - virtual_machine_id            = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Compute/virtualMachines/udacity-vm0" -> null

      - ip_configuration {
          - name                          = "internal" -> null
          - primary                       = true -> null
          - private_ip_address            = "10.0.2.5" -> null
          - private_ip_address_allocation = "Dynamic" -> null
          - private_ip_address_version    = "IPv4" -> null
          - subnet_id                     = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/virtualNetworks/udacity-network/subnets/internal" -> null
        }
    }

  # azurerm_network_interface.main[1] will be destroyed
  - resource "azurerm_network_interface" "main" {
      - applied_dns_servers           = [] -> null
      - dns_servers                   = [] -> null
      - enable_accelerated_networking = false -> null
      - enable_ip_forwarding          = false -> null
      - id                            = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/networkInterfaces/udacity-nic-1" -> null
      - internal_domain_name_suffix   = "vhokaj1cz3oehcsscn5uggjlfa.bx.internal.cloudapp.net" -> null
      - location                      = "eastus" -> null
      - mac_address                   = "00-0D-3A-99-ED-98" -> null
      - name                          = "udacity-nic-1" -> null
      - private_ip_address            = "10.0.2.4" -> null
      - private_ip_addresses          = [
          - "10.0.2.4",
        ] -> null
      - resource_group_name           = "udacity-resources" -> null
      - tags                          = {
          - "project_name" = "udacity-project"
          - "stage"        = "Submission"
        } -> null
      - virtual_machine_id            = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Compute/virtualMachines/udacity-vm1" -> null

      - ip_configuration {
          - name                          = "internal" -> null
          - primary                       = true -> null
          - private_ip_address            = "10.0.2.4" -> null
          - private_ip_address_allocation = "Dynamic" -> null
          - private_ip_address_version    = "IPv4" -> null
          - subnet_id                     = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/virtualNetworks/udacity-network/subnets/internal" -> null
        }
    }

  # azurerm_network_security_group.main will be destroyed
  - resource "azurerm_network_security_group" "main" {
      - id                  = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/networkSecurityGroups/udacity-NSG" -> null
      - location            = "eastus" -> null
      - name                = "udacity-NSG" -> null
      - resource_group_name = "udacity-resources" -> null
      - security_rule       = [
          - {
              - access                                     = "Allow"
              - description                                = ""
              - destination_address_prefix                 = "*"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "*"
              - destination_port_ranges                    = []
              - direction                                  = "Outbound"
              - name                                       = "udacity-NSRule"
              - priority                                   = 100
              - protocol                                   = "Tcp"
              - source_address_prefix                      = "*"
              - source_address_prefixes                    = []
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
            },
          - {
              - access                                     = "Deny"
              - description                                = ""
              - destination_address_prefix                 = "*"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "*"
              - destination_port_ranges                    = []
              - direction                                  = "Inbound"
              - name                                       = "Inbound-DeniedAll"
              - priority                                   = 100
              - protocol                                   = "*"
              - source_address_prefix                      = "*"
              - source_address_prefixes                    = []
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
            },
        ] -> null
      - tags                = {
          - "project_name" = "udacity-project"
          - "stage"        = "Submission"
        } -> null
    }

  # azurerm_network_security_rule.main will be destroyed
  - resource "azurerm_network_security_rule" "main" {
      - access                                     = "Allow" -> null
      - destination_address_prefix                 = "*" -> null
      - destination_address_prefixes               = [] -> null
      - destination_application_security_group_ids = [] -> null
      - destination_port_range                     = "*" -> null
      - destination_port_ranges                    = [] -> null
      - direction                                  = "Outbound" -> null
      - id                                         = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/networkSecurityGroups/udacity-NSG/securityRules/udacity-NSRule" -> null
      - name                                       = "udacity-NSRule" -> null
      - network_security_group_name                = "udacity-NSG" -> null
      - priority                                   = 100 -> null
      - protocol                                   = "Tcp" -> null
      - resource_group_name                        = "udacity-resources" -> null
      - source_address_prefix                      = "*" -> null
      - source_address_prefixes                    = [] -> null
      - source_application_security_group_ids      = [] -> null
      - source_port_range                          = "*" -> null
      - source_port_ranges                         = [] -> null
    }

  # azurerm_public_ip.main will be destroyed
  - resource "azurerm_public_ip" "main" {
      - allocation_method       = "Static" -> null
      - ddos_protection_mode    = "VirtualNetworkInherited" -> null
      - id                      = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/publicIPAddresses/udacity-public-ip" -> null
      - idle_timeout_in_minutes = 4 -> null
      - ip_address              = "172.172.228.149" -> null
      - ip_tags                 = {} -> null
      - ip_version              = "IPv4" -> null
      - location                = "eastus" -> null
      - name                    = "udacity-public-ip" -> null
      - resource_group_name     = "udacity-resources" -> null
      - sku                     = "Basic" -> null
      - sku_tier                = "Regional" -> null
      - tags                    = {
          - "project_name" = "udacity-project"
          - "stage"        = "Submission"
        } -> null
      - zones                   = [] -> null
    }

  # azurerm_resource_group.main will be destroyed
  - resource "azurerm_resource_group" "main" {
      - id       = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources" -> null
      - location = "eastus" -> null
      - name     = "udacity-resources" -> null
      - tags     = {
          - "project_name" = "udacity-project"
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
      - id                                             = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/virtualNetworks/udacity-network/subnets/internal" -> null
      - name                                           = "internal" -> null
      - private_endpoint_network_policies_enabled      = true -> null
      - private_link_service_network_policies_enabled  = true -> null
      - resource_group_name                            = "udacity-resources" -> null
      - service_endpoint_policy_ids                    = [] -> null
      - service_endpoints                              = [] -> null
      - virtual_network_name                           = "udacity-network" -> null
    }

  # azurerm_virtual_network.main will be destroyed
  - resource "azurerm_virtual_network" "main" {
      - address_space           = [
          - "10.0.0.0/16",
        ] -> null
      - dns_servers             = [] -> null
      - flow_timeout_in_minutes = 0 -> null
      - guid                    = "27a0dca9-cf62-435c-8a52-137f43192b28" -> null
      - id                      = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/virtualNetworks/udacity-network" -> null
      - location                = "eastus" -> null
      - name                    = "udacity-network" -> null
      - resource_group_name     = "udacity-resources" -> null
      - subnet                  = [
          - {
              - address_prefix = "10.0.2.0/24"
              - id             = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/virtualNetworks/udacity-network/subnets/internal"
              - name           = "internal"
              - security_group = ""
            },
        ] -> null
      - tags                    = {
          - "project_name" = "udacity-project"
          - "stage"        = "Submission"
        } -> null
    }

Plan: 0 to add, 0 to change, 12 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

azurerm_public_ip.main: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/publicIPAddresses/udacity-public-ip]
azurerm_network_security_rule.main: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/networkSecurityGroups/udacity-NSG/securityRules/udacity-NSRule]
azurerm_managed_disk.main: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Compute/disks/acctestmd]
azurerm_lb.main: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/loadBalancers/udacity-lb]
azurerm_linux_virtual_machine.main[1]: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Compute/virtualMachines/udacity-vm1]
azurerm_linux_virtual_machine.main[0]: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Compute/virtualMachines/udacity-vm0]
azurerm_lb.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...osoft.Network/loadBalancers/udacity-lb, 10s elapsed]
azurerm_linux_virtual_machine.main[0]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ft.Compute/virtualMachines/udacity-vm0, 10s elapsed]
azurerm_network_security_rule.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...acity-NSG/securityRules/udacity-NSRule, 10s elapsed]
azurerm_managed_disk.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ders/Microsoft.Compute/disks/acctestmd, 10s elapsed]
azurerm_linux_virtual_machine.main[1]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ft.Compute/virtualMachines/udacity-vm1, 10s elapsed]
azurerm_public_ip.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...rk/publicIPAddresses/udacity-public-ip, 10s elapsed]
azurerm_lb.main: Destruction complete after 11s
azurerm_network_security_rule.main: Destruction complete after 11s
azurerm_network_security_group.main: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/networkSecurityGroups/udacity-NSG]
azurerm_public_ip.main: Destruction complete after 11s
azurerm_managed_disk.main: Destruction complete after 11s
azurerm_network_security_group.main: Destruction complete after 4s
azurerm_linux_virtual_machine.main[0]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ft.Compute/virtualMachines/udacity-vm0, 20s elapsed]
azurerm_linux_virtual_machine.main[1]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ft.Compute/virtualMachines/udacity-vm1, 20s elapsed]
azurerm_linux_virtual_machine.main[0]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ft.Compute/virtualMachines/udacity-vm0, 30s elapsed]
azurerm_linux_virtual_machine.main[1]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ft.Compute/virtualMachines/udacity-vm1, 30s elapsed]
azurerm_linux_virtual_machine.main[1]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ft.Compute/virtualMachines/udacity-vm1, 40s elapsed]
azurerm_linux_virtual_machine.main[0]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ft.Compute/virtualMachines/udacity-vm0, 40s elapsed]
azurerm_linux_virtual_machine.main[0]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ft.Compute/virtualMachines/udacity-vm0, 50s elapsed]
azurerm_linux_virtual_machine.main[1]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ft.Compute/virtualMachines/udacity-vm1, 50s elapsed]
azurerm_linux_virtual_machine.main[1]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ft.Compute/virtualMachines/udacity-vm1, 1m0s elapsed]
azurerm_linux_virtual_machine.main[0]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ft.Compute/virtualMachines/udacity-vm0, 1m0s elapsed]
azurerm_linux_virtual_machine.main[0]: Destruction complete after 1m4s
azurerm_linux_virtual_machine.main[1]: Destruction complete after 1m4s
azurerm_network_interface.main[1]: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/networkInterfaces/udacity-nic-1]
azurerm_network_interface.main[0]: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/networkInterfaces/udacity-nic-0]
azurerm_network_interface.main[0]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...etwork/networkInterfaces/udacity-nic-0, 10s elapsed]
azurerm_network_interface.main[1]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...etwork/networkInterfaces/udacity-nic-1, 10s elapsed]
azurerm_network_interface.main[0]: Destruction complete after 12s
azurerm_network_interface.main[1]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...etwork/networkInterfaces/udacity-nic-1, 20s elapsed]
azurerm_network_interface.main[1]: Destruction complete after 23s
azurerm_subnet.internal: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/virtualNetworks/udacity-network/subnets/internal]
azurerm_subnet.internal: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...works/udacity-network/subnets/internal, 10s elapsed]
azurerm_subnet.internal: Destruction complete after 11s
azurerm_virtual_network.main: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources/providers/Microsoft.Network/virtualNetworks/udacity-network]
azurerm_virtual_network.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...etwork/virtualNetworks/udacity-network, 10s elapsed]
azurerm_virtual_network.main: Destruction complete after 11s
azurerm_resource_group.main: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacity-resources]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...053d2/resourceGroups/udacity-resources, 10s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...053d2/resourceGroups/udacity-resources, 20s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...053d2/resourceGroups/udacity-resources, 30s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...053d2/resourceGroups/udacity-resources, 40s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...053d2/resourceGroups/udacity-resources, 50s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...053d2/resourceGroups/udacity-resources, 1m0s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...053d2/resourceGroups/udacity-resources, 1m10s elapsed]
azurerm_resource_group.main: Destruction complete after 1m19s

Destroy complete! Resources: 12 destroyed.
```