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
    $scope.powerGroups = [];
    $scope.getChildGroupPower = ->
      Records.groups.fetchMemberChildGroupPower($scope.model.id).then (group_powers) ->
        angular.forEach group_powers.power_groups, (value, key) ->
          $scope.powerGroups[value.id] = value.vote_power
          return

    $scope.fetchChildRecords = ->
      Records.groups.fetchChildGroups($scope.model.id).then (groups) ->
        $scope.recordGroups = groups.groups
        angular.forEach $scope.recordGroups, (value, key) -> 
        #$scope.recordGroups = {"demo":1,"value":2}
          # console.log value
          if $scope.powerGroups[value.id]
            $scope.recordGroups[key]['power'] = $scope.powerGroups[value.id]
          else
            $scope.recordGroups[key]['power'] = "1"
        $scope.fetched = true

    

    applyLoadingFunction $scope, 'fetchChildRecords'
    $scope.getChildGroupPower()
    $scope.fetchChildRecords()
    
    
    # console.log($scope.childGroups)
    # $scope.polls = ->
      # Records.groups.fetchChildGroups($scope.model.id)
    #   console.log(@childGroups)
  ]
