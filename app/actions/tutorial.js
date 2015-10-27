var apiClient = require('../api/client');

var tutorialActions = {
  createForProject: function(projectID) {
    return function(dispatch) {
      var tutorialData = {
        steps: [],
        language: 'en',
        links: {
          project: projectID
        }
      };

      return apiClient.type('tutorials').create(tutorialData).save();
    };
  },

  getByProject: function(projectID) {
    return function(dispatch) {
      return apiClient.type('tutorials').get({
        project_id: projectID
      }).then(function(tutorials) {
        var tutorial = tutorials[0];
        if (tutorial === undefined) {
          // TODO: How should we define the difference between a nonexistant tutorial
          // and one that hasn't been fetched yet? Is it null vs undefined?
        } else {
          dispatch({
            type: 'RECEIVE_TUTORIAL',
            projectID: projectID,
            tutorial: tutorial
          });
        }
      });
    }
  },

  getMedia: function(tutorialID) {
    return function(dispatch) {
      return apiClient.type('tutorials').get(tutorialID)
      .then(function(tutorial) {
        return tutorial.get('attached_images');
      })
      .catch(function() {
        return [];
      })
      .then(function(mediaResources) {
        return mediaResources.reduce(function(mappedByID, resource) {
          mappedByID[resource.id] = resource;
          return mappedByID;
        }, {});
      })
      .then(media)
        dispatch({
          type: 'RECEIVE_MEDIA_FOR_TUTORIAL',
          tutorialID: tutorialID,
          media: media
        });
      });
    }
  },

  appendStep: function(tutorialID) {
    return {
      type: 'APPEND_TUTORIAL_STEP',
      tutorialID: tutorialID
    };
  },

  removeStep: function(tutorialID, stepIndex) {
    return {
      type: 'REMOVE_TUTORIAL_STEP',
      tutorialID: tutorialID,
      stepIndex: stepIndex
    };
  },

  setStepMedia: function(tutorialID, stepIndex, file) {
    return function(dispatch) {
      return Promise.resolve('TODO').then(function() {
        dispatch({
          type: 'SET_TUTORIAL_STEP_MEDIA',
          tutorialID: tutorialID,
          stepIndex: stepIndex,
          file: file
        });
      })
    };
  },

  setStepContent: function(tutorialID, stepIndex, content) {
    return {
      type: 'SET_TUTORIAL_STEP_CONTENT',
      tutorialID: tutorialID,
      stepIndex: stepIndex,
      file: file
    };
  }
};

module.exports = tutorialActions;
