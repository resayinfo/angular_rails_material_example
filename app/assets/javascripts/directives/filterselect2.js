angular.module('fantasyLeagueFinder').directive('filterselect2', ['$q', function($q) {
  var link = function(scope, $el, attr) {
    var options, postGroup, hockeyGroup, footballGroup, postOption, hockeyOption,
        footballOption, slideValuePromise, allGroups,
        deselectAndAddOption, fieldGroupForFieldType, updateOptionWithValue,
        removeOption, removeOptionValue, baseballOptionsArray,
        tempGroup, tempOptions, optionizeParams, postOptionsArray, hockeyOptionsArray,
        footballOptionsArray, postOptions, hockeyOptions, footballOptions, findOptionGroupFor,
        comparators, baseballOptions, baseballGroup;

    postOptions = function(){ return options['Post'] };
    baseballOptions = function(){
      var lt = scope.leagueType;
      if(_.isEmpty(lt) || lt == 'BaseballLeague'){
        return options['Baseball League']
      }else{
        return []
      }
    };
    hockeyOptions = function(){
      var lt = scope.leagueType;
      if(_.isEmpty(lt) || lt == 'HockeyLeague'){
        return options['Hockey League']
      }else{
        return []
      }
    };
    footballOptions = function(){
      var lt = scope.leagueType;
      if(_.isEmpty(lt) || lt == 'FootballLeague'){
        return options['Football League']
      }else{
        return []
      }
    };
    findOptionGroupFor = function(id){
      if(!/^leaguejoin_/.test(id)) return postOptions();

      if(scope.leagueType == 'HockeyLeague'){
          return hockeyOptions();
      }else{
        return footballOptions();
      }
    };
    postGroup = function(){
      return {text: 'Post', children: postOptionsArray()};
    };
    footballGroup = function(){
      var o = footballOptionsArray();
      if(_.isEmpty(o)){
        return null;
      }
      return {text: 'Football League', children: o};
    };
    hockeyGroup = function(){
      var o = hockeyOptionsArray();
      if(_.isEmpty(o)){
        return null;
      }
      return {text: 'Hockey League', children: o};
    };
    baseballGroup = function(){
      var o = baseballOptionsArray();
      if(_.isEmpty(o)){
        return null;
      }
      return {text: 'Baseball League', children: o};
    };
    allGroups = function(){
      return _.compact([postGroup(), footballGroup(), baseballGroup(), hockeyGroup()]);
    };

    // build options from params
    optionizeParams = function(params){
      var o, g;
      return _.compact(_.map(params, function(v,k){
        g = findOptionGroupFor(k);
        o = g[k];
        
        if(_.isObject(o)){
          updateOptionWithValue(
            _.extend(o,{val: v})
          )
          return o.id;
        }
      }));
    }
    slideValuePromise = function(option){
      var selector = ["#filter-value", option.input_type, "input"].join('-')
      var valueFieldGroup = $el.closest('form').find(selector);
      valueFieldGroup.find('.floating-label').text(option.text);
      valueFieldGroup.slideDown();
      return $q(function(resolve, reject) {
        scope.resolveSlidePromise = function(){
          var val = valueFieldGroup.find('.form-control').val();
          if(!scope.isAcceptableValue(val)) return null;

          valueFieldGroup.slideUp(function(){
            resolve(_.extend({}, option, {val: val}));
          });
        }
        scope.rejectSlidePromise = function(){
          valueFieldGroup.slideUp(function(){
            reject(option);
          });
        }
      });
    }
    updateOptionWithValue = function(option){
      var k, new_key;
      k = option.klass;
      if(k != 'Post'){
        scope.leagueType = k;
      }
      option.text = [option.text, option.val].join(' ');
      return option;
    }
    removeOptionValue = function(option){
      var oldText = option.text;
      var match, regex;
      _.every(comparators, function(c){
        regex = new RegExp("^'[\\w| ]+' "+ c +" (.+)$", "i");
        match = oldText.match(regex);
        if(_.isEmpty(match)){
          return true;
        }else{
          match = match[1];
          return false;
        }
      });
      var i = oldText.lastIndexOf(" " + match);
      option.text = oldText.substring(0, i);
      option.val = null;
      return option;
    }
    postOptionsArray = function(){
      return _.map(postOptions(), function(v,k){ return v })
    }
    hockeyOptionsArray = function(){
      return _.map(hockeyOptions(), function(v,k){ return v })
    }
    footballOptionsArray = function(){
      return _.map(footballOptions(), function(v,k){ return v })
    }
    baseballOptionsArray = function(){
      return _.map(baseballOptions(), function(v,k){ return v })
    }
    scope.isAcceptableValue = function(val){
      return !_.isEmpty(val) || _.isNumber(val);
    };
    scope.integerValue = 0;
    scope.booleanValue = 'true';
    scope.decimalValue = 0;
    options = JSON.parse(attr.groupedOptions);
    comparators = JSON.parse(attr.optionComparators);

    $el.val(optionizeParams(scope.selectedFilters));

    $el.select2({
      allowClear: true,
      multiple: true,
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
      initSelection:function (element, callback) {
        var data = [];
        $(element.val().split(",")).each(function () {
          if(!_.isEmpty(this)){
            data.push(findOptionGroupFor(this)[this]);
          }
        });
        callback(data);
      }
    }).on('select2-selecting', function(e){
      e.preventDefault();
      $el.select2('close');
      $el.parent().slideUp(function(){
        var oldOption = e.object;
        slideValuePromise(oldOption).then(function(option){
          var newOption = option;
          scope.leagutType = oldOption.klass;
          var oldId = oldOption.id;
          var g = findOptionGroupFor(oldId);
          g[oldId] = updateOptionWithValue(newOption);
          var allOptions = $el.select2('data').concat([newOption])
          $el.select2('data', allOptions);
          $el.parent().slideDown();
          scope.addFilterParam(newOption);
        }, function(){
          $el.parent().slideDown();
        });
      });
    }).on('select2-removed', function(e){
      var option = e.choice;
      removeOptionValue(option);
      scope.removeFilterParam(e.choice);
    });
  }
  return {
    restrict: 'A',
    link: link
  };
}]);