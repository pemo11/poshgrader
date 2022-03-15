<#
 .Synopsis
 The core functions for dealing with submissions
#>

using module ./PoshgraderClasses.psm1

$Psd1Path = Join-Path -Path $PSScriptRoot -ChildPath "graderconfig.psd1"
$Config = import-powershelldataFile -Path $Psd1Path

$Psm1Path = Join-Path -Path $PSScriptRoot -ChildPath "JavaActions.psm1"
Import-Module -Name $Psm1Path -Force

<#
 .Synopsis
 Gets all the actions and tests from a grading plan
#>
function Get-Gradingplan
{
    [CmdletBinding()]
    param([String]$Path)
    $XpathExpr = "//actions"
    $Ns = @{"sig"=""}
    $Actions = Select-Xml -Path $Path -XPath $XpathExpr -Namespace $Ns |
     Select-Object -ExpandProperty Node | Select-Object -ExpandProperty Action
    $XpathExpr = "//tests"
    $Tests = Select-Xml -Path $Path -XPath $XpathExpr -Namespace $Ns |
     Select-Object -ExpandProperty Node | Select-Object -ExpandProperty Test
    Return @{
        Actions=$Actions
        Tests=$Tests
    }
}

<#
 .Synopsis
 Gets all grading actions for an excercise/level
#>
function Get-GradingAction
{
    [CmdletBinding()]
    param([String]$Path, [String]$Exercise, [String]$Level)
    $XpathExpr = "//sig:task[@name='$Exercise' and @level='$Level']//actions"
    $Ns = @{"sig"="urn:simpleGrader"}
    $Actions = Select-Xml -Path $Path -XPath $XpathExpr -Namespace $Ns | 
     Select-Object -ExpandProperty Node | Select-Object -ExpandProperty Action
    $Actions.foreach{
        [GradeAction]::new($Exercise, $Level, $_.Active, $_.Type, $_."#text")
    }
}

<#
 .Synopsis
 Gets all grading tests for an excercise/level
#>
function Get-GradingTest
{
    [CmdletBinding()]
    param([String]$Path, [String]$Exercise, [String]$Level)
    $XpathExpr = "//sig:task[@name='$Exercise' and @level='$Level']//tests"
    $Ns = @{"sig"="urn:simpleGrader"}
    $Tests = Select-Xml -Path $Path -XPath $XpathExpr -Namespace $Ns | 
     Select-Object -ExpandProperty Node | Select-Object -ExpandProperty test
    $Tests.foreach{
        [GradeTest]::new($Exercise, $Level, $_.Active, $_."test-name", $_."test-type", $_."test-description")
    }
}

<#
 .Synopsis
 Gets all the submissions from the submission directory
 .Notes
 Returns a dictionary with exercise name as the key
#>
function Get-Submission
{
    [CmdletBinding()]
    param([String]$Path)
    $subDic = @{}
    Get-ChildItem -Path $Path -Filter *.zip | ForEach-Object {
        $m1 = "(?<task>\w+)_Level(?<level>\w)_(?<student>[_\w]+)\.zip"
        # Der "Trick des Jahres" - non greedy dank *? anstelle von +, damit der Vorname nicht dem Aufgabenname zugeordnet wird
        $m2 = "(?<task>\w*?)_(?<student>[_\w]+)\.zip"
        if ([Regex]::IsMatch($_.Name, $m1))
        {
            $SubElements = [Regex]::Matches($_.Name, $m1)
        } 
        else
        {
            $SubElements = [Regex]::Matches($_.Name, $m2)
        }
        $Exercise = $SubElements.Groups[1].Value
        $Level = $SubElements.Groups.Name -contains "level" ? $SubElements.Groups[2].Value : "A"
        $Student = $SubElements.Groups.Name -contains "level" ? $SubElements.Groups[3].Value : $SubElements.Groups[2].Value
        if (!$subDic.ContainsKey($Exercise))
        {
            $subDic[$Exercise] = @()
        }
        $subDic[$Exercise] += [Submission]::new($SubmissionList.Count + 1, $Student, $Exercise, $Level, $_.Name)
    }

    $subDic
}

<#
.Synopsis
Invokes a single action from the grading plan
#>
function Invoke-Action
{
    [CmdletBinding()]
    param([String]$Path, [String]$ActionType)
    $ModuleName = $Config.moduleName
    $file = [SubmissionFile]::new($Path)
    $Student = $file.Student
    $Exercise = $file.Exercise

    switch ($ActionType)
    {
        "java-compile" {
            # Create temp directory
            $TempPath = Join-Path -Path $env:TEMP -ChildPath $ModuleName
            $TempPath = Join-Path -Path $TempPath -ChildPath $Exercise
            $TempPath = Join-Path -Path $TempPath -ChildPath $Student
            if (!(Test-Path -Path $TempPath))
            {
                mkdir $TempPath -Force | Out-Null
            }
            $JavaPath = Join-Path -Path $TempPath -ChildPath (Split-Path -Path $Path -Leaf)
            Invoke-Compile -JavaPath $JavaPath
            break;
        }
        "java-compare" {

        }
    }
}
