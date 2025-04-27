# Azure Bicep - Imports and Exports

## Introduction

The import and export feature in Bicep allows you to resuse commonly used variables. Exports allows you to define variables to be exported for use elsewhere in other templates. Imports let you pull in variables pre-defined elsewhere, so you don’t have to duplicate code. 

This approach keeps your templates tidy, consistent, and easier to manage as your environment grows.

## 📃 Benefits of User Defined Types

✅ Centraliation: Allows you to define commonly repeated variables and user defined types in one file that many Bicep templates can reuse.

✅ Reduces repetition: Variables you may be repeating in each Bicep template can now be moved centrally, reducing repetition and streamlining templates.

✅ Resuability: The exports can now be used across multiple projects and templates allowing much greater resuability for standards and common values.

## Export Example

In the exports example, you can define what variables or types you want to be available to be 'imported' by defining an @export() decorator next to them.

For example, a `shared.bicep` file could reside in the root of your Bicep repository with these commonly used variables:

```bicep
// shared.bicep with common vars

@export()
@description('Primary Azure region.')
var region = 'uksouth'

@export()
@description('Azure Landing Zone HUB subscription Id')
var alzHubSubscriptionId = '0000-0000-0000-000'

@export()
@description('Azure Landing Zone HUB Resource Group')
var alzHubResourceGroup = 'rg-hub'

@export()
@description('Branch Office Public IP for network ACLs')
var branchOfficePip = '82.102.11.90'
```

Entra example:

```bicep
@export()
@description('Common Entra Security Group(s) for RBAC')
var entraSecurityGroups = [
    {
        displayName: 'SG_Cloud_Team',
        objectId: '11111111-1111-1111-1111-111111111111'
    },
    {
        displayName: 'SG_Security_Team',
        objectId: '22222222-2222-2222-2222-222222222222'
    },
    {
        displayName: 'SG_Dev_Team',
        objectId: '33333333-3333-3333-3333-333333333333'
    }
]
```
## Import Example

```bicep
import * as shared '../shared.bicep'



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
