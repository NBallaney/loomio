Records        = require 'shared/services/records'
Session        = require 'shared/services/session'
AbilityService = require 'shared/services/ability_service'
EventBus       = require 'shared/services/event_bus'
utils          = require 'shared/record_store/utils'
{ registerKeyEvent }  = require 'shared/helpers/keyboard'
{ fieldFromTemplate } = require 'shared/helpers/poll'

{ applyLoadingFunction } = require 'shared/helpers/apply'

angular.module('loomioApp').directive 'pollCommonInviteMembers', ->
  #scope: {poll: '='}
  templateUrl: 'generated/components/poll/common/invite_members/poll_common_invite_members.html'
  controller: ['$scope', ($scope) ->
    $scope.fetchedMembers = false
    $scope.poll.additionalData.user_ids = []
    $scope.poll.additionalData.emails = []
    $scope.user_idsArray = []
    $scope.fetchUsers = ->
      Records.delegates.fetchUsers()
    applyLoadingFunction $scope, 'fetchUsers'

    $scope.fetchUsers().then((res) ->
      $scope.userslist = res.users
    )

    $scope.search = (query) ->
      users = $scope.userslist.filter((searchUser) => searchUser.email.toLowerCase().indexOf(query.toLowerCase()) > -1)
      if users.length == 0
        index = $scope.poll.additionalData.emails.indexOf(query);
        if index == -1
          tempdata = {}
          tempdata.id = 0
          tempdata.email = query
          tempdata.name = query
          users.push(tempdata)
      else
        users = $scope.arr_diff(users,$scope.poll.additionalData.user_ids)

      $scope.users = users

    $scope.arr_diff =  (a1, a2) -> 
      diffArray = []
      for element in a1
        if a2.indexOf(element.id) == -1
          diffArray.push(element)
      return diffArray


    $scope.addRecipient = (recipent) ->
      if recipent
        $scope.poll.additionalData.user_ids = []
        $scope.poll.additionalData.emails = []
        if recipent.id == 0
          if $scope.poll.additionalData.emails.indexOf(recipent.email) == -1
            $scope.poll.additionalData.emails.push(recipent.email)
          $scope.query = ''
        else
          if $scope.poll.additionalData.user_ids.indexOf(recipent.id) == -1
            $scope.poll.additionalData.user_ids.push(recipent.id)
            $scope.user_idsArray[recipent.id] = recipent.email
          $scope.query = '' 
            

    $scope.member_rem = (member) ->
      index = $scope.poll.additionalData.user_ids.indexOf(member);
      if index > -1
        $scope.poll.additionalData.user_ids.splice(index, 1);

    $scope.email_rem = (email) ->
      index = $scope.poll.additionalData.emails.indexOf(email);
      if index > -1
        $scope.poll.additionalData.emails.splice(index, 1);


  ]