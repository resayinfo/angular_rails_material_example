// defining all routes
angular.module('fantasyLeagueFinder').config([
  '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {

    $routeProvider.when(Routes.posts_path(), {
      templateUrl: '/posts/index.html',
      controller: 'PostsController',
      reloadOnSearch: false
    }).when(Routes.new_post_path(), {
      templateUrl: '/posts/show.html',
      controller: 'CreatePostController'
    }).when(Routes.post_path(':id'), {
      templateUrl: '/posts/show.html',
      controller: 'ShowPostController'
    }).when(Routes.new_user_path(), {
      templateUrl: '/users/show.html',
      controller: 'CreateUserController'
    }).when(Routes.user_path(':id'), {
      templateUrl: '/users/show.html',
      controller: 'ShowUserController'
    }).otherwise({
      redirectTo: Routes.posts_path()
    });

    return $locationProvider.html5Mode(true);
  }
]);