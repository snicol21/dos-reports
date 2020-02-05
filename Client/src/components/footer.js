import React from "react"
import { useStaticQuery, graphql } from "gatsby"

const Footer = () => {
  const data = useStaticQuery(graphql`
    query {
      site {
        siteMetadata {
          subtitle
        }
      }
    }
  `)

  return (
    <footer>
      © {new Date().getFullYear()} {data.site.siteMetadata.subtitle}. All Rights
      Reserved. Built with
      {` `}
      <a href="https://www.gatsbyjs.org">Gatsby</a>
    </footer>
  )
}

export default Footer
