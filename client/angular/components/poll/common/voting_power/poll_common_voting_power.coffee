Session        = require 'shared/services/session'
AbilityService = require 'shared/services/ability_service'
EventBus       = require 'shared/services/event_bus'

{ registerKeyEvent }  = require 'shared/helpers/keyboard'
{ fieldFromTemplate } = require 'shared/helpers/poll'

angular.module('loomioApp').directive 'pollCommonVotingPower', ->
  #scope: {poll: '='}
  templateUrl: 'generated/components/poll/common/voting_power/poll_common_voting_power.html'
  controller: ['$scope', ($scope) ->
    $scope.category_array = []
    $scope.voting_power_type = [{"id":"user","name":"Group Member"},{"id":"group","name":"Child Group"}]
    
    $scope.changeType = (field_data) ->
      $scope.poll.additionalData.member_type = field_data
  ]
