# Azure Bicep - Resource Derived Types

## Introduction

> [!TIP]
> Check this example out on the Bicep Users Group on LinkedIn to see a code snippet example [here](https://www.linkedin.com/feed/update/urn:li:activity:7360935609323958272?utm_source=share&utm_medium=member_ios&rcm=ACoAABQc0g0BE6cF8NVeQPgDN4PQqnuxftB0rTE)

Resource-derived types in Azure Bicep allow you to define the shape of an object or parameter based on the schema of an existing Azure resource. This enables you to ensure your parameters or variables match the exact structure expected by Azure resources, improving type safety and maintainability.

This can be useful when you ***don't*** need a custom type enforced and instead can rely on the resource built-in type instead. This will reduce code making sure you only use a user defined type for custom data structures.

## 📃 Benefits of Resource Derived Types

✅ Type Safety: Resource-derived types ensure your objects match the schema of Azure resources, reducing misconfiguration risk.

✅ Maintainability: If the resource schema changes, your Bicep code can automatically stay in sync by referencing the resource type.

✅ Intellisense: VS Code Bicep IntelliSense provides completions and validation based on the derived type, making authoring easier.

## Resource Derived Type Example

In this example, you’ll use resource-derived types with the `resourceInput<>` helper to define parameters that match the allowed values for a Storage Accounts `SKU` and `kind`.

```bicep
targetScope = 'resourceGroup'

// Parameters
@description('The SKU type for the storage account using the resource providers derived type.')
param storageSkuType resourceInput<'Microsoft.Storage/storageAccounts@2024-01-01'>.sku.name

@description('The kind of the storage account using the resource providers derived type.')
param storageKindType resourceInput<'Microsoft.Storage/storageAccounts@2024-01-01'>.kind

// Resources
resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: 'st${uniqueString(resourceGroup().id)}'
  location: resourceGroup().location
  sku: {
    name: storageSkuType
  }
  kind: storageKindType
}
```

By using `resourceInput<>`, the parameters `storageSkuType` and `storageKindType` are always validated against the allowed values for the specified Storage Account API version. This provides strong type safety. If you go to the `main.bicepparam` file in VS Code (with the Bicep extension) you will see you get autocompletions for the types taken directly from the resource provider. Very cool!

## 🚀 Test

> [!NOTE]
> This example does not require a deployment. Rather showing that the intellisense now will autocomplete based on the derived type resource input.

- Go to the `main.bicepparam` file
- Select SKU param and press `cntrl+enter` to bring up the Bicep extensions autocomplete list. This list is being pulled from the resourceInput by the resource provider property.
