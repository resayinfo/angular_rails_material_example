/*
  Service to provide a modal dialog.
 */
angular.module('fantasyLeagueFinder.services').factory('ModalDialog', [
  '$window', function($window) {
    return {
      confirm: function(message) {
        return $window.confirm(message);
      }
    };
  }
]);
