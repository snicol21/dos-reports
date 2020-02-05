import React from "react"
import { graphql, Link } from "gatsby"
import SEO from "../components/seo"
import Icon from "../components/icon"

const ReportsPage = ({ data }) => {
  const reports = data.allMdx.edges
  return (
    <>
      <SEO title="Report" />
      {reports.map(report => (
        <div key={report.node.id} className="report">
          <h3 className="report-title">
            <Link to={report.node.fields.slug}>
              {report.node.frontmatter.title}
            </Link>
          </h3>
          {report.node.frontmatter.subtitle && (
            <h5 className="report-subtitle">{report.node.frontmatter.subtitle}</h5>
          )}
          <small className="report-date">{report.node.frontmatter.date}</small>
          <p className="report-excerpt">{report.node.excerpt}</p>
          {report.node.frontmatter.categories && (
            <div className="report-categories">
              {report.node.frontmatter.categories.map((category, i) => (
                <span key={i} className="report-category">
                  <Icon name={category}></Icon>
                </span>
              ))}
            </div>
          )}
        </div>
      ))}
    </>
  )
}

export default ReportsPage

export const pageQuery = graphql`
  query {
    allMdx(
      filter: { fileAbsolutePath: { regex: "/reports/" } }
      sort: { fields: frontmatter___date, order: DESC }
    ) {
      edges {
        node {
          excerpt(pruneLength: 185)
          fields {
            slug
          }
          frontmatter {
            categories
            date(formatString: "MMMM DD, YYYY")
            subtitle
            title
          }
          id
        }
      }
    }
  }
`
