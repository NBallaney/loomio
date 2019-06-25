# Records  = require 'shared/services/records'
# EventBus = require 'shared/services/event_bus'
Records        = require 'shared/services/records'
AbilityService = require 'shared/services/ability_service'
ModalService   = require 'shared/services/modal_service'
RecordLoader   = require 'shared/services/record_loader'
I18n           = require 'shared/services/i18n'
Records        = require 'shared/services/records'
AppConfig     = require 'shared/services/app_config'

angular.module('loomioApp').directive 'delegatesChip', ->
  scope: {user: '=', showClose: '=?'}
  # scope: {}
  replace: true
  restrict: 'E'
  templateUrl: 'generated/components/delegates/chip/delegates_chip.html'
  # controller: ['$scope',user, ($scope,user) ->
  controller: ['$scope', ($scope) ->
    $scope.removeRecipient = ->
      EventBus.emit $scope, 'removeRecipient', $scope.user
  ]
