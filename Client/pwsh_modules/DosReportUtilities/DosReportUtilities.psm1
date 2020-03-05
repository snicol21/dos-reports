<#	
	===========================================================================
	 Filename:     	DosReportUtilities.psm1
	-------------------------------------------------------------------------
	 Module Name: DosReportUtilities
	===========================================================================
#>

#Get public and private function definition files.
$public = @( Get-ChildItem -Path $PSScriptRoot\functions\public\*.ps1 -ErrorAction SilentlyContinue )
$private = @( Get-ChildItem -Path $PSScriptRoot\functions\private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
Foreach ($import in @($public + $private)) {
    Try {
        . $import.fullname
    }
    Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

$publicFunctions = [Management.Automation.Language.Parser]::ParseInput((Get-Content $public -Raw), [ref]$null, [ref]$null).EndBlock.Statements.FindAll([Func[Management.Automation.Language.Ast, bool]] { $args[0] -is [Management.Automation.Language.FunctionDefinitionAst] }, $false) | Select-Object -ExpandProperty Name
Export-ModuleMember -Function $publicFunctions -Alias *

#update security protocol in powershell session
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$progressPreference = 'silentlyContinue'