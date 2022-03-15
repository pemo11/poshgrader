<#
 .Synopsis
 All Java Actions
#>

using namespace System.IO

$Psd1Path = Join-Path -Path $PSScriptRoot -ChildPath "graderconfig.psd1"
$Config = import-powershelldataFile -Path $Psd1Path

<#
 .Synopsis
 Compiles a Java file and returns exit code and output text
#>
function Invoke-Compile
{
    [CmdletBinding()]
    param([String]$JavaPath)
    $DirPath = Split-Path -Path $JavaPath
    $JavaCPath = $Config.JavaCPath
    $OutfilePath = Join-Path -Path $DirPath -ChildPath "Output1.txt"
    $ErrorFilePath = Join-Path -Path $DirPath -ChildPath "Error1.txt"
    $JavaArgs = $JavaPath
    $P = Start-Process -FilePath $JavaCPath -ArgumentList $JavaArgs -NoNewWindow `
     -RedirectStandardOutput $OutfilePath -RedirectStandardError $ErrorFilePath `
     -WorkingDirectory $DirPath -Wait -PassThru
    if ($P.ExitCode -eq 0)
    {
        $JavaClassPath = [Path]::ChangeExtension($JavaPath, ".class")
        if (!(Test-Path -Path $JavaClassPath))
        {
            throw "!!! $JavaClassPath not found !!!"
        }
    }
    [PSCustomObject]@{
        Points = $P.ExitCode -ge 0 ? 1 : -1
        Message = Get-Content -Path $OutfilePath
        JavaClassPath = $JavaClassPath
    }
}

<#
 .Synopsis
 Compiles two Java files and compares output text
#>
function Invoke-Compare
{
    [CmdletBinding()]
    param([String]$JavaPath, [String]$TestDriverPath)
    $Result1 = Invoke-Compile -Path $JavaPath
    if ($Result1.ExitCode -ne 0)
    {
        throw "!!! Compile error for $JavaPath !!!"
    }
    $Result2 = Invoke-Compile -Path $TestDriverPath
    if ($Result2.ExitCode -ne 0)
    {
        throw "!!! Compile error for $TestDriverPath !!!"
    }
    $Result = Invoke-Java -Path $Result2.ClassPath
    [PSCustomObject]@{
        Points = $Result.ExitCode -ge 0 ? 1 : -1
        Message = Get-Content -Path $OutfilePath
    }
}
