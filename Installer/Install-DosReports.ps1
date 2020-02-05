# get all dependent modules and functions
$modules = @( Get-ChildItem -Path $PSScriptRoot\Utilities\* -Include *.psd1 -Recurse -ErrorAction SilentlyContinue )
if ($modules) { Import-Module $modules -Force -Global }

[xml]$xml = @'
    <root>
        <Persons>
            <id>1</id><info><name>homer</name><surname>simpson</surname></info><age>35</age>
        </Persons>
        <Persons>
            <id>2</id><info><name>john</name><surname>doe</surname></info><age>20</age>
        </Persons>
        <Persons>
            <id>3</id><info><name>ralph</name><surname>wiggins</surname></info><age>10</age>
        </Persons>
        <Persons>
            <id>4</id><info><name>bart</name><surname>simpson</surname></info><age>34</age>
        </Persons>
    </root>
'@

ConvertFrom-XmlToJson $xml -OmitRootObject