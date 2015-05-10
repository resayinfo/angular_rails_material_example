angular.module('fantasyLeagueFinder').controller('MainController', [
  '$log', '$window', '$scope', '$location', '$route', '$timeout','SessionService', 'ViewState', 'FlashMessages', 'Post',
  function($log, $window, $scope, $location, $route, $timeout, SessionService, ViewState, FlashMessages, Post) {
  var init, loginResultHandler, logoutResultHandler, attachMaterialListener;
  init = function() {
    var currentUser, $body;
    $body                     = $('body')
    currentUser               = $body.data('current-user');
    $scope.leagueTypes        = $body.data('league-types');
    $scope.sortOrderParam     = $body.data('sort-order-param');
    $scope.defaultSortOrder   = $body.data('default-sort-order');
    $scope.queryLimitParam    = $body.data('query-limit-param');
    $scope.defaultQueryLimit  = $body.data('default-query-limit');
    $scope.sortDirectionParam = $body.data('sort-direction-param');
    $scope.sessionService     = SessionService;

    if ($.isEmptyObject(currentUser)){
      $scope.currentUser = SessionService.getCurrentUser();
    } else {
      $scope.currentUser = SessionService.updateCurrentUser(currentUser, true);
    }
    getNewPost();
    attachMaterialListener();
  };
  $scope.currentMainViewClass = function(){
    return {
      posts:'main-view-posts',
      showUser:'main-view-show-user',
      showPost:'main-view-show-post',
      createUser:'main-view-create-user',
      createPost:'main-view-create-post'
    }[ViewState.current]
  };
  $scope.submitLogin = function() {
    return SessionService.login($scope.currentUser).then(loginResultHandler, function(error) {
      return FlashMessages.flashErrors(error.data.errors);
    });
  };
  $scope.logout = function() {
    return SessionService.logout().then(logoutResultHandler, function(error) {
      return FlashMessages.flashErrors(error.data.errors);
    });
  };
  $scope.navToAccount = function() {
    var userId = SessionService.getCurrentUser().id || 'new';
    return $location.path(Routes.user_path(userId));
  };
  $scope.createPost = function() {
    return $location.path(Routes.new_post_path());
  };
  loginResultHandler = function(result) {
    if (!!SessionService.authorized()) {
      $scope.currentUser = SessionService.getCurrentUser();
      $route.reload();
      getNewPost();
      return FlashMessages.flashNotice("Successfully logged in as " + $scope.currentUser.username);
    } else {
      return FlashMessages.flash('alert', 'Invalid username or password.');
    }
  };
  logoutResultHandler = function(result) {
    if (!SessionService.authorized()) {
      $scope.currentUser = SessionService.getCurrentUser();
      getNewPost();
      $route.reload();
      return FlashMessages.flashNotice("Successfully logged out");
    }
  };
  attachMaterialListener = function() {
    $scope.$on('$viewContentLoaded', function() {
      $timeout(function(){
        $.material.init();
      });
    });
  };
  getNewPost = function() {
    return Post.get('new').then(function(post) {
      $scope.canCreatePost = post.can_create;
    }, function(error) {
      error.data && FlashMessages.flashErrors(error.data.errors);
    });
  };
  return init();
}]);