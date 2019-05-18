Records        = require 'shared/services/records'
{ applyLoadingFunction } = require 'shared/helpers/apply'

angular.module('loomioApp').directive 'pollCommonCategories', ->
  scope: {poll: '='}
  templateUrl: 'generated/components/poll/common/categories/poll_common_categories.html'
  controller: ['$scope', ($scope) ->
    $scope.category_array = []
    $scope.categroyDropDown = []
   
    $scope.poll.votingpowertype = ''
    $scope.fetchRecords = ->
      Records.groups.getGroupCategories($scope.poll.groupId)
    applyLoadingFunction $scope, 'fetchRecords'
    $scope.fetchRecords().then((res) ->
      angular.forEach res.poll_categories, (value, key) ->
        $scope.category_array[value.id] = value.name
        if value.name != "Alliance Decision"
          $scope.categroyDropDown.push(value)
      
      $scope.pollCategories = res.poll_categories
    )


    $scope.get_data = (field_data) ->
      $scope.poll.additionalData = {}
      $scope.pollCategoryName = $scope.category_array[field_data]
      if $scope.pollCategoryName == 'Increase Voting Power'
        $scope.poll.votingpowertype = '1'
      if $scope.pollCategoryName == 'Decrease Voting Power'
        $scope.poll.votingpowertype = "0"
      $scope.poll.pollCategoryId = field_data 
  ]