// Rios Engineer - Public Bicep Registry Example
module public_registry 'br/public:compute/function-app:2.0.1' = {
  name: 'public_registry_example'
  params: {
    name: 'example-func-001'
    location: 'uksouth'
    storageAccountName: 'stsomestorageaccount001'
    storageAccountResourceGroup: 'rg-some-rg-here'
  }
}

// Rios Engineer - Private Bicep Registry Example
module private_registry 'br:bicepify.azurecr.io/bicep/modules/logging:2023-09-29' = {
  name: 'private_registry_example'
  params: {
    parLogAnalyticsWorkspaceLocation: 'uksouth'
    parAutomationAccountLocation: 'uksouth'
    parLogAnalyticsWorkspaceName: 'example-uks-ala-prod'
    parLogAnalyticsWorkspaceSkuName: 'PerGB2018'
    parLogAnalyticsWorkspaceSolutions: [
      'AgentHealthAssessment'
      'AntiMalware'
      'ChangeTracking'
      'Security'
      'SecurityInsights'
      'SQLAdvancedThreatProtection'
      'SQLVulnerabilityAssessment'
      'SQLAssessment'
      'Updates'
      'VMInsights'
    ]
    parAutomationAccountName: 'example-uks-aa-prod'
    parAutomationAccountUseManagedIdentity: true
    parTags: {
      Env: 'Example'
    }
  }
}

// Rios Engineer - Inline Bicep Module Example
module inline_module 'modules/inline/customModule.bicep' = {
  name: 'inline_module_example'
  params:{
    location: 'uksouth'
    tags: {
      Env: 'Example'
    }
    storageName: 'stsomestoragename001'
    storagePleBlobName: 'someblobname'
    storagePleFileName: 'somefilename'
    storageSkuName: 'Standard_LRS'
    subnetId: 'subnetId'
    virtualNetworkId: 'vnetId'
  }
}
