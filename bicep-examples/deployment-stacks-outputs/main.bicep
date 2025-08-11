targetScope = 'subscription'

// Metadata
metadata name = 'Deployment Stacks Outputs Example'
metadata description = 'Showcasing Azure Bicep Stacks Outputs'
metadata owner = 'dan@rios.engineer'

// Parameters
@description('Azure region for deployments chosen from the resource group.')
param location string = 'uksouth'

@maxLength(24)
@description('Name of the Key Vault resource.')
param keyVaultName string

@description('Name of the resource group for the Key Vault.')
param resourceGroupName string

// Variables
@description('Your Deployment Stack name that you want to pull outputs from.')
var stackName = 'az-bicepify-stack-output'

// Existing Deployment Stack 
resource existingStack 'Microsoft.Resources/deploymentStacks@2024-03-01' existing = {
  name: stackName
  scope: subscription(stackSubscriptionId)
}

@description('Creating stack outputs variable to reference existing stack outputs.')
var stackOutputs object = existingStack.properties.outputs
var stackOutputsUserAssignedIdentityId string = stackOutputs.userAssignedIdentityId.value

@description('The subscription ID where the referenced stack exists.')
param stackSubscriptionId string = '1417db09-accd-4799-b224-4346e5cb12c3'

// Modules 
module modResourceGroup 'br/public:avm/res/resources/resource-group:0.4.1' = {
  params: {
    name: resourceGroupName
    location: location
  }
}

module modKeyVault 'br/public:avm/res/key-vault/vault:0.13.1' = {
  scope: resourceGroup(resourceGroupName)
  params: {
    name: keyVaultName
    location: location
    sku: 'standard'
    roleAssignments: [
      {
        principalId: stackOutputsUserAssignedIdentityId // Using the UMI resourceId from the existing stack
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Key Vault Secrets User'
      }
    ]
  }
}

output test object = {
  userAssignedIdentityId: stackOutputsUserAssignedIdentityId
}
