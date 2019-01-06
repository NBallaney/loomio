Records        = require 'shared/services/records'
I18n    = require 'shared/services/i18n'
{ registerKeyEvent }  = require 'shared/helpers/keyboard'
{ fieldFromTemplate } = require 'shared/helpers/poll'

angular.module('loomioApp').directive 'pollCommonSelectVotingPowerType', ->
  #scope: {poll: '='}
  templateUrl: 'generated/components/poll/common/select_voting_power_type/poll_common_select_voting_power_type.html'
  controller: ['$scope', ($scope) ->
    $scope.voting_power_type = [{"id":"member","name":"Group Member"},{"id":"group","name":"New Group"}]
     
    $scope.changeType = (field_data) ->
      #$scope.poll.additionalData.member_type = field_data
      # console.log(field_data)
  ]
