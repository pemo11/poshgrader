<#
 .Synopsis
 Paths tests
#>

#requires -module @{ModuleName="pester";ModuleVersion="5.1.1"}

describe "path tests" {

    BeforeAll {
        $Psd1Path = Join-Path -Path $PSScriptRoot -ChildPath "../graderconfig.psd1"
        $Config = Import-PowershelldataFile -Path $Psd1Path
    }
    
    it "checks submission path " {
        $submissionPath = $config.submissionPath
        Test-Path -Path $submissionPath | Should -be $true
    }

    it "checks grading plan path " {
        $gradingplanPath = $config.gradingplanPath
        Test-Path -Path $gradingplanPath | Should -be $true
    }

}
