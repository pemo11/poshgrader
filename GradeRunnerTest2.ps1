<#
 .Synopsis
 Testet einen Grade run
 .Notes
 Letzte Aktualisierung: 14/03/22
#>

$Psm1Path = Join-Path -Path $PSScriptRoot -ChildPath "GradingRun.psm1"
Import-Module -Name $Psm1Path -Force

# Schritt 1: Alle Submissions graden

Invoke-GradeRun -Exercise "EA1" -Level "A" -Verbose

