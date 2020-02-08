const path = require("path")

exports.onCreateNode = ({ node, actions, getNode }) => {
  const { createNodeField } = actions
  if (node.internal.type === "data") {
    const slug = node.slug
    createNodeField({ name: "slug", node, value: `${slug}` })

    const routes = slug.split("/").filter(Boolean)
    for (let i = 0; i < routes.length - 1; i++) {
      const route = routes.slice(0, i + 1).join("/")
      createNodeField({ name: `slug${i}`, node, value: `/${route}/` })
    }

    node.report = JSON.parse(node.report) // parse the JSON string to an Object
  }
}

exports.createPages = async ({ graphql, actions, reporter }) => {
  const { createPage } = actions
  const reportTemplate = path.resolve("src/templates/report-template.js")
  const result = await graphql(`
    query {
      reports: allData {
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
