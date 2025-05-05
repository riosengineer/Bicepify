
targetScope = 'subscription'

// MARK: Imports
import * as shared from 'shared.bicep'
// import { location } as location from 'shared.bicep' to only import a specific var or type from the file.

// MARK: Variables
var location = shared.location // using central value from shared.bicep
var rgName = 'rg-bicepify-demo'
var keyVaultName = 'kv-bicepify-demo'

// MARK: RBAC Entra import example
module resourceGroupShared 'br/public:avm/res/resources/resource-group:0.4.1' = {
  name: '${uniqueString(deployment().name, location)}-${rgName}'
  params:{
    name: rgName
    location: location
    roleAssignments: [
      {
        principalId: shared.entraSecurityGroups.SG_Cloud_Team.objectId // Using imported Entra Security Group Object ID
        roleDefinitionIdOrName: 'Contributor'
      }
    ]
  }
}

// MARK: Key Vault
module keyVault 'br/public:avm/res/key-vault/vault:0.12.1' = {
  name: '${uniqueString(deployment().name, location)}-${keyVaultName}'
  scope: resourceGroup(rgName)
  params: {
    name: keyVaultName
    location: location
    sku: 'standard'
    publicNetworkAccess: 'Disabled' // Selected Networking
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: [
        {
          value: shared.branchOfficePublicIP // using central import value from shared.bicep
          action: 'Allow'
        }
      ]
    }
  }
}
