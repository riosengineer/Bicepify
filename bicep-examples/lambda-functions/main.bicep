targetScope = 'resourceGroup'

metadata name = 'Lambda Function Examples'
metadata description = 'Showcasing Azure Bicep Lamba Functions'
metadata owner = 'func@example.com'

@description('Azure region for deployments chosen from the resource group.')
param location string = 'uksouth'

// map function
module keyVaults 'br/public:avm/res/key-vault/vault:0.4.0' = [ for i in range(0,10):  {
  name: 'kvdeploy-${i}${uniqueString(resourceGroup().id)}'
  params: {
    name: 'keyv-${i}-${uniqueString(subscription().id)}'
    location: location
    sku: 'standard'
  }
}]

@description('Output all Key Vault names from the loop using a map function expression.')
output keyVaultNames array = map(keyVaults, keyvault => keyvault.outputs.name)

// filter function
var kvProperties = [
  {
    keyvaultName: 'keyvault-0-1234567890'
    sku: 'standard'
    softdelete: 'true'
  }
  {
    keyvaultName: 'keyvault-1-1234567890'
    sku: 'premium'
    softdelete: 'true'
  }
  {
    keyvaultName: 'keyvault-2-1234567890'
    sku: 'premium'
    softdelete: 'true'
  }
  {
    keyvaultName: 'keyvault-3-1234567890'
    sku: 'premium'
    softdelete: 'false'
    purge: 'off'
  }
]
@description('Output all Key Vaults with premium SKUs that have soft delete disabled.')
output kvFilter array = filter(kvProperties, kv => kv.sku == 'premium' && kv.softdelete == 'true')
