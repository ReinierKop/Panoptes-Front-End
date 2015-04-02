handleInputChange = require './handle-input-change'

DEFAULT_UNSAVED_CHANGES_WARNING = '''
    Are you sure you want to leave this page?
    **You will lose your unsaved changes.**
  '''

module.exports =
  statics:
    willTransitionFrom: (transition, component) ->
      resource = component._getResource()

      if resource.hasUnsavedChanges()
        confirmLeave = confirm component.unsavedChangesWarning ? DEFAULT_UNSAVED_CHANGES_WARNING

        if confirmLeave
          resource.refresh()
        else
          transition.abort()

  getInitialState: ->
    saveError: null
    saveInProgress: false
    saved: false

  _getResource: ->
    if typeof @boundResource is 'function'
      @boundResource()
    else if typeof @boundResource is 'string'
      @props[@boundResource]
    else
      throw new Error 'Define `Component::boundResource` when using BoundResourceMixin.'

  handleChange: ->
    @setState saved: false
    handleInputChange.apply @_getResource(), arguments

  saveResource: ->
    @setState
      saveInProgress: true
      saveError: null
      saved: false

    @_getResource().save()
      .then =>
        @setState saved: true
      .catch (error) =>
        @setState saveError: error
      .then =>
        @setState saveInProgress: false

  renderSaveStatus: ->
    if @state.saveInProgress
      <span className="form-help">Saving...</span>
    else if @state.saveError
      <span className="form-help error">{@state.saveError.message}</span>
    else if @state.saved
      <span className="form-help success">Saved!</span>