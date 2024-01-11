# Azure Bicep - Metadata & Descriptions

## Introduction

Whether you're starting your Azure Bicep journey and want to align to best practice methods straight from the get go, or you have existing templates that could do with a freshen up - descriptions and metadata has a place in your Azure Bicep templates.

## 📃 Benefits of using metadata and descriptions in your Azure Bicep files

1. ✅ Reusability. By defining the `@description` for the parameters other engineers can quickly understand the template and what function each parameter and variable is

2. ✅ Accountability. By defining the `metadata =` information we're able to define the Azure Bicep name, description and business/team ownership for maintain the module (if applicable. Otherwise this is good just to describe the modules purpose)

3. ✅ Best practice. It's good practice to have metadata and descriptions in your Azure Bicep files. It offers a consistent experience for everyone, and incorporates the above benefits that align into the best practice model

> [!TIP]
> You can hover over parameters in your .bicepparam file to get the parameter description information.

## 🚀 Deployment

> [!NOTE]  
> Metadata and descriptions decorators are just for the Azure Bicep file and have no bearing on deployment resources, however, as with all the examples there is a real world example deployment to accommodate the concept to bring the picture full circle.

In VisualStudio Code open a terminal and run:

CLI

```bash
az login
az account set --subscription 'subscription name or id'
az deployment sub create --confirm-with-what-if -l 'uksouth' -f .\metadata-example.bicep -p .\metadata-example.bicepparam
```

or PowerShell

```powershell
Connect-AzAccount
Set-AzContext -Subscription "subscription name or id"
New-AzDeployment -Confirm -Location "UKSouth" -TemplateFile ".\metadata-example.bicep" -TemplateParameterFile ".\metadata-example.bicepparam"
```
