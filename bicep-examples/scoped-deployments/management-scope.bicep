targetScope = 'managementGroup'

@description('Resource Group name.')
param rg string = 'rg-bicepify-dev'

@description('Deployment location for resources.')
param location string = 'uksouth'

@description('Subscription Id.')
param subId string = 'subscription-guid-here'

@description('Storage Account name.')
param stName string = 'stname0001'

// Deploy Storage Account to existing resource group in a subscription from management scope
module st_deploy 'br/public:avm/res/storage/storage-account:0.11.1' = {
  scope: resourceGroup(subId, rg)
  name: 'st_deploy'
  params:{
    name: stName
    kind: 'StorageV2'
    location: location
  }
}
