Records        = require 'shared/services/records'
I18n    = require 'shared/services/i18n'
{ applyLoadingFunction } = require 'shared/helpers/apply'
{ fieldFromTemplate } = require 'shared/helpers/poll'

angular.module('loomioApp').directive 'pollCommonGroupVotingPower', ->
  # scope: {poll: '='}
  templateUrl: 'generated/components/poll/common/group_voting_power/poll_common_group_voting_power.html'
  controller: ['$scope', ($scope) ->
    $scope.selectGroupData = {}
    if $scope.poll.additionalData.apd_data1
      $scope.selectablegroupid = $scope.poll.main_group_id
    else
      $scope.selectablegroupid = $scope.poll.groupId
      
    $scope.change_type = (group_id) ->
      $scope.poll.additionalData.group_id = group_id

    Records.groups.fetchChildGroups($scope.selectablegroupid).then((res) ->
      data = []
      for group in res.groups
        data.push {"id":group.id,"name":group.full_name}
        $scope.groupData = data
    )
    applyLoadingFunction $scope, 'fetchRecords'
  ]
