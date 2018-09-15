EventBus = require 'shared/services/event_bus'

angular.module('loomioApp').factory 'DelegatesModal', ->
  templateUrl: 'generated/components/delegates/modal/delegates_modal.html'
  controller: ['$scope', 'user', ($scope, user) ->
    $scope.user = user
    EventBus.listen $scope, '$close', $scope.$close
  ]
