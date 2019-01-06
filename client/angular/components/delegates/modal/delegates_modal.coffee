EventBus = require 'shared/services/event_bus'
Session       = require 'shared/services/session' 

angular.module('loomioApp').factory 'DelegatesModal', ->
  templateUrl: 'generated/components/delegates/modal/delegates_modal.html'
  controller: ['$scope', ($scope) ->
    $scope.user = Session.user()
    EventBus.listen $scope, '$close', $scope.$close
  ]
