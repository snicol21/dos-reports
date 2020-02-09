[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.ConnectionInfo');
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.Management.Sdk.Sfc');
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO');

# Requiered for SQL Server 2008 (SMO 10.0).
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMOExtended');
$server = New-Object Microsoft.SqlServer.Management.Smo.Server "localhost";
$db = $server.Databases.Item("SAM");
[String] $sql = "SELECT [BindingID],[BindingNM],[LastLoadDTS],[ReportXML] FROM [Demo].[NewEntity13]";
try {
    $result = $db.ExecuteWithResults($sql);
}
catch {
    Write-Error "Unable to call $sql";
    throw;
}

function clean-slug ($slug) {
    return $slug.Replace('''','-').Replace(':','-').Replace('%','-').Replace('#','-').Replace('*','-').Replace('<','-').Replace('>','-').Replace('?','-').Replace('"','-').Replace('"','-').Replace('@','-').Replace('&','-').Replace('=','-').Replace(';','-').Replace('|','-').Replace('\','-').Replace('[','-').Replace(']','-').Replace('~','-').Replace('{','-').Replace('}','-').Replace('^','-').Replace('!','-').Replace(',','-').Replace('.','-')
}


$queries = @();
foreach($row in $result.Tables[0].Rows) {
    $json = JsonConvert-SerializeXmlNode -Xml ([xml]$row.ReportXML) -OmitRootObject;
    $obj = JsonConvert-DeserializeObject -Json $json;
    $key = clean-slug("/$($obj.header.group.domain)/$($obj.header.group.area)/$($obj.header.group.report)/$($obj.header.date)-$($obj.header.group.report)/".ToLower() -replace ' ','-')
    $queries += @'
IF EXISTS (SELECT 1 FROM [Reports].[DosReportsBASE] WHERE [ReportKEY] = '{0}')
BEGIN
  UPDATE [Reports].[DosReportsBASE] SET [ReportJSON] = '{1}' WHERE [ReportKEY] = '{0}';
END
ELSE
BEGIN
  INSERT INTO [Reports].[DosReportsBASE] ([ReportKEY],[ReportJSON],[StatusCD]) VALUES ('{0}','{1}','Active');
END;
'@ -f $key, $json
}

$script = $queries -join(' ')
$db = $server.Databases.Item("Shared");
try {
    $result = $db.ExecuteWithResults($script);
}
catch {
    Write-Error "Unable to call";
    throw;
}