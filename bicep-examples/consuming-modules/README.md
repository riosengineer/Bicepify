# Consuming Bicep Modules - What are my options?

## [Blog post](https://rios.engineer/consuming-bicep-modules-what-are-my-options/)

## Introduction

If you're new to Bicep understanding the different ways to consume modules can be beneficial to accelerating your adoption. This example will showcase the different methods, the benefits and why taking a combination approach can be desirable.

Please review the blog post to get an understanding on the pros & cons of each consumption method. These are based on real world experiences using all methods, straight from the battlefield.

## Public Bicep Registry (Azure Verfieid Modules)

The public registry can be consumed directly from anywhere with ease and has quick adoption with no start up overhead as the modules are centrally stored by the team.

The concept of AVM allows these modules to accelerate teams to deploy with Bicep, using best practice & aligned to the Well-Architected Framework that is managed by Microsoft so you don't have to maintain the modules yourselves. Be sure to check out more on [AVM](https://azure.github.io/Azure-Verified-Modules/overview/introduction/).

```bicep
module KeyVault 'br/public:avm/res/key-vault/vault:0.7.0' = {
  name: 'avm_exmple'
  params: {
    name: 'kvName'
    location: 'uksouth'
    sku: 'standard'
    enableSoftDelete: true
  }
}
```

## Private Registry

Creating your own Azure Container Registry can be a great way to consume Bicep modules for internal use only.

This may be required if you have heavy customisations, want central control and standards for your teams to use. However, it comes with much larger overhead for maintenance and versioning, communication and updates are key to keep up with the pace of Azure!

Example (the Azure URI is just for illustration purposes):

```javascript
module private_registry 'br:crbicepprod.azurecr.io/bicep/modules/logging:2023-09-29' = {
  name: 'private_registry_example'
  params: {
    parLogAnalyticsWorkspaceLocation: 'uksouth'
    parAutomationAccountLocation: 'uksouth'
    parLogAnalyticsWorkspaceName: 'example-uks-ala-prod'
    parLogAnalyticsWorkspaceSkuName: 'PerGB2018'
    parLogAnalyticsWorkspaceSolutions: [
      'AgentHealthAssessment'
      'AntiMalware'
      'ChangeTracking'
      'Security'
      'SecurityInsights'
      'SQLAdvancedThreatProtection'
      'SQLVulnerabilityAssessment'
      'SQLAssessment'
      'Updates'
      'VMInsights'
    ]
    parAutomationAccountName: 'example-uks-aa-prod'
    parAutomationAccountUseManagedIdentity: true
    parTelemetryOptOut: false
    parTags: {
      Env: 'Example'
    }
  }
}
```

## Inline Bicep Modules

Lastly, consuming modules locally is another approach. This method is great for getting started, it's easy to see how everything flows together (visually at least) and enables you to customise modules.

With this method you can write your own modules within a `\modules` folder and call on them in your `main.bicep` to load in.

The benefit here is customisation, flexibility & you can take advantage of [CARML (Common Azure Resource Library)](https://github.com/Azure/ResourceModules) where a lot of the Azure Bicep coding has been done for you, copying the modules to the modules folder gives you a lot of deployment velocity straight away, with minimal startup overhead.

```javascript
// Rios Engineer - Inline Bicep Module Example
module inline_module 'modules/inline/customModule.bicep' = {
  name: 'inline_module_example'
  params:{
    location: 'uksouth'
    tags: {
      Env: 'Example'
    }
    storageName: 'stsomestoragename001'
    storagePleBlobName: 'someblobname'
    storagePleFileName: 'somefilename'
    storageSkuName: 'Standard_LRS'
    subnetId: 'subnetId'
    virtualNetworkId: 'vnetId'
  }
}
```
