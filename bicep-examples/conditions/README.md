# Azure Bicep - Conditions

## Introduction

This example will showcase conditional resource deployments with Azure Bicep. There are two examples presented, the first being 'if' expression and then an if/else condition. You can read more from the Microsoft docs [here](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/conditional-resource-deployment).

## 📃 Benefits of using conditions in Azure Bicep

1. ✅ Dynamic resource deployment. Allows to set boolean values to true/false to determine if a resource should be deployed or not depending on requirements.

2. ✅ Environment conditions. We can specific different Azure SKU tiers depending on the environment selected.

3. ✅ Flexible Bicep template. By adding conditions we're able to increase the reusability and flexibility of a Bicep template based on specific constraints.

> [!WARNING]  
> There are some limitations with (if) conditions, these are highlighted in the Microsoft documentation linked above.

## Examples

### If condition

Taking a snippet from the `main.bicep` file, notice the `deployResource` parameter which is set as a boolean value to be evaluated. In the file, it's set to `true` which means the Key Vault will be deployed. If set to `false` the module block for the Key Vault will determine it does not need to be deployed.

The `= if (deployResource)` is the Bicep code added to determine this in the module code block. It is calling the boolean parameter and evaluating it's true/false state.

```javascript
@description('Deploy Azure Key Vault true/false.')
param deployResource bool = false

module KeyVault 'br/public:security/keyvault:1.0.2' = if (deployResource) {
name: '${uniqueString(deployment().name, location)}-${kvName}'
  params: {
    name: kvName
    location: location
    skuName: kvSku
    enableSoftDelete: true
  }
}
````

### If/else condition

Using an if/else condition can be useful to determine if we need to deploy to a different SKU tier depending on requirements, such as production vs dev. However, it is not limited to this scenario. It can be used for any values that fit your deployment constraints.

By specifying a variable called `kvSku` we're able to evaluate the parameter `kvEnv` to check if this contains `prod` then set the Key Vault SKU to `premium` else, set to `standard`. Later in the Key Vault module block the `skuName: kvSku` is how this is assigned within the module.

```javascript
@description('Azure Key Vault organisation environment.')
@allowed([
  'prod'
  'preprod'
  'dev'
])
param kvEnv string = 'prod'

// Environment variable for Key Vault SKU else if
var kvSku = kvEnv == 'prod' ? 'premium' : 'standard'
```

## 🚀 Deployment

> [!NOTE]  
> You need to have a resource group deployed before trying this out.

In VisualStudio Code open a terminal and run:

CLI

```bash
az login
az account set --subscription 'subscription name or id'
az deployment group create -g 'your-rg' --confirm-with-what-if -f '.\main.bicep'
```

or PowerShell

```powershell
Connect-AzAccount
Set-AzContext -Subscription "subscription name or id"
New-AzResourceGroupDeployment -Confirm -ResourceGroup "your-rg -TemplateFile "main.bicep"
```
