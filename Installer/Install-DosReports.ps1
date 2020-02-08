# get all dependent modules and functions
$modules = @( Get-ChildItem -Path $PSScriptRoot\Utilities\* -Include *.psd1 -Recurse -ErrorAction SilentlyContinue )
if ($modules) { Import-Module $modules -Force -Global }

[xml]$xml = @'
<root xmlns:json="http://james.newtonking.com/projects/json">
  <date xmlns:json="http://james.newtonking.com/projects/json">2019-02-01</date>
  <title xmlns:json="http://james.newtonking.com/projects/json">Sepsis Rate Report</title>
  <subtitle xmlns:json="http://james.newtonking.com/projects/json">with a subtitle</subtitle>
  <latest xmlns:json="http://james.newtonking.com/projects/json" Boolean="true" />
  <group xmlns:json="http://james.newtonking.com/projects/json">
    <domain>Clinical</domain>
    <area>Sepsis</area>
    <report>Rate</report>
  </group>
  <sections xmlns:json="http://james.newtonking.com/projects/json" json:Array="true">
    <name>Rate Over Time</name>
    <chart>
      <type xmlns:json="http://james.newtonking.com/projects/json">line</type>
      <data xmlns:json="http://james.newtonking.com/projects/json">
        <labels xmlns:json="http://james.newtonking.com/projects/json">January</labels>
        <labels xmlns:json="http://james.newtonking.com/projects/json">February</labels>
        <labels xmlns:json="http://james.newtonking.com/projects/json">March</labels>
        <labels xmlns:json="http://james.newtonking.com/projects/json">April</labels>
        <labels xmlns:json="http://james.newtonking.com/projects/json">May</labels>
        <labels xmlns:json="http://james.newtonking.com/projects/json">June</labels>
        <labels xmlns:json="http://james.newtonking.com/projects/json">July</labels>
        <datasets xmlns:json="http://james.newtonking.com/projects/json" json:Array="true">
          <label>My First dataset</label>
          <backgroundColor>red</backgroundColor>
          <borderColor>red</borderColor>
          <data xmlns:json="http://james.newtonking.com/projects/json" Float="1.00" />
          <data xmlns:json="http://james.newtonking.com/projects/json" Float="0.78" />
          <data xmlns:json="http://james.newtonking.com/projects/json" Float="0.68" />
          <data xmlns:json="http://james.newtonking.com/projects/json" Float="0.70" />
          <data xmlns:json="http://james.newtonking.com/projects/json" Float="0.72" />
          <data xmlns:json="http://james.newtonking.com/projects/json" Float="0.65" />
          <data xmlns:json="http://james.newtonking.com/projects/json" Float="0.62" />
          <fill Boolean="false" />
        </datasets>
      </data>
      <options xmlns:json="http://james.newtonking.com/projects/json">
        <responsive Boolean="true" />
        <title xmlns:json="http://james.newtonking.com/projects/json">
          <display Boolean="true" />
          <text>Chart.js Line Chart</text>
        </title>
        <tooltips xmlns:json="http://james.newtonking.com/projects/json">
          <mode>index</mode>
          <intersect Boolean="false" />
        </tooltips>
        <hover xmlns:json="http://james.newtonking.com/projects/json">
          <mode>nearest</mode>
          <intersect Boolean="true" />
        </hover>
        <scales xmlns:json="http://james.newtonking.com/projects/json">
          <xAxes xmlns:json="http://james.newtonking.com/projects/json" json:Array="true">
            <display Boolean="true" />
            <scaleLabel>
              <display xmlns:json="http://james.newtonking.com/projects/json" Boolean="true" />
              <labelString xmlns:json="http://james.newtonking.com/projects/json">Month</labelString>
            </scaleLabel>
          </xAxes>
          <yAxes xmlns:json="http://james.newtonking.com/projects/json" json:Array="true">
            <display Boolean="true" />
            <scaleLabel>
              <display xmlns:json="http://james.newtonking.com/projects/json" Boolean="true" />
              <labelString xmlns:json="http://james.newtonking.com/projects/json">Value</labelString>
            </scaleLabel>
          </yAxes>
        </scales>
      </options>
    </chart>
  </sections>
</root>
'@

ConvertFrom-XmlToJson $xml -OmitRootObject