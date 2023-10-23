using './main.bicep'

@description('Deployment location for resources.')
param location = 'uksouth'

@description('Storage account resource SKU.')
param kind = 'storageV2'
