angular.module('fantasyLeagueFinder').controller('PostsController', [
  '$log', '$window', '$scope', '$location', '$route', 'Post', 'ViewState', 'ModalDialog', 'FlashMessages',
  function($log, $window, $scope, $location, $route, Post, ViewState, ModalDialog, FlashMessages) {
    var getPosts, init, initFilterSelect2, initOrderSelect2, initDirectionButton,
        resetSearchParamsAndReload, initLeagueTypeAndLoad;
    init = function() {
      ViewState.current = 'posts';
      var params = $location.$$search;
      $scope.selectedFilters = params;
      $scope.selectedPost = {};
      $scope.qParam = params['q'];
      $scope.queryLimit = params[$scope.queryLimitParam] || $scope.defaultQueryLimit;
      $scope.queryLimit = parseInt($scope.queryLimit);
      $scope.sortOrder = params[$scope.sortOrderParam] || $scope.defaultSortOrder;
      initDirectionButton(params[$scope.sortDirectionParam]);
      initLeagueTypeAndLoad(params['league_type']);
    };
    initDirectionButton = function(direction) {
      if (_.isString(direction) && direction == 'ASC') {
        $scope.sortDirection = 'ASC';
      } else {
        $scope.sortDirection = 'DESC';
      }
    };
    initLeagueTypeAndLoad = function(leagueType) {
      if(s.isBlank(leagueType)){
        $scope.leagueType = 'FootballLeague';
        resetSearchParamsAndReload();
      }else{
        $scope.leagueType = leagueType;
        getPosts($location.$$search);
      }
    };
    getPosts = _.debounce(function(params) {
      return Post.query(_.extend({}, params)).then(function(posts) {
        return $scope.posts = posts;
      }, function(error) {
        error.data && FlashMessages.flashErrors(error.data.errors);
      });
    }, 500);
    numberStringToMoney = function(str){
      return '$' + s.numberFormat(s.toNumber(str, 2), 2);
    };
    isDateAttribute = function(attrName){
      return (
        attrName.split(/_at$/)[1]=='' ||
        attrName.split(/_date$/)[1]=='' ||
        attrName.split(/_deadline$/)[1]==''
      );
    };
    attributeDisplayValue = function(post, modelName, attrName) {
      var value;
      if(modelName=='posts'){
        value = post[attrName];
      }else{
        value = post['league'][attrName];
      }
      if(isDateAttribute(attrName)){
        // treat as a timestamp
        return moment(value).format("M/DD/YY h:mma");
      }else if(attrName == 'entry_fee'){
        return numberStringToMoney(value);
      }else if(s.isBlank(value)){
        return '-';
      }else{
        return value;
      }
    };
    resetSearchParamsAndReload = function(){
      $location.search({});
      $location.search('league_type', $scope.leagueType)
      $location.search($scope.sortDirectionParam, $scope.sortDirection);
      $location.search($scope.sortOrderParam, $scope.defaultSortOrder);
      if(!s.isBlank($scope.qParam)){
        $location.search('q', $scope.qParam);
      }
      $route.reload();
    };
    $scope.updateLeagueType = function(leagueType){
      if($scope.leagueType == leagueType){
        // same params.. do nothing
        return null;
      }
      $scope.leagueType = leagueType;
      resetSearchParamsAndReload();
    }
    $scope.rowClassesForPost = function(post){
      return {
        'info selected' : post.id == $scope.selectedPost.id
      };
    }
    $scope.postOrderModelName = function() {
      return $scope.sortOrder.split(/\./)[0];
    };
    $scope.postOrderAttributeName = function() {
      return $scope.sortOrder.split(/\./)[1];
    };
    $scope.postOrderAttributeDisplayName = function() {
      return s.humanize($scope.postOrderAttributeName());
    };
    $scope.leagueEntryFee = function(league) {
      return numberStringToMoney(league.entry_fee)
    };
    $scope.leagueTeamsAvailable = function(league) {
      league = league || {};
      return league.teams_filled + '/' + league.teams;
    };
    $scope.leagueDraftDate = function(league) {
      return moment(league.draft_date).format("M/DD/YY h:mma");
    };
    $scope.postOrderAttributeDisplayValue = function(post) {
      return attributeDisplayValue(post, $scope.postOrderModelName(), $scope.postOrderAttributeName());
    };
    $scope.updateQparam = function() {
      $location.search('q', $scope.qParam)
      getPosts($location.$$search);
    };
    $scope.updateQueryLimit = function() {
      $location.search($scope.queryLimitParam, $scope.queryLimit);
      getPosts($location.$$search);
    };
    $scope.toggleDirection = function() {
      if ($scope.sortDirection == 'ASC') {
        $scope.sortDirection = 'DESC';
      } else {
        $scope.sortDirection = 'ASC';
      }
      $location.search($scope.sortDirectionParam, $scope.sortDirection);
      getPosts($location.$$search);
    };
    $scope.updateSortOrder = function(order) {
      $scope.sortOrder = order;
      $location.search($scope.sortOrderParam, $scope.sortOrder);
      getPosts($location.$$search);
    };
    $scope.selectPost = function(post) {
      $scope.selectedPost = post;
    };
    $scope.canDestroy = function() {
      return $scope.selectedPost.can_destroy;
    };
    $scope.showPost = function() {
      return $location.path(Routes.post_path($scope.selectedPost.id));
    };
    $scope.deletePost = function() {
      var post = $scope.selectedPost;
      if (ModalDialog.confirm("Are you sure you want to delete post #" + post.id + "?")) {
        return post["delete"]({
          post_id: post.id
        }).then(function() {
          FlashMessages.flashNotice("Successfully deleted post #" + post.id);
          return getPosts($location.$$search);
        }, function(error) {
          FlashMessages.flashErrors(error.data.errors);
        });
      }
    };
    $scope.addFilterParam = function(p) {
      $location.search(p.id, p.val);
      getPosts($location.$$search);
    };
    $scope.removeFilterParam = function(p) {
      $location.search(p.id, null);
      getPosts($location.$$search);
    };
    return init();
  }
]);