Records        = require 'shared/services/records'
AbilityService = require 'shared/services/ability_service'
ModalService   = require 'shared/services/modal_service'

{ submitForm } = require 'shared/helpers/form'

angular.module('loomioApp').directive 'groupCategoryAttributeCard', ->
  scope: {group: '='}
  restrict: 'E'
  templateUrl: 'generated/components/group_category/attribute_card/group_category_attribute_card.html'
  replace: true
  controller: ['$scope', ($scope) ->
    $scope.title = "Category Attribute"
    $scope.category_show = Array()
    $scope.showfun = (category_name) ->
      if !$scope.category_show[category_name]
        $scope.category_show[category_name] = 1
      else
        $scope.category_show[category_name] = 0

    Records.groups.fetchCategoryAttributes($scope.group.id).then (attributes) ->
      $scope.category_attributes = attributes.poll_categories
      for categoryy in attributes.poll_categories
        $scope.category_show[categoryy.category_name] = 0
  ]
