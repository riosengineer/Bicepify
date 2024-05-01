# Azure Bicep - Lambda Functions

## Introduction

Lambda Functions in Azure Bicep can be a good way to create an argument based on multiple parameters. These are defined as `<lambda var> => <expression>` and consist of multiple functions such as `filter()` `map()` `sort()` `reduce()` `toObject()`.

This can be useful when wanting to output an array of Azure resource names for example. This example will be expanded over time to include more real world use cases.

However, it is worth noting there are some [limitations](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-functions-lambda?WT.mc_id=MVP_319025#limitations) with lambda functions.

You can read more from the official Microsoft Learn documentation on Lambda Functions [here](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-functions-lambda?WT.mc_id=MVP_319025).

## 📃 Benefits of Lambda Functions

1. ✅ Abstraction. Allows you to define custom data structures for your use cases.

2. ✅ Consistency with other programming languages. Many popular languages use the `=>` to represent the functions so it's familiar for devs.

## Lambda Function Examples

In the first example within the `main.bicep` file, there is a `map` expression from an array output. Using the `map` expression in this example you're able to extrapolate all the Key vault resource names from a loop in the output. 

In the second example within the `main.bicep` file, there is a `filter` expression from an array output. This enables you to manipulate the array and filter the output using the `filter` expression to only show those that match your expression statement in the output.

Map

```javascript
@description('Output all Key Vault names from the loop using a map function expression.')
output keyVaultNames array = map(keyVaults, keyvault => keyvault.outputs.name)
```

Filter

```javascript
@description('Output all Key Vaults with premium SKUs that have soft delete disabled.')
output kvFilter array = filter(kvProperties, kv => kv.sku == 'premium' && kv.softdelete == 'true')
```

Output example

```json
    "outputs": {
      "keyVaultNames": {
        "type": "Array",
        "value": [
          "kv-0-7jf67vploiowy",
          "kv-1-7jf67vploiowy",
          "kv-2-7jf67vploiowy",
          "kv-3-7jf67vploiowy",
          "kv-4-7jf67vploiowy",
          "kv-5-7jf67vploiowy",
          "kv-6-7jf67vploiowy",
          "kv-7-7jf67vploiowy",
          "kv-8-7jf67vploiowy",
          "kv-9-7jf67vploiowy"
        ]
      },
      "kvFilter": {
        "type": "Array",
        "value": [
          {
            "keyvaultName": "kv-of3g6trcnh2ak",
            "sku": "premium",
            "softdelete": "true"
          },
          {
            "keyvaultName": "kv-of3g6trcnh2ak",
            "sku": "premium",
            "softdelete": "true"
          }
        ]
      }
    },
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
