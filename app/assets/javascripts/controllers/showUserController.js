angular.module('fantasyLeagueFinder.user').controller('ShowUserController', [
  '$log', '$window', '$scope', '$location', 'SessionService', 'User', 'ViewState', 'ModalDialog', 'FlashMessages',
  function($log, $window, $scope, $location, SessionService, User, ViewState, ModalDialog, FlashMessages) {
    var init, getUser, update, resetActivationButtons;
    init = function() {
      ViewState.current = 'showUser';
      $scope.currentUser = SessionService.getCurrentUser();
      $scope.isCreateForm = false;
      $scope.submitButtonText = 'Update';
      getUser();
    };
    getUser = function() {
      var id = $location.path().match(/\d+/)[0];
      User.get(id).then(function(user) {
        $scope.user = user
        resetActivationButtons();
        $scope.legendText = $scope.user.username + "'s Account";
        $scope.canModify = $scope.user.can_update;
      }, function(error) {
        FlashMessages.flashErrors(error.data.errors);
      });
    };
    update = function() {
      return $scope.user.update().then(function() {
        FlashMessages.flashNotice("Successfully updated " + $scope.user.username);
      }, function(error) {
        FlashMessages.flashErrors(error.data.errors);
      });
    };
    resetActivationButtons = function() {
      $scope.canActivate = $scope.currentUser.admin && $scope.user.can_update && !!$scope.user.deactivated_at;
      $scope.canDeactivate = $scope.currentUser.admin && $scope.user.can_update && !$scope.user.deactivated_at;
    };
    $scope.activateUser = function() {
      if (ModalDialog.confirm("Are you sure you want to activate " + $scope.user.username + "'s account?")) {
        var activationUser = new User({
          id: $scope.user.id,
          deactivated_at: null
        });
        return activationUser.update().then(function() {
          $scope.user.deactivated_at = null;
          resetActivationButtons();
          FlashMessages.flashNotice("Successfully activated " + $scope.user.username);
        }, function(error) {
          FlashMessages.flashErrors(error.data.errors);
        });
      }
    };
    $scope.deactivateUser = function() {
      if (ModalDialog.confirm("Are you sure you want to deactivate " + $scope.user.username + "'s account?")) {
        return $scope.user.delete().then(function() {
          $scope.user.deactivated_at = true;
          resetActivationButtons();
          FlashMessages.flashNotice("Successfully deactivated " + $scope.user.username);
        }, function(error) {
          FlashMessages.flashErrors(error.data.errors);
        });
      }
    };
    $scope.submit = function() {
      return update();
    };
    return init();
  }
]);