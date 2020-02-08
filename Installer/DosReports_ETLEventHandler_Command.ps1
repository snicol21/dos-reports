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
    #$row.BindingID
    #$row.BindingNM
    #$row.LastLoadDTS
    $json = JsonConvert-SerializeXmlNode -Xml ([xml]$row.ReportXML) -OmitRootObject;
    $obj = JsonConvert-DeserializeObject -Json $json;
    $slug = clean-slug("/$($obj.group.domain)/$($obj.group.area)/$($obj.group.report)/$($obj.date)-$($obj.group.report)'s/".ToLower() -replace ' ','-')
    $queries += "INSERT INTO [Reports].[DosReportsBASE] ([ID],[SlugCD],[ReportJSON],[StatusCD]) VALUES ($($row.BindingID),'$($slug)','$($json)','Active');"
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