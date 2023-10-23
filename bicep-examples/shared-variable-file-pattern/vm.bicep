// Rios Engineer - Shared variable patterns
@description('Global VM JSON config file.')
var compute = loadJsonContent('./configs/vm-config.json', 'winSvr2022')

@description('Naming standards prefix JSON config file. Loads prefixes for Azure resources using {$namingPrefixes.Name}.')
var naming = loadJsonContent('./configs/naming-config.json')

@description('Deployment location for resources.')
param location string = resourceGroup().location

// Windows Global Config
var image = compute.imageReference
var sku = compute.VMSku.size

// Naming standards
var vmPrefix = naming.virtualMachinePrefix
var nicPrefix = naming.nicPrefix
var pipPrefix = naming.pipPrefix

// Prefix names
var vmName = '${vmPrefix}-demo'
var nic = '${nicPrefix}-rios-demo'
var pip = '${pipPrefix}-rios-demo'
var snet = subnet.id

@description('Username for the Virtual Machine.')
param adminUsername string

@description('Password for the Virtual Machine.')
@minLength(12)
@secure()
param adminPassword string
/*
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2020-06-01' existing = {
  name: 'vnet-prod-uks-001'

}*/

// add your own demo virtual network and subnet here 
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2020-06-01' existing = {
  name: 'vnet-prod-uks-001/snet-rios-demo' 
}

  resource publicIP 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
    name: pip
    location: location
    properties: {
      publicIPAllocationMethod: 'Dynamic'
    }
  }
  resource networkInterface 'Microsoft.Network/networkInterfaces@2020-06-01' = {
    name: nic
    location: location
    properties: {
      ipConfigurations: [ {
          name: 'ipconfig1'
          properties: {
            privateIPAllocationMethod: 'Dynamic'
            subnet: {
              id: snet
            }
            publicIPAddress: {
              id: publicIP.id
            }
          }
        } ]
    }
  }
  resource virtualMachine 'Microsoft.Compute/virtualMachines@2020-06-01' = {
    name: vmName
    location: location
    properties: {
      hardwareProfile: {
        vmSize: sku
      }
      osProfile: {
        computerName: vmName
        adminUsername: adminUsername
        adminPassword: adminPassword
      }
      storageProfile: {
        imageReference: {
          offer: image.Offer
          publisher: image.publisher
          sku: image.sku
          version: image.version
        }
        osDisk: {
          createOption: 'FromImage'
        }
      }
      networkProfile: {
        networkInterfaces: [ {
            id: networkInterface.id
          } ]
      }
    }
  }

output vm string = virtualMachine.name
output os object = virtualMachine.properties
