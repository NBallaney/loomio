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
    Records.groups.fetchCategoryAttributes($scope.group.id).then (attributes) ->
      $scope.category_attributes = attributes.poll_categories
  ]
