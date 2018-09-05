{ submitOnEnter } = require 'shared/helpers/keyboard'
{ submitPoll, submitForm }    = require 'shared/helpers/form'
EventBus = require 'shared/services/event_bus.coffee'
AbilityService = require 'shared/services/ability_service'

angular.module('loomioApp').directive 'pollCommonFormActions', ['$rootScope', ($rootScope) ->
  scope: {poll: '='}
  replace: true
  templateUrl: 'generated/components/poll/common/form_actions/poll_common_form_actions.html'
  controller: ['$scope', ($scope) ->

    $scope.submit = submitPoll($scope, $scope.poll, broadcaster: $rootScope)

    $scope.reSubmit = submitForm $scope, $scope.poll,
      submitFn: $scope.poll.resubmit
      flashSuccess: "poll_common_form.resubmitted.#{$scope.poll.pollType}"
      successCallback: ->
        EventBus.emit $scope, '$close'

    $scope.showResubmit = AbilityService.canResubmitPoll($scope.poll)
  ]
]

