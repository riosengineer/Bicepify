targetScope = 'subscription'
// az stack sub create --name 'az-bicepify-stack' -l 'uksouth' -f .\bicep-examples\deployment-stacks-outputs\stacks.bicep --action-on-unmanage 'deleteAll' --deny-settings-mode 'none'
// Metadata
metadata name = 'Deployment Stacks Output Example'
metadata description = 'Showcasing Azure Bicep Stacks Output references'
metadata owner = 'dan@rios.engineer'

// Parameters 
@description('Azure region for deployments chosen from the resource group.')
param location string = 'uksouth'

@maxLength(24)
@description('Name of the user assigned identity. Unique string.')
param umiName string

@description('Name of the resource group for the user assigned identity.')
param resourceGroupName string

// Modules
module modResourceGroup 'br/public:avm/res/resources/resource-group:0.4.1' = {
  params: {
    name: resourceGroupName
    location: location
  }
}

module modUserAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = {
  name: '${uniqueString(deployment().name, location)}-${umiName}'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: umiName
    location: location
  }
  dependsOn: [
    modResourceGroup
  ]
}

output userAssignedIdentityId string = modUserAssignedIdentity.outputs.principalId
output resourceGroupId string = modResourceGroup.outputs.name
