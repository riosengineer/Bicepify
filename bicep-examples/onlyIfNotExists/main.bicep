targetScope = 'resourceGroup'

metadata name = 'Key Vault with onlyIfNotExists Secret deployment'
metadata description = 'Showcasing Azure Bicep @onlyIfNotExists decorator for conditional secret deployment'

@description('Azure region for deployments chosen from the resource group.')
param location string = resourceGroup().location

@description('Key Vault name - globally unique.')
param kvName string = 'kv-${uniqueString(resourceGroup().id)}'

// Deploy Key Vault using AVM
module keyVault 'br/public:avm/res/key-vault/vault:0.13.3' = {
  name: '${uniqueString(deployment().name, location)}-kv'
  params: {
    name: kvName
    location: location
    sku: 'standard'
    enableRbacAuthorization: false
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    enablePurgeProtection: false
  }
}

// Deploy secret to the Key Vault using @onlyIfNotExists decorator
@onlyIfNotExists()
resource kvSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  name: '${kvName}/mySecret'
  properties: {
    value: 'SecureValue123!'
  }
  dependsOn: [
    keyVault
  ]
}

@description('Key Vault name output.')
output keyVaultName string = keyVault.outputs.name

@description('Key Vault URI output.')
output keyVaultUri string = keyVault.outputs.uri

@description('Secret name output.')
output secretName string = last(split(kvSecret.name, '/'))
