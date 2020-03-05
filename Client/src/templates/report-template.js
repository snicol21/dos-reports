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
      <SEO title={report.header.title} />
      <div className="back">
        <Link to="/">
          <i className="arrow left"></i>
          {`Back to reports`}
        </Link>
      </div>
      <div className="report">
        <h3 className="report-title">{report.header.title}</h3>
        <small className="report-date">{report.header.date}</small>
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
        header {
          date(formatString: "MMMM DD, YYYY")
          title
        }
      }
    }
  }
`

/*
        {report.sections.map((section, sectionIndex) => (
          // <MDXRenderer key={`${sectionIndex}`}>{section.md}</MDXRenderer>
          <div key={`${sectionIndex}`}>{section.md}</div>
        ))}
*/
