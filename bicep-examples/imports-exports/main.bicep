
// Imports
import * as shared from 'shared.bicep'
// import { location } as location from 'shared.bicep' to only import a specific var or type from the file.

module entraRbac 'br/public:avm/ptn/authorization/role-assignment:0.2.2' = {
    name: '${uniqueString(deployment().name, location)}'
    params: {
      principalId: shared.entraSecurityGroups.SG_Cloud_Team.objectId
      roleDefinitionIdOrName: 'Reader'
      subscriptionId: subscription().subscriptionId
    }
  }