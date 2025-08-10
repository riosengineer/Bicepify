targetScope = 'resourceGroup'

// Parameters
@description('The SKU type for the storage account using the resource providers derived type.')
param storageSkuType resourceInput<'Microsoft.Storage/storageAccounts@2024-01-01'>.sku.name

@description('The kind of the storage account using the resource providers derived type.')
param storageKindType resourceInput<'Microsoft.Storage/storageAccounts@2024-01-01'>.kind

// Resources
resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: 'st${uniqueString(resourceGroup().id)}'
  location: resourceGroup().location
  sku: {
    name: storageSkuType
  }
  kind: storageKindType
}
