import React from "react"
import { graphql, Link } from "gatsby"
import SEO from "../components/seo"

const ReportLayout = ({ data: { json } }) => {
  return (
    <>
      <SEO title={json.title} />
      <div className="back">
        <Link to="/">
          <i className="arrow left"></i>
          {`Back to reports`}
        </Link>
      </div>
      <div className="report">
        <h3 className="report-title">{json.title}</h3>
        <small className="report-date">{json.date}</small>
        <div className="report-body">body</div>
      </div>
    </>
  )
}

export default ReportLayout

export const pageQuery = graphql`
  query($id: String) {
    json(id: { eq: $id }) {
      id
      date(formatString: "MMMM DD, YYYY")
      title
    }
  }
`
