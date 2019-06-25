Records        = require 'shared/services/records'
ModalService   = require 'shared/services/modal_service'
I18n           = require 'shared/services/i18n'
EventBus       = require 'shared/services/event_bus'
utils          = require 'shared/record_store/utils'
LmoUrlService  = require 'shared/services/lmo_url_service'
AbilityService = require 'shared/services/ability_service'
FlashService   = require 'shared/services/flash_service'
Session       = require 'shared/services/session' 
{ audiencesFor, audienceValuesFor } = require 'shared/helpers/announcement'

angular.module('loomioApp').directive 'delegatesForm', ->
  # scope: {delegates: '='}
  restrict: 'E'
  templateUrl: 'generated/components/delegates/form/delegates_form.html'
  controller: ['$scope', ($scope) ->
    $scope.delegates = {}
    $scope.audiences      = -> audiencesFor($scope.delegates.model)
    $scope.audienceValues = -> audienceValuesFor($scope.delegates.model)
    user = Session.user()
  
    getCookie =(cname) ->
      name = cname + '='
      decodedCookie = decodeURIComponent(document.cookie)
      ca = decodedCookie.split(';')
      i = 0
      while i < ca.length
        c = ca[i]
        while c.charAt(0) == ' '
          c = c.substring(1)
        if c.indexOf(name) == 0
          return c.substring(name.length, c.length)
        i++
      ''

    $scope.all_members = []

    Records.groups.fetchChildGroups(getCookie('groupId')).then (members) ->
      # console.log members.members
      if members.status == 200
        $scope.recordGroupMembers = members.members
        for value in $scope.recordGroupMembers
        # .each (value) ->
          # console.log value
          $scope.all_members.push(value.email)
          return
      else
        $scope.recordGroupMembers = []
   

    $scope.search = (query) ->
      # console.log user
      if query != ''
      #  && searchUser.id != user.id
        users = $scope.recordGroupMembers.filter((searchUser) => searchUser.email.toLowerCase().indexOf(query.toLowerCase()) > -1 && searchUser.id != user.id )
        # console.log users
        utils.parseJSONList(users)


    buildRecipientFromEmail = (email) ->
      email: email
      emailHash: email
      avatarKind: 'mdi-email-outline'
      
    $scope.addRecipient = (recipient) ->
      if $scope.user.memberr_ids.length < 10
        if user.id != recipient.id
          if recipient
            if $scope.user.memberr_ids.indexOf(recipient.id) < 0
              $scope.user.memberr_ids.push(recipient.id)
              $scope.user.memberr.push(recipient)
      $scope.searchText = ""

    $scope.removeRecipient = (recipient) ->
      index = $scope.user.memberr_ids.indexOf(recipient.id)
      $scope.user.memberr_ids.splice(index, 1)
      angular.forEach $scope.user.memberr, (value, key) ->        
        if value.id == recipient.id
          index1 = $scope.user.memberr.indexOf(recipient)
          $scope.user.memberr.splice(key, 1)


    EventBus.listen $scope, 'removeRecipient', (_event, recipient) ->
      _.pull $scope.user.memberr, recipient

    $scope.loadAudience = (kind) ->
      Records.announcements.fetchAudience($scope.delegates.model, kind).then (data) ->
        _.each _.sortBy(utils.parseJSONList(data), (e) -> e.name || e.email ), $scope.addRecipient
  ]
