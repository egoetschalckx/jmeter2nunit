param ($xml, $xsl, $output, $reportname)

if (-not $xml -or -not $xsl -or -not $output -or -not $reportname)
{
	Write-Host "& .\xslt.ps1 [-xml] xml-input [-xsl] xsl-input [-output] transform-output [$reportname] report-name"
	exit;
}

trap [Exception]
{
	Write-Host $_.Exception;
	Break;
}

$xslt = New-Object System.Xml.Xsl.XslCompiledTransform;
$xslt.Load($xsl);

$date = Get-Date
$xslArgList = New-Object System.Xml.Xsl.XsltArgumentList;
$xslArgList.AddParam("date", "", $date.ToString("yyyy-MM-dd"));
$xslArgList.AddParam("time", "", $date.ToString("HH-mm-ss"));
$xslArgList.AddParam("report_name", "", $reportName);

$xmlWriter = [System.Xml.XmlWriter]::Create($output);
$xslt.Transform($xml, $xslArgList, $xmlWriter);
$xmlWriter.Close();

Write-Host "generated" $output;
