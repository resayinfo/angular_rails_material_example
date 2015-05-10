angular.module('fantasyLeagueFinder.post').controller('CreatePostController', [
  '$log', '$scope', '$location', 'SessionService', 'Post', 'ViewState', 'FlashMessages',
  function($log, $scope, $location, SessionService, Post, ViewState, FlashMessages) {
    var init, getNewPost;
    init = function() {
      ViewState.current = 'createPost';
      $scope.currentUser = SessionService.getCurrentUser();
      $scope.isCreateForm = true;
      $scope.submitButtonText = 'Add';
      $scope.legendText = 'Create Post';
      getNewPost();
    };
    getNewPost = function() {
      Post.get('new').then(function(post) {
        $scope.post = post;
        $scope.post.user_id = $scope.currentUser.id;
        $scope.canModify = $scope.post.can_create;
      }, function(error) {
        FlashMessages.flashErrors(error.data.errors);
      });
    };
    $scope.submit = function() {
      return $scope.post.create().then(function() {
          FlashMessages.flashNotice("Successfully created post #" + $scope.post.id);
          $location.path(Routes.post_path($scope.post.id));
      }, function(error) {
        FlashMessages.flashErrors(error.data.errors);
      });
    };
    $scope.browseToOverview = function() {
      Post.instance = void 0;
      return $location.path(Routes.posts_path());
    };
    return init();
  }
]);