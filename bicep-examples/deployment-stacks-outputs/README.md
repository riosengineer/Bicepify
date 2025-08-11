# Azure Bicep - Deployment Stack Outputs

## Introduction

Deployment stack outputs in Azure Bicep allow you to reference values from resources managed by a deployment stack in other Bicep templates. This enables you to create modular, reusable infrastructure and pass important resource IDs or properties between deployments.

> [!TIP]  
> Checkout [Bas Berkhout's blog](https://under-ctrl.com/posts/azure-deployment-stacks-arm-limits-p-1/) on this if you want more reading material.

## 📃 Benefits of Stack Outputs

✅ Modularity: Outputs make it easy to break your infrastructure into reusable stacks and reference their results elsewhere. This also allows you to work around the ARM 4MB template size limits.

✅ Automation: Automatically pass resource IDs, connection strings, or other values between deployments without manual intervention.

✅ Maintainability: Changes to outputs in the stack propagate to all templates that consume them. Be cautious, however, as this also may increase blast radius if a upstream value changes and you haven't tested properly.

## Stack Output Example

In this example, you’ll deploy a user-assigned managed identity in one stack, then reference its resource ID as an output in another Bicep template to assign it to a storage account.

**Stack Bicep (outputs):**

```bicep
output userAssignedIdentityId string = modUserAssignedIdentity.outputs.resourceId
```

**Main Bicep:**

Here, we're referencing the existing stack resource in another subscription (the concept applies to resource groups too!) so we can consume the outputs in this template from the other stacks metadata outputs. By creating an outputs variable we're able to pull in the `userAssignedIdentityId` value to this template when deploying.

```bicep
@description('The subscription ID where the referenced stack exists.')
param stackSubscriptionId string

@description('Your Deployment Stack name that you want to pull outputs from.')
var stackName = 'az-bicepify-stack-output'

resource existingStack 'Microsoft.Resources/deploymentStacks@2024-03-01' existing = {
  name: stackName
  scope: subscription(stackSubscriptionId)
}

var stackOutputs = existingStack.properties.outputs
var stackOutputsUserAssignedIdentityId string = stackOutputs.userAssignedIdentityId.value // We get no intellisense here, so you have to know the output name and append the `.value` on the end for the string value.

module modStorageAccount 'br/public:avm/res/storage/storage-account:0.26.0' = {
  // ...existing code...
  managedIdentities: {
    userAssignedResourceIds: [
      stackOutputsUserAssignedIdentityId
    ]
  }
}
```

By referencing the stack output, you can connect resources across templates and scopes in a robust, automated way.

## 🚀 Deployment

> [!NOTE]  
> You need to have the stack deployed before running the main template.

In Visual Studio Code open a terminal and run:

CLI

```bash
az login
az account set --subscription 'subscription name or id'
-- Deploy Stack
az stack sub create --name 'az-bicepify-stack-output' -l 'uksouth' -f .\bicep-examples\deployment-stacks-outputs\stacks.bicep -p .\bicep-examples\deployment-stacks-outputs\stacks.bicepparam  --action-on-unmanage 'deleteAll' --deny-settings-mode 'none'
-- Deploy main template
az deployment sub create -l uksouth -f .\bicep-examples\deployment-stacks-outputs\main.bicep -p .\bicep-examples\deployment-stacks-outputs\main.bicepparam
```

or PowerShell

PowerShell

```powershell
Connect-AzAccount
Set-AzContext -Subscription "subscription name or id"
# Deploy Stack
New-AzSubscriptionDeploymentStack -Name 'az-bicepify-stack-output' -Location 'uksouth' -TemplateFile '.\bicep-examples\deployment-stacks-outputs\stacks.bicep' -TemplateParameterFile '.\bicep-examples\deployment-stacks-outputs\stacks.bicepparam' -ActionOnUnmanage 'deleteAll' -DenySettingsMode 'none' 
# Deploy main template
New-AzSubscriptionDeployment -Location 'uksouth' -TemplateFile '.\bicep-examples\deployment-stacks-outputs\main.bicep' -TemplateParameterFile '.\bicep-examples\deployment-stacks-outputs\main.bicepparam'
```
