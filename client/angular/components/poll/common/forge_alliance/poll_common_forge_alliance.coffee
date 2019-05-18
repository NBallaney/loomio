Records        = require 'shared/services/records'
I18n    = require 'shared/services/i18n'
{ applyLoadingFunction } = require 'shared/helpers/apply'
{ fieldFromTemplate } = require 'shared/helpers/poll'

angular.module('loomioApp').directive 'pollCommonForgeAlliance', ->
  # scope: {poll: '='}
  templateUrl: 'generated/components/poll/common/forge_alliance/poll_common_forge_alliance.html'
  controller: ['$scope', ($scope) ->
    $scope.selectGroupData = {}
    # if !$scope.poll.additionalData.apd_data1
    #   $scope.poll.additionalData = {}
    $scope.poll.additionalData.parent = false
    $scope.groupData = []
    $scope.parentGroupData = []
    $scope.change_type = (group_id) ->
      $scope.poll.additionalData.group_id = group_id
    if $scope.poll.additionalData.apd_data1
      $scope.selectablegroupid = $scope.poll.main_group_id
    else
      $scope.selectablegroupid = $scope.poll.groupId

    # parent_data = []
    # data = []
    Records.groups.getInvitableParentGroups($scope.selectablegroupid).then((res) ->          
      for parentgroup in res.parent_groups
        $scope.parentGroupData.push {"id":parentgroup.id,"name":parentgroup.full_name}            
    )
    # $scope.parentGroupData = parent_data
    
    Records.groups.getInvitableGroups($scope.selectablegroupid).then((res) ->     
      for group in res.groups
        $scope.groupData.push {"id":group.id,"name":group.full_name}          
    )
    # $scope.groupData = data
    # $scope.groupData = data

    # $scope.change_forgetype = () ->
    #   console.log 'data'
    #   $scope.getdata()

    # applyLoadingFunction $scope, 'fetchRecords'
  ]
