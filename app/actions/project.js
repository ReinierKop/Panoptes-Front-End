var apiClient = require('../api/client');

module.exports = {
  getByID: function(projectID) {
    return function(dispatch) {
      return apiClient.type('projects').get(projectID).then(function(project) {
        dispatch({
          type: 'PROJECT_RECEIVED',
          project: project
        });
      });
    }
  }
};
