targetScope = 'subscription'

metadata name = 'Resource Group Azure Bicep module'
metadata description = 'Module used to create Resource Groups'
metadata owner = 'ops@example.com'

@description('Azure Region where the Resource Group will be created.')
param parLocation string

@description('Name of Resource Group to be created.')
param parResourceGroupName string

@description('Azure Tags you would like to be applied to the Resource Group.')
param parTags object = {}

resource resResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  location: parLocation
  name: parResourceGroupName
  tags: parTags
}
