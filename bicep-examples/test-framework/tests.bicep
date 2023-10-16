// Rios Engineer - Bicep Test Framework
test mainTest 'main.bicep' = {
  params: {
    kind: 'storageV2'
    location: 'uksouth'
  }
}

test mainTestFail 'main.bicep' = {
  params: {
    kind: 'BlobStorage'
    location: 'northeurope'
  }
}
