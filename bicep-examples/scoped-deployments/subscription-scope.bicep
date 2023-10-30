targetScope = 'subscription'

@description('Resource Group name.')
param rg string = 'rg-bicepify-dev'

@description('Deployment location for resources.')
param location string = 'uksouth'


// Deploy new resource group for later use in same bicep deployment
resource rg_deploy 'Microsoft.Resources/resourceGroups@2022-09-01' = {
name: rg
location: location
}

// Deploy storage account to newly created resource group

module st_deploy 'br/public:storage/storage-account:3.0.1' = {
  scope: rg_deploy
  name: 'storageDeployment'
  params:{
    name: 'stbicepifydemo001'
  }
}

// Deploy storage account to existing resource group in a subscription, without changing target scope

module st_deploy2 'br/public:storage/storage-account:3.0.1' = {
  scope: resourceGroup('subscription-guid-here', 'rg-name-here')
  name: 'storageDeployment'
  params:{
    name: 'stbicepifydemo002'
  }
}
