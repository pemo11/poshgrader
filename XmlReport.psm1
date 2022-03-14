<#
 .Synopsis
 Functions for creating xml reports
#>

<#
 .Synopsis
 Create a xml report from a grade result list
#>
function New-GradeReportXml
{
    [CmdletBinding()]
    param([Object]$GradeResultList, [String]$XmlPath)

}

<#
 .Synopsis
 Creates an Html report via XSLT
#>
function Convert-XmlReport
{
    [CmdletBinding()]
    param([String]$XmlPath, [String]$XsltPath)
    

}