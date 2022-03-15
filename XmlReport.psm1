<#
 .Synopsis
 Functions for creating xml reports
#>

using namespace System.Collections
using namespace System.IO
using namespace System.Xml.Linq
using namespace System.Xml.Xsl

<#
 .Synopsis
 Create a xml report from a grade result list
#>
function New-GradeReportXml
{
    [CmdletBinding()]
    param([Object]$GradeResultList, [String]$XmlPath)
    $Ns = [XNamespace]::Get("urn:simpleGrader")
    $xlName = [XName]::Get("GradeResults", $Ns)
    $xlRoot = [XElement]::new($xlName, [XAttribute]::new([XNamespace]::Xmlns + "sig", $Ns))
    $i = 1
    $GradeResultList.foreach{
        $xlResult = [XElement]::new($Ns + "GradeResult",
         [XAttribute]::new("id", $i++),
         [XElement]::new($Ns + "Timestamp", $_.Timestamp.ToString("dd.MM.yy HH:mm")),
         [XElement]::new($Ns + "Exercise", $_.Exercise),
         [XElement]::new($Ns + "Student", $_.Student),
         [XElement]::new($Ns + "Filename", $_.FileName),
         [XElement]::new($Ns + "GradeAction", $_.GradeAction),
         [XElement]::new($Ns + "GradeResult", $_.GradeResult),
         [XElement]::new($Ns + "GradePoints", $_.GradePoints)
         )
        $xlRoot.Add($xlResult)
    }
    $xlRoot.Save($xmlPath)
}

<#
 .Synopsis
 Creates an Html report via XSLT
#>
function Convert-XmlReport
{
    [CmdletBinding()]
    param([String]$XmlPath, [String]$XsltPath, [String]$HtmlPath, [Hashtable]$XsltArgs)
    $xslt = [XslCompiledTransform]::new()
    $arglist = [XsltArgumentList]::new()
    # Add the necessary parameters
    $XsltArgs.Keys.ForEach{
        $arglist.AddParam($_, "", $XsltArgs[$_])
    }
    $xslt.Load($XsltPath)
    $Sw = [StreamWriter]::new($HtmlPath)
    $xslt.Transform($XmlPath, $arglist, $Sw)
    $Sw.Flush()
    $Sw.Close()
}