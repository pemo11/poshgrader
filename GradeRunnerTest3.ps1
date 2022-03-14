<#
 .Synopsis
 Testet einen Grade run
 .Notes
 Letzte Aktualisierung: 14/03/22
#>

# Grade Run initialisieren
$Psd1Path = Join-Path -Path $PSScriptRoot -ChildPath "graderconfig.psd1"
$Config = import-powershelldataFile -Path $Psd1Path

# Schritt 1: Alle Submissions einlesen

$SubmissionsDic = Get-Submission -Path $Config.SubmissionPath

# Alle Submissions für EA1 einzeln graden
$SubmissionsDic["EA1"] | ForEach-Object {
    Write-Verbose "*** Grade Abgabe von $($_.Student) ***" -Verbose
    Invoke-GradeRunStudent -Exercise $EA1 -Submission $_
}
