React = require 'react'
{RouteHandler, Link} = require '@edpaget/react-router'
TalkBreadcrumbs = require './breadcrumbs.cjsx'
TalkSearchInput = require './search-input'
TalkFootnote = require './footnote'
{sugarClient} = require '../api/sugar'

module?.exports = React.createClass
  displayName: 'Talk'

  componentWillMount: ->
    sugarClient.subscribeTo @props.section or 'zooniverse'

  componentWillUnmount: ->
    sugarClient.unsubscribeFrom @props.section or 'zooniverse'

  render: ->
    <div className="talk content-container">
      <h1 className="talk-main-link">
        <Link to="talk" params={@props.params}>
          Zooniverse Talk
        </Link>
      </h1>

      <TalkBreadcrumbs {...@props} />

      <TalkSearchInput {...@props} placeholder={'Search the Zooniverse...'} />

      <RouteHandler {...@props} section={'zooniverse'} />

      <TalkFootnote />
    </div>
