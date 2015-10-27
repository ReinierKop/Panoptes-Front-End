var apiClient = require('../api/client');

module.exports = {
  get: function(type, whatToGet) {
    return function(dispatch) {
      apiClient.type(type).get(whatToGet).then(function(resources) {
        resourcesForcedArray = [].concat(resources);
        resourcesForcedArray.forEach(function(resource) {
          dispatch({
            type: 'GET_RESOURCE',
            resourceType: type,
            resource: resource
          });
        });
      });
    }
  }
};
