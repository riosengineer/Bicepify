targetScope = 'subscription'

metadata name = 'Existing examples'
metadata description = 'Showcasing Azure Bicep existing resources'
metadata owner = 'ops@example.com'

@description('Azure region for deployments.')
param location string = 'uksouth'

// Defining existing resource group named 'existing-rg'
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: 'existing-rg'
}

// Defining existing log analytics workspace named 'existing-law' from the existing resource group above 'scope: rg`
resource law 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  scope: rg
  name: 'existing-law'
}

// Deploying Storage Account to existing resource group & log analytics workspace
module storageAccount 'br/public:avm/res/storage/storage-account:0.8.3' = {
  name: 'storageAccount-${uniqueString(subscription().subscriptionId)}'
  scope: rg
  params: {
    name: 'st${uniqueString(deployment().name)}'
    location: location
    diagnosticSettings:[
      {
        workspaceResourceId: law.id
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
      }
    ]
  }
}

@description('Storage Account name output string.')
output storageAccountName string = storageAccount.outputs.name

@description('Log Analytics Workspace Id.')
output lawName string = law.id
