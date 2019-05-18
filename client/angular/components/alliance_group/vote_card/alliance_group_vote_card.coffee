Records        = require 'shared/services/records'
AbilityService = require 'shared/services/ability_service'
ModalService   = require 'shared/services/modal_service'
RecordLoader   = require 'shared/services/record_loader'
I18n           = require 'shared/services/i18n'
Records        = require 'shared/services/records'
AppConfig     = require 'shared/services/app_config'

angular.module('loomioApp').directive 'allianceGroupVoteCard', ->
  scope: {group: '=', pending: "=?"}
  restrict: 'E'
  templateUrl: 'generated/components/alliance_group/vote_card/alliance_group_vote_card.html'
  replace: false
  controller: ['$scope', ($scope) ->
    $scope.vote_status = false
    $scope.alliance_decision_votes = $scope.group.allianceDecisionVotes
    if $scope.alliance_decision_votes.length =0
      $scope.vote_status = true
  ]