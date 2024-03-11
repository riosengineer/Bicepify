# Azure Bicep - Iterative loops (for)

## Introduction

For loops in Azure Bicep can be a great way to simplify and minimise your Bicep templates, as they allow you to define multiple copies of a resource which helps reduce and avoids us repeating code in our Bicep templates. 

Using a for loop, you can quickly deploy multiple resources, in this instance a virtual network resource with multiple subnets in one block. 

You can go through the Microsoft Learn training module for this which is great [here](https://learn.microsoft.com/en-us/training/modules/build-flexible-bicep-templates-conditions-loops/).

## 📃 Benefits of using for loops in Bicep

1. ✅ DRY (Don't repeat yourself) - avoids repeating Bicep code unnecessarily

2. ✅ Clean templates. By avoiding duplicating code, we can reduce large template files with lots of code lines

3. ✅ Best practice. It's good practice to use for loops in your Bicep templates for the reasons above as well as maintainability as you scale

## For Loop Example

In the basic example within the `main.bicep` file, we can using the `for` property to state for each `vnet` resource, loop through and create the virtual network with subnets.

As the variable (refer to the `main.bicep` file) also contains the required subnets, we're further looping the sub-property within the `vnet` to loop for each `subnet` within the `vnet` as it deploys.

```javascript
resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = [for vnet in vnets: {
  name: vnet.name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet.addressPrefix
      ]
    }
    subnets: [for subnet in vnet.subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.subnetPrefix
      }
    }]
  }
}]
```

## 🚀 Deployment

> [!NOTE]  
> You need to have a resource group deployed before trying this out.

In VisualStudio Code open a terminal and run:

CLI

```bash
az login
az account set --subscription 'subscription name or id'
az deployment group create -g 'your-rg' --confirm-with-what-if -f '.\main.bicep'
```

or PowerShell

```powershell
Connect-AzAccount
Set-AzContext -Subscription "subscription name or id"
New-AzResourceGroupDeployment -Confirm -ResourceGroup "your-rg -TemplateFile "main.bicep"
```
