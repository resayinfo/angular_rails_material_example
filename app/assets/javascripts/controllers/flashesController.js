angular.module('fantasyLeagueFinder').controller('FlashesController', [
  '$log', '$scope', '$location', 'FlashMessages',
  function($log, $scope, $location, FlashMessages) {
    var init, isAlertFlash;
    init = function() {
      FlashMessages.setFlashes($('body').data('flash-messages'));
      $scope.flashes = FlashMessages.getFlashes();
    };
    isAlertFlash = function(flash) {
      return flash.type == 'alert';
    };
    $scope.flashClass = function(flash) {
      return isAlertFlash(flash) ? 'alert-danger' : 'alert-success';
    };
    $scope.removeFlash = function(flash) {
      FlashMessages.removeFlash(flash);
    };
    return init();
  }
]);