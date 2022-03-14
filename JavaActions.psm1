<#
 .Synopsis
 All Java Actions
#>

$Psd1Path = Join-Path -Path $PSScriptRoot -ChildPath "graderconfig.psd1"
$Config = import-powershelldataFile -Path $Psd1Path

<#
 .Synopsis
 Compiles a Java file and returns exit code and output text
#>
function Invoke-Compile
{
    [CmdletBinding()]
    param([String]$Path)
    $JavaCPath = $Config.JavaCPath
    $ModuleName = $Config.ModuleName
    # Create temp directory with student name
    $TempPath = Join-Path -Path $env:TEMP -ChildPath $ModuleName
    # Only the name without the exercise name (may be a little bit too complicated)
    # $Student = (($Path -split "\\")[-2] -split "(\w*?)_(.*)")[2]
    $Student = ($Path -split "\\")[-2]
    $TempPath = Join-Path -Path $TempPath -ChildPath $Student
    if (!(Test-Path -Path $TempPath))
    {
        mkdir $TempPath | Out-Null
    }
    # Copy Java file in temp dir
    # Copy-Item -Path $Path -Destination $TempPath
    $OutfilePath = Join-Path -Path $PSScriptRoot -ChildPath "Output1.txt"
    $ErrorFilePath = Join-Path -Path $PSScriptRoot -ChildPath "Error1.txt"
    $JavaArgs = Join-Path -Path $TempPath -ChildPath (Split-Path -Path $Path -Leaf)
    $P = Start-Process -FilePath $JavaCPath -ArgumentList $JavaArgs -NoNewWindow `
     -RedirectStandardOutput $OutfilePath -RedirectStandardError $ErrorFilePath `
     -WorkingDirectory $TempPath -Wait -PassThru
    if ($P.ExitCode -eq 0)
    {
        $JavaClassPath = [System.IO.Path]::ChangeExtension($Path, ".class")
        if (!(Test-Path -Path $JavaClassPath))
        {
            throw "!!! $JavaClassPath not found !!!"
        }
    }
    [PSCustomObject]@{
        ExitCode = $P.ExitCode
        OutputText = Get-Content -Path $OutfilePath
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
        ExitCode = $Result.ExitCode
        CompareResult = $Result.ExitCode -eq 0
    }
}
