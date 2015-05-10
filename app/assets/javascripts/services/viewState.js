/*
  Simple Service to share data of current view state, which is acting as a domain model.
  The view state set by controllers.


  Current view states are:
    'login'
    'posts'
    'edit'
    'create'
 */
angular.module('fantasyLeagueFinder.services').factory('ViewState', [
  '$log', function($log) {
    var current;
    current = 'login';
    return {
      current: current
    };
  }
]);
