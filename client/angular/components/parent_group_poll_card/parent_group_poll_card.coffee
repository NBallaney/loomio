Records        = require 'shared/services/records'
AbilityService = require 'shared/services/ability_service'
ModalService   = require 'shared/services/modal_service'
EventBus = require 'shared/services/event_bus'

{ applyLoadingFunction } = require 'shared/helpers/apply'

angular.module('loomioApp').directive 'parentGroupPollCard', ->
  scope: {model: '='}
  templateUrl: 'generated/components/parent_group_poll_card/parent_group_poll_card.html'
  controller: ['$scope', ($scope) ->
    
    $scope.fetchedParent = false

    $scope.fetchParentRecords = ->
      Records.groups.fetchChildGroups($scope.model.id).then (groups) ->
        $scope.recordParentGroups = groups.parent_groups
        #$scope.recordGroups = {"demo":1,"value":2}
        $scope.fetched = true

    applyLoadingFunction $scope, 'fetchParentRecords'
    $scope.fetchParentRecords()
    
    # console.log($scope.childGroups)
    # $scope.polls = ->
      # Records.groups.fetchChildGroups($scope.model.id)
    #   console.log(@childGroups)
  ]
