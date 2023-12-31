# Bicep Scoped Deployments

## Introduction

One of the potential drawbacks seen with Bicep vs other declarative languages like Terraform is that we have scoped deployments. This refers to different target scopes for the resources which consists of:

- resourceGroup (Default target)
- subscription
- managementGroup
- tenant

Whereas the likes of Terraform does not have this concept so it is not a concern when building our code.

In Bicep, we have to declare our `targetScope` in the file for deployment of the resources. We can't deploy a management group in a Bicep file that has a resource group code due to the differences in target scopes.

This can potentially be slightly confusing when starting out.

For example, do you have separate files for each scope or is there other ways to structure our Bicep file to accommodate multiple deployment scopes under one roof? Lets take a look.

## Benefits of using combined scopes

With the above in mind, we may think we have to split out our files to target different scopes and deploy these independently. However, there are some ways around this which can be leveraged.

For example, we can use a subscription `targetScope` to also deploy resourceGroup scope deployments within the same file. This has some major benefits:

1. Streamlines deployments: can now combine subscription and resourceGroup Bicep code in one file for example

2. Simplifies CI/CD pipeline logic because we can use the `az deployment sub` command to deploy multiple files that otherwise may have had to have logic deciding if they need to be subscription or resourceGroup cmdlets.

3. Helps reduce the need for additional Bicep files for better house keeping.

Using this concept, we can also do a similar approach with managementGroup scope and using `scope: subscription(subId, rg)` for an existing subscription id and resource group name and corresponding Azure CLI cmdlets.

> [!TIP]
> This concept only works with Bicep modules

## Subscription scope example

In the example `subscription-scope.bicep` we're able to use the `scope: rg_deploy` to specify a resource block name to associate it with where we want to deploy the Storage Account.

```javascript
// Deploy new resource group for later use in same bicep deployment
resource rg_deploy 'Microsoft.Resources/resourceGroups@2022-09-01' = {
name: rg
location: location
}

// Deploy storage account to newly created resource group
module st_deploy 'br/public:storage/storage-account:3.0.1' = {
  scope: rg_deploy
  name: 'storageDeployment'
  params:{
    name: 'stbicepifydemo001'
  }
}
```

## Multi-scope example

Within the `subscription-scope.bicep` file we're using `targetScope = 'subscription'` but using the `scope:` switch we can specify a resource group scope in the file without the need to change the targetScope.

```javascript
module st_deploy2 'br/public:storage/storage-account:3.0.1' = {
  scope: resourceGroup('subscription-guid-here', 'rg-name-here')
  name: 'storageDeployment'
  params:{
    name: 'stbicepifydemo002'
  }
}
```

Similarly, the same concept applies to the other target scopes. Take a look at the `management-scope.bicep` file for a further example.

## Deployment

In VisualStudio Code open a terminal and run:

CLI

```bash
az login
az set --subscription 'our subscription name'
az deployment sub create --confirm-with-what-if -l 'uksouth' -f .\file.bicep 
```

or PowerShell

```powershell
Connect-AzAccount
Set-AzContext -Subscription "our subscription name"
New-AzDeployment -Confirm -Location "UKSouth" -TemplateFile "file.bicep"
```
