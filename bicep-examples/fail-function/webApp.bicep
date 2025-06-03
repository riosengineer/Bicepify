@description('The name of the App Service Plan')
param appServicePlanName string = uniqueString(resourceGroup().id)

@description('The name of the Web App')
param webAppName string = uniqueString(resourceGroup().id)

// Fail the deployment if the runtime is not specified
@description('The runtime stack for the Web App, e.g. "DOTNET|9.0"')
param runtime string = ''

// Fail if runtime is empty
var varRuntime = empty(trim(runtime)) ? fail('The runtime parameter is empty!') : runtime

resource appServicePlan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: appServicePlanName
  location: resourceGroup().location
  sku: {
    name: 'F1'
    tier: 'Free'
  }
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2024-11-01' = {
  name: webAppName
  location: resourceGroup().location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: varRuntime
    }
  }
}
