const path = require("path")
// const crypto = require("crypto")

exports.onCreateNode = ({ node, actions, createNodeId }) => {
  const { createNode, createNodeField, createParentChildLink } = actions
  if (node.internal.type === "data") {
    const slug = node.slug
    createNodeField({ name: "slug", node, value: `${slug}` })

    const routes = slug.split("/").filter(Boolean)
    for (let i = 0; i < routes.length - 1; i++) {
      const route = routes.slice(0, i + 1).join("/")
      createNodeField({ name: `slug${i}`, node, value: `/${route}/` })
    }

    node.report = JSON.parse(node.report) // parse the JSON string to an Object

    node.report.sections.forEach(async section => {
      // if ("markdown" in section) {
      //   const mdxContent = section.markdown.join("\n")
      //   createNode({
      //     id: createNodeId(`${node.id} >>> Mdx`),
      //     parent: null,
      //     children: [],
      //     internal: {
      //       type: `MyCustomMdxNodesFromString`,
      //       contentDigest: crypto
      //         .createHash(`md5`)
      //         .update(mdxContent)
      //         .digest(`hex`),
      //       mediaType: `text/markdown`,
      //       content: mdxContent,
      //       description: `My custom MDX nodes`,
      //     },
      //   })
      // }
      if ("figures" in section) {
        section.figures.forEach(figure => {
          if ("config" in figure) {
            figure.config = JSON.stringify(figure.config)
          }
        })
      }
    })
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
