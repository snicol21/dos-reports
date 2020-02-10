# get all dependent modules and functions
$modules = @( Get-ChildItem -Path $PSScriptRoot\Utilities\* -Include *.psd1 -Recurse -ErrorAction SilentlyContinue )
if ($modules) { Import-Module $modules -Force -Global }

[xml]$xml = @'
<root xmlns:json="http://james.newtonking.com/projects/json">
  <header xmlns:json="http://james.newtonking.com/projects/json">
    <domain>Clinical</domain>
    <area>Sepsis</area>
    <report>Hand Hygiene</report>
    <title>Sepsis Hand Hygiene Report</title>
    <subtitle>with a subtitle</subtitle>
    <date>2019-01-01</date>
    <latest Boolean="true" />
  </header>
  <sections xmlns:json="http://james.newtonking.com/projects/json" json:Array="true">
    <markdown xmlns:json="http://james.newtonking.com/projects/json" json:Array="true">
      <markdown>## Section 1</markdown>
    </markdown>
    <markdown xmlns:json="http://james.newtonking.com/projects/json" json:Array="true">
      <markdown> * List Item 1</markdown>
    </markdown>
    <markdown xmlns:json="http://james.newtonking.com/projects/json" json:Array="true">
      <markdown> * List Item 2</markdown>
    </markdown>
    <figures xmlns:json="http://james.newtonking.com/projects/json" json:Array="true">
      <figures>
        <type xmlns:json="http://james.newtonking.com/projects/json">line-chart</type>
        <config xmlns:json="http://james.newtonking.com/projects/json">
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
              <data xmlns:json="http://james.newtonking.com/projects/json" Integer="10" />
              <data xmlns:json="http://james.newtonking.com/projects/json" Integer="60" />
              <data xmlns:json="http://james.newtonking.com/projects/json" Integer="15" />
              <data xmlns:json="http://james.newtonking.com/projects/json" Integer="5" />
              <data xmlns:json="http://james.newtonking.com/projects/json" Integer="30" />
              <data xmlns:json="http://james.newtonking.com/projects/json" Integer="38" />
              <data xmlns:json="http://james.newtonking.com/projects/json" Integer="60" />
              <fill Boolean="false" />
            </datasets>
            <datasets xmlns:json="http://james.newtonking.com/projects/json" json:Array="true">
              <label>My Second dataset</label>
              <backgroundColor>blue</backgroundColor>
              <borderColor>blue</borderColor>
              <data xmlns:json="http://james.newtonking.com/projects/json" Integer="5" />
              <data xmlns:json="http://james.newtonking.com/projects/json" Integer="12" />
              <data xmlns:json="http://james.newtonking.com/projects/json" Integer="90" />
              <data xmlns:json="http://james.newtonking.com/projects/json" Integer="65" />
              <data xmlns:json="http://james.newtonking.com/projects/json" Integer="20" />
              <data xmlns:json="http://james.newtonking.com/projects/json" Integer="56" />
              <data xmlns:json="http://james.newtonking.com/projects/json" Integer="12" />
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
        </config>
      </figures>
    </figures>
  </sections>
  <footer xmlns:json="http://james.newtonking.com/projects/json">
    <markdown xmlns:json="http://james.newtonking.com/projects/json" json:Array="true">
      <markdown>© 2020 Health Catalyst. All Rights Reserved.</markdown>
    </markdown>
  </footer>
</root>
'@

JsonConvert-SerializeXmlNode $xml -OmitRootObject