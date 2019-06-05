Records = require 'shared/services/records'
I18n    = require 'shared/services/i18n'

angular.module('loomioApp').directive 'pollProposalChartPanel', ->
  scope: {poll: '='}
  templateUrl: 'generated/components/poll/proposal/chart_panel/poll_proposal_chart_panel.html'
  controller: ['$scope', ($scope) ->
    $scope.run = false
    $scope.alliancedecsionvotes= [0,0,0,0]
    $scope.allianceVoteCount = 0
    $scope.stanceCounts = []
    $scope.pollOptionNames = ['agree', 'abstain', 'disagree', 'block']
    if !$scope.run
      Records.polls.fetchById($scope.poll.key).then((res) -> 
          if res.polls[0].alliance_decision_votes 
            angular.forEach res.polls[0].alliance_decision_votes, (value, key) ->
              indexget = $scope.pollOptionNames.indexOf(value.vote)
              $scope.poll.stanceCounts[indexget] +=1
              $scope.alliancedecsionvotes[indexget] =  $scope.alliancedecsionvotes[indexget]+1
              $scope.allianceVoteCount+=1
          $scope.countstance =$scope.poll.stanceCounts 
          $scope.run = true          
      )

    $scope.countFor = (name) ->
      ($scope.poll.stanceData[name] or 0)+$scope.alliancedecsionvotes[$scope.pollOptionNames.indexOf(name)]

    $scope.percentFor = (name) ->
      parseInt(parseFloat($scope.countFor(name)) / parseFloat($scope.poll.stancesCount+$scope.allianceVoteCount) * 100)

    $scope.translationFor = (name) ->
      I18n.t("poll_proposal_options.#{name}")
]