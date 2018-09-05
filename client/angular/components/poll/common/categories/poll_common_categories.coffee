Records        = require 'shared/services/records'
{ applyLoadingFunction } = require 'shared/helpers/apply'

angular.module('loomioApp').directive 'pollCommonCategories', ->
  scope: {poll: '='}
  templateUrl: 'generated/components/poll/common/categories/poll_common_categories.html'
  controller: ['$scope', ($scope) ->
    $scope.fetchRecords = ->
      Records.pollCategories.fetch()
    applyLoadingFunction $scope, 'fetchRecords'
    $scope.fetchRecords().then((res) ->
      $scope.pollCategories = res.categories
    )
  ]