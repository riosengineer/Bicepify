# Azure Bicep - Fail Function

## Introduction

The `fail()` function in Bicep allows you to stop deployments with custom error messages when conditions are not met. This is useful for enforcing business rules, validating parameters, and ensuring proper configuration before resources are deployed.

## 📃 Benefits of the Fail Function

✅ **Early Validation**: Catches configuration errors before Azure resources are created.

✅ **Clear Error Messages**: Provides custom, descriptive error messages.

✅ **Enforces Standards**: Ensures naming conventions and business rules are followed consistently.

✅ **Prevents Runtime Issues**: Stops deployments that would fail to function properly.

## Examples

### Storage Account Naming Convention

Ensures storage account names start with "st" prefix. The fail function here is populating the `storageAccountNameChecked` var with our fail condition, if the `storageAccountName` value does not start with the value from `storageAccountPrefix` then it will fail pre-deployment.

```bicep
var storageAccountPrefix = 'st'
var storageAccountNameChecked = startsWith(storageAccountName, storageAccountPrefix)
  ? storageAccountName
  : fail('The storage account name must start with "${storageAccountPrefix}".')
```

### Web App Runtime Validation

Ensures runtime stack is specified. With Web Apps, you can technically deploy them without any runtime specified and ARM will return a successful deployment. However, the web app will not be functional as the runtime and stack are not set (e.g. DOTNET version 9.0). By adding a fail function to check if the parameter is set, you can fail pre-deployment with your custom error message.

```bicep
var varRuntime = empty(trim(runtime)) ? fail('The runtime parameter must not be empty.') : runtime
```

## 🚀 Deployment

In Visual Studio Code open a terminal and run:

CLI

```bash
az login
az account set --subscription 'subscription name or id'
az deployment group create -g 'your-rg' --confirm-with-what-if -f './storage.bicep' -p 'storage.bicepparam'
// amend to webApp.bicep / webApp.bicepparam to test that example
```

or PowerShell

```powershell
Connect-AzAccount
Set-AzContext -Subscription "subscription name or id"
New-AzResourceGroupDeployment -Confirm -ResourceGroup "your-rg" -TemplateFile "storage.bicep" -TemplateParameterFile "storage.bicepparam"
// amend to webApp.bicep / webApp.bicepparam to test that example
```