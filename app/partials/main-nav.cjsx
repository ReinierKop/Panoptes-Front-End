counterpart = require 'counterpart'
React = require 'react'
Translate = require 'react-translate-component'
{Link} = require '@edpaget/react-router'
ZooniverseLogo = require './zooniverse-logo'

counterpart.registerTranslations 'en',
  nav:
    home: 'Zooniverse'
    projects: 'Projects'
    about: 'About'

module.exports = React.createClass
  displayName: 'MainNav'

  render: ->
    <nav className="main-nav">
      <Link to="home" className="main-header-item logo">
        <ZooniverseLogo />&nbsp;<Translate content="nav.home" />
      </Link>
      <Link to="projects" className="main-header-item"><Translate content="nav.projects" /></Link>
    </nav>
