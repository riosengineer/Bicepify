targetScope = 'managementGroup'

@description('Resource Group name.')
param rg string = 'rg-bicepify-dev'

@description('Deployment location for resources.')
param location string = 'uksouth'

@description('Subscription Id.')
param subId string = 'subscription-guid-here'

// Deploy Storage Account to existing resource group in a subscription from management scope
module st_deploy 'br/public:storage/storage-account:3.0.1' = {
  scope: resourceGroup(subId, rg)
  name: 'st_deploy'
  params:{
    kind: 'StorageV2'
    location: location
  }
}
