@description('Name of the storage account - without st prefix.  ')
param storageAccountName string

@description('Azure resource location.')
param location string = resourceGroup().location

var storageAccountPrefix = 'st'
var storageAccountNameChecked = startsWith(storageAccountName, storageAccountPrefix)
  ? storageAccountName
  : fail('The storage account name must start with "${storageAccountPrefix}".')

resource resStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountNameChecked
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {}
}
