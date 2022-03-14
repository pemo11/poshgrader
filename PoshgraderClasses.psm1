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
    [Int]$ExitCode
    [String]$ResultText

    GradeResult([String]$Student, [String]$Exercise, [Int]$ExitCode, [String]$ResultText)
    {
        $this.Timestamp = Get-Date
        $this.Student = $Student
        $this.Exercise = $Exercise
        $this.ExitCode = $ExitCode
        $this.ResultText = $ResultText
    }

    [String]ToString() 
    {
        return "|$this.Timestamp| Student: $this.Student Exercise: $this.Exercise Exitcode: $this.Exitcode"
    }
}
