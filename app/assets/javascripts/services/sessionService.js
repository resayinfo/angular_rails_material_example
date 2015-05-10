angular.module('fantasyLeagueFinder.services').factory('SessionService', [
  '$log', '$resource', function($log, $resource) {
    var authorized, currentUser, getCurrentUser, login, logout, service, updateCurrentUser;
    service = $resource(Routes.session_path(':param'), {}, {
      'login': {
        method: 'POST'
      },
      'logout': {
        method: 'DELETE'
      }
    });
    authorized = function() {
      return getCurrentUser().authorized === true;
    };
    login = function(newUser) {
      var promise;
      promise = service.login(newUser).$promise;
      promise.then(function(result) {
        return updateCurrentUser(result.user, !!result.user);
      });
      return promise;
    };
    logout = function() {
      var promise;
      promise = service.logout({
        param: currentUser.id
      }).$promise;
      updateCurrentUser({}, false);
      return promise;
    };
    currentUser = {};
    getCurrentUser = function() {
      return currentUser;
    };
    updateCurrentUser = function(user, authorized) {
      if (!!user){
        currentUser = user;
      }
      currentUser.authorized = authorized;
      return currentUser;
    };
    return {
      login: login,
      logout: logout,
      authorized: authorized,
      getCurrentUser: getCurrentUser,
      updateCurrentUser: updateCurrentUser
    };
  }
]);