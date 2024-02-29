targetScope = 'resourceGroup'

metadata name = 'Virtual Network with Subnet loop'
metadata description = 'Showcasing Azure Bicep iterative loops - basic example'
metadata owner = 'networks@example.com'

@description('Azure region for deployments chosen from the resource group.')
param location string = resourceGroup().location

@description('The Virtual Network and subnet address spaces & names.')
var vnets = [
  {
    name: 'vnet-uks-bicepify-dev'
    addressPrefix: '10.0.0.0/21'
    subnets: [
      {
        name: 'sql'
        subnetPrefix: '10.0.1.0/24'
      }
      {
        name: 'backend'
        subnetPrefix: '10.0.2.0/24'
      }
      {
        name: 'app-service'
        subnetPrefix: '10.0.3.0/26'
      }
    ]
  }
]

// Virtual Network with subnet loop
resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = [for vnet in vnets: {
  name: vnet.name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet.addressPrefix
      ]
    }
    subnets: [for subnet in vnet.subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.subnetPrefix
      }
    }]
  }
}]
