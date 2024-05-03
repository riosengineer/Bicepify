# Azure Bicep - Existing references

## Introduction

Referencing existing Azure resources in your Bicep templates is a useful way to cut down on repeating parameter values that may already be known because the resource already exists. In addition to getting properties from existing resources.

Using the `existing` keyword you can reference an existing Azure resource to call into your properties for deployments.

You can read more from the official Microsoft Learn documentation on existing resources in Bicep [here](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/existing-resource?WT.mc_id=MVP_319025).

## 📃 Benefits of existing references

1. ✅ (DRY) Reduce parameter or variable repetition by using existing to pull in existing Azure resources. E.g. instead of defining a parameter for a Log Analytics workspace name or resourceId that already exists you can leverage `existing`

2. ✅ Access. Allows access to existing resource properties easily e.g. ResourceId of existing resource.

3. ✅ Scope. Allows for scope flexibility. You can reference a resource in a different resource group for example.

## Azure Bicep existing examples

In this example, we are referencing two existing Azure resources:

- Resource Group
- Log Analytics Workspace

Both of these resources are likely to already existing in your Azure environment. If you're deploying a new resource you may want to put this into an existing resource group, using an existing log analytics workspace that is centralised for all metrics to ingest into. In this example within the `main.bicep` file:

We are defining the existing resources to be used in a newly deploy Storage Account.

```javascript
module storageAccount 'br/public:avm/res/storage/storage-account:0.8.3' = {
  name: 'storageAccount-${uniqueString(subscription().subscriptionId)}'
  scope: rg
  params: {
    name: 'st${uniqueString(deployment().name)}'
    location: location
    diagnosticSettings:[
      {
        workspaceResourceId: law.id
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
      }
    ]
  }
}
```

`scope: rg` which is leveraging the existing symbolic name of the existing Resource Group where we have specified the existing `name:` of the Resource Group in the `main.bicep` file.

`workspaceResourceId: law.id` which is referencing the existing Log Analytics Workspace resource to retrieve the `resourceId` property.

Combining these enables a new Storage Account to be created in an existing Resource Group and diagnostic settings to send all metrics to an existing Log Analytics Workspace.

## 🚀 Deployment

> [!NOTE]  
> The deployment commands will create the existing resources first before leveraging the Bicep template to utilise these.

In VisualStudio Code open a terminal and run:

CLI

```bash
az login
az account set --subscription 'subscription name or id'
az group create -l uksouth -n existing-rg
az monitor log-analytics workspace create -n 'existing-law' -g 'existing-rg'
az deployment sub create -l 'uksouth' --confirm-with-what-if -f '.\main.bicep'
```

or PowerShell

```powershell
Connect-AzAccount
Set-AzContext -Subscription "subscription name or id"
New-AzResourceGroup -Location "UKSouth" -Name "existing-rg"
New-AzOperationalInsightsWorkspace -Location "UKSouth" -Name "existing-law" -ResourceGroupName "existing-rg"
New-AzSubscriptionDeployment -Confirm -Location "UKSouth" -TemplateFile ".\main.bicep" 
```
