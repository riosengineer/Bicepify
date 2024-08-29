targetScope = 'resourceGroup'

// User Defined Types
type storageSkuType = 'Standard_LRS' | 'Standard_GRS' | 'Standard_RAGRS' | 'Standard_ZRS' | 'Premium_LRS' | 'Premium_ZRS' | 'Premium_GRS' | 'Premium_RAGRS'

type storageConfType = {
  name: string
  sku: storageSkuType
  location: string
  kind: 'StorageV2' | 'BlobStorage' | 'FileStorage' | 'BlockBlobStorage' }

// Parameters
@description('Azure region used from the resource group.')
param location string = resourceGroup().location

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
