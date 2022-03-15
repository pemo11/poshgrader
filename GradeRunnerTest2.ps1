<#
 .Synopsis
 Testet einen Grade run
 .Notes
 Letzte Aktualisierung: 14/03/22
#>

using namespace System.IO

$Psm1Path = Join-Path -Path $PSScriptRoot -ChildPath "GradingRun.psm1"
Import-Module -Name $Psm1Path -Force
$Psm1Path = Join-Path -Path $PSScriptRoot -ChildPath "XmlReport.psm1"
Import-Module -Name $Psm1Path -Force

$Psd1Path = Join-Path -Path $PSScriptRoot -ChildPath "graderconfig.psd1"
$Config = import-powershelldataFile -Path $Psd1Path

$Exercise = "EA1"
$Semester = $Config.Semester
$ModuleName = $Config.moduleName

# Schritt 1: Alle Submissions graden

$GradeResult = Invoke-GradeRun -Exercise "EA1" -Level "A" -Verbose

# Schritt 2: XMl-Report erzeugen

$XmlReportPath = Join-Path -Path $PSScriptRoot -ChildPath ("Grade-Report_{0:dd.MM.yy-HH:mm}" -f (Get-Date))
New-GradeReportXml -GradeResultList $GradeResult -XmlPath $XmlReportPath

# Schritt 3: Html-Report erzeugen

$XsltPath = Join-Path -Path $PSScriptRoot -ChildPath "GradeReport.xslt"

$XsltArgs = @{
    "gradingTime" = Get-Date -Format "dd.MM.yy HH:mm"
    "module" = $ModuleName
    "exercise" = $Exercise
    "semester" = $Semester
}

$HtmlPath = [Path]::ChangeExtension($XmlReportPath, "html")
Convert-XmlReport -XmlPath $XmlReportPath -XsltPath $XsltPath -HtmlPath $HtmlPath -XsltArgs $XsltArgs

Invoke-Expression -Command $HtmlPath
