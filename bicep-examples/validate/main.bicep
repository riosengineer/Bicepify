// Rios Engineer - Bicep Validate Decorator
targetScope = 'resourceGroup'

// Parameters
@description('Deployment location for resources.')
param location string = resourceGroup().location

// Parameters with validate decorator
@description('Allowed origin FQDN for CORS. Must not contain https:// or http:// prefix.')
@validate(
  x => !contains(x, 'https://') && !contains(x, 'http://') && contains(x, '.'), 
  'The allowed origin FQDN must not contain "https://" or "http://" prefix and must be a valid domain name.'
)
param allowedOriginFqdn string

// Resources
resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: 'st${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2024-01-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    cors: {
      corsRules: [
        {
          allowedOrigins: [
            'https://${allowedOriginFqdn}'
          ]
          allowedMethods: [
            'GET'
          ]
          allowedHeaders: [
            '*'
          ]
          exposedHeaders: [
            '*'
          ]
          maxAgeInSeconds: 3600
        }
      ]
    }
  }
}

// Outputs
@description('The name of the storage account.')
output storageAccountName string = storageAccount.name

@description('The allowed origin configured for CORS.')
output allowedOrigin string = 'https://${allowedOriginFqdn}'
