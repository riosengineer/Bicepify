// Test with only required parameters
module test_required_params '../storageAccount.bicep' = {
  name: 'test_required_params'
  params: {
    location: 'uksouth'
    tags: {
      Demo: 'Rios Engineer Blog'
    }
    storageName: 'riosengineerst001'
    storageSkuName: 'Standard_GRS'
    storagePleBlobName: 'someBlob'
    storagePleFileName: 'someFileshare'
    subnetId: 'test'
    virtualNetworkId: 'test'
  }
}
