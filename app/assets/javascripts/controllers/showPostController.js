angular.module('fantasyLeagueFinder.post').controller('ShowPostController', [
  '$log', '$window', '$scope', '$location', 'SessionService', 'Post', 'ViewState', 'ModalDialog', 'FlashMessages',
  function($log, $window, $scope, $location, SessionService, Post, ViewState, ModalDialog, FlashMessages) {
    var init, getPost, update, resetDeleteButton;
    init = function() {
      ViewState.current = 'showPost';
      $scope.currentUser = SessionService.getCurrentUser();
      $scope.isCreateForm = false;
      $scope.submitButtonText = 'Update';
      getPost();
    };
    getPost = function() {
      var id = $location.path().match(/\d+/)[0];
      Post.get(id).then(function(post) {
        $scope.post = post;
        $scope.legendText = 'Post ' + post.id;
        $scope.canModify = post.can_update;
        resetDeleteButton();
      }, function(error) {
        FlashMessages.flashErrors(error.data.errors);
      });
    };
    update = function() {
      return $scope.post.update().then(function() {
        FlashMessages.flashNotice("Successfully updated post #" + $scope.post.id);
      }, function(error) {
        FlashMessages.flashErrors(error.data.errors);
      });
    };
    resetDeleteButton = function() {
      $scope.canDestroy = $scope.post.can_update && !$scope.post.deleted_at;
    };
    $scope.deletePost = function() {
      if (ModalDialog.confirm("Are you sure you want to delete post #" + $scope.post.id + "?")) {
        return $scope.post.delete().then(function() {
          $scope.post.deleted_at = true;
          resetDeleteButton();
          FlashMessages.flashNotice("Successfully deleted post #" + $scope.post.id);
          return $scope.browseToOverview();
        }, function(error) {
          FlashMessages.flashErrors(error.data.errors);
        });
      }
    };
    $scope.submit = function() {
      return update();
    };
    $scope.browseToOverview = function() {
      return $location.path(Routes.posts_path());
    };
    return init();
  }
]);