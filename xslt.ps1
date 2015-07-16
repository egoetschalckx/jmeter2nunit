trap [Exception]
{
	Write-Host $_.Exception;
	Break;
}

$xsl = "C:\Users\Eric\Google Drive\jmeter_to_nunit.xslt"
$xml = "C:\Users\Eric\Google Drive\mpplat_jmeter_report.xml"
$reportName = "Platform PreProd Automated Tests"
$output = "C:\Users\Eric\Google Drive\nunit_report.xml"

$xslt = New-Object System.Xml.Xsl.XslCompiledTransform;
$xslt.Load($xsl);
#$xslt.Transform($xml, $output);

$date = Get-Date
$xslArgList = New-Object System.Xml.Xsl.XsltArgumentList;
$xslArgList.AddParam("date", "", $date.ToString("yyyy-MM-dd"));
$xslArgList.AddParam("time", "", $date.ToString("HH-mm-ss"));
$xslArgList.AddParam("report_name", "", $reportName);

$xmlWriter = [System.Xml.XmlWriter]::Create($output);
$xslt.Transform($xml, $xslArgList, $xmlWriter);
$xmlWriter.Close();

Write-Host "generated" $output;
