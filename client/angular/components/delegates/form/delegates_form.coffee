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

    $scope.search = (query) ->
      Records.announcements.search(query, $scope.delegates.model).then (users) ->
        utils.parseJSONList(users)

    buildRecipientFromEmail = (email) ->
      email: email
      emailHash: email
      avatarKind: 'mdi-email-outline'
      
    $scope.addRecipient = (recipient) ->
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
