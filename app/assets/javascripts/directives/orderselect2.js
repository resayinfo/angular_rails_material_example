angular.module('fantasyLeagueFinder').directive('orderselect2', [function() {
  var link = function(scope, $el, attr) {
    var options, postGroup, hockeyGroup, footballGroup, postOptions,
    hockeyOptions, footballOptions, allGroups, baseballOptions, baseballGroup;
    options = JSON.parse(attr.groupedOptions);

    postOptions = function(){
      return options['Post'];
    };
    baseballOptions = function(){
      var lt = scope.leagueType;
      if(_.isEmpty(lt) || lt == 'BaseballLeague'){
        return options['Baseball League'];
      }else{
        return [];
      }
    };
    hockeyOptions = function(){
      var lt = scope.leagueType;
      if(_.isEmpty(lt) || lt == 'HockeyLeague'){
        return options['Hockey League'];
      }else{
        return [];
      }
    };
    footballOptions = function(){
      var lt = scope.leagueType;
      if(_.isEmpty(lt) || lt == 'FootballLeague'){
        return options['Football League'];
      }else{
        return [];
      }
    };
    postGroup = function(){
      var o = postOptions();
      if(_.isEmpty(o)){
        return null;
      }
      return {text: 'Post', children: postOptions()};
    };
    footballGroup = function(){
      var o = footballOptions();
      if(_.isEmpty(o)){
        return null;
      }
      return {text: 'Football League', children: o};
    };
    hockeyGroup = function(){
      var o = hockeyOptions();
      if(_.isEmpty(o)){
        return null;
      }
      return {text: 'Hockey League', children: o};
    };
    baseballGroup = function(){
      var o = baseballOptions();
      if(_.isEmpty(o)){
        return null;
      }
      return {text: 'Baseball League', children: o};
    };
    allGroups = function(){
      return _.compact([postGroup(), footballGroup(), baseballGroup(), hockeyGroup()]);
    };

    $el.val(scope.sortOrder);
    $el.select2({
      allowClear: false,
      data: [postGroup, hockeyGroup, footballGroup],
      query: function (query) {
        var results = _.map(allGroups(), function(g){
          return _.extend({}, g, {
            children: _.compact(_.map(g.children, function(c){
              if(query.matcher(query.term, c.text)){
                return c;
              }
            }))
          });
        })
        query.callback({results: results});
      },
      initSelection: function(element, callback){
        var id = element.val();
        var allOptions = postOptions().concat(hockeyOptions().concat(footballOptions()));
        _.each(allOptions, function(option){
          if(option.id == id){
            callback(option);
          }
        });
      }
    }).on('select2-selecting', function(e){
      scope.updateSortOrder(e.object.id);
    });
  }
  return {
    restrict: 'A',
    link: link
  };
}]);