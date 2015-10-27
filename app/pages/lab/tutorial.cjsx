React = require 'react'
apiClient = require '../../api/client'
putFile = require '../../lib/put-file'
FileButton = require '../../components/file-button'
{MarkdownEditor} = require 'markdownz'
debounce = require 'debounce'
{Provider, connect} = require 'react-redux'
store = require '../../store'
projectActions = require '../../actions/project'
tutorialActions = require '../../actions/tutorial'

TutorialStepEditor = React.createClass
  getDefaultProps: ->
    mediaSrc: ''
    content: ''
    onRemove: -> console.warn 'TutorialStepEditor onRemove', arguments
    onMediaChange: -> console.warn 'TutorialStepEditor onMediaChange', arguments
    onContentChange: -> console.warn 'TutorialStepEditor onContentChange', arguments

  render: ->
    <div style={
      border: '1px solid'
      marginBottom: '1em'
    }>
      <header>
        <button type="button" onClick={@props.onRemove}>Remove step</button>
      </header>
      <div>
        <header>Media</header>
        {if @props.mediaSrc
          <div>
            <img src={@props.mediaSrc} style={
              maxHeight: '5em'
              maxWidth: '100%'
            } />
            <button type="button" className="minor-button" onClick={@handleMediaChange}>Clear media</button>
          </div>}
        <FileButton className="standard-button" onSelect={@handleMediaChange}>Select</FileButton>
      </div>
      <div>
        <header>Content</header>
        <MarkdownEditor value={@props.content} onChange={@handleContentChange} />
      </div>
    </div>

  handleMediaChange: (e) ->
    @props.onMediaChange e.target.files?[0], arguments...

  handleContentChange: (e) ->
    @props.onContentChange e.target.value, arguments...


TutorialEditor = React.createClass
  getDefaultProps: ->
    steps: []
    media: {}
    onStepAdd: -> console.warn 'TutorialEditor onStepAdd', arguments
    onStepRemove: -> console.warn 'TutorialEditor onStepRemove', arguments
    onStepMediaChange: -> console.warn 'TutorialEditor onMediaChange', arguments
    onStepContentChange: -> console.warn 'TutorialEditor onStepContentChange', arguments

  render: ->
    <div>
      <div>
        <p>Here’s some text all about the tutorial editor. Lorem ipsum dolor sit amet, etc.</p>
        <p><strong>Work in progress.</strong></p>
      </div>
      <div>
        {if @props.steps.length is 0
          <p>This tutorial has no steps.</p>
        else
          for step, i in @props.steps
            step._key ?= Math.random()
            <TutorialStepEditor
              key={step._key}
              mediaSrc={@props.media[step.media]?.src}
              content={step.content}
              onRemove={@props.onStepRemove.bind null, i}
              onMediaChange={@props.onStepMediaChange.bind null, i}
              onContentChange={@props.onStepContentChange.bind null, i}
            />}
      </div>
      <div>
        <button type="button" onClick={@props.onStepAdd}>Add a step</button>
      </div>
    </div>


TutorialEditorController = React.createClass
  getDefaultProps: ->
    tutorial: null
    media: {}
    dispatch: -> console.warn 'TutorialEditorController dispatch', arguments

  render: ->
    <TutorialEditor
      steps={@props.tutorial.steps}
      media={@props.media}
      onStepAdd={@handleStepAdd}
      onStepRemove={@handleStepRemove}
      onStepMediaChange={@handleStepMediaChange}
      onStepContentChange={@handleStepContentChange}
    />

  handleStepAdd: ->
    @props.dispatch tutorialActions.appendStep @props.tutorial.id

  handleStepRemove: (index) ->
    @props.dispatch tutorialActions.removeStep @props.tutorial.id, index

  handleStepMediaChange: (index, file) ->
    @props.dispatch tutorialActions.setStepMedia @props.tutorial.id, index, file

  handleStepContentChange: (index, content) ->
    @props.dispatch tutorialActions.setStepContent @props.tutorial.id, index, content


TutorialCreator = React.createClass
  getDefaultProps: ->
    project: null
    dispatch: -> console.warn 'TutorialCreator dispatch', arguments

  render: ->
    <div>
      <p>This project doesn’t have a tutorial.</p>
      <p>
        <button type="button" onClick={@handleCreateClick}>Build one</button>
      </p>
    </div>

  handleCreateClick: ->
    @props.dispatch tutorialActions.createForProject @props.project.id


mapStateToProps = (state, ownProps) ->
  tutorial = state.tutorials.byProject[ownProps.project.id]
  media = {}
  {tutorial, media}

TutorialEditorRoot = connect(mapStateToProps) React.createClass
  getDefaultProps: ->
    project: null
    tutorial: null

  componentDidMount: ->
    @fetchTutorialFor @props.project
    if @props.tutorial?
      @fetchMediaFor @props.tutorial

  componentWillReceiveProps: (nextProps) ->
    unless nextProps.project is @props.project
      @fetchTutorialFor nextProps.project
    unless nextProps.tutorial is @props.tutorial
      @fetchMediaFor nextProps.tutorial

  fetchTutorialFor: (project) ->
    tutorialActions.getByProject project.id

  fetchMediaFor: (tutorial) ->
    tutorialActions.getMedia tutorial.id

  render: ->
    if @props.tutorial?
      <div TutorialEditorController steps={@props.tutorial.steps} media={@props.media} dispatch={@props.dispatch} />
      <p>Edit</p>
    else
      <div TutorialCreator dispatch={@props.dispatch} />
      <p>Create</p>


TemporaryTutorialEditorRoot = React.createClass
  getDefaultProps: ->
    project: null

  render: ->
    <Provider store={store}>{=>
      <TutorialEditorRoot project={@props.project} />
    }</Provider>


module.exports = TemporaryTutorialEditorRoot
