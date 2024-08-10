// Rios Engineer - Bicep Test Framework
test mainTest 'main.bicep' = {
  params: {
    stName: 'stbicepifydemo001'
    kind: 'storageV2'
    location: 'uksouth'
  }
}

test mainTestFail 'main.bicep' = {
  params: {
    stName: 'stbicepifydemo001'
    kind: 'BlobStorage'
    location: 'northeurope'
  }
}
