angular.module('fantasyLeagueFinder').directive('leagueselect2', [function() {
  var link = function(scope, $el, attr) {
    var leagueOptions = JSON.parse(attr.leagueOptions);
    var options = _.map(leagueOptions, function(o){
      return {id: o, text: o.split(/League$/)[0]}
    });
    $el.val(scope.leagueType);
    $el.select2({
      allowClear: false,
      data: options
    }).on('select2-selecting', function(e){
      scope.updateLeagueType(e.object.id);
    });
  }
  return {
    restrict: 'A',
    link: link
  };
}]);