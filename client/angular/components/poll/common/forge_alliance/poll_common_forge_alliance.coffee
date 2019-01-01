Records        = require 'shared/services/records'
I18n    = require 'shared/services/i18n'
{ applyLoadingFunction } = require 'shared/helpers/apply'
{ fieldFromTemplate } = require 'shared/helpers/poll'

angular.module('loomioApp').directive 'pollCommonForgeAlliance', ->
  # scope: {poll: '='}
  templateUrl: 'generated/components/poll/common/forge_alliance/poll_common_forge_alliance.html'
  controller: ['$scope', ($scope) ->
    $scope.selectGroupData = {}
    $scope.change_type = (group_id) ->
      $scope.poll.additionalData.group_id = group_id

    Records.groups.getInvitableGroups($scope.poll.groupId).then((res) ->
     
      data = []
      for group in res.groups
        data.push {"id":group.id,"name":group.full_name}
        $scope.groupData = data
    )
    applyLoadingFunction $scope, 'fetchRecords'
  ]
