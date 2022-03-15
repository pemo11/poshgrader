<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:sig="urn:simpleGrader"
    version="1.0">
    <xsl:param name="semester"/>
    <xsl:param name="module"/>
    <xsl:param name="exercise"/>
    <xsl:param name="gradingTime"/>
    <xsl:template match="/">
        <html>
            <head>
                <style>
                    body {
                        font-family: arial;
                    }

                    #grades {
                        font-family: Arial, Helvetica, sans-serif;
                        border-collapse: collapse;
                        width: 80%;
                    }
                    #grades td, #grades th {
                        border: 1px solid #ddd;
                        padding: 8px;
                    }

                    #grades th {
                        padding-top: 12px;
                        padding-bottom: 12px;
                        text-align: left;
                        background-color: #04AA6D;
                        color: white;
                    }
                    
                    #grades tr:nth-child(even){background-color: #f2f2f2;}
                    #grades tr:hover {background-color: #ddd;}

                    #grades td.ok {
                        background-color: #ACE6D7;
                    }
 
                    #grades td.alert1 {
                        background-color: orange;
                    }

                    #grades td.alert2 {
                        background-color: red;
                    }


                </style>
            </head>
            <body>
                <h3>Grading-Report <xsl:value-of select="$gradingTime"/> - <xsl:value-of select="$module"/>/<xsl:value-of select="$exercise"/> (<xsl:value-of select="$semester"/>)</h3>
                <table id="grades">
                    <tr bgcolor="#ADD8E6">
                        <th>Timestamp</th>
                        <th>Student</th>
                        <th>Exercise</th>
                        <th>Filename</th>
                        <th>Action</th>
                        <th>Result</th>
                        <th>Points</th>
                    </tr>
                    <xsl:for-each select="//sig:GradeResult">
                        <tr>
                            <td><xsl:value-of select="sig:Timestamp"/></td>
                            <td><xsl:value-of select="sig:Student"/></td>
                            <td><xsl:value-of select="sig:Exercise"/></td>
                            <xsl:choose>
                                <xsl:when test="sig:GradePoints &lt; -1">
                                    <td class='alert1'><xsl:value-of select="sig:Filename"/></td>
                                </xsl:when>
                                <xsl:otherwise>
                                    <td><xsl:value-of select="sig:Filename"/></td>
                                </xsl:otherwise>
                            </xsl:choose>
                            <td><xsl:value-of select="sig:GradeAction"/></td>
                            <td><xsl:value-of select="sig:GradeResult"/></td>
                            <xsl:choose>
                                <xsl:when test="sig:GradePoints &lt; -1">
                                    <td class='alert2'><xsl:value-of select="sig:GradePoints"/></td>
                                </xsl:when>
                                <xsl:otherwise>
                                    <td class='ok'><xsl:value-of select="sig:GradePoints"/></td>
                                </xsl:otherwise>
                            </xsl:choose>
                        </tr>
                    </xsl:for-each>
                </table>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
