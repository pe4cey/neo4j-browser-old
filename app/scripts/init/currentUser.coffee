angular.module('neo4jApp')
.run [
  'CurrentUser'
  '$rootScope'
  'UsageDataCollectionService'
  (CurrentUser, $rootScope, UDC) ->
    $rootScope.$on 'ntn:authenticated', ->
      $rootScope.currentUser = CurrentUser.instance()
      UDC.connectUser()
]
