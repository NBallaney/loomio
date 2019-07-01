
Records        = require 'shared/services/records'
ModalService   = require 'shared/services/modal_service'
Session       = require 'shared/services/session'

angular.module('loomioApp').directive 'delegatesCard', ->
  scope: {group: '='}
  templateUrl: 'generated/components/delegates/card/delegates_card.html'
  controller: ['$scope', ($scope) ->
    # console.log $scope
    document.cookie = "groupId=; expires=Thu, 01 Jan 1970 00:00:00 UTC;"
    document.cookie = "groupId="+$scope.group.id
    $scope.manageDelegates = ->
      # console.log $scope
      ModalService.open 'DelegatesModal', delegates: ->
        Records.announcements.buildFromModel($scope.group.targetModel())
  ]