<#
 .Synopsis
Class definitions for classes used by Poshgrader
#>

<#
 .Synopsis
 A single submission
#>
class Submission
{
    [Int]$Id
    [DateTime]$timestamp
    [String]$Student
    [String]$Filename
    [String]$Semester
    [String]$Module
    [String]$Exercise
    [String]$Level

    Submission([Int]$Id, [String]$Student, [String]$Exercise, [String]$Level, [String]$Filename)
    {
        $this.Id = $Id
        $this.Student = $Student
        $this.Exercise = $Exercise
        $this.Level = $Level
        $this.Filename = $Filename
    }
}

<#
 .Synopsis
 A single grade action
#>
class GradeAction
{
    [String]$Exercise
    [String]$Level
    [bool]$Active
    [String]$Type
    [String]$Action

    GradeAction([String]$Exercise, [String]$Level, [Bool]$active, [String]$Type, [String]$Action)
    {
        $this.Exercise = $Exercise
        $this.Level = $Level
        $this.Active = $Active
        $this.Type = $Type
        $this.Action = $Action
    }
}

<#
 .Synopsis
 A single grade test
#>
class GradeTest
{
    [String]$Exercise
    [String]$Level
    [bool]$Active
    [String]$Type
    [String]$Name
    [String]$Description
    [String]$TextInput
    [String]$TestOutput
    [Int]$TestScore

    GradeTest([String]$Exercise, [String]$Level, [Bool]$Active, [String]$Name, [String]$Type, [String]$Description)
    {
        $this.Exercise = $Exercise
        $this.Level = $Level
        $this.Active = $Active
        $this.Name = $Name
        $this.Type = $Type
        $this.Description
    }
}

<#
 .Synopsis
 A single grade result
#>
class GradeResult
{
    [DateTime]$Timestamp
    [String]$Exercise
    [String]$Student
    [String]$FileName
    [String]$GradeAction
    [Int]$GradePoints
    [String]$GradeResult

    GradeResult([String]$Student, [String]$Exercise, [String]$FileName, [String]$Action, [Int]$Points, [String]$Result)
    {
        $this.Timestamp = Get-Date
        $this.Student = $Student
        $this.Exercise = $Exercise
        $this.FileName = $FileName
        $this.GradeAction = $Action
        $this.GradePoints = $Points
        $this.GradeResult = $Result
    }

    [String]ToString() 
    {
        return "|$this.Timestamp| Student: $this.Student Exercise: $this.Exercise Exitcode: $this.Exitcode"
    }
}

<#
 .Synopsis
 Represents a single submission filename with exercise, student name and optionally level
#>

class SubmissionFile
{
    [String]$Exercise
    [String]$Student
    [String]$Level

    SubmissionFile([String]$Path)
    {
        $FileDir = $Path
        if (Test-Path -Path $Path -PathType Leaf)
        {
            $FileDir = ((Split-Path -Path $Path) -split "\\")[-1]
        }
        $m1 = "(?<exercise>\w+)_Level(?<level>\w)_(?<student>[_\w]+)"
        $m2 = "(?<exercise>\w*?)_(?<student>[_\w]+)"
        if ([Regex]::IsMatch($FileDir, $m1))
        {
            $SubElements = [Regex]::Matches($FileDir, $m1)
        } 
        else
        {
            $SubElements = [Regex]::Matches($FileDir, $m2)
        }
        $this.Exercise = $SubElements.Groups[1].Value
        $this.Level = $SubElements.Groups.Name -contains "level" ? $SubElements.Groups[2].Value : "A"
        $this.Student = $SubElements.Groups.Name -contains "level" ? $SubElements.Groups[3].Value : $SubElements.Groups[2].Value
    }

}