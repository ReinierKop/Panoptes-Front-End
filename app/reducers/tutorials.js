var DEFAULT_STEP = {
  media: '',
  content: ''
};

module.exports = function(state, action) {
  if (state === undefined) {
    return {
      byProject: {}
    };
  }

  switch (action.type) {
    case 'RECEIVE_TUTORIAL':
      var newState = Object.assign({}, state);
      newState[action.tutorial.id] = action.tutorial;
      newState.byProject = Object.assign({}, newState.byProject);
      newState.byProject[action.projectID] = action.tutorial.id;
      return newState;

    case 'APPEND_TUTORIAL_STEP':
      var newState = Object.assign({}, state);
      newState[action.tutorialID] = Object.assign({}, state[tutorialID]);
      newState[action.tutorialID].steps = [].concat(addition[action.tutorialID].steps);
      var newStep = Object.assign({}, DEFAULT_STEP);
      newState[action.tutorialID].steps.push(newStep);
      return newState;

    case 'REMOVE_TUTORIAL_STEP':
      var newState = Object.assign({}, state);
      newState[action.tutorialID] = Object.assign({}, state[tutorialID]);
      newState[action.tutorialID].steps = [].concat(addition[action.tutorialID].steps);
      newState[action.tutorialID].steps.splice(action.index, 1);
      return newState;

    case 'SET_TUTORIAL_STEP_MEDIA':
      var newState = Object.assign({}, state);
      return newState;

    case 'SET_TUTORIAL_STEP_CONTENT':
      var newState = Object.assign({}, state);
      return newState;

    default:
      return state;
  }
}
