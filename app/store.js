var combineReducers = require('redux').combineReducers;
var applyMiddleware = require('redux').applyMiddleware;
var thunk = require('redux-thunk');
var createStore = require('redux').createStore;

var reducer = combineReducers({
  projects: require('./reducers/projects'),
  tutorials: require('./reducers/tutorials')
});

module.exports = applyMiddleware(thunk)(createStore)(reducer);
window.zooStore = module.exports
