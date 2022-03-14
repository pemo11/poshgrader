<#
 .Synopsis
 Paths tests
#>

#requires -module @{ModuleName="pester";ModuleVersion="5.1.1"}

Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath "../JavaActions.psm1")

describe "path tests" {

    BeforeAll {
        $Psd1Path = Join-Path -Path $PSScriptRoot -ChildPath "../graderconfig.psd1"
        $Config = Import-PowershelldataFile -Path $Psd1Path
    }
    
    it "checks java compile test " {
        $JavaPath = Join-Path -Path $PSScriptRoot -ChildPath "Files/JavaMath.java"
        $RetCode = Invoke-Compile -Path $JavaPath
        $RetCode | Should -be 0
    }

}
