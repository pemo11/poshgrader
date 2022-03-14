<#
 .Synopsis
 Contains several functions for dealing with submissions
#>

$Psd1Path = Join-Path -Path $PSScriptRoot -ChildPath "graderconfig.psd1"
$Config = import-powershelldataFile -Path $Psd1Path

<#
 .Synopsis
 Run all actions for a single submission
#>
function New-TestSubmission
{

}

<#
 .Synopsis
 Get the names of all files for an exercise
#>
function Get-ExerciseFile
{
    [CmdletBinding()]
    param([String]$SubmissionPath, [String]$Exercise, [String]$Level="A")
    $XmlPath = $Config.gradingPlanPath
    $Ns = @{"sig"="urn:simpleGrader"}
    $XPathExpr = "//sig:task[@exercise='$Exercise' and @level='$Level']/files/file"
    Select-Xml -Path $XmlPath -XPath $XPathExpr -Namespace $Ns | 
     Select-Object -ExpandProperty node
}

<#
 .Synopsis
 Get all files from a submission file
#>
function Get-SubmissionFile
{
    [CmdletBinding()]
    param([String]$SubmissionPath)
    $ModuleName = $Config.ModuleName
    # Create temp directory
    $TempPath = Join-Path -Path $env:TEMP -ChildPath $ModuleName
    if (!(Test-Path -Path $TempPath))
    {
        mkdir $TempPath | Out-Null
    } else
    {
        # Delete all files to avoid confusion
        Remove-Item -Path $TempPath\* -Force -Recurse
    }
    # Expand archive
    Expand-Archive -Path $SubmissionPath -DestinationPath $TempPath
    # Add file name to path
    $TempPath = Join-Path -Path $TempPath -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension($SubmissionPath))
    Get-ChildItem -Path $TempPath -Filter "*.java"
}

<#
 .Synopsis
 Tests of file completeness based on the grading plan
#>
function Test-Submission
{
    [CmdletBinding()]
    param([String]$SubmissionPath, [String]$Exercise, [String]$Level="A")
    $ExFiles = Get-ExerciseFile -Exercise $Exercise -Level $Level
    $SubFiles = Get-SubmissionFile -SubmissionPath $SubmissionPath
    $ExFiles.Count -eq $SubFiles.Count
}