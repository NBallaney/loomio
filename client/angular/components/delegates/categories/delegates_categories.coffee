Records        = require 'shared/services/records'
{ applyLoadingFunction } = require 'shared/helpers/apply'
Session       = require 'shared/services/session'

angular.module('loomioApp').directive 'delegatesCategories', ->
  # scope: {delegates: '='}
  templateUrl: 'generated/components/delegates/categories/delegates_categories.html'
  controller: ['$scope', ($scope) ->
    $scope.user = Session.user()
    $scope.fetchRecords = ->
      Records.pollCategories.fetch()
    applyLoadingFunction $scope, 'fetchRecords'
    $scope.fetchRecords().then((res) ->
      $scope.pollCategories = res.categories
    )
]