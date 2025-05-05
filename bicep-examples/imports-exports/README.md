# Azure Bicep - Imports and Exports

## Introduction

The import and export feature in Bicep allows you to reuse commonly used variables and types efficiently. Exports enable you to define variables that can be imported for use in other templates, while imports allow you to pull in pre-defined variables—eliminating the need to duplicate code across multiple Bicep files.

Instead of manually defining a variable in every new Bicep file, such as:

 `var budgetAlertEmail = 'dan@rios.engineer'` 

You can store this value centrally and simply import it into your template when needed.

This functionality extends beyond just variables (and types). It can be applied to various use cases, such as subscription IDs, service principal IDs, app registrations, and private DNS zone FQDNs and tons more. Helping maintain consistency and reducing repetitive code.

## 📃 Benefits of User Defined Types

✅ Centraliation: Allows you to define commonly repeated variables and user defined types in one file that many Bicep templates can reuse.

✅ Reduces repetition: Variables you may be repeating in each Bicep template can now be moved centrally, reducing repetition and streamlining templates.

✅ Resuability: The exports can now be used across multiple projects and templates allowing much greater resuability for standards and common values. This can also help reduce configuration errors.

## Export Examples

In the exports example, you can define what variables or types you want to be available to be imported by defining an @export() decorator next to them.

For example, a `shared.bicep` file could reside in the root of your Bicep folder within your repository, with these commonly used variables as an example:

```bicep
// shared.bicep with common vars
@export()
@description('The Primary Azure Region location')
var location = 'uksouth'

@export()
@description('Branch Office Public IP')
var branchOfficePublicIP = '82.110.72.90'
```

### Entra example:

```bicep
@export()
@description('Common Entra Security Group(s) for RBAC')
var entraSecurityGroups = {
    SG_Cloud_Team: {
        displayName: 'SG_Cloud_Team'
        objectId: '11111111-1111-1111-1111-111111111111'
    }
    SG_Security_Team: {
        displayName: 'SG_Security_Team'
        objectId: '22222222-2222-2222-2222-222222222222'
    }
    SG_Dev_Team: {
        displayName: 'SG_Dev_Team'
        objectId: '33333333-3333-3333-3333-333333333333'
    }
}
```
## Import Examples
### Entra ObjectId
```bicep
import * as shared from 'shared.bicep'

module rg 'br/public:avm/res/resources/resource-group:0.4.1' = {
...
roleAssignments: [
      {
        principalId: shared.entraSecurityGroups.SG_Cloud_Team.objectId // Using imported Entra Security Group Object ID
        roleDefinitionIdOrName: 'Contributor'
      }
    ]
```

### ACL IP Example:
```bicep
import * as shared from 'shared.bicep' 
// or you can only import the required variable vs all available via 
// import { branchOfficePublicIP } as branchOfficePublicIP from 'shared.bicep' as an example
module keyVault 'br/public:avm/res/key-vault/vault:0.12.1' = {
....
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: [
        {
          value: shared.branchOfficePublicIP // using central import value from shared.bicep
          action: 'Allow'
        }
      ]
    }
  }
```

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