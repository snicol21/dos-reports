// if (process.env.NODE_ENV !== `production`) {
require(`dotenv`).config({ path: `.env` })
// }
const env = db_env_var => process.env[`${db_env_var}`]

const SqlDbConnection = () => ({
  client: `mssql`,
  connection: {
    domain: env(`DOS_REPORTS_SQL_USER_DOMAIN`),
    user: env(`DOS_REPORTS_SQL_USER_NAME`),
    password: env(`DOS_REPORTS_SQL_USER_PASSWORD`),
    server: env(`DOS_REPORTS_SQL_SERVER`),
    database: env(`DOS_REPORTS_SQL_DATABASE`),
    options: { encrypt: true },
  },
})

module.exports = {
  siteMetadata: {
    title: `DOS Reports`,
    subtitle: `Health Catalyst`,
    description: `DOS Reports generates static reports from markdown files.`,
    author: `Spencer Nicol`,
  },
  plugins: [
    `gatsby-plugin-react-helmet`,
    `gatsby-transformer-sharp`,
    `gatsby-plugin-sharp`,
    `gatsby-plugin-sass`,
    `gatsby-plugin-mdx`,
    {
      resolve: `gatsby-source-sql`,
      options: {
        typeName: `data`,
        fieldName: `data`,
        dbEngine: SqlDbConnection(),
        queryChain: function(x) {
          return x.raw(`
          SELECT ReportKEY AS slug
                ,ReportJSON AS report
                ,StatusCD as status
          FROM [Shared].[Reports].[DosReportsBASE]
          WHERE StatusCD = 'Active'
          `)
        },
      },
    },
    {
      resolve: `gatsby-source-filesystem`,
      options: {
        name: `images`,
        path: `${__dirname}/src/images`,
        ignore: [`/adobe-xd/`],
      },
    },
    {
      resolve: `gatsby-plugin-layout`,
      options: {
        component: `${__dirname}/src/components/layout.js`,
      },
    },
    {
      resolve: `gatsby-plugin-manifest`,
      options: {
        name: `DOS Reports`,
        short_name: `DOS Reports`,
        start_url: `/`,
        background_color: `#fff`,
        theme_color: `#fff`,
        display: `minimal-ui`,
        icon: `src/images/logo.png`, // This path is relative to the root of the site.
      },
    },
    `gatsby-plugin-offline`, // Put this at the end of everything so that it all gets cached (especially the manifest)
  ],
}
