Records        = require 'shared/services/records'
ModalService   = require 'shared/services/modal_service'
I18n           = require 'shared/services/i18n'
EventBus       = require 'shared/services/event_bus'
utils          = require 'shared/record_store/utils'
LmoUrlService  = require 'shared/services/lmo_url_service'
AbilityService = require 'shared/services/ability_service'
FlashService   = require 'shared/services/flash_service'
{ audiencesFor, audienceValuesFor } = require 'shared/helpers/announcement'

angular.module('loomioApp').directive 'delegatesForm', ->
  # scope: {delegates: '='}
  restrict: 'E'
  templateUrl: 'generated/components/delegates/form/delegates_form.html'
  controller: ['$scope', ($scope) ->
    $scope.delegates = {}
    $scope.delegates.recipients = []
    $scope.audiences      = -> audiencesFor($scope.delegates.model)
    $scope.audienceValues = -> audienceValuesFor($scope.delegates.model)

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
        if members.status == 200
          $scope.recordGroupMembers = members.members
          members.members.each (value) ->
            $scope.all_members.push(value.email)
            return
        else
          $scope.recordGroupMembers = []
   

    $scope.search = (query) ->
      console.log($scope.all_members)
      users = $scope.recordGroupMembers.filter((searchUser) => searchUser.email.toLowerCase().indexOf(query.toLowerCase()) > -1)
      utils.parseJSONList(users)


    buildRecipientFromEmail = (email) ->
      email: email
      emailHash: email
      avatarKind: 'mdi-email-outline'
      
    $scope.addRecipient = (recipient) ->
      console.log(recipient)
      return unless recipient
      _.each recipient.emails, (email) -> $scope.addRecipient buildRecipientFromEmail(email)
      if !recipient.emails && !_.contains(_.pluck($scope.delegates.recipients, "emailHash"), recipient.emailHash)
        $scope.delegates.recipients.unshift recipient
      $scope.selected = undefined
      $scope.query = ''

    EventBus.listen $scope, 'removeRecipient', (_event, recipient) ->
      _.pull $scope.delegates.recipients, recipient

    $scope.loadAudience = (kind) ->
      Records.announcements.fetchAudience($scope.delegates.model, kind).then (data) ->
        _.each _.sortBy(utils.parseJSONList(data), (e) -> e.name || e.email ), $scope.addRecipient
  ]
