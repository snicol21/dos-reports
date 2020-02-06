const path = require("path")
const { createFilePath } = require("gatsby-source-filesystem")

exports.onCreateNode = ({ node, actions, getNode }) => {
  const { createNodeField } = actions
  if (node.internal.type === "json") {
    const slug = createFilePath({ node, getNode })
    createNodeField({ name: "slug", node, value: `${slug}` })

    const routes = slug.split("/").filter(Boolean)
    for (let i = 0; i < routes.length - 1; i++) {
      const route = routes.slice(0, i + 1).join("/")
      createNodeField({ name: `slug${i}`, node, value: `/${route}/` })
    }
  }
}

exports.createPages = async ({ graphql, actions, reporter }) => {
  const { createPage } = actions

  const reportTemplate = path.resolve("src/templates/report-template.js")

  const result = await graphql(`
    query {
      reports: allJson {
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
