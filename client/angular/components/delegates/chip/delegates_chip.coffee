Records  = require 'shared/services/records'
EventBus = require 'shared/services/event_bus'

angular.module('loomioApp').directive 'delegatesChip', ->
  scope: {user: '=', showClose: '=?'}
  replace: true
  restrict: 'E'
  templateUrl: 'generated/components/delegates/chip/delegates_chip.html'
  controller: ['$scope',user, ($scope,user) ->
    $scope.removeRecipient = ->
      EventBus.emit $scope, 'removeRecipient', $scope.user
  ]
