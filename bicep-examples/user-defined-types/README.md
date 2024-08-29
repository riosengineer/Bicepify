# Azure Bicep - User Defined Types

## Introduction

User-defined types in Azure Bicep allow you to create custom data structures within your Bicep templates. Instead of relying solely on built-in data types, you can define your own types tailored to your specific needs and requirements.

## 📃 Benefits of User Defined Types

✅ Type Safety: User-defined types (UDTs) enforce that only valid data structures are used. This helps prevent accidental misconfigurations.

✅ Maintainability: When you adopt UDTs, your Bicep code becomes easier to maintain. Changes to the types automatically propagate to all places where the type is used.

✅ Intellisense: The VS Code Bicep IntelliSense provides type auto completions and expected values, enhancing your development experience.

## User Defined Type Example

In this example, you’ll deploy a Storage Account using custom types as part of the configuration. Within the `main.bicep` file, you’ll find the two defined types:

```bicep
// User Defined Types
type storageSkuType = 'Premium_LRS' | 'Premium_ZRS' | 'Standard_GRS' | 'Standard_GZRS' | 'Standard_LRS' | 'Standard_RAGRS' | 'Standard_RAGZRS' | 'Standard_ZRS'

type storageConfType = {
  name: string
  sku: storageSkuType
  location: string
  kind: 'StorageV2' | 'BlobStorage' | 'FileStorage' | 'BlockBlobStorage' }
```

By defining the data structure in this way, you ensure both type safety and valid data for the Storage Account configuration.

Next, the Bicep parameter is defined for the type.

```bicep
@description('Storage account UDR param config.')
param storageConf storageConfType
```

Lastly, using the parameter you can complete the Storage Account config `storageConf.sku` `storageConf.kind` and so forth.

## 🚀 Deployment

> [!NOTE]  
> You need to have a resource group deployed before trying this out.

In VisualStudio Code open a terminal and run:

CLI

```bash
az login
az account set --subscription 'subscription name or id'
az deployment group create -g 'your-rg' --confirm-with-what-if -f '.\main.bicep' -p 'main.bicepparam'
```

or PowerShell

```powershell
Connect-AzAccount
Set-AzContext -Subscription "subscription name or id"
New-AzResourceGroupDeployment -Confirm -ResourceGroup "your-rg" -TemplateFile "main.bicep" -TemplateParameterFile "main.bicepparam"
```
