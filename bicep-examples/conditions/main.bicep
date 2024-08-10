targetScope = 'resourceGroup'

metadata name = 'Key Vault creation Bicep module'
metadata description = 'Showcasing Azure Bicep if conditions'
metadata owner = 'ops@example.com'

@description('Azure region for deployments chosen from the resource group.')
param location string = resourceGroup().location

@description('Azure Key Vault resource names that will be created. Must be globally unique.')
param kvName string = 'kv-uks-bicepify-prod-001'

@description('Deploy Azure Key Vault true/false.')
param deployResource bool = false

@description('Azure Key Vault organisation enviornment.')
@allowed([
  'prod'
  'preprod'
  'dev'
])
param kvEnv string = 'prod'

// Environment variable for Key Vault SKU else if
var kvSku = kvEnv == 'prod' ? 'premium' : 'standard'

module KeyVault 'br/public:avm/res/key-vault/vault:0.7.0' = if (deployResource) {
  name: '${uniqueString(deployment().name, location)}-${kvName}'
  params: {
    name: kvName
    location: location
    sku: kvSku
    enableSoftDelete: true
  }
}

// Output Key Vault name
output kvUri string = KeyVault.outputs.name
