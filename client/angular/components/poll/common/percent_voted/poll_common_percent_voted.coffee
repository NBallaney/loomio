Records = require 'shared/services/records'
I18n    = require 'shared/services/i18n'

angular.module('loomioApp').directive 'pollCommonPercentVoted', ->
  scope: {poll: '='}
  templateUrl: 'generated/components/poll/common/percent_voted/poll_common_percent_voted.html'
  controller: ['$scope', ($scope) ->
    $scope.alliancedecsionvotes= []
    $scope.run = false
    $scope.pollOptionNames = ->
      ['agree', 'abstain', 'disagree', 'block']
    $scope.poll.total_count = 0
    $scope.alliancedecsionvotes= []
    $scope.run = false
    $scope.pollOptionNames = ->
      ['agree', 'abstain', 'disagree', 'block']
    $scope.poll.total_count = 0
    if !$scope.run
      Records.polls.fetchById($scope.poll.key).then((res) ->                   
            angular.forEach $scope.pollOptionNames(), (value, key) -> 
              $scope.alliancedecsionvotes[value] = 0
            angular.forEach res.polls[0].alliance_decision_votes, (value, key) -> 
              $scope.alliancedecsionvotes[value.vote] = $scope.alliancedecsionvotes[value.vote]+1
              $scope.poll.total_count++
            $scope.poll.total_count=$scope.poll.total_count+$scope.poll.stanceCounts
        ) 
      $scope.run = true
      

    # $scope.countFor = (name) ->
    #   $scope.poll.stanceData[name]+$scope.alliancedecsionvotes[name] or 0+$scope.alliancedecsionvotes[name]


    # $scope.percentFor = (name) ->
    #   parseInt(parseFloat($scope.countFor(name)) / parseFloat($scope.poll.stanceCounts+$scope.poll.total_count) * 100)

  ]