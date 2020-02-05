const path = require("path")
const { createFilePath } = require("gatsby-source-filesystem")

exports.onCreateNode = ({ node, actions, getNode }) => {
  const { createNodeField } = actions
  if (node.internal.type === "Mdx") {
    const value = createFilePath({ node, getNode })
    createNodeField({
      name: "slug",
      node,
      value: `${value}`,
    })
  }
}

exports.createPages = async ({ graphql, actions, reporter }) => {
  const { createPage } = actions

  const reportTemplate = path.resolve("src/templates/report-template.js")

  const result = await graphql(`
    query {
      reports: allMdx(filter: { fileAbsolutePath: { regex: "/reports/" } }) {
        edges {
          node {
            fields {
              slug
            }
            id
          }
        }
      }
    }
  `)

  if (result.errors) {
    reporter.panicOnBuild("Error on createPages")
  }

  const reports = result.data.reports.edges
  reports.forEach(({ node }, index) => {
    createPage({
      path: node.fields.slug,
      component: reportTemplate,
      context: { id: node.id },
    })
  })
}
