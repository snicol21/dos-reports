# get all dependent modules and functions
$modules = @( Get-ChildItem -Path $PSScriptRoot\Utilities\* -Include *.psd1 -Recurse -ErrorAction SilentlyContinue )
if ($modules) { Import-Module $modules -Force -Global }

[xml]$xml = @'
<root xmlns:json="http://james.newtonking.com/projects/json">
  <date xmlns:json="http://james.newtonking.com/projects/json">2019-01-01</date>
  <title xmlns:json="http://james.newtonking.com/projects/json">Sepsis Hand Hygiene Report</title>
  <subtitle xmlns:json="http://james.newtonking.com/projects/json">with a subtitle</subtitle>
  <latest xmlns:json="http://james.newtonking.com/projects/json" Boolean="true" />
  <group xmlns:json="http://james.newtonking.com/projects/json">
    <domain>Clinical</domain>
    <area>Sepsis</area>
    <report>Hand Hygiene</report>
  </group>
  <sections xmlns:json="http://james.newtonking.com/projects/json">
    <name>Compliance Over Time</name>
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
        <datasets xmlns:json="http://james.newtonking.com/projects/json">
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
        <datasets xmlns:json="http://james.newtonking.com/projects/json">
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
    </chart>
  </sections>
  <sections xmlns:json="http://james.newtonking.com/projects/json">
    <name>Compliance By Department</name>
    <chart />
  </sections>
</root>
'@

ConvertFrom-XmlToJson $xml -OmitRootObject

<#
WITH XMLNAMESPACES ('http://james.newtonking.com/projects/json' as [json])
SELECT (
SELECT
  (
    SELECT
      '2019-01-01' as [date],
      'Sepsis Hand Hygiene Report' as [title],
      'with a subtitle' as [subtitle],
      'true' as [latest/@Boolean],
      (
        SELECT
          'Clinical' as [domain],
          'Sepsis' as [area],
          'Hand Hygiene' as [report]
        FOR XML PATH ('group'), type
      )
    FOR XML PATH (''), type
  ),
  (
    SELECT *
    FROM (VALUES
      /* section */
      (
        'Compliance Over Time', /* name */
        (
          SELECT
            'line' as [type],
            (
              SELECT
                (
                  SELECT [labels]
                  FROM (VALUES ('January'), ('February'), ('March'), ('April'), ('May'), ('June'), ('July')) as l ([labels])
                  FOR XML PATH (''), type
                ),
                (
                  SELECT
                    'My First dataset' as [label],
                    'red' as [backgroundColor],
                    'red' as [borderColor],
                    (
                      SELECT [data/@Integer]
                      FROM (VALUES (10), (60), (15), (5), (30), (38), (60)) as d ([data/@Integer])
                      FOR XML PATH (''), type
                    ),
                    'false' as [fill/@Boolean]
                  FOR XML PATH ('datasets'), type
                ),
                (
                  SELECT
                    'My Second dataset' as [label],
                    'blue' as [backgroundColor],
                    'blue' as [borderColor],
                    (
                      SELECT [data/@Integer]
                      FROM (VALUES (5), (12), (90), (65), (20), (56), (12)) as d ([data/@Integer])
                      FOR XML PATH (''), type
                    ),
                    'false' as [fill/@Boolean]
                  FOR XML PATH ('datasets'), type
                )
              FOR XML PATH ('data'), type
            ),
            (
              SELECT
                'true' as [responsive/@Boolean],
                (
                  SELECT
                    'true' as [display/@Boolean],
                    'Chart.js Line Chart' as [text]
                  FOR XML PATH ('title'), type
                ),
                (
                  SELECT
                    'index' as [mode],
                    'false' as [intersect/@Boolean]
                  FOR XML PATH ('tooltips'), type
                ),
                (
                  SELECT
                    'nearest' as [mode],
                    'true' as [intersect/@Boolean]
                  FOR XML PATH ('hover'), type
                ),
                (
                  SELECT
                    (
                      SELECT 'true' as [@json:Array], [display/@Boolean], [scaleLabel]
                      FROM (VALUES
                        (
                          'true',
                           (
                             SELECT
                               'true' as [display/@Boolean],
                               'Month' as [labelString]
                             FOR XML PATH (''), type
                           )
                        )
                      ) as l ([display/@Boolean], [scaleLabel])
                      FOR XML PATH ('xAxes'), type
                    ),
                    (
                      SELECT 'true' as [@json:Array], [display/@Boolean], [scaleLabel]
                      FROM (VALUES
                        (
                          'true',
                           (
                             SELECT
                               'true' as [display/@Boolean],
                               'Value' as [labelString]
                             FOR XML PATH (''), type
                           )
                        )
                      ) as l ([display/@Boolean], [scaleLabel])
                      FOR XML PATH ('yAxes'), type
                    )
                  FOR XML PATH ('scales'), type
                )
              FOR XML PATH ('options'), type
            )
          FOR XML PATH (''), type
        ) /* chart */
      ),

      /* section */
      (
        'Compliance By Department', /* name */
        ''
      )
    ) as sections ([name], [chart])
    FOR XML PATH ('sections'), type
  )
FOR XML PATH (''), ROOT ('root')
) as ReportXML
#>