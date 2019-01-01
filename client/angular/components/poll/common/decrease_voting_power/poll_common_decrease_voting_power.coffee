Session        = require 'shared/services/session'
AbilityService = require 'shared/services/ability_service'
EventBus       = require 'shared/services/event_bus'

{ registerKeyEvent }  = require 'shared/helpers/keyboard'
{ fieldFromTemplate } = require 'shared/helpers/poll'

angular.module('loomioApp').directive 'pollCommonDecreaseVotingPower', ->
  scope: {poll: '='}
  templateUrl: 'generated/components/poll/common/decrease_voting_power/poll_common_decrease_voting_power.html'
  controller: ['$scope', ($scope) ->
    $scope.category_array = []
  ]
