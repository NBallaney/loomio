Records        = require 'shared/services/records'
EventBus = require 'shared/services/event_bus'

{ applyLoadingFunction } = require 'shared/helpers/apply'

angular.module('loomioApp').directive 'delegatesCategories', ->
  scope: {user: '='}
  templateUrl: 'generated/components/delegates/categories/delegates_categories.html'
  controller: ['$scope', ($scope) ->
    $scope.fetchRecords = ->
      Records.pollCategories.fetch()
    applyLoadingFunction $scope, 'fetchRecords'
    $scope.fetchRecords().then((res) ->
      $scope.categories = res.categories
      $scope.categoryChange($scope.categories[0].id)
    )

    $scope.categoryChange = (id) ->
      $scope.user.updateCategory(id)
      EventBus.emit $scope, 'categoryChange', $scope.user

  ]