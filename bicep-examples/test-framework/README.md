# Bicep Test Framework 🧪

## [Blog post - Bicep Test Framework](https://rios.engineer/exploring-the-bicep-test-framework-%f0%9f%a7%aa/)

## Introduction

The Bicep Test Framework is a fail fast mechanism to enable Bicep adopters to have a testing experience that shifts further left to the client side (e.g. in VSCode and in CI/CD pipelines).

The focus of the test framework is to help Bicep users validate without the need to go the Azure Resource Manager (ARM) to get the results.

I'd recommend reading the blog post above to gain a deeper insight.

## ✅ How does this benefit Bicep?

- 👉 Shift left - move testing client side and remove the wait time on long deployments that fail mid-way through due to errors/misconfigurations

- 👉 Validate before deployment – we don’t need to go to ARM for validations

- 👉 Unit testing – Incorporate the tests to CI/CD pipelines

- 👉 Reduce errors/typos – Tests can guard from misconfigurations and typos on things like naming errors

## ⚗️ How it works

## Assertion

Within your `main.bicep` file we are able to create an `assertion` statement. This consists of an `assert` keyword syntax and the assertion must be `Boolean` which means the return values can only be a true or false.

In the example `main.bicep`, we can see the `locationUk` assert statement is used to calculate if the region contains the keyword `uk` therefore, matching UK South or UK West Azure regions in a true or false return for the regions that do not include the contains statement.

## Test Framework

For the testing file we're able to draw on our assertion statements to conclude if they match the parameter values that we want to validate with from their true or false statements.

In the example we can see a successful test block and a failure test block for demostatration purposes. 

If we are to try and deploy a resource in the `northeurope` region the test block would validate that it does not match the boolen true/false statement from the assertion and fail the test.

## 💡 How to get started

Make sure your Azure Bicep version is up to date.

Azure CLI (recomended approach as Bicep CLI is built-in):

```bash
az bicep upgrade
az bicep test filename.bicep
```

PowerShell / Bicep CLI:

```PowerShell
winget upgrade -e --id Microsoft.Bicep
bicep test filename.bicep
```
