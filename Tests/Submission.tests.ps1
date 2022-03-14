<#
 .Synopsis
 Tests submission preparation
#>
#requires -module @{ModuleName="pester";ModuleVersion="5.1.1"}

Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath "../Submissions.psm1") -Force

describe "exercise file tests" {

    it "EA3 files should be 2" {
        $files = Get-ExerciseFile -Exercise "EA1" -Level "A"
        $files.Count | Should -be 2
    }

    it "EA2 files should be 2" {
        $files = Get-ExerciseFile -Exercise "EA2" -Level "A"
        $files.Count | Should -be 2
    }

    it "EA3 files should be 4" {
        $files = Get-ExerciseFile -Exercise "EA3" -Level "A"
        $files.Count | Should -be 4
    }

}

describe "submission file tests" {

    it "submission should contain 2 files" {
        $SubmissionPath = Join-Path -Path $PSScriptRoot -ChildPath "Files/EA3_Peter_Monadjemi.zip"
        Test-Submission -SubmissionPath $SubmissionPath -Exercise "EA3" | Should -be $true
    }
}