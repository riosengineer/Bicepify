// Rios Engineer - Bicep Test Framework
targetScope = 'resourceGroup'

@description('Deployment location for resources.')
param location string

@description('Storage account resource SKU.')
param kind string

@description('Storage account name.')
param stName string

// Storage Account
module storage 'br/public:avm/res/storage/storage-account:0.11.1' = {
  name: 'storage_deploy'
  params:{
    name: stName
    kind: kind
    location: location
  }
}
// 24 character limit assertion
var namingLength = [length(storage.name) > 24]
assert validLength = !contains(namingLength, true)

// Test location is valid for UK regions
assert locationUk = contains(location, 'uk')

// SKU assert
assert sku = contains(kind, 'storageV2')
