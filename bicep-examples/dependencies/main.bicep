targetScope = 'resourceGroup'

// Change the below params to suit your deployment needs
// Go to the modules to amend IP schema, app plan sku/app code stack etc.
@description('Azure UK South region.')
param location string = resourceGroup().location

@description('Web App resource group name.')
param rg_web_workload string = 'rg-webapp-prod'

@description('Workload / corp / core landing zone subid.')
param workloadsSubId string = '00000000-0000-0000-0000-000000000000'

@description('Log analytics workspace name.')
param alaName string = 'ala-workspace-name'

@description('App service application insights name.')
param appInsightsName string = 'appinsights-name'

@description('Azure app service name.')
param webAppName string = 'webapp-001'

@description('The name of the Front Door endpoint to create. This must be globally unique.')
param afdWebEndpoint string = 'afd-${uniqueString(resourceGroup().id)}'

@description('The name of the SKU to use when creating the Front Door profile.')
@allowed([
  'Standard_AzureFrontDoor'
  'Premium_AzureFrontDoor'
])
param frontDoorSkuName string = 'Premium_AzureFrontDoor'

var frontDoorProfileName = 'afdpremium-web'
var frontDoorOriginGroupName = 'webapp-origin-group'
var frontDoorOriginName = 'webapp-origin-group'
var frontDoorRouteName = 'webapp-route'

///////////////
// Resources //
///////////////

// Azure App Service components

// vNet for integration
module vnet 'br/public:avm/res/network/virtual-network:0.2.0' = {
  name: '${uniqueString(deployment().name, location)}-webVnet'
  scope: resourceGroup(workloadsSubId, rg_web_workload)
  params: {
    name: 'webapp-vnet'
    addressPrefixes: [
      '10.1.0.0/21'
    ]
    subnets: [
      {
        name: 'webapp-snet'
        addressPrefix: '10.1.1.0/24'
        delegations: [
          {
            name: 'Microsoft.Web.serverFarms'
            properties: {
              serviceName: 'Microsoft.Web/serverFarms'
            }
          }
        ]
      }
    ]
  }
}

// Log Analytics workspace
module logAnalytics 'br/public:avm/res/operational-insights/workspace:0.5.0' = {
  name: '${uniqueString(deployment().name, location)}-ala'
  scope: resourceGroup(rg_web_workload)
  params: {
    name: alaName
    location: location
  }
}

// Application Insight
module appInsights 'modules/appInsights/appinsights.bicep' = {
  name: '${uniqueString(deployment().name, location)}-appInsights'
  scope: resourceGroup(workloadsSubId, rg_web_workload)
  params: {
    name: appInsightsName
    location: location
    workspaceResourceId: logAnalytics.outputs.logAnalyticsWorkspaceId
    kind: 'web'
    applicationType: 'web'
  }
}

// Azure App Plan
module webAppPlan 'modules/webApp/appPlan.bicep' = {
  name: '${uniqueString(deployment().name, location)}-appPlan'
  scope: resourceGroup(workloadsSubId, rg_web_workload)
  params: {
    name: 'appPlan'
    location: location
    sku: {
      name: 'S1'
    }
    kind: 'App'
  }
}

// Web App resource
module webApp 'modules/webApp/webApp.bicep' = {
  name: '${uniqueString(deployment().name, location)}-webApp'
  scope: resourceGroup(workloadsSubId, rg_web_workload)
  params: {
    name: webAppName
    location: location
    kind: 'app'
    serverFarmResourceId: webAppPlan.outputs.resourceId
    httpsOnly: true
    publicNetworkAccess: 'Disabled'
    appInsightResourceId: appInsights.outputs.resourceId
    virtualNetworkSubnetId: vnet.outputs.subnetResourceIds[0]
    siteConfig: {
      detailedErrorLoggingEnabled: true
      httpLoggingEnabled: true
      requestTracingEnabled: true
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
      alwaysOn: true
    }
    appSettingsKeyValuePairs: {
      name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
      value: appInsights.outputs.instrumentationKey
    }
    managedIdentities: {
      systemAssigned: true
    }
  }
}


// Front Door resource
resource frontDoorProfile 'Microsoft.Cdn/profiles@2021-06-01' = {
  name: frontDoorProfileName
  location: 'global'
  sku: {
    name: frontDoorSkuName
  }
  dependsOn: [
    webApp
    webAppPlan
  ]
}

// Front Door endpoint(s)
resource frontDoorEndpoint 'Microsoft.Cdn/profiles/afdEndpoints@2021-06-01' = {
  name: afdWebEndpoint
  parent: frontDoorProfile
  location: 'global'
  properties: {
    enabledState: 'Enabled'
  }
}

// Front Door origin group
resource frontDoorOriginGroup 'Microsoft.Cdn/profiles/originGroups@2021-06-01' = {
  name: frontDoorOriginGroupName
  parent: frontDoorProfile
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
    }
    healthProbeSettings: {
      probePath: '/'
      probeRequestType: 'HEAD'
      probeProtocol: 'Http'
      probeIntervalInSeconds: 100
    }
  }
}

// Front Door backend - Azure Web App 
resource frontDoorOrigin 'Microsoft.Cdn/profiles/originGroups/origins@2022-11-01-preview' = {
  name: frontDoorOriginName
  parent: frontDoorOriginGroup
  properties: {
    hostName: webApp.outputs.defaultHostname
    httpPort: 80
    httpsPort: 443
    originHostHeader: webApp.outputs.defaultHostname
    priority: 1
    weight: 1000
    sharedPrivateLinkResource: {
      groupId: 'sites'
      privateLink: {
        id: webApp.outputs.resourceId
      }
      privateLinkLocation: location
      requestMessage: 'AFD PE to Web App'
      status: 'Pending'
    }
  }
}

// Front Door route 
resource frontDoorRoute 'Microsoft.Cdn/profiles/afdEndpoints/routes@2021-06-01' = {
  name: frontDoorRouteName
  parent: frontDoorEndpoint
  dependsOn: [
    frontDoorOrigin // This explicit dependency is required to ensure that the origin group is not empty when the route is created.
  ]
  properties: {
    originGroup: {
      id: frontDoorOriginGroup.id
    }
    supportedProtocols: [
      'Http'
      'Https'
    ]
    patternsToMatch: [
      '/*'
    ]
    forwardingProtocol: 'HttpsOnly'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
  }
}

// Output FQDNs
output appServiceHostName string = webApp.outputs.defaultHostname
output frontDoorEndpointHostName string = frontDoorEndpoint.properties.hostName
