// angular.module('fantasyLeagueFinder.services').factory('Post', [
//   '$log', function($log) {
//     return {
//       instance: void 0
//     };
//   }
// ]);

angular.module('fantasyLeagueFinder.services').factory('Post', [
  '$log', 'railsResourceFactory', 'railsSerializer', function($log, railsResourceFactory, railsSerializer) {
    var resource;
    return resource = railsResourceFactory({
      url: Routes.api_v1_posts_path(),
      name: 'post',
      serializer: railsSerializer(function() {
        return this.nestedAttribute('league');
      })
    });
  }
]);
