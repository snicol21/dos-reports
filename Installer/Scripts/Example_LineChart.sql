WITH XMLNAMESPACES ('http://james.newtonking.com/projects/json' as [json])
SELECT (
SELECT
  (
    SELECT
      'Clinical' as [domain],
      'Sepsis' as [area],
      'Hand Hygiene' as [report],
      'true' as [latest/@Boolean]
    FOR XML PATH ('frontmatter'), type
  ),
  (
    SELECT
      '2019-01-01' as [date],
      'Sepsis Hand Hygiene Report' as [title],
      'with a subtitle' as [subtitle]
    FOR XML PATH ('header'), type
  ),
  (
    SELECT 'true' as [@json:Array], *
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
                    'true' as [@json:Array],
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
                    'true' as [@json:Array],
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
      )
    ) as sections ([name], [chart])
    FOR XML PATH ('sections'), type
  ),
  (
    SELECT
      '© 2020 Health Catalyst. All Rights Reserved.' as [text]
    FOR XML PATH ('footer'), type
  )
FOR XML PATH (''), ROOT ('root')
) as ReportXML