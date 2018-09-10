Records        = require 'shared/services/records'
ModalService   = require 'shared/services/modal_service'

angular.module('loomioApp').directive 'delegatesCard', ->
  scope: {group: '='}
  templateUrl: 'generated/components/delegates/card/delegates_card.html'
  controller: ['$scope', ($scope) ->

    $scope.manageDelegates = ->
      ModalService.open 'DelegatesModal', delegates: ->
        Records.announcements.buildFromModel($scope.group.targetModel())

  ]
