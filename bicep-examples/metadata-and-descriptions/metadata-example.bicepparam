using 'metadata-example.bicep'

// Hover over the param to see their descriptions pulled from the main bicep file
param parLocation = 'uksouth'
param parResourceGroupName = 'rg-uks-test-prod'
param parTags = {
  metadata: 'test'
}
