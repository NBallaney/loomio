Records        = require 'shared/services/records'
ModalService   = require 'shared/services/modal_service'
I18n           = require 'shared/services/i18n'
EventBus       = require 'shared/services/event_bus'
utils          = require 'shared/record_store/utils'
LmoUrlService  = require 'shared/services/lmo_url_service'
AbilityService = require 'shared/services/ability_service'
FlashService   = require 'shared/services/flash_service'

{ applyLoadingFunction } = require 'shared/helpers/apply'

angular.module('loomioApp').directive 'delegatesForm', ->
  scope: {user: '='}
  templateUrl: 'generated/components/delegates/form/delegates_form.html'
  controller: ['$scope', '$rootScope', ($scope, $rootScope) ->
    
    $scope.recipients = []

    #Fetch users for searching
    $scope.fetchUsers = ->
      Records.delegates.fetchUsers()
    applyLoadingFunction $scope, 'fetchUsers'
    $scope.fetchUsers().then((res) ->
      $scope.users = res.users
    )

    #Fetch all the delegates for the user based on category
    $scope.fetchDelegates = ->
      Records.delegates.fetchByUser($scope.user, {
        'poll_category_id': $scope.user.categoryId 
      })
    applyLoadingFunction $scope, 'fetchDelegates'

    $scope.search = (query) ->
      $scope.users.filter((searchUser) => searchUser.name.toLowerCase().indexOf(query.toLowerCase()) > -1)
      
    $scope.addRecipient = (recipient) ->
      return unless recipient
      if !_.contains(_.pluck($scope.recipients, "key"), recipient.key)
        $scope.recipients.unshift recipient
      $scope.query = ''

    EventBus.listen $scope, 'removeRecipient', (_event, recipient) ->
      _.pull $scope.recipients, recipient

    EventBus.listen $scope.$parent, 'assignDelegates', (_event, recipient) ->
      applyLoadingFunction $scope, 'assignDelegates'
      delegateIds = $scope.recipients.map (delegate) -> delegate.id
      Records.delegates.assignDelegates($scope.user.id, $scope.user.categoryId, delegateIds).then((res) ->
        if res.status == 200
          FlashService.success(res.message)
          $scope.$parent.$close()
      )
    
    EventBus.listen $scope, 'categoryChange', (_event, recipient) ->
      $scope.fetchDelegates().then((res) ->
        $scope.recipients = res.delegates
      )
  ]
