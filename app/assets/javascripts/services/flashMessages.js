angular.module('fantasyLeagueFinder.services').factory('FlashMessages', [
  '$log', '$resource', '$timeout', function($log, $resource, $timeout) {
    var flashes, flashTimeout, flashCounter, setFlashes, getFlashes, flash, flashErrors, flashNotice, removeFlash;
    flashes = [];
    flashTimeout = 10000;
    setFlashes = function(new_flashes) {
      new_flashes.map(function(f, index){
        return flash(f.type, f.message);
      });
    };
    getFlashes = function() {
      return flashes;
    };
    flash = function(type, message) {
      var f = {
        type: type,
        message: message
      }

      flashes.push(f);

      $timeout(function () {
        removeFlash(f);
      }, flashTimeout);
    };
    flashErrors = function(errors) {
      message = Object.keys(errors).map(function(field, index){
        return field + " " + errors[field];
      }).join(", ");

      flash('alert', message);
    };
    flashNotice = function(notice) {
      flash('notice', notice);
    };
    removeFlash = function(f) {
      var index = flashes.indexOf(f);
      if (index > -1) {
        flashes.splice(index, 1);
      }
    };

    return {
      setFlashes: setFlashes,
      getFlashes: getFlashes,
      flash: flash,
      flashErrors: flashErrors,
      flashNotice: flashNotice,
      removeFlash: removeFlash
    };
  }
]);