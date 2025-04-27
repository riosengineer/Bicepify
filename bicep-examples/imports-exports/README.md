# Azure Bicep - Imports and Exports

## Introduction

The import and export feature in Bicep allows you to resuse commonly used variables. Exports allows you to define variables to be exported for use elsewhere in other templates. Imports let you pull in variables pre-defined elsewhere, so you don’t have to duplicate code. 

This approach keeps your templates tidy, consistent, and easier to manage as your environment grows.

## 📃 Benefits of User Defined Types

✅ Centraliation: Allows you to define commonly repeated variables and user defined types in one file that many Bicep templates can reuse.

✅ Reduces repetition: Variables you may be repeating in each Bicep template can now be moved centrally, reducing repetition and streamlining templates.

✅ Resuability: The exports can now be used across multiple projects and templates allowing much greater resuability for standards and common values.

## Export Example

## Import Example

## 🚀 Deployment

> [!NOTE]  
> You need to have a resource group deployed before trying this out.

In VisualStudio Code open a terminal and run:

CLI

```bash
az login
az account set --subscription 'subscription name or id'
az deployment group create -g 'your-rg' --confirm-with-what-if -f '.\main.bicep' -p 'main.bicepparam'
```

or PowerShell

```powershell
Connect-AzAccount
Set-AzContext -Subscription "subscription name or id"
New-AzResourceGroupDeployment -Confirm -ResourceGroup "your-rg" -TemplateFile "main.bicep" -TemplateParameterFile "main.bicepparam"
```
