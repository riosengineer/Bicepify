# Azure Bicep - Validate Decorator

## Introduction

The `@validate()` decorator in Azure Bicep allows you to add custom validation logic to your parameters. This enables you to enforce complex constraints that go beyond basic type checking, catching configuration errors at deployment time with clear error messages.

This feature was released in [Bicep v0.32](https://github.com/Azure/bicep/releases/tag/v0.32.4) as an experimental feature.

## 📃 Benefits of the Validate Decorator

✅ **Custom Validation**: Define complex validation rules using lambda expressions that return true or false.

✅ **Clear Error Messages**: Validation errors include your custom message, making it easy to understand what went wrong.

✅ **ARM-Level Enforcement**: Validation is enforced by Azure Resource Manager at deployment time, ensuring invalid configurations are rejected before resources are created.

## ⚗️ Enabling the Experimental Feature

The `@validate()` decorator is currently an experimental feature. To enable it, add the following to your `bicepconfig.json` file:

```json
{
  "experimentalFeaturesEnabled": {
    "userDefinedConstraints": true
  }
}
```

## Example

In this example, the `@validate()` decorator uses a lambda expression to enforce that a CORS allowed origin FQDN does not contain protocol prefixes and is a valid domain format. The template then prepends `https://` to the validated FQDN when configuring the Storage Account CORS rules.

```bicep
@description('Allowed origin FQDN for CORS. Must not contain https:// or http:// prefix.')
@validate(
  x => !contains(x, 'https://') && !contains(x, 'http://') && contains(x, '.'), 
  'The allowed origin FQDN must not contain "https://" or "http://" prefix and must be a valid domain name.'
)
param allowedOriginFqdn string
```

The lambda syntax `x => expression` allows you to reference the parameter value within the validation expression. You can combine multiple conditions using logical operators like `&&` (and) and `||` (or).

> [!IMPORTANT]
> The `@validate()` decorator is enforced at **ARM deployment time**, not at Bicep compile time. This means you need to deploy the template to see validation errors. If you want alternative options ahead of ARM engine deployment, look at the Bicep Test Framework and the `fail()` function.

### Validation Error Example

If you were to deploy with an invalid value like `https://app.contoso.com`, ARM would reject the deployment with an error similar to:

```plaintext
{"code": "InvalidTemplate", "message": "Deployment template validation failed: The template parameter 'allowedOriginFqdn' failed validation. The allowed origin FQDN must not contain \"https://\" or \"http://\" prefix and must be a valid domain name."}
```

This enables authors to define meaningful validation messages that surface during deployment, providing clear guidance on how to resolve the issue.

## 🚀 Deployment

> [!NOTE]  
> You need to have a resource group deployed before trying this out.

In Visual Studio Code open a terminal and run:

CLI

```bash
az login
az account set --subscription 'subscription name or id'
az deployment group create -g 'your-rg' --confirm-with-what-if -f './main.bicep' -p 'main.bicepparam'
```

or PowerShell

```powershell
Connect-AzAccount
Set-AzContext -Subscription "subscription name or id"
New-AzResourceGroupDeployment -Confirm -ResourceGroup "your-rg" -TemplateFile "main.bicep" -TemplateParameterFile "main.bicepparam"
```
