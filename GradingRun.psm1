<#
 .Synopsis
 Functions for grading runs
#>

using module ./PoshgraderClasses.psm1

$Psd1Path = Join-Path -Path $PSScriptRoot -ChildPath "graderconfig.psd1"
$Config = import-powershelldataFile -Path $Psd1Path

$Psm1Path = Join-Path -Path $PSScriptRoot -ChildPath "Poshgrader.psm1"
Import-Module -Name $Psm1Path -Force

$Psm1Path = Join-Path -Path $PSScriptRoot -ChildPath "Submissions.psm1"
Import-Module -Name $Psm1Path -Force

<#
 .Synopsis
 Starts a grade run for a single exercise
 .Notes
 All submission for this exercise will be graded
#>
function Invoke-GradeRun
{
    [CmdletBinding()]
    param([String]$Exercise, [String]$Level)
    # for the final grade run report
    $gradeResultlist = @()
    $SubmissionPath = $Config.SubmissionPath
    $GradingplanPath = $Config.GradingPlanPath
    $ModuleName = $Config.ModuleName
    # Temp directory is already created - no need for a mkdir again
    $TempPath = Join-Path -Path $env:TEMP -ChildPath $ModuleName
    $planDic = Get-Gradingplan -Path $GradingplanPath
    $submissionDic = Get-Submission -Path $SubmissionPath
    # $exerciseFiles = Get-SubmissionFile -Exercise $Exercise
    $Actions = $planDic.Actions
    # go through all submissions by exercise name as key
    $i = 0
    $submissionDic.Keys | ForEach-Object {
        $PValue1 = ++$i / $SubmissionDic.Keys.Count * 100
        Write-Progress -Activity "Grading submissions" -Status "Grading submissions for exercise $_" `
         -PercentComplete $PValue1 -Id 1
        # now go through all the submissions for that exercise
        $j = 0
        $submissionDic.$_ | ForEach-Object {
            $PValue2 = ++$j /  @($submissionDic[$_.Exercise]).Count * 100
            Write-Progress -Activity "Grading submissions" -Status "Grading $_" `
             -PercentComplete $PValue2 -ParentId 1
            $ZipPath = Join-Path -Path $SubmissionPath -ChildPath $_.Filename
            $files = Get-SubmissionFile -SubmissionPath $ZipPath
            # now go through all submitted files for compile action
            $files | ForEach-Object {
                # Choose only the compile action at the moment
                Write-Verbose "*** Processing file $_ ***"
                $action = $Actions.Where{$_.Type -eq "java-compile"}[0]
                $javaFilePath = $_.FullName
                # thanks to non greedy *?
                $Student = (($_.FullName -split "\\")[-2] -split "(\w*?)_(.*)")[2]
                $Result = Invoke-Action -Path $javaFilePath -Exercise $Exercise -Level $Level -Action $action.type
                $gradeResultlist += [GradeResult]::new($Student, $Exercise, $Result.ExitCode, $Result.OutputText)
            }
      }
    }
    # Return all grade results as a list (array)
    $gradeResultlist
}