Records  = require 'shared/services/records'
EventBus = require 'shared/services/event_bus'

angular.module('loomioApp').directive 'delegatesChip', ->
  # scope: {user: '=', showClose: '=?'}
  scope: {}
  replace: true
  restrict: 'E'
  templateUrl: 'generated/components/delegates/chip/delegates_chip.html'
  # controller: ['$scope',user, ($scope,user) ->
  controller: ['$scope', ($scope) ->
    $scope.removeRecipient = ->
      EventBus.emit $scope, 'removeRecipient', $scope.user
  ]
