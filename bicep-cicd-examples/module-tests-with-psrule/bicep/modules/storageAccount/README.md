# Storage Account Module

Storage Account Bicep standard for deployments

Storage Account Bicep Module

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
location       | Yes      | Azure region of the deployment
tags           | Yes      | Tags to add to the resources
storageName    | Yes      | Name of the storage account
storagePleBlobName | Yes      | Name of the storage blob private link endpoint
storagePleFileName | Yes      | Name of the storage file private link endpoint
subnetId       | Yes      | Resource ID of the subnet
virtualNetworkId | Yes      | Resource ID of the virtual network
storageSkuName | Yes      | Storage SKU

### location

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Azure region of the deployment

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Tags to add to the resources

### storageName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Name of the storage account

### storagePleBlobName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Name of the storage blob private link endpoint

### storagePleFileName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Name of the storage file private link endpoint

### subnetId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Resource ID of the subnet

### virtualNetworkId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Resource ID of the virtual network

### storageSkuName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Storage SKU

- Allowed values: `Standard_LRS`, `Standard_ZRS`, `Standard_GRS`, `Standard_GZRS`, `Standard_RAGRS`, `Standard_RAGZRS`, `Premium_LRS`, `Premium_ZRS`

## Outputs

Name | Type | Description
---- | ---- | -----------
storageId | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "bicep/modules/storageAccount/storageAccount.json"
    },
    "parameters": {
        "location": {
            "value": ""
        },
        "tags": {
            "value": {}
        },
        "storageName": {
            "value": ""
        },
        "storagePleBlobName": {
            "value": ""
        },
        "storagePleFileName": {
            "value": ""
        },
        "subnetId": {
            "value": ""
        },
        "virtualNetworkId": {
            "value": ""
        },
        "storageSkuName": {
            "value": ""
        }
    }
}
```
