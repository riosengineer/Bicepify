// Rios Engineer - Shared variable patterns
@description('Naming standards prefix JSON config file. Loads prefixes for Azure resources using {$namingPrefixes.Name}.')
var namingPrefixes = loadJsonContent('./configs/naming-config.json')

@description('Deployment location for resources.')
param location string = 'uksouth'

@description('Virtual Network Address space.')
param vnetAddressPrefix string = '10.1.0.0/16'

@description('Virtual Network Address space.')
param snetAddressPrefix string = '10.1.1.0/24'

module storage_prefix 'br/public:storage/storage-account:3.0.1' = {
  name: 'storage_deploy'
  params:{
    name: '${namingPrefixes.storagePrefix}riosengineer001'
    sku: 'Standard_LRS'
    kind: 'StorageV2'
    location: 'uksouth'
  }
}

module pip_prefix 'br/public:network/public-ip-address:1.0.2' = {
  name: 'pip_deploy'
  params: {
    name: '${namingPrefixes.pipPrefix}-prefix-demo'
    location: location
    domainNameLabel: 'pip-demo'
  }
}

module vnet 'br/public:network/virtual-network:1.1.3' = {
  name: 'vnet_deploy'
  params:{
    name: '${namingPrefixes.vnetPrefix}-prod-uks-001'
    addressPrefixes: [
      vnetAddressPrefix
    ]
    subnets:[
      {
        name: '${namingPrefixes.subnetPrefix}-rios-demo'
        addressPrefix: snetAddressPrefix
      }
    ]
  }
}

// Output resource names
output storage string = storage_prefix.outputs.name
output pip string = pip_prefix.outputs.name
output vnet string = vnet.outputs.name
output snet array = vnet.outputs.subnetNames
