# { submitForm }    = require 'shared/helpers/form'
{ submitOnEnter } = require 'shared/helpers/keyboard'
EventBus = require 'shared/services/event_bus'
Records        = require 'shared/services/records'

angular.module('loomioApp').directive 'delegatesFormActions', ->
  scope: {user: '='}
  replace: true
  templateUrl: 'generated/components/delegates/form_actions/delegates_form_actions.html'
  controller: ['$scope', '$rootScope', ($scope, $rootScope) ->
    # $scope.submit = -> EventBus.broadcast $scope.$parent, 'assignDelegates', $scope.user
    $scope.submit = () ->
      Records.delegates.assignDelegates($scope.user.id, $scope.user.categoryId, $scope.user.memberr_ids)
      $scope.$emit('$close')
  ]
