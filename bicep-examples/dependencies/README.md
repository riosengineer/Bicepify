# Resource dependencies in Azure Bicep 🦾

There's two types of dependencies `implicit` and `explicit` in Azure Bicep. Within the `main.bicep` file example you'll notice many implicit and some explicit dependencies that you can review as a real example of how these two play a role in your Azure Bicep deployments.

> [!TIP]
> If you're interested in this examples solution and what it does then there is more information in this template repo [here](https://github.com/riosengineer/bicep-quickstart-frontdoor-private-endpoint-appservice) with supporting documentation and architectural drawing.

## Implicit 🔗

With `implicit` dependencies we are referencing another Azure resource within the same deployment, which means we'll not need to declare an explicit dependency. There are two common ways this is accomplished. For example:

```javascript
module appInsights 'modules/appInsights/appinsights.bicep' = {
  name: '${uniqueString(deployment().name, location)}-appInsights'
  params: {
    name: appInsightsName
    location: location
    workspaceResourceId: logAnalytics.outputs.id
    kind: 'web'
    applicationType: 'web'
  }
}
```

Note the `logAnalytics.outputs.id` symbolic name defined is referencing a previous module for this resources properties. This is how an implicit dependency is created and ARM will deploy in resources in their dependent order.

```javascript
resource frontDoorOriginGroup 'Microsoft.Cdn/profiles/originGroups@2021-06-01' = {
  name: frontDoorOriginGroupName
  parent: frontDoorProfile
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
    }
    healthProbeSettings: {
      probePath: '/'
      probeRequestType: 'HEAD'
      probeProtocol: 'Http'
      probeIntervalInSeconds: 100
    }
  }
}
```

Lastly, notice the `parent:` property defined in this Azure Front Door resource block above, where it's defining the symbolic name from the Azure CDN profile object. This is also an implicit dependency created between the two objects.

## Explicit 🖇️

```javascript
resource frontDoorProfile 'Microsoft.Cdn/profiles@2021-06-01' = {
  name: frontDoorProfileName
  location: 'global'
  sku: {
    name: frontDoorSkuName
  }
  dependsOn: [
    webApp
    webAppPlan
  ]
}
```

For explicit dependencies, we can use the `dependsOn` property to describe explicitly which resources we want this deployment to depend on.

In the case above, I don't want my Front Door deployment to start before the App service and App Plan have been deployed first, as I need them to exist for my origin backend.

## Deployment 🚀

> [!WARNING]  
> This example deploys Azure Front Door Premium SKU which is circa $300 for the month. Do not leave running if you don't want to incur charges. Make sure to delete as soon as possible after deployment and you'll likely see very minimal costs.

Define the parameters in the top of the file before deploying.

In VisualStudio Code open a terminal and run:

CLI

```bash
az login
az set --subscription 'your subscription name'
az deployment create --confirm-with-what-if -g 'your resource group name' -f .\main.bicep 
```

or PowerShell

```powershell
Connect-AzAccount
Set-AzContext -Subsription "your subsription name"
New-AzResourceGroupDeployment -Confirm -ResourceGroup "your resource group name" -TemplateFile "main.bicep"
```
