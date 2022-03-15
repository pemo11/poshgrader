<#
 .Synopsis
 Weitere GradeRunner tests
#>
#requires -version 7.0

using module ./PoshgraderClasses.psm1

Set-StrictMode -Version latest

$Psm1Path = Join-Path -Path $PSScriptRoot -ChildPath "XmlReport.psm1"
Import-Module -Name $Psm1Path -Force

$Psd1Path = Join-Path -Path $PSScriptRoot -ChildPath "graderconfig.psd1"
$Config = import-powershelldataFile -Path $Psd1Path

$Exercise = "EA1"
$Semester = $Config.Semester
$ModuleName = $Config.moduleName
$Student = "Bjarne Stroupstrup"
$Points = -1..2 | Get-Random
$FileName = "$Exercise`_$($Student -replace ' ','_').zip"
$Action = "Java-Compile"
$Result = "All systems on alert", "OK" | Get-Random

$gradeResultlist = @()
$gradeResultlist += [GradeResult]::new($Student, $Exercise, $FileName, $Action, $Points, $Result)
$gradeResultlist += [GradeResult]::new($Student, $Exercise, $FileName, $Action, $Points, $Result)
$gradeResultlist += [GradeResult]::new($Student, $Exercise, $FileName, $Action, $Points, $Result)
$gradeResultlist += [GradeResult]::new($Student, $Exercise, $FileName, $Action, -2, "Lots of nasty errors")

$XmlPath = Join-Path -Path $PSScriptRoot -ChildPath "TestReport.xml"
New-GradeReportXml -GradeResultList $gradeResultlist -XmlPath $XmlPath

Get-Content -Path $XmlPath

$XsltPath = Join-Path -Path $PSScriptRoot -ChildPath "GradeReport.xslt"

$XsltArgs = @{
    "gradingTime" = Get-Date -Format "dd.MM.yy HH:mm"
    "module" = $ModuleName
    "exercise" = $Exercise
    "semester" = $Semester
}

Convert-XmlReport -XmlPath $XmlPath -XsltPath $XsltPath -XsltArgs $XsltArgs
