targetScope = 'resourceGroup'

// Metadata
metadata name = 'User Defined Types'
metadata description = 'Showcasing Azure Bicep UDTs'
metadata owner = 'ops@example.com'

// User Defined Types
type storageSkuType = 'Premium_LRS' | 'Premium_ZRS' | 'Standard_GRS' | 'Standard_GZRS' | 'Standard_LRS' | 'Standard_RAGRS' | 'Standard_RAGZRS' | 'Standard_ZRS'

type storageConfType = {
  name: string
  sku: storageSkuType
  location: string
  kind: 'StorageV2' | 'BlobStorage' | 'FileStorage' | 'BlockBlobStorage' }

// Parameters
@description('Azure region used from the resource group.')
param location string = resourceGroup().location

@description('Storage account UDR param config.')
param storageConf storageConfType

// Storage Account
module storage 'br/public:avm/res/storage/storage-account:0.11.1' = {
  name: 'uniqueString(deployment().name, location)-st'
  params: {
    name: storageConf.name
    location: location
    skuName: storageConf.sku
    kind: storageConf.kind
  }
}
