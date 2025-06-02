@description('Name of the storage account.')
param storageAccountName string

@description('Azure resource location.')
param location string = resourceGroup().location

@description('Enable Azure AD (Entra ID) authentication for Azure Files?')
param enableAzureAD bool

var entraIdCheck = enableAzureAD ? true : fail('Azure AD (Entra ID) must be enabled for Azure Files to work properly. Set enableAzureAD to true.')

resource resStorageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: entraIdCheck ? storageAccountName : storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    
  }
}

resource resFileService 'Microsoft.Storage/storageAccounts/fileServices@2024-01-01' = {
  name: 'default'
  parent: resStorageAccount
}

resource resFileShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2024-01-01' = {
  name: 'entraFileShare'
  parent: resFileService
  properties: {
    }
}
