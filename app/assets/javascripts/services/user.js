angular.module('fantasyLeagueFinder.services').factory('User', [
  '$log', 'railsResourceFactory', function($log, railsResourceFactory) {
    var resource;
    return resource = railsResourceFactory({
      url: Routes.api_v1_users_path(),
      name: 'user'
    });
  }
]);
