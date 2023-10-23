# Bicep Test Modules - Folder structure & examples

## [https://rios.engineer/bicep-modules-with-psrule-testing-documentation-ci-pipeline-examples/](https://rios.engineer/bicep-modules-with-psrule-testing-documentation-ci-pipeline-examples/)

## Introduction

In this example you can get some insight on how to:

- Structure your Git repository with Bicep modules
- How to create a 'test' file to scan PSRule with
- How you can create documentation for your Bicep modules
- Why you should consider testing in this method vs scanning your templates directly

For a deeper dive on some of the above bullet points I would recommend reading the blog post attached.

## What is PSRule?

PSRule for Azure helps you identify and remediate issues surrounding Azure best practices in your Azure Bicep code. This results in improved quality of solutions deploy to Azure and better IaC templates that align to the [Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/).

## Modules Folder Structure - Example

The folder structure should resemble the following for the CI pipeline and PSRule to work as intended. With this layout, we can use the `ps-rule.yaml` configuration file to scan only the `*.tests.bicep` files as part of the CI pipeline as the tests file will have the required parameter defined. This results in a more reliable CI experience.

```json
└── bicep/
    └── modules/
        ├── storageAccount/
        │   └── .tests/
        │       └── storageAccount.tests.bicep
        ├── storage.bicep
        └── metadata.json
```

## Bicep Modules test file - Example

The `.tests.bicep` file will have the required parameters defined for PSRule to scan the module code. The module is called in-line from the `\modules` folder in this directory, for example:

```javascript
// Test with only required parameters
module test_required_params '../storageAccount.bicep' = {
  name: 'test_required_params'
  params: {
    location: 'uksouth'
    tags: {
      Demo: 'Rios Engineer Blog'
    }
    storageName: 'riosengineerst001'
    storageSkuName: 'Standard_GRS'
    storagePleBlobName: 'someBlob'
    storagePleFileName: 'someFileshare'
    subnetId: 'test'
    virtualNetworkId: 'test'
  }
}
```

## Bicep Module documentation - Example

The `metadata.json` file is to contain some basic summary information and description of the module. This is so the PowerShell script in `.scripts\` can be ran and uses this metadata to create a `README` file for the module (example README.md output in the `\storageAccount` folder).

```json

    {
        "itemDisplayName": "Storage Account Module.",
        "description": "Storage Account Bicep Module",
        "summary": "Storage Account Bicep standard for deployments"
    }

```

## Continuous Integration pipeline

There is an example CI pipeline `azure-devops-psrule-ci.yaml` and `github-actions-psrule-ci.yaml` files which you can review and use as part of your build validation pipelines for either Azure DevOps or GitHub. For ADO once the file is created within the repository, you can use it as the [build pipeline](https://learn.microsoft.com/en-us/azure/devops/repos/git/branch-policies?view=azure-devops&tabs=browser#build-validation).

For GitHub Actions, you can follow the documentation if you need a step-by-step [here](https://docs.github.com/en/actions/quickstart).

## PSRule configuration

Lastly, the `ps-rule.yaml` file defines our PSRule scan configuration. Using this file we can define the tests file path for scanning.

Snippet taken from the file:

```yaml
input:
  pathIgnore:
  # Ignore common files that don't need analysis.
  - "**/bicepconfig.json"
  - "*.yaml"
  - "*.yml"
  - "*.md"
  - "*.ps1"

  # Exclude Bicep module files.
  - "bicep/modules/**/*.bicep"

  # Exclude JSON module files.
  - "bicep/modules/**/*.json"

  # Include bicep files from modules.
  - "!bicep/modules/**/.tests/*.bicep"
```

This enables the test files to be scanned for Azure best practice. As the tests file have the required parameters defined PSRule can run the scan against the values.

There is a lot of fantastic documentation around this [here](https://azure.github.io/PSRule.Rules.Azure/setup/configuring-options/).

There is more detailed information in the attached blog post with a full demo on this setup.
