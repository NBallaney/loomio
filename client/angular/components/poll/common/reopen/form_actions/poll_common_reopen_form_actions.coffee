moment = require 'moment'

EventBus = require 'shared/services/event_bus.coffee'
ModalService   = require 'shared/services/modal_service.coffee'

{ submitForm } = require 'shared/helpers/form.coffee'

angular.module('loomioApp').directive 'pollCommonReopenFormActions', ->
  scope: {poll: '='}
  templateUrl: 'generated/components/poll/common/reopen/form_actions/poll_common_reopen_form_actions.html'
  controller: ['$scope', ($scope) ->
    $scope.poll.closingAt = moment().add(1, 'day')

    $scope.submit = submitForm $scope, $scope.poll,
      submitFn: $scope.poll.reopen
      flashSuccess: "poll_common_reopen_form.#{$scope.poll.pollType}_reopened"
      successCallback: ->
        EventBus.emit $scope, '$close'

    $scope.showEdit = -> $scope.poll.isProposal() && $scope.poll.resubmissionCount < 3 && $scope.poll.status != 1 && $scope.poll.childPollId == null

    $scope.editPoll = ->
      ModalService.open 'PollCommonEditModal', poll: -> $scope.poll
  ]
