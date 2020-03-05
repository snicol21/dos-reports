WITH XMLNAMESPACES ('http://james.newtonking.com/projects/json' as [json])
SELECT (
SELECT
  (
    SELECT
      'Examples' as [domain],
      'Templates' as [area],
      'Line Charts' as [report],
      'Line Charts' as [title],
      'Example report using line charts' as [subtitle],
      '2020-02-10' as [date],
      'true' as [latest/@Boolean]
    FOR XML PATH ('header'), type
  ),
  (
    SELECT 'true' as [@json:Array],
        (
          SELECT 'true' as [@json:Array], *
          FROM (VALUES
            ('## Section 1'),
            (' * List Item 1'),
            (' * List Item 2')
          ) as md ([markdown])
          FOR XML PATH ('markdown'), type
        ),
        (
          SELECT 'true' as [@json:Array], *
          FROM (VALUES
            (
              (
                SELECT
                  'line-chart' as [type],
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
                  ) as [config]
                FOR XML PATH (''), type
              )
            )
          ) as f ([figures])
          FOR XML PATH ('figures'), type
        )
    FOR XML PATH ('sections'), type
  ),
  (
    SELECT 
        (
          SELECT 'true' as [@json:Array], *
          FROM (VALUES
            ('© 2020 Health Catalyst. All Rights Reserved.')
          ) as md ([markdown])
          FOR XML PATH ('markdown'), type
        )
    FOR XML PATH ('footer'), type
  )
FOR XML PATH (''), ROOT ('root')
) as ReportXML