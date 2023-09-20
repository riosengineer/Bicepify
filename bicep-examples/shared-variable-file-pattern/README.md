# Using shared variable file pattern in Azure Bicep - Examples

## Blog post coming soon

Building on the Microsoft Documentation on this I've expanded and created some more examples where this can be useful for you or your organisation. I've broken these down into three example chunks. I would advise first going over the documentation to familiarise yourself with the concept here:

 [MS Learn - Shared variable file pattern](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/patterns-shared-variable-file)

 Each example should be simple to understand and translate to real world scenarios these could help you with.

 Within the `/configs` folder you'll find `json` files which contain the shared variable example data

## Deployment

In VisualStudio Code open a terminal and run:

CLI

```bash
az login
az set --subscription 'your subscription name'
az deployment create --confirm-with-what-if -g 'your resource group name' -f .\file.bicep 
```

or PowerShell

```powershell
Connect-AzAccount
Set-AzContext -Subsription "your subsription name"
New-AzResourceGroupDeployment -Confirm -ResourceGroup "your resource group name" -TemplateFile "file.bicep"
```

## Example - Naming prefixes

Using naming prefixes in a global configuration JSON file means we can centralise commonly used variables for repeated use across many Bicep templates.

Loading the content from the JSON file `naming-config.json` we can expand the variable referenced to call on our naming prefixes, for example:

```javascript
@description('Naming standards prefix JSON config file. Loads prefixes for Azure resources using {$namingPrefixes.Name}.')
var namingPrefixes = loadJsonContent('./configs/naming-config.json')
```

The variable 'namingPrefixes' is now available to call on, below is an example JSON config file, where we can call the variable that has loaded this JSON content to call our prefix standard:

```yaml
{
    "virtualMachinePrefix": "vm-prod",
    "webAppPrefix": "app-prod",
    "functionPrefix": "func",
    "sqlPrefix": "sqldb-prod",
    "storagePrefix": "st",
    "vnetPrefix": "vnet",
    "subnetPrefix": "snet",
    "nicPrefix": "nic",
    "pipPrefix": "pip",
    "nsgPrefix": "nsg",
    "routeTablePrefix": "route"
}
```

`
${namingPrefixes.storagePrefix}
`

Example Azure Bicep code block that uses this:

```javascript
module storage_prefix 'br/public:storage/storage-account:3.0.1' = {
  name: 'storage_deploy'
  params:{
    name: '${namingPrefixes.storagePrefix}riosengineer001'
    sku: 'Standard_LRS'
    kind: 'StorageV2'
    location: 'uksouth'
  }
}
```

There are further complete examples for you to test deploy in this folder using this concept, such as loading in virtual machine publisher information and enviornment configuration (production, dev & UAT).
