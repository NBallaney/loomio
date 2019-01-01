Records        = require 'shared/services/records'
AbilityService = require 'shared/services/ability_service'
ModalService   = require 'shared/services/modal_service'
EventBus = require 'shared/services/event_bus'

{ applyLoadingFunction } = require 'shared/helpers/apply'

angular.module('loomioApp').directive 'childGroupPollsCard', ->
  scope: {model: '='}
  templateUrl: 'generated/components/child_group_polls_card/child_group_polls_card.html'
  controller: ['$scope', ($scope) ->
    
    $scope.fetched = false

    $scope.fetchChildRecords = ->
      Records.groups.fetchChildGroups($scope.model.id).then (groups) ->
        $scope.recordGroups = groups.groups
        #$scope.recordGroups = {"demo":1,"value":2}
        $scope.fetched = true

    applyLoadingFunction $scope, 'fetchChildRecords'
    $scope.fetchChildRecords()
    
    # console.log($scope.childGroups)
    # $scope.polls = ->
      # Records.groups.fetchChildGroups($scope.model.id)
    #   console.log(@childGroups)
  ]
