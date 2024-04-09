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

2. Use the command `az group list -o table` to ensure that your group is created successfully.

3. Create a role with the following command, replacing `<subsription_id>` with yours:
   ```
   az ad sp create-for-rbac --name "udacity-project-1" --role Contributor --scopes /subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2 --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"
   ```

4. This command will output a JSON in the following format:
   ```
   {
  "client_id": "xxxxxx-xxxx-xxxx-dddd-xxxxxxxxxx",
  "client_secret": "xxxxx~xxxx.-.xxxxxxxxxxx",
  "tenant_id": "xxxxxxxxxxxxxx"
  }
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
   az policy assignment create --name tagging-policy-assignment --scope "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/udacityResourceGroup" --policy tagging-policy
   ```

7. Execute the command `packer build server.json` to create an image. You can verify from your Azure console that the image has been successfully created.

8. Execute the command `terraform init` to initialize Terraform within your directory.

9. Run `terraform plan -out solution.plan` to generate a Terraform execution plan to update your infrastructure based on changes made to your configuration files, and save this plan to a file named solution.plan. This plan can then be reviewed before being applied to the actual infrastructure using the command `terraform apply`.

10. Execute the command `terraform apply "solution.plan"` to apply the plan to your Azure infrastructure.

11. To delete all the resources you have deployed, you can issue the command `terraform destroy`.

## Output
12. Below, you will find the list of results obtained after executing certain commands:


- Result of the command `az group create -n udacityResourceGroup -l eastus`
```
ourobadiou@MacBook-Air-de-Badiou deploy-azure-infrastructure-udacity-project-1 %  az group create -n udacityResourceGroup -l eastus
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
ourobadiou@MacBook-Air-de-Badiou deploy-azure-infrastructure-udacity-project-1 % packer build server.json                                         
azure-arm: output will be in this color.

==> azure-arm: Running builder ...
    azure-arm: Creating Azure Resource Manager (ARM) client ...
==> azure-arm: Getting source image id for the deployment ...
==> azure-arm:  -> SourceImageName: '/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/providers/Microsoft.Compute/locations/East US/publishers/canonical/ArtifactTypes/vmimage/offers/UbuntuServer/skus/18.04-LTS/versions/latest'
==> azure-arm: Creating resource group ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-zlx6c2jfio'
==> azure-arm:  -> Location          : 'East US'
==> azure-arm:  -> Tags              :
==> azure-arm:  ->> project_name : udacity-project-1
==> azure-arm:  ->> stage : Submission
==> azure-arm: Validating deployment template ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-zlx6c2jfio'
==> azure-arm:  -> DeploymentName    : 'pkrdpzlx6c2jfio'
==> azure-arm: Deploying deployment template ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-zlx6c2jfio'
==> azure-arm:  -> DeploymentName    : 'pkrdpzlx6c2jfio'
==> azure-arm: Getting the VM's IP address ...
==> azure-arm:  -> ResourceGroupName   : 'pkr-Resource-Group-zlx6c2jfio'
==> azure-arm:  -> PublicIPAddressName : 'pkripzlx6c2jfio'
==> azure-arm:  -> NicName             : 'pkrnizlx6c2jfio'
==> azure-arm:  -> Network Connection  : 'PublicEndpoint'
==> azure-arm:  -> IP Address          : '52.224.218.63'
==> azure-arm: Waiting for SSH to become available...
==> azure-arm: Connected to SSH!
==> azure-arm: Provisioning with shell script: /var/folders/y2/5f0v9c8s4cd38dr623w38k_r0000gn/T/packer-shell3671159541
==> azure-arm: + echo Hello, World!
==> azure-arm: Querying the machine's properties ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-zlx6c2jfio'
==> azure-arm:  -> ComputeName       : 'pkrvmzlx6c2jfio'
==> azure-arm:  -> Managed OS Disk   : '/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/pkr-Resource-Group-zlx6c2jfio/providers/Microsoft.Compute/disks/pkroszlx6c2jfio'
==> azure-arm: Querying the machine's additional disks properties ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-zlx6c2jfio'
==> azure-arm:  -> ComputeName       : 'pkrvmzlx6c2jfio'
==> azure-arm: Powering off machine ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-zlx6c2jfio'
==> azure-arm:  -> ComputeName       : 'pkrvmzlx6c2jfio'
==> azure-arm:  -> Compute ResourceGroupName : 'pkr-Resource-Group-zlx6c2jfio'
==> azure-arm:  -> Compute Name              : 'pkrvmzlx6c2jfio'
==> azure-arm:  -> Compute Location          : 'East US'
==> azure-arm: Generalizing machine ...
==> azure-arm: Capturing image ...
==> azure-arm:  -> Image ResourceGroupName   : 'udacityResourceGroup'
==> azure-arm:  -> Image Name                : 'myPackerImage'
==> azure-arm:  -> Image Location            : 'East US'
==> azure-arm: 
==> azure-arm: Deleting Virtual Machine deployment and its attached resources...
==> azure-arm: Adding to deletion queue -> Microsoft.Compute/virtualMachines : 'pkrvmzlx6c2jfio'
==> azure-arm: Adding to deletion queue -> Microsoft.Network/networkInterfaces : 'pkrnizlx6c2jfio'
==> azure-arm: Adding to deletion queue -> Microsoft.Network/virtualNetworks : 'pkrvnzlx6c2jfio'
==> azure-arm: Adding to deletion queue -> Microsoft.Network/publicIPAddresses : 'pkripzlx6c2jfio'
==> azure-arm: Waiting for deletion of all resources...
==> azure-arm: Attempting deletion -> Microsoft.Network/publicIPAddresses : 'pkripzlx6c2jfio'
==> azure-arm: Attempting deletion -> Microsoft.Network/networkInterfaces : 'pkrnizlx6c2jfio'
==> azure-arm: Attempting deletion -> Microsoft.Network/virtualNetworks : 'pkrvnzlx6c2jfio'
==> azure-arm: Attempting deletion -> Microsoft.Compute/virtualMachines : 'pkrvmzlx6c2jfio'
==> azure-arm: Couldn't delete Microsoft.Network/virtualNetworks resource. Will retry.
==> azure-arm: Name: pkrvnzlx6c2jfio
==> azure-arm: Couldn't delete Microsoft.Network/publicIPAddresses resource. Will retry.
==> azure-arm: Name: pkripzlx6c2jfio
==> azure-arm: Attempting deletion -> Microsoft.Network/virtualNetworks : 'pkrvnzlx6c2jfio'
==> azure-arm: Attempting deletion -> Microsoft.Network/publicIPAddresses : 'pkripzlx6c2jfio'
==> azure-arm:  Deleting -> Microsoft.Compute/disks : '/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/pkr-Resource-Group-zlx6c2jfio/providers/Microsoft.Compute/disks/pkroszlx6c2jfio'
==> azure-arm: Removing the created Deployment object: 'pkrdpzlx6c2jfio'
==> azure-arm: 
==> azure-arm: Cleanup requested, deleting resource group ...
==> azure-arm: Resource group has been deleted.
Build 'azure-arm' finished after 3 minutes 51 seconds.

==> Wait completed after 3 minutes 51 seconds

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
ourobadiou@MacBook-Air-de-Badiou deploy-azure-infrastructure-udacity-project-1 % terraform plan -out solution.plan
var.admin_password
  The password for the VM being created.

  Enter a value: xxxxxxxx

var.admin_username
  The admin username for the VM being created.

  Enter a value: xxxxxxxx

var.counter
  The number of virtual machines you want to create..

  Enter a value: 2

var.prefix
  The prefix which should be used for all resources in this example

  Enter a value: udacity-project-1


Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_lb.main will be created
  + resource "azurerm_lb" "main" {
      + id                   = (known after apply)
      + location             = "eastus"
      + name                 = "udacity-project-1-lb"
      + private_ip_address   = (known after apply)
      + private_ip_addresses = (known after apply)
      + resource_group_name  = "udacity-project-1-resources"
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
      + name                                                   = "udacity-project-1-vm0"
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
      + resource_group_name                                    = "udacity-project-1-resources"
      + size                                                   = "Standard_D2s_v3"
      + tags                                                   = {
          + "project_name" = "udacity-project-1"
          + "tage"         = "Submission"
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
      + name                                                   = "udacity-project-1-vm1"
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
      + resource_group_name                                    = "udacity-project-1-resources"
      + size                                                   = "Standard_D2s_v3"
      + tags                                                   = {
          + "project_name" = "udacity-project-1"
          + "tage"         = "Submission"
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
      + resource_group_name               = "udacity-project-1-resources"
      + source_uri                        = (known after apply)
      + storage_account_type              = "Standard_LRS"
      + tags                              = {
          + "project_name" = "udacity-project-1"
          + "stage"        = "Submission"
        }
      + tier                              = (known after apply)
    }

  # azurerm_network_interface.main will be created
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
      + name                          = "udacity-project-1-nic"
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "udacity-project-1-resources"
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
      + name                    = "udacity-project-1-public-ip"
      + resource_group_name     = "udacity-project-1-resources"
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
      + name     = "udacity-project-1-resources"
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
      + resource_group_name                            = "udacity-project-1-resources"
      + virtual_network_name                           = "udacity-project-1-network"
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
      + name                = "udacity-project-1-network"
      + resource_group_name = "udacity-project-1-resources"
      + subnet              = (known after apply)
      + tags                = {
          + "project_name" = "udacity-project-1"
          + "stage"        = "Submission"
        }
    }

Plan: 9 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: solution.plan

To perform exactly these actions, run the following command to apply:
    terraform apply "solution.plan"
```

- DO NOT FORGET TO RUN `terraform destroy` IF YOU WANT TO DELETE YOUR RESOURCES
```

```