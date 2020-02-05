import React from "react"
import { graphql, Link } from "gatsby"
import SEO from "../components/seo"
// import Icon from "../components/icon"

const IndexPage = ({ data }) => {
  const reports = data.allJson.edges
  return (
    <>
      <SEO title="Report" />
      {reports.map(report => (
        <div key={report.node.id} className="report">
          <h3 className="report-title">
            <Link to={report.node.fields.slug}>{report.node.title}</Link>
          </h3>
          {/* {report.node.frontmatter.subtitle && (
            <h5 className="report-subtitle">
              {report.node.frontmatter.subtitle}
            </h5>
          )} */}
          <small className="report-date">{report.node.date}</small>
          <p className="report-excerpt">excerpt</p>
          {/* {report.node.frontmatter.categories && (
            <div className="report-categories">
              {report.node.frontmatter.categories.map((category, i) => (
                <span key={i} className="report-category">
                  <Icon name={category}></Icon>
                </span>
              ))}
            </div>
          )} */}
        </div>
      ))}
    </>
  )
}

export default IndexPage

export const pageQuery = graphql`
  query {
    allJson(sort: { fields: date, order: DESC }) {
      edges {
        node {
          id
          title
          date
          parent {
            ... on File {
              id
              name
              relativeDirectory
            }
          }
          fields {
            slug
          }
        }
      }
    }
  }
`
