<#
 .Synopsis
 Testet ein paar Functions aus poshgrader.psm1
 .Notes
 Letzte Aktualisierung: 14/03/22
#>

$Psm1Path = Join-Path -Path $PSScriptRoot -ChildPath poshgrader.psm1
Import-module $Psm1Path -Force

$Psd1Path = Join-Path -Path $PSScriptRoot -ChildPath "graderconfig.psd1"
$Config = import-powershelldataFile -Path $Psd1Path

$GradingPlanPath = $Config.GradingPlanPath
$SubmissionPath = $Config.SubmissionPath

$planDic = Get-Gradingplan -Path $GradingPlanPath

$planDic.Actions | Format-Table
$planDic.Tests | Format-Table

# $SubmissionList = Get-Submission -Path $SubmissionPath

# $SubmissionList

Get-GradingAction -Path $GradingPlanPath -Exercise "EA1" -Level "A"

Get-GradingTest -Path $GradingPlanPath -Exercise "EA1" -Level "A"
