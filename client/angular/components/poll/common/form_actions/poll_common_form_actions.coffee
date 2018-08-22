{ submitOnEnter } = require 'shared/helpers/keyboard.coffee'
{ submitPoll, submitForm }    = require 'shared/helpers/form.coffee'
EventBus = require 'shared/services/event_bus.coffee'

angular.module('loomioApp').directive 'pollCommonFormActions', ['$rootScope', ($rootScope) ->
  scope: {poll: '='}
  replace: true
  templateUrl: 'generated/components/poll/common/form_actions/poll_common_form_actions.html'
  controller: ['$scope', ($scope) -> 
    if !$scope.poll.isNew() && $scope.poll.isClosed()
      $scope.submit = submitForm $scope, $scope.poll,
      submitFn: $scope.poll.resubmit
      flashSuccess: "poll_common_form.resubmitted.#{$scope.poll.pollType}"
      successCallback: ->
        EventBus.emit $scope, '$close'
    else
      $scope.submit = submitPoll($scope, $scope.poll, broadcaster: $rootScope)
    submitOnEnter $scope
  ]
]
