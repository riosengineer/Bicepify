#requires -Modules @{ModuleName='PSDocs';ModuleVersion='0.9.0'}, @{ModuleName='PSDocs.Azure';ModuleVersion='0.3.0'}
# Make sure the below modules are installed:
# Install-Module PSDocs
# Install-Module PSDocs.Azure
# If you have done that before, proceed onto the next steps:
# Create a new metadata.json in the relevant modules folder and fill out some details
# Then to generate ReadMe run the below command example BEFORE PR
# .scripts\bicep-readme.ps1 -templatePath file.bicep -Verbose
<#
===============================================
AUTHOR: Tao Yang
DATE: 02/02/2023
NAME: generateBicepReadme.ps1
VERSION: 1.0.0
COMMENT: Generate Readme.md for Bicep template
===============================================
#>

[CmdletBinding()]
Param
(
  [Parameter(Mandatory = $true, HelpMessage = "Template Path.")]
  [ValidateScript({ test-path $_ -PathType leaf })][String]$templatePath
)

#region functions
Function ValidateMetadata {
  [CmdletBinding()]
  [outputType([boolean])]
  Param
  (
    [Parameter(Mandatory = $true)][String]$metadataPath
  )
  $bValidMetadata = $true
  $requiredAttributes = 'itemDisplayName', 'description', 'summary'
  If (Test-Path $metadataPath) {
    try {
      $metadata = Get-Content $metadataPath -Raw | convertFrom-Json
      Foreach ($attribute in $requiredAttributes) {
        if (!$($metadata.$attribute) -or $($($metadata.$attribute).length) -eq 0) {
          Write-Error "Metadata is missing attribute: $attribute or $attribute is empty"
          $bValidMetadata = $false
          break
        }
      }
    } catch {
      $bValidMetadata = $false
    }
  } else {
    $bValidMetadata = $false
  }
  $bValidMetadata
}

Function BicepBuild {
  [CmdletBinding()]
  Param
  (
    [Parameter(Mandatory = $true)][String]$bicepPath
  )
  $bicepDir = (Get-Item -Path $bicepPath).DirectoryName;
  $bicepFileBaseName = (Get-Item -Path $bicepPath).BaseName
  $outputFile = Join-Path $bicepDir "$bicepFileBaseName`.json"
  Write-Verbose "Building ARM template $outputFile from Bicep file $bicepPath"
  az bicep Build --file $bicepPath --outfile $outputFile
  $outputFile
}
#endregion
#region main
$docName = "README"
$currentDir = $PWD
Write-Output "Current working directory '$currentDir'"
$templateDir = (Get-Item -Path $templatePath).DirectoryName;
Write-Verbose "Template Directory '$templateDir'"
set-location $templateDir
Write-Verbose "Detecting git root directory"
$gitRootDir = invoke-expression 'git rev-parse --show-toplevel' -ErrorAction SilentlyContinue
if ($gitRootDir.length -gt 0) {
  Write-Verbose "Git root directory '$gitRootDir'"
} else {
  Write-Verbose "Not a git repository"
}
set-location $currentDir
Import-Module PSDocs.Azure;

$metadataPath = Join-Path $templateDir 'metadata.json';
Write-Verbose "metadata.json file path: '$metadataPath'"
#Validate metadata'
$ValidMetaData = ValidateMetadata -metadataPath $metadataPath

#Convert Bicep to ARM template if input file is bicep
$removeARM = $false
if ((get-item $templatePath).Extension -ieq '.bicep') {
  Write-Verbose "Comping bicep file $templatePath to ARM template"
  $tempPath = BicepBuild -bicepPath $templatePath
  $removeARM = $true
} else {
  $tempPath = $templatePath
}
Write-Verbose "Generating Document for $tempPath"
if ($ValidMetaData) {
  Get-AzDocTemplateFile -Path $tempPath | ForEach-Object {
    # Generate a standard name of the markdown file. i.e. <name>_<version>.md
    $template = Get-Item -Path $_.TemplateFile;

    # Generate markdown
    Invoke-PSDocument -Module PSDocs.Azure -OutputPath $templateDir -InputObject $template.FullName -InstanceName $docName -Culture en-GB

  }
} else {
  Throw "Invalid metadata in $metadataPath"
  Exit -1
}
$outputFilePath = join-path $templateDir "$docName`.md"
If (Test-Path $outputFilePath) {
  if ($gitRootDir.length -gt 0) {
    # replace the git root dir with a relative path in generated markdown file
    Write-Verbose "replacing git root dir '$gitRootDir' with '.' in generated markdown file '$outputFilePath'"
    (Get-Content $outputFilePath -Raw) -replace $gitRootDir, '.' | Set-Content $outputFilePath
  }

  Write-Output "Generated document '$outputFilePath'"
} else {
  Write-Error "'$outputFilePath' not found"
}
#Remove temp ARM template if required
if ($removeARM) {
  Write-Verbose "Remove temp ARM template $tempPath"
  Remove-Item -Path $tempPath -Force
}
#endregion