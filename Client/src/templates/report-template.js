import React from "react"
import { graphql, Link } from "gatsby"
import SEO from "../components/seo"
// import Icon from "../components/icon"

const ReportLayout = ({ data: { json } }) => {
  return (
    <>
      <SEO title={json.title} />
      <div className="back">
        <Link to="/reports">
          <i className="arrow left"></i>
          {`Back to reports`}
        </Link>
      </div>
      <div className="report">
        <h3 className="report-title">{json.title}</h3>
        {/* {mdx.frontmatter.subtitle && (
          <h5 className="report-subtitle">{mdx.frontmatter.subtitle}</h5>
        )} */}
        <small className="report-date">{json.date}</small>
        <div className="report-body">body</div>
        {/* {mdx.frontmatter.categories && (
          <>
            <div className="report-categories-title">Categories</div>
            <div className="report-categories">
              {mdx.frontmatter.categories.map((category, i) => (
                <span key={i} className="report-category">
                  <Icon name={category}></Icon>
                </span>
              ))}
            </div>
          </>
        )} */}
      </div>
    </>
  )
}

export default ReportLayout

export const pageQuery = graphql`
  query ReportPageQuery($id: String) {
    json(id: { eq: $id }) {
      id
      date(formatString: "MMMM DD, YYYY")
      title
    }
  }
`
