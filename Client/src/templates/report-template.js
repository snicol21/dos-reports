import React from "react"
import { graphql, Link } from "gatsby"
import SEO from "../components/seo"

const ReportLayout = ({
  data: {
    data: { report },
  },
}) => {
  return (
    <>
      <SEO title={report.title} />
      <div className="back">
        <Link to="/">
          <i className="arrow left"></i>
          {`Back to reports`}
        </Link>
      </div>
      <div className="report">
        <h3 className="report-title">{report.title}</h3>
        <small className="report-date">{report.date}</small>
        <div className="report-body">body</div>
      </div>
    </>
  )
}

export default ReportLayout

export const pageQuery = graphql`
  query($id: String) {
    data(id: { eq: $id }) {
      id
      report {
        date(formatString: "MMMM DD, YYYY")
        title
      }
    }
  }
`
