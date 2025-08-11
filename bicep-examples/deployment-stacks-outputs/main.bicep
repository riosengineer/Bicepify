targetScope = 'subscription'

// Metadata
metadata name = 'Deployment Stacks Outputs Example'
metadata description = 'Showcasing Azure Bicep Stacks Outputs'
metadata owner = 'dan@rios.engineer'

// Parameters
@description('Azure region for deployments chosen from the resource group.')
param location string = 'uksouth'

@maxLength(24)
@description('Name of the Storage Account resource.')
param storageAccountName string

param resourceGroupName string
// Variables
@description('Your Deployment Stack name that you want to pull outputs from.')
var stackName = 'az-bicepify-stack-output'

@description('Creating stack outputs variable to reference existing stack outputs.')
var stackOutputs = existingStack.properties.outputs
output stackOutputsState string = stackOutputs.userAssignedIdentityId[0]

@description('The subscription ID where the referenced stack exists.')
param stackSubscriptionId string = subscription().id

// Existing Deployment Stack 
resource existingStack 'Microsoft.Resources/deploymentStacks@2024-03-01' existing = {
  name: stackName
  //scope: subscription(stackSubscriptionId)
}

// Modules 
module modResourceGroup 'br/public:avm/res/resources/resource-group:0.4.1' = {
  params: {
    name: resourceGroupName
    location: location
  }
}

module modStorageAccount 'br/public:avm/res/storage/storage-account:0.26.0' = {
  name: '${uniqueString(deployment().name, location)}-storage'
  scope: resourceGroup('${resourceGroupName}')
  params: {
    name: storageAccountName
    location: location
    skuName: 'Standard_LRS'
    kind: 'StorageV2'
    managedIdentities: {
      userAssignedResourceIds: [
        stackUserAssignedIdentityId // References existing stack output value
      ]
    }
  }
  dependsOn: [
    modResourceGroup
  ]
}
