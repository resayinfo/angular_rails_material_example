angular.module('fantasyLeagueFinder.user').controller('CreateUserController', [
  '$log', '$scope', '$location', 'SessionService', 'User', 'ViewState', 'FlashMessages',
  function($log, $scope, $location, SessionService, User, ViewState, FlashMessages) {
    var init, getNewUser;
    init = function() {
      ViewState.current = 'createUser';
      $scope.currentUser = SessionService.getCurrentUser();
      $scope.isCreateForm = true;
      $scope.submitButtonText = 'Register';
      $scope.legendText = 'Create User';
      getNewUser();
    };
    getNewUser = function() {
      User.get('new').then(function(user) {
        $scope.canModify = user.can_create;
        return $scope.user = user;
      }, function(error) {
        FlashMessages.flashErrors(error.data.errors);
      });
    };
    $scope.submit = function() {
      $scope.user.create().then(function() {
        FlashMessages.flashNotice("Successfully created account for " + $scope.user.username);
        if (!SessionService.authorized()){
          SessionService.login($scope.user).then(function() {
            if (!!SessionService.authorized()) {
              $scope.currentUser = SessionService.getCurrentUser();
              FlashMessages.flashNotice("Successfully logged in as " + $scope.currentUser.username);
              return $location.path(Routes.user_path($scope.currentUser.id));
            }
          });
        } else {
          return $location.path(Routes.user_path($scope.user.id));
        }
      }, function(error) {
        return FlashMessages.flashErrors(error.data.errors);
      });
    };
    $scope.browseToOverview = function() {
      User.instance = void 0;
      return $location.path(Routes.posts_path());
    };
    return init();
  }
]);