using 'main.bicep'

param storageConf = {
  name: 'stbicepifyudt001'
  sku: 'Standard_LRS'
  location: 'uksouth'
  kind: 'StorageV2'
}
