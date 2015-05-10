angular.module('fantasyLeagueFinder.services', [
  'ngAnimate',
  'ngResource',
  'rails',
  'ng-rails-csrf'
]);

angular.module('fantasyLeagueFinder.post', [
  'ngRoute',
  'fantasyLeagueFinder.services'
]);

angular.module('fantasyLeagueFinder.user', [
  'ngRoute',
  'fantasyLeagueFinder.services'
]);

angular.module('fantasyLeagueFinder', [
  'fantasyLeagueFinder.post',
  'fantasyLeagueFinder.user',
  'fantasyLeagueFinder.services'
]);

angular.module('fantasyLeagueFinder').config(["railsSerializerProvider", function(railsSerializerProvider) {
    railsSerializerProvider.underscore(angular.identity).camelize(angular.identity);
}]);