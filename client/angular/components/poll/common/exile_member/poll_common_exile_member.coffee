Records        = require 'shared/services/records'
Session        = require 'shared/services/session'
AbilityService = require 'shared/services/ability_service'
EventBus       = require 'shared/services/event_bus'

{ registerKeyEvent }  = require 'shared/helpers/keyboard'
{ fieldFromTemplate } = require 'shared/helpers/poll'

angular.module('loomioApp').directive 'pollCommonExileMember', ->
  #scope: {poll: '='}
  templateUrl: 'generated/components/poll/common/exile_member/poll_common_exile_member.html'
  controller: ['$scope', ($scope) ->
    $scope.fetchedMembers = false
    $scope.fetchedGroups = false
    $scope.parentChildGroups = []
    if $scope.poll.additionalData.apd_data1
      $scope.selectablegroupid = $scope.poll.main_group_id
    else
      $scope.selectablegroupid = $scope.poll.groupId
    $scope.selected_template = (id) ->
      $scope.poll.additionalData = {}
      if typeof id == 'string'        
        $scope.poll.additionalData.group_id = parseInt(id.replace("group",""))
        $scope.poll.additionalData.member_type = "group"
      else
        $scope.poll.additionalData.user_id = parseInt(id)
        $scope.poll.additionalData.member_type = "user"

    $scope.fetchGroupMembers = ->
      Records.groups.fetchChildGroups($scope.selectablegroupid).then (members) ->
        if members.status == 200
          $scope.recordGroupMembers = members.members
        else
          $scope.recordGroupMembers = []

        if members.groups.length!=0  
            angular.forEach members.groups, (value,key) ->
              if value.id!=$scope.selectablegroupid
                value.id = 'group'+value.id 
                $scope.parentChildGroups.push(value)
        $scope.fetchedMembers = true
        $scope.fetchedGroups = true

    $scope.fetchGroupMembers()
  ]