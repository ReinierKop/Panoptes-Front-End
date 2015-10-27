module.exports = function(state, action) {
  if (state === undefined) {
    return {};
  }

  switch (action.type) {
    case 'PROJECT_RECEIVED':
      var addition = {};
      addition[action.project.id] = actions.project;
      var newState = Object.assign({}, state, addition);
      return newState;

    default:
      return state;
  }
}
