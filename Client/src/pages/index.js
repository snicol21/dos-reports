import React from "react"
import { graphql } from "gatsby"
// import Img from "gatsby-image"
import SEO from "../components/seo"

const IndexPage = ({ data }) => (
  <>
    <SEO title="Home" />
    <h2>Hi people</h2>
    <p>Welcome to your new Gatsby site.</p>
    <p>Last updated: {data.site.buildTime}</p>
    {/* <Img
      fluid={data.file.childImageSharp.fluid}
      style={{ maxWidth: `600px`, margin: `0 auto` }}
    /> */}
  </>
)

export default IndexPage

export const query = graphql`
  query {
    site {
      buildTime(formatString: "MMMM DD, YYYY")
    }
    # file(relativePath: { eq: "family_cute.jpg" }) {
    #   childImageSharp {
    #     fluid(maxWidth: 600) {
    #       ...GatsbyImageSharpFluid
    #     }
    #   }
    # }
  }
`
