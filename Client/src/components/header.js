import React from "react"
import { Link } from "gatsby"
import Img from "gatsby-image"
import { useStaticQuery, graphql } from "gatsby"
import PropTypes from "prop-types"

const Header = ({ siteMetadata }) => {
  const data = useStaticQuery(graphql`
    query {
      logo: file(relativePath: { eq: "logo.png" }) {
        childImageSharp {
          fixed(width: 92) {
            ...GatsbyImageSharpFixed_withWebp_noBase64
          }
        }
      }
    }
  `)

  return (
    <>
      <header>
        <Link to="/">
          <h1>{siteMetadata.title}</h1>
          <div>{siteMetadata.subtitle}</div>
        </Link>
        <Link to="/">
          <Img loading="eager" fixed={data.logo.childImageSharp.fixed} />
        </Link>
      </header>
      <nav>
        <Link to="/" activeClassName="active">
          Reports
        </Link>
      </nav>
    </>
  )
}

Header.propTypes = {
  siteTitle: PropTypes.string,
}

Header.defaultProps = {
  siteTitle: ``,
}

export default Header
