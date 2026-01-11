# Azure Bicep - @onlyIfNotExists Decorator

## Introduction

The `@onlyIfNotExists()` decorator in Azure Bicep enables **conditional resource deployment** based on whether a resource with the specified name already exists. When applied to a resource declaration, Azure Resource Manager will only create the resource if one with that name doesn't already exist in the target scope.

It's particularly valuable for deploying resources that should only be created once, such as Key Vault secrets, where you want to avoid overwriting existing values or encountering "resource already exists" errors.

**Key Concept**: The decorator checks only the resource **name** - it does not compare properties or configurations. If a resource with the same name exists, deployment is skipped entirely for that resource, regardless of whether its properties match the template definition.

Learn more about the `@onlyIfNotExists()` decorator in the [official Microsoft Learn documentation](https://learn.microsoft.com/azure/azure-resource-manager/bicep/resource-declaration?WT.mc_id=MVP_319025#onlyifnotexists-decorator).

## ✅ Benefits of Using @onlyIfNotExists

✅ **Prevents Overwriting Critical Data**: Protects existing resources (like secrets with sensitive values) from being accidentally overwritten during redeployment.

✅ **Idempotent Deployments**: Enables truly idempotent templates where multiple executions won't fail or cause unintended changes if resources already exist.

✅ **Simplified Secret Management**: Perfect for one-time secret deployments where you want to set an initial value but never modify it through automation afterward.

✅ **Reduces Deployment Errors**: Eliminates "resource already exists" conflicts in scenarios where you're uncertain whether a resource has been previously deployed.

## ⚗️ Example: Key Vault Secret with @onlyIfNotExists

This example demonstrates deploying an Azure Key Vault and a secret using the `@onlyIfNotExists()` decorator. The Key Vault will always be deployed (or updated), but the secret will **only be created if it doesn't already exist**.

### Bicep Code Snippet

```bicep
// Deploy secret to the Key Vault using @onlyIfNotExists decorator
@onlyIfNotExists()
resource kvSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  name: '${keyVault.outputs.name}/mySecret'
  properties: {
    value: 'SecureValue123!'
  }
}
```

### How It Works

1. **First Deployment**: The secret `mySecret` doesn't exist, so it's created with the value `SecureValue123!`
2. **Subsequent Deployments**: The secret already exists with the same name, so deployment is skipped entirely - the existing value is preserved
3. **Name-Based Check**: Only the secret name is checked; if a secret named `mySecret` exists, it won't be recreated regardless of its current value

### Full Template

The complete `main.bicep` file includes:
- Azure Key Vault deployment using the Azure Verified Modules (AVM) pattern
- A secret resource with the `@onlyIfNotExists()` decorator
- Metadata for resource documentation
- Outputs for the Key Vault name, URI, and secret name

## ⚠️ Important Considerations

### Decorator Placement
The `@onlyIfNotExists()` decorator must be placed **directly above** the resource declaration:

```bicep
@onlyIfNotExists()
resource myResource 'Microsoft.Provider/type@version' = { ... }
```

### Bicep CLI Version Requirement
Requires **Bicep CLI 0.38.0 or later**. Check your version:

```bash
bicep --version
```

### Name-Based Detection Only
The decorator **only checks if a resource with the specified name exists**. It does not:
- Compare resource properties or configurations
- Detect if the existing resource matches your template definition
- Update existing resources with new property values

### Scope Limitations

The existence check is performed within the deployment scope (subscription, resource group, etc.). A resource in a different scope with the same name won't prevent creation.

## 🚀 Deployment

### Prerequisites

- Azure subscription
- Bicep CLI 0.38.0 or later

### Deploy with Azure CLI

```bash
az group create --name rg-onlyIfNotExists-example --location uksouth

az deployment group create \
  --resource-group rg-onlyIfNotExists-example \
  --template-file main.bicep
```

### Deploy with Azure PowerShell

```powershell
New-AzResourceGroup -Name rg-onlyIfNotExists-example -Location uksouth

New-AzResourceGroupDeployment `
  -ResourceGroupName rg-onlyIfNotExists-example `
  -TemplateFile main.bicep
```
