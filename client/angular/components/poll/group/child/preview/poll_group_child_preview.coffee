AppConfig      = require 'shared/services/app_config'
Session        = require 'shared/services/session'
Records        = require 'shared/services/records'
EventBus       = require 'shared/services/event_bus'
AbilityService = require 'shared/services/ability_service'
LmoUrlService  = require 'shared/services/lmo_url_service'
InboxService   = require 'shared/services/inbox_service'
ModalService   = require 'shared/services/modal_service'

angular.module('loomioApp').directive 'pollGroupChildPreview', ->
  scope: {poll: '=', displayGroupName: '=?'}
  templateUrl: 'generated/components/poll/group/child/preview/poll_group_child_preview.html'
  controller: ['$scope', ($scope) ->
    $scope.imgUrl = ""
    if $scope.poll.logo_file_name != null
      $scope.imgUrl = "/system/groups/logos/000/000/026/medium/#{$scope.poll.logo_file_name}"
    else
      $scope.imgUrl = "/theme/icon.png"


    $scope.showGroupName = ->
      $scope.displayGroupName && $scope.poll.group()
  ]
