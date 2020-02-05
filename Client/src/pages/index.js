import React from "react"
import { graphql, Link } from "gatsby"
import SEO from "../components/seo"

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
          <small className="report-date">{report.node.date}</small>
          <p className="report-excerpt">excerpt</p>
        </div>
      ))}
    </>
  )
}

export default IndexPage

export const pageQuery = graphql`
  query {
    allJson(
      sort: { fields: date, order: DESC }
      filter: { latest: { eq: true } }
    ) {
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
