import React from "react"
import { graphql, Link } from "gatsby"
import SEO from "../components/seo"

const IndexPage = ({ data }) => {
  const reports = data.allData.edges
  return (
    <>
      <SEO title="Report" />
      {reports.map(report => (
        <div key={report.node.id} className="report">
          <h3 className="report-title">
            <Link to={report.node.fields.slug}>{report.node.report.title}</Link>
          </h3>
          <small className="report-date">{report.node.report.date}</small>
          <p className="report-excerpt">excerpt</p>
        </div>
      ))}
    </>
  )
}

export default IndexPage

export const pageQuery = graphql`
  query {
    allData(
      sort: { fields: report___date, order: DESC }
      filter: { report: { latest: { eq: true } } }
    ) {
      edges {
        node {
          id
          report {
            title
            date
          }
          fields {
            slug
          }
        }
      }
    }
  }
`
