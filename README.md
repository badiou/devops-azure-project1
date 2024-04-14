# Azure Infrastructure Operations Project: Deploying a Scalable IaaS Web Server in Azure

## Introduction
For this project, you will create a Packer template and a Terraform template to automate the deployment of a flexible and scalable web server infrastructure on Azure. The goal is to streamline the process of provisioning and configuring virtual machines, allowing for easy customization and efficient scaling of resources as needed."

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
   `az group create -n udacityResourceGroup -l eastus`
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
5. Le déploiement de votre infrastructure sur Azure se fait à travers le fichier main.tf. Ce fichier est associé à vars.tf qui contient toutes les variables utilisées pour le déploiement. Vous pouvez spécifier les parametres souhaitées. Par exemple si vous souhaite

6. Run 
```terraform apply \
    -var="prefix=my_prefix" \  # Replace "my_prefix" with your custom prefix, or use the default value "udacity"
    -var="location=East US" \   # Replace "East US" with your custom Azure region, or use the default value
    -var="admin_username=my_username" \  # Replace "my_username" with your custom admin username, or use the default value "ourobadiou"
    -var="admin_password=my_passwordSecret" \  # Replace "my_passwordSecret" with your custom password, or use the default value "B@diou2023"
    -var="counter=2" "solution.plan"  # Specify the number of virtual machines to create (in this example, 2)
```

    to generate a Terraform execution plan to update your infrastructure based on changes made to your configuration files, and save this plan to a file named solution.plan. This plan can then be reviewed before being applied to the actual infrastructure using the command `terraform apply`. If you wish to use the default parameters, you can omit specifying any of the variables.
  If you wish to use the default values for the variables, you can simply modify the default values in the vars.tf file
`terraform apply "solution.plan"`



7.  Execute the command `terraform apply "solution.plan"` to apply the plan to your Azure infrastructure.

8.  To delete all the resources you have deployed, you can issue the command `terraform destroy`.

## Output
9. Below, you will find the list of results obtained after executing certain commands:


10. Result of the command `az group create -n udacityResourceGroup -l eastus`
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
10. result of the command 
`az policy definition create --name tagging-policy --rules tagging_policy.json`
```
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


- Result of the command `packer build server.json` 
  
```
ourobadiou@MacBook-Air-de-Badiou devops-azure-project1 % packer build server.json                                                  
azure-arm: output will be in this color.

==> azure-arm: Running builder ...
    azure-arm: Creating Azure Resource Manager (ARM) client ...
==> azure-arm: Getting source image id for the deployment ...
==> azure-arm:  -> SourceImageName: '/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/providers/Microsoft.Compute/locations/East US/publishers/canonical/ArtifactTypes/vmimage/offers/UbuntuServer/skus/18.04-LTS/versions/latest'
==> azure-arm: Creating resource group ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-pnhkqb2mqp'
==> azure-arm:  -> Location          : 'East US'
==> azure-arm:  -> Tags              :
==> azure-arm:  ->> project_name : udacity-project
==> azure-arm:  ->> stage : Submission
==> azure-arm: Validating deployment template ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-pnhkqb2mqp'
==> azure-arm:  -> DeploymentName    : 'pkrdppnhkqb2mqp'
==> azure-arm: Deploying deployment template ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-pnhkqb2mqp'
==> azure-arm:  -> DeploymentName    : 'pkrdppnhkqb2mqp'
==> azure-arm: Getting the VM's IP address ...
==> azure-arm:  -> ResourceGroupName   : 'pkr-Resource-Group-pnhkqb2mqp'
==> azure-arm:  -> PublicIPAddressName : 'pkrippnhkqb2mqp'
==> azure-arm:  -> NicName             : 'pkrnipnhkqb2mqp'
==> azure-arm:  -> Network Connection  : 'PublicEndpoint'
==> azure-arm:  -> IP Address          : '13.92.127.234'
==> azure-arm: Waiting for SSH to become available...
==> azure-arm: Connected to SSH!
==> azure-arm: Provisioning with shell script: /var/folders/y2/5f0v9c8s4cd38dr623w38k_r0000gn/T/packer-shell934076252
==> azure-arm: + echo Hello, World!
==> azure-arm: Querying the machine's properties ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-pnhkqb2mqp'
==> azure-arm:  -> ComputeName       : 'pkrvmpnhkqb2mqp'
==> azure-arm:  -> Managed OS Disk   : '/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/pkr-Resource-Group-pnhkqb2mqp/providers/Microsoft.Compute/disks/pkrospnhkqb2mqp'
==> azure-arm: Querying the machine's additional disks properties ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-pnhkqb2mqp'
==> azure-arm:  -> ComputeName       : 'pkrvmpnhkqb2mqp'
==> azure-arm: Powering off machine ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-pnhkqb2mqp'
==> azure-arm:  -> ComputeName       : 'pkrvmpnhkqb2mqp'
==> azure-arm:  -> Compute ResourceGroupName : 'pkr-Resource-Group-pnhkqb2mqp'
==> azure-arm:  -> Compute Name              : 'pkrvmpnhkqb2mqp'
==> azure-arm:  -> Compute Location          : 'East US'
==> azure-arm: Generalizing machine ...
==> azure-arm: Capturing image ...
==> azure-arm:  -> Image ResourceGroupName   : 'udacityResourceGroup'
==> azure-arm:  -> Image Name                : 'myPackerImage'
==> azure-arm:  -> Image Location            : 'East US'
==> azure-arm: 
==> azure-arm: Deleting Virtual Machine deployment and its attached resources...
==> azure-arm: Adding to deletion queue -> Microsoft.Compute/virtualMachines : 'pkrvmpnhkqb2mqp'
==> azure-arm: Adding to deletion queue -> Microsoft.Network/networkInterfaces : 'pkrnipnhkqb2mqp'
==> azure-arm: Adding to deletion queue -> Microsoft.Network/virtualNetworks : 'pkrvnpnhkqb2mqp'
==> azure-arm: Adding to deletion queue -> Microsoft.Network/publicIPAddresses : 'pkrippnhkqb2mqp'
==> azure-arm: Waiting for deletion of all resources...
==> azure-arm: Attempting deletion -> Microsoft.Compute/virtualMachines : 'pkrvmpnhkqb2mqp'
==> azure-arm: Attempting deletion -> Microsoft.Network/virtualNetworks : 'pkrvnpnhkqb2mqp'
==> azure-arm: Attempting deletion -> Microsoft.Network/networkInterfaces : 'pkrnipnhkqb2mqp'
==> azure-arm: Attempting deletion -> Microsoft.Network/publicIPAddresses : 'pkrippnhkqb2mqp'
==> azure-arm: Couldn't delete Microsoft.Network/publicIPAddresses resource. Will retry.
==> azure-arm: Name: pkrippnhkqb2mqp
==> azure-arm: Couldn't delete Microsoft.Network/virtualNetworks resource. Will retry.
==> azure-arm: Name: pkrvnpnhkqb2mqp
==> azure-arm: Attempting deletion -> Microsoft.Network/publicIPAddresses : 'pkrippnhkqb2mqp'
==> azure-arm: Attempting deletion -> Microsoft.Network/virtualNetworks : 'pkrvnpnhkqb2mqp'
==> azure-arm: Couldn't delete Microsoft.Network/virtualNetworks resource. Will retry.
==> azure-arm: Name: pkrvnpnhkqb2mqp
==> azure-arm: Couldn't delete Microsoft.Network/publicIPAddresses resource. Will retry.
==> azure-arm: Name: pkrippnhkqb2mqp
==> azure-arm: Attempting deletion -> Microsoft.Network/publicIPAddresses : 'pkrippnhkqb2mqp'
==> azure-arm: Attempting deletion -> Microsoft.Network/virtualNetworks : 'pkrvnpnhkqb2mqp'
==> azure-arm:  Deleting -> Microsoft.Compute/disks : '/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/pkr-Resource-Group-pnhkqb2mqp/providers/Microsoft.Compute/disks/pkrospnhkqb2mqp'
==> azure-arm: Removing the created Deployment object: 'pkrdppnhkqb2mqp'
==> azure-arm: 
==> azure-arm: Cleanup requested, deleting resource group ...
==> azure-arm: Resource group has been deleted.
Build 'azure-arm' finished after 4 minutes 27 seconds.

==> Wait completed after 4 minutes 27 seconds

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

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_lb.main will be created
  + resource "azurerm_lb" "main" {
      + id                   = (known after apply)
      + location             = "eastus"
      + name                 = "default-prefix-lb"
      + private_ip_address   = (known after apply)
      + private_ip_addresses = (known after apply)
      + resource_group_name  = "default-prefix-resources"
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
      + name                                                   = "default-prefix-vm0"
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
      + resource_group_name                                    = "default-prefix-resources"
      + size                                                   = "Standard_D2s_v3"
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
      + name                                                   = "default-prefix-vm1"
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
      + resource_group_name                                    = "default-prefix-resources"
      + size                                                   = "Standard_D2s_v3"
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
      + resource_group_name               = "default-prefix-resources"
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
      + name                          = "default-prefix-nic-0"
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "default-prefix-resources"
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
      + name                          = "default-prefix-nic-1"
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "default-prefix-resources"
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
      + name                = "acceptanceTestSecurityGroup1"
      + resource_group_name = "default-prefix-resources"
      + security_rule       = (known after apply)
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
      + name                        = "test123"
      + network_security_group_name = "acceptanceTestSecurityGroup1"
      + priority                    = 100
      + protocol                    = "Tcp"
      + resource_group_name         = "default-prefix-resources"
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
      + name                    = "default-prefix-public-ip"
      + resource_group_name     = "default-prefix-resources"
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
      + name     = "default-prefix-resources"
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
      + resource_group_name                            = "default-prefix-resources"
      + virtual_network_name                           = "default-prefix-network"
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
      + name                = "default-prefix-network"
      + resource_group_name = "default-prefix-resources"
      + subnet              = (known after apply)
      + tags                = {
          + "project_name" = "udacity-project"
          + "stage"        = "Submission"
        }
    }

Plan: 12 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: solution.plan

To perform exactly these actions, run the following command to apply:
    terraform apply "solution.plan"
```

- Result of command ` terraform apply "solution.plan" `
```
ourobadiou@MacBook-Air-de-Badiou devops-azure-project1 % terraform apply "solution.plan"
azurerm_resource_group.main: Creating...
azurerm_resource_group.main: Creation complete after 2s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources]
azurerm_network_security_group.main: Creating...
azurerm_virtual_network.main: Creating...
azurerm_public_ip.main: Creating...
azurerm_lb.main: Creating...
azurerm_managed_disk.main: Creating...
azurerm_network_security_group.main: Creation complete after 3s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/networkSecurityGroups/acceptanceTestSecurityGroup1]
azurerm_network_security_rule.main: Creating...
azurerm_public_ip.main: Creation complete after 3s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/publicIPAddresses/default-prefix-public-ip]
azurerm_managed_disk.main: Creation complete after 4s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Compute/disks/acctestmd]
azurerm_virtual_network.main: Creation complete after 6s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/virtualNetworks/default-prefix-network]
azurerm_subnet.internal: Creating...
azurerm_network_security_rule.main: Creation complete after 3s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/networkSecurityGroups/acceptanceTestSecurityGroup1/securityRules/test123]
azurerm_lb.main: Still creating... [10s elapsed]
azurerm_subnet.internal: Creation complete after 5s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/virtualNetworks/default-prefix-network/subnets/internal]
azurerm_network_interface.main[1]: Creating...
azurerm_network_interface.main[0]: Creating...
azurerm_lb.main: Creation complete after 12s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/loadBalancers/default-prefix-lb]
azurerm_network_interface.main[1]: Still creating... [10s elapsed]
azurerm_network_interface.main[0]: Still creating... [10s elapsed]
azurerm_network_interface.main[0]: Creation complete after 13s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/networkInterfaces/default-prefix-nic-0]
azurerm_network_interface.main[1]: Still creating... [20s elapsed]
azurerm_network_interface.main[1]: Creation complete after 26s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/networkInterfaces/default-prefix-nic-1]
azurerm_linux_virtual_machine.main[0]: Creating...
azurerm_linux_virtual_machine.main[1]: Creating...
azurerm_linux_virtual_machine.main[0]: Still creating... [10s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [10s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [20s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [20s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [30s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [30s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [40s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [40s elapsed]
azurerm_linux_virtual_machine.main[1]: Creation complete after 50s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Compute/virtualMachines/default-prefix-vm1]
azurerm_linux_virtual_machine.main[0]: Still creating... [50s elapsed]
azurerm_linux_virtual_machine.main[0]: Creation complete after 50s [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Compute/virtualMachines/default-prefix-vm0]

Apply complete! Resources: 12 added, 0 changed, 0 destroyed.
```

- DO NOT FORGET TO RUN `terraform destroy` IF YOU WANT TO DELETE YOUR RESOURCES
```
ourobadiou@MacBook-Air-de-Badiou devops-azure-project1 % terraform destroy
azurerm_resource_group.main: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources]
azurerm_lb.main: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/loadBalancers/default-prefix-lb]
azurerm_network_security_group.main: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/networkSecurityGroups/acceptanceTestSecurityGroup1]
azurerm_public_ip.main: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/publicIPAddresses/default-prefix-public-ip]
azurerm_virtual_network.main: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/virtualNetworks/default-prefix-network]
azurerm_managed_disk.main: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Compute/disks/acctestmd]
azurerm_subnet.internal: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/virtualNetworks/default-prefix-network/subnets/internal]
azurerm_network_security_rule.main: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/networkSecurityGroups/acceptanceTestSecurityGroup1/securityRules/test123]
azurerm_network_interface.main[0]: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/networkInterfaces/default-prefix-nic-0]
azurerm_network_interface.main[1]: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/networkInterfaces/default-prefix-nic-1]
azurerm_linux_virtual_machine.main[1]: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Compute/virtualMachines/default-prefix-vm1]
azurerm_linux_virtual_machine.main[0]: Refreshing state... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Compute/virtualMachines/default-prefix-vm0]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # azurerm_lb.main will be destroyed
  - resource "azurerm_lb" "main" {
      - id                   = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/loadBalancers/default-prefix-lb" -> null
      - location             = "eastus" -> null
      - name                 = "default-prefix-lb" -> null
      - private_ip_addresses = [] -> null
      - resource_group_name  = "default-prefix-resources" -> null
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
      - computer_name                                          = "default-prefix-vm0" -> null
      - disable_password_authentication                        = false -> null
      - encryption_at_host_enabled                             = false -> null
      - extensions_time_budget                                 = "PT1H30M" -> null
      - id                                                     = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Compute/virtualMachines/default-prefix-vm0" -> null
      - location                                               = "eastus" -> null
      - max_bid_price                                          = -1 -> null
      - name                                                   = "default-prefix-vm0" -> null
      - network_interface_ids                                  = [
          - "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/networkInterfaces/default-prefix-nic-0",
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
      - resource_group_name                                    = "default-prefix-resources" -> null
      - secure_boot_enabled                                    = false -> null
      - size                                                   = "Standard_D2s_v3" -> null
      - tags                                                   = {
          - "project_name" = "udacity-project"
          - "stage"        = "Submission"
        } -> null
      - virtual_machine_id                                     = "e5d41a27-3b08-4130-8dfb-53d8ba6422b9" -> null
      - vm_agent_platform_updates_enabled                      = false -> null
      - vtpm_enabled                                           = false -> null

      - os_disk {
          - caching                   = "ReadWrite" -> null
          - disk_size_gb              = 30 -> null
          - name                      = "default-prefix-vm0_OsDisk_1_5af6b8087dd5489e8840b3f8cad7031a" -> null
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
      - computer_name                                          = "default-prefix-vm1" -> null
      - disable_password_authentication                        = false -> null
      - encryption_at_host_enabled                             = false -> null
      - extensions_time_budget                                 = "PT1H30M" -> null
      - id                                                     = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Compute/virtualMachines/default-prefix-vm1" -> null
      - location                                               = "eastus" -> null
      - max_bid_price                                          = -1 -> null
      - name                                                   = "default-prefix-vm1" -> null
      - network_interface_ids                                  = [
          - "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/networkInterfaces/default-prefix-nic-1",
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
      - resource_group_name                                    = "default-prefix-resources" -> null
      - secure_boot_enabled                                    = false -> null
      - size                                                   = "Standard_D2s_v3" -> null
      - tags                                                   = {
          - "project_name" = "udacity-project"
          - "stage"        = "Submission"
        } -> null
      - virtual_machine_id                                     = "9dc2a016-8d53-4f65-961d-6f4cfe1b168d" -> null
      - vm_agent_platform_updates_enabled                      = false -> null
      - vtpm_enabled                                           = false -> null

      - os_disk {
          - caching                   = "ReadWrite" -> null
          - disk_size_gb              = 30 -> null
          - name                      = "default-prefix-vm1_OsDisk_1_420e7f073b7844a19cc266aada50aa43" -> null
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
      - id                                = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Compute/disks/acctestmd" -> null
      - location                          = "eastus" -> null
      - max_shares                        = 0 -> null
      - name                              = "acctestmd" -> null
      - on_demand_bursting_enabled        = false -> null
      - optimized_frequent_attach_enabled = false -> null
      - performance_plus_enabled          = false -> null
      - public_network_access_enabled     = true -> null
      - resource_group_name               = "default-prefix-resources" -> null
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
      - id                            = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/networkInterfaces/default-prefix-nic-0" -> null
      - internal_domain_name_suffix   = "tkf2rsctsgdebpid1nvjipspxc.bx.internal.cloudapp.net" -> null
      - location                      = "eastus" -> null
      - mac_address                   = "00-22-48-1D-03-B1" -> null
      - name                          = "default-prefix-nic-0" -> null
      - private_ip_address            = "10.0.2.4" -> null
      - private_ip_addresses          = [
          - "10.0.2.4",
        ] -> null
      - resource_group_name           = "default-prefix-resources" -> null
      - tags                          = {
          - "project_name" = "udacity-project"
          - "stage"        = "Submission"
        } -> null
      - virtual_machine_id            = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Compute/virtualMachines/default-prefix-vm0" -> null

      - ip_configuration {
          - name                          = "internal" -> null
          - primary                       = true -> null
          - private_ip_address            = "10.0.2.4" -> null
          - private_ip_address_allocation = "Dynamic" -> null
          - private_ip_address_version    = "IPv4" -> null
          - subnet_id                     = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/virtualNetworks/default-prefix-network/subnets/internal" -> null
        }
    }

  # azurerm_network_interface.main[1] will be destroyed
  - resource "azurerm_network_interface" "main" {
      - applied_dns_servers           = [] -> null
      - dns_servers                   = [] -> null
      - enable_accelerated_networking = false -> null
      - enable_ip_forwarding          = false -> null
      - id                            = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/networkInterfaces/default-prefix-nic-1" -> null
      - internal_domain_name_suffix   = "tkf2rsctsgdebpid1nvjipspxc.bx.internal.cloudapp.net" -> null
      - location                      = "eastus" -> null
      - mac_address                   = "00-0D-3A-9C-43-9B" -> null
      - name                          = "default-prefix-nic-1" -> null
      - private_ip_address            = "10.0.2.5" -> null
      - private_ip_addresses          = [
          - "10.0.2.5",
        ] -> null
      - resource_group_name           = "default-prefix-resources" -> null
      - tags                          = {
          - "project_name" = "udacity-project"
          - "stage"        = "Submission"
        } -> null
      - virtual_machine_id            = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Compute/virtualMachines/default-prefix-vm1" -> null

      - ip_configuration {
          - name                          = "internal" -> null
          - primary                       = true -> null
          - private_ip_address            = "10.0.2.5" -> null
          - private_ip_address_allocation = "Dynamic" -> null
          - private_ip_address_version    = "IPv4" -> null
          - subnet_id                     = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/virtualNetworks/default-prefix-network/subnets/internal" -> null
        }
    }

  # azurerm_network_security_group.main will be destroyed
  - resource "azurerm_network_security_group" "main" {
      - id                  = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/networkSecurityGroups/acceptanceTestSecurityGroup1" -> null
      - location            = "eastus" -> null
      - name                = "acceptanceTestSecurityGroup1" -> null
      - resource_group_name = "default-prefix-resources" -> null
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
              - name                                       = "test123"
              - priority                                   = 100
              - protocol                                   = "Tcp"
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
      - id                                         = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/networkSecurityGroups/acceptanceTestSecurityGroup1/securityRules/test123" -> null
      - name                                       = "test123" -> null
      - network_security_group_name                = "acceptanceTestSecurityGroup1" -> null
      - priority                                   = 100 -> null
      - protocol                                   = "Tcp" -> null
      - resource_group_name                        = "default-prefix-resources" -> null
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
      - id                      = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/publicIPAddresses/default-prefix-public-ip" -> null
      - idle_timeout_in_minutes = 4 -> null
      - ip_address              = "40.71.80.97" -> null
      - ip_tags                 = {} -> null
      - ip_version              = "IPv4" -> null
      - location                = "eastus" -> null
      - name                    = "default-prefix-public-ip" -> null
      - resource_group_name     = "default-prefix-resources" -> null
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
      - id       = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources" -> null
      - location = "eastus" -> null
      - name     = "default-prefix-resources" -> null
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
      - id                                             = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/virtualNetworks/default-prefix-network/subnets/internal" -> null
      - name                                           = "internal" -> null
      - private_endpoint_network_policies_enabled      = true -> null
      - private_link_service_network_policies_enabled  = true -> null
      - resource_group_name                            = "default-prefix-resources" -> null
      - service_endpoint_policy_ids                    = [] -> null
      - service_endpoints                              = [] -> null
      - virtual_network_name                           = "default-prefix-network" -> null
    }

  # azurerm_virtual_network.main will be destroyed
  - resource "azurerm_virtual_network" "main" {
      - address_space           = [
          - "10.0.0.0/16",
        ] -> null
      - dns_servers             = [] -> null
      - flow_timeout_in_minutes = 0 -> null
      - guid                    = "c8c88b9a-9153-4086-bd03-db6a943e4fba" -> null
      - id                      = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/virtualNetworks/default-prefix-network" -> null
      - location                = "eastus" -> null
      - name                    = "default-prefix-network" -> null
      - resource_group_name     = "default-prefix-resources" -> null
      - subnet                  = [
          - {
              - address_prefix = "10.0.2.0/24"
              - id             = "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/virtualNetworks/default-prefix-network/subnets/internal"
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

azurerm_public_ip.main: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/publicIPAddresses/default-prefix-public-ip]
azurerm_network_security_rule.main: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/networkSecurityGroups/acceptanceTestSecurityGroup1/securityRules/test123]
azurerm_lb.main: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/loadBalancers/default-prefix-lb]
azurerm_linux_virtual_machine.main[1]: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Compute/virtualMachines/default-prefix-vm1]
azurerm_linux_virtual_machine.main[0]: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Compute/virtualMachines/default-prefix-vm0]
azurerm_managed_disk.main: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Compute/disks/acctestmd]
azurerm_public_ip.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...icIPAddresses/default-prefix-public-ip, 10s elapsed]
azurerm_managed_disk.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ders/Microsoft.Compute/disks/acctestmd, 10s elapsed]
azurerm_linux_virtual_machine.main[0]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ute/virtualMachines/default-prefix-vm0, 10s elapsed]
azurerm_linux_virtual_machine.main[1]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ute/virtualMachines/default-prefix-vm1, 10s elapsed]
azurerm_network_security_rule.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...stSecurityGroup1/securityRules/test123, 10s elapsed]
azurerm_lb.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...etwork/loadBalancers/default-prefix-lb, 10s elapsed]
azurerm_lb.main: Destruction complete after 11s
azurerm_network_security_rule.main: Destruction complete after 11s
azurerm_network_security_group.main: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/networkSecurityGroups/acceptanceTestSecurityGroup1]
azurerm_public_ip.main: Destruction complete after 11s
azurerm_managed_disk.main: Destruction complete after 11s
azurerm_network_security_group.main: Destruction complete after 2s
azurerm_linux_virtual_machine.main[0]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ute/virtualMachines/default-prefix-vm0, 20s elapsed]
azurerm_linux_virtual_machine.main[1]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ute/virtualMachines/default-prefix-vm1, 20s elapsed]
azurerm_linux_virtual_machine.main[1]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ute/virtualMachines/default-prefix-vm1, 30s elapsed]
azurerm_linux_virtual_machine.main[0]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ute/virtualMachines/default-prefix-vm0, 30s elapsed]
azurerm_linux_virtual_machine.main[1]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ute/virtualMachines/default-prefix-vm1, 40s elapsed]
azurerm_linux_virtual_machine.main[0]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ute/virtualMachines/default-prefix-vm0, 40s elapsed]
azurerm_linux_virtual_machine.main[0]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ute/virtualMachines/default-prefix-vm0, 50s elapsed]
azurerm_linux_virtual_machine.main[1]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ute/virtualMachines/default-prefix-vm1, 50s elapsed]
azurerm_linux_virtual_machine.main[1]: Destruction complete after 59s
azurerm_linux_virtual_machine.main[0]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...ute/virtualMachines/default-prefix-vm0, 1m0s elapsed]
azurerm_linux_virtual_machine.main[0]: Destruction complete after 1m4s
azurerm_network_interface.main[1]: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/networkInterfaces/default-prefix-nic-1]
azurerm_network_interface.main[0]: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/networkInterfaces/default-prefix-nic-0]
azurerm_network_interface.main[0]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...networkInterfaces/default-prefix-nic-0, 10s elapsed]
azurerm_network_interface.main[1]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...networkInterfaces/default-prefix-nic-1, 10s elapsed]
azurerm_network_interface.main[0]: Destruction complete after 11s
azurerm_network_interface.main[1]: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...networkInterfaces/default-prefix-nic-1, 20s elapsed]
azurerm_network_interface.main[1]: Destruction complete after 22s
azurerm_subnet.internal: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/virtualNetworks/default-prefix-network/subnets/internal]
azurerm_subnet.internal: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...efault-prefix-network/subnets/internal, 10s elapsed]
azurerm_subnet.internal: Destruction complete after 11s
azurerm_virtual_network.main: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources/providers/Microsoft.Network/virtualNetworks/default-prefix-network]
azurerm_virtual_network.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...virtualNetworks/default-prefix-network, 10s elapsed]
azurerm_virtual_network.main: Destruction complete after 11s
azurerm_resource_group.main: Destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourceGroups/default-prefix-resources]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...esourceGroups/default-prefix-resources, 10s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...esourceGroups/default-prefix-resources, 20s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...esourceGroups/default-prefix-resources, 30s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...esourceGroups/default-prefix-resources, 40s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...esourceGroups/default-prefix-resources, 50s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...esourceGroups/default-prefix-resources, 1m0s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/c6b49f87-b44b-4f50-9328-...esourceGroups/default-prefix-resources, 2m43s elapsed]
azurerm_resource_group.main: Destruction complete after 2m51s

Destroy complete! Resources: 12 destroyed.
ourobadiou@MacBook-Air-de-Badiou devops-azure-project1 % 
```